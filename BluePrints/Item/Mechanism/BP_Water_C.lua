--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_Water_C
local BP_Water_C = Class({
    "BluePrints.Item.BP_CombatItemBase_C",
})

function BP_Water_C:OnOverlapActor(OtherActor, OtherComponent)
    if UE4.UKismetMathLibrary.ClassIsChildOf(OtherComponent:GetClass(), UInteractiveBaseComponent:StaticClass()) then
        return
    end

    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then
        return
    end
    
    --判断是掉落物不是其他机关
    if not OtherActor.IsCharacter then
        print(_G.LogTag,"Error: FallTrigger 触发到了没有IsCharacter()的东西, 此物不在ActorType范畴内",OtherActor:GetName())
    end
    if OtherActor.IsCharacter and not OtherActor:IsCharacter() and not OtherActor:Cast(UE4.APickupBase) then
        return
    end
    local ResComponent = self:GetNearestComponentTransform(OtherActor:K2_GetActorLocation())
    if not ResComponent then return end
    GameMode:TriggerWaterFallingCallable(
        OtherActor,
        ResComponent:K2_GetComponentToWorld(),
        10000,
        true
    )
end

function BP_Water_C:GetNearestComponentTransform(PlayerLoc)
    local DefaultTransforms = TArray(UChildActorComponent)
    local Mesh = self:K2_GetRootComponent()
    Mesh:GetChildrenComponents(false, DefaultTransforms)
    local MinDis = 999999
    local ResComponent = nil
    for i = 1, DefaultTransforms:Length() do
        local Component = DefaultTransforms:GetRef(i)
        if Component:K2_GetComponentToWorld().Translation.Z > self.PlaneWater:K2_GetComponentToWorld().Translation.Z and Component:GetName() ~= "Heights" then
            local Dis = (PlayerLoc - Component:K2_GetComponentLocation()):Size()
            if Dis < MinDis then
                MinDis = Dis
                ResComponent = Component
            end
        end
    end
    return ResComponent
end

function BP_Water_C:Initialize()
    self.CurHeight = 0
    self.TargetHeight = 0
    self.TimerTimes = 0
    self.TargetIndex = 0
    self.FirstChange = true
end

function BP_Water_C:ReceiveBeginPlay()
    self.Super.ReceiveBeginPlay(self)
    self.OriZ = self.PlaneWater.RelativeLocation.Z
    self.CurHeight = self.OriZ
    self.TargetLocations = {}
    local HeightPoints = TArray(USceneComponent)
    self.Heights:GetChildrenComponents(false, HeightPoints)
    local LuaPoints = {}
    for i, v in pairs(HeightPoints) do
        table.insert(LuaPoints, v)
    end
    table.sort(LuaPoints, function(a, b)
        return a:GetName() < b:GetName()
    end)

    if self.Height and self.Height:Length() > 0 then
        local Sum = 0
        for i = 1, self.Height:Length() do
            Sum = Sum + self.Height[i]
            table.insert(self.TargetLocations, self.OriZ + Sum)
        end
    else
        for i = 1, #LuaPoints do
            table.insert(self.TargetLocations, LuaPoints[i].RelativeLocation.Z)
        end
    end
end

function BP_Water_C:OnEnterState(NowStateId)
    DebugPrint("zwk BP_Water EnterState",NowStateId,self:GetName(),GWorld:GetCurrentTime())
    self.CurHeight = self.PlaneWater.RelativeLocation.Z

    -- 是完成状态，直接设置位置
    for i, v in pairs(self.CompleteStates) do
        if NowStateId == v and self.TargetLocations[i] then
            self:RemoveTimer("ChangeWaterHeight")
            local Location = self.PlaneWater.RelativeLocation
            self.PlaneWater:K2_SetRelativeLocation(UE4.FVector(Location.X, Location.Y, self.TargetLocations[i]),false,nil,false)
            self:EnableTriggerBox()
            return
        end
    end
    -- 不是完成状态，计算应该到达的高度
    local Idx = NowStateId - self.Data.FirstStateId
    if Idx < 0 then
        self:EnableTriggerBox()
        return
    end
    if Idx == 0 then
        local Location = self.PlaneWater.RelativeLocation
        self.PlaneWater:K2_SetRelativeLocation(UE4.FVector(Location.X, Location.Y, self.OriZ),false,nil,false)
        self:EnableTriggerBox()
        return
    end
    -- 如果是回到上一水位，要用之前的那个时间，否则用新的时间
    local TimeIdx = Idx
    if self.TargetIndex > Idx then
        TimeIdx = self.TargetIndex
    end
    self.TargetIndex = Idx
    local NumTime = self.Time:Length()
    if NumTime < TimeIdx then
        DebugPrint("请检查水位机关状态")
        self:EnableTriggerBox()
        return
    end
    if self.TargetLocations[self.TargetIndex] then
        self:BeginChangeWaterHeight(self.Time[TimeIdx], self.TargetLocations[self.TargetIndex] - self.CurHeight)
    end
    self:EnableTriggerBox()
end

function BP_Water_C:EnableTriggerBox()
    if self.FirstChange then
        self.Navbox:SetCollisionEnabled(ECollisionEnabled.QueryOnly)
        self.FirstChange = false
    end
end

function BP_Water_C:BeginChangeWaterHeight(Time, Height)
    if self.EMNavModifierComponent then
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        -- if GameMode then
        --     GameMode.bSkipNavCulling = true
        -- end
        self.EMNavModifierComponent:SetTransformUpdate(false)
        self.EMNavModifierComponent:LockTransformUpdate(true)
    end

    if math.abs(self.CurHeight - Height) < 1.0 then return end
    self:RemoveTimer("ChangeWaterHeight")
    local Times = Time / 0.02
    local ChangeHeight = Height / Times
    Times = math.floor(Times)
    self:AddTimer(0.02, self.ChangeWaterHeight, true, -1, "ChangeWaterHeight", nil, Times, ChangeHeight)
end

function BP_Water_C:ChangeWaterHeight(Times, ChangeHeight)
    self.TimerTimes = self.TimerTimes + 1
    if self.TimerTimes >= Times then
        if self.EMNavModifierComponent then
            self.EMNavModifierComponent:LockTransformUpdate(false)
            self.EMNavModifierComponent:SetTransformUpdate(true)
        end
        self.PlaneWater:K2_AddRelativeLocation(UE4.FVector(0, 0, ChangeHeight),false,nil,false)
        
        self.TimerTimes = 0
        self:RemoveTimer("ChangeWaterHeight")
        self:ChangeState("Manual", 0, self.CompleteStates[self.TargetIndex])
    else
        self.PlaneWater:K2_AddRelativeLocation(UE4.FVector(0, 0, ChangeHeight),false,nil,false)
    end
end

function BP_Water_C:ReceiveEndPlay(EndReason)
    if self.TargetIndex > 0 then
        self:UpdateRegionData("StateId", self.CompleteStates[self.TargetIndex])
    end
    self.Super.ReceiveEndPlay(self, EndReason)
end

return BP_Water_C

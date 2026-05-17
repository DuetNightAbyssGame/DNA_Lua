--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local BP_ResourcePoint_C = Class("BluePrints/Item/CombatProp/BP_CombatPropBase_C")

function BP_ResourcePoint_C:AuthorityInitInfo(Info)
    BP_ResourcePoint_C.Super.AuthorityInitInfo(self,Info)
    -- self.RewardID = self.UnitParams["RewardId"]
    -- self.FirstRefresh = self.UnitParams["FirstRefresh"]
    -- self.RefreshCD = self.UnitParams["RefreshCD"]
    -- self.NeedAttach = self.UnitParams["NeedAttach"]
    -- self.RefreshCD = 3
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    -- GameMode:InitDropRule(self.UnitId, self.RewardID)
end

function BP_ResourcePoint_C:CommonInitInfo(Info)
    BP_ResourcePoint_C.Super.CommonInitInfo(self, Info)
    self.RewardId = self.Data["RewardId"]
    self.FirstRefresh = self.UnitParams["FirstRefresh"]
    self.RefreshCD = self.UnitParams["RefreshCD"]
    self.NeedAttach = self.UnitParams["NeedAttach"]
    self.CountDownTime = 0
    self.ResourceNum = 0
end

function BP_ResourcePoint_C:ClientInitInfo(Info)
    BP_ResourcePoint_C.Super.ClientInitInfo(self,Info)
    self.BillboardComponent:InitItemsBillBoard(self, "BreakableItem")
    self.BillboardComponent:SetWidgetClassByBpPath("WidgetBlueprint'/Game/UI/UI_PC/Common/Common_Circular_Progress_Bar.Common_Circular_Progress_Bar_C'")
    self.BillboardComponent:ShowOrHideBloodBar(false)
    local Height = self.Position.RelativeLocation.Z
    self.BillboardComponent:K2_SetRelativeLocation(UE4.FVector(0, 0, Height), false, nil, false)
    EventManager:AddEvent(EventID.OnItemPickedUp,self,self.ShowCountDown)
end

function BP_ResourcePoint_C:OnActorReady(Info)
    BP_ResourcePoint_C.Super.OnActorReady(self,Info)
    if IsStandAlone(self) or not IsAuthority(self) then
        self:ShowCountDown(self.Eid, self.FirstRefresh)
    end
end

function BP_ResourcePoint_C:CreateReward()
    if not self:CheckAutoCreateReward() then
        return
    end
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local Transform = self.Position:K2_GetComponentToWorld()
    local RewardTransform = FTransform(Transform.Rotation, Transform.Translation)
    if IsStandAlone(self) then
        if GameState and self.RewardID then
            print(_G.LogTag,"LXZ CreateReward", self.RewardId)
            local DropIds = DataMgr.Reward[self.RewardId].Id
            for i, DropId in pairs(DropIds) do
                print(_G.LogTag,"LXZ CreateReward00", DropId)
                local Context = AEventMgr.CreateUnitContext()
                Context.UnitType = "Drop"
                Context.UnitId = DropId
                Context.Loc = RewardTransform.Translation
                Context.IntParams:Add("ParentEid", self.Eid)
                Context.StrParams:Add("ReasonType", CommonConst.RewardReason.Chest)
                if self.NeedAttach then
                    Context:AddObjectParams("AttachActor", self)
                end
                GameState.EventMgr:CreateUnitNew(Context, false)
            end
        end
    else
        if GameState and self.RewardID then
            local DropIds = DataMgr.Reward[self.RewardId].Id
            for i, DropId in pairs(DropIds) do
                local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
                PlayerController:SpawnClientDrop(DropId, 1, CommonConst.RewardReason.Chest, RewardTransform, false, self.Eid)
            end
        end
    end
end

function BP_ResourcePoint_C:ShowCountDown(SourceEid, Time)
    print(_G.LogTag,"LXZ ShowCountDown", SourceEid, self.Eid)
    if SourceEid ~= self.Eid then
        return
    end
    self.BillboardComponent:ShowOrHideBloodBar(true)
    self.CountDownTime = 0
    if not self.CountDownHandle then
        self.CountDownHandle = self:AddTimer(0.1, self.CountDown, true, 0, nil, nil, Time)
    end
end

function BP_ResourcePoint_C:CountDown(Time)
    self.CountDownTime = self.CountDownTime + 0.1
    local RealTime = Time or self.RefreshCD
    -- Time为nil说明是外部拾取触发的倒计时，RealTime为0说明刷新CD为0。
    -- 这种情况下说明已经刷新过，且只刷一次
    if Time == nil and RealTime == 0 then
        self.BillboardComponent:ShowOrHideBloodBar(false)
        self:RemoveTimer(self.CountDownHandle)
        self.CountDownHandle = nil
        self:MarkIsNeedShowCountdownUI(false)
        return
    end
    if self.CountDownTime >= RealTime then
        self.BillboardComponent:ShowOrHideBloodBar(false)
        self:MarkIsNeedShowCountdownUI(false)
        self:ResourcePoint_SpawnReward(self.Eid)
        self:RemoveTimer(self.CountDownHandle)
        self.CountDownHandle = nil
    end
    local Widget = self.BillboardComponent:GetWidget()
    if Widget and Widget.SetPercent then
        Widget:SetPercent(self.CountDownTime/RealTime)
    end

    if self.CountDownTime < RealTime + 0.001 then
        self:MarkIsNeedShowCountdownUI(true)
    end

end

function BP_ResourcePoint_C:ReceiveEndPlay(Reason)
    self.Overridden.ReceiveEndPlay(self,Reason)
    if IsStandAlone(self) or not IsAuthority(self) then
        self:RemoveTimer(self.CountDownHandle)
        EventManager:RemoveEvent(EventID.OnItemPickedUp,self)
    end
end

function BP_ResourcePoint_C:MarkIsNeedShowCountdownUI(bIsNeed)
    if self.BillboardComponent then
        local UI = self.BillboardComponent:GetUserWidgetObject()
        UI.bCanShow = bIsNeed
    end
end

function BP_ResourcePoint_C:ResourcePoint_SpawnReward_Lua(Eid)
    --print(_G.LogTag,"LXZ ResourcePoint_SpawnReward_Lua", Eid)
    if Eid ~= self.Eid then
        return
    end
    self:CreateReward()
end


-- function BP_ResourcePoint_C:ReceiveTick(DeltaSeconds)
-- end

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return BP_ResourcePoint_C

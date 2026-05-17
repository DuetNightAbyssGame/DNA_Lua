--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@type BP_HardBossOpenMechanism_C
local M = Class( "BluePrints/Item/MiniGame/BP_OpenUIMechanism_C")

function M:OpenUI(PlayerId, NextStateId)
    M.Super.OpenUI(self, PlayerId, NextStateId)
    local Controller = UE4.UGameplayStatics.GetPlayerController(self,0)
    local Player = Battle(self):GetEntity(PlayerId)
    self.Camera:SetAspectRatio(Player.CharCameraComponent.AspectRatio)
    self.Camera:SetFieldOfView(Player.CharCameraComponent.FieldOfView)
    Controller:SetViewTargetWithBlend(self, self.OpenBlendTime)
    self.CacheControllerPausedParam = Controller.bShouldPerformFullTickWhenPaused
    Controller.bShouldPerformFullTickWhenPaused = true
    Player.CharSpringArmComponent:SetTickableWhenPaused(true)
    -- self:LoadGameUI(PlayerId)
end

function M:CloseMechanism(PlayerId, IsSuccess)
    local Controller = UE4.UGameplayStatics.GetPlayerController(self,0)
    local Player = Battle(self):GetEntity(PlayerId)
    local PlayerRot = Player:K2_GetActorRotation().Yaw
    Controller:SetControlRotation(FRotator(0,PlayerRot,0))
    Controller:SetViewTargetWithBlend(Player, self.CloseBlendTime, EViewTargetBlendFunction.VTBlend_Linear, 0)
    EventManager:AddEvent(EventID.UnLoadUI, self, self.ResetPauseState)
    M.Super.CloseMechanism(self, PlayerId)
    -- self:UnLoadGameUI(PlayerId)

    -- self:ChangeState("Manual", PlayerId, self.Data.FirstStateId)
end

function M:ResetPauseState(UIName)
    if UIName ~= "HardBossLevelChoose" then
        return
    end
    EventManager:RemoveEvent(EventID.UnLoadUI, self)
    local Controller = UE4.UGameplayStatics.GetPlayerController(self,0)
    Controller.bShouldPerformFullTickWhenPaused = self.CacheControllerPausedParam
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    Player.CharSpringArmComponent:SetTickableWhenPaused(false)
end

function M:GetCanOpen(PlayerEid)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        self.CanOpen = true
        return
    end
    local Battle = Battle(self)
    if not Battle then
        return
    end
    local Player = Battle:GetEntity(PlayerEid)
    if Player and Player:IsDead() then
        self.CanOpen = false
        return
    end
    self.CanOpen = not Avatar:IsInHardBoss()
end

function M:HideMechanism(NeedCallBack, Reason, AlwaysShow)
    --隐藏这个机关，包括关闭碰撞和隐藏actor，有特殊处理的在子类续写
    local CompArray = self:K2_GetComponentsByClass(UShapeComponent:StaticClass())
    for i, v in pairs(CompArray) do
        v:SetCollisionEnabled(0)
    end
    if not AlwaysShow then
        self:SetActorHideTag(Reason, true)
        local MeshCompArray = self:K2_GetComponentsByClass(UMeshComponent:StaticClass())
        for i, v in pairs(MeshCompArray) do
            v:SetCollisionEnabled(0)
        end
    end
    if NeedCallBack then
        EventManager:AddEvent(EventID.ConditionComplete, self, self.ShowMechanismWithCondition)
    end
end

function M:ShowMechanismWithCondition(ShowConditionId)
    if ShowConditionId ~= self.Data.ShowConditionId then
        return
    end
    --显示这个机关，包括开启碰撞和显示actor，有特殊处理的在子类续写
    local CompArray = self:K2_GetComponentsByClass(UShapeComponent:StaticClass())
    for i, v in pairs(CompArray) do
        v:SetCollisionEnabled(1)
    end
    local MeshCompArray = self:K2_GetComponentsByClass(UMeshComponent:StaticClass())
    for i, v in pairs(MeshCompArray) do
        v:SetCollisionEnabled(1)
    end
    EventManager:RemoveEvent(EventID.ConditionComplete, self)
    self:SetActorHideTag("Condition", false)
end

function M:OnActorReady(Info)
    M.Super.OnActorReady(self, Info)
    EventManager:FireEvent(EventID.OnMiniGameCreated,self)
end

function M:ReceiveEndPlay(EndReason)
    M.Super.ReceiveEndPlay(self, EndReason)
    EventManager:RemoveEvent(EventID.ConditionComplete, self)
end

-- function M:RealLoadGameUI()
--     print(_G.LogTag,"LXZ RealLoadGameUI")
--     return UIManager(self):LoadUINew("HardBossLevelChoose",self.UnitParams.HardBossId or 1)
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

return M

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_TouchBomb_C
require "UnLua"
local M = Class({
    "BluePrints.Item.Temple.BP_TouchBombBase_C"
})

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    self.MoveSpeed = self.UnitParams["MoveSpeed"]
    self.ChestInteractiveComponent:InitInteractiveComponent(self.Data.InteractiveId)
end

-- function M:ReceiveBeginPlay()
--     M.Super.ReceiveBeginPlay(self)
--     self.DefaultInteractiveComponent.OnInteractiveTriggerEnter:Add(self, self.TriggerEnter)
--     self.DefaultInteractiveComponent.OnInteractiveTriggerExit:Add(self, self.TriggerExit)
-- end

-- function M:TriggerEnter(PlayerActor)
--     --DebugPrint("zwkk player进来了", PlayerActor:GetName())
--     self:AddTimer(0.2, self.CheckDistance, true, 0, "CheckDistance", false, PlayerActor)
-- end

-- function M:TriggerExit(PlayerActor)
--     --DebugPrint("zwkk player离开了", PlayerActor:GetName())
--     self:RemoveTimer("CheckDistance")
-- end

-- function M:CheckDistance(PlayerActor)
--     if PlayerActor and self.ChestInteractiveComponent then
--         local InRange = self.ChestInteractiveComponent.DistanceCheckComponent(self.ChestInteractiveComponent, PlayerActor, self.ChestInteractiveComponent.InteractiveDistance, false)
--         if InRange and not self.ShouldShowDirection then
--             self.ShouldShowDirection = true
--             self:OnShowEffect()
--         elseif not InRange and self.ShouldShowDirection then
--             self.ShouldShowDirection = false
--             self:OnHideEffect()
--         end
--     end
-- end

function M:ReceiveBeginPlay()
    M.Super.ReceiveBeginPlay(self)
    self.Sphere.OnComponentBeginOverlap:Add(self, self.SphereOverlap)
end

function M:OnActorReady(Info)
    M.Super.OnActorReady(self, Info)
    EventManager:FireEvent(EventID.OnSpawnTempleBomb, self.Eid, self.CreatorId)
end

function M:SphereOverlap(OverlappedComponent, OtherActor, OtherComp,OtherBodyIndex, bFromSweep, SweepResult)
    if self.IsActive then
        self:OnCrash()
        if self.SpecialEffect and self.SpecialEffect > 0 then
            Battle(self):ExecuteSkillEffectWithType(self, self.SpecialEffect, nil, nil, self)
        end
    end
end

function M:ReceiveTick(DeltaSeconds)
    self.Overridden.ReceiveTick(self, DeltaSeconds)
    self:ShowArrowDirection()
    if not self.IsActive then return end
    self:Lanuch(DeltaSeconds)
end

function M:OnCrash()
    if not self.IsActive then
        return
    end
    self:SetActorEnableCollision(false)
    self:SetActorTickEnabled(false)
    self:K2_SetActorLocation(self.Mesh:K2_GetComponentLocation(), false, nil, false)
    self.Mesh:K2_SetRelativeLocation(FVector(0, 0, 0), false, nil, false)
    self:CrashEffect()
    --self:EMActorDestroy(EDestroyReason.MechanismDead)
    self:OnEnd()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        GameMode:TriggerGameModeEvent("OnBallBomb", self.UnitId, self.OwnerManualId or 0)
    end
    self.IsActive = false
end

function M:CrashEffect()
    if self.PlayerEffect and self.PlayerEffect > 0 then
        --self.Super.PropUseSkill(self, self.PlayerEffect, self)
        Battle(self):ExecuteSkillEffectWithType(self, self.PlayerEffect, nil, nil, self)
    end
    if self.MonEffect and self.MonEffect > 0 then
        --self.Super.PropUseSkill(self, self.MonEffect, self)
        Battle(self):ExecuteSkillEffectWithType(self, self.MonEffect, nil, nil, self)
    end
    -- if self.SpecialEffect and self.SpecialEffect > 0 then
    --     --self.Super.PropUseSkill(self, self.MonEffect, self)
    --     Battle(self):ExecuteSkillEffectWithType(self, self.SpecialEffect, nil, nil, self)
    -- end
end

function M:GetCanOpen()
    if self.Player and self.Player.bHasAttachBomb then
        self.CanOpen = false
        return
    end
    self.CanOpen = true
end

function M:ActiveCombat()
    M.Super.ActiveCombat(self)
    self.ChestInteractiveComponent.bCanUsed = false
    self.Dir = self:GetDirection()
    self:OnInteractived()

    local Actors = self.Sphere:GetOverlappingActors()
    if Actors:Length() > 0 then
        self:OnCrash()
        if self.SpecialEffect and self.SpecialEffect > 0 then
            Battle(self):ExecuteSkillEffectWithType(self, self.SpecialEffect, nil, nil, self)
        end
    end
end

function M:Lanuch(DeltaSeconds)
    if self.Dir then
        local Offset = self.Dir * self.MoveSpeed * DeltaSeconds
        -- 添加移动启用一下sweep，不然会穿怪穿墙
        local HitResult = UE.FHitResult()
        self.Mesh:K2_AddWorldOffset(Offset, true, HitResult, false)
        if HitResult.bBlockingHit then
            DebugPrint("zwk 撞到物体停下来", HitResult.Actor:GetName())
            self:OnCrash()
            if HitResult.Actor and HitResult.Actor.IsPureMonster and HitResult.Actor:IsPureMonster() then
                if self.SpecialEffect and self.SpecialEffect > 0 then
                    Battle(self):ExecuteSkillEffectWithType(self, self.SpecialEffect, nil, nil, self)
                end
            end
        end
    end
end

function M:PreAttach(Player)
    if Player.bHasAttachBomb then
        self:ChangeState("Manual", 0, self.Data.FirstStateId)
        return false
    end
    Player.bHasAttachBomb = true
    EventManager:FireEvent(EventID.OnPlayerGetAttachBomb)
    self:OnHideEffect()
    self:OnInteractived()
    return true
end

function M:EndAttach(Player)
    Player.bHasAttachBomb = false
    EventManager:FireEvent(EventID.OnPlayerEndAttachBomb)
end

function M:OnPadLanuch(Dir)
    -- 发射台交互后调用
    self.Dir = Dir
    self.Dir:Normalize()
    local Actors = self.Sphere:GetOverlappingActors()
    if Actors:Length() > 0 then
        self:OnCrash()
    end
    self.IsActive = true
end

function M:ChangeToNormalState()
    self:ChangeState("Manual", 0, self.NormalState)
end

function M:ChangeToForbiddenState()
    self:ChangeState("Manual", 0, self.ForbiddenState)
end

return M

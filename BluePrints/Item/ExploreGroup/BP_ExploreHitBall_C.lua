--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_ExploreHitBall_C
local M = Class("BluePrints/Item/CombatProp/BP_CombatPropBase_C")

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self, Info)
    self.DeadFXId = self.UnitParams["DeadFXId"] or 209
    self.DeadDurationTime = self.UnitParams["DeadDurationTime"] or 0
end

function M:ShowDeath()
    local FXObject = self.FXComponent:PlayEffectByIDParams(self.DeadFXId, {NotAttached = true})
end

function M:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
    M.Super.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
    self.Mesh:SetVisibility(false, false)
    self:AddTimer(self.DeadDurationTime, function() 
        self:EMActorDestroy(EDestroyReason.MechanismDead) 
    end)
end

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return M

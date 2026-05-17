--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type BP_FortMechanism_C
local M = Class({
    "BluePrints/Item/CombatProp/BP_CombatPropBase_C",
})

function M:OnActiveStateChange()
    self.Super.OnActiveStateChange(self)
    if self.IsActive then
        self:SetActorTickEnabled(true)
    else
        self:FindTarget()
        self:SetActorTickEnabled(false)
    end
end

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    -- self.RotatingMovement.RotationRate.Yaw = self.RotateSpeed
    self.AttackRange = self.UnitParams["AttackRange"]
    self.AttackCD = self.UnitParams["AttackCD"]
    if self.UnitParams["AttackSkillEffect"] then
        for i,v in pairs(self.UnitParams["AttackSkillEffect"]) do
            self.AttackSkillEffects:Add(v)
        end
    end
end

function M:OnTargetCanBeAttack(Target)
    if self.bCDOver then
        for i, Id in pairs(self.AttackSkillEffects) do
            self:PropUseSkill(Id, Target)
        end
        self.bCDOver = false
        self:AddTimer(self.AttackCD, self.ResetCD)
    end
    self.Overridden.OnTargetCanBeAttack(self, Target)
    
end

function M:ResetCD()
    self.bCDOver = true
end

function M:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
    M.Super.OnDead(self,KillMineRoleEid, KillMineSkillId, DeathReason)  
    self:SetActorTickEnabled(false)
    self:EMActorDestroy(EDestroyReason.MechanismDead)
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

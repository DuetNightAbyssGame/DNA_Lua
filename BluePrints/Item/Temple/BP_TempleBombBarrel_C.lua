--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_TempleBombBarrel_C
require "UnLua"

local M = Class({
    "BluePrints/Item/CombatProp/BP_BombBarrel_C",
})

function M:AuthorityInitInfo(Info)
    M.Super.AuthorityInitInfo(self,Info)

    self.SkillEffect_Monster = self.UnitParams["SkillEffect_Monster"]
    self.SkillEffect_Player = self.UnitParams["SkillEffect_Player"]
    self.ActiveRange = self.UnitParams["ActiveRange"]
end

function M:OnBomb()
    if self.SkillEffect_Monster then
        self.PropUseSkill(self,self.SkillEffect_Monster,self)
    end
    if self.SkillEffect_Player then
        self.PropUseSkill(self,self.SkillEffect_Player,self)
    end
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

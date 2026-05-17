--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_FeinaEventChangeColorBase_C
require "UnLua"
local M = Class("BluePrints/Item/CombatProp/BP_CombatPropBase_C")

function M:OnBreakCountDown(SourceEid)
    M.Super.OnBreakCountDown(self, SourceEid)
    self.Overridden.OnBreakCountDown(self, SourceEid)
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

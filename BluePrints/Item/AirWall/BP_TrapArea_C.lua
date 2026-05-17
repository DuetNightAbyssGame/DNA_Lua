--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_TrapArea_C
require "UnLua"

local M = Class({
    "BluePrints/Item/AirWall/BP_FieldCreature_C",
})

function M:OnBreakCountDown(SourceEid)
    M.Super.OnBreakCountDown(self, SourceEid)
    self:ChangeState("Hit", SourceEid)
end

-- function M:CommonInitInfo(Info)
--     M.Super.CommonInitInfo(self, Info)
--     -- Battle(self):AddBuffToTarget(self, self, 5000017, -1, nil, nil)
-- end

function M:ClientInitInfo(Info)
    M.Super.ClientInitInfo(self, Info)
    self.BillboardComponent.IsInit = true
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

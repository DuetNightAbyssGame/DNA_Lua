--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type BP_DongGuoRotateCenter_C
local M = Class({
    "BluePrints/Item/CombatProp/BP_CombatPropBase_C",
})

-- function M:ReceiveBeginPlay()
--     self.CanOpen = true
-- end

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    if self.UnitParams["RotateAxis"] == "X" then
        self.RotateAxis = 0
    elseif self.UnitParams["RotateAxis"] == "Y" then
        self.RotateAxis = 1
    elseif self.UnitParams["RotateAxis"] == "Z" then
        self.RotateAxis = 2
    end
    --self.RotateAxis = 0
end

function M:OnBreakCountDown(SourceEid)
    if self.bInRotate or not self.IsActive then
        return
    end
    local RotateSucc = self:TryRotate()
    if RotateSucc then
        self.bInRotate = true
        self:ChangeState("Hit", SourceEid)
    end
end

-- function M:UserConstructionScript()
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

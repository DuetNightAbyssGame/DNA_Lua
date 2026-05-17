--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_SweetPlantBreakable_C
require "UnLua"
local M = Class({
    "BluePrints/Item/CombatProp/BP_CombatPropBase_C",
})

function M:OnBreakCountDown(SourceEid)
    M.Super.OnBreakCountDown(self, SourceEid)
    self:ChangeState("Hit", SourceEid)
end

function M:ActiveCombat()
    M.Super.ActiveCombat(self)
    self:OnActive()
    -- self:AddTimer(self.ActiveTime, self.OnActiveTimeEnd, false, 0)
end

function M:DeActiveCombat()
    M.Super.DeActiveCombat(self)
    self:OnDeActive()
end

-- function M:OnActiveTimeEnd()
--     self:ChangeState("Manual", 0, self.DeActiveStateId)
-- end

function M:OnEnterState(NowStateId)
    self.Overridden.OnEnterState(self, NowStateId)

    if NowStateId == self.CompleteStateId then
        self:OnComplete()
    end
end

return M

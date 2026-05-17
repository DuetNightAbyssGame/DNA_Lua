--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type BP_LimitExploreStart_C
local M = Class("BluePrints/Item/Chest/BP_MechanismBase_C")

function M:GetCanOpen()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    self.CanOpen = (GameState.ActiveLimitTimeExploreGroup == 0)
end

return M

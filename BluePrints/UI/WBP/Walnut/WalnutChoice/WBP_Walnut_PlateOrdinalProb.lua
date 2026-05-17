--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Walnut_PlateOrdinalProb_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:SetProbPercent(Percent)
    self.Num_Porb:SetText(string.format("%.2f", Percent * 100))
end

return M

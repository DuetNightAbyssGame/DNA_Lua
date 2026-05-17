-- WBP_Activity_AutoChess_EquipmentEffect

require "UnLua"

---@type WBP_Activity_AutoChess_EquipmentEffect
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:OnListItemObjectSet(Content)
    self.Text_Name:SetText(Content.Text_Name)
    self.Text_Desc:SetText(Content.Text_Desc)
end

return M

-- WBP_Com_Dialog_PasswordNumber.lua
require "UnLua"

local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---设置显示状态
function M:SetState(Mode, Char)
    if not self.WS_Type then return end
    
    if Mode == "Empty" then
        self.WS_Type:SetActiveWidgetIndex(0)
        if self.Text_Input then self.Text_Input:SetText("") end
    elseif Mode == "Masked" then
        self.WS_Type:SetActiveWidgetIndex(1)
    elseif Mode == "Visible" then
        self.WS_Type:SetActiveWidgetIndex(0)
        if self.Text_Input then self.Text_Input:SetText(Char or "") end
    end
end

return M
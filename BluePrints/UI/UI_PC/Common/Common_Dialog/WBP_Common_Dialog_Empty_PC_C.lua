

require "UnLua"

---@type WBP_Common_Dialog_Empty_PC_C
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

---@field FirstTabText string @Tab1标题
function M:PreInitContent(Params, PopupData, Owner) 
    self.Super.PreInitContent(self, Params, PopupData, Owner)
    self.Owner = Owner
    self.Text_Dummy_Status:SetText(Params.DummyStatusText)
    
end

return M
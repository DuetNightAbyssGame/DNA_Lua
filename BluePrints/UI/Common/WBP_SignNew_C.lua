--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SignNew_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
    local Language = CommonConst.SystemLanguage
    local text
    if Language == CommonConst.SystemLanguages.CN then
        text = DataMgr.TextMap_ContentEN["UI_NEW"].ContentEN
    else
        text = GText("UI_NEW")
    end
    self.Text_New:SetText(text)
end

return M

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Abyss_DialogReview_Tip_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end
function M:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)
    self.Text_Tips:SetText(GText("Abyss_SeasonReview_Tips1"))
end

return M

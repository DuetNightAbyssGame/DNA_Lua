--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Item_Show_AscendItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnListItemObjectSet(Content)
    Content.Entry = self
    self.Content = Content
    if self.Content.Light then
        self.Switcher_Star:SetActiveWidgetIndex(2)
    else
        self.Switcher_Star:SetActiveWidgetIndex(1)
    end
end

return M

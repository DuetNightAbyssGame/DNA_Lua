--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Story_Review_GamePadBtn_C
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

function M:OnFocusLost(InFocusEvent)
    self.ParentWidget:FocusLost()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self.ParentWidget:FocusReceived()
    return UE4.UWidgetBlueprintLibrary.Handled()
end


return M

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_PersonalInfo_Edit_TipsItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
-- function M:Initialize(Initializer)
-- end
---设置item被聚焦时的回调
function M:SetFocusCallback(callback)
    self._callback = callback
end
function M:OnAddedToFocusPath()
    if self._callback then
        self._callback(self)
    end

    return UIUtils.Handled
end
-- function M:Construct()
-- end

-- function M:Tick(MyGeometry, InDeltaTime)
-- end

-- function M:Destruct()
-- end

return M

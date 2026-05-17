--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_AutoChess_UnlockCondition_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local LevelState = {
    Pass = 0, --已首通
    UnPass = 1, --解锁未首通
    UnLock = 2, --未解锁
}

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--ends

--function M:Destruct()
--end
function M:OnListItemObjectSet(Content)
    Content.UI = self
    if Content.success then
        self.WS_Icon:SetActiveWidgetIndex(1)
    else
        self.WS_Icon:SetActiveWidgetIndex(0)
    end
    self.Text_Condition:SetText(Content.Text)
end

return M

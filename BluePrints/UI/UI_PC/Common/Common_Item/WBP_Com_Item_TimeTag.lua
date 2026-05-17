--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_Item_TimeTag_C
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

function M:SetUpTimeTag(TimeTagList)
    for _, TimeTagUI in pairs(self.HB_TimeTag:GetAllChildren()) do
        TimeTagUI:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    for i,TimeTag in ipairs(TimeTagList) do
        local TimeTagUI = self.HB_TimeTag:GetChildAt(i-1)
        TimeTagUI:SetVisibility(UIConst.VisibilityOp.Visible)
        TimeTagUI.WS_DayAndNight:SetActiveWidgetIndex(TimeTag-1)
    end
end


return M

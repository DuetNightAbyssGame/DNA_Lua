--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_BulletCancel_M_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

M._components = {
    "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent",
}

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Btn_Cancel.OnClicked:Add(self, self.OnBtnClicked)
end


function M:InitNormalText()
    self.TextCancel:SetText(GText("UI_CustomLayout_WidgetName14"))
end

function M:InitSlideText()
    self.TextCancel:SetText(GText("UI_CustomLayout_WidgetName15"))
end

function M:OnBtnClicked()
    self.OwnerPanel:CancelBulletJump()
end

AssembleComponents(M)

return M

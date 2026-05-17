--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Theater_Btn_item01_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Construct()
    self.Btn_item.OnClicked:Add(self, self.OnBtnItemClicked)
    self.Btn_Item.OnHovered:Add(self, self.OnBtnItemHovered)
    self.Btn_Item.OnUnhovered:Add(self, self.OnBtnItemUnhovered)
end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.ParentWidget = Content.ParentWidget
    self.Text_num_nor:SetText(Content.Index)
    self.Content.UI = self
    if Content.IsLock then
        self:PlayAnimation(self.Lock)
    else
        self:PlayAnimation(self.Lock_Normal)
    end
    if Content.IsDone then
        self.panel_check:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.panel_check:SetVisibility(ESlateVisibility.Collapsed)
    end
    if Content.IsSelected then
        self:PlayAnimation(self.Click)
        self:SetFocus()
    end
end

function M:OnBtnItemHovered()
    if self.ParentWidget.SelectedIndex == self.Content.Index then
        return
    end
    if (UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad) then
        self:OnBtnItemClicked()
        return
    end
    self:PlayAnimation(self.Hover)
end

function M:OnBtnItemUnhovered()
    if self.ParentWidget.SelectedIndex == self.Content.Index then
        return
    end
    self:PlayAnimation(self.Unhover)
end

function M:OnBtnItemClicked()
    self.ParentWidget:OnBtnItemClicked(self.Content.Index)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
end

function M:StopAllRegularAnimations()
    self:StopAnimation(self.Hover)
    self:StopAnimation(self.Unhover)
    self:StopAnimation(self.Click)
    self:StopAnimation(self.Normal)
end

return M

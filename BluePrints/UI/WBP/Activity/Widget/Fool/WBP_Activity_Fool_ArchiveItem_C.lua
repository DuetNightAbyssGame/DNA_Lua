require "UnLua"

local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
    self.Btn_Click.OnClicked:Add(self, self.OnButonClicked)
    self.Btn_Click.OnHovered:Add(self, self.OnButonHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnButonUnhovered)
    self.Btn_Click.OnPressed:Add(self, self.OnButonPressed)
end

function M:Destruct()
    self.Btn_Click.OnClicked:Clear()
    self.Btn_Click.OnHovered:Clear()
    self.Btn_Click.OnUnhovered:Clear()
    self.Btn_Click.OnPressed:Clear()
end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.ParentWidget = Content.ParentWidget
    self.Content.SelfWidget = self
    self:InitIcon()
    self:InitInteractivity()
    self:InitIsLock()
    -- 滑动时恢复动画
    if (self.Content.IsHUDChange) and self.ParentWidget.LastClickedItem == Content then
        self:PlayAnimation(self.Click)
    else
        self:PlayAnimation(self.Normal)
    end

    if (self.Content.IsHUDChange) and (not self.Content.Islock) then
        self:SetNavigationRuleBase(UE4.EUINavigation.Up, EUINavigationRule.Stop)
        self:SetNavigationRuleBase(UE4.EUINavigation.Down, EUINavigationRule.Stop)
        self:SetNavigationRuleCustom(EUINavigation.Left, {self, self.HandleHUDNavigationLeft})
        self:SetNavigationRuleCustom(EUINavigation.Right, {self, self.HandleHUDNavigationRight})
    end
end

function M:InitIcon()
    if not self.Content.IconPath then
        return
    end
    local Texture = LoadObject(self.Content.IconPath)
    self.Image_Icon:SetBrushFromTexture(Texture)
end

function M:InitInteractivity()
    if self.Content.NotInteractive then
        self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
end

function M:InitIsLock()
    if self.Content.Islock then
        self.Image_Icon:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Item_CommonBG.Image_Empty:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Item_CommonBG.Image_Normal:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.Image_Icon:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Item_CommonBG.Image_Empty:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Item_CommonBG.Image_Normal:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
end

function M:BP_OnEntryReleased()
    self.Content.SelfWidget = nil
    self:PlayAnimation(self.Normal)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.Content.IsHUDChange then
        if self.ParentWidget and self.ParentWidget.SelectFirstItem then
            self.ParentWidget:OnListItemClick(self.Content)
            self.ParentWidget.SelectFirstItem = nil
        end
        self.Btn_Click:SetFocus()
    end
    return UIUtils.Handled
end

function M:OnButonClicked()
    if self.Content.Islock then
        return
    end
    if self.ParentWidget and self.ParentWidget.OnListItemClick then
        self.ParentWidget:OnListItemClick(self.Content)
        return
    end
    self:PlayAnimation(self.Click)
end

function M:OnButonHovered()
    if self.Content.Islock or (self.ParentWidget.LastClickedItem == self.Content) then
        return
    end
    self:StopAnimation(self.UnHover)
    self:PlayAnimation(self.Hover)
end

function M:OnButonUnhovered()
    if self.Content.Islock or (self.ParentWidget.LastClickedItem == self.Content) then
        return
    end
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.UnHover)
end

function M:OnButonPressed()
    if self.Content.Islock or (self.ParentWidget.LastClickedItem == self.Content) then
        return
    end
    self:PlayAnimation(self.Press)
end

-- Begin HUD 切换变身导航设置
function M:HandleHUDNavigationLeft()
    if (not self.Content.IsHUDChange) or (not self.Content.Index) then
        return self
    end

    if self.Content.Index < 2 then
        return self
    end

    local Parent = self.ParentWidget
    if not Parent then
        return self
    end

    Parent.List_Change:NavigateToIndex(self.Content.Index - 2)
    return Parent.UnLockedContents[self.Content.Index-1].SelfWidget
end

function M:HandleHUDNavigationRight()
    if (not self.Content.IsHUDChange) or (not self.Content.Index) then
        return self
    end

    local Parent = self.ParentWidget
    if not Parent then
        return self
    end

    local MaxIndex = Parent.ValidItemCount - 1
    if self.Content.Index > MaxIndex then
        return self
    end

    Parent.List_Change:NavigateToIndex(self.Content.Index)
    return Parent.UnLockedContents[self.Content.Index + 1].SelfWidget
end

-- End HUD 切换变身导航设置

return M
--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_CategoryItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    Content.UI = self
    self:SetIcon(Content.Icon)
    self:FlushAnimations()
    self.IsSelected = Content.IsSelected
    self:SetIsSelected(Content.IsSelected)
    self:ShowRecommend(Content.bShowRecommend)
    self.Owner = Content.Owner

    self:SetNavigationRuleCustom(EUINavigation.Up, {self, self.OnListItemNavigation})
    self:SetNavigationRuleCustom(EUINavigation.Down, {self, self.OnListItemNavigation})
end

function M:BP_OnEntryReleased()
    if(self.Content)then
        self.Content.UI = nil
    end
end

function M:SetIcon(Icon)
    if(type(Icon) == "string")then
        self.Image_Attribute:SetBrushResourceObject(LoadObject(Icon))
    else
        self.Image_Attribute:SetBrushResourceObject(Icon)
    end
end

function M:ShowRecommend(bShowRecommend)
    if(bShowRecommend)then
        if self.Tag_Recommend then
            self.Tag_Recommend:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
    else
        if self.Tag_Recommend then
            self.Tag_Recommend:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
end

--region 交互事件/动效

function M:SetIsSelected(IsSelected)
    self.IsSelected = IsSelected
    if(IsSelected)then
        self:StopAllAnimations()
        self:PlayAnimation(self.Click)
    else
        self:StopAnimation(self.Click)
        self:PlayAnimation(self.Normal)
    end
end

function M:OnMouseEnter(MyGeometry,MouseEvent)
    if(self.IsSelected)then
        return
    end
    self:StopAnimation(self.UnHover)
    self:PlayAnimation(self.Hover)
end

function M:OnMouseLeave(MouseEvent)
    if(self.IsSelected)then
        return
    end
    self:StopAnimation(self.Press)
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.UnHover)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    if(self.IsSelected)then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    self:PlayAnimation(self.Press)
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnMouseButtonUp(MyGeometry,MouseEvent)
    if(self.IsSelected)then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    if(self:IsHovered())then
        self:OnMouseEnter()
    else
        self:PlayAnimation(self.Normal)
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnTouchStarted(MyGeometry, InTouchEvent)
    return UIUtils.Unhandled
    --return self:OnMouseButtonDown(MyGeometry, InTouchEvent)
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
    return UIUtils.Unhandled
    --return self:OnMouseButtonUp(MyGeometry, InTouchEvent)
end

function M:OnFocusReceived()
    if self.Owner then
        if self.Owner.IsFromListContent and self.Owner.CurFilterItem and self.Owner.CurFilterItem == self.Content then
            self.Owner.CurFilterItem.UI:SetFocus()
            self.Owner.EMListView_Filter:BP_SetSelectedItem(self.Owner.CurFilterItem)
            self.Owner.IsFromListContent = false
        else
            self.Owner.CurFilterItem = self.Content
            self.Owner:OnFilterListItemClicked(self.Content)
        end
    end
    return UIUtils.Unhandled
end

function M:OnListItemNavigation(NavigationDirection)
    local CurIndex = self.Content.Index
    if not (self.Owner or CurIndex) then
        return self
    end

    if (NavigationDirection == EUINavigation.Up) then
        self.Owner.EMListView_Filter:NavigateToIndex(CurIndex - 1)
    elseif(NavigationDirection == EUINavigation.Down) then
        self.Owner.EMListView_Filter:NavigateToIndex(CurIndex + 1)
    end

    return self
end

--endregion 交互事件/动效

return M

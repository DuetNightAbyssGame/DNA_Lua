--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_SoloTreasure_ListBagItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Construct()
    self.Btn_Click.OnClicked:Add(self, self.OnClicked)
end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.Content.UI = self
    self:Init(Content)
end

function M:Init(Content)
    if Content.IsEmpty then
        self.WS_Type:SetActiveWidgetIndex(1)
        return
    end
    self.Text_Cost:SetText(Content.Price)
    self.Text_Num:SetText(Content.Index)
    local BagIndex = string.format("%02d", tonumber(Content.Index) or 1)
    local BagIconName = string.format("Texture2D'/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_BagSign%s.T_Activity_SoloTreasure_BagSign%s'", BagIndex, BagIndex)
    local BagIcon = LoadObject(BagIconName)
    if BagIcon then
        self.Image_57:SetBrushFromTexture(BagIcon)
    end
    self.Text_Bag:SetText(GText(Content.Name))
    self:PlayAnimation(self.Normal)
    self:CheckCondition()
    if self.Content.IsSelected then
        self:SetSelected(true)
    end
    if self.Content.IsChosen then
        self:SetIsChosen(true)
    end
    if self.Content.IsLock then
        self:PlayAnimation(self.Forbidden)
        self.Panel_Lock:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self:PlayAnimation(self.Normal)
        self.Panel_Lock:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:CheckCondition()
    if self.Content.Condition then
        local Avatar = GWorld:GetAvatar()
        if (ConditionUtils.CheckCondition(Avatar, self.Content.Condition) == false) then
            self.Content.IsLock = true
        else
            self.Content.IsLock = false
        end
    else
        self.Content.IsLock = false
    end
end

function M:OnClicked()
    if self.IsSelected then
        return
    end
    self.Content.ParentWidget:OnSelectBag(self.Content)
    self:SetSelected(true)
end

function M:SetIsChosen(IsChosen)
    if IsChosen then
        local LastChosenBagItemUI = self.Content.ParentWidget.LastChosenBagItemUI
        if LastChosenBagItemUI then
            LastChosenBagItemUI:SetIsChosen(false)
        end
        self.Content.ParentWidget.LastChosenBagItemUI = self
        self.Panel_Select:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.IsChosen = true
        self.Content.IsChosen = true
    else
        self.Panel_Select:SetVisibility(ESlateVisibility.Collapsed)
        self.IsChosen = false
        self.Content.IsChosen = false
    end
end

function M:SetSelected(IsSelected)
    if IsSelected then
        local LastSelectedBagItemUI = self.Content.ParentWidget.LastSelectedBagItemUI
        if LastSelectedBagItemUI then
            LastSelectedBagItemUI:SetSelected(false)
        end
        self.Content.ParentWidget.LastSelectedBagItemUI = self
        self.Content.ParentWidget.LastSelectedBagItemUIIndex = self.Content.Index
        self.IsSelected = true
        self.Content.IsSelected = true
        self:PlayAnimation(self.Select_In)
    else
        self.IsSelected = false
        self.Content.IsSelected = false
        self:PlayAnimation(self.Select_Out)
    end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:OnClicked()
        return nil
    end
    return nil
end

return M

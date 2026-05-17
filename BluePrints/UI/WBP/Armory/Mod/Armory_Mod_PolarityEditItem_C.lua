--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ModModel = ModController:GetModel()

---@type WBP_Armory_Mod_ReplaceItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})


function M:Destruct()
    self.ButtonArea.OnCheckStateChanged:Remove(self, self.OnMyCheckStateChanged)
end

function M:Construct()
    self.ButtonArea.OnCheckStateChanged:Add(self, self.OnMyCheckStateChanged)
end

function M:OnAnimationFinished(Animation)
    if Animation == self.In then
        self:InitSelectedState()
    end
end

function M:InitSelectedState()
    local SelectedStuff = ModModel:GetSelectStuff()
    local SlotUIData = ModModel:GetSlotUIData(SelectedStuff.SlotId)
    if SlotUIData:GetPolarity() == self.Content.Polarity then
        self.Content.bSelected = true
        self.ButtonArea:SetCheckedNoNotify(true)
        self.ButtonArea:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        --self.WidgetSwitcher_2:SetActiveWidgetIndex(1)
    else
        self:DeSelect()
        --self.WidgetSwitcher_2:SetActiveWidgetIndex(0)
    end
end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.ButtonArea:SetVisibility(UIConst.VisibilityOp.Visible)
    self.ButtonArea:SetForbidden(false)
    if self.ButtonArea:IsChecked() then
        self.ButtonArea:SetCheckedNoNotify(false)
    end 
    --self.WidgetSwitcher_2:SetActiveWidgetIndex(0)
    self.WidgetTree.RootWidget:SetRenderOpacity(1)
    self:SetImageVisibile(true)
    if not Content.Polarity then
        self.WidgetTree.RootWidget:SetRenderOpacity(self.DisableOpacity)
        self:SetImageVisibile(false)
        self.ButtonArea:SetForbidden(true)
        self.ButtonArea:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self:SetImageIcon(Content.Polarity)
    end
end

function M:SetImageVisibile(bVisible)
    if bVisible then 
        self.WidgetSwitcher_State:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.WidgetSwitcher_State:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:SetImageIcon(Polarity)
    if Polarity==CommonConst.NonePolarity then
        self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    else
        self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
        local PText = ModModel:GetPolarityText(Polarity)
        self.Text_Polarity:SetText(PText)
    end
end

function M:OnMyCheckStateChanged(bChecked)
    if bChecked then
        self.ButtonArea:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Content.bSelected = true
        if self.OnItemSelectOnCallback then
            self.OnItemSelectOnCallback(self.Content)
        end
    end
end

function M:SetOnItemSelectOn(Callback)
    self.OnItemSelectOnCallback = Callback
end

function M:DeSelect()
    if self.Content.Polarity then
        self.ButtonArea:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Content.bSelected = false
        self.ButtonArea:SetCheckedNoNotify(false)
    end
end

function M:BP_OnItemSelectionChanged(IsSelected)
    self.IsSelected = IsSelected
    if IsSelected then
        self.ButtonArea:SetChecked(true)
    end
end

return M

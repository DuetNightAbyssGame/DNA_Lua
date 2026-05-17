require "UnLua"

---@type WBP_Forging_Convert_PopUp_Choose_Item_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Init(Content)
    DebugPrint("Yihan@ InitItem")
    self:OnListItemObjectSet(Content)
end

function M:OnListItemObjectSet(Content)
    Content.Entry = self
    self.Content = Content
    self:InitData(Content)
    self:InitCompView()
    if self.AfterInitCallback then 
        self.AfterInitCallback(self)
    end
    if self.Content.NeedFocus then
        DebugPrint("Yeke@OnListItemObjectSet SetFocus")
        self:SetFocus()
    end
end

function M:InitData(Content)
    self.Id = Content.Id
    self.ItemType = Content.ItemType
    self.Rarity = Content.Rarity
    self.Icon = Content.Icon
    self.IsSelect = Content.IsSelect
    self.ClickedCount = Content.ClickedCount
    self.IsSelfDeadWithUpEvent = Content.IsSelfDeadWithUpEvent
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    if self.Content.IsEmpty then
        return UIUtils.Handled
    end
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    if (self.IsSelfDeadWithUpEvent) then
        DebugPrint("yihan@ OnMouseButtonUp")
        if self.Content then
            if self.WBP_Com_Item_Universal_L.Content.SelfWidget then 
                self.WBP_Com_Item_Universal_L.Content.SelfWidget.bMouseButtonDown = true
            end
            return self.WBP_Com_Item_Universal_L.Content.SelfWidget:OnMouseButtonUp(self, MyGeometry, MouseEvent)
        end
    else
        return UIUtils.Handled
    end
end

function M:OnTouchEnded(MyGeometry, TouchEvent)
    return self:OnMouseButtonUp(MyGeometry, TouchEvent)
end

function M:OnTouchStarted(MyGeometry, TouchEvent)
    return self:OnMouseButtonDown(MyGeometry, TouchEvent)
end

function M:InitCompView()
    self:InitCommonView()
    self:InitItem()
end

function M:InitCommonView()
    DebugPrint("Yihan@ Init Choose", self.ClickedCount)
    self:UpdateChoosedCount(self.ClickedCount)
    self:UpdateChoosedState(self.IsSelect)
end

function M:SetSelected(IsSelected)
    if self.NotInteractive then
        return
    end
    if self.Content then 
        self.Content.IsSelect = IsSelected
    end
end

-- 初始化Item相关
function M:InitItem()
    DebugPrint("Yihan@ WBP_Forging_Convert_PopUp_Choose_Item_C.InitItem", self.ClickedCount)
    self.Ws_Item:SetActiveWidgetIndex(0)
    self.WBP_Com_Item_Universal_L:Init(self.Content)
    self.IMgLight:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

-- 更改Choose中num的数量
function M:UpdateChoosedCount(Count)
    if Count == 0 or not Count then
        self.Choose:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Choose:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        self.TextNum:SetText(Count)
    end
end

function M:OnAddedToFocusPath()
    if self.Content and self.Content.Parent then
        local Parent = self.Content.Parent
        if Parent.IsGamePad then
            Parent:RefreshItemDetailsByContent(self.Content, true)
        end
    end
    -- self:StopAllAnimations()
    -- if self.Hover then
    --     self:PlayAnimation(self.Hover)
    -- end
end

function M:OnRemovedFromFocusPath()
    -- self:StopAllAnimations()
    -- if self.Normal then
    --     self:PlayAnimation(self.Normal)
    -- end
end

function M:UpdateChoosedState(bIsSelect)
    self.WBP_Com_Item_Universal_L:SetSelected(bIsSelect)
    -- if bIsSelect then
    --     self.IMgLight:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    -- else
    --     self.IMgLight:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- end
end

return M

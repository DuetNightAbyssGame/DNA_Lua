require "UnLua"

---@type WBP_Forging_Convert_Item_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Init(Content)
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
end

function M:InitData(Content)
    self.Id = Content.ItemData.ProductId
    self.ItemType = Content.ItemType
    self.Rarity = Content.Rarity
    self.Icon = Content.Icon

    self.Parent = Content.Parent
    self.ItemName = Content.ResourceName
    self.ResourseCount = Content.ResourseCount
    self.IsNew = Content.IsNew

end

function M:InitCompView()
    self:InitCommonView()
    self:InitItem()
end

function M:InitCommonView()
    self:SetName(self.ItemName)
    self:SetCount(self.ResourseCount)
    self:SetSelected(self.Content.IsSelect)
    self:SetNewIcon(self.IsNew)
end

-- 初始化Item相关
function M:InitItem()
    local Content = self.Content
    local ItemContent = {}
    ItemContent.Id = Content.Id
    ItemContent.ItemType = Content.ItemType
    ItemContent.Rarity = Content.Rarity
    ItemContent.Icon = Content.Icon
    ItemContent.IsSelect = false
    ItemContent.NotInteractive = Content.NotInteractive
    self.Item_S:Init(ItemContent)
    self.TextHave:SetText(GText("UI_FORGING_CURRENT"))
    -- 绑定按钮 添加Title_Button的按键监听
    -- self.Button_Area.OnClicked:Clear()
    -- self.Button_Area.OnClicked:Add(self, self.OnItemClicked)
end

function M:SetNewIcon(bIsNew)
    if bIsNew then
        self.New:SetVisibility(UE4.ESlateVisibility.Visible)
    else
        self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:SetName(Name)
    self.TextName:SetText(GText(Name))
end

function M:SetCount(Count)
    if self.Content.ProductType == CommonConst.ArmoryType.Mod then
        self.TextHave:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Num:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.TextHave:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Num:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Num:SetText(Count)
    end
end

function M:BindClicked()
    self.Button_Area.OnClicked:Add(self, function(self)
        self:ShowItemDetailsPanel(false)
    end)
end

function M:ShowItemDetailsPanel(bIsShow)
    if bIsShow then
        self.ItemDetails:SetVisibility(UE4.ESlateVisibility.Visible)
    elseif not bIsShow then
        self.ItemDetails:SetVisibility(UE4.ESlateVisibility.Hidden)

        if self.CurSelectedContent then
            local PrevWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Item, self.List_Item:GetIndexForItem(self.CurSelectedContent))
            if PrevWidget then
                PrevWidget:SetSelected(false)
            end
            self.CurSelectedContent.IsSelect = false
        end
        self.CurSelectedContent = nil
    end
end

function M:SetSelected(IsSelected)
    if self.Content then
        self.Content.IsSelect = IsSelected
    end
    self:StopAllAnimations()
    if IsSelected then
        self:PlayAnimation(self.Click)
    else
        self:PlayAnimation(self.Normal)
    end
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    DebugPrint("Yihan@ WBP_Forging_Convert_Item_C:OnMouseEnter")
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if not self.Content or self.Content.IsSelect then
        return 
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    DebugPrint("Yihan@ WBP_Forging_Convert_Item_C:OnMouseLeave")
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if not self.Content or self.Content.IsSelect then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
end

function M:OnAddedToFocusPath()
    if self.Content and self.Content.Parent and UIUtils:IsGamepadInput() then
        self.Content.Parent.CurFocusedItem = self.Content
        self.Content.Parent:OnEMListItemClicked(self.Content)
    end
end

function M:OnRemovedFromFocusPath()
    if not UIUtils:IsGamepadInput() then
        return 
    end
end

return M
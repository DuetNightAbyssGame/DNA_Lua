--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_Dialog_Skin_Item_C
-- local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

--function M:Initialize(Initializer)
--end

function M:Construct()
    -- self.Switch_Item:SetActiveWidgetIndex(0)
    -- self.Com_Item_Icon:SetVisibility(ESlateVisibility.Visible)
    -- self.Text_Item_Name:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- self.Text_Item_Num:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
end

function M:OnListItemObjectSet(Content)
    self:InitSkinItemInfo(Content)
end

function M:InitSkinItemInfo(Content)
    ---@field Id number                         @道具ID
    ---@field ItemType number                   @道具类型
    ---@field Rarity number                     @稀有度
    ---@field Icon string                       @图标(路径)
    self.Com_Item_Icon:Init({
        Id = Content.ItemId,
        ItemType = Content.ItemType,
        Rarity = Content.Rarity or 1,
        Icon = Content.Icon,
        -- UIName = "CommonDialog",
        IsShowDetails = true,
        IsCantItemSelection = true,
        MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
        HandleMouseDown = true,
        bCustomStype = true,
        bDisableCommonClick = true
    })
    self.Text_Item_Name:SetTexT(GText(Content.Name))
    self.Text_Item_Num:SetText("1")
end

function M:RefreshOpInfoByInputDevice()
    if self:HasAnyUserFocus() then
        self.Com_Item_Icon:SetFocus()
    end
end

function M:OnMouseButtonDown(MyGeometry, InMouseEvent)
    return UWidgetBlueprintLibrary.Unhandled()
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    return UWidgetBlueprintLibrary.Unhandled()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self.Com_Item_Icon:SetFocus()
    return UWidgetBlueprintLibrary.Handled()
end

return M

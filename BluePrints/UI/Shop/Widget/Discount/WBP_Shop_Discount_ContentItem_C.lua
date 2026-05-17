require "UnLua"

---@type WBP_Shop_Discount_ContentItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.TimerMgr", "BluePrints.UI.BP_EMUserWidgetUtils_C"})

function M:Construct()
    self.Com_List:BindEventOnClicked(self, self.OnSelfClicked)
    self.Com_List:SetCanCancelSelection(false)
    self.Com_List:TryOverrideSoundFunc(self.PlayVoucherOptionClickSound)
end

function M:Destruct()
    self.CurrentData.BoundWidget = nil
    self.Com_List.Obj = nil
    self.Com_List.Func = nil
    if self.Com_Item.Item and self.Com_Item.Item.ItemDetails_MenuAnchor and self.Com_Item.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor then
        self.Com_Item.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Remove(self,self.OnMenuOpenChanged)
    end
end

function M:OnListItemObjectSet(Data)
    self.CurrentData = Data
    self.CurrentData.BoundWidget = self

    if Data.IsVoucher then
        local VoucherInfo = Data.RawData
        self.Text_Desc:SetText(GText(VoucherInfo.ResourceName))
        
        local ItemContent = {
            Id = VoucherInfo.ResourceId,
            ItemType = "Resource",
            Count = VoucherInfo.VoucherNum,
            IsShowDetails = true,
            HandleMouseDown = true
        }
        ItemContent.Rarity = ItemUtils.GetItemRarity(ItemContent.Id, ItemContent.ItemType)
        ItemContent.Icon = ItemUtils.GetItemIconPath(ItemContent.Id, ItemContent.ItemType)
        
        self.Com_Item:SetVisibility(UIConst.VisibilityOp["Visible"])
        self.Com_Item:Init(ItemContent)
    else
        self.Com_Item:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        -- self.Com_Item:Init({Id = 0,})
        self.Text_Desc:SetText(GText("UI_Voucher_NotUse"))
    end
    if self.Com_Item.Item and self.Com_Item.Item.ItemDetails_MenuAnchor then
        self.Com_Item.Item.ItemDetails_MenuAnchor:SetLastFocusWidget(self)
        if self.Com_Item.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor then
            self.Com_Item.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self, self.OnMenuOpenChanged)
        end
    end

    self:UpdateSelection(Data.bIsSelected)
end

function M:UpdateSelection(bIsSelected)
    if bIsSelected and self.Com_List.SelectCell then
        self.WidgetSwitcher_Option:SetActiveWidgetIndex(1)
        self.Com_List:SelectCell()
    elseif not bIsSelected and self.Com_List.OnCellUnSelect then
        self.WidgetSwitcher_Option:SetActiveWidgetIndex(0)
        self.Com_List:OnCellUnSelect()
    end
end

function M:OnMenuOpenChanged(bIsOpen)
    if self.CurrentData and self.CurrentData.ItemTipsStateChangedCallback then
        self.CurrentData.ItemTipsStateChangedCallback(self.CurrentData, bIsOpen)
    end
end

function M:OnSelfClicked()
    if self.CurrentData and self.CurrentData.OnClickContext then
        self.CurrentData.OnClickContext()
    end
end

function M:PlayVoucherOptionClickSound()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_check", nil, nil)
end

--- 处理按键按下事件
-- function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
--     local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
--     local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
--     if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
--         self.Com_Item:OpenItemMenu()
--         return UE4.UWidgetBlueprintLibrary.Handled()
--     end
--     return UIUtils.Unhandled
-- end

--- 处理按键按下事件
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
        if self.CurrentData and self.CurrentData.IsVoucher and self.CurrentData.RawData then
            self.Com_Item:OpenItemMenu()
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
    end
    return UIUtils.Unhandled
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.CurrentData and self.CurrentData.ItemFocusReceivedCallback then
        self.CurrentData.ItemFocusReceivedCallback(self.CurrentData)
    end
    if self.CurrentData and not self.CurrentData.IsVoucher and self.Com_List and self.Com_List.Button_Area then
        self.Com_List.Button_Area:SetFocus()
    end
    return UIUtils.Handled
end

return M
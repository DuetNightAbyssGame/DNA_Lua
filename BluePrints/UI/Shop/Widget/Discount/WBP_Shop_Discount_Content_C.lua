require "UnLua"

---@type WBP_Shop_Discount_Content_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.TimerMgr", "BluePrints.UI.BP_EMUserWidgetUtils_C"})
local EMCache = require "EMCache.EMCache"

function M:Construct()
    self.Text_Desc:SetText(GText("UI_Voucher_DefaultUse"))
    self.Com_BtnQa:Init({
        -- ClickCallback = function,
        OwnerWidget = self,
        TextContent = GText("UI_Voucher_DefaultUseDes"),
        OnMenuOpenChangedCallBack = self.OnQaMenuOpenChangedCallBack,
        SoundFunc = function(Obj)
            AudioManager(Obj):PlayUISound(Obj, "event:/ui/common/click_btn_small", nil, nil)
        end,
        -- SoundFuncReceiver = Obj,
    })
    self.Com_SwitchCheckBox:AddEventOnCheckStateChanged(self, self.OnCheckStateChanged)
    self.Key_Qa:CreateGamepadKey(UIConst.GamePadImgKey.DPadLeft)
    self.Key_Switch:CreateGamepadKey(UIConst.GamePadImgKey.DPadRight)
    self:StopAnimation(self.List_In)
    self:PlayAnimation(self.List_In)
end

function M:Destruct()
    self.Com_SwitchCheckBox:RemoveEventOnCheckStateChanged(self)
    self:RemoveInputMethodChangedListen()
end

function M:Init(Params)
    self.SelectCallback = Params.SelectCallback
    self.TipsStateChangedCallback = Params.TipsStateChangedCallback
    self.ItemTipsStateChangedCallback = Params.ItemTipsStateChangedCallback

    -- 设置尺寸
    if Params.IsInPreview then
        self.Group_Content:SetWidthOverride(self.InPreviewSize.X)
        self.Group_Content:SetHeightOverride(self.InPreviewSize.Y)
    elseif Params.IsInPopup then
        self.Group_Content:SetWidthOverride(self.InPopupSize.X)
        self.Group_Content:SetHeightOverride(self.InPopupSize.Y)
    end

    local TargetUEIndex = 0 
    local CurrentLoopIndex = 0

    self.CurrentListData = {}
    -- 添加不使用折扣券选项
    local NoUseItem = NewObject(UIUtils.GetCommonItemContentClass())
    NoUseItem.IsVoucher = false
    NoUseItem.RawData = nil
    NoUseItem.bIsSelected = (Params.SelectedDiscount == nil)
    NoUseItem.OnClickContext = function() self:OnItemClickedLogic(NoUseItem) end
    NoUseItem.ItemFocusReceivedCallback = Params.ItemFocusReceivedCallback
    table.insert(self.CurrentListData, NoUseItem)

    if NoUseItem.bIsSelected then
        TargetUEIndex = CurrentLoopIndex
    end
    CurrentLoopIndex = CurrentLoopIndex + 1

    -- 添加折扣券
    for _, Data in pairs(Params.AvailableDiscounts) do
        local Item = NewObject(UIUtils.GetCommonItemContentClass())
        Item.IsVoucher = true
        Item.RawData = Data
        Item.bIsSelected = (Params.SelectedDiscount and Params.SelectedDiscount.VoucherId == Data.VoucherId) or false
        Item.OnClickContext = function() self:OnItemClickedLogic(Item) end
        Item.ItemTipsStateChangedCallback = self.ItemTipsStateChangedCallback
        Item.ItemFocusReceivedCallback = Params.ItemFocusReceivedCallback
        table.insert(self.CurrentListData, Item)

        if Item.bIsSelected then
            TargetUEIndex = CurrentLoopIndex
        end
        CurrentLoopIndex = CurrentLoopIndex + 1
    end
    self.List_Discount:BP_SetListItems(self.CurrentListData)

    -- 默认选中状态
    local AutoSelectDiscount = EMCache:Get("AutoSelectDiscount", true)
    self.Com_SwitchCheckBox.IsChecked = AutoSelectDiscount and true or false
    self.Com_SwitchCheckBox:PlayAnimation(self.Com_SwitchCheckBox:GetBtnNormalAnim())

    --添加手柄监听
    self:AddInputMethodChangedListen()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    local bIsGamepad = false
    if (IsValid(self.GameInputModeSubsystem)) then
        local InputType = self.GameInputModeSubsystem:GetCurrentInputType()
        bIsGamepad = (InputType == ECommonInputType.Gamepad)
        self:RefreshOpInfoByInputDevice(InputType, self.GameInputModeSubsystem:GetCurrentGamepadName())
    end

    -- 聚焦给被默认选中的折扣券
    self:AddTimer(0.01, function()
        if IsValid(self) and IsValid(self.List_Discount) then
            self.List_Discount:NavigateToIndex(TargetUEIndex)
            self.List_Discount:SetSelectedIndex(TargetUEIndex)
            local NewFocusItem=self.List_Discount:GetItemAt(TargetUEIndex)
            self.List_Discount:ScrollItemIntoViewWithAnim(NewFocusItem, false, UE4.EDescendantScrollDestination.BottomOrRight)
            if bIsGamepad then
                self.List_Discount:SetFocus()
            end
        end
    end)
end

function M:OnItemClickedLogic(ClickedItemData)
    for _, ItemData in ipairs(self.CurrentListData) do
        local bWasSelected = ItemData.bIsSelected
        ItemData.bIsSelected = (ItemData == ClickedItemData)
        
        if bWasSelected ~= ItemData.bIsSelected then
            if ItemData.BoundWidget and ItemData.BoundWidget.UpdateSelection then
                ItemData.BoundWidget:UpdateSelection(ItemData.bIsSelected)
            end
        end
    end

    if self.SelectCallback then
        local Result = ClickedItemData.IsVoucher and ClickedItemData.RawData or nil
        self.SelectCallback(Result)
    end
end

function M:OnQaMenuOpenChangedCallBack(IsChecked)
    self.QaMenuOpen = IsChecked
    if self.TipsStateChangedCallback then
        self.TipsStateChangedCallback(nil, IsChecked)
    end
end

function M:OnCheckStateChanged(IsChecked)
    if IsChecked then
        EMCache:Set("AutoSelectDiscount", true, true)
    else
        EMCache:Set("AutoSelectDiscount", false, true)
    end
end

--- 处理按键按下事件
function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == UIConst.GamePadKey.DPadLeft and not UIManager(self):IsHaveMenuAnchorOpen() then
        local MenuOpen = self.QaMenuOpen
        self.Com_BtnQa.Btn_Click:SetChecked(not MenuOpen)
        self.Com_BtnQa:OnViewInfoClicked()
        if MenuOpen then
            self.List_Discount:SetFocus()
        end
        return UIUtils.Handled
    elseif InKeyName == UIConst.GamePadKey.DPadRight and not UIManager(self):IsHaveMenuAnchorOpen() then
        self.Com_SwitchCheckBox:OnBtnClicked()
        return UIUtils.Handled
    end
    return UIUtils.Unhandled
end

--- 处理按键按下事件
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
        if self.QaMenuOpen then
            self.Com_BtnQa.Btn_Click:SetChecked(false)
            self.List_Discount:SetFocus()
            return UIUtils.Handled
        end
    end
    return UIUtils.Unhandled
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if CurInputDevice == ECommonInputType.Gamepad then
        self.Key_Qa:SetVisibility(UIConst.VisibilityOp["Visible"])
        self.Key_Switch:SetVisibility(UIConst.VisibilityOp["Visible"])
    else
        self.Key_Qa:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Key_Switch:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

return M
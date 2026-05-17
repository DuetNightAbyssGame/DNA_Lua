require "UnLua"

---@type WBP_Shop_Discount_Btn_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.TimerMgr", "BluePrints.UI.BP_EMUserWidgetUtils_C"})

function M:Construct()
    self.Button_Area.OnClicked:Add(self, self.OnButtonClicked)
    self.Button_Area.OnPressed:Add(self, self.OnButtonPressed)
    self.Button_Area.OnReleased:Add(self, self.OnButtonReleased)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Button_Area.OnHovered:Add(self, self.OnButtonHovered)
        self.Button_Area.OnUnhovered:Add(self, self.OnButtonUnhovered)
    end
    self.ItemDetailsMenuAnchor.OnGetUserMenuContentEvent:Bind(self, self.OnGetUserMenuContent)
    self.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self, self.OnMenuStateChanged)
    self.Text_Forbidden:SetText(GText("UI_Voucher_Unavailable"))
    self.Text_Button:SetText(GText("UI_Voucher_Available"))
    
    self.Key_GamePad:CreateGamepadKey(UIConst.GamePadImgKey.DPadUp)
    self.Key_Change:CreateGamepadKey(UIConst.GamePadImgKey.DPadUp)

    self:StopAllAnimations()
    self:PlayAnimation(self.Normal) -- 默认状态
end

function M:Destruct()
    self.Button_Area.OnClicked:Remove(self, self.OnButtonClicked)
    self.Button_Area.OnPressed:Remove(self, self.OnButtonPressed)
    self.Button_Area.OnReleased:Remove(self, self.OnButtonReleased)
    self.Button_Area.OnHovered:Remove(self, self.OnButtonHovered)
    self.Button_Area.OnUnhovered:Remove(self, self.OnButtonUnhovered)
    self.ItemDetailsMenuAnchor.OnGetUserMenuContentEvent:Unbind()
    self.ItemDetailsMenuAnchor.OnMenuOpenChanged:Remove(self, self.OnMenuStateChanged)
end

function M:Init(Params)
    self.ParentWidget = Params.ParentWidget
    self.IsInPreview = Params.IsInPreview
    self.IsInPopup = Params.IsInPopup
    self.ShopItemData = Params.ShopItemData
    self.AvailableDiscounts = Params.AvailableDiscounts
    self.SelectedDiscount = Params.SelectedDiscount
    self.OnDiscountChangedCallback = Params.OnDiscountChangedCallback
    self.OnMenuStateChangedCallback = Params.OnMenuStateChangedCallback
    self.TipsStateChangedCallback = Params.TipsStateChangedCallback
    self.ItemTipsStateChangedCallback = Params.ItemTipsStateChangedCallback
    self.ItemFocusReceivedCallback = Params.ItemFocusReceivedCallback

    self.CanOpenMenu = (self.AvailableDiscounts and #self.AvailableDiscounts > 0)

    self:RefreshDiscountUI()
    self.Image_Arrow:SetRenderTransformAngle(0)

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
end

function M:SetSelectedDiscount(NewDiscount)
    self.SelectedDiscount = NewDiscount
    self:RefreshDiscountUI()
end

function M:RefreshDiscountUI()
    if self.CanOpenMenu then
        if self.SelectedDiscount then
            self.Text_Change:SetText(string.format(GText("UI_Voucher_Count"), GText(self.SelectedDiscount.ResourceName)))
            self.WS_Content:SetActiveWidgetIndex(1)
        else
            self.WS_Content:SetActiveWidgetIndex(0)
        end
    else
        self.WS_Content:SetActiveWidgetIndex(2)
    end
end

function M:OnGetUserMenuContent()
    self.CurrentContentWidget = self:CreateWidgetNew("ShopDiscountContent")
    local Content = {
        AvailableDiscounts = self.AvailableDiscounts,
        SelectedDiscount = self.SelectedDiscount,
        SelectCallback = function(NewDiscount) self:OnDiscountChanged(NewDiscount) end,
        IsInPreview = self.IsInPreview,
        IsInPopup = self.IsInPopup,
        TipsStateChangedCallback = self.TipsStateChangedCallback,
        ItemTipsStateChangedCallback = self.ItemTipsStateChangedCallback,
        ItemFocusReceivedCallback = self.ItemFocusReceivedCallback,
    }
    self.CurrentContentWidget:Init(Content)
    return self.CurrentContentWidget
end

function M:OnMenuStateChanged(bIsOpen)
    self.MenuAnchorOpen = bIsOpen
    if bIsOpen then
        if self.OnMenuStateChangedCallback then
            self.OnMenuStateChangedCallback(true)
        end
        self.Key_GamePad:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Key_Change:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Image_Arrow:SetRenderTransformAngle(180)
        self.WS_ChangeImage:SetActiveWidgetIndex(1)
    else
        local bClosedByThisButton = self.Button_Area:IsHovered() or self.Button_Area:HasKeyboardFocus()
        self.bJustClosed = true
        self.bCanPlayCloseSound = bClosedByThisButton
        self:AddTimer(0.3, function()
            if IsValid(self) then
                self.bJustClosed = false
                self.bCanPlayCloseSound = false
            end
        end)
        if self.OnMenuStateChangedCallback then
            self.OnMenuStateChangedCallback(false)
        end
        if UIUtils.IsGamepadInput() then
            self.Key_GamePad:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Key_Change:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
        self.Image_Arrow:SetRenderTransformAngle(0)
        self.WS_ChangeImage:SetActiveWidgetIndex(0)
    end
end

function M:OnButtonClicked()
    if not self.CanOpenMenu then
        return
    end

    if self.bJustClosed then
        if self.bCanPlayCloseSound then
            self.bCanPlayCloseSound = false
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
            self:PlayAnimation(self.Click)
        end
        return
    end

    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)

    if self.MenuAnchorOpen then
        self.ItemDetailsMenuAnchor:Close()
    else
        self.ItemDetailsMenuAnchor:Open(true)
    end
    self:PlayAnimation(self.Click)
end

function M:OnButtonPressed()
    if not self.CanOpenMenu then
        return
    end
    -- self:StopAnimation(self.)
    self:PlayAnimation(self.Press)
end

function M:OnButtonReleased()
    if not self.CanOpenMenu then
        return
    end
    self:StopAnimation(self.Press)
    self:PlayAnimation(self.Normal)
end

function M:OnButtonHovered()
    if not self.CanOpenMenu then
        return
    end
    self:StopAnimation(self.UnHover)
    self:PlayAnimationForward(self.Hover)
end

function M:OnButtonUnhovered()
    if not self.CanOpenMenu then
        return
    end
    self:StopAnimation(self.Hover)
    self:PlayAnimationForward(self.UnHover)
end

-- 当菜单里选中了折扣券时的回调函数
function M:OnDiscountChanged(NewDiscount)
    if self.ItemDetailsMenuAnchor:IsOpen() then
        self.ItemDetailsMenuAnchor:Close()
    end
    if self.OnDiscountChangedCallback then
        self.OnDiscountChangedCallback(NewDiscount) -- 通知父组件折扣变化了
    end
end

--- 处理按键按下事件
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
        if self.MenuAnchorOpen then
            self.ItemDetailsMenuAnchor:Close()
            return UIUtils.Handled
        end
    end
    return UIUtils.Unhandled
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if IsValid(self.ItemDetailsMenuAnchor) and self.ItemDetailsMenuAnchor:IsOpen() then
        self.ItemDetailsMenuAnchor:Close()
    end
    if CurInputDevice == ECommonInputType.Gamepad then
        self.Key_GamePad:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Key_Change:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Key_GamePad:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Key_Change:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

-- Utils
function M:ForceCloseMenu()
    if self.ItemDetailsMenuAnchor and self.ItemDetailsMenuAnchor:IsOpen() then
        self.ItemDetailsMenuAnchor:Close()
        self.MenuAnchorOpen = false
    end
end

return M
local M = Class({ "BluePrints.UI.BP_EMUserWidget_C" })

function M:Construct()
    self.TitleText = self.Text_Title
    self.PrizeItems = {
        self.Btn_Select_01,
        self.Btn_Select_02,
    }
    self.ConfirmButton = self.Btn_Select
    self.CloseButton = self.Btn_Close
    self.CloseKeySwitcher = self.WS_Type
    self.KeyboardCloseKey = self.Key_Close
    self.GamepadCloseKey = self.Controller_Close

    self.FadeInAnimation = self.In
    self.FadeOutAnimation = self.Out

    self.TitleText:SetText(GText("UI_LimitedPrizePool_PleaseSelectFirstPrize"))
    self.ConfirmButton:SetForbidden(true)

    for _, PrizeItem in ipairs(self.PrizeItems) do
        if (IsValid(PrizeItem)) then
            PrizeItem:BindSelectedChanged({ self, self.HandlePrizeItemSelectedChanged })
            PrizeItem:BindViewDetails({ self, self.HandlePrizeItemViewDetails })
        end
    end

    self.ConfirmButton:BindClicked({ self, self.ConfirmSelection })
    self.CloseButton:Init("Close", self, self.Close)

    self:BindToAnimationFinished(self.FadeOutAnimation, { self, self.RemoveFromParent })

    self.OnConfirmSelection = nil

    self:SetKeyboardFocus()
    self:ListenInputTypeChanged()
    self:SetInputType(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())
end

function M:Destruct()
    for _, PrizeItem in ipairs(self.PrizeItems) do
        if (IsValid(PrizeItem)) then
            PrizeItem:UnbindSelectedChanged()
            PrizeItem:UnbindViewDetails()
        end
    end

    self.ConfirmButton:UnbindClicked()

    self:UnlistenInputTypeChanged()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)

    if (KeyName == UIConst.GamePadKey.LeftShoulder) then
        local SelectedItem = self:GetSelectedPrizeItem()
        if (IsValid(SelectedItem)) then
            SelectedItem:ViewDetails()
        end
    elseif (KeyName == UIConst.GamePadKey.FaceButtonBottom) then
        self:ConfirmSelection()
    elseif (KeyName == UIConst.GamePadKey.FaceButtonRight) then
        self:Close()
    elseif (KeyName == "Escape") then
        self:Close()
    end

    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local Key = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)

    self:SelectGamepadFocusPrizeItem()

    return UE4.UWidgetBlueprintLibrary.Handled()
end

---@ param Prizes table: { { Id: int, Type: string } }
function M:Init(Prizes, OnConfirmSelection)
    for i, Prize in pairs(Prizes) do
        local PrizeItem = self.PrizeItems[i]
        if (IsValid(PrizeItem)) then
            PrizeItem:SetPrize(Prize)
        end
    end

    self.OnConfirmSelection = OnConfirmSelection

    self:PlayAnimation(self.FadeInAnimation)
end

function M:Close()
    if (self:IsAnimationPlaying(self.FadeOutAnimation)) then
        return
    end

    self:PlayAnimation(self.FadeOutAnimation)
end

function M:HandlePrizeItemSelectedChanged(PrizeItem)
    if (not IsValid(PrizeItem)) then
        return
    end

    if (PrizeItem:IsSelected()) then
        for _, Item in pairs(self.PrizeItems) do
            if (IsValid(Item) and Item ~= PrizeItem) then
                Item:SetSelected(false)
            end
        end
    end

    for _, Item in pairs(self.PrizeItems) do
        if (IsValid(Item) and Item:IsSelected()) then
            self.ConfirmButton:SetForbidden(false)
            break
        end
    end
end

function M:HandlePrizeItemViewDetails(PrizeItem)
    if (not IsValid(PrizeItem)) then
        return
    end

    local Prize = PrizeItem:GetPrize()
    if (not Prize) then
        return
    end

    local SkinPreviewUIName = "SkinPreview"

    EventManager:AddEvent(EventID.UnLoadUI, self, function(_, UIName)
        if (UIName ~= SkinPreviewUIName) then
            return
        end

        EventManager:RemoveEvent(EventID.UnLoadUI, self)
        self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end)

    UIManager(self):LoadUINew(SkinPreviewUIName, {
        TypeId = Prize.Id,
        ItemType = Prize.Type,
        SinglePreview = true,
        HidePurchase = true
    })
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:BindConfirmSelection(OnConfirmSelection)
    self.OnConfirmSelection = OnConfirmSelection
end

function M:UnbindConfirmSelection()
    self.OnConfirmSelection = nil
end

function M:ConfirmSelection()
    local SelectedPrize = nil
    for _, PrizeItem in pairs(self.PrizeItems) do
        if (IsValid(PrizeItem) and PrizeItem:IsSelected()) then
            SelectedPrize = PrizeItem:GetPrize()
            break
        end
    end

    if (not SelectedPrize) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_LimitedPrizePool_PleaseSelectPrize"))
        return
    end

    if (SelectedPrize and self.OnConfirmSelection and self.OnConfirmSelection[1] and self.OnConfirmSelection[2]) then
        self.OnConfirmSelection[2](self.OnConfirmSelection[1], SelectedPrize)
    end
end

function M:ListenInputTypeChanged()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UE4.UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.SetInputType)
    end
end

function M:UnlistenInputTypeChanged()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UE4.UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.SetInputType)
    end
end

function M:SetInputType(NewInputType, NewGamepadName)
    if (NewInputType == ECommonInputType.Touch) then
    elseif NewInputType == ECommonInputType.Gamepad then
        self.GamepadCloseKey:CreateCommonKey({
            KeyInfoList = { { Type = "Img", ImgShortPath = "B", ClickCallback = self.Close, Owner = self } },
            Desc = GText("UI_Tips_Close")
        })

        self.CloseKeySwitcher:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.CloseKeySwitcher:SetActiveWidget(self.GamepadCloseKey)

        self:GamepadFocusSelectedPrizeItem()
    else
        self.KeyboardCloseKey:CreateCommonKey({
            KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback = self.Close, Owner = self } },
            Desc = GText("UI_BACK")
        })

        self.CloseKeySwitcher:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.CloseKeySwitcher:SetActiveWidget(self.KeyboardCloseKey)
    end
end

function M:GamepadFocusSelectedPrizeItem()
    local SelectedItem = self:GetSelectedPrizeItem()
    if (SelectedItem) then
        SelectedItem:SetKeyboardFocus()
    else
        local FirstItem = self.PrizeItems[1]
        if (IsValid(FirstItem)) then
            FirstItem:SetKeyboardFocus()
            FirstItem:SetSelected(true)
        end
    end
end

function M:SelectGamepadFocusPrizeItem()
    for _, PrizeItem in pairs(self.PrizeItems) do
        if (IsValid(PrizeItem) and PrizeItem:HasKeyboardFocus()) then
            PrizeItem:SetSelected(true)
            break
        end
    end
end

function M:GetSelectedPrizeItem()
    for _, PrizeItem in pairs(self.PrizeItems) do
        if (IsValid(PrizeItem) and PrizeItem:IsSelected()) then
            return PrizeItem
        end
    end

    return nil
end

return M

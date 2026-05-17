local M = Class({ "BluePrints.UI.BP_EMUserWidget_C" })

function M:Construct()
    self.SelectedPanel = self.Panel_Select
    self.SelectedIcon = self.Icon_Select3
    self.PrizeNameText = self.Text_Name
    self.CheckBoxButton = self.Btn_Select

    self.OwnedText = self.Text_Got

    self.ViewDetailsSwitcher = self.WS_Type
    self.KeyboardViewDetailsKey = self.Btn_Check
    self.GamepadViewDetailsKey = self.Controller_Check

    self.ViewDetailsText = self.Text_CheckDetail
    self.ViewDetailsButton = self.Btn_CheckDetail

    self.SelectedAnimation = self.Select
    self.UnselectedAnimation = self.UnSelect

    self.OwnedText:SetText(GText("UI_LimitedPrizePool_AlreadyGet"))
    self.ViewDetailsText:SetText(GText("UI_LimitedPrizePool_ViewDetails"))

    self.CheckBoxButton.OnClicked:Add(self, self.ToggleSelected)
    self.ViewDetailsButton.OnClicked:Add(self, self.ViewDetails)

    self.Prize = nil
    self.bSelected = false
    self.bOwned = false
    self.OnSelectedChanged = nil
    self.OnViewDetails = nil

    self:ListenInputTypeChanged()
    self:SetInputType(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())
end

function M:Destruct()
    self.CheckBoxButton.OnClicked:Remove(self, self.ToggleSelected)
    self.ViewDetailsButton.OnClicked:Remove(self, self.ViewDetails)

    self:UnlistenInputTypeChanged()
end

-- Prize: { Id: int, Type: string}
function M:SetPrize(Prize)
    if (not Prize) then
        return
    end

    self.Prize = Prize
    self.bSelected = false
    self.bOwned = false

    local ItemName = ItemUtils.GetItemName(Prize.Id, Prize.Type)
    self.PrizeNameText:SetText(GText(ItemName))

    local Avatar = GWorld:GetAvatar()
    if (Avatar) then
        self.bOwned = Avatar:CheckSkinEnough({ [Prize.Id] = 1 })
    end

    if (self.bOwned) then
        self.SelectedPanel:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.OwnedText:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.SelectedPanel:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.OwnedText:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:GetPrize()
    return self.Prize
end

function M:IsOwned()
    return self.bOwned
end

function M:SetSelected(bSelected)
    if (self.bSelected == bSelected) then
        return
    end

    self.bSelected = bSelected

    if (self.bSelected) then
        self:StopAnimation(self.UnselectedAnimation)
        self:PlayAnimation(self.SelectedAnimation)
        self.GamepadViewDetailsKey:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self:StopAnimation(self.SelectedAnimation)
        self:PlayAnimation(self.UnselectedAnimation)
        self.GamepadViewDetailsKey:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    if (self.OnSelectedChanged and self.OnSelectedChanged[1] and self.OnSelectedChanged[2]) then
        self.OnSelectedChanged[2](self.OnSelectedChanged[1], self)
    end
end

function M:IsSelected()
    return self.bSelected
end

function M:BindSelectedChanged(OnSelectedChanged)
    self.OnSelectedChanged = OnSelectedChanged
end

function M:UnbindSelectedChanged()
    self.OnSelectedChanged = nil
end

function M:BindViewDetails(OnViewDetails)
    self.OnViewDetails = OnViewDetails
end

function M:UnbindViewDetails()
    self.OnViewDetails = nil
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
        self.ViewDetailsSwitcher:SetActiveWidget(self.KeyboardViewDetailsKey)
    elseif NewInputType == ECommonInputType.Gamepad then
        self.GamepadViewDetailsKey:CreateCommonKey({
            KeyInfoList = { { Type = "Img", ImgShortPath = "LS" } }
        })

        self.ViewDetailsSwitcher:SetActiveWidget(self.GamepadViewDetailsKey)
    else
        self.ViewDetailsSwitcher:SetActiveWidget(self.KeyboardViewDetailsKey)
    end
end

function M:ToggleSelected()
    if (self.bOwned) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_LimitedPrizePool_AlreadyGetPrize"))
        return
    end

    self:SetSelected(not self.bSelected)
end

function M:ViewDetails()
    if (self.OnViewDetails and self.OnViewDetails[1] and self.OnViewDetails[2]) then
        self.OnViewDetails[2](self.OnViewDetails[1], self)
    end
end

return M

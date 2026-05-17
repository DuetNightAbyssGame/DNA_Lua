---@type WBP_LimitedPrizePool_RewardWave_C
local M = Class({ "BluePrints.UI.BP_EMUserWidget_C" })

function M:Construct()
    self.QACheckbox = self.Btn_Qa
    self.QAGamepadTip = self.Controller
    self.Text = self.Text_Wave
    self.Round = self.Text_Now
    self.TotalRound = self.Text_Total

    self.QACheckbox:Init({
        TextContent = GText("UI_LimitedPrizePool_GetAllDes"),
        MenuPlacement = EMenuPlacement.MenuPlacement_AboveRightAnchor,
        OnMenuOpenChangedCallBack = self.OnMenuOpenChangedCallBack,
        OwnerWidget = self
    })
    self.QAGamepadTip:CreateGamepadKey(UIConst.GamePadImgKey.SpecialLeft)
    self.Text:SetText(GText("UI_LimitedPrizePool_Round"))

    self:SetInputType(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())
    self:ListenInputTypeChanged()
end

function M:Destruct()
    self:UnlistenInputTypeChanged()
end

function M:OnMenuOpenChangedCallBack(bIsOpen)
    if (self.OnMenuOpenChanged and self.OnMenuOpenChanged[1] and self.OnMenuOpenChanged[2]) then
        self.OnMenuOpenChanged[2](self.OnMenuOpenChanged[1], bIsOpen)
    end
end

function M:BindOnMenuOpenChanged(OnMenuOpenChanged)
    self.OnMenuOpenChanged = OnMenuOpenChanged
end

function M:UnbindindOnMenuOpenChanged()
    self.OnMenuOpenChanged = nil
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
        self.QAGamepadTip:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif NewInputType == ECommonInputType.Gamepad then
        self.QAGamepadTip:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.QAGamepadTip:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:SetQAChecked(bChecked)
    self.QACheckbox:SetChecked(bChecked)
end

function M:IsQAChecked()
    return self.QACheckbox:IsChecked()
end

function M:SetCurrentRound(Value)
    self.Round:SetText(tostring(Value))
end

function M:GetCurrentRound()
    return tonumber(self.Round:GetText())
end

function M:SetTotalRound(Value)
    self.TotalRound:SetText(tostring(Value))
end

function M:SetGamePadVisibility(Op)
    self.QAGamepadTip:SetVisibility(Op)
end

return M

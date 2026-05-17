local M = Class({ "BluePrints.UI.BP_EMUserWidget_C" })

function M:Construct()
    self.GamepadKeyTip = self.Key_GamePad
    self.Text = self.Text_Button
    self.Button = self.Button_Area

    self.Text:SetText(GText("UI_LimitedPrizePool_ConfirmSelect"))

    self.Button.OnClicked:Add(self, self.HandleButtonClicked)

    self.OnClicked = nil

    self:ListenInputTypeChanged()
    self:SetInputType(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())
end

function M:Destruct()
    self.Button.OnClicked:Remove(self, self.HandleButtonClicked)

    self:UnlistenInputTypeChanged()
end

function M:BindClicked(OnClicked)
    self.OnClicked = OnClicked
end

function M:UnbindClicked()
    self.OnClicked = nil
end

function M:SetForbidden(bForbidden)
    self.Button:SetForbidden(bForbidden)
end

function M:IsForbidden()
    return self.Button:GetForbidden()
end

function M:HandleButtonClicked()
    if (self.OnClicked and self.OnClicked[1] and self.OnClicked[2]) then
        self.OnClicked[2](self.OnClicked[1])
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
        self.GamepadKeyTip:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif NewInputType == ECommonInputType.Gamepad then
        self.GamepadKeyTip:CreateCommonKey({
            KeyInfoList = { { Type = "Img", ImgShortPath = "A" } }
        })

        self.GamepadKeyTip:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.GamepadKeyTip:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

return M

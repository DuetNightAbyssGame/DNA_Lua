---@type WBP_LimitedPrizePool_Gacha_P_C
local M = Class({ "BluePrints.UI.WBP.Activity.Widget.LimitedPrizePool.WBP_LimitedPrizePool_Gacha_Base_C" })

function M:Construct()
    M.Super.Construct(self)
    self.SkipKey = self.Key_Skip
    self.SkipControllerKey = self.Controller_Skip
    self.SkipTypeSwitcher = self.WS_Type
    self:InitSkipKeys()
    self:ListenInputTypeChanged()
end

function M:Destruct()
    if self.SkipKey then
        self.SkipKey:RemoveExecuteLogic()
    end
    if self.SkipControllerKey then
        self.SkipControllerKey:RemoveExecuteLogic()
    end
    self:UnlistenInputTypeChanged()
    M.Super.Destruct(self)
end

function M:InitSkipKeys()
    if self.SkipKey then
        self.SkipKey:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Text",
                    Text = "Space",
                }
            },
            Desc = GText("UI_TALK_SKIP"),
            bLongPress = true,
        })
        self.SkipKey:AddExecuteLogic(self, self.SkipToResult)
    end
    if self.SkipControllerKey then
        self.SkipControllerKey:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "A",
                }
            },
            Desc = GText("UI_TALK_SKIP"),
            bLongPress = true,
        })
        self.SkipControllerKey:AddExecuteLogic(self, self.SkipToResult)
    end
end

function M:Init(RewardPool, WonIndex, bIsBigPrize, AcquiredList, DrawCount, ConvertFlags, InCallback)
    M.Super.Init(self, RewardPool, WonIndex, bIsBigPrize, AcquiredList, DrawCount, ConvertFlags, InCallback)
    self:AddTimer(0.01, function()
        if IsValid(self) then
            self:SetFocus()
        end
    end, nil, nil, nil, true)
    self:RefreshBaseInfo()
end

function M:ListenInputTypeChanged()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    end
end

function M:UnlistenInputTypeChanged()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

function M:RefreshBaseInfo()
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end
    self.UsingGamepad = CurInputDevice == ECommonInputType.Gamepad
    if self.SkipTypeSwitcher then
        if self.UsingGamepad then
            self.SkipTypeSwitcher:SetActiveWidgetIndex(1)
        else
            self.SkipTypeSwitcher:SetActiveWidgetIndex(0)
        end
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)
    local IsHandled = false
    if KeyName == "SpaceBar" then
        if self.SkipKey then
            self.SkipKey:OnShortCutPressed()
            IsHandled = true
        end
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)
    local IsHandled = false
    if KeyName == "SpaceBar" then
        if self.SkipKey then
            self.SkipKey:OnShortCutReleased()
            IsHandled = true
        end
    elseif KeyName == "Gamepad_FaceButton_Bottom" then
        if self.SkipControllerKey then
            self.SkipControllerKey:OnShortCutReleased()
            IsHandled = true
        end
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)
    local IsHandled = false
    if KeyName == "Gamepad_FaceButton_Bottom" then
        if self.SkipControllerKey then
            self.SkipControllerKey:OnShortCutPressed()
            IsHandled = true
        end
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

return M

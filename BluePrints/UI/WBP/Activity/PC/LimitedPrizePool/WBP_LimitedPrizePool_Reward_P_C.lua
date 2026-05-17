---@type WBP_LimitedPrizePool_Reward_P_C
local M = Class({ "BluePrints.UI.WBP.Activity.Widget.LimitedPrizePool.WBP_LimitedPrizePool_Reward_Base_C" })

function M:Construct()
    M.Super.Construct(self)
    self.TypeSwitcher = self.WS_Type
    self.GamepadMoveKey = self.Controller_Switch
    self.GamepadViewKey = self.Controller_Check
    self.GamepadBackKey = self.Controller_Back
    self:InitGamepadKeys()
    self:ListenInputTypeChanged()
end

function M:Destruct()
    self:UnlistenInputTypeChanged()
    M.Super.Destruct(self)
end

function M:OnLoaded(...)
    M.Super.OnLoaded(self, ...)
    self:RefreshBaseInfo()
end

function M:InitGamepadKeys()
    if self.GamepadMoveKey then
        self.GamepadMoveKey:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "LH",
                }
            },
            Desc = GText("UI_Controller_CheckItems"),
        })
    end
    if self.GamepadViewKey then
        self.GamepadViewKey:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "A",
                }
            },
            Desc = GText("UI_Controller_CheckDetails"),
        })
    end
    if self.GamepadBackKey then
        self.GamepadBackKey:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "B",
                }
            },
            Desc = GText("UI_BACK"),
        })
    end
end

function M:ListenInputTypeChanged()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UE4.UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
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
    if not self.TypeSwitcher then
        return
    end
    if CurInputDevice == ECommonInputType.Gamepad then
        self.TypeSwitcher:SetActiveWidgetIndex(1)
        if self.List then
            self.List:SetFocus()
        end
    else
        self.TypeSwitcher:SetActiveWidgetIndex(0)
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)
    local IsHandled = false
    if KeyName == "Escape" then
        self:OnClose()
        IsHandled = true
    elseif KeyName == UIConst.GamePadKey.FaceButtonRight then
        self:OnClose()
        IsHandled = true
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnMenuOpenChange(IsOpen)
    return
end

return M

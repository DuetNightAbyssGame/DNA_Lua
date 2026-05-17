local Component = {}

local Const = UIConst.GamePadKey

function Component:InitListenEvent()
    local PlayerController = self:GetOwningPlayer()
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function Component:RefreshBaseInfo()
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function Component:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then return end
    if CurInputDevice == UE4.ECommonInputType.Touch then return end
    self.CurGamepadName = CurGamepadName
    local IsUseGamepad = CurInputDevice == ECommonInputType.Gamepad
    if (IsUseGamepad) then
        self.BeginKey:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.BeginKey:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.CurInputDevice = CurInputDevice
end

function Component:InitGamePadKey()
    self.BeginKey:CreateCommonKey({
        KeyInfoList = {{Type="Img", ImgShortPath="X"}},
        ClickCallback = self.OnBeginBtnClicked,
        Owner = self,
    })
end

function Component:HandleGamepadInput(InKeyName)
    if InKeyName == Const.LeftShoulder then          -- LB
        self:ScrollToPreviousItem()
        return true
    elseif InKeyName == Const.RightShoulder then     -- RB
        self:ScrollToNextItem()
        return true
    elseif InKeyName == Const.FaceButtonLeft then    -- X
        self:OnBeginBtnClicked()
        return true
    elseif InKeyName == Const.FaceButtonTop then     -- Y
        if self.Btn_Arward and self.Btn_Arward.HandleKeyDownOnGamePad then
            self.Btn_Arward:HandleKeyDownOnGamePad(InKeyName)
        end
        return true
    elseif InKeyName == Const.FaceButtonRight then   -- B
        self:CloseSelf()
        return true
    end
    return false
end

function Component:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    -- if CurInputDevice == UE4.ECommonInputType.Touch then return end
    -- local bGamepad = CurInputDevice == UE4.ECommonInputType.Gamepad
    -- if bGamepad then
    -- else
    -- end
end

return Component

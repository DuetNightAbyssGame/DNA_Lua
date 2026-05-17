local Component = {}

function Component:OnGamepadKeyDown(InKeyName)
    if InKeyName == "Gamepad_Special_Left" then -- View
        if not self.Book:GetIsClueUi() then
            return
        end
        self.Book:OnClickButton()
        self:AddTimer(0.1, function()
            self:SetDefaultFocus()
        end)
        self.Btn_Associate.Key_GamePad:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    elseif InKeyName == "Gamepad_FaceButton_Left" then --X键
        if not self.Book:GetIsClueUi() then
            return
        end
        self:OnClickButtonAssociate()
    elseif InKeyName == "Gamepad_FaceButton_Right" then -- B键
        if self.Book:GetIsClueUi() then
            self:OnClickBackButton()
        else
            self.Book:OnClickClose()
            self:SetDefaultFocus()
            self.Btn_Associate.Key_GamePad:SetVisibility(UIConst.VisibilityOp["Visible"])
        end
    end
    -- 等待一帧确保布局完成
    self:AddTimer(0.1, function()
        self:RefreshTabGamepadIcon()
    end)
end

function Component:InitGamePadUI()
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    self.Btn_Associate.Key_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "X",
            },
        },
    })

    self.Book.Btn_QaBook.Key_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "View",
            },
        },
    })
end

function Component:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        DebugPrint("thy    已经显示的是该输入模式，不需要进行刷新")
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    self.IsSwitchDevice = true
    --更新UI
    if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
        self:SwitchMainUIToPCOrMoble()
    elseif self.CurInputDeviceType == ECommonInputType.Gamepad then
        self:SwitchMainUIToGamePad()
        self:SetDefaultFocus()
    end
end

function Component:SetDefaultFocus()
    if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
        return
    end
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    if self.IsClueEmpty then
        if self.Book:GetIsClueUi() then
            self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
            self:SetFocus()
        else
            self.Book:SetFocus()
        end
    else
        if self.Book:GetIsClueUi() then
            self.Clue_01.Btn_Click:SetFocus()
        else
            self.Book:SetFocus()
        end
    end
end

function Component:SwitchMainUIToGamePad()
    if self.Book:GetIsClueUi() then
        self.Btn_Associate.Key_GamePad:SetVisibility(UIConst.VisibilityOp["Visible"])
    end
    self.Book.Btn_QaBook.Key_GamePad:SetVisibility(UIConst.VisibilityOp["Visible"])
    if self.Book.WS_Controller then
        self.Book.WS_Controller:SetActiveWidgetIndex(1)
    end
    self:RefreshTabGamepadIcon()
end

function Component:SwitchMainUIToPCOrMoble()
    if self.Book.WS_Controller then
        self.Book.WS_Controller:SetActiveWidgetIndex(0)
    end
    self.Btn_Associate.Key_GamePad:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    self.Book.Btn_QaBook.Key_GamePad:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function Component:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Gamepad_RightY") then
        local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 30
        local CurScrollOffset = self.Book.EMScrollBox_100:GetScrollOffset()
        local ScrollOffset = math.clamp(CurScrollOffset - a,0, self.Book.EMScrollBox_100:GetScrollOffsetOfEnd())
        self.Book.EMScrollBox_100:SetScrollOffset(ScrollOffset)
    end
    return UWidgetBlueprintLibrary.Unhandled()
end

function Component:RefreshTabGamepadIcon()
    if ModController:IsMobile() then
        return
    end
    -- 创建一个表来存储所有按键提示
    local keyInfos = {}
    -- 检查是否为线索UI并有可滚动内容，先添加滚动按键提示
    if self.Book:GetIsClueUi() then
        if self.Book.EMScrollBox_100:GetScrollOffsetOfEnd() > 0 then
            table.insert(keyInfos, {"RV", GText("UI_CTL_Rougelike_SlideItems")})
        end

        if not self.IsClueEmpty then
            if (self.CurrentReasoningState == 3) then
                table.insert(keyInfos, {"A", GText("UI_CTL_Select/Cancel")})
            end
            if (self.CurrentReasoningState == 2) then
                if(self.IsCommitAnswerMultiSelect) then
                    table.insert(keyInfos, {"A", GText("UI_CTL_Select/Cancel")})
                else
                    table.insert(keyInfos, {"A", GText("UI_CTL_Select")})
                end
            end
        end
    end

    if self.Book:GetIsClueUi() then
        table.insert(keyInfos, {"B", GText("UI_Tips_Close")})
    else
        table.insert(keyInfos, {"A", GText("UI_CTL_Select")})
        table.insert(keyInfos, {"B", GText("Impression_UI_Back")})
    end

    self.Tab:UpdateBottomKeyInfo_Quick(keyInfos)
end
return Component
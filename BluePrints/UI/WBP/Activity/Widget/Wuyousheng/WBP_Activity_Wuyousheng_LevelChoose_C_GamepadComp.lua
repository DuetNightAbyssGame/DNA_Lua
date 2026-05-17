local Component = {}

function Component:InitGamePad()
    if ModController:IsMobile() then
        return
    end
    self.Btn_Start.Key_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "X"
            }
        }
    })
    self.Key_Monster:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "LS"
            }
        }
    })
end

function Component:HandleGamepadInput(InKeyName)
    local IsHandled = true
    if (InKeyName == "Gamepad_FaceButton_Left") then
        if self.FocusMode ~= 1 then
            return true
        end
        self:BtnStartOnClicked()
    elseif (InKeyName == "Gamepad_FaceButton_Top") then
        if self.FocusMode ~= 1 then
            return true
        end
        self.Root.RewardText:OnBtnClicked()
    elseif (InKeyName == "Gamepad_LeftThumbstick") then
        if self.FocusMode ~= 1 then
            return true
        end
        self.WidgetList[1]:SetFocus()
        self:ChangeFocusMode(2)
    elseif (InKeyName == "Gamepad_FaceButton_Right") then
        if self.FocusMode == 1 then
            self:OnReturnKeyDown()
        elseif self.FocusMode == 2 then
            self:SetDefaultFocus()
        end
    else
        IsHandled = false
    end
    return IsHandled
end

function Component:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    --- 切换手柄端相关图标显隐
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end

    self:SetDefaultFocus()
    self.IsUseGamePad = CurInputDevice == ECommonInputType.Gamepad
    if (self.IsUseGamePad) then
        self.Btn_Start.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Key_Monster:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Btn_Start.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Key_Monster:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function Component:SetDefaultFocus()
    -- 如果当前没有焦点就返回
    if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
        return
    end
    self:ChangeFocusMode(1)
    if self.SelectedIndex and self.LevelTabList and self.LevelTabList[self.SelectedIndex] then
        self.LevelTabList[self.SelectedIndex]:SetFocus()
        return
    end
    local Item = self.HB_List:GetChildAt(0)
    if Item then
        Item.LevelTab_1:SetFocus()
    end
end

function Component:UpdateBottomKeyInfo(FocusMode)
    local BottomKeyInfo = {}
    if FocusMode == 1 then
        BottomKeyInfo = { { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root,}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
    elseif FocusMode == 2 then
        BottomKeyInfo = { { GamePadInfoList = {{Type="Img", ImgShortPath="A"}}, Desc = GText("UI_Controller_CheckDetails"), bLongPress = false},
        { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root,}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
    elseif FocusMode == 3 then
        BottomKeyInfo = {}
    end
    self.Root.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
end

function Component:UpdateGamepadKeyInfo(FocusMode)
    if FocusMode == 1 then
        self.Btn_Start.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Key_Monster:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    elseif FocusMode == 2 then
        self.Btn_Start.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Key_Monster:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function Component:ChangeFocusMode(FocusMode)
    self.FocusMode = FocusMode
    self:UpdateBottomKeyInfo(self.FocusMode)
    self:UpdateGamepadKeyInfo(self.FocusMode)
end

return Component
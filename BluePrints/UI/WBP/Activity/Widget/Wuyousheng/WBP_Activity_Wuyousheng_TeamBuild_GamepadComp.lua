local Component = {}

function Component:InitGamePad()
    if ModController:IsMobile() then
        return
    end
    self.Btn_Save.Key_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "X"
            }
        }
    })
    self.Btn_Clear.Key_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "LS"
            }
        }
    })
    self.Btn_SwitchMod.Key_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Y"
            }
        }
    })
    self.Key_Controller_L:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "LB"
            }
        }
    })
    self.Key_Controller_R:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "RB"
            }
        }
    })
    self.Key_L:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Text",
                Text = "Q"
            }
        }
    })
    self.Key_R:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Text",
                Text = "E"
            }
        }
    })
end

function Component:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    --- 切换手柄端相关图标显隐
    if (CurInputDevice == ECommonInputType.Touch) then
        self.Switch_Mode_L:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Switch_Mode_R:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end

    self:SetDefaultFocus()
    self.IsUseGamePad = CurInputDevice == ECommonInputType.Gamepad
    if (self.IsUseGamePad) then
        self.Btn_Save.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Clear.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_SwitchMod.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Switch_Mode_L:SetActiveWidgetIndex(1)
        self.Switch_Mode_R:SetActiveWidgetIndex(1)
    else
        self.Btn_Save.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Clear.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_SwitchMod.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Switch_Mode_L:SetActiveWidgetIndex(0)
        self.Switch_Mode_R:SetActiveWidgetIndex(0)
        self.Switch_Mode_L:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Switch_Mode_R:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

function Component:HandleGamepadInput(InKeyName)
    local IsHandled = false
    if self.IsTabPrimaryVisible and self.FocusMode ~= 1 then
        if InKeyName == "Gamepad_LeftShoulder" then
            self.Type_Melee:OnBtnClicked()
            IsHandled = true
            self.List_Select:NavigateToIndex(0)
            return IsHandled
        elseif InKeyName == "Gamepad_RightShoulder" then
            self.Type_Range:OnBtnClicked()
            IsHandled = true
            self.List_Select:NavigateToIndex(0)
            return IsHandled
        end
    end
    if  self.FocusMode == 3 or self.FocusMode == 2 then
        if InKeyName == "Gamepad_LeftThumbstick" and not self.bListEmpty then
            self:ChangeFocusMode(4)
            self.Sort:SetFocus()
            IsHandled = true
            return IsHandled
        end
    end
    if self.FocusMode == 1 then
        if InKeyName == "Gamepad_FaceButton_Left" then
            self:OnSaveClicked()
            IsHandled = true
        elseif InKeyName == "Gamepad_LeftThumbstick" then
            self:OnClearClicked()
            IsHandled = true
        elseif InKeyName == "Gamepad_FaceButton_Top" then
            self:OnSwitchModClicked()
            IsHandled = true
        elseif InKeyName == "Gamepad_FaceButton_Right" then
            self:OnReturnKeyDown()
            IsHandled = true
        end
    end
    if self.FocusMode == 2 then
        if InKeyName == "Gamepad_FaceButton_Right" then
            self.FocusWidget:SetFocus()
            IsHandled = true
            self:ChangeFocusMode(1)
        end
    end
    if self.FocusMode == 3 then
        if InKeyName == "Gamepad_FaceButton_Right" then
            self.FocusWidget:SetFocus()
            IsHandled = true
            self:ChangeFocusMode(1)
        end
    end
    if self.FocusMode == 4 then
        if InKeyName == "Gamepad_FaceButton_Right" then
            IsHandled = true
            self.List_Select:SetFocus()
            self:ChangeFocusMode(2)
        end
    end
    return IsHandled
end

function Component:SetDefaultFocus()    
    self:ChangeFocusMode(1)
    if self.FocusWidget then
        self.FocusWidget:SetFocus()
        return
    end
    self.Character:SetFocus()
end

function Component:UpdateBottomKeyInfo(FocusMode)
    local BottomKeyInfo = {}
    if FocusMode == 1 then
        BottomKeyInfo = { { GamePadInfoList = {{Type="Img", ImgShortPath="A"}}, Desc = GText("UI_Tips_Ensure"), bLongPress = false},
        { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
    elseif FocusMode == 2 then
        if self.CurSlotType ~= "Char" then
            BottomKeyInfo = {{ KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
        else
            BottomKeyInfo = { { GamePadInfoList = {{Type="Img", ImgShortPath="A"}}, Desc = GText("UI_CTL_Add/Remove"), bLongPress = false},
            { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
        end
    elseif FocusMode == 3 then
        BottomKeyInfo = {{ KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
    elseif FocusMode == 4 then
        BottomKeyInfo = { { GamePadInfoList = {{Type="Img", ImgShortPath="A"}}, Desc = GText("UI_Tips_Ensure"), bLongPress = false},
        { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
    end
    self.Root.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
end

function Component:UpdateGamepadKeyInfo(FocusMode)
    if FocusMode == 1 then
        self.Btn_Clear.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_SwitchMod.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Save.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Switch_Mode_L:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Switch_Mode_R:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Sort:SetControllerKeyHidden(true)
    elseif FocusMode == 2 then
        self.Btn_Clear.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_SwitchMod.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Save.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Switch_Mode_L:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Switch_Mode_R:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Sort:SetControllerKeyHidden(false)
    elseif FocusMode == 4 then
        self.Btn_Clear.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_SwitchMod.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Save.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Switch_Mode_L:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Switch_Mode_R:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Sort:SetControllerKeyHidden(false)
    end
end

function Component:ChangeFocusMode(FocusMode)
    self.FocusMode = FocusMode
    self:UpdateBottomKeyInfo(self.FocusMode)
    self:UpdateGamepadKeyInfo(self.FocusMode)
end

function Component:InitNavigation()
    self.List_Select:SetNavigationRuleCustom(EUINavigation.Right, {self, function()
        self:ChangeFocusMode(3)
        return self.EMListView_Filter
    end})
    self.EMListView_Filter:SetNavigationRuleCustom(EUINavigation.Left, {self, function()
        if self.bListEmpty then
            return nil
        else
            self:ChangeFocusMode(2)
            return self.List_Select
        end
    end})
    self:AddTimer(0.2, function()
        if self.LastWidget then
            self.LastWidget:SetAllNavigationRules(EUINavigationRule.Escape, 0)
            self.LastWidget = nil
        end
        local Index = #self.FilteredContents
        local LastItem = self.List_Select:GetItemAt(Index-1)
        if not LastItem or not LastItem.SelfWidget then
            return
        end
        local LastWidget = LastItem.SelfWidget
        LastWidget:SetNavigationRuleExplicit(EUINavigation.Right, self.EMListView_Filter)
        self.LastWidget = LastWidget
    end,false, 0, "DelayInitNavigation",true)
end

-- 给聚焦到sort的时候返回用的
function Component:SetFocus_Lua()
    if self.FocusMode == 4 then
        self:ChangeFocusMode(2)
        self.List_Select:SetFocus()
        return
    end
end

return Component
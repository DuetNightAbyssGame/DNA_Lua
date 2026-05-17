local Component = {}

function Component:InitGamePad()
    if ModController:IsMobile() then
        return
    end
    self.Btn_Start.Controller:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "X"
            }
        }
    })
    self.Btn_Clear.Controller:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Menu"
            }
        }
    })
    self.Listing.Key_Controller_L:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "LB"
            }
        }
    })
    self.Listing.Key_Controller_R:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "RB"
            }
        }
    })
    self.Listing.Key_L:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Text",
                Text = "Q"
            }
        }
    })
    self.Listing.Key_R:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Text",
                Text = "E"
            }
        }
    })
    self.Preview.Btn_Bag.Controller:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "X"
            }
        }
    })
end

function Component:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    --- 切换手柄端相关图标显隐
    self.CurInputDeviceType = CurInputDevice
    if (CurInputDevice == ECommonInputType.Touch) then
        self.Listing.Switch_Mode_L:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Listing.Switch_Mode_R:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end
    self.IsUseGamePad = CurInputDevice == ECommonInputType.Gamepad
    if (self.IsUseGamePad) then
        self.Btn_Clear.Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Start.Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Btn_Clear.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Start.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if self:GetVisibility() == UE4.ESlateVisibility.Collapsed then
        return
    end
    self:SetDefaultFocus()
end

function Component:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Gamepad_RightY") then
        if not IsValid(self.Preview) then
            return
        end
        local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 30
        local CurScrollOffset = self.Preview.EMScrollBox_1:GetScrollOffset()
        local ScrollOffset = math.clamp(CurScrollOffset - a,0, self.Preview.EMScrollBox_1:GetScrollOffsetOfEnd())
        self.Preview.EMScrollBox_1:SetScrollOffset(ScrollOffset)
    end
    return UWidgetBlueprintLibrary.Unhandled()
end

function Component:HandleGamepadInput(InKeyName)
    local IsHandled = false
    DebugPrint("jly     FocusMode: " .. self.FocusMode)
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
        if InKeyName == "Gamepad_Special_Right" then
            self:OnClearClicked()
            IsHandled = true
        elseif InKeyName == "Gamepad_FaceButton_Left" then
            self:OnStartClicked()
            IsHandled = true
        elseif InKeyName == "Gamepad_FaceButton_Top" then
            if self.FocusWidget then
                self.FocusWidget:OnMinusClicked()
            end
            IsHandled = true
        elseif InKeyName == "Gamepad_FaceButton_Right" then
            self:OnReturnKeyDown()
            IsHandled = true
        elseif InKeyName == "Gamepad_RightThumbstick" then
            if self.Root.Com_Tab.WBP_Com_Tab_ResourceBar then
                self.Root.Com_Tab.WBP_Com_Tab_ResourceBar:SetFocus()
            end
            IsHandled = true
            self:ChangeFocusMode(5)
            self.Root.Com_Tab.WBP_Com_Tab_ResourceBar:SetLastFocusWidget(self.FocusWidget)
            self.Root.Com_Tab.WBP_Com_Tab_ResourceBar:SetGetReplyOnBack(function()
                self:ChangeFocusMode(1)
            end)
        end
    elseif self.FocusMode == 2 then
        if InKeyName == "Gamepad_FaceButton_Right" then
            self.FocusWidget:SetFocus()
            IsHandled = true
            self:ChangeFocusMode(1)
        end
    elseif self.FocusMode == 3 then
        if InKeyName == "Gamepad_FaceButton_Right" then
            self.FocusWidget:SetFocus()
            IsHandled = true
            self:ChangeFocusMode(1)
        end
    elseif self.FocusMode == 4 then
        if InKeyName == "Gamepad_FaceButton_Right" then
            IsHandled = true
            self.List_Select:SetFocus()
            self:ChangeFocusMode(2)
        end
    elseif self.FocusMode == 6 then
        if InKeyName == "Gamepad_FaceButton_Right" then
            IsHandled = true
            self.Build.Bag.Btn_Click:SetFocus()
            self:ChangeFocusMode(1)
            self.Build.Bag:SetVisibility(UE4.ESlateVisibility.Visible)
        elseif InKeyName == "Gamepad_FaceButton_Left" then
            IsHandled = true
            self:OnPreviewBagClicked()
        end
    elseif self.FocusMode == 7 then
        if InKeyName == "Gamepad_FaceButton_Right" then
            IsHandled = true
            self:CloseTips()
            self:ChangeFocusMode(2)
            self.Listing.TileView_Select_Role:SetFocus()
        elseif InKeyName == "Gamepad_FaceButton_Left" then
            IsHandled = true
            if self.CurGamepadArea == "Tip" then
                if self.CurSlotType == "Pet" then
                    self:MakeSureCallback()
                else
                    if self.SquadItemTip then
                        self:MakeSureCallback(self.SquadItemTip.Edit_Tips.SelectModIndex)
                    end
                end
            end
            self:ChangeFocusMode(2)
            self.Listing.TileView_Select_Role:SetFocus()
        elseif InKeyName == "Gamepad_Special_Left" then
            IsHandled = true
            self:GoToArmory()
        end
    end
    return IsHandled
end

function Component:SetDefaultFocus()
    self:ChangeFocusMode(1)
    self.FocusWidget = self.Build.Character
    self.Build.Character:SetFocus()
end

-- 从其他界面跳转回来时恢复聚焦
function Component:RestoreFocusOnReturn()
    if self.FocusMode == 6 then
        self.SelectBagContent.UI:SetFocus()
    elseif self.FocusMode == 7 then
        self:ChangeFocusMode(2)
        self:AddTimer(0.2, function()
            -- self.Listing.TileView_Select_Role:SetFocus()
            self.FocusWidget:SetFocus()
        end)
    end
end

function Component:UpdateBottomKeyInfo(FocusMode)
    if ModController:IsMobile() then
        return
    end
    local BottomKeyInfo = {}
    if FocusMode == 1 then
        if not self.FocusWidget.IsEmpty then
            BottomKeyInfo = { { GamePadInfoList = {{Type="Img", ImgShortPath="Y"}}, Desc = GText("UI_CTL_Clear"), bLongPress = false},
            { GamePadInfoList = {{Type="Img", ImgShortPath="A"}}, Desc = GText("UI_Tips_Ensure"), bLongPress = false},
            { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
        else
            BottomKeyInfo = { { GamePadInfoList = {{Type="Img", ImgShortPath="A"}}, Desc = GText("UI_Tips_Ensure"), bLongPress = false},
            { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
        end
    elseif FocusMode == 2 then
        if self.CurSlotType ~= "Char" then
            BottomKeyInfo = {{ KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
        else
            BottomKeyInfo = { { GamePadInfoList = {{Type="Img", ImgShortPath="A"}}, Desc = GText("UI_Tips_Ensure"), bLongPress = false},
            { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
        end
    elseif FocusMode == 3 then
        BottomKeyInfo = {{ KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
    elseif FocusMode == 4 then
        BottomKeyInfo = { { GamePadInfoList = {{Type="Img", ImgShortPath="A"}}, Desc = GText("UI_Tips_Ensure"), bLongPress = false},
        { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
    elseif FocusMode == 6 then
        if self.Preview.EMScrollBox_1:GetScrollOffsetOfEnd() > 0 then
            BottomKeyInfo = { { GamePadInfoList = {{Type="Img", ImgShortPath="RV"}}, Desc = GText("UI_Controller_Slide"), bLongPress = false},
            { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
        else
            BottomKeyInfo = {{ KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
        end
    elseif FocusMode == 7 then
        BottomKeyInfo = { { GamePadInfoList = {{Type="Img", ImgShortPath="A"}}, Desc = GText("UI_CTL_Select"), bLongPress = false},
        { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
    end
    self.Root.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
end

function Component:UpdateGamepadKeyInfoByHasItem(HasItem)
    local BottomKeyInfo = {}
    if HasItem then
        BottomKeyInfo = { { GamePadInfoList = {{Type="Img", ImgShortPath="Y"}}, Desc = GText("UI_CTL_Clear"), bLongPress = false},
        { GamePadInfoList = {{Type="Img", ImgShortPath="A"}}, Desc = GText("UI_Tips_Ensure"), bLongPress = false},
        { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
    else
        BottomKeyInfo = { { GamePadInfoList = {{Type="Img", ImgShortPath="A"}}, Desc = GText("UI_Tips_Ensure"), bLongPress = false},
        { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
    end
    self.Root.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
end

function Component:UpdateGamepadKeyInfo(FocusMode)
    if FocusMode == 1 and self.IsUseGamePad then
        self.Btn_Start.Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Clear.Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Btn_Start.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Clear.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if FocusMode == 6 then
        self.Preview.Btn_Bag.Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Preview.Btn_Bag.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

-- self.FocusMode
-- 1: 默认模式
-- 2: 聚焦到左边角色选择
-- 3: 聚焦到类型选择
-- 4: 聚焦到sort栏
-- 5：聚焦到货币栏
-- 6: 聚焦到背包选择
-- 7: 打开弹窗模式
function Component:ChangeFocusMode(FocusMode)
    self.FocusMode = FocusMode
    self:UpdateBottomKeyInfo(self.FocusMode)
    self:UpdateGamepadKeyInfo(self.FocusMode)
end

function Component:InitNavigation()
    self.List_Select:SetNavigationRuleCustom(EUINavigation.Left, {self, function()
        self:ChangeFocusMode(3)
        return self.EMListView_Filter
    end})
    self.EMListView_Filter:SetNavigationRuleCustom(EUINavigation.Right, {self, function()
        if self.bListEmpty then
            return nil
        else
            self:ChangeFocusMode(2)
            return self.List_Select
        end
    end})
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
local Component = {}
local ModModel = ModController:GetModel()

function Component:InitGamePad()
    if ModController:IsMobile() then return end
    self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
        self:AddTimer(0.1, function()
            self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
        end)
    end

    self.Mod_Plan.Key_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Menu",
                ClickCallback = function()
                    UIManager():MarkKeyLongPressSuccess(UIConst.GamePadKey.SpecialRight)
                    ModController:SetSelectedStuff(nil,nil)
                    self.Mod_Plan.Btn_Plan:SetFocus()
                    self.IsFocusInSpecialItem = true
                end
            }
        },
        bLongPress = true,
    })

    self.Btn_EditPolarity:SetDefaultGamePadImg("RS")
    self.Key_Search:CreateCommonKey({
        KeyInfoList = {{Type="Img", ImgShortPath="LS"}}
    })
    self.Btn_Auto:SetDefaultGamePadImg("Y")
    self.Btn_Discharge:SetDefaultGamePadImg("X")
    self.Btn_Discharge:TryOverrideLongPressClickFunc(function()
        if self.IsOpenModDetailPanel then
            return
        end
        self:FocusListSelectMod()
    end)
    self.Common_PolarityList_PC.Key_LT:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "LT"
            }
        }
    })
    self.Common_PolarityList_PC.Key_RT:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "RT"
            }
        }
    })
    self.Key_FocusList_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "X",
            }
        },
        Desc = GText("UI_CTL_Focus_ModList")
    })
    self.Key_SelectMod_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "A",
            }
        },
        Desc = GText("UI_CTL_Select_Mod")
    })
end

function Component:FocusListSelectMod()
    if self.needNavigation then
        self.List_Select_Mod:SetFocus()
        self.IsFocusInSpecialItem = false
    end
end

--手柄监听
function Component:Handle_OnGamePadDown(InKeyName)
    DebugPrint("thy    Handle_OnGamePadDown", InKeyName)
    -- 极性调整会有另一套操作方式
    if (ModModel.PolarityEditModeData ~= nil) then
        if (InKeyName == "Gamepad_FaceButton_Top" ) then -- Y键确认
            self.PolarityEditWidget.Button_Purchase:OnBtnClicked()
            self.Mod_1:SetFocus()
            return true
        elseif (InKeyName == "Gamepad_LeftShoulder") then -- LB
            self:UpdatePolarityListIndex(-1)
            return true
        elseif (InKeyName == "Gamepad_RightShoulder") then -- RB
            self:UpdatePolarityListIndex(1)
            return true
        elseif (InKeyName == "Gamepad_LeftThumbstick") then -- LS
            self.PolarityEditWidget.Btn_Reset:OnBtnClicked()
            return true
        elseif (InKeyName == "Gamepad_FaceButton_Right" ) then -- B键退出
            self:Close()
            return true
        elseif (InKeyName == "Gamepad_RightThumbstick") then -- R键按下
            local ResourceBar = self.Tab_Mod.WBP_Com_Tab_ResourceBar or self.Tab_Mod.Panel_ResourceBar
            self.IsFocusOnResourceBar = true
            ResourceBar:SetFocus()
            return true
        end
    else
        if ModModel:IsModUIPreview() then
            if (InKeyName == "Gamepad_Special_Left") then -- View
                -- 聚焦到Btn_Info
                self.Btn_Info:SetFocus()
                self.Key_Gamepad:SetVisibility(UIConst.VisibilityOp.Collapsed)
                self.IsFocusInSpecialItem = true
                return true
            elseif (InKeyName == "Gamepad_FaceButton_Right" ) then -- B键
                if(self.IsFocusInSpecialItem) then
                    self:SetFocus()
                    self.IsFocusInSpecialItem = false
                    self.Key_Gamepad:SetVisibility(UIConst.VisibilityOp.Visible)
                    return true
                end
                if(not (self.List_Role:HasFocusedDescendants() or self.List_Role:HasAnyUserFocus())) then
                    self.List_Role:SetFocus()
                    ModController:SetSelectedStuff(nil, nil)
                    return true
                end
                self:Close()
                return true
            elseif (InKeyName == "Gamepad_LeftTrigger") then -- LT
                self:ChangePolarityListIndex(-1)
                return true
            elseif (InKeyName == "Gamepad_RightTrigger") then -- RT
                self:ChangePolarityListIndex(1)
                return true
            elseif (InKeyName == "Gamepad_LeftShoulder") then -- LB
                self.Tab_Atrr:TabToLeft()
                return true
            elseif (InKeyName == "Gamepad_RightShoulder") then -- RB
                self.Tab_Atrr:TabToRight()
                return true
            end
            return false
        end
        -- 先判断一下是不是选中mod的状态
        if(ModModel:GetGamePadSelectedStuff()) then
            if (InKeyName == "Gamepad_FaceButton_Right" ) then -- B键
                self:RecoverFromGamepad()
                if(self.LastFocusedItemBeforeSelection) then
                    self.LastFocusedItemBeforeSelection:SetFocus()
                end
                ModModel:SetGamePadSelectedStuff(nil, nil)
                ModController:SetSelectedStuff(nil, nil)
                return true
            else
                return true
            end
        end
        if(self.IsOpenModDetailPanel) then
            if (InKeyName == "Gamepad_FaceButton_Top") then -- Y键
                ModController:OpenModIntensify()
                return true
            elseif (InKeyName == "Gamepad_FaceButton_Left") then -- X键
                local EquipedSlotId = ModModel:GetSelectStuff().SlotId
                if EquipedSlotId then
                    ModController:SendTakeOffMod(ModModel:GetTarget(), EquipedSlotId)
                else
                    ModController:QuickEquipMod(ModModel:GetSelectStuff().ModUuid)
                end
                ModModel:SetGamePadSelectedStuff(nil, nil)
                return true
            end
        end
        if (InKeyName == "Gamepad_FaceButton_Right" ) then -- B键
            if(ModModel.PolarityEditModeData ~= nil) then
                return false
            end
            if(self.LastSelectedItem and self.IsFocusInSpecialItem) then
                self.LastSelectedItem:SetFocus()
                self.IsFocusInSpecialItem = false
                self.Key_Gamepad:SetVisibility(UIConst.VisibilityOp.Visible)
                return true
            end
            if(not (self.List_Role:HasFocusedDescendants() or self.List_Role:HasAnyUserFocus())) then
                self.List_Role:SetFocus()
                ModController:SetSelectedStuff(nil, nil)
                return true
            end
            self:Close()
            return true
        elseif (InKeyName == "Gamepad_FaceButton_Left") then -- X键
            if(not self.IsGamePadXIsPressing) then
                self.IsGamePadXIsPressing = true
                self.Btn_Discharge:OnBtnPressed()
            end
            if (self.Btn_Discharge:IsBtnForbidden()) then
                self:FocusListSelectMod()
            end
            return true
        elseif (InKeyName == "Gamepad_FaceButton_Top") then -- Y键
            if ModModel:IsModUINormal() then
                self:OnClickBtnAutoEquip()
            end
            return true
        elseif (InKeyName == "Gamepad_Special_Right") then -- 菜单键
            self.Mod_Plan.Key_GamePad:OnShortCutPressed()
            return true    
        elseif (InKeyName == "Gamepad_LeftTrigger") then -- LT
            self:ChangePolarityListIndex(-1)
            return true
        elseif (InKeyName == "Gamepad_RightTrigger") then -- RT
            self:ChangePolarityListIndex(1)
            return true
        elseif (InKeyName == "Gamepad_LeftShoulder") then -- LB
            self.Tab_Atrr:TabToLeft()
            return true
        elseif (InKeyName == "Gamepad_RightShoulder") then -- RB
            self.Tab_Atrr:TabToRight()
            return true
        elseif (InKeyName == "Gamepad_RightThumbstick") then -- R键按下
            self.Btn_EditPolarity:OnBtnClicked()
            return true
        elseif (InKeyName == "Gamepad_LeftThumbstick") then -- L键按下
            self.Com_Search:SetFocus()
            self.IsFocusInSpecialItem = true
            return true
        elseif (InKeyName == "Gamepad_Special_Left") then -- View
            -- 聚焦到Btn_Info
            self.Btn_Info:SetFocus()
            self.Key_Gamepad:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.IsFocusInSpecialItem = true

            -- 装备魔之楔推荐，长按满了，会将上面三行的状态复原
            if not self.Btn_Recommend:HasAnyUserFocus() and not self.Btn_Delete:HasAnyUserFocus() then
                if ModModel:IsRecommendModState() then
                    self.Btn_Delete.Key_Gamepad:OnShortCutPressed()
                else
                    self.Btn_Recommend.Key_Gamepad:OnShortCutPressed()
                end
            else
                --在抬起的时候
            end

            return true
        end
    end
    return false
end

function Component:Handle_OnGamePadUp(InKeyName)
    DebugPrint("thy    Handle_OnGamePadDown", InKeyName)
    if (InKeyName == "Gamepad_FaceButton_Top") then -- Y键
        if ModModel:IsModUICopyMode() then
            self.Btn_Import:OnBtnClicked()
        return true
        end
    elseif (InKeyName == "Gamepad_FaceButton_Left") then -- X键
        self.IsGamePadXIsPressing = false
        self.Btn_Discharge:OnBtnReleased()
        if not self.Btn_Discharge.IsForbidden then
            self.Btn_Discharge:OnBtnClicked()
        end
        return true
    elseif (InKeyName == "Gamepad_Special_Right") then -- 菜单键
        self.Mod_Plan.Key_GamePad:OnShortCutReleased()
        if not UIManager():CheckAndCleanKeyLongPressSuccess(InKeyName) then
            if self.ItemDetailsWidget then
                local DetailContent = self.ItemDetailsWidget.Content
                if self.ItemDetailsWidget:IsVisible() and DetailContent then
                    self.ItemDetailsWidget.Btn_Locked:OnBtnPressed()
                    self.ItemDetailsWidget.Btn_Locked:OnBtnReleased()
                end
            end
        end
        return true
    elseif (InKeyName == "Gamepad_Special_Left") then -- 菜单键
        if self.Btn_Recommend:HasAnyUserFocus() then
            self.Btn_Recommend.Key_Gamepad:OnShortCutReleased()
            --self.Btn_Recommend:OnButtonClicked()
            --self.Btn_Recommend:SetGamePadIconVisible(false)
        elseif self.Btn_Delete:HasAnyUserFocus() then
            self.Btn_Delete.Key_Gamepad:OnShortCutReleased()
            --self.Btn_Delete:OnButtonClicked()
            --self.Btn_Delete:SetGamePadIconVisible(false)
        else
            if ModModel:IsRecommendModState() then
                self.Btn_Delete.Key_Gamepad:OnShortCutReleased()
            else
                self.Btn_Recommend.Key_Gamepad:OnShortCutReleased()
            end
        end

        return true
    end
    return false
end

function Component:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Gamepad_RightY") then
        if not IsValid(self.ItemDetailsWidget) then
            return UWidgetBlueprintLibrary.Unhandled()
        end
        local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 30
        local CurScrollOffset = self.ItemDetailsWidget.EMScrollBox_1:GetScrollOffset()
        local ScrollOffset = math.clamp(CurScrollOffset - a,0, self.ItemDetailsWidget.EMScrollBox_1:GetScrollOffsetOfEnd())
        self.ItemDetailsWidget.EMScrollBox_1:SetScrollOffset(ScrollOffset)
    end
    return UWidgetBlueprintLibrary.Unhandled()
end

function Component:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if not ModController:IsGamepad() then
        self.Btn_Discharge:SetButtonIsLongPress(false)
        self:SetKeySelectModGamePad(nil)
        self.IsFocusInSpecialItem = false
    else
        self.Btn_Discharge:SetButtonIsLongPress(true)
        self.Btn_Discharge:SetDefaultGamePadImg("X")
    end
    if UIManager(self):GetLastestAndFocusableUIWidgetObj() ~= self then
        return 
    end
    if ModController:IsMobile() then
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    self.IsSwitchDevice = true
    --更新UI
    if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
        self:SwitchMainUIToPCOrMoble()
    else
        self:SwitchMainUIToGamePad()
    end

    if self.RecommendView and self.RecommendView:GetVisibility() == UIConst.VisibilityOp.Visible then
        self.RecommendView:SetRecommendFocus()
    end
end

function Component:BP_GetDesiredFocusTarget()
    if ModModel:IsInAutoEquip() then return nil end
    if not ModController:IsGamepad() then return self end
    return self:SetDefaultGamepadFocus()
end

function Component:SwitchMainUIToPCOrMoble()
    if self.Key_Gamepad then
        self.Key_Gamepad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.List_Attribute then
        self.List_Attribute:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    self:RecoverFromGamepad()
    self.Mod_Plan.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Common_PolarityList_PC.Key_LT:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Common_PolarityList_PC.Key_RT:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Key_FocusList_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.List_Role:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.CheckBox_Mod:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Key_Search:SetVisibility(UIConst.VisibilityOp.Collapsed)
    ModModel:SetGamePadSelectedStuff(nil,nil)
    self.IsFocusOnResourceBar = false
end

function Component:SetDefaultGamepadFocus()
    -- 如果是极性模式，那么就要聚焦到Mod_1
    if (ModModel.PolarityEditModeData ~= nil) or ModModel:IsModUIPreview() then
        self.Mod_1:SetFocus()
        return self.Mod_1
    else
        -- 如果当前有选中的Mod，那么就聚焦到选中的Mod
        local SelectStuff = ModModel:GetSelectStuff()
        if(SelectStuff) then
            if(SelectStuff.SlotId) then
                self.ModSlotUIs[SelectStuff.SlotId]:SetFocus()
                self.LastSelectedItem = self.ModSlotUIs[SelectStuff.SlotId]
            elseif(SelectStuff.ModUuid) then
                -- 限制Mod的导航范围
                for j = 1, 8 do
                    local mod = self["Mod_" .. j]
                    if mod then
                        mod:SetNavigationRuleCustom(EUINavigation.Down, {self, function()
                            return self:OnUINavigationMod(mod, EUINavigation.Down, true)
                        end})
                    end
                end
                self.Mod_1:SetFocus()
                return self.Mod_1
            end
        end
    end
    if self.LastSelectedItem then
        return self.LastSelectedItem
    end
    self.LastSelectedItem = self.List_Role
    return self.List_Role
end

function Component:SwitchMainUIToGamePad()
    if self.Key_Gamepad then
        self.Key_Select:CreateCommonKey({
            KeyInfoList={
                    {
                        Type = "Img",
                        ImgShortPath = "View"
                    }
                },
                Desc = GText("UI_Controller_Check")
            })
        self.Key_Gamepad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end

    self.List_Attribute:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    if self.PolarityEditWidget then
        self.PolarityEditWidget.Com_Cost.Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.Mod_Plan.Key_GamePad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Common_PolarityList_PC.Key_LT:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Common_PolarityList_PC.Key_RT:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Key_FocusList_GamePad:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Sift.Img_Key_L:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.List_Role:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    self.CheckBox_Mod:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    self.List_Role.BP_OnItemSelectionChanged:Clear()
    self.List_Role.BP_OnItemSelectionChanged:Add(self,self.OnRoleListItemSelectionChanged)
    self.List_Select_Mod.BP_OnItemSelectionChanged:Add(self, self.OnModListItemChange)
    self.Key_Search:SetVisibility(UIConst.VisibilityOp.Visible)
    self:SetGamepadNavigationRule()
    self:SetDefaultGamepadFocus()
    --self.Sift:BindEventOnAddedToFocusPath(self,self.OnSiftAddedToFocusPath)
    --self.Sift:BindEventOnRemovedFromFocusPath(self,self.OnSiftRemovedFromFocusPath)
    self.Btn_Share:BindEventOnAddedToFocusPath(self,self.OnBtnCopyLinkAddedToFocusPath)
    self.Btn_Share:BindEventOnRemovedFromFocusPath(self,self.OnBtnCopyLinkRemovedFromFocusPath)
    if self.ItemDetailsWidget then
        self:AddTimer(0.2, function()
            self.ItemDetailsWidget.Panel_Controller:SetVisibility(ESlateVisibility.Collapsed)
        end)
    end
    self.Btn_Info:SetGamepadIconVisibility(false)
end

-- function Component:OnSiftAddedToFocusPath()
--     self.Common_SortList_PC.Img_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
-- end

-- function Component:OnSiftRemovedFromFocusPath()
--     self.Common_SortList_PC.Img_Key:SetVisibility(UIConst.VisibilityOp.Visible)
-- end

function Component:OnBtnCopyLinkAddedToFocusPath()
    self.Mod_Plan.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function Component:OnBtnCopyLinkRemovedFromFocusPath()
    self.Mod_Plan.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Visible)
end

function Component:SetGamepadNavigationRule()
    -- 为每个Mod设置导航规则
    for i = 1, 9 do
        local mod = self["Mod_" .. i]
        if mod then
            mod:SetNavigationRuleCustom(EUINavigation.Left, {self, function()
                return self:OnUINavigationMod(mod, EUINavigation.Left)
            end})
            mod:SetNavigationRuleCustom(EUINavigation.Right, {self, function()
                return self:OnUINavigationMod(mod, EUINavigation.Right)
            end})
            mod:SetNavigationRuleCustom(EUINavigation.Up, {self, function()
                return self:OnUINavigationMod(mod, EUINavigation.Up)
            end})
            mod:SetNavigationRuleCustom(EUINavigation.Down, {self, function()
                return self:OnUINavigationMod(mod, EUINavigation.Down)
            end})
        end
    end

    -- self.Common_SortList_PC.Btn_SortType:SetNavigationRuleExplicit(EUINavigation.Right, self.Sift)
    -- self.Common_SortList_PC.Btn_SortType:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    -- self.Common_SortList_PC.Btn_Filter_List:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    -- self.Common_SortList_PC.Btn_Filter_List:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    --self.Sift:SetNavigationRuleExplicit(EUINavigation.Left, self.Common_SortList_PC.Btn_SortType)
    self.Sift:SetNavigationRuleExplicit(EUINavigation.Right, self.CheckBox_Mod)
    self.CheckBox_Mod:SetNavigationRuleExplicit(EUINavigation.Left, self.Sift)

    self.Mod_Plan.Btn_Plan:SetNavigationRuleExplicit(EUINavigation.Right, self.Mod_Plan.Btn_Edit)
    self.Mod_Plan.Btn_Plan:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.Mod_Plan.Btn_Edit:SetNavigationRuleExplicit(EUINavigation.Left, self.Mod_Plan.Btn_Plan)
    self.Mod_Plan.Btn_Edit:SetNavigationRuleExplicit(EUINavigation.Right, self.Btn_Share)
    self.Mod_Plan.Btn_Plan:SetNavigationRuleCustom(EUINavigation.Down, {self, function()
        return self:OnModPlanNavigationDown()
    end})
    self.Btn_Share:SetNavigationRuleExplicit(EUINavigation.Left, self.Mod_Plan.Btn_Edit)
    self.Mod_Plan.List_Plan:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self.Mod_Plan.Btn_Edit:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)

    if ModModel:IsModUIPreview() then
        return
    end
    self.Mod_Skill:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    local SkillItem = self.Mod_Skill:GetItemAt(0)
    if IsValid(SkillItem) and IsValid(SkillItem.UI) then
        SkillItem.UI:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    end
end

function Component:OnModPlanNavigationDown()
    if not self.Mod_Plan.bExpandList then
        return nil
    else
        local index = ModModel:GetTarget().ModSuitIndex
        self.Mod_Plan.List_Plan:NavigateToIndex(index - 1)
    end
end

-- 恢复因为手柄选中导致的导航限制、透明度等东西
function Component:RecoverFromGamepad()
    --由于有些Tab栏是用ListView做的，在ListView没生成完之前去直接拿里面的格子会报错，所以这里卡个定时器等等
    self:AddTimer(0.03, self.SetGamepadNavigationRule)
    self:PlayAnimationReverse(self.GamePad_Dark)
    --self.List_Select_Mod:SetRenderOpacity(1.0)
    self.IsSelectModToItem = false
    self:SetModSlotHighlight(nil)
    self:SetModListHighlight(nil)
    self.Tip_Mod.Panel_Button:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Mod_Plan.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Visible)
    if ModController:IsGamepad() then
        self.Btn_EditPolarity:SetGamePadVisibility(UIConst.VisibilityOp.Visible)
    end
end

function Component:SetModSlotHighlight(index)
    if index == nil then
        for i = 1, 9 do
            local mod = self["Mod_" .. i]
            mod:SetRenderOpacity(1.0)
        end
        self.Image_Remind:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        for i = 1, 9 do
            local mod = self["Mod_" .. i]
            mod:SetRenderOpacity(0.5)
        end
        self.Image_Remind:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
end

function Component:SetModListHighlight(Widget)
    if Widget == nil then
        for i = 1, 9 do
            local mod = self["Mod_" .. i]
            mod.Image_Remind:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        self.List_Select_Mod:SetRenderOpacity(1.0)
        if self.LastHighlightWidget then
            self.LastHighlightWidget:SetRenderOpacity(1.0)
            self.LastHighlightWidget = nil
        end
    else
        for i = 1, 9 do
            local mod = self["Mod_" .. i]
            if not mod.SlotUIData:InState(ModCommon.SlotState.Lock) then
                mod.Image_Remind:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            end
        end
        self.List_Select_Mod:SetRenderOpacity(0.5)
        Widget:SetRenderOpacity(2.0)
        self.LastHighlightWidget = Widget
    end
end

function Component:UpdatePolarityListIndex(indexChange)
    if (self.PolarityEditWidget.List_Polarity == nil) then
        return
    end
    local SelectedItem = self.PolarityEditWidget.List_Polarity:BP_GetSelectedItem()
    local MaxIndex = #DataMgr.ModPolarity
    local index = 0
    if SelectedItem then
        index = self.PolarityEditWidget.List_Polarity:GetIndexForItem(SelectedItem)
    end
    local newIndex = math.clamp(index + indexChange, 0, MaxIndex)
    self.PolarityEditWidget.List_Polarity:SetSelectedIndex(newIndex)
end

function Component:OnModListItemChange(SelectItem, bIsSelect)
    if (SelectItem) then
        self.LastSelectedItem = SelectItem.UI
    end
end

function Component:HandleGamepadModSelection(Content)
    if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
        return
    end
    local GamePadSelectedStuff = ModModel:GetGamePadSelectedStuff()
    if (not GamePadSelectedStuff or not GamePadSelectedStuff.SlotId) then
        self.LastFocusedItemBeforeSelectionIndex = self.List_Select_Mod:GetIndexForItem(Content)
        self.LastFocusedItemBeforeSelection = Content.UI
        ModModel:SetGamePadSelectedStuff(Content.Uuid, nil)
        -- 移到Mod_1
        self.Mod_1:SetFocus()
        self:EnterGamepadSelectionMode()
        -- 限制Mod的导航范围
        for i = 1, 9 do
            local mod = self["Mod_" .. i]
            if mod then
                mod:SetNavigationRuleCustom(EUINavigation.Down, {self, function()
                    return self:OnUINavigationMod(mod, EUINavigation.Down, true)
                end})
            end
        end
        self.Mod_1:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
        self.Mod_5:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
        self:SetModListHighlight(Content.UI)
    elseif (GamePadSelectedStuff.SlotId) then
        ModController:SendChangeMod(ModModel:GetTarget(), GamePadSelectedStuff.SlotId, Content.Uuid)
        ModModel:SetGamePadSelectedStuff(nil, nil)
        self:RecoverFromGamepad()
        if(self.LastFocusedItemBeforeSelection) then
            self:AddTimer(0.1, function()
                self.LastFocusedItemBeforeSelection:SetFocus()
            end)
        end
    end
end

function Component:HandleGamepadModSlotSelection(SlotUIData)
    if ModModel:IsInPolarityEditMode() or ModModel:IsModUIPreview() then
        return UE.UWidgetBlueprintLibrary.Handled()
    end
    local GamePadSelectedStuff = ModModel:GetGamePadSelectedStuff()
    if (not GamePadSelectedStuff or not GamePadSelectedStuff.ModUuid) then
        ModModel:SetGamePadSelectedStuff(SlotUIData.ModEid, SlotUIData.SlotId)
        local Item = self.List_Select_Mod:GetItemAt(0)
        self.List_Select_Mod:BP_SetSelectedItem(Item)
        Item.UI:SetFocus()
        self:EnterGamepadSelectionMode()
        self.LastFocusedItemBeforeSelection = self["Mod_" .. SlotUIData.SlotId]
        self.IsSelectModToItem = true
        self:SetModSlotHighlight(SlotUIData.SlotId)
    elseif (GamePadSelectedStuff.ModUuid) then
        if (GamePadSelectedStuff.SlotId) then
            ModController:SendExchangeMod(ModModel:GetTarget(), GamePadSelectedStuff.SlotId, SlotUIData.SlotId)
        else
            ModController:SendChangeMod(ModModel:GetTarget(), SlotUIData.SlotId, GamePadSelectedStuff.ModUuid)
        end
        ModModel:SetGamePadSelectedStuff(nil,nil)
        self:RecoverFromGamepad()
        if(self.LastFocusedItemBeforeSelectionIndex) then
            self:AddTimer(0.1, function()
                self.List_Select_Mod:SetFocus()
                self.List_Select_Mod:NavigateToIndex(self.LastFocusedItemBeforeSelectionIndex)
            end)
        end
    end
end

function Component:EnterGamepadSelectionMode()
    self.Tip_Mod.Panel_Button:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:PlayAnimation(self.GamePad_Dark)
    self.Mod_Plan.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_EditPolarity:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
end




-- 水平导航顺序映射
local HorizontalNavOrder = {
    -- 第一行
    [1] = {1, 3, 9, 4, 2},
    -- 第二行
    [2] = {5, 7, 9, 8, 6}
}

-- 获取下一个可用的Mod槽位
function Component:GetNextAvailableModInRow(currentIndex, direction, rowIndex)
    local row = HorizontalNavOrder[rowIndex]
    local currentPosition = 1
    
    -- 找到当前位置
    for pos, index in ipairs(row) do
        if index == currentIndex then
            currentPosition = pos
            break
        end
    end
    
    -- 向右或向左查找
    local step = direction == EUINavigation.Right and 1 or -1
    local nextPosition = currentPosition + step
    
    while nextPosition >= 1 and nextPosition <= #row do
        local nextModIndex = row[nextPosition]
        local nextMod = self["Mod_" .. nextModIndex]
        
        -- 检查Mod是否可用
        if nextMod and nextMod:GetVisibility() ~= UE4.ESlateVisibility.Collapsed 
           and not nextMod.SlotUIData:InState(ModCommon.SlotState.Lock) then
            if nextModIndex == 9 then
                self.CurrentrowIndex = rowIndex
            end
            return nextMod
        end
        nextPosition = nextPosition + step
    end
    
    -- 如果是Mod_1和Mod_5,且往左，这里需要返回List_Role
    if (currentIndex == 1 or currentIndex == 5) and direction == EUINavigation.Left and ModModel.PolarityEditModeData == nil then
        ModController:SetSelectedStuff(nil, nil)
        return self.List_Role
    end
    return nil
end

function Component:OnUINavigationMod(currentMod, direction, isFobidNavigation)
    local currentIndex = tonumber(string.match(currentMod:GetName(), "Mod_(%d+)"))
    local rowIndex = currentIndex <= 4 and 1 or 2

    if currentIndex == 9 then
        rowIndex = self.CurrentrowIndex or 1
    end
    
    if direction == EUINavigation.Left or direction == EUINavigation.Right then
        -- 水平导航
        local nextMod = self:GetNextAvailableModInRow(currentIndex, direction, rowIndex)
        return nextMod or currentMod
        
    elseif direction == EUINavigation.Down then
        -- 向下导航
        if rowIndex == 1 then
            -- 从第一行到第二行
            local bottomIndex = currentIndex == 1 and 5 or (currentIndex == 3 and 7 or (currentIndex == 4 and 8 or 6))
            local bottomMod = self["Mod_" .. bottomIndex]
            
            if bottomMod and bottomMod:GetVisibility() ~= UE4.ESlateVisibility.Collapsed 
               and not bottomMod.SlotUIData:InState(ModCommon.SlotState.Lock) then
                return bottomMod
            end
            -- 如果下面的Mod不可用，返回List_Select_Mod
            if self.needNavigation then
                return self.List_Select_Mod
            else
                return nil
            end
        else
            if not isFobidNavigation then
                if currentIndex == 9 then
                    return self.List_Select_Mod
                end
                if self.needNavigation then
                    return self.List_Select_Mod
                else
                    return nil
                end
            end
                return nil
        end
    elseif direction == EUINavigation.Up then
        -- 向上导航
        if rowIndex == 2 then
            -- 从第二行到第一行
            local topIndex = currentIndex == 5 and 1 or (currentIndex == 7 and 3 or (currentIndex == 8 and 4 or 2))
            local topMod = self["Mod_" .. topIndex]
            
            if topMod and topMod:GetVisibility() ~= UE4.ESlateVisibility.Collapsed 
               and not topMod.SlotUIData:InState(ModCommon.SlotState.Lock) then
                return topMod
            end
        end
    end
    return currentMod
end

function Component:OnListModNavigationMod()
    if self.IsSelectModToItem then
        return nil
    end
    if self.Mod_5.Visibility == UE4.ESlateVisibility.Collapsed
    or self.Mod_5.SlotUIData:InState(ModCommon.SlotState.Lock) then
        return self.Mod_1
    end
    return self.Mod_5
end

function Component:OnResourceBarRemovedFromFocusPath()
    if self.IsFocusOnResourceBar and not self.IsProcessingFocusChange then
        self.IsProcessingFocusChange = true
        self.Mod_1:SetFocus()
        self.IsFocusOnResourceBar = false
        self.IsProcessingFocusChange = false
    end
end

function Component:SetFocus_Lua()
    if ModModel:IsInAutoEquip() then return end
    if ModController:IsGamepad() then
        if self.RecommendView and self.RecommendView:GetVisibility() == UIConst.VisibilityOp.Visible then
            self.RecommendView:SetRecommendFocus()
        else
            if(self.LastSelectedItem) then
                self.LastSelectedItem:SetFocus()
            else
                self.LastSelectedItem = self.List_Role
                self.List_Role:SetFocus()
            end
        end
    end
end

function Component:OnRemovedFromFocusPath(InFocusEvent)
    self.IsFocusInSpecialItem = false
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self.Key_Gamepad:SetVisibility(UIConst.VisibilityOp.Visible)
    end
end

function Component:OnRoleListItemSelectionChanged(Content,IsSelected)
    if(not IsSelected)then
        return
    end
    if(self.CurInputDeviceType == ECommonInputType.Gamepad and IsSelected)then
        self:OnTargetTabSelected(Content)
        self.List_Role:BP_NavigateToItem(Content)
        self.Mod_Plan.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Visible)
        ModModel:SetGamePadSelectedStuff(nil, nil)
    end
end

function Component:UpdatePolarityListIndex(indexChange)
    if (self.PolarityEditWidget.List_Polarity == nil) then
        return
    end
    local SelectedItem = self.PolarityEditWidget.List_Polarity:BP_GetSelectedItem()
    local MaxIndex = #DataMgr.ModPolarity
    local index = 0
    if SelectedItem then
        index = self.PolarityEditWidget.List_Polarity:GetIndexForItem(SelectedItem)
    end
    local newIndex = math.clamp(index + indexChange, 0, MaxIndex)
    self.PolarityEditWidget.List_Polarity:SetSelectedIndex(newIndex)
end

function Component:ChangePolarityListIndex(indexChange)
    self.Common_PolarityList_PC:UpdateListIndex(indexChange)
    if self.List_Select_Mod:HasFocusedDescendants() or self.List_Select_Mod:HasAnyUserFocus() then
        self.List_Select_Mod:NavigateToIndex(0)
    end
    ModModel:SetGamePadSelectedStuff(nil, nil)
end

function Component:SetKeySelectModGamePad(Desc)
    if not self.Key_SelectMod_GamePad then return end
    if ModModel.PolarityEditModeData ~= nil then
        self.Key_SelectMod_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    elseif Desc == nil then
        self.Key_SelectMod_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.Key_SelectMod_GamePad:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Key_SelectMod_GamePad:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "A",
                }
            },
            Desc = Desc
        })
    end
end

return Component
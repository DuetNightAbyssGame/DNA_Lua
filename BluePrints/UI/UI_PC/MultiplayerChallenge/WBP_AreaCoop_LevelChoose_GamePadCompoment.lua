local M = {}

-- 输入设备切换：同步页面与默认列表的布局、提示与焦点（去重处理）
function M:RefreshOpInfoByInputDevice(InputType, GamepadName)
    if InputType == ECommonInputType.Touch then
        return
    end
    local isKBM = (InputType == ECommonInputType.MouseAndKeyboard)

    -- 页面样式切换
    self:UpdateUIStyleInPlatform(isKBM)

    -- 默认列表：避免双重初始化（页面这边不主动再调用 PC/Gamepad 的双份初始化）
    local DefaultList = self.DefaultList or (self.EnsurePlatformDefaultListLoaded and self:EnsurePlatformDefaultListLoaded())
    if DefaultList then
        if isKBM then
            if DefaultList.ApplyPcUiLayout then
                 DefaultList:ApplyPcUiLayout() -- 已在初始化处做一次化，避免多次触发
            end
        else
            if DefaultList.InitWidgetInfoInGamePad then
                 DefaultList:InitWidgetInfoInGamePad() -- 页面统一控，避免重复
            end
        end
    end

    if self.Super and self.Super.RefreshOpInfoByInputDevice then
        self.Super.RefreshOpInfoByInputDevice(self, InputType, GamepadName)
    end
end

function M:OnInputDeviceChanged(InputType, GamepadName)
    self:RefreshOpInfoByInputDevice(InputType, GamepadName)
end

-- 视图初始化：按输入设备显示手柄提示控件
function M:InitWidgetInfoInGamePad()
    self.IsInSelectState = false
    self.CurSelectWidget = nil

    if self.Key_Title_Monster then
        self.Key_Title_Monster:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Key_Title_Rewards then
        self.Key_Title_Rewards:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Key_Scroll then
        self.Key_Scroll:CreateCommonKey({
            KeyInfoList = {{
                Type = "Img",
                ImgShortPath = "LS",
            }},
            Desc = GText("UI_Controller_Check"),
        })
    end
    if self.Key_Qa then
        self.Key_Qa:CreateGamepadKey("RS")
    end

    local isOpen = self.DefaultList and self.DefaultList.IsMenuAnchorOpen and self.DefaultList:IsMenuAnchorOpen() or false
    self:UpdateSquadPresetKeyTips(isOpen)
end

function M:InitGamepadView()
    if self.Common_Button_Text_PC then
        self.Common_Button_Text_PC:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Common_Button_Text_PC:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.Btn_Coop then
        self.Btn_Coop:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Btn_Coop:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.Key_Title_Rewards then
        self.Key_Title_Rewards:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.Key_Title_Monster then
        self.Key_Title_Monster:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.Key_Qa then
        self.Key_Qa:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.Image_QaBG then
        self.Image_QaBG:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.SetFocus then
        self:SetFocus()
    end
    if self.EliteItem and self.EliteItem.List_EliteProp then
        self.EliteItem.List_EliteProp:BP_ClearSelection()
        self.EliteItem.List_EliteProp:SetSelectedIndex(0)
    end
    if self.Key_Scroll then
        self.Key_Scroll:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self.Common_Button_Text_PC:SetGamePadImg("Y")
    self.Btn_Coop:SetGamePadImg("X")
end
-- 左下角手柄提示（与现有实现一致）
function M:UpdateSquadPresetKeyTips(bIsOpen)
    local isGamepad = (UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad)

    if isGamepad then
        if self.Group_Key and self.Group_Key.SetVisibility then
            self.Group_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end

        local BottomKeyInfo
        if bIsOpen then
            BottomKeyInfo = {
                { KeyInfoList = {{ Type = "Img", ImgShortPath = "B" }}, Desc = GText("UI_BACK") },
            }
        else
            BottomKeyInfo = {
                { KeyInfoList = {{ Type = "Img", ImgShortPath = "LS" }}, Desc = GText("UI_Controller_Check") },
                { KeyInfoList = {{ Type = "Img", ImgShortPath = "A" }},  Desc = GText("UI_Tips_Ensure") },
                { KeyInfoList = {{ Type = "Img", ImgShortPath = "B" }},  Desc = GText("UI_BACK") },
            }
        end

        if self.Com_LeftKeyTips and self.Com_LeftKeyTips.UpdateKeyInfo then
            self.Com_LeftKeyTips:UpdateKeyInfo(BottomKeyInfo)
        end
    else
        if self.Group_Key and self.Group_Key.SetVisibility then
            self.Group_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        if self.Com_LeftKeyTips then
            if self.Com_LeftKeyTips.UpdateKeyInfoNew then
                self.Com_LeftKeyTips:UpdateKeyInfoNew({})
            elseif self.Com_LeftKeyTips.ClearChildren then
                self.Com_LeftKeyTips:ClearChildren()
            end
        end
        return
    end
    local DefaultList = self.DefaultList
    local isShow = DefaultList and DefaultList.IsShow or false
    local isMenuOpen = DefaultList and DefaultList.IsMenuAnchorOpen and DefaultList:IsMenuAnchorOpen() or false

    if not isShow then
        if self.Group_Key and self.Group_Key.SetVisibility then
            self.Group_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        if self.Com_LeftKeyTips then
            if self.Com_LeftKeyTips.UpdateKeyInfoNew then
                self.Com_LeftKeyTips:UpdateKeyInfoNew({})
            elseif self.Com_LeftKeyTips.ClearChildren then
                self.Com_LeftKeyTips:ClearChildren()
            end
        end
        return
    end

    local BottomKeyInfo
    if isMenuOpen then
        BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "B" } },
                Desc = GText("UI_CTL_CloseTips"),
            }
        }
    else
        BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "A" } },
                Desc = GText("UI_Tips_Ensure"),
            },
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "B" } },
                Desc = GText("UI_BACK"),
            }
        }
    end

    if self.Group_Key and self.Group_Key.SetVisibility then
        self.Group_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.Com_LeftKeyTips and self.Com_LeftKeyTips.UpdateKeyInfo then
        self.Com_LeftKeyTips:UpdateKeyInfo(BottomKeyInfo)
    end
end

function M:InitKeyboardView()
    if self.LeaveSelectMode then
        self:LeaveSelectMode()
    end

    if self.Common_Button_Text_PC then
        self.Common_Button_Text_PC:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        if self.Common_Button_Text_PC.SetGamePadVisibility then
            self.Common_Button_Text_PC:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
    if self.Btn_Coop then
        self.Btn_Coop:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        if self.Btn_Coop.SetGamePadVisibility then
            self.Btn_Coop:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
    if self.Key_Title_Rewards then
        self.Key_Title_Rewards:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Key_Title_Monster then
        self.Key_Title_Monster:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Key_Qa then
        self.Key_Qa:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Image_QaBG then
        self.Image_QaBG:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Key_Scroll then
        self.Key_Scroll:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self:UpdateSquadPresetKeyTips(false)
end

-- 与 DeputeDetail 一致的模式切换封装：统一入口
function M:UpdateUIStyleInPlatform(isKBM)
    if isKBM then
        self:InitKeyboardView()
    else
        self:InitGamepadView()
    end
end

--用于scrollbox上下导航的自定义边界函数，处理需要导航到尚且未显示的列表的情况
function M:OnNavigationUpInScrollBox(Index)
    local elite   = self.EliteItem and self.EliteItem.List_EliteProp
    local reward  = self.ListView_Rewards
    local monster = self.ListView_Monster

    local current
    if monster and (monster:HasFocusedDescendants() or monster:HasAnyUserFocus()) then
        current = monster
    elseif reward and (reward:HasFocusedDescendants() or reward:HasAnyUserFocus()) then
        current = reward
    elseif elite and (elite:HasFocusedDescendants() or elite:HasAnyUserFocus()) then
        current = elite
    else
        return
    end

    local prevList
    if current == monster then
        prevList = reward
    elseif current == reward then
        prevList = elite
    else
        return
    end

    if prevList:GetNumItems() <= 0 then
        return
    end

    return  self:SetectFirstItem(prevList)
end

function M:OnNavigationDownInScrollBox(Index)
    -- 保持与 OnNavigationUpInScrollBox 一致的线性导航：Elite → Reward → Monster
    local Elite   = self.EliteItem and self.EliteItem.List_EliteProp
    local Reward  = self.ListView_Rewards
    local Monster = self.ListView_Monster

    local Current
    if Elite and (Elite:HasFocusedDescendants() or Elite:HasAnyUserFocus()) then
        Current = Elite
    elseif Reward and (Reward:HasFocusedDescendants() or Reward:HasAnyUserFocus()) then
        Current = Reward
    elseif Monster and (Monster:HasFocusedDescendants() or Monster:HasAnyUserFocus()) then
        Current = Monster
    else
        return
    end

    local NextList
    if Current == Elite then
        NextList = Reward
    elseif Current == Reward then
        NextList = Monster
    else
        return
    end

    if NextList:GetNumItems() <= 0 then
        return
    end

    return self:SetectFirstItem(NextList)
end

function M:EnterSelectMode(SelectList)
    self.IsInSelectState = true
    self.CurSelectWidget = SelectList
    self:SetectFirstItem(SelectList)

    local DefaultList = self.DefaultList or (self.EnsurePlatformDefaultListLoaded and self:EnsurePlatformDefaultListLoaded())
    if DefaultList and DefaultList.ApplyPcUiLayout then
        DefaultList:ApplyPcUiLayout()
    end

    -- 直接设置可见性：隐藏滚动与 QA
    if self.Key_Scroll then
        self.Key_Scroll:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Key_Qa then
        self.Key_Qa:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:LeaveSelectMode()
    self.IsInSelectState = false
    self.CurSelectWidget = nil
    self:FocusOnDefault()

    local DefaultList = self.DefaultList or (self.EnsurePlatformDefaultListLoaded and self:EnsurePlatformDefaultListLoaded())
    if DefaultList and DefaultList.InitWidgetInfoInGamePad then
        DefaultList:InitWidgetInfoInGamePad()
    end

    -- 直接设置可见性：显示滚动与 QA
    if self.Key_Scroll then
        self.Key_Scroll:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.Key_Qa then
        self.Key_Qa:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
end

function M:FocusOnDefault()
    self.bShoulFocusToLastFocusedWidget = false --从好友界面返回时，这个选项会导致焦点回不到主界面上，关闭一下
    if self.SetFocus then
        self:SetFocus()
    end
    self:AddTimer(0.1, function()
        self.bShoulFocusToLastFocusedWidget = true
    end)
end

function M:FindNextFocusableItem()
    local ListView_Monster = self.ListView_Monster
    local ListView_Rewards = self.ListView_Rewards
    if ListView_Monster and ListView_Monster:GetNumItems() > 0 then
        ListView_Monster:NavigateToIndex(0)
    elseif ListView_Rewards and ListView_Rewards:GetNumItems() > 0 then
        ListView_Rewards:NavigateToIndex(0)
    else
        self:FocusOnDefault()
    end
end

function M:OnSpecialRightUp()
    local Parent = self
    local DefaultList = self.DefaultList or (self.EnsurePlatformDefaultListLoaded and self:EnsurePlatformDefaultListLoaded())
    if not DefaultList then return end

    -- 是否存在 Parent:IsFocusList 用于判定列表焦点区域
    local hasFocusFn = type(Parent.IsFocusList) == "function"
    local isFocus    = hasFocusFn and (Parent:IsFocusList() and true or false) or false

    -- 与 WBP_Build_DefaultList_P_C.OnSpecialRightUp 一致的切换规则
    local doOpen     = (not DefaultList.IsShow) and ((not hasFocusFn) or (not isFocus))
    local doClose    = (DefaultList.IsShow)     and ((not hasFocusFn) or (not isFocus))

    if doOpen and DefaultList.OnOpenSquadGamepad then
        DefaultList:OnOpenSquadGamepad()
        Parent.CurrentFocusType = "DefaultList"
        -- 新增：手柄端打开后确保默认列表获得焦点
        self:_FocusDefaultListForGamepad(DefaultList)
    elseif doClose and DefaultList.OnCloseSquadGamepad then
        DefaultList:OnCloseSquadGamepad()
    end
    self:UpdateSquadPresetBottomKey()
end

function M:OnDPadRightToggleAutoSummon()
    local DefaultList = self.DefaultList or (self.EnsurePlatformDefaultListLoaded and self:EnsurePlatformDefaultListLoaded())
    if not DefaultList then return false end

    local hasFocusFn = type(self.IsFocusList) == "function"
    if hasFocusFn and self:IsFocusList() then return false end

    if not (DefaultList.GetVisibility and DefaultList:GetVisibility() == UE4.ESlateVisibility.SelfHitTestInvisible) then
        return false
    end
    if DefaultList.IsShow then return false end

    local Preview = DefaultList.Preview
    local Switch = Preview and Preview.Switch_Summon
    if not Switch or not Switch.GetChecked or not Switch.SetChecked then return false end

    local IsChecked = not Switch:GetChecked()
    Switch:SetChecked(IsChecked)

    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.SwitchSquadAutoPhantom then
        Avatar:SwitchSquadAutoPhantom(IsChecked)
    end
    return true
end

function M:OnDPadLeftOpenDefaultMenuAnchor()
    local DefaultList = self.DefaultList or (self.EnsurePlatformDefaultListLoaded and self:EnsurePlatformDefaultListLoaded())
    if not DefaultList then return false end

    -- -- 已打开菜单锚点时，直接消费事件，避免重复打开导致导航异常
    -- if DefaultList.IsMenuAnchorOpen and DefaultList:IsMenuAnchorOpen() then
    --     return true
    -- end

    local hasFocusFn = type(self.IsFocusList) == "function"
    if hasFocusFn and self:IsFocusList() then return false end

    if not (DefaultList.GetVisibility and DefaultList:GetVisibility() == UE4.ESlateVisibility.SelfHitTestInvisible) then
        return false
    end
    if DefaultList.IsShow then return false end

    local Preview = DefaultList.Preview
    if not Preview or not Preview.OpenDefaultMenuAnchor then return false end

    Preview:OpenDefaultMenuAnchor()
    if self.UpdateSquadPresetBottomKey then
        self:UpdateSquadPresetBottomKey()
    end
    -- -- 展开后确保默认列表获得焦点
    -- if self._FocusDefaultListForGamepad then
    --     self:_FocusDefaultListForGamepad(DefaultList)
    -- end

    return true
end

function M:OnBKeyCloseDefaultList()
    local DefaultList = self.DefaultList or (self.EnsurePlatformDefaultListLoaded and self:EnsurePlatformDefaultListLoaded())
    if not DefaultList then return false end

    if DefaultList.GetVisibility
        and DefaultList:GetVisibility() == UE4.ESlateVisibility.SelfHitTestInvisible
        and DefaultList.IsShow
        and DefaultList.OnCloseSquadGamepad
    then
        DefaultList:OnCloseSquadGamepad()
        return true
    end
    return false
end
-- 新增：根据 DefaultList 的状态（IsShow + IsMenuAnchorOpen）刷新底部快捷键
function M:UpdateSquadPresetBottomKey()
    local DefaultList = self.DefaultList or (self.EnsurePlatformDefaultListLoaded and self:EnsurePlatformDefaultListLoaded())
    local isGamepad = (UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad)

    if not isGamepad then
        if self.Group_Key and self.Group_Key.SetVisibility then
            self.Group_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        if self.Com_LeftKeyTips then
            if self.Com_LeftKeyTips.UpdateKeyInfoNew then
                self.Com_LeftKeyTips:UpdateKeyInfoNew({})
            elseif self.Com_LeftKeyTips.ClearChildren then
                self.Com_LeftKeyTips:ClearChildren()
            end
        end
        return
    end

    local isShow = DefaultList and DefaultList.IsShow or false
    local isMenuOpen = DefaultList and DefaultList.IsMenuAnchorOpen and DefaultList:IsMenuAnchorOpen() or false

    if not isShow then
        if self.Group_Key and self.Group_Key.SetVisibility then
            self.Group_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        if self.Com_LeftKeyTips then
            if self.Com_LeftKeyTips.UpdateKeyInfoNew then
                self.Com_LeftKeyTips:UpdateKeyInfoNew({})
            elseif self.Com_LeftKeyTips.ClearChildren then
                self.Com_LeftKeyTips:ClearChildren()
            end
        end
        return
    end

    local BottomKeyInfo
    if isMenuOpen then
        BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "B" } },
                Desc = GText("UI_CTL_CloseTips"),
            }
        }
    else
        BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "A" } },
                Desc = GText("UI_Tips_Ensure"),
            },
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "B" } },
                Desc = GText("UI_BACK"),
            }
        }
    end

    if self.Group_Key and self.Group_Key.SetVisibility then
        self.Group_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.Com_LeftKeyTips and self.Com_LeftKeyTips.UpdateKeyInfo then
        self.Com_LeftKeyTips:UpdateKeyInfo(BottomKeyInfo)
    end
end

function M:ShowQaTipsPopup()
    if UIManager and UIManager(self) and UIManager(self).ShowCommonPopupUI then
        UIManager(self):ShowCommonPopupUI(100241)
        return true
    end
    return false
end

function M:IsFocusList()
    local function hasFocus(w)
        return w and (
            (w.HasFocusedDescendants and w:HasFocusedDescendants()) or
            (w.HasAnyUserFocus and w:HasAnyUserFocus())
        )
    end
    local l1 = self.ListView_Monster
    local l2 = self.ListView_Rewards
    local l3 = self.EliteItem and self.EliteItem.List_EliteProp
    if hasFocus(l1) or hasFocus(l2) or hasFocus(l3) then
        return true
    end
    return self.IsInSelectState == true
end



-- 新增：手柄端默认列表聚焦逻辑（优先 Armory，其次列表项，最后回退到整个列表）
function M:_FocusDefaultListForGamepad(DefaultList)
    local isGamepad = (UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad)
    if not isGamepad or not DefaultList then return end

    -- 优先聚焦到装配区（与 Depute 页一致）
    if DefaultList.Team_Armory and DefaultList.Team_Armory.SetFocus then
        DefaultList.Team_Armory:SetFocus()
        return
    end

    -- 次选：聚焦到默认列表第一项或已选项
    local lv = DefaultList.List_Default
    if lv and lv.NavigateToIndex then
        lv:NavigateToIndex(0)
        if lv.GetDisplayedEntryWidgets then
            local widgets = lv:GetDisplayedEntryWidgets()
            if widgets then
                local target = widgets[1]
                for _, w in pairs(widgets) do
                    if w.IsSelected then
                        target = w
                        break
                    end
                end
                if target and target.SetFocus then
                    target:SetFocus()
                    return
                end
            end
        end
    end

    -- 回退：聚焦整个默认列表
    if DefaultList.SetFocus then
        DefaultList:SetFocus()
    end
end
-- 聚焦到列表第一项并控制scrollbox滚动。
function M:SetectFirstItem(List)
    if List:HasAnyUserFocus() or List:HasFocusedDescendants() then
        return
    end
    if List then
        if List:GetNumItems() > 0 then
            local Item = List:GetItemAt(0)
            if Item then
                List:BP_NavigateToItem(Item)
                if Item.SelfWidget then
                    Item.SelfWidget:SetFocus()
                    self:ScrollItemIntoView(Item.SelfWidget)
                    return Item.SelfWidget
                else
                    local Widgets = List:GetDisplayedEntryWidgets(Item)
                    if Widgets and Widgets:Num() > 0 then
                        Widgets[1]:SetFocus()
                        self:ScrollItemIntoView(Widgets[1])
                        return Widgets[1]
                    end
                end
            end
        else
            List:SetFocus()
            self:ScrollItemIntoView(List)
            return List
        end
    end
end

function M:OnItemFocus(Content)
    DebugPrint("OnItemFocus")
    if not Content.SelfWidget then
        return
    end
    self:ScrollItemIntoView(Content.SelfWidget)
    if self.FocusList ~= Content.List then
        self.FocusList = Content.List
        self.FocusList:BP_SetSelectedItem(Content)
    end
end

return M
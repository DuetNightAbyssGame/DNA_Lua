
-- 手柄按键聚焦通用组件，详情说明可参阅文档：https://herogames.feishu.cn/wiki/BOONwP0DLiXDb1kC8rfcIXYTn5b

local Component = {}
-- 在界面 Construct 函数中调用
---@param KeyImg Common_Key_Show_Img_PC_C 类型为Com_KeyImg，手柄按键LS图标
---@param WidgetOrGroup table<UWidget> 类型为Table，按界面中从左到右的顺序存储控件
---@param OverriddenKeyName string 默认为LS，可以设置不同的KeyName
---@param bSingleWidget bool 是否是唯一需要聚焦控件，若是则将会在聚焦时自动激活(展开/选中)
-- self:AddLSFocusTarget(nil, {self.Common_SortList_PC, self.CheckBox_Own})  (目标是复数控件)
-- self:AddLSFocusTarget(nil, self.Common_SortList_PC, "X", true)            (目标是单个控件)
function Component:AddLSFocusTarget(KeyImg, WidgetOrGroup, OverriddenKeyName, bSingleWidget)
    -- DebugPrint("lhr@AddLSFocusTarget", OverriddenKeyName)
    if not self.LSInitialized then
        self:BindInputEventForLSComp()
        self:InitKeyMaps()
        self.LSInitialized = true
    end
    local KeyName = OverriddenKeyName or "LS"
    self:InitGamePadImgForLSComp(KeyImg, KeyName)
    local GamePadKey = Const.ShortKeyToGamePadKey[KeyName]
    if not WidgetOrGroup then
        DebugPrint(WarningTag, "LSFocusComp::AddLSFocusTarget, 传入的控件无效, UI名:", self.GetName and self:GetName())
        return
    end
    if bSingleWidget then
        local Widget = WidgetOrGroup
        self.SingleWidget[GamePadKey] = {KeyImg = KeyImg, Widget = Widget}
        Widget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
        Widget:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
        Widget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
        Widget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
        self:RefreshOpInfoByInputDeviceForLSComp(self.GameInputModeSubsystem:GetCurrentInputType())
        return
    end
    local GroupWidgets = WidgetOrGroup
    self.GroupWidgets[GamePadKey] = {KeyImg = KeyImg, Widgets = GroupWidgets}
    local LastWidget = nil
    for _, TargetWidget in ipairs(GroupWidgets) do
        if (TargetWidget ~= nil and TargetWidget:IsVisible()) then
            --设置控件之间的导航规则
            TargetWidget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
            TargetWidget:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
            TargetWidget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
            if TargetWidget.Btn_SortType then
                TargetWidget.Btn_SortType:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
            else
                TargetWidget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
            end
            if LastWidget then
                if LastWidget.Btn_SortType then
                    LastWidget.Btn_SortType:SetNavigationRuleExplicit(EUINavigation.Right, TargetWidget)
                else
                    LastWidget:SetNavigationRuleExplicit(EUINavigation.Right, TargetWidget)
                end
                TargetWidget:SetNavigationRuleExplicit(EUINavigation.Left, LastWidget)
            end
            LastWidget = TargetWidget
        end
    end
    self:RefreshOpInfoByInputDeviceForLSComp(self.GameInputModeSubsystem:GetCurrentInputType())
end

function Component:InitKeyMaps()
    if not self.LSInitialized then
        self.GroupWidgets = self.GroupWidgets or {}
        self.SingleWidget = self.SingleWidget or {}
    end
end

function Component:InitGamePadImgForLSComp(KeyImg, KeyName)
    if not KeyImg or not KeyName then
        return
    end
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Touch then
        KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if KeyImg.CreateCommonKey then
        KeyImg:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = KeyName,
                },
            },
        })
    end
end

function Component:HideGamepadKeyForLSComp()
    self.HideCompKeyImg = true
    self:UpdateGamepadKeyState()
end

function Component:ShowGamepadKeyForLSComp()
    self.HideCompKeyImg = false
    self:UpdateGamepadKeyState()
end

function Component:BindInputEventForLSComp()
    if (not self.GameInputModeSubsystem) then
        self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    end
    if (IsValid(self) and IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDeviceForLSComp) 
    end
end

function Component:Destruct()
    if (IsValid(self) and IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDeviceForLSComp) 
    end
end

---@param KeyName string 移除注册在KeyName上的目标控件
function Component:RemoveFocusTarget(KeyName)
    self:InitKeyMaps()
    local GamePadKey = Const.ShortKeyToGamePadKey[KeyName]
    if self.SingleWidget[GamePadKey] then
        self.SingleWidget[GamePadKey] = nil
        return
    end
    --当有复数目标控件时
    if self.GroupWidgets[GamePadKey] then
        self.GroupWidgets[GamePadKey] = nil
        return
    end
end


--在界面 RefreshOpInfoByInputDevice 函数中调用
function Component:RefreshOpInfoByInputDeviceForLSComp(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end
    self:InitKeyMaps()
    self.CurInputDeviceType = CurInputDevice
    if(self.CurInputDeviceType ~= ECommonInputType.Gamepad) then
        self.CurrentFocusKey = nil
    else
        for Key, _ in pairs(self.SingleWidget) do
            if self:IsInLSMode(Key) then
                self.CurrentFocusKey = Key
                self:UpdateGamepadKeyState()
                return
            end
        end
        for Key, _ in pairs(self.GroupWidgets) do
            if self:IsInLSMode(Key) then
                self.CurrentFocusKey = Key
                self:UpdateGamepadKeyState()
                return
            end
        end
    end
    self:UpdateGamepadKeyState()
end


--在界面 OnKeyDown 函数中调用
--使用示例：
-- function M:OnKeyDown(MyGeometry, InKeyEvent)
--      local IsHandled =  self:OnKeyDownForLSComp(MyGeometry, InKeyEvent)
--      if not IsHandled then
--          return self.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
--      else
--          return UE4.UWidgetBlueprintLibrary.Handled()
--      end
-- end
function Component:OnKeyDownForLSComp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    -- DebugPrint("lhr@OnKeyDownForLSComp",InKeyName, self.SingleWidget[InKeyName])
    local IsEventHandled = false
    self:InitKeyMaps()
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName ~= "Gamepad_FaceButton_Right") then
            if self:EnterLSMode(InKeyName) then
                IsEventHandled = true
            end
        else
            IsEventHandled = self:LeaveLSMode()
        end
    end

    return IsEventHandled
end

function Component:FocusOnWidget(TargetWidget, FocusKey, bSingleWidget)
    if (TargetWidget ~= nil and TargetWidget:IsVisible()) then
        --当只有单个控件时，激活控件(展开/选中)
        if bSingleWidget then
            self:ActivateWidget(TargetWidget)
        else
        --聚焦到通过LS唤起的控件
            TargetWidget:SetFocus()
            self.CurrentFocusKey = FocusKey
        end
        self:UpdateGamepadKeyState(FocusKey)
        return true
    end
    return false
end

function Component:IsWidgetFocused(TargetWidget)
    if (TargetWidget ~= nil and TargetWidget:IsVisible()) then
        --隐藏LS图标，待蓝图开始接手柄端后将控件名改为图标变量名
        if (TargetWidget:HasFocusedDescendants() or TargetWidget:HasAnyUserFocus()) then
            return true
        end
    end
    return false
end

function Component:EnterLSMode(FocusKey)
    if (self:IsInLSMode(FocusKey)) then
        return false
    end
    --当只有单个控件时
    if self.SingleWidget[FocusKey] then
        local WidgetInfo = self.SingleWidget[FocusKey]
        local Widget = WidgetInfo.Widget
        return self:FocusOnWidget(Widget, FocusKey, true)
    end
    --当有复数目标控件时
    if self.GroupWidgets[FocusKey] then
        local GroupInfo = self.GroupWidgets[FocusKey]
        local GroupWidgets = GroupInfo.Widgets
        if not GroupWidgets then
            return false
        end
        for _, TargetWidget in ipairs(GroupWidgets) do
        --聚焦到目标控件群组的第一个控件上
            if self:FocusOnWidget(TargetWidget, FocusKey) then
                return true
            end
        end
    end

    return false
end

function Component:LeaveLSMode()
    local FocusKey = self.CurrentFocusKey
    if not FocusKey then
        self:UpdateGamepadKeyState()
        return false
    end
    if (not self:IsInLSMode(FocusKey)) then
        self:UpdateGamepadKeyState()
        self.CurrentFocusKey = nil
        return true
    end
    --当只有单个控件时
    if self.SingleWidget[FocusKey] then
        local Widget = self.SingleWidget[FocusKey].Widget
        self:InActivateWidget(Widget)
    end
    --离开通过LS唤起的控件，聚焦回界面的默认聚焦控件
    local DefaultFocusWidget = self:BP_GetDesiredFocusTarget()
    if (DefaultFocusWidget ~= nil) then
        DefaultFocusWidget:SetFocus()
    end
    self:UpdateGamepadKeyState()
    if self.AddTimer then
        self:AddTimer(0.2, function()
            if FocusKey and not self:IsInLSMode(FocusKey) then
                self.CurrentFocusKey = nil
            end
        end, nil, nil, nil, true)
    else
        self.CurrentFocusKey = nil
    end
    return true
end

function Component:UpdateGamepadKeyState(FocusKey)
    if(self.CurInputDeviceType == ECommonInputType.Gamepad)then
        if(not self:IsInLSMode(FocusKey) and not self.HideCompKeyImg)then
            self:ShowKeyImg(true)
        else
            self:ShowKeyImg(false)
        end
    else
        self:ShowKeyImg(false)
    end
end

function Component:IsInLSMode(FocusKey)
    local FocusKey = FocusKey or self.CurrentFocusKey
    if not FocusKey then
        return false
    end
    --当只有单个控件时
    if self.SingleWidget[FocusKey] then
        local Widget = self.SingleWidget[FocusKey].Widget
        return self:IsWidgetFocused(Widget)
    end
    --当有复数目标控件时
    if self.GroupWidgets[FocusKey] then
        local GroupWidgets = self.GroupWidgets[FocusKey].Widgets
        if not GroupWidgets then
            return false
        end
        for _, TargetWidget in ipairs(GroupWidgets) do
            if self:IsWidgetFocused(TargetWidget) then
                return true
            end
        end
    end
    return false
end

function Component:ShowKeyImg(bShow)
    for _, v in pairs(self.SingleWidget) do
        local KeyImg = v.KeyImg
        self:SetKeyVisibility(KeyImg, bShow)
    end
    for _, v in pairs(self.GroupWidgets) do
        local KeyImg = v.KeyImg
        self:SetKeyVisibility(KeyImg, bShow)
    end
end

function Component:SetKeyVisibility(Key, bShow)
    if not Key then
        return
    end
    if bShow then
        Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function Component:ActivateWidget(TargetWidget)
    if TargetWidget.Activate then
        TargetWidget:Activate()
    end
end

function Component:InActivateWidget(TargetWidget)
    if TargetWidget.InActivate then
        TargetWidget:InActivate()
    end
end

return Component
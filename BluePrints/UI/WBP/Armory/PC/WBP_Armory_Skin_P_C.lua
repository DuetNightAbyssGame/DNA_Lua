--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local FSM = require("Blueprints.UI.FocusStateMachine")
local FocusAreas = {
    SkinList = "SkinList",
    AccessoryList = "AccessoryList",
    AccessoryTab = "AccessoryTab",
    HiddenSelf = "HiddenSelf",
    Resource = "Resource",
    MVPList = "MVPList",
    SkinLevelUp = "SkinLevelUp",
}

---@type WBP_Armory_Skin_P_C|WBP_Armory_Skin_Base_C
local M = Class("BluePrints.UI.WBP.Armory.Appearance.WBP_Armory_Skin_Base_C")
M._components = {
    "BluePrints.UI.KeyInputComponent"
}
--function M:Initialize(Initializer)
--end

function M:Construct()
    rawset(self,"EscapeKey",EKeys.Escape.KeyName)
    rawset(self,"ZoomKey","Mouse_Button")

    self.ESCKeyInfoList = {
        KeyInfoList = {
            {Type="Text", Text = self.EscapeKey, ClickCallback=self.OnBackKeyDown, Owner=self},
        },
        GamePadInfoList =  {
            {Type="Img", ImgShortPath="B", ClickCallback=self.OnBackKeyDown, Owner=self}
        },
        Desc = GText("UI_BACK"),
    }
    self.HideUI_KeyInfoList = {
        KeyInfoList = {
            {Type="Text", Text = CommonUtils:GetKeyText("U"), ClickCallback=self.OnHideUIKeyDown, Owner=self},
        },
        GamePadInfoList =  {
            {Type="Img", ImgShortPath="X"}
        },
        Desc = GText("UI_Dye_HideUI")
    }
    self.ZoomKeyInfoList = {
        KeyInfoList = {
            {Type="Text", Text = self.ZoomKey, Owner=self},
        },
        GamePadInfoList =  {
            {Type="Or"},
            GamePadSubKeyInfoList = {
                {Type="Img", ImgShortPath="LT", Owner=self},
                {Type="Img", ImgShortPath="RT", Owner=self}
            }
        },
        Desc = GText("UI_Dye_Zoom"),
        bLongPress = false
    }
    self.RightThumbstickAnalogBottomKeyInfoList = {
        GamePadInfoList =  {
            {Type="Img", ImgShortPath="RH",}
        },
        Desc = GText("UI_CTL_RotatePreview"),
    }
    self.Btn_Function:SetDefaultGamePadImg("A")
    self.Btn_Package_Open:SetDefaultGamePadImg("A")
    self.Btn_Package_Buy:SetDefaultGamePadImg("Y")
    self.Key_Show:CreateCommonKey({ KeyInfoList = {{Type = "Img", ImgShortPath = "View"}} })
    self.Key_Dye:CreateCommonKey({ KeyInfoList = {{Type = "Img", ImgShortPath = "Y"}} })
    self.Key_Custom:CreateCommonKey({ KeyInfoList = {{Type = "Img", ImgShortPath = "Y"}} })
    M.Super.Construct(self)
    rawset(self,"FSM",FSM:New(self,{StateNames = FocusAreas,
                                    OnStateChanged = self.OnFocusStateChanged,
                                    CheckFunction = self.IsFocusStateValid,}))
    self.WBP_Com_Cost:SwitchToPC()--临时处理
    self.Key_LevelUp:CreateCommonKey({ 
        KeyInfoList = {{Type = "Img", ImgShortPath = "LS"}},
        SkipRefreshInputType = true
    })
end

function M:OnTabConfigCreated(TabConfig)
    TabConfig.StyleName = "Text"
    TabConfig.GetReplyOnBack = function()
        self.FSM:Pop()
        return self:GetReplyOnBack()
    end
    TabConfig.OnResourceBarAddedToFocusPath = self.OnResourceBarAddedToFocusPath
    TabConfig.OnResourceBarRemovedFromFocusPath = self.OnResourceBarRemovedFromFocusPath
end

function M:InitUIInfo(...)
    M.Super.InitUIInfo(self, ...)
end

function M:OnInited()
    M.Super.OnInited(self)
    rawset(self,"Inited",true)
    self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:OnTopTabSelected(...)
    M.Super.OnTopTabSelected(self,...)
    self:UpdateKeySetting()
end

function M:UpdateKeySetting()
    if(rawget(self,"bAccessoryCustomOpened"))then
        self:UpdateKeySetting_AccessoryCustom()
        return
    end
    self:ClearAllKeyEvents()
    self.BottomKeyInfo = {}
    self.RepeatKeyDownEvents = {}
    if(self.IsGamepadInput)then
        local StateName = self.FSM:Peak().Name
        if(StateName == FocusAreas.Resource)then
            self:AddKeyDownEvent(Const.GamepadFaceButtonRight,self.OnBackKeyDown)
            table.insert(self.BottomKeyInfo,self.ESCKeyInfoList)
        else
            if(not self.bSelfHidden)then
                self:AddKeyDownEvent(Const.GamepadRightThumbstick,self.OnFocusToResourceKeyDown)
                self:AddKeyDownEvent(Const.GamepadSpecialLeft,self.OnOpenVideoKeyDown)
                self:AddKeyDownEvent(Const.GamepadLeftShoulder,self.OnTabLeftKeyDown)
                self:AddKeyDownEvent(Const.GamepadRightShoulder,self.OnTabRightKeyDown)
            end
            self:AddKeyDownEvent(Const.GamepadFaceButtonRight,self.OnBackKeyDown)
            self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonLeft,self.OnHideUIKeyDown)
            if(not self.bSelfHidden and not self.IsPreviewMode and not self.IsCharacterTrialMode)then
                if(self.CurrentTopTabIdx == self.SkinTabIdx or self.CurrentTopTabIdx == self.HairTabIdx)then
                    self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonTop,self.OnGamePadFaceButtonTopKeyDown)
                elseif(self.CurrentTopTabIdx == self.AccessoryTabIdx)then
                    self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonTop,self.OnGamePadAccessoryCustomKeyDown)
                end
            end
            if (self.Panel_LevelUp:IsVisible()) then
                self:AddKeyDownEvent(UIConst.GamePadKey.LeftThumb, self.OnGamePadLeftThumbKeyDown)
            end
            table.insert(self.BottomKeyInfo,self.HideUI_KeyInfoList)
            if(self.EnableMouseWheel)then
                self.RepeatKeyDownEvents[Const.GamepadLeftTrigger] = self.OnCameraScrollBackwardKeyDown
                self.RepeatKeyDownEvents[Const.GamepadRightTrigger] = self.OnCameraScrollForwardKeyDown
                table.insert(self.BottomKeyInfo,self.ZoomKeyInfoList)
            end
            if(self.EnableDrag)then
                table.insert(self.BottomKeyInfo,self.RightThumbstickAnalogBottomKeyInfoList)
            end
            table.insert(self.BottomKeyInfo,self.ESCKeyInfoList)
        end
    else
        --键鼠
        if(not self.bSelfHidden)then
            self:AddKeyDownEvent(EKeys.Q.KeyName,self.OnTabLeftKeyDown)
            self:AddKeyDownEvent(EKeys.E.KeyName,self.OnTabRightKeyDown)
        end
        self:AddKeyDownEvent(self.EscapeKey,self.OnBackKeyDown)
        self:AddKeyDownEvent(EKeys.U.KeyName,self.OnHideUIKeyDown)
        table.insert(self.BottomKeyInfo,self.HideUI_KeyInfoList)
        if(self.EnableMouseWheel)then
            table.insert(self.BottomKeyInfo,self.ZoomKeyInfoList)
        end
        if(self.EnableDrag)then
            table.insert(self.BottomKeyInfo,self.RightThumbstickAnalogBottomKeyInfoList)
        end
        table.insert(self.BottomKeyInfo,self.ESCKeyInfoList)
    end
    self.Tab_Skin:UpdateBottomKeyInfo(self.BottomKeyInfo)
end

function M:OnFocusToResourceKeyDown()
    self.Tab_Skin:Handle_KeyEventOnGamePad(Const.GamepadRightThumbstick)
    return UIUtils.Handled,true
end

function M:OnOpenVideoKeyDown()
    self:OpenSkinVideo()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    M.Super.OnUpdateUIStyleByInputTypeChange(self,CurInputDevice, CurGamepadName)
    if(not rawget(self,"Inited"))then
        return
    end
    self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
    self:SetIsDealWithVirtualAccept(false)
    if (self.IsGamepadInput) then
        if(rawget(self,"bAccessoryCustomOpened"))then
            self:SetIsDealWithVirtualAccept(true)
        end
        self.Key_Show:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Panel_Key_Dye:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Panel_Key_Custom:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Key_LevelUp:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        if(not self.IsInFocusPath)then
            return
        end
        local State = self.FSM:Peak()
        if(not self:IsFocusStateValid(State))then
            self.FSM:Clear()
        end
        local Widget = self:GetDesiredFocusTarget()
        if(Widget and not UIUtils.HasAnyFocus(Widget))then
            Widget:SetFocus()
        end
        if State and (State.Name == FocusAreas.SkinLevelUp) then
            self.Key_LevelUp:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    else
        self.Panel_Key_Dye:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Key_Show:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Panel_Key_Custom:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Key_LevelUp:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self:UpdateKeySetting()
end

function M:OnFocusStateChanged()
    self:UpdateKeySetting()
end

function M:IsFocusStateValid(State)
    if(rawget(self,"bAccessoryCustomOpened"))then
        return self:IsFocusStateValid_AccessoryCustom(State)
    end
    local StateName = State.Name
    if(StateName == FocusAreas.SkinList)then
        return self.List_Skin:GetIndexForItem(State.Content) >= 0
    elseif(StateName == FocusAreas.AccessoryTab)then
        local CurrentTab = self.AccessoryTabsArray and self.AccessoryTabsArray[self.CurrentAccessoryTabIdx]
        return CurrentTab and CurrentTab == State.Content
    elseif(StateName == FocusAreas.AccessoryList)then
        return self.List_Accessory:GetIndexForItem(State.Content) >= 0
    elseif(StateName == FocusAreas.MVPList)then
        return self.List_SettlementAction:GetIndexForItem(State.Content) >= 0
    elseif(StateName == FocusAreas.HiddenSelf)then
        return self.bSelfHidden
    elseif(StateName == FocusAreas.Resource)then
        return true
    elseif(StateName == FocusAreas.SkinLevelUp) then
        return self.Panel_LevelUp:IsVisible()
    end
end

function M:GetDesiredFocusTarget()
    if(rawget(self,"bAccessoryCustomOpened"))then
        return self:GetDesiredFocusTarget_AccessoryCustom()
    end
    local State = self.FSM:Peak()
    local StateName = State.Name
    self.List_SettlementAction:BP_CancelScrollIntoView()
    self.List_Skin:BP_CancelScrollIntoView()
    self.List_Accessory:BP_CancelScrollIntoView()
    if(self.bSelfHidden)then
        return self
    elseif(self.CurrentTopTabIdx == self.SkinTabIdx)then
        if (StateName == FocusAreas.SkinLevelUp) then
            return self["WBP_Armory_Skin_LevelUp_" .. self.SelectedSkinLevel]
        else
            return self:NavigateToSkinList()
        end
    elseif(self.CurrentTopTabIdx == self.MVPTabIdx)then
        return  self:NavigateToMVPList()
    else
        if(StateName == FocusAreas.AccessoryTab)then
            return self:NavigateToAccessoryTab()
        else
            return  self:NavigateToAccessoryList()
        end
    end
end

function M:OnSkinContentCreated(Content)
    Content.OnAddedToFocusPath = self.OnSkinItemAddedToFocusPath
    Content.OnRemovedFromFocusPath = self.OnSkinItemRemovedFromFocusPath
end

function M:OnSkinItemAddedToFocusPath(Content)
    self.FSM:Clear()
    self.FSM:Push({Name = FocusAreas.SkinList,Content = Content})
end

function M:OnSkinItemRemovedFromFocusPath(Content)
end

function M:OnResourceBarAddedToFocusPath(Widget)
    self.FSM:Push({Name = FocusAreas.Resource,Widget = Widget})
end

function M:OnResourceBarRemovedFromFocusPath(Widget)
end

function M:NavigateToSkinList(Content)
    local Content = Content or self.SkinMap[self.SelectedSkinId]
    if(not Content or self.List_Skin:GetIndexForItem(Content) < 0)then
        Content = self.List_Skin:GetItemAt(0)
    end
    self.List_Skin:BP_CancelScrollIntoView()
    self.List_Skin:BP_SetSelectedItem(Content)
    self.List_Skin:BP_NavigateToItem(Content)
    if(Content and Content.Widget)then
        return Content.Widget
    end
    return self.List_Skin
end

function M:NavigateToAccessoryTab()
    local CurrentTab = self.AccessoryTabsArray and self.AccessoryTabsArray[self.CurrentAccessoryTabIdx]
    return CurrentTab and CurrentTab.UI
end

function M:NavigateToAccessoryList()
    local Content = self.ComparedContent or self.CurrentContent
    if(not Content or self.List_Accessory:GetIndexForItem(Content) < 0)then
        Content = self.List_Accessory:GetItemAt(0)
    end
    self.List_Accessory:BP_CancelScrollIntoView()
    self.List_Accessory:BP_SetSelectedItem(Content)
    self.List_Accessory:BP_NavigateToItem(Content)
    if(Content and Content.SelfWidget)then
        return Content.SelfWidget
    end
    return self.List_Accessory
end

function M:OnAccessoryContentCreated(Content)
    Content.OnAddedToFocusPathEvent = {Obj = self,Callback = function()
        self.FSM:Clear()
        self.FSM:Push({Name = FocusAreas.AccessoryList,Content = Content})
    end}
    Content.OnRemovedFromFocusPathEvent = {Obj = self,Callback = function()
    end}
end

function M:OnAccessoryTabContentCreated(Content,Widget)
    Content.OnAddedToFocusPath = function()
        self.FSM:Clear()
        self.FSM:Push({Name = FocusAreas.AccessoryTab,Content = Content,Widget = Widget})
    end
    Content.OnRemovedFromFocusPath = function()
    end
end

function M:NavigateToMVPList()
    local Content = self.ComparedContent or self.CurrentContent
    if(not Content or self.List_SettlementAction:GetIndexForItem(Content) < 0)then
        Content = self.List_SettlementAction:GetItemAt(0)
    end
    self.List_SettlementAction:BP_CancelScrollIntoView()
    self.List_SettlementAction:BP_SetSelectedItem(Content)
    self.List_SettlementAction:BP_NavigateToItem(Content)
    if(Content and Content.Widget)then
        return Content.Widget
    end
    return self.List_SettlementAction
end

function M:OnMVPContentCreated(Content)
    Content.OnAddedToFocusPath = function()
        self.FSM:Clear()
        self.FSM:Push({Name = FocusAreas.MVPList,Content = Content})
    end
end

function M:OnHairContentCreated(Content)
    Content.OnAddedToFocusPathEvent = {Obj = self,Callback = function()
        self.FSM:Clear()
        self.FSM:Push({Name = FocusAreas.AccessoryList,Content = Content})
    end}
    Content.OnRemovedFromFocusPathEvent = {Obj = self,Callback = function()
    end}
end

function M:OnAddedToFocusPath()
    self.IsInFocusPath = true
end

function M:OnRemovedFromFocusPath()
    self.IsInFocusPath = false
end

function M:OnCharAccessoryTabClicked(...)
    M.Super.OnCharAccessoryTabClicked(self,...)
    self:InitAccessoryNavigationRules()
end

function M:OnWeaponAccessoryTabClicked(...)
    M.Super.OnWeaponAccessoryTabClicked(self,...)
    self:InitAccessoryNavigationRules()
end

--列表间的导航
function M:InitAccessoryNavigationRules()
    self.Tab_Accessory:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.Tab_Accessory:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self.Tab_Accessory:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.List_Accessory:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.List_Accessory:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self.List_Accessory:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    if(self.Tab_Accessory:IsVisible())then
        self.Tab_Accessory:SetNavigationRuleCustom(EUINavigation.Right, {self, function()
            return self:NavigateToAccessoryList()
        end})
        self.List_Accessory:SetNavigationRuleCustom(EUINavigation.Left,{self, function()
            return self:NavigateToAccessoryTab()
        end})
    end
end

function M:OnAccessoryListSelectionChanged(Content,IsSelected)
    if(not IsSelected or not self.IsGamepadInput)then
        return
    end
    if(self.CurrentTopTabIdx == self.HairTabIdx)then
        --发型和配饰使用了同一个列表
        self:OnHairItemClicked(Content)
    else
        self:TrySelectAccessoryItem(Content)
    end
end

function M:OnAccessoryItemClicked(Content)
    if (self.IsGamepadInput) then
        self:OnGamePadConfirKeyDown()
    else
        M.Super.OnAccessoryItemClicked(self,Content)
    end
end

function M:OnSkinListSelectionChanged(Content,IsSelected)
    if (self.IsGamepadInput) then
        M.Super.OnSkinItemClicked(self,Content)
    end
end

function M:OnMVPListSelectionChanged(Content,IsSelected)
    if (self.IsGamepadInput) then
        M.Super.OnMVPItemClicked(self,Content)
    end
end

function M:OnMVPItemClicked(Content)
    if (self.IsGamepadInput) then
        self:OnGamePadConfirKeyDown()
    else
        M.Super.OnMVPItemClicked(self,Content)
    end
end

function M:OnSkinItemClicked(Content)
    if (self.IsGamepadInput) then
        self:OnGamePadConfirKeyDown()
    else
        M.Super.OnSkinItemClicked(self,Content)
    end
end

--手柄A键按下时
function M:OnGamePadConfirKeyDown()
    if(rawget(self,"bAccessoryCustomOpened"))then
        return self:OnGamePadConfirKeyDown_AccessoryCustom()
    end
    if(self.IsPreviewMode or self.IsCharacterTrialMode)then
        return UIUtils.Handled,true
    end
    if(self.Btn_Function:IsVisible() and not self.Btn_Function:IsBtnForbidden() and self.WidgetSwitcher_BtnState:GetActiveWidgetIndex() == 0)then
        if(self.RightConfirmBtnFunc)then
            self.RightConfirmBtnFunc(self)
        end
    end
    return UIUtils.Handled,true
end

--手柄Y键按下时
function M:OnGamePadFaceButtonTopKeyDown()
    if(self.IsPreviewMode or self.IsCharacterTrialMode)then
        return UIUtils.Handled,true
    end
    if(self.LeftConfirmBtnFunc)then
        self.LeftConfirmBtnFunc(self)
        return
    end
    if(self.IsTargetUnowned)then
        return UIUtils.Handled,true
    end
    local Content
    if(self.CurrentTopTabIdx == self.HairTabIdx)then
        Content = self.HairMap[self.SelectedHairId]
    else
        Content = self.SkinMap[self.SelectedSkinId]
    end
    if(not Content)then
        return UIUtils.Handled,true
    end
    if(Content.bDyeable and not Content.LockType)then
        self:OpenDye()
    end
    return UIUtils.Handled,true
end

--手柄左摇杆键按下时
function M:OnGamePadLeftThumbKeyDown()
    if(self.IsPreviewMode or self.IsCharacterTrialMode)then
        return UIUtils.Handled,true
    end
    if (not self.Panel_LevelUp:IsVisible()) then
        return UIUtils.Handled,true
    end

    self.Key_LevelUp:SetVisibility(UIConst.VisibilityOp.Collapsed)
    local CurLevelUpWidget = self["WBP_Armory_Skin_LevelUp_" .. self.SelectedSkinLevel]
    if (CurLevelUpWidget) then
        CurLevelUpWidget:SetFocus()
        self.FSM:Push({Name = FocusAreas.SkinLevelUp,Content = CurLevelUpWidget})
    end
    return UIUtils.Handled,true
end

function M:OnGamePadAccessoryCustomKeyDown()
    return self:TryOpenAccessoryCustom()
end

function M:OnCameraScrollBackwardKeyDown()
    self:ScrollCamera(1)
end

function M:OnCameraScrollForwardKeyDown()
    self:ScrollCamera(-1)
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    if(CommonUtils:IfExistSystemGuideUI(self)) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    M.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local StateName = self.FSM:Peak().Name
    if(InKeyName == Const.GamepadFaceButtonDown and StateName ~= FocusAreas.Resource)then
        self:OnGamePadConfirKeyDown()
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnRepeatKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local RepeatKeyDownEvent = self.RepeatKeyDownEvents[InKeyName]
    if(RepeatKeyDownEvent)then
        local Reply,IsHandled = RepeatKeyDownEvent(self)
        if(IsHandled)then
            return Reply
        end
    end
    return UIUtils.Handled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    if(CommonUtils:IfExistSystemGuideUI(self)) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    local Reply,IsHandled = self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
    if(IsHandled)then
        return Reply
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    local Reply = M.Super.OnFocusReceived(self,MyGeometry, InFocusEvent)
    if(not self.IsGamepadInput)then
        return UIUtils.Handled
    end
    local Widget = self:GetDesiredFocusTarget()
    if(Widget == self)then
        self:OnFocusStateChanged()
        return UIUtils.Handled
    end
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),Widget)
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    if(not self.EnableDrag)then
        return UIUtils.Unhandled
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if(InKeyName == "Gamepad_RightX")then
        if(self.ActorController)then
            local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
            self.ActorController:OnDragViewActor({X=DeltaX})
        end
        return UIUtils.Handled
    elseif(InKeyName == "Gamepad_RightY")then
        if(rawget(self,"bAccessoryCustomOpened"))then
            local Delta = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) / 10
            self:ScrollCamera(Delta)
        end
    end
    return UIUtils.Unhandled
end

function M:OnTabLeftKeyDown()
    self.Tab_Skin:TabToLeft()
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:GetDesiredFocusTarget()),true
end

function M:OnTabRightKeyDown()
    self.Tab_Skin:TabToRight()
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:GetDesiredFocusTarget()),true
end

function M:OnHideUIKeyDown()
    M.Super.OnHideUIKeyDown(self)
    self:OnFocusStateChanged()
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:GetDesiredFocusTarget()),true
end

function M:GetReplyOnBack()
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:GetDesiredFocusTarget()),true
end

function M:OnBackKeyDown()
    local StateName = self.FSM:Peak().Name
    if(StateName == FocusAreas.SkinLevelUp) then
        self.FSM:Pop()
        self.Key_LevelUp:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:GetDesiredFocusTarget()),true
    else
        return M.Super.OnBackKeyDown(self)
    end
end

AssembleComponents(M)
return M

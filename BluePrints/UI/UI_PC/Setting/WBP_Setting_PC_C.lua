--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local SettingUtils = require "Utils.SettingUtils"
local EMCache = require "EMCache.EMCache"
local WBP_Setting_PC_C = Class({"Blueprints.UI.BP_UIState_C"})

local Rule = FSlateChildSize()
Rule.SizeRule = UE.ESlateSizeRule.Fill
Rule.Value = 1.0

function WBP_Setting_PC_C:Initialize(Initializer)
    self.NpcId = 900003                 -- 界面的NpcId
    self.IsNeedPlayNpcAnim = true       -- 是否播放Npc退场动画
end

function WBP_Setting_PC_C:Construct()
    WBP_Setting_PC_C.Super.Construct(self)
    self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    ReddotManager.AddListener("Setting_Control_LayOutBtn",self,self.RefreshReddot)
    ReddotManager.AddListener("Setting_Control",self,self.RefreshReddot)
    ReddotManager.AddListener("Setting_Control_SettingBtn",self,self.RefreshReddot)
end

function WBP_Setting_PC_C:Destruct()
    ReddotManager.RemoveListener("Setting_Control_LayOutBtn", self)
    ReddotManager.RemoveListener("Setting_Control", self)
    ReddotManager.RemoveListener("Setting_Control_SettingBtn", self)
end

function WBP_Setting_PC_C:OnLoaded(...)
    self.Super.OnLoaded(self,...)
    self.IsInLoginMainPage,self.LastSystem = ... --是否是登录界面,上一个系统，退出时重新设置聚焦
    self.Plan1CurrentLayout = 1
    self.Plan2CurrentLayout = 2
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        self.Plan1CurrentLayout, self.Plan2CurrentLayout = Avatar:GetMappedPlanCurrentLayout()
    end
    rawset(self, "SettingUIs",{})
    rawset(self, "HoverContentList",{})
    rawset(self, "Platform",CommonUtils.GetDeviceTypeByPlatformName(self))--移动端还是PC端
    rawset(self, "IsUnfoldListOpen",false)
    rawset(self, "AutoClose",false)
    rawset(self, "IsInFullScreenMode",true) --是否处于全屏模式
    rawset(self, "ScreenSize",FVector2D(1920,1080))
    self:PlayInAnim()
    self.ScrollBox_Option:ClearChildren()
    self:InitSettingParameter()
    self:InitCommonTab(1, false)
    self:AddTimer(0.033, self.ListenScreenResolution, true, 0.0, "ListenScreenResolution",true)
    -- local ComponentClass = LoadObject('/Game/Asset/Char/Npc/Npc_Bai_Tongxun/Mesh/BaiTX_Part01_SM.BaiTX_Part01_SM')
    if not self.IsInLoginMainPage then
        UIManager(self):SwitchUINpcCamera(true,"Setting", self.NpcId, {IsHaveInOutAnim=self.IsNeedPlayNpcAnim})
    end
    self.RegionOnline = EMCache:Get("AutoJoin")
    self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self:FocusToOptionFirstWidget()
    end
    self:AddDispatcher(EventID.OnSwitchMobileHUDLayout, self.OnSwitchMobileHUDLayout)
end

function WBP_Setting_PC_C:OnSwitchMobileHUDLayout(PlanIndex)
    if PlanIndex % 2 == 0 then
        self.Plan2CurrentLayout = PlanIndex
    else
        self.Plan1CurrentLayout = PlanIndex
    end
end

-- 手柄端
---------------------------------------------------------------------------

function WBP_Setting_PC_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if CurInputDevice == ECommonInputType.Gamepad then
        self:RefreshAllGamePadOperator(self.OptionUnfold_Prefrence.NowOptionId)
    end
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end

    self.CurInputDeviceType = CurInputDevice
    self:UpdateUIStyleInPlatform(self.CurInputDeviceType == ECommonInputType.Gamepad)
end

function WBP_Setting_PC_C:UpdateUIStyleInPlatform(IsUseGamePad)
    if self.Com_KeyImg_L then
        self.Com_KeyImg_L:SetVisibility(IsUseGamePad and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
        self.Com_KeyImg_R:SetVisibility(IsUseGamePad and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
        self.Image_83:SetVisibility(IsUseGamePad and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
    end
    if IsUseGamePad then
        self:InitGamepadView()
    elseif UIUtils.IsMobileInput() then
        self:InitMobileView()
    else
        self:InitKeyboardView()
    end
end

function WBP_Setting_PC_C:InitGamepadView()
    self.ScrollBox_Option:SetScrollWhenFocusChanges(UE4.EScrollWhenFocusChanges.AnimatedScroll)
    if self:HasAnyFocus() then 
        self:FocusToOptionFirstWidget()
    end
end

function WBP_Setting_PC_C:UpdateKeyboardBottonKey()
    local Params = {
        { KeyInfoList = {{Type="Text", Text="R",  ClickCallback=self.OnPressR, Owner=self}},
            GamePadInfoList = {{Type="Img", ImgShortPath="X", ClickCallback=self.OnPressR, Owner=self}},
            Desc = GText("UI_OPTION_DEFAULT"),},
        { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.OnPressESC, Owner=self}},
            GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnPressESC, Owner=self}},
            Desc = GText("UI_BACK")},
    }

    if self.HasBeenChanged then
        table.insert(Params, 1, { KeyInfoList = {{Type="Text", Text="Y", ClickCallback=self.OnPressY, Owner=self}},
        GamePadInfoList = {{Type="Img", ImgShortPath="Y", ClickCallback=self.OnPressY, Owner=self}}, 
        Desc = GText("UI_ACCEPT"),})
    end
    
    if not UIUtils.IsMobileInput() then
        self.Tab_Set:UpdateBottomKeyInfo(Params)
    end
end

function WBP_Setting_PC_C:InitMobileView()
    
end

function WBP_Setting_PC_C:InitKeyboardView()
    self.ScrollBox_Option:SetScrollWhenFocusChanges(UE4.EScrollWhenFocusChanges.NoScroll)
    self:UpdateKeyboardBottonKey()
end

function WBP_Setting_PC_C:OnSettingUINavigateUp(Widget, Index)
    local NextWidget = self.SettingUIs[self.CurrentTab][Index-1]
    if NextWidget then
        return NextWidget:GetLastWidgetToNavigate()
    end

    return nil
end

function WBP_Setting_PC_C:OnSettingUINavigateDown(Widget, Index)
    local NextWidget = self.SettingUIs[self.CurrentTab][Index+1]
    if NextWidget then 
        return NextWidget:GetFirstWidgetToNavigate()
    end

    return nil
end

function WBP_Setting_PC_C:FocusToOptionFirstWidget()
    if not self.CurrentTab then
        return
    end
    if self.CurrentTab == 1 and self.MultiPlateIndex == 2 and not self.IsInLoginMainPage then
        if self.OptionUnfold_Prefrence then
            self:AddDelayFrameFunc(function()
                self.OptionUnfold_Prefrence:SetFocus()
            end, 1)
        end
        return
    end
    local FirstPanel = self.SettingUIs[self.CurrentTab][1]
    if FirstPanel then 
        local FirstWidget = FirstPanel:GetFirstWidgetToNavigate()
        FirstWidget:SetFocus()
    else
        self:SetFocus()
    end
end

function WBP_Setting_PC_C:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == UIConst.GamePadKey.RightAnalogX and self.MultiPlateIndex == 2 and self.Tab_MultiPlate and self.Tab_MultiPlate:GetVisibility() ~= UE4.ESlateVisibility.Collapsed then
        local DeltaOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 20
        local CurrentOffset = self.SC_Combination:GetScrollOffset()
        local NextOffset = math.clamp(CurrentOffset + DeltaOffset,0, self.SC_Combination:GetScrollOffsetOfEnd())
        if self.SC_Combination:GetScrollOffsetOfEnd() > NextOffset and self.SC_Combination:GetScrollOffsetOfEnd() - NextOffset < 1 then
            NextOffset = self.SC_Combination:GetScrollOffsetOfEnd()
        elseif NextOffset < 1 then
            NextOffset = 0
        end
        self.SC_Combination:SetScrollOffset(NextOffset)
        self:OnScrollBoxTaskScrolled()
        return UIUtils.Handled
    end
    return UIUtils.Unhandled
end

-- 当聚焦在设置页面二级Title时调用
function WBP_Setting_PC_C:OnGamepadFocusPanelTitle()
    self:UpdateBottomKey({        
        {UIConst.GamePadImgKey.FaceButtonBottom, GText("UI_CTL_Squad_Expand")},
        {UIConst.GamePadImgKey.FaceButtonRight, GText("UI_BACK")},
    })
end

function WBP_Setting_PC_C:UpdateBottomKey(Params)
    if UIUtils.IsGamepadInput() then
        local FinalParams = {}
        if UIUtils.IsGamepadInput() and self.MultiPlateIndex == 2 and self.Tab_MultiPlate and self.Tab_MultiPlate:GetVisibility() ~= UE4.ESlateVisibility.Collapsed then
            table.insert(FinalParams, {"RH", GText("UI_Controller_Slide")})
        end
        if self.HasBeenChanged then
            table.insert(FinalParams, {UIConst.GamePadImgKey.FaceButtonTop, GText("UI_ACCEPT")})
        end
        table.insert(FinalParams, {UIConst.GamePadImgKey.FaceButtonLeft, GText("UI_OPTION_DEFAULT")})
        for i, Param in ipairs(Params) do
            table.insert(FinalParams, Param)
        end
        self.Tab_Set:UpdateBottomKeyInfo_Quick(FinalParams)
    end
end

function WBP_Setting_PC_C:SetFocus_Lua()
    if self.CurInputDeviceType and self.CurInputDeviceType == ECommonInputType.Gamepad then
            self:AddDelayFrameFunc(function()
                self:FocusToOptionFirstWidget()
            end, 1)
        return
    end
end

---------------------------------------------------------------------------

function WBP_Setting_PC_C:ListenScreenResolution()
    local ScreenSize = FVector2D(0, 0)
    UE4.UWidgetLayoutLibrary.GetViewportSize(self, ScreenSize)
    if self.ScreenSize ~= ScreenSize then
        self.ScreenSize = ScreenSize
        if self.IsUnfoldListOpen then
            self.WBP_Set_UnfoldList:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        self:OnClickAllLeftMouseButton()
    end
end

function WBP_Setting_PC_C:InitSettingParameter()
    self.HasBeenChanged = false    --是否有设置被修改
end

function WBP_Setting_PC_C:InitCommonTab(TabId, DontPlayInAnim)
    self:InitCommonTabInfo()
    if self.Platform == "PC" then
        self.Tab_Set:Init({LeftKey = "Q", RightKey = "E", Tabs = self.CommonTabInfo,
                            DynamicNode = {"Back","BottomKey"},
                            BottomKeyInfo = {},
                            TitleName = GText("UI_Esc_CommonSet"),
                            StyleName = "Text", OwnerPanel = self, BackCallback = self.OnPressESC},DontPlayInAnim)
        self:UpdateKeyboardBottonKey()
    else
        self.Tab_Set:Init({Tabs = self.CommonTabInfo,
                                DynamicNode = {"Back"},
                                TitleName = GText("UI_Esc_CommonSet"),
                                StyleName = "Text", OwnerPanel = self, BackCallback = self.OnPressESC},DontPlayInAnim)
        self.Btn_Default:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Default:BindEventOnClicked(self,self.OnPressR)
    end
    if self.Tab_MultiPlate then
        self.Tab_MultiPlate:Init({LeftKey = "A", RightKey = "D", Tabs = {
            {
                Text = GText("UI_OPTION_Keyboard"),
                TabId = 1,
            },
            {
                Text = GText("UI_OPTION_Gamepad"),
                TabId = 2,
            }
        }})
    end
    self.MultiPlateIndex = UIUtils.IsGamepadInput() and 2 or 1
    self.Tab_Set:BindEventOnTabSelected(self, self.OnTabSelected)
    self.Tab_Set:SelectTab(TabId)
    if self.Tab_MultiPlate then
        self.Tab_MultiPlate:BindEventOnTabSelected(self, self.OnMultiPlateTabSelected)
        self.Tab_MultiPlate:SelectTab(self.MultiPlateIndex)
    end
    self.WBP_Set_UnfoldList:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if self.OptionUnfold_Prefrence then
        self.OptionUnfold_Prefrence:Init(self, "GamepadPreset", DataMgr.Option["GamepadPreset"])
    end
    self.GamePadXBOXDirection = {
        ["WB_Key_View"] = "Left",
        ["WB_Key_LBT"] = "Left",
        ["WB_Key_L"] = "Left",
        ["WB_Key_Direc"] = "Left",
    }
    if self.OptionUnfold_Prefrence then
        self.Btn_TabL.OnClicked:Clear()
        self.Btn_TabR.OnClicked:Clear()
        self.GamepadBottomContent = "Combo1"
        self.IsTabLClick = true
        self:PlayAnimation(self.TabL_Click)
        self:PlayAnimation(self.TabR_Normal)
        self.Btn_TabL.OnClicked:Add(self, function()
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
            self:ShowFightGamepadBottomContent()
        end)
        self.Btn_TabR.OnClicked:Add(self, function()
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
            self:ShowSystemGamepadBottomContent()
        end)
        self.Text_TabName_Sel:SetText(GText("UI_CharVoice_Battle"))
        self.Text_TabName_Sel_1:SetText(GText("UI_CTL_System"))
        if self.Com_KeyImg_L then
            self.Com_KeyImg_L:CreateCommonKey({
                KeyInfoList={
                    {
                        Type = "Img",
                        ImgShortPath = "Left",
                    },
                },
            })
            self.Com_KeyImg_R:CreateCommonKey({
                KeyInfoList={
                    {
                        Type = "Img",
                        ImgShortPath = "Right",
                    },
                },
            })
        end
        self:RefreshAllGamePadOperator(self.OptionUnfold_Prefrence.NowOptionId)
        self.SC_Combination.OnUserScrolled:Remove(self, self.OnScrollBoxTaskScrolled)
        self.SC_Combination.OnUserScrolled:Add(self, self.OnScrollBoxTaskScrolled)
        self:OnScrollBoxTaskScrolled()
    end
    self:InitLayoutPlantUI()
end

function WBP_Setting_PC_C:OnScrollBoxTaskScrolled()
    if not self.SC_Combination then
        return
    end
    self:AddDelayFrameFunc(function()
        UIUtils.UpdateScrollBoxArrow(self.SC_Combination, self.Btn_L, self.Btn_R)
    end, 2)
end

function WBP_Setting_PC_C:InitLayoutPlantUI()
    self.IsInitLayoutPlan = false
    if self.Platform ~= "Mobile" then
        return
    end
    if self.CommonTabInfo[self.CurrentTab].TabName ~= "Control" then
        self.Tab_State:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Panel_Tab:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.WS_State:SetActiveWidgetIndex(0)
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local Count = Avatar:GetMobileHudPlanCount()
    for i = Count + 1, 2 do
        Avatar:AddMobileHudPlan({})
    end
    self.IsInitLayoutPlan = true
    self.CurPlanIndex = Avatar:GetCurrentMobileHudPlanIndex()
    self.Tab_State:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Panel_Tab:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Tab_State:Init({
        Tabs = {
            {Text = GText("UI_OPTION_Layout"), TabId = 1},
            {Text = GText("UI_OPTION_Operation"), TabId = 2},
        },
    })
    self.LayoutPlantIndex = nil
    self.Layout_01.Index = 1
    self.Layout_02.Index = 2
    self.Tab_State:BindEventOnTabSelected(self, self.OnOperateTabSelected)
    self.Tab_State:SelectTab(1)
    self.Layout_01.Text_Plan:SetText(GText("UI_Setting_Layout01"))
    self.Layout_02.Text_Plan:SetText(GText("UI_Setting_Layout02"))
    self.Layout_01.Btn_CustomLayout.Text_Button:SetText(GText("UI_Setting_CustomLayout"))
    self.Layout_02.Btn_CustomLayout.Text_Button:SetText(GText("UI_Setting_CustomLayout"))

    self.Layout_01.Btn_Area.OnClicked:Add(self, self.OnClickLayout1)
    self.Layout_02.Btn_Area.OnClicked:Add(self, self.OnClickLayout2)
    
    self:InitLayoutPlanList()
    self:RefreshReddot()
end

function WBP_Setting_PC_C:RefreshReddot()
    local RedDot = ReddotManager.GetTreeNode("Setting_Control_LayOutBtn")
    if self.Tab_State then
        if RedDot and RedDot.Count > 0 then
            self.Tab_State:ShowTabRedDotByTabId(1, true)
        else
            self.Tab_State:ShowTabRedDotByTabId(1)
        end
    end

    RedDot = ReddotManager.GetTreeNode("Setting_Control_SettingBtn")
    if RedDot and RedDot.Count > 0 and self.Tab_State then
        self.Tab_State:ShowTabRedDotByTabId(2, true)
    else
        if self.Tab_State then
            self.Tab_State:ShowTabRedDotByTabId(2)
        end
    end

    RedDot = ReddotManager.GetTreeNode("Setting_Control")
    if RedDot and RedDot.Count > 0 and self.CurrentTab and self.CommonTabInfo[self.CurrentTab].TabName == "Control" then
        self.Tab_Set:ShowTabRedDotByTabId(self.CurrentTab, true)
    else
        self.Tab_Set:ShowTabRedDotByTabId(self.CurrentTab)
    end
end

function WBP_Setting_PC_C:InitLayoutPlanList()
    self.List_CustomOption:ClearListItems()
    local LayoutPlanTab = {
        "LeftBulletJumpShow",
        "LeftShootShow",
    }
    table.sort(LayoutPlanTab, function(a, b)
        local OptionConfig1 = DataMgr.Option[a]
        local OptionConfig2 = DataMgr.Option[b]
        if OptionConfig1.SortId and OptionConfig2.SortId then
            return OptionConfig1.SortId < OptionConfig2.SortId
        else
            return a < b
        end
    end)
    for i = 1, #LayoutPlanTab do
        local OptionContent = NewObject(UIUtils.GetCommonItemContentClass())
        local OptionConfig = DataMgr.Option[LayoutPlanTab[i]]
        OptionContent.Cache = OptionConfig.Cache
        OptionContent.ParentWidget = self
        OptionContent.UpdateBottomKeyFunc = function(Params)
            
        end
        OptionContent.OnItemNavigateUp = function(Item, Widget)
            return nil
        end
        OptionContent.OnItemNavigateDown = function(Item, Widget)
            return nil
        end
        self.List_CustomOption:AddItem(OptionContent)
    end
end

function WBP_Setting_PC_C:OnClickLayout1()
    if self.Layout_02.LayoutState == UIConst.ButtonState.Click then
        self.Layout_02:PlayAnimation(self.Layout_02.Normal)
        self.Layout_02.LayoutState = UIConst.ButtonState.None
    end
    self.CurPlanIndex = self.Plan1CurrentLayout
    EventManager:FireEvent(EventID.OnSwitchMobileHUDLayout, self.Plan1CurrentLayout)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    Avatar:SwitchMobileHudPlan(self.Plan1CurrentLayout)
end

function WBP_Setting_PC_C:OnClickLayout2()
    if self.Layout_01.LayoutState == UIConst.ButtonState.Click then
        self.Layout_01:PlayAnimation(self.Layout_01.Normal)
        self.Layout_01.LayoutState = UIConst.ButtonState.None
    end
    self.CurPlanIndex = self.Plan2CurrentLayout
    EMCache:Set("FirstOpenLayoutPlan", true, true)
    self.Layout_02.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    EventManager:FireEvent(EventID.OnSwitchMobileHUDLayout, self.Plan2CurrentLayout)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    Avatar:SwitchMobileHudPlan(self.Plan2CurrentLayout)
    local RedDot = ReddotManager.GetTreeNode("Setting_Layout")
    if RedDot and RedDot.Count > 0 then
        ReddotManager.ClearLeafNodeCount("Setting_Layout")
    end
end

function WBP_Setting_PC_C:OnOperateTabSelected(TabWidget)
    if self.LayoutPlantIndex == TabWidget.Idx then
        return
    end
    self.LayoutPlantIndex = TabWidget.Idx
    if self.LayoutPlantIndex == 1 then
        self.WS_State:SetActiveWidgetIndex(1)
        self.Layout_01:InitLayoutPlan(self.CurPlanIndex, self.Plan1CurrentLayout)
        self.Layout_02:InitLayoutPlan(self.CurPlanIndex, self.Plan2CurrentLayout)
    else
        self.WS_State:SetActiveWidgetIndex(0)
        self:UpdateEmptyGridCount()
    end
end

function WBP_Setting_PC_C:ShowFightGamepadBottomContent()
    if self.GamepadBottomContent == "Combo1" then
        return
    end
    self:PlayAnimation(self.TabL_Click)
    self:PlayAnimation(self.TabR_Normal)
    self.IsTabLClick = true
    self.GamepadBottomContent = "Combo1"
    self:RefreshGamepadOperationSystemBottom(self.OptionUnfold_Prefrence.NowOptionId)
    self.SC_Combination:SetScrollOffset(0)
    self:OnScrollBoxTaskScrolled()
end

function WBP_Setting_PC_C:ShowSystemGamepadBottomContent()
    if self.GamepadBottomContent == "Combo2" then
        return
    end
    self:PlayAnimation(self.TabR_Click)
    self:PlayAnimation(self.TabL_Normal)
    self.IsTabLClick = false
    self.GamepadBottomContent = "Combo2"
    self:RefreshGamepadOperationSystemBottom(self.OptionUnfold_Prefrence.NowOptionId)
    self.SC_Combination:SetScrollOffset(0)
    self:OnScrollBoxTaskScrolled()
end

function WBP_Setting_PC_C:OnMultiPlateTabSelected(TabWidget)
    if self.MultiPlateIndex == TabWidget.Idx then
        return
    end
    if self.OptionUnfold_Prefrence.IsListOpen then
        self.OptionUnfold_Prefrence:OnClickSubOptionList()
    end
    if self.HasBeenChanged then
        if self.MultiPlateIndex == 2 and TabWidget.Idx == 1 then
            local Params = {}
            local PopConfig = DataMgr.CommonPopupUIContext[100190]
            local ContentStr = PopConfig.PopoverText
            Params.LeftCallbackObj = self
            Params.LeftCallbackFunction = function()
                self.MultiPlateTabUpdate = true
                self:RestoreOldValueSet()
                self:InitSettingParameter()
                self:UpdateKeyboardBottonKey()
                self.OptionUnfold_Prefrence:RestoreOldGamepadPresetInLocal()
                self.MultiPlateIndex = TabWidget.Idx
                self.WidgetSwitcher_MP:SetActiveWidgetIndex(self.MultiPlateIndex - 1)
                if (self.MultiPlateIndex - 1) == 1 then
                    self:UpdateEmptyGridCount()
                end
            end
            Params.RightCallbackObj = self
            Params.RightCallbackFunction = function()
                self.MultiPlateTabUpdate = true
                self:SaveAllSetting()
                self.MultiPlateIndex = TabWidget.Idx
                self.WidgetSwitcher_MP:SetActiveWidgetIndex(self.MultiPlateIndex - 1)
                if (self.MultiPlateIndex - 1) == 1 then
                    self:UpdateEmptyGridCount()
                end
            end
            Params.ShortText = string.format(GText(ContentStr), self.OptionUnfold_Prefrence:GetGamepadPresetOptionContentText())
            UIManager(self):ShowCommonPopupUI(100190, Params, self)
        elseif self.MultiPlateIndex == 1 and TabWidget.Idx == 2 then
            local Params = {}
            Params.LeftCallbackObj = self
            Params.LeftCallbackFunction = function()
                self:OnCancelClickOtherSet()
                self.MultiPlateIndex = TabWidget.Idx
                self.WidgetSwitcher_MP:SetActiveWidgetIndex(self.MultiPlateIndex - 1)
                if (self.MultiPlateIndex - 1) == 1 then
                    self:UpdateEmptyGridCount()
                end
            end
            Params.RightCallbackObj = self
            Params.RightCallbackFunction = function()
                self:SaveAllSetting()
                self.MultiPlateIndex = TabWidget.Idx
                self.WidgetSwitcher_MP:SetActiveWidgetIndex(self.MultiPlateIndex - 1)
                if (self.MultiPlateIndex - 1) == 1 then
                    self:UpdateEmptyGridCount()
                end
            end
            UIManager(self):ShowCommonPopupUI(100010,Params, self)
        end
    else
        self.MultiPlateIndex = TabWidget.Idx
        self.WidgetSwitcher_MP:SetActiveWidgetIndex(self.MultiPlateIndex - 1)
        if (self.MultiPlateIndex - 1) == 1 then
            self:UpdateEmptyGridCount()
        end
        self:FocusToOptionFirstWidget()
    end
    self:OnScrollBoxTaskScrolled()
end

function WBP_Setting_PC_C:RefreshAllGamePadOperator(PreferenceId)
    self:RefreshGamepadOperationSystemByIndex(PreferenceId, self.WBP_Set_GamePadXBOX_C_1)
    self:RefreshGamepadOperationSystemByIndex(PreferenceId, self.WBP_Set_GamePadPS5)
end

function WBP_Setting_PC_C:RefreshGamepadOperationSystemByIndex(PreferenceId, GamePadOperator)
    self.Node_GamePad:SetActiveWidgetIndex(UIUtils.UtilsGetCurrentGamepadName() == "PS" and 1 or 0)
    GamePadOperator.WB_Key_XYBA:ClearChildren()
    GamePadOperator.WB_Key_R:ClearChildren()
    GamePadOperator.WB_Key_RBT:ClearChildren()
    GamePadOperator.WB_Key_Menu:ClearChildren()
    GamePadOperator.WB_Key_View:ClearChildren()
    GamePadOperator.WB_Key_LBT:ClearChildren()
    GamePadOperator.WB_Key_L:ClearChildren()
    GamePadOperator.WB_Key_Direc:ClearChildren()
    local GamepadSet = {}
    for _, V in pairs(DataMgr.GamepadSet) do
        table.insert(GamepadSet, V)
    end
    table.sort(GamepadSet, function(a, b) return a.Order < b.Order end)
    for _, V in ipairs(GamepadSet) do
        local AreaName = ""
        if V.KeyRegion[PreferenceId] then
            AreaName = V.KeyRegion[PreferenceId]
        else
            AreaName = V.KeyRegion[1]
        end
        local IconList = UIUtils.GetIconListByActionNameAndSetNum(V.ActionName, PreferenceId)
        if GamePadOperator[AreaName] then
            local FilePath = self.GamePadXBOXDirection[AreaName] and '/Game/UI/WBP/Set/Widget/WBP_Set_KeyGamePad_L.WBP_Set_KeyGamePad_L' or '/Game/UI/WBP/Set/Widget/WBP_Set_KeyGamePad_R.WBP_Set_KeyGamePad_R'
            local Widget = UIManager(self):CreateWidget(FilePath, false)
            GamePadOperator[AreaName]:AddChild(Widget)
            Widget.Key_GamePad:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
            local KeyText = V.TextHighLight and string.format("<Highlight>%s</>", GText(V.KeyText)) or GText(V.KeyText)
            Widget.Key_GamePad:CreateCommonKey({
                KeyInfoList={
                    {
                        Type = "Img",
                        ImgShortPath = IconList and IconList[1] or V.GamepadIcon[1],
                    },
                },
                Desc = KeyText
            })
        end
    end
    self:PlayAnimation(self.GamePadChange)
    self:RefreshGamepadOperationSystemBottom(PreferenceId)
end

function WBP_Setting_PC_C:RefreshGamepadOperationSystemBottom(PreferenceId)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if not Player then
        return
    end
    self.HB_Combination:ClearChildren()
    local ComboList = {}
    local GamepadSet = {}
    for _, V in pairs(DataMgr.GamepadSet) do
        if V.KeyRegion[1] and V.KeyRegion[1] == self.GamepadBottomContent then
            table.insert(GamepadSet, V)
        end
    end
    table.sort(GamepadSet, function(a, b) return a.Order < b.Order end)
    for k, v in ipairs(GamepadSet) do
        if v.KeyRegion then
            local IconList = UIUtils.GetIconListByActionNameAndSetNum(v.ActionName, PreferenceId)
            if IconList then
                local KeyText = v.TextHighLight and string.format("<Highlight>%s</>", GText(v.KeyText)) or GText(v.KeyText)
                table.insert(ComboList, {IconList, KeyText})
            end
        end
    end
    local Count = #ComboList
    if Count == 0 then
        return
    end
    local Circle = math.modf(Count / 2 + 0.5)
    for i = 1, Circle do
        local Index = i * 2 - 1
        local FilePath = '/Game/UI/WBP/Set/Widget/WBP_Set_KeyCombination.WBP_Set_KeyCombination'
        local Widget = UIManager(self):CreateWidget(FilePath, false)
        self.HB_Combination:AddChild(Widget)
        local TeamHeadSlot = UWidgetLayoutLibrary.SlotAsHorizontalBoxSlot(Widget)
        TeamHeadSlot:SetSize(Rule)
        local KeyInfoList = {}
        for j = 1, #ComboList[Index] do
            table.insert(KeyInfoList, {Type = "Img", ImgShortPath = ComboList[Index][1][j]})
        end
        local KeyData = {
            KeyInfoList = KeyInfoList,
            Desc = ComboList[Index][2],
            Type = "Add"
        }
        Widget.Key_Combination_1:CreateSubKeyDesc(KeyData)
        Widget.Key_Combination_1:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        if ComboList[Index + 1] then
            KeyInfoList = {}
            for j = 1, #ComboList[Index + 1] do
                table.insert(KeyInfoList, {Type = "Img", ImgShortPath = ComboList[Index + 1][1][j]})
            end
            KeyData = {
                KeyInfoList = KeyInfoList,
                Desc = ComboList[Index + 1][2],
                Type = "Add"
            }
            Widget.Key_Combination_2:CreateSubKeyDesc(KeyData)
            Widget.Key_Combination_2:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        else
            Widget.Key_Combination_2:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
    self:PlayAnimation(self.Combination_Change)
end

function WBP_Setting_PC_C:InitCommonTabInfo()
    self.CommonTabInfo = {}
    self.TabNums = 0
    for TabId,TabInfo in ipairs(DataMgr.OptionTab) do
        if self.Platform == "PC" or ((self.Platform == "Mobile") and (not TabInfo.IsMobileHide)) then
            local Tag = TabInfo.Tag
            local OptionTags = DataMgr.Option2Tag[Tag..self.Platform]
            if Tag == "Key" then
                if not self.IsInLoginMainPage then --登录界面屏蔽改键
                    self.TabNums = self.TabNums + 1
                    self.CommonTabInfo[self.TabNums] = {
                        Text = GText(TabInfo.TabName),
                        TabId = self.TabNums,
                        TabName = TabInfo.Tag,
                        IconPath = TabInfo.Icon,
                        Regions = 2,
                        RegionNames = {
                            [1] = GText('UI_Option_Area_6'),
                            [2] = GText('UI_Option_Area_7'),
                        }
                    }
                end
            elseif OptionTags and self:CheckSpecialHide(OptionTags) then
                self.TabNums = self.TabNums + 1
                local RegionNums = 0
                local RegionNames = {}
                local OptionInfo
                for index,Cache in pairs(OptionTags) do
                    OptionInfo = DataMgr.Option[Cache]
                    local Region = OptionInfo.Region
                    if RegionNames[Region] == nil and self:CheckOptionSpecialHide(Cache, OptionInfo.SpecialHide) then
                        RegionNames[Region] = OptionInfo.RegionName or ""
                    end
                    if Region > RegionNums then
                        RegionNums = Region
                    end
                end
                self.CommonTabInfo[self.TabNums] = {
                    Text = GText(OptionInfo.TagName),
                    TabId = self.TabNums,
                    TabName = TabInfo.Tag,
                    IconPath = TabInfo.Icon,
                    Regions = RegionNums,
                    RegionNames = RegionNames
                }

                if Tag == "Other" then
                    self.CommonTabInfo[self.TabNums].BindReddotNode = "Setting_Tab_Other"
                end
                if Tag == "Control" then
                    self.CommonTabInfo[self.TabNums].BindReddotNode = "Setting_Control"
                end
            end
        end
    end
end

--true代表需要显示 false代表隐藏
function WBP_Setting_PC_C:CheckSpecialHide(OptionTags)
    for index,Cache in pairs(OptionTags) do
        local OptionInfo = DataMgr.Option[Cache]
        if self:CheckOptionSpecialHide(Cache, OptionInfo.SpecialHide) then
            return true
        end
    end
    return false
end

--false代表隐藏 true代表显示
function WBP_Setting_PC_C:CheckOptionSpecialHide(OptionId, SpecialHide)
    local Avatar = GWorld:GetAvatar()
	if Avatar and Avatar.CdnHideData then
        local OptionData = Avatar.CdnHideData.option
        if OptionData  then
            for _, Data in pairs(OptionData) do
                if Data.gameCtrlOption and type(Data.gameCtrlOption) == "table" then
                    for __,CtrlOptionId in pairs(Data.gameCtrlOption) do
                        if CtrlOptionId==OptionId then
                            SpecialHide=Data.config
                            return SpecialHide
                        end
                    end
                end
            end
        end
    end
    local OptionInfo = DataMgr.Option[OptionId]
    if OptionInfo.HideOnPhone and UIUtils.IsMobileInput() then
        return false
    end

    if OptionInfo.HideOnPC and UIUtils.IsPCInput() then
        return false
    end
    
    if UE4.UUCloudGameInstanceSubsystem.IsCloudGame() and self:CheckIsUCloudHide(OptionId) then --云游戏
        return false
    end
    if self:CheckIsExamineDistribution(OptionId) then --提审服和正式服区分
        return false
    end
    if self:CheckIsInLogin(OptionId) then --登录界面和游戏内区分
        return false
    end
    if SpecialHide and SpecialHide == CommonConst.SpecialHideAnyWhere then
        return false
    end
    if URuntimeCommonFunctionLibrary.IsDLSSSupported() then --DLSS和FSR只有一个显示，根据是否支持dlss,30以上N卡支持dlss
        if OptionId == "FSR" then
            return false
        end
    else
        if OptionId == "DLSS" then
            return false
        end
        if OptionId == "DLSSOption" then
            return false
        end
    end
    if OptionId == "RayTracing" and not SettingUtils.IsOpenRayTracing() then
        return false
    end
    local IsGlobalPak = HeroUSDKSubsystem(self):IsGlobalSDK()
    if SpecialHide == nil or SpecialHide == CommonConst.SpecialHideNoWhere then
        return true
    else
        if IsGlobalPak and  SpecialHide == CommonConst.SpecialHideCN then
            return true
        elseif (not IsGlobalPak) and SpecialHide == CommonConst.SpecialHideAboard then
            return true
        end
    end
    return false
end

function WBP_Setting_PC_C:CheckIsUCloudHide(OptionId)
    local OptionInfo = DataMgr.Option[OptionId]
    if OptionInfo.UCloudHide then
        return true
    end
    return false
end

function WBP_Setting_PC_C:CheckIsExamineDistribution(OptionId)
    local OptionList = { --提审服需要屏蔽 true是，false否
        CustomerService = true,
        ExchangeCode = true,
        LogOffAccount = false,
    }
    if OptionList[OptionId] and AHotUpdateGameMode.IsExamineDistribution() then
        return true
    elseif OptionId == "CustomerService" then
        if HeroUSDKSubsystem(self):IsBilibili() then
            return true
        end
    --elseif OptionId == "LogOffAccount" then
    --    if HeroUSDKSubsystem(self):IsBilibili() then
    --        return true
    --    end
    else
        return false
    end
    return false
end

function WBP_Setting_PC_C:CheckIsInLogin(OptionId)
    local OptionInfo = DataMgr.Option[OptionId]
    if OptionInfo.GameHide == nil or OptionInfo.GameHide == CommonConst.SpecialHideNoWhere then
        return false
    end
    if self.IsInLoginMainPage and OptionInfo.GameHide == CommonConst.SpecialHideCN then
        return true
    end
    if not self.IsInLoginMainPage and OptionInfo.GameHide == CommonConst.SpecialHideAboard then
        return true
    end
    return false
end

function WBP_Setting_PC_C:ReceiveEnterState(EnteredState)
	self.Super.ReceiveEnterState(self, EnteredState)
	if EnteredState == UE4.EStackAction.Push then
		self:SetFocus()
	end
end

function WBP_Setting_PC_C:ScrollToOffset(Offset)
    self.ScrollBox_Option:SetScrollOffset(Offset)
end

function WBP_Setting_PC_C:GetScrollOffset()
    return self.ScrollBox_Option:GetScrollOffset()
end

function WBP_Setting_PC_C:OnTabSelected(TabWidget,NeedInit)
    self.WBP_Set_UnfoldList:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.NewTabId = TabWidget.Idx
    if self.HasBeenChanged then
        if self.HasBeenChanged == "GamepadPresetSave" then
            local Params = {}
            local PopConfig = DataMgr.CommonPopupUIContext[100190]
            local ContentStr = PopConfig.PopoverText
            Params.LeftCallbackObj = self
            Params.LeftCallbackFunction = function()
                self.OptionUnfold_Prefrence:RestoreOldGamepadPresetInLocal()
                self:OnCancelClickOtherSet()
            end
            Params.RightCallbackObj = self
            Params.RightCallbackFunction = self.OnConfirmClickOtherSet
            Params.ShortText = string.format(GText(ContentStr), self.OptionUnfold_Prefrence:GetGamepadPresetOptionContentText())
            UIManager(self):ShowCommonPopupUI(100190, Params, self)
        else
            local Params = {}
            Params.LeftCallbackObj = self
            Params.LeftCallbackFunction = self.OnCancelClickOtherSet
            Params.RightCallbackObj = self
            Params.RightCallbackFunction = self.OnConfirmClickOtherSet
            UIManager(self):ShowCommonPopupUI(100010,Params, self)
        end
        return
    end
    if self.CurrentTab ~= nil then
        for i,SettingUI in pairs(self.SettingUIs[self.CurrentTab]) do
            if(SettingUI.OnParentTabSwitch) then
                SettingUI:OnParentTabSwitch()
            end
        end
    end
    self.CurrentTab = TabWidget.Idx
    self.CurrentWidget = TabWidget
    --self.ScrollBox_Option:ClearChildren()
    --self.SettingUIs = {}
    if self.EmptySettingUI then
        self.ScrollBox_Option:RemoveChild(self.EmptySettingUI)
        self.EmptySettingUI = nil
    end
    self.ScrollBox_Option:ScrollToStart()
    local IsInit = false --是否初始化
    if self.SettingUIs[self.CurrentTab] == nil then
        self.SettingUIs[self.CurrentTab] = {}
        for i = 1,self.CommonTabInfo[self.CurrentTab].Regions do
            if self.CommonTabInfo[self.CurrentTab].RegionNames[i] then
                local SettingUI = self:CreateWidgetNew('SettingList')
                self.ScrollBox_Option:AddChild(SettingUI)
                local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsScrollBoxSlot(SettingUI)
                CanvasSlot:SetPadding(FMargin(0,0,0,0))
                self.SettingUIs[self.CurrentTab][i] = SettingUI
            end
        end
        IsInit = true
    end
    if NeedInit ~= nil then
        IsInit = NeedInit
    end
    for i, j in pairs(self.SettingUIs) do
        for m, n in pairs(j) do
            n:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
    for i,SettingUI in pairs(self.SettingUIs[self.CurrentTab]) do
        if(SettingUI.OnParentTabSwitch) then
            SettingUI:OnParentTabSwitch()
        end
        SettingUI:Init(self,self.CommonTabInfo[self.CurrentTab].TabName,i,self.CommonTabInfo[self.CurrentTab].RegionNames[i],IsInit)
        self.ScrollBox_Option:SetConsumeMouseWheel(EConsumeMouseWheel.WhenScrollingPossible)
        SettingUI:PlayInAnim()
        if(SettingUI.bIsFocusable)then
            SettingUI:SetFocus()
        end
    end
    if self.EmptySettingUI == nil then
        local SettingUI = self:CreateWidgetNew('SettingList')
        self.ScrollBox_Option:AddChild(SettingUI)
        local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsScrollBoxSlot(SettingUI)
        CanvasSlot:SetPadding(FMargin(0,0,0,0))
        self.EmptySettingUI = SettingUI
        self.EmptySettingUI:PlayInAnim()
    end
    self:UpdateEmptyGridCount()
    if self.CommonTabInfo[self.CurrentTab].TabName == "Key" then
        if self.Tab_MultiPlate then
            self.WidgetSwitcher_MP:SetActiveWidgetIndex(self.MultiPlateIndex - 1)
            self.Tab_MultiPlate:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Panel_SubTab:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    else
        if self.Tab_MultiPlate then
            self.WidgetSwitcher_MP:SetActiveWidgetIndex(0)
            self.Tab_MultiPlate:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Panel_SubTab:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
    if self.Tab_State and self.IsInitLayoutPlan then
        if self.CommonTabInfo[self.CurrentTab].TabName ~= "Control" then
            self.Tab_State:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Panel_Tab:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Tab_State:SelectTab(2)
        else
            self.Tab_State:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Panel_Tab:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Tab_State:SelectTab(1)
        end
    end
    
    -- 更新手柄聚焦
    self:AddTimer(0.1, function()
        self:FocusToOptionFirstWidget()
    end)
end

--更新列表空态
function WBP_Setting_PC_C:UpdateEmptyGridCount()
    if not IsValid(self.EmptySettingUI)  then
        return
    end
    local ListItemSize
    if self:IsExistTimer("GetEmptyGridCount") then
        self:RemoveTimer("GetEmptyGridCount")
    end
    local GetEmptyGridCount = function()
        local GridCountSum = 0
        local ListView
        for i,SettingUI in pairs(self.SettingUIs[self.CurrentTab]) do
            GridCountSum = GridCountSum + SettingUI:GetCurrentStateGrideCount()
            if not ListView then
                ListView = SettingUI.List_Options
            end
        end
        local ItemUIs = ListView:GetDisplayedEntryWidgets()
        if ItemUIs:Length() == 0 then
            self.EmptySettingUI:SetVisibility(ESlateVisibility.Collapsed)
            return
        end
        local ItemSize = UIManager(self):GetWidgetRenderSize(ItemUIs:GetRef(1).WidgetTree.RootWidget)
        ListItemSize = ItemSize.Y + ListView.EntrySpacing
        local ListViewSize = UIManager(self):GetWidgetRenderSize(self.ScrollBox_Option)
        local RowInt,RowLeft = math.modf(ListViewSize.Y / ListItemSize)
        if RowLeft >= 0.5 then
            RowInt = RowInt + 1
        end
        if GridCountSum > RowInt then
            self.ScrollBox_Option:SetScrollBarVisibility(ESlateVisibility.Visible)
            self.EmptySettingUI:SetVisibility(ESlateVisibility.Collapsed)
        elseif GridCountSum == RowInt then
            self.ScrollBox_Option:SetScrollBarVisibility(ESlateVisibility.Collapsed)
            self.EmptySettingUI:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.ScrollBox_Option:SetScrollBarVisibility(ESlateVisibility.Collapsed)
            self.EmptySettingUI:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.EmptySettingUI:SetEmptyGrid(self,RowInt - GridCountSum)
        end
    end
    self:AddTimer(0.033, GetEmptyGridCount, false, 0, "GetEmptyGridCount",true)
    
end

function WBP_Setting_PC_C:OnPreviewMouseButtonDown(MyGeometry, InMouseEvent)
    if UE4.UKismetInputLibrary.PointerEvent_IsMouseButtonDown(InMouseEvent, UE4.EKeys.LeftMouseButton) then
        local ScreenSpacePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InMouseEvent)
        -- local LocalPosition = UE4.USlateBlueprintLibrary.AbsoluteToLocal(MyGeometry, ScreenSpacePosition)
        local ItemGeometry = self.WBP_Set_UnfoldList:GetCachedGeometry()
        --点击在下拉列表里时不处理
        if self.WBP_Set_UnfoldList:IsVisible() and UE4.USlateBlueprintLibrary.IsUnderLocation(ItemGeometry,ScreenSpacePosition) then
            return UE4.UWidgetBlueprintLibrary.Unhandled()
        end
        self:OnClickAllLeftMouseButton()
        if self.OptionUnfold_Prefrence then
            self.OptionUnfold_Prefrence:OnClickLeftMouseButton()
        end
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function WBP_Setting_PC_C:OnKeyDown(MyGeometry, InKeyEvent)
    -- 判断是否有二级界面存在
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetStringLibrary.StartsWith(InKeyName, "GamePad")) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    elseif (InKeyName == "Escape") then
        UIUtils.PlayCommonBtnSe(self)
        self:OnPressESC()
    elseif (InKeyName == "Y") then
        self:OnPressY()
    elseif (InKeyName == "R") then
        self:OnPressR()
    elseif InKeyName == "Q" and self.CurrentTab ~= 1 then
        local UICommonTipSecond= UIManager(self):GetUI("CommonTipSecond")
        if UICommonTipSecond then
            UICommonTipSecond:Close()
        end
        self.NextTabIsLeft = true
        self.Tab_Set:TabToLeft()
    elseif InKeyName == "E" and self.CurrentTab ~= self.TabNums then
        local UICommonTipSecond= UIManager(self):GetUI("CommonTipSecond")
        if UICommonTipSecond then
            UICommonTipSecond:Close()
        end
        self.NextTabIsLeft = false
        self.Tab_Set:TabToRight()
    elseif InKeyName == "A" and self.CurrentTab == 1 then
        if self.MultiPlateIndex ~= 1 and self.Tab_MultiPlate and self.Tab_MultiPlate:GetVisibility() ~= UE4.ESlateVisibility.Collapsed then
            self.Tab_MultiPlate:Handle_KeyEventOnPC(InKeyName)
            self.MultiPlateIndex = 1
        end
    elseif InKeyName == "D" and self.CurrentTab == 1 and self.Tab_MultiPlate:GetVisibility() ~= UE4.ESlateVisibility.Collapsed then
        if self.MultiPlateIndex ~= 2 and self.Tab_MultiPlate and self.Tab_MultiPlate:GetVisibility() ~= UE4.ESlateVisibility.Collapsed then
            self.Tab_MultiPlate:Handle_KeyEventOnPC(InKeyName)
            self.MultiPlateIndex = 2
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function WBP_Setting_PC_C:RefreshGamepadOperationSystemBottomContent(InKeyName)
    if InKeyName == UIConst.GamePadKey.DPadLeft and self.CurrentTab == 1 and self.MultiPlateIndex == 2 then
        self:ShowFightGamepadBottomContent()
    elseif InKeyName == UIConst.GamePadKey.DPadRight and self.CurrentTab == 1 and self.MultiPlateIndex == 2 then
        self:ShowSystemGamepadBottomContent()
    end
end

function WBP_Setting_PC_C:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == Const.GamepadFaceButtonRight and self.IsUnfoldListOpen and self.OnUnfoldListClosed then
        self.OnUnfoldListClosed()
        self.OnUnfoldListClosed = nil
        return true
    elseif InKeyName == Const.GamepadFaceButtonUp then  -- 应用
        self:OnPressY()
        IsEventHandled = true
    elseif InKeyName == Const.GamepadFaceButtonLeft then  -- 恢复默认
        self:OnPressR()
        IsEventHandled = true
    end

    if not IsEventHandled then
        IsEventHandled = self.Tab_Set:Handle_KeyEventOnGamePad(InKeyName)
    end
    if InKeyName == Const.GamepadLeftTrigger and self.CurrentTab == 1 then
        if self.MultiPlateIndex ~= 1 and self.Tab_MultiPlate and self.Tab_MultiPlate:GetVisibility() ~= UE4.ESlateVisibility.Collapsed then
            self.Tab_MultiPlate:Handle_KeyEventOnGamePad(InKeyName)
            self.MultiPlateIndex = 1
        end
    elseif InKeyName == Const.GamepadRightTrigger and self.CurrentTab == 1 then
        if self.MultiPlateIndex ~= 2 and self.Tab_MultiPlate and self.Tab_MultiPlate:GetVisibility() ~= UE4.ESlateVisibility.Collapsed then
            self.Tab_MultiPlate:Handle_KeyEventOnGamePad(InKeyName)
            self.MultiPlateIndex = 2
        end
    elseif InKeyName == UIConst.GamePadKey.DPadLeft and self.CurrentTab == 1 and self.MultiPlateIndex == 2 then
        self:ShowFightGamepadBottomContent()
    elseif InKeyName == UIConst.GamePadKey.DPadRight and self.CurrentTab == 1 and self.MultiPlateIndex == 2 then
        self:ShowSystemGamepadBottomContent()
    end
    return IsEventHandled
end

function WBP_Setting_PC_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == UIConst.GamePadKey.DPadLeft and self.CurrentTab == 1 and self.MultiPlateIndex == 2 then
        self:ShowFightGamepadBottomContent()
    elseif InKeyName == UIConst.GamePadKey.DPadRight and self.CurrentTab == 1 and self.MultiPlateIndex == 2 then
        self:ShowSystemGamepadBottomContent()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function WBP_Setting_PC_C:AddHoverContent(Content)
    self.HoverContentList[Content] = true
    for key, value in pairs(self.HoverContentList) do
        if key ~= Content and value and key.OnBtnAreaUnHover then
            key:OnBtnAreaUnHover()
            self.HoverContentList[key] = nil
        end
    end
end

function WBP_Setting_PC_C:RemoveHoverContent(Content)
    if self.HoverContentList[Content] then
        self.HoverContentList[Content] = nil
    end
end

function WBP_Setting_PC_C:OnPressESC()
    if self.HasBeenChanged then
        if self.HasBeenChanged == "GamepadPresetSave" then
            local Params = {}
            local PopConfig = DataMgr.CommonPopupUIContext[100190]
            local ContentStr = PopConfig.PopoverText
            Params.LeftCallbackObj = self
            Params.LeftCallbackFunction = function()
                self.OptionUnfold_Prefrence:RestoreOldGamepadPresetInLocal()
                self:OnESCClickCancel()
            end
            Params.RightCallbackObj = self
            Params.RightCallbackFunction = function()
                self:SaveAllSetting(true)
                self:CloseSelf()
            end
            Params.ShortText = string.format(GText(ContentStr), self.OptionUnfold_Prefrence:GetGamepadPresetOptionContentText())
            UIManager(self):ShowCommonPopupUI(100190, Params, self)
        else
            local Params = {}
            Params.LeftCallbackObj = self
            Params.LeftCallbackFunction = self.OnESCClickCancel
            Params.RightCallbackObj = self
            Params.RightCallbackFunction = self.OnConfirmPressESC
            UIManager(self):ShowCommonPopupUI(100010, Params,self)
        end
    else
        self:SetInputUIOnly(false)
        local UICommonTipSecond= UIManager(self):GetUI("CommonTipSecond")
        if UICommonTipSecond then
            UICommonTipSecond:Close()
        end
        self:CloseSelf()
    end
end

function WBP_Setting_PC_C:OnPressY()
    if self.HasBeenChanged then
        UIUtils.PlayCommonBtnSe(self)
        self:SaveAllSetting()
    else
        return
    end
end

function WBP_Setting_PC_C:OnPressR()
    UIUtils.PlayCommonBtnSe(self)
    local Params = {}
    Params.RightCallbackObj = self
    Params.RightCallbackFunction = self.OnConfirmPressR
    UIManager(self):ShowCommonPopupUI(100011,Params, self)
end

function WBP_Setting_PC_C:CommonTabToLast()
    self.Tab_Set:SelectTab(self.CurrentTab)
end

function WBP_Setting_PC_C:CommonTabToNext()
    self.Tab_Set:SelectTab(self.NewTabId)
end

function WBP_Setting_PC_C:OnConfirmPressESC()
    self:SaveAllSetting(true)
    self.AutoClose = true
    -- self:CloseSelf()
end

function WBP_Setting_PC_C:OnESCClickCancel()
    self:RestoreOldValueSet()
    self:CloseSelf()
end

function WBP_Setting_PC_C:OnConfirmPressR()
    self:RestoreAllDefaultSet()
end

function WBP_Setting_PC_C:OnConfirmClickOtherSet()
    self:SaveAllSetting()
    self:CommonTabToNext()
end

function WBP_Setting_PC_C:OnCancelClickOtherSet()
    self:RestoreOldValueSet()
    self:InitSettingParameter()
    self:UpdateKeyboardBottonKey()
    self:CommonTabToNext()
end

function WBP_Setting_PC_C:OnClickBlankArea()
    self:CommonTabToLast()
end

function WBP_Setting_PC_C:ClearSettingListUnfoldState()
    for key, value in pairs(self.SettingUIs[self.CurrentTab]) do
        value:ClearSettingOptionUnfoldState()
    end
end

function WBP_Setting_PC_C:SaveAllSetting()
    self.HasBeenChanged = false
    self:UpdateKeyboardBottonKey()
    if self.CurrentTab == 1 and self.MultiPlateIndex == 2 then
        self.OptionUnfold_Prefrence:SaveGamepadPresetOptionSettingInLocal()
    else
        for key, value in pairs(self.SettingUIs[self.CurrentTab]) do
            if value and value.SaveSetting then
                value:SaveSetting()
            end
        end
    end
end

function WBP_Setting_PC_C:RestoreAllDefaultSet()
    self.HasBeenChanged = false
    self:UpdateKeyboardBottonKey()
    if self.CurrentTab == 1 and self.MultiPlateIndex == 2 then
        self.OptionUnfold_Prefrence:RestoreDefaultGamepadPresetInLocal()
    elseif self.CommonTabInfo[self.CurrentTab].TabName == "Control" and self.LayoutPlantIndex == 1 then
        for i = 0,self.List_CustomOption:GetNumItems() - 1 do
            local Item = self.List_CustomOption:GetItemAt(i)
            if Item and Item.SelfWidget and Item.SelfWidget.RestoreDefaultOptionSet then
                Item.SelfWidget:RestoreDefaultOptionSet()
            end
        end
    else
        for key, value in pairs(self.SettingUIs[self.CurrentTab]) do
            if value and value.RestoreDefaultSet then
                value:RestoreDefaultSet()
            end
        end 
    end
end

function WBP_Setting_PC_C:RestoreOldValueSet()
    for key, value in pairs(self.SettingUIs[self.CurrentTab]) do
        if value and value.RestoreOldValueSet then
            value:RestoreOldValueSet()
        end
    end
end

function WBP_Setting_PC_C:OnClickAllLeftMouseButton()
    for key, value in pairs(self.SettingUIs[self.CurrentTab]) do
        if value and value.OnClickLeftMouseButton then
            value:OnClickLeftMouseButton()
        end
    end
end

function WBP_Setting_PC_C:UpdateUnfoldListPosition(Position,IsUpper)
    local CanvasSlotTarget = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.WBP_Set_UnfoldList)
    if IsUpper then
        CanvasSlotTarget:SetAlignment(FVector2D(0.5,1.0))
    else
        CanvasSlotTarget:SetAlignment(FVector2D(0.5,0))
    end
    CanvasSlotTarget:SetPosition(Position)
end

function WBP_Setting_PC_C:BindUnfoldListClosedCallback(Callback)
    self.OnUnfoldListClosed = Callback
end

function WBP_Setting_PC_C:ChangeUnfoldListSelection(SelectOptionId)
    local ListItems = self.WBP_Set_UnfoldList.SubOption_List:GetListItems()
    for _, ListItem in pairs(ListItems) do
        ListItem.SelectedOptionId = SelectOptionId
    end

    local GetDisplayedEntryWidgets = self.WBP_Set_UnfoldList.SubOption_List:GetDisplayedEntryWidgets()
    for _, Entry in pairs(GetDisplayedEntryWidgets) do
        Entry:UpdateEntrySelection()
    end
end

function WBP_Setting_PC_C:FocusToSelectedUnfoldListOption()
    local ListItems = self.WBP_Set_UnfoldList.SubOption_List:GetListItems()
    local ListNums = self.WBP_Set_UnfoldList.SubOption_List:GetNumItems()
    for i = 0, ListNums - 1 do
        local Item = ListItems:GetRef(i + 1)
        if Item and Item.SelectedOptionId == Item.Id then
            self.WBP_Set_UnfoldList.SubOption_List:NavigateToIndex(i)
            break
        end
    end

    self:UpdateBottomKey({
        {UIConst.GamePadImgKey.FaceButtonBottom, GText("UI_Tips_Ensure")},
        {UIConst.GamePadImgKey.FaceButtonRight, GText("UI_Tips_Close")}
    })
end

function WBP_Setting_PC_C:SetSettingUnfoldListPC(IsShow)
    if IsShow then
        self.WBP_Set_UnfoldList:StopAllAnimations()
        self.WBP_Set_UnfoldList:PlayAnimation(self.WBP_Set_UnfoldList.In)
        if(self:IsExistTimer("SetList")) then
            self:RemoveTimer("SetList")
        end
        self.IsUnfoldListOpen = true
        self.WBP_Set_UnfoldList:SetVisibility(UE4.ESlateVisibility.Visible)
        self.ScrollBox_Option:SetConsumeMouseWheel(EConsumeMouseWheel.Never)

        if UIUtils.IsGamepadInput() then
            self:AddTimer(0.1, function()
                self:FocusToSelectedUnfoldListOption()
            end)
        end

    else
        if self.IsUnfoldListOpen then
            self.IsUnfoldListOpen = false
            self.WBP_Set_UnfoldList:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.WBP_Set_UnfoldList:StopAllAnimations()
            self.WBP_Set_UnfoldList:PlayAnimation(self.WBP_Set_UnfoldList.Out)
            self.ScrollBox_Option:SetConsumeMouseWheel(EConsumeMouseWheel.WhenScrollingPossible)
            local SetList = function()
                self.WBP_Set_UnfoldList:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
            local EndTime = self.WBP_Set_UnfoldList.Out:GetEndTime()
            self:AddTimer(EndTime, SetList,false,0,"SetList",true)
        end
        self.WBP_Set_UnfoldList:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_Setting_PC_C:PlayInAnim()
    if self.IsInLoginMainPage then
        self:PlayAnimation(self.logIn)
    else
        self:PlayAnimation(self.In)
    end
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "OpenShopSetting", nil)
end

function WBP_Setting_PC_C:CloseSelf()
    if self.OptionUnfold_Prefrence and self.OptionUnfold_Prefrence.IsListOpen then
        self.OptionUnfold_Prefrence:OnClickSubOptionList()
    end
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    self:StopAnimation(self.In)
    self:PlayAnimation(self.Out)
    AudioManager(self):SetEventSoundParam(self, "OpenShopSetting", {ToEnd = 1})
    self:BindToAnimationFinished(self.Out,{self,self.Close})
end

function WBP_Setting_PC_C:Close()
    self:UnbindAllFromAnimationFinished(self.Out)
    for i, j in pairs(self.SettingUIs) do
        for m, n in pairs(j) do
            if n and n.OnParentClosed then
                n:OnParentClosed()
            end
        end
    end
    local ESCUI = UIManager(self):GetUI(UIConst.MenuWorld) or UIManager(self):GetUI(UIConst.MenuLevel)
    if ESCUI and not self.CloseEsc then
        ESCUI:PlayInAnim()
    end
    if ESCUI and self.CloseEsc then
         ESCUI.CloseByChild=true
    end
    if not self.IsInLoginMainPage then
        UIManager(self):SwitchUINpcCamera(false,"Setting", self.NpcId, 
                                            {bDestroyNpc=true, IsHaveInOutAnim=self.IsNeedPlayNpcAnim})
    end
    if self.LastSystem and self.LastSystem.SetFocus then
        self.LastSystem:SetFocus()
    end
    if self.RegionOnline ~= EMCache:Get("AutoJoin") then
        EventManager:FireEvent(EventID.ChangeRegionOnline, EMCache:Get("AutoJoin"))
    end

    local GachaKey = "SecPasswordNew"
    local SecPasswordNewCache = EMCache:Set(GachaKey, true, true)
    ReddotManager.ClearLeafNodeCount("Setting_SecPassword")

    self.Super.Close(self)
end

function WBP_Setting_PC_C:CloseSelfAndEsc()
    self.CloseEsc=true
    self:Close()
end


return WBP_Setting_PC_C
--
-- DESCRIPTION
-- 设置界面专用拖拽
-- @AUTHOR HY

require "Unlua"

local BattleHUDCommonConst = require "BluePrints.UI.UI_Phone.Battle.BattleHUDCommonConst"
-- local EMCache = require "EMCache.EMCache"

-- 试用布局方案索引（用于保存试用跳转的临时数据）
local TRIAL_LAYOUT_PLAN_INDEX = 7

local M = Class("BluePrints.UI.BP_UIState_C")

M._components = {
    "BluePrints.UI.UI_Phone.Battle.Component.HUDWidgetDesignComponent",
}

--进行初始化
function M:Initialize(Initializer)
    self.Super.Initialize(self)
    self.CurrentSelectWidget = nil                                              -- 当前选中的可拖拽组件
    self.bHaveModifiedLayoutData = false                                        -- 当前是否修改过布局数据
    self.AllWidgetOperationHistory = {}                                         -- 所有可拖拽组件的操作历史
    self.bIsFoldedFloat = false                                                 -- 当前是否折叠
    self.bIsDefaultLayoutData = true                                            -- 当前是否为默认布局
    self.DraggableWidget2ParentNodeMap = {}                                     -- 可拖拽组件到父节点的映射
end

-- 界面构造
function M:Construct()
    self:InitConfigData()
    self:InitListenEvent()
    self:BindBtnClick()
    -- 隐藏设置的Npc
    UIManager(self):HideNpcById(BattleHUDCommonConst.SettingPageNpcId, true, "SettingCustomPage")
end

-- 界面销毁
function M:Destruct()
    self:UnRegisterHUDDesignComponent()
    -- 显示设置的Npc
    UIManager(self):HideNpcById(BattleHUDCommonConst.SettingPageNpcId, false, "SettingCustomPage")
end

-- 界面初始化
function M:OnLoaded(...)
    local bHaveModifiedLayoutData = nil
    self.CurEditPlan, self.WidgetPlanData, bHaveModifiedLayoutData = ...
    if (bHaveModifiedLayoutData) then
        self.bHaveModifiedLayoutData = true
    end
    self:EnterDesignState(self.CurEditPlan, self.Panel_LayoutNode, self.WidgetPlanData)
    for WidgetObj, ParentNode in pairs(self.DraggableWidget2ParentNodeMap) do
        if (WidgetObj and type(WidgetObj.EnterDesignState) == "function") then
            WidgetObj:EnterDesignState(self.CurEditPlan)
        end
        if (WidgetObj and type(WidgetObj.HideRelativeNodeWhenUnSelected) == "function") then
            WidgetObj:HideRelativeNodeWhenUnSelected(true)
        end
    end
    -- 增加方案右侧面板的返回按钮事件绑定
    self.SchemeRight:InitClickInfo(self, self.ManualAddWidgetsList, self.OnClickToAddManualWidget)

    -- 初始化重置按钮状态
    self.Btn_Anew:ForbidBtn(self.bIsDefaultLayoutData)
    -- 跳跃按钮根据当前布局进行调整
    self.Jump:ChangeByLayout(self.CurEditPlan)
    self:PlayInAnim()
    self:SetEditPlanName()
    EventManager:FireEvent(EventID.OnExitMobileHudTrial)
    self.IsPlayingOutAnim = false
    self:UpdateRedDot()
    DebugPrint("HUDWidgetDesignComponent OnLoaded, CurEditPlan is :", self.CurEditPlan, self.bIsDefaultLayoutData)
end

function M:UpdateRedDot()
    local RedDot = ReddotManager.GetTreeNode("Setting_Control_TrailBtn")
    if RedDot and RedDot.Count > 0 then
        self.Btn_Trial:SetReddot(true)
    else
        self.Btn_Trial:SetReddot(false)
    end
    RedDot = ReddotManager.GetTreeNode("Setting_Control_AddBtn")
    if RedDot and RedDot.Count > 0 then
        self.new:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.new:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

-- 播放进入动画
function M:PlayInAnim()
    -- self:BindToAnimationFinished(self.In, {self, PlayAnimFinished})
    self:PlayAnimationForward(self.In)
end

-- 播放退出动画
function M:PlayOutAnim()
    self.IsPlayingOutAnim = true
    self:BindToAnimationFinished(self.Out, {self, function() self:Close() end})
    self:PlayAnimationForward(self.Out)
end

-- 播放退出动画并关闭设置界面和菜单界面（用于试用按钮）
function M:PlayOutAnimAndCloseSettingAndMenuWorld()
    self:BindToAnimationFinished(self.Out, {self, function() 
        local SettingUI = UIManager(self):GetUIObj("Setting")
        if SettingUI then
            SettingUI.CloseEsc = true
            SettingUI:Close()
        end
        -- 然后关闭当前界面
        self:Close()
    end})
    self:PlayAnimationForward(self.Out)
end

-- 通知选中了某个可拖拽组件
---@param CurSelectWidget table 当前选中的可拖拽组件
function M:OnDraggableWidgetSelected(CurSelectWidget)
    if (not IsValid(CurSelectWidget)) then
        DebugPrint("Error: OnDraggableWidgetSelected function received an invalid widget!")
        return
    end
    if (self.Switch_TipsType:GetActiveWidgetIndex() ~= 0) then
        self.Switch_TipsType:SetActiveWidgetIndex(0)
    end

    if (self.CurrentSelectWidget == CurSelectWidget) then
        DebugPrint("HUDWidgetDesignComponent OnDraggableWidgetSelected function received the same widget, no need to re-select!")
        return
    end
    if (self.CurrentSelectWidget ~= nil) then
        self.CurrentSelectWidget:UnSelectWidget()
    else
        self.Size_Slider:SetIsEnabled(true)
        self.Stretch_Slider:SetIsEnabled(true)
    end
    self.CurrentSelectWidget = CurSelectWidget
    -- self.CurrentSelectWidget:SelectWidget()
    -- 更新滑动条数值
    local ParentNode = self.DraggableWidget2ParentNodeMap[CurSelectWidget]
    if (ParentNode) then
        self:CheckAndRefreshRelativeSlideBar()
        self:UpdateSliderValue("Size", ParentNode.RenderTransform.Scale.X)
    end
    -- 更新撤销按钮状态
    local HistoryOpList = self.AllWidgetOperationHistory[CurSelectWidget]
    if (IsEmptyTable(HistoryOpList)) then
        self.Btn_Retract:ForbidBtn(true)
    else
        self.Btn_Retract:ForbidBtn(false)
    end
    -- 更新编辑控件文本
    self.TextContent:SetText(GText(self.CurrentSelectWidget:GetSelectWidgetTextMapContent()))
end

-- 通知布局数据进行了修改
function M:OnDraggableWidgetInfoChanged(TypeStr, TargetWidget, NewValue)
    self.bHaveModifiedLayoutData = true
    -- 记录操作历史
    local HistoryOpList = self.AllWidgetOperationHistory[TargetWidget]
    if (HistoryOpList) then
        if (#HistoryOpList >= BattleHUDCommonConst.LayOutSettingConfig.MaxOperationHistoryCount) then
            table.remove(HistoryOpList, 1)
        end
        table.insert(self.AllWidgetOperationHistory[TargetWidget], {OpType=TypeStr, Value=NewValue})
    else
        self.AllWidgetOperationHistory[TargetWidget] = {{OpType=TypeStr, Value=NewValue}}
    end
    self.Btn_Retract:ForbidBtn(false)
    self.Btn_Anew:ForbidBtn(false)
    if (TypeStr == "Pos") then
        -- 位置修改
    elseif (TypeStr == "Scale") then
        -- 缩放修改
    end
end

-- 根据配置初始化界面信息
function M:InitConfigData()
    -- 界面布局信息
    local AllWidgetConfigData = {}
    for key, value in pairs(BattleHUDCommonConst.DesignBaseConfigInHUD) do
        local SubWidgetObj = self[value.WidgetName]
        local ModifyValue = {
            WidgetObj = SubWidgetObj,
            WidgetName = value.WidgetName,
            TextMapContent = value.TextMapContent,
            InnerActiveSlateName = value.InnerActiveSlateName,
            MaskNodeName = value.MaskNodeName,
            bHasExtraLimitArea = value.bHasExtraLimitArea,
            bNeedAddWorldPos = value.bNeedAddWorldPos,
            bIsNeedManualAdd = value.bIsNeedManualAdd,
            RelativeNodeName = value.RelativeNodeName,
            ParentNodeName = key,
        }

        if (SubWidgetObj and type(SubWidgetObj.InitAllDraggableWidgetInfo) == "function") then
            SubWidgetObj:InitAllDraggableWidgetInfo(self, ModifyValue)
        end
        AllWidgetConfigData[key] = ModifyValue
        if SubWidgetObj then
            self.DraggableWidget2ParentNodeMap[SubWidgetObj] = self[key]
        end
    end

    -- 设置所有文本内容
    self:InitAllTextContent()

    -- 初始化缩放值
    self.Size_Slider:SetIsEnabled(false)                                                     -- 初始不可用
    self:UpdateSliderValue("Size", BattleHUDCommonConst.LayOutSettingConfig.DefaultScaleValue)
    -- 初始化拉伸值
    self.Stretch_Slider:SetIsEnabled(false)                                                  -- 初始不可用
    self:UpdateSliderValue("Stretch", BattleHUDCommonConst.VisualJoystickConfig.DefaultAreaRangeYPercent)

    -- 注册HUD设计组件
    self:RegisterHUDDesignComponent(AllWidgetConfigData, false, false)
end

function M:InitAllTextContent()
    self.Chat.TextNpc:SetText(GText("UI_CustomLayout_CaseName01"))
    self.Chat.TextChat:SetText(GText("UI_CustomLayout_CaseName02"))
    self.Chat.TextTitle:SetText(GText("UI_CustomLayout_CaseName03"))
    self.Chat.TextForge01:SetText(GText("UI_CustomLayout_CaseName04"))
    self.Chat.TextForge02:SetText(GText("UI_CustomLayout_CaseName04"))
    self.Chat.TextForge03:SetText(GText("UI_CustomLayout_CaseName04"))

    self.Interaction.TextInteraction01:SetText(GText("UI_CustomLayout_WidgetName11"))
    self.Interaction.TextInteraction02:SetText(GText("UI_CustomLayout_WidgetName11"))
    self.Interaction.TextInteraction03:SetText(GText("UI_CustomLayout_WidgetName11"))

    self.Task:InitTaskText()
    self.Drop:InitDropText()
    self.Team:InitTeamText()

    self.TextAdd:SetText(GText("UI_CustomLayout_AddBtn"))
    self.Text_Scale:SetText(GText("UI_CustomLayout_Scale"))
    self.Text_Stretch:SetText(GText("UI_CustomLayout_ResponseRange"))
    self.Btn_Save:SetText(GText("UI_CustomLayout_Save"))
    self.Text_Choose:SetText(GText("UI_CustomLayout_DefaultTip"))
    self.Btn_Trial:SetText(GText("UI_CustomLayout_Trial"))
    self.TextNow:SetText(GText("UI_CustomLayout_Editing"))
    self.CancelLeft:InitNormalText()
    self.CancelRight:InitSlideText()
    self.Switch_TipsType:SetActiveWidgetIndex(1)
end

-- 初始化监听事件
function M:InitListenEvent()
	self:AddDispatcher(EventID.OnMobileHudPlanChanged, self, self.OnMobileHudPlanChanged)
    self:AddDispatcher(EventID.OnSwitchMobileHUDLayout, self, self.OnSwitchMobileHUDLayout)
    self:AddDispatcher(EventID.OnUpdateMobileHudPlanName, self, self.OnUpdateMobileHudPlanName)
end

-- 检查并刷新相关节点的滑动条数值
function M:CheckAndRefreshRelativeSlideBar()
    if (self.CurrentSelectWidget and self.CurrentSelectWidget.RelativeNodeWidgetName) then
        self:UpdateSliderValue("Stretch", self.CurrentSelectWidget:GetAreaRangeYPercent())
        self.Fillled_Stretch:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Fillled_Stretch:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

-- 刷新手动添加节点项的状态
function M:RefreshManualWidgetWhenDataChange()
    for ManualNodeName, WidgetConfigData in pairs(BattleHUDCommonConst.ManualAdditionConfigInHUD) do
        local WidgetServerData = self.ManualAddWidgetsList[ManualNodeName] or {}
        self.SchemeRight:RefreshStateWhenDataChange(WidgetConfigData, WidgetServerData)
    end
end

-- 更新缩放滑动条数值
---@param SlideType string 滑动条类型
---@param NewSliderValue number 新的数值
function M:UpdateSliderValue(SlideType, NewSliderValue)
    if (SlideType == "Size") then
        local SliderValue = (NewSliderValue - BattleHUDCommonConst.LayOutSettingConfig.MinScaleValue) 
                                / (BattleHUDCommonConst.LayOutSettingConfig.MaxScaleValue - BattleHUDCommonConst.LayOutSettingConfig.MinScaleValue)
        self.Size_Slider:SetValue(SliderValue)
        self.ProgressBarSize_Slider:SetPercent(self.Size_Slider:GetValue())
        self.TextScaleNum:SetText(string.format("%.1f", NewSliderValue))
    elseif (SlideType == "Stretch") then
        local SliderValue = (NewSliderValue - BattleHUDCommonConst.VisualJoystickConfig.AreaRangeYPercentMin) 
                                / (BattleHUDCommonConst.VisualJoystickConfig.AreaRangeYPercentMax - BattleHUDCommonConst.VisualJoystickConfig.AreaRangeYPercentMin)
        self.Stretch_Slider:SetValue(SliderValue)
        self.ProgressBarStretch_Slider:SetPercent(self.Stretch_Slider:GetValue())
        self.TextStretchNum:SetText(string.format("%.1f", NewSliderValue))
    end
end

-- 绑定按钮点击事件
function M:BindBtnClick()
    self.Btn_Collapsed.OnClicked:Add(self, self.OnClickedFloatCollapsed)
    self.Btn_Retract:BindEventOnClicked(self, self.OnClickedOperationBack)
    self.Btn_Anew:BindEventOnClicked(self, self.OnClickedAnewSet)
    self.Btn_Save:BindEventOnClicked(self, self.OnClickedSave)
    self.Btn_Trial:BindEventOnClicked(self, self.OnClickedTrial)
    self.Btn_Switch.OnClicked:Add(self, self.OnClickedSwitch)
    self.Btn_Exit.OnClicked:Add(self, self.OnClickedExit)
    self.Btn_Add.OnClicked:Add(self, self.OnClickedAdd)

    if (BattleHUDCommonConst.LayOutSettingConfig.bIsSupportLongPress) then
        self.Btn_Up:SetLongPressEnable(true)
        self.Btn_Down:SetLongPressEnable(true)
        self.Btn_Left:SetLongPressEnable(true)
        self.Btn_Right:SetLongPressEnable(true)

        self.Btn_Up:BindEventOnPressed(self, self.OnClickedMoveUp)
        self.Btn_Down:BindEventOnPressed(self, self.OnClickedMoveDown)
        self.Btn_Left:BindEventOnPressed(self, self.OnClickedMoveLeft)
        self.Btn_Right:BindEventOnPressed(self, self.OnClickedMoveRight)
    else
        self.Btn_Up:BindEventOnClicked(self, self.OnClickedMoveUp)
        self.Btn_Down:BindEventOnClicked(self, self.OnClickedMoveDown)
        self.Btn_Left:BindEventOnClicked(self, self.OnClickedMoveLeft)
        self.Btn_Right:BindEventOnClicked(self, self.OnClickedMoveRight)
    end

    self.Size_Slider.OnValueChanged:Add(self, self.OnSizeSliderValueChanged)
    self.Stretch_Slider.OnValueChanged:Add(self, self.OnStretchSliderValueChanged)
    -- 初始禁止撤销按钮
    self.Btn_Retract:ForbidBtn(true)
end

-- 缩放滑动条数值改变
---@param Value number 新的数值
function M:OnSizeSliderValueChanged(Value)
    if (self.CurrentSelectWidget == nil) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_DefaultTip"))
        return
    end

    local CurPercent = self.ProgressBarSize_Slider.Percent
    if (self:_Numbers_Equal(Value, CurPercent, 0.0001)) then
        DebugPrint("HUDWidgetDesignComponent OnSizeSliderValueChanged function received the same value, no need to update!")
        return
    end
    if (IsValid(self.CurrentSelectWidget)) then
        local NewScale = UE4.UKismetMathLibrary.Lerp(BattleHUDCommonConst.LayOutSettingConfig.MinScaleValue, 
                            BattleHUDCommonConst.LayOutSettingConfig.MaxScaleValue, Value)
        DebugPrint("HUDWidgetDesignComponent OnSizeSliderValueChanged set widget scale value, NewScale is :", NewScale)
        self.CurrentSelectWidget:ModifyWidgetScale(NewScale)
        self.ProgressBarSize_Slider:SetPercent(self.Size_Slider:GetValue())
        self.TextScaleNum:SetText(string.format("%.1f", NewScale))

        AudioManager(self):PlayUISound(self, "event:/ui/common/slider_value_change", nil, nil)
    end
end

-- 拉伸滑动条数值改变
---@param Value number 新的数值
function M:OnStretchSliderValueChanged(Value)
    if (self.CurrentSelectWidget == nil) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_DefaultTip"))
        return
    end

    local CurPercent = self.ProgressBarStretch_Slider.Percent
    if (self:_Numbers_Equal(Value, CurPercent, 0.0001)) then
        DebugPrint("HUDWidgetDesignComponent OnStretchSliderValueChanged function received the same value, no need to update!")
        return
    end
    if (IsValid(self.CurrentSelectWidget)) then
        local NewStretchPercent = UE4.UKismetMathLibrary.Lerp(BattleHUDCommonConst.VisualJoystickConfig.AreaRangeYPercentMin, 
                                BattleHUDCommonConst.VisualJoystickConfig.AreaRangeYPercentMax, Value)
        DebugPrint("HUDWidgetDesignComponent OnStretchSliderValueChanged set widget stretch value, NewStretchPercent is :", NewStretchPercent)
        self.CurrentSelectWidget:OnModifyPropertyWithSlideChange(NewStretchPercent)
        self.ProgressBarStretch_Slider:SetPercent(self.Stretch_Slider:GetValue())
        self.TextStretchNum:SetText(string.format("%.1f", NewStretchPercent))

        AudioManager(self):PlayUISound(self, "event:/ui/common/slider_value_change", nil, nil)
    end
end

-- 移动端布局方案发生变化
function M:OnMobileHudPlanChanged(OpType, PlanIndex, PlanInfo, IsChangeName)
    if (OpType == "Update") then
        self.bHaveModifiedLayoutData = false
        self.AllWidgetOperationHistory = {}
        if (PlanIndex ~= TRIAL_LAYOUT_PLAN_INDEX) then
            if IsChangeName then
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Change_Success"))
            else
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_SaveToast"))
            end
        end
    end
end

-- 移动端布局方案切换
function M:OnSwitchMobileHUDLayout(PlanIndex)
    self.bHaveModifiedLayoutData = false
    self.Switch_TipsType:SetActiveWidgetIndex(1)
    self.Btn_Anew:ForbidBtn(false)
    if (self.CurrentSelectWidget ~= nil) then
        self.CurrentSelectWidget:UnSelectWidget()
    end
    self.CurEditPlan = PlanIndex
    self:SetEditPlanName()
    self:EnterDesignState(self.CurEditPlan, self.Panel_LayoutNode)
    for WidgetObj, ParentNode in pairs(self.DraggableWidget2ParentNodeMap) do
        if (WidgetObj and type(WidgetObj.EnterDesignState) == "function") then
            WidgetObj:EnterDesignState(self.CurEditPlan)
        end
    end
    self:RefreshManualWidgetWhenDataChange()
end

-- 移动端布局方案名称更新
function M:OnUpdateMobileHudPlanName(PlanIndex, PlanName)
    if (PlanIndex == self.CurEditPlan) then
        self.Text_PlanName:SetText(PlanName)
    end
end

-- 手动添加组件的复选框被点击（显示或隐藏对应组件）
function M:OnClickToAddManualWidget(bChecked, WidgetName)
    DebugPrint("HUDWidgetDesignComponent OnClickToAddManualWidget function is called, WidgetName is :", WidgetName, "bChecked is :", bChecked)
    local WidgetConfig = BattleHUDCommonConst.ManualAdditionConfigInHUD[WidgetName]
    if (not WidgetConfig) then
        DebugPrint("Error: OnClickToAddManualWidget function received an invalid WidgetName:", WidgetName)
        return
    end
    local LayoutNodeName = WidgetConfig.LayoutInHUDPosName
    local LayoutNodeWidget = self[LayoutNodeName]
    if (LayoutNodeWidget) then
        if (bChecked) then
            LayoutNodeWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            LayoutNodeWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        DebugPrint("Error: OnClickToAddManualWidget function cannot find the corresponding LayoutNodeWidget for WidgetName:", WidgetName)
    end

    local TargetWidget = self[WidgetName]
    if (TargetWidget) then
        TargetWidget:SetManualAddInSetting(bChecked)
    end
    -- local EffectNodeWidget = self[WidgetConfig.EffectWidgetName]
    -- self.bHaveModifiedLayoutData = true
end

-- 点击浮动折叠按钮（播放动画）
function M:OnClickedFloatCollapsed()
    if (self.bIsFoldedFloat) then
        self:PlayAnimation(self.Expand)
        self.bIsFoldedFloat = false
        AudioManager(self):PlayUISound(self, "event:/ui/common/ui_scale_panel_expand", "CustomHUDSetting", nil)
    else
        self:PlayAnimation(self.Fold)
        self.bIsFoldedFloat = true
        AudioManager(self):PlayUISound(self, "event:/ui/common/ui_scale_panel_shrink", "CustomHUDSetting", nil)
    end
end

-- 点击保存按钮
function M:OnClickedSave()
    self:SaveAllWidgetLayoutData(self.CurEditPlan)
    -- 保存之后禁用一些按钮状态
    self.Btn_Retract:ForbidBtn(true)
    self.Btn_Anew:ForbidBtn(true)
end

-- 点击撤销按钮
function M:OnClickedOperationBack()
    local HistoryOpList = self.AllWidgetOperationHistory[self.CurrentSelectWidget]
    if (HistoryOpList) then
        table.remove(HistoryOpList, 1)
        if (IsEmptyTable(HistoryOpList)) then
            self.Btn_Retract:ForbidBtn(true)
            self.AllWidgetOperationHistory[self.CurrentSelectWidget] = nil
            self:ResetSingleItemToDefaultLayout(self.CurrentSelectWidget)
            self:UpdateSliderValue("Size", BattleHUDCommonConst.LayOutSettingConfig.DefaultScaleValue)
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_WithdrawToast"))
        else
            local LastOp = HistoryOpList[#HistoryOpList]
            self:SetSingleItemToLastRecordState(self.CurrentSelectWidget, LastOp.OpType, LastOp.Value)
        end
    end
end

-- 点击退出按钮
function M:OnClickedExit()
    if (self.IsPlayingOutAnim) then
        DebugPrint("HUDWidgetDesignComponent OnClickedExit function is playing Out animation, cannot exit now!")
        return
    end
    if (self.bHaveModifiedLayoutData) then
        local CommonDialogParams = {}
        CommonDialogParams.RightCallbackFunction = function()
            self:SaveAllWidgetLayoutData(self.CurEditPlan)
            self.bHaveModifiedLayoutData = false
            self:PlayOutAnim()
        end
        CommonDialogParams.LeftCallbackFunction = function()
            EventManager:FireEvent(EventID.OnSwitchMobileHUDLayout, self.CurEditPlan)
            self.bHaveModifiedLayoutData = false
            self:PlayOutAnim()
        end
        UIManager(self):ShowCommonPopupUI(100273, CommonDialogParams, self)
    else
        self:PlayOutAnim()
    end
end

-- 点击添加按钮
function M:OnClickedAdd()
    ReddotManager.ClearLeafNodeCount("Setting_Control_AddBtn")
    self:UpdateRedDot()

    -- 展开添加按钮面板
    self.SchemeRight:PlayInAnim()
end

-- 点击重置按钮
function M:OnClickedAnewSet()
    local CommonDialogParams = {}
    CommonDialogParams.RightCallbackFunction = function()
        self:ResetToDefaultLayout()
        self.bHaveModifiedLayoutData = true
        self.Btn_Retract:ForbidBtn(true)
        self.Btn_Anew:ForbidBtn(true)
        self.AllWidgetOperationHistory = {}
    end
    UIManager(self):ShowCommonPopupUI(100274, CommonDialogParams, self)
end

-- 点击向上移动按钮
function M:OnClickedMoveUp()
    if (self.CurrentSelectWidget == nil) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_DefaultTip"))
        return
    end
    if IsValid(self.CurrentSelectWidget) then
        self.CurrentSelectWidget:MoveWidgetByOffset(FVector2D(0, -BattleHUDCommonConst.LayOutSettingConfig.MoveOffsetStep))
    end
end

-- 点击向下移动按钮
function M:OnClickedMoveDown()
    if (self.CurrentSelectWidget == nil) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_DefaultTip"))
        return
    end
    if IsValid(self.CurrentSelectWidget) then
        self.CurrentSelectWidget:MoveWidgetByOffset(FVector2D(0, BattleHUDCommonConst.LayOutSettingConfig.MoveOffsetStep))
    end
end

-- 点击向左移动按钮
function M:OnClickedMoveLeft()
    if (self.CurrentSelectWidget == nil) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_DefaultTip"))
        return
    end
    if IsValid(self.CurrentSelectWidget) then
        self.CurrentSelectWidget:MoveWidgetByOffset(FVector2D(-BattleHUDCommonConst.LayOutSettingConfig.MoveOffsetStep, 0))
    end
end

-- 点击向右移动按钮
function M:OnClickedMoveRight()
    if (self.CurrentSelectWidget == nil) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_DefaultTip"))
        return
    end
    if IsValid(self.CurrentSelectWidget) then
        self.CurrentSelectWidget:MoveWidgetByOffset(FVector2D(BattleHUDCommonConst.LayOutSettingConfig.MoveOffsetStep, 0))
    end
end

-- 点击试用按钮
function M:OnClickedTrial()
    ReddotManager.ClearLeafNodeCount("Setting_Control_TrailBtn")
    -- 使用试用布局方案索引保存试用跳转的数据
    local WidgetPlanData = self:GetCurrentWidgetPlanData()
    self.PlayerAvatar:UpdateMobileHudPlan(TRIAL_LAYOUT_PLAN_INDEX, WidgetPlanData)
    -- 播放退出动画，在动画完成后关闭设置界面和当前界面，直接返回到主HUD
    self:PlayOutAnimAndCloseSettingAndMenuWorld()
    UIManager(self):LoadUINew("CustomHUDSettingTrailUI", self.CurEditPlan, WidgetPlanData)
end

-- 显示切换布局方案弹窗
function M:ShowSwitchLayoutPlanPopup()
    local Params = {Index = self.CurEditPlan}
    UIManager(self):ShowCommonPopupUI(100322, Params)
end

-- 点击切换按钮
function M:OnClickedSwitch()
    self:ShowSwitchLayoutPlanPopup()
end

function M:SetEditPlanName()
    local MappedPlanIndex = self:_GetMappedPlanIndex(self.CurEditPlan)
    if (MappedPlanIndex == 1) then
        -- 第一个布局方案不显示添加按钮, 且需要隐藏所有手动添加节点项
        self.Group_Add:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Group_Add:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local PlanData = Avatar:GetMobileHudPlan(self.CurEditPlan)
    if not PlanData then
        return
    end
    local PlanName = PlanData.HudPlanName or "Default"
    self.PlanName = PlanName
    self.Text_PlanName:SetText(PlanName)
end

-- 重置所有关联节点到默认状态
function M:ResetRelativeNodeStateInDefault()
    for _, LayoutNodeName in ipairs(BattleHUDCommonConst.AllHasRelativeNodeWidgetList) do
        local LayoutConfigData = self.AllHUD_DraggableWidgetConfigData[LayoutNodeName]
        if (LayoutConfigData) then
            local WidgetNode = LayoutConfigData.WidgetObj
            if (WidgetNode and type(WidgetNode.ResetRelativeNodeToDefault) == "function") then
                WidgetNode:ResetRelativeNodeToDefault()
            end
        end
    end
end

AssembleComponents(M)

return M
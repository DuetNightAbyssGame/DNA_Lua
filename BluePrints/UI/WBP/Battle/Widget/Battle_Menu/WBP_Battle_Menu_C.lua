--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_Menu_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.UI.BP_EMUserWidgetUtils_C",})

local IN_BATTLE_MENU = UIConst.BATTLE_MENU_BEHAVIOUR_TYPE.IN_BATTLE_MENU
local ARMOURY_BATTLE_MENU = UIConst.BATTLE_MENU_BEHAVIOUR_TYPE.ARMOURY_BATTLE_MENU

local GAMEPAD_DEAD_AREA = 0.5
M._components = {}

M.BehaviourComponent = {
    [IN_BATTLE_MENU] = "BluePrints.UI.WBP.Battle.Widget.Battle_Menu.InBattleWheelMenuComponent",
    [ARMOURY_BATTLE_MENU] = "BluePrints.UI.WBP.Battle.Widget.Battle_Menu.ArmoryBattleWheelMenuComponent",
}

M.SLOT_INDEX_2_BG_INDEX =
{
    [1] = 7,
    [2] = 8,
    [3] = 1,
    [4] = 2,
    [5] = 3,
    [6] = 4,
    [7] = 5,
    [8] = 6
}

function M:Construct()
    --第一个槽位在第一象限
    --槽位的方向向量
    self.SlotDirections = { FVector2D(1,0),
UKismetMathLibrary.Normal2D(FVector2D(1,-1)),
                            FVector2D(0,-1),
UKismetMathLibrary.Normal2D(FVector2D(-1,-1)),
                            FVector2D(-1,0),
UKismetMathLibrary.Normal2D(FVector2D(-1,1)),
                            FVector2D(0,1),
UKismetMathLibrary.Normal2D(FVector2D(1,1)),
                            FVector2D(1,0)}
    self.TotalSlotNumber = 8
    self.AngelPerSlot = 360 / self.TotalSlotNumber
    --轮盘外圈半径（用于计算，会随窗口大小改变）
    self.OuterWheelRadius = 9999999
    --轮盘内圈半径（用于计算，会随窗口大小改变）
    self.InnerWheelRadius = 0.0001
    --期望轮盘外圈半径
    self.DesiredOuterWheelRadius = 9999999
    --期望轮盘内圈半径
    self.DesiredInnerWheelRadius = 0.0001
    --用于计算圆心的控件
    self.WidgetForCalcCenter = self.Bg01
    self.FrameCount = 0
    --默认开启Hover
    self.bEnableHovered = true
    --指针Tick检测默认开启
    self.bEnablePointerDetection = true
    --如果为true，鼠标不在窗口内依然会发生交互
    self.bPointerAllwaysEntered = false
    --用于保存Slot对应的数据对象
    self.SlotContents = {}
    for i=1,self.TotalSlotNumber do
    self["Prop_Icon"..i]:BindEvent(self,{   OnDragDetected = self.OnDragDetected,
                                            OnCaptruedMouseButtonUp = self.OnMouseButtonUp,
                                            OnDragCancelled = self.OnDragCancelled
                                            })
    end
    self.Scheme_Switching:BindEventOnSchemeClicked(self,self.OnSchemeClicked)
    self.InstallSoundFunc = function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/combat_bag_cell_place_common", nil, nil)
    end
    self.PointerPos = FVector2D(0,0)
    self.bDeviceInPc = CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"
    self:AddDispatcher(EventID.OnWindowResized, self, function()
        self:RelayoutPrepass(-10)
    end)
    self:AddDispatcher(EventID.OnWindowMoved, self, function()
        self:RelayoutPrepass(-10)
    end)
    self.AnalogValue = FVector2D(0,0)
    self.KeyDownEvents = {}
    self.KeyDownEvents[UIConst.GamePadKey.FaceButtonBottom] = self.OnFaceButtonBottomKeyDown
    self.KeyUpEvents = {}
    self.KeyUpEvents[UIConst.GamePadKey.FaceButtonBottom] = self.OnFaceButtonBottomKeyUp
    self:AddInputMethodChangedListen()
    self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
    self.bIsDealWithVirtualAccept = true
    self:TryInitBgMat()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.bIsGamepad = CurInputDevice == ECommonInputType.Gamepad
end

--更新交互检测（改变大小后需要调用）
function M:RelayoutPrepass(FrameCount)
    self.FrameCount = FrameCount or 0
end

function M:Tick(MyGeometry, InDeltaTime)
    if(self.FrameCount < 2)then
        --前两帧不能获取UI正确大小，此处等待两帧
        self.FrameCount = self.FrameCount + 1
        if(self.FrameCount == 2)then
            self:UpdateWheelConfig()
        end
        return
    end

	if self.bIsClosing or self:GetVisibility() ~= UIConst.VisibilityOp.Visible then
		return
	end
    local PointerInSlot = nil
    if(self.WheelCenter and self.bEnablePointerDetection and (self.bPointerEntered or self.bPointerAllwaysEntered) )then
        local PointerPosition = self:GetPointerPosition()
        local Diff = PointerPosition - self.WheelCenter

        if self.bIsGamepad then
            self:CalcGamepadPointerDiff(Diff)
        end
        
        local DiffSize = UKismetMathLibrary.VSize2D(Diff)
        self.bMouseInSelectArea = not self.bIsGamepad and DiffSize >= self.InnerWheelRadius and DiffSize <= self.OuterWheelRadius
        self.bOldGamepadInSelectArea = self.bGamepadInSelectArea
        self.bGamepadInSelectArea = self.bIsGamepad and DiffSize > GAMEPAD_DEAD_AREA
        local bInSelectArea = self.bMouseInSelectArea or self.bGamepadInSelectArea
        
        if bInSelectArea then
            PointerInSlot = self:CalcHoveredSlot(Diff)
        end
        --检测到的最后的鼠标悬停Slot
        self.LastDetectedHoveredSlot = PointerInSlot
    end
    local LastSlot = self.CurrentHoveredSlot
    self.CurrentHoveredSlot = PointerInSlot
    if(PointerInSlot ~= LastSlot)then
        self:OnSlotHoverChanged(LastSlot,PointerInSlot)
    end

    if self.bOldGamepadInSelectArea and not self.bGamepadInSelectArea then
        self:HandleJoystickSelect(LastSlot)
    end
end

function M:CalcGamepadPointerDiff(Diff)
    --在Component实现
end

function M:CalcHoveredSlot(DisFromCenter)
    local NormalDiff = UKismetMathLibrary.Normal2D(DisFromCenter)
    for i=1,self.TotalSlotNumber do
        local AngelSlot = UKismetMathLibrary.DegAcos(UKismetMathLibrary.DotProduct2D(NormalDiff,self.SlotDirections[i]))
        local AngelNextSlot = UKismetMathLibrary.DegAcos(UKismetMathLibrary.DotProduct2D(NormalDiff,self.SlotDirections[i+1]))
        if( AngelSlot >= 0 and AngelSlot <= self.AngelPerSlot
                and AngelNextSlot > 0 and AngelNextSlot <= self.AngelPerSlot)then
            return i
        end
    end
end

---设置轮盘半径
---@param InnerWheelRadius number 轮盘内圈半径
---@param OuterWheelRadius number 轮盘外圈半径
function M:SetWheelRadius(InnerWheelRadius,OuterWheelRadius)
    self.DesiredInnerWheelRadius = InnerWheelRadius
    self.DesiredOuterWheelRadius = OuterWheelRadius
    local ViewPortScale = UE4.UWidgetLayoutLibrary.GetViewportScale(self)
    self.InnerWheelRadius = InnerWheelRadius * ViewPortScale * self.RenderTransform.Scale.X
    self.OuterWheelRadius = OuterWheelRadius * ViewPortScale * self.RenderTransform.Scale.X
    if(InnerWheelRadius <= 0)then
        self.InnerWheelRadius = 0.0001
    end
end


---播放In动画
function M:PlayInAnim()
    self.Scheme_Switching:PlayInAnim()
    self:StopAnimation(self.Auto_Out)
    self:PlayAnimation(self.Auto_In)
    self:SetVisibility(UIConst.VisibilityOp.Visible)
end

---播放Out动画
function M:PlayOutAnim()
    self:StopAnimation(self.Auto_In)
    self:PlayAnimation(self.Auto_Out)
    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

---设置轮盘方案
function M:SetWheelScheme(SchemIdx)
    self.Scheme_Switching:SwitchScheme(SchemIdx)
end

---设置轮盘中心样式
function M:SetWheelMiddleStyle(Style)
    self.WidgetSwitcher_0:SetActiveWidgetIndex(Style)
end

function M:CreateCommonKey(Params)
    if(Params)then
        self.Key:CreateCommonKey(Params)
        self.Key:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
    else
        self.Key:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

---设置轮盘中心文本
function M:SetTipText(Text)
    self.Text_Tips:SetText(Text)
end

---设置轮盘中心文本
function M:SetWSNum(Num)
    self.WS_Num:SetActiveWidgetIndex(Num - 1)
end

---判断Slot是否在轮盘右侧
function M:IsSlotInWheelRight(SlotIdx)
    local QuarterTotal = self.TotalSlotNumber / 4
    local HalfTotal = self.TotalSlotNumber / 2
    return SlotIdx + QuarterTotal <= HalfTotal or SlotIdx - QuarterTotal > HalfTotal
end

---开关tick检测指针位置
function M:EnablePointerDetection(bEnable)
    self.bEnablePointerDetection = bEnable
end

---设置作为轮盘中心的控件
function M:SetWheelCenter(Widget)
    self.WidgetForCalcCenter = Widget
    self.WheelCenter = self:CalcWheelCenter()
    self:OnWheelCenterCalculated()
end

---计算轮盘中心
function M:CalcWheelCenter()
    local Geometry = self.WidgetForCalcCenter:GetTickSpaceGeometry()
    local LocalCenter = USlateBlueprintLibrary.GetLocalSize(Geometry) / 2
    return USlateBlueprintLibrary.LocalToAbsolute(Geometry,LocalCenter)
end

---指针悬停Slot改变时
---@field LastSlot Number 指针悬停的上一个Slot,需要判空
---@field CurrentSlot Number 指针悬停的当前Slot,需要判空
function M:OnSlotHoverChanged(LastSlot,CurrentSlot)
    if(not self.bEnableHovered)then
        return
    end

    if(CurrentSlot)then
        self:HoverSlot(CurrentSlot)
    else
        self:UnHoverSlot(LastSlot)
    end

    if(self.OnSlotHoverChangedEvent)then
        self.OnSlotHoverChangedEvent(self.EventReceiver,LastSlot,CurrentSlot)
    end
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    if(self.bDeviceInPc)then
        self.bPointerEntered = true
    end
end

function M:OnMouseLeave(MouseEvent)
    self.bPointerEntered = false
end

function M:OnDragEnter(MyGeometry, PointerEvent, Operation)
    self.bPointerEntered = true
end

function M:OnDragLeave(PointerEvent, Operation)
    self.bPointerEntered = false
end

function M:OnDragOver(MyGeometry, PointerEvent, Operation)
    self.bPointerEntered = true
    if(not self.bDeviceInPc)then
        self:SetPointerPositionByTouchEvnet( PointerEvent)
    end
    return false
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    self.bPointerEntered = true
    local ReturnValue
    if(self.CurrentHoveredSlot)then
        if(UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent) ==  UE4.EKeys.LeftMouseButton
            or UE4.UKismetInputLibrary.PointerEvent_IsTouchEvent(MouseEvent)
        )then
            if(self.bEnableClicked)then
                self.MouseDownSlot = self.CurrentHoveredSlot
                self:OnPressedChanged(self.MouseDownSlot,true)
                ReturnValue = UWidgetBlueprintLibrary.CaptureMouse(UE4.UWidgetBlueprintLibrary.Handled(),self)
            end
            if(self.bEnableDragAndDrop and self.SlotContents[self.CurrentHoveredSlot])then
                ReturnValue = UWidgetBlueprintLibrary.CaptureMouse(UE4.UWidgetBlueprintLibrary.Handled(),self["Prop_Icon"..self.CurrentHoveredSlot])
            end
        else
            if(self.bEnableClicked)then
                self.RightMouseDownSlot = self.CurrentHoveredSlot
                ReturnValue = UWidgetBlueprintLibrary.CaptureMouse(UE4.UWidgetBlueprintLibrary.Handled(),self)
            end
        end
    end
    return ReturnValue or UIUtils.Unhandled

end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    self.bPointerEntered = self.bDeviceInPc
    local MouseDownSlot
    if(UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent) ==  UE4.EKeys.LeftMouseButton
            or UE4.UKismetInputLibrary.PointerEvent_IsTouchEvent(MouseEvent)
        )then
        MouseDownSlot = self.MouseDownSlot
        self.MouseDownSlot = nil
        if(self.bEnableClicked)then
            if(MouseDownSlot)then
                self:OnPressedChanged(MouseDownSlot,false)
            end
            if(self.LastDetectedHoveredSlot and MouseDownSlot == self.LastDetectedHoveredSlot and self.OnSlotClickedEvent)then
                AudioManager(self):PlayUISound(self, "event:/ui/common/combat_bag_cell_click", nil, nil)
                self.OnSlotClickedEvent(self.EventReceiver,self.LastDetectedHoveredSlot,self.CurrentSelectedSlot)
            end
            return UWidgetBlueprintLibrary.ReleaseMouseCapture(UE4.UWidgetBlueprintLibrary.Handled())
        end
    else
        MouseDownSlot = self.RightMouseDownSlot
        self.RightMouseDownSlot = nil
        if(self.bEnableClicked)then
            if(self.LastDetectedHoveredSlot and MouseDownSlot == self.LastDetectedHoveredSlot and self.OnSlotRightMouseClickedEvent)then
                AudioManager(self):PlayUISound(self, "event:/ui/common/combat_bag_cell_click", nil, nil)
                self.OnSlotRightMouseClickedEvent(self.EventReceiver,self.LastDetectedHoveredSlot,self.CurrentSelectedSlot)
            end
            return UWidgetBlueprintLibrary.ReleaseMouseCapture(UE4.UWidgetBlueprintLibrary.Handled())
        end
    end
    return UIUtils.Unhandled
end

function M:SetPointerPositionByTouchEvnet(InTouchEvent)
    self.PointerPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InTouchEvent)
end

function M:OnTouchStarted(MyGeometry, InTouchEvent)
    self:SetPointerPositionByTouchEvnet( InTouchEvent)
    local Ret = self:OnMouseButtonDown(MyGeometry, InTouchEvent)
    self:Tick()
    return Ret 
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
    self.bPointerEntered = true
    self:SetPointerPositionByTouchEvnet( InTouchEvent)
    return UIUtils.Unhandled
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
    self:SetPointerPositionByTouchEvnet( InTouchEvent)
    local Ret =  self:OnMouseButtonUp(MyGeometry, InTouchEvent)
    self.bPointerEntered = false
    self:Tick()
    return Ret
end

---@param EventReceiver table 接收事件的对象
---@param Events table 事件
---@field Events.OnSlotHoverChangedEvent function Hover状态改变事件
---@field Events.OnSlotClickedEvent function 点击事件
---@field Events.OnSlotDragedEvent function 开始拖拽事件
---@field Events.OnSlotDropedEvent function 拖拽放置事件（放置在轮盘内）
---@field Events.OnDragCancelledEvent function 拖拽取消事件（放置在轮盘外）
---@field Events.CreateDragWidgetEvent function 创建拖拽控件事件（不绑定会调用默认的）
function M:BindEvents(EventReceiver, Events)
    self.EventReceiver = EventReceiver
    self.OnSlotHoverChangedEvent = Events.OnSlotHoverChangedEvent
    self.OnSlotClickedEvent = Events.OnSlotClickedEvent
    self.OnSlotRightMouseClickedEvent = Events.OnSlotRightMouseClickedEvent
    self.OnSlotDragedEvent = Events.OnSlotDragedEvent
    self.OnSlotDropedEvent = Events.OnSlotDropedEvent
    self.OnDragCancelledEvent = Events.OnDragCancelledEvent
    self.OnSlotItemExchangedEvent = Events.OnSlotItemExchangedEvent
    self.CreateDragWidgetEvent = Events.CreateDragWidgetEvent
    self.OnSchemeClickedEvent = Events.OnSchemeClickedEvent
    self._OnAddedToFocusPath = Events.OnAddedToFocusPathEvent
    self._OnRemovedFromFocusPath = Events.OnRemovedFromFocusPathEvent
    self._OnAnalogValueChanged = Events.OnAnalogValueChanged
end

function M:EnableEvents(bEnableHovered, bEnableClicked, bEnableDragAndDrop)
    self.bEnableHovered = bEnableHovered
    self.bEnableClicked = bEnableClicked
    self.bEnableDragAndDrop = bEnableDragAndDrop
end

function M:OnSchemeClicked(Index)
    if(self.OnSchemeClickedEvent)then
        self.OnSchemeClickedEvent(self.EventReceiver,Index)
    end
end

---数据对象（Content）相关

---设置Slot数据（无动效）
function M:SetSlotItem(SlotIndex,Content)
    self.SlotContents[SlotIndex] = Content
    self:UpdateSlotItemWidget(SlotIndex,Content)
end
function M:UpdateSlotItemWidget(SlotIndex,Content)
    if(Content)then
        Content.IconAnimationBP = DataMgr.Resource[Content.Id] and DataMgr.Resource[Content.Id].IconAnimationBP or nil
    end
    if(Content and  Content.IconAnimationBP)then
        local PropSp = UIManager(self):CreateWidget(Content.IconAnimationBP,false)
        if PropSp then
            self["Prop_"..SlotIndex]:RemoveChild(self["Prop_Icon"..SlotIndex])
            rawset(self,"Prop_Icon"..SlotIndex,PropSp)
            self["Prop_"..SlotIndex]:AddChild(self["Prop_Icon"..SlotIndex])
        end
    elseif Content then
        local NormalPropBP = '/Game/UI/WBP/Battle/Widget/Battle_Menu/WBP_BattleMenu_Prop.WBP_BattleMenu_Prop'
        local Prop = UIManager(self):CreateWidget(NormalPropBP,false)
        if Prop then
            self["Prop_"..SlotIndex]:RemoveChild(self["Prop_Icon"..SlotIndex])
            rawset(self,"Prop_Icon"..SlotIndex,Prop)
            self["Prop_"..SlotIndex]:AddChild(self["Prop_Icon"..SlotIndex])
        end
    end
    if Content then
        self["Prop_Icon"..SlotIndex]:BindEvent(self,
        {   
            OnDragDetected = self.OnDragDetected,
            OnCaptruedMouseButtonUp = self.OnMouseButtonUp,
            OnDragCancelled = self.OnDragCancelled
        })
        self:SetSlotItemVisibility(SlotIndex,UIConst.VisibilityOp["Visible"])
    else
        self:SetSlotItemVisibility(SlotIndex,UIConst.VisibilityOp["Collapsed"])
    end
    self["Prop_Icon"..SlotIndex]:OnSlotPropObjectSet(Content)
end

---获取Slot数据
function M:GetSlotItem(SlotIndex)
    return SlotIndex and self.SlotContents[SlotIndex]
end

function M:GetSlotWidget(SlotIndex)
    return SlotIndex and self["Prop_Icon"..SlotIndex]
end

function M:FindFirtEmptySlotIdx()
    for i=1,self.TotalSlotNumber do
        if(not self.SlotContents[i])then
            return i
        end
    end
end

---获取当前指针悬停Slot
function M:GetCurrentPointerHoveredSlot()
    if(self.CurrentHoveredSlot)then
        return self.SlotContents[self.CurrentHoveredSlot],self.CurrentHoveredSlot
    end
end

function M:SetSlotItemVisibility(SlotIdx,VisibilityOp)
    if(self.SlotContents[SlotIdx])then
        self["Prop_Icon"..SlotIdx]:SetVisibility(VisibilityOp)
    else
        if(self["Prop_Icon"..SlotIdx])then
            self["Prop_Icon"..SlotIdx]:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    end
end

---选中Slot
function M:SelectSlot(bSelected,SlotIdx)
    if(bSelected)then
        self.CurrentSelectedSlot = SlotIdx
        self:OnSelectedChanged(self.CurrentSelectedSlot,true)
    else
        self:ClearSlotSelect()
    end
end

---清除Slot选中态
function M:ClearSlotSelect()
    if(self.CurrentSelectedSlot)then
        self:OnSelectedChanged(self.CurrentSelectedSlot,false)
    end
    self.CurrentSelectedSlot = nil
end

---安装Slot（有动效)
function M:InstallSlot(bSuccessful,SlotIdx,Content)
    if(bSuccessful)then
        self:SetSlotItem(SlotIdx,Content)
        self:PlayInstallSound(Content)
        self:OnInstallationSuccessful(SlotIdx)
    else
        self:OnInstallationFailure(SlotIdx)
        AudioManager(self):PlayUISound(self, "event:/ui/common/err_action_warning", nil, nil)
    end
end

---交换Slot（有动效)
function M:ExchangedItem(bSuccessful,FromIdx,ToIdx)
    if(bSuccessful)then
        local tContent = self.SlotContents[FromIdx]
        self:SetSlotItem(FromIdx,self.SlotContents[ToIdx])
        self:SetSlotItem(ToIdx,tContent)
        if(self.SlotContents[FromIdx])then
            self:PlayInstallSound(self.SlotContents[FromIdx])
            self:OnInstallationSuccessful(FromIdx)
        end
        if(self.SlotContents[ToIdx])then
            self:PlayInstallSound(self.SlotContents[ToIdx])
            self:OnInstallationSuccessful(ToIdx)
        end
    else
        AudioManager(self):PlayUISound(self, "event:/ui/common/err_action_warning", nil, nil)
        if(self.SlotContents[FromIdx])then
            self:OnInstallationFailure(FromIdx)
        end
        if(self.SlotContents[ToIdx])then
            self:OnInstallationFailure(ToIdx)
        end
    end
end

function M:OnPressedChanged(SlotIdx,bPressed)
    local BgIndex = self.SLOT_INDEX_2_BG_INDEX[SlotIdx]
    if(bPressed)then
        if self.BgMat then
            self.BgMat:SetScalarParameterValue("MenuID", BgIndex)
            self:PlayAnimation(self.Press)
        end
    else
        --self:PlayAnimation(self.Normal)
    end
end

function M:OnSelectedChanged(SlotIdx,bSelected)
    local BgIndex = self.SLOT_INDEX_2_BG_INDEX[SlotIdx]
    if(bSelected)then
        if self.BgMat then
            self.BgMat:SetScalarParameterValue("LoopID", BgIndex)
            self:PlayAnimation(self.Opacity_Loop,0,0,0,1,true)
        end
    else
        self:StopAnimation(self.Opacity_Loop)
        self.BgMat:SetScalarParameterValue("LoopOpacity", 0)
    end
end

function M:OnInstallationSuccessful(SlotIdx)
    local BgIndex = self.SLOT_INDEX_2_BG_INDEX[SlotIdx]
    if self.BgMat then
        if(self:IsAnimationPlaying(self.InstallationSuccessful))then
            self.BgMat:SetScalarParameterValue("InstallID2", BgIndex)
            self:PlayAnimation(self.InstallationSuccessful2)
        else
            self.BgMat:SetScalarParameterValue("InstallID1", BgIndex)
            self:PlayAnimation(self.InstallationSuccessful)
        end
    end
end

function M:OnInstallationFailure(SlotIdx)
    local BgIndex = self.SLOT_INDEX_2_BG_INDEX[SlotIdx]
    if self.BgMat then
        if(self:IsAnimationPlaying(self.InstallationFailure))then
            self.BgMat:SetScalarParameterValue("InstallID2", BgIndex)
            self:PlayAnimation(self.InstallationFailure2)
        else
            self.BgMat:SetScalarParameterValue("InstallID1", BgIndex)
            self:PlayAnimation(self.InstallationFailure)
        end
    end
end

--region 拖拽相关

---创建拖拽控件：
---@field self.Content.CreateDragWidget function 返回值为UserWidget
---@field self.Content.DragTag string 说明参照UDragDropOperation
---@field self.Content.DragPivot EDragPivot 说明参照UDragDropOperation
---@field self.Content.DragOffset FVector2D 说明参照UDragDropOperation
function M:OnDragDetected(MyGeometry,PointerEvent)
    self.bPointerEntered = true
    if(not self.bEnableDragAndDrop)then
        return
    end
    local DragContent = self.LastDetectedHoveredSlot and self.SlotContents[self.LastDetectedHoveredSlot]
    if not DragContent then
        return
    end
    local DragDropOperation = NewObject(self.DragDropOperationClass)
    self.CurrentDragSlot = self.LastDetectedHoveredSlot
    self:SetSlotItemVisibility(self.CurrentDragSlot,UIConst.VisibilityOp["Collapsed"])
    DragDropOperation.Payload = DragContent
    if(self.CreateDragWidgetEvent)then
        DragDropOperation.DefaultDragVisual = self.CreateDragWidgetEvent(self.EventReceiver,DragContent,self.LastDetectedHoveredSlot)
    else
        DragDropOperation.DefaultDragVisual = self:CreateDefaultDragWidget(DragContent,self.LastDetectedHoveredSlot)
    end
    DragDropOperation.Tag = DragContent.DragTag or DragDropOperation.Tag
    DragDropOperation.Pivot = DragContent.DragPivot or UE4.EDragPivot.CenterCenter
    DragDropOperation.Offset = DragContent.DragOffset or DragDropOperation.Offset
    self.DragDropOperation = DragDropOperation
    return DragDropOperation
end

function M:CreateDefaultDragWidget(DragContent)
    if(not IsValid(self.DefaultDragWidget))then
        self.DefaultDragWidget = UIManager(self):CreateWidget('/Game/UI/WBP/Battle/Widget/Battle_Menu/WBP_BattleMenu_Prop.WBP_BattleMenu_Prop',false)
        self.DefaultDragWidget.Text_Num:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    if(not IsValid(self.DefaultDragSPWidget)) then
        self.DefaultDragSPWidget = UIManager(self):CreateWidget('/Game/UI/WBP/Battle/Widget/Battle_Menu/WBP_BattleMenu_Prop_SpCar.WBP_BattleMenu_Prop_SpCar',false)
        self.DefaultDragSPWidget.Text_Num:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    if(DragContent.Icon and not DragContent.IconAnimationBP)then
        local IconDynaMaterial = self.DefaultDragWidget.Prop_Icon:GetDynamicMaterial()
        if(IconDynaMaterial)then
            if(type(DragContent.Icon) == "string")then
                IconDynaMaterial:SetTextureParameterValue("MainTex",LoadObject(DragContent.Icon))
            else
                IconDynaMaterial:SetTextureParameterValue("MainTex",DragContent.Icon)
            end
        end
    elseif (DragContent.Icon and DragContent.IconAnimationBP)then
        self.DefaultDragSPWidget.Prop_Icon:SetBrushFromTexture(LoadObject(DragContent.Icon))
    end
    return DragContent.IconAnimationBP and self.DefaultDragSPWidget or self.DefaultDragWidget
end

function M:OnDrop(MyGeometry,PointerEvent,Operation)
    self.bPointerEntered = false
    if(not self.bEnableDragAndDrop or not self.bEnablePointerDetection)then
        return false
    end
    local DragSlot =  self.CurrentDragSlot
    if(not Operation.DefaultDragVisual or not Operation.Payload)then
        self.CurrentDragSlot = nil
        return false
    end
    if(DragSlot)then
        --被放置的控件来自轮盘
        if(self.CurrentHoveredSlot)then
            --在轮盘内放置
            if(self.MouseDownSlot)then
                self:OnPressedChanged(self.MouseDownSlot,false)
            end
            self.MouseDownSlot = nil
            self:SetSlotItemVisibility(DragSlot,UIConst.VisibilityOp["Visible"])
            if(DragSlot ~= self.CurrentHoveredSlot)then
                if(self.OnSlotItemExchangedEvent)then
                    self.OnSlotItemExchangedEvent(self.EventReceiver,self.SlotContents[DragSlot],self.SlotContents[self.CurrentHoveredSlot],DragSlot,self.CurrentHoveredSlot)
                end
            end
        else
            --在轮盘外放置
            self:OnDragCancelled(PointerEvent,Operation)
        end
        self.CurrentDragSlot = nil
        return true
    else
        --被放置的控件来自外部
        local Content = Operation.Payload
        if(self.OnSlotDropedEvent and self.CurrentHoveredSlot)then
            self.OnSlotDropedEvent(self.EventReceiver,Content,self.CurrentHoveredSlot)
        end
    end
    self.CurrentDragSlot = nil
    return false
end

function M:OnDragCancelled(PointerEvent,Operation)
    if(self.CurrentHoveredSlot)then
        self:OnDrop(nil,PointerEvent,Operation)
        return
    end
    if(self.CurrentDragSlot)then
        self:SetSlotItemVisibility(self.CurrentDragSlot,UIConst.VisibilityOp["Visible"])
    end
    local DragSlot = self.CurrentDragSlot
    self.CurrentDragSlot = nil
    if(self.MouseDownSlot)then
        self:OnPressedChanged(self.MouseDownSlot,false)
    end
    self.MouseDownSlot = nil
    if(self.OnDragCancelledEvent)then
        local Content = Operation.Payload
        self.OnDragCancelledEvent(self.EventReceiver,Content,DragSlot)
    end
end

function M:PlayInstallSound(Content)
    if(self.InstallSoundFunc)then
        self.InstallSoundFunc(Content)
    end
end

--endregion 拖拽相关


--#region 按键输入

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    if(self._OnAnalogValueChanged)then
        local Reply,IsHandled = self._OnAnalogValueChanged(self.EventReceiver,MyGeometry,InAnalogInputEvent)
        if(IsHandled)then
            return Reply
        end
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if(InKeyName == "Gamepad_LeftX")then
        self.AnalogValue.X = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    elseif(InKeyName == "Gamepad_LeftY")then
        self.AnalogValue.Y = -UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    end
    return UIUtils.Handled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local InputEvent = UWidgetBlueprintLibrary.GetInputEventFromKeyEvent(InKeyEvent)
    if(UKismetInputLibrary.InputEvent_IsRepeat(InputEvent))then
        return UIUtils.Unhandled
    end
    local KeyDownEvent = self.KeyDownEvents[InKeyName]
    if(KeyDownEvent)then
        local Reply,IsHandled = KeyDownEvent(self)
        return Reply,IsHandled
    end
    return UIUtils.Unhandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local KeyUpEvent = self.KeyUpEvents[InKeyName]
    if(KeyUpEvent)then
        local Reply,IsHandled = KeyUpEvent(self)
        return Reply,IsHandled
    end
    return UIUtils.Unhandled
end

function M:OnFaceButtonBottomKeyDown(MyGeometry, InKeyEvent)
    if(UWidgetBlueprintLibrary.IsDragDropping())then
        return UIUtils.Handled
    end
    if(self.bEnableClicked)then
        if(self.CurrentHoveredSlot)then
            if(self.bEnableClicked)then
                self.KeyDownSlot = self.CurrentHoveredSlot
                self:OnPressedChanged(self.KeyDownSlot,true)
                return UE4.UWidgetBlueprintLibrary.Handled(),true
            end
        end
    end
    return UIUtils.Unhandled
end

function M:OnFaceButtonBottomKeyUp(MyGeometry, InKeyEvent)
    if(self.bEnableClicked)then
        if(self.KeyDownSlot)then
            self:OnPressedChanged(self.KeyDownSlot,false)
        end
        local KeyDownSlot = self.KeyDownSlot
        self.KeyDownSlot = nil
        if(self.LastDetectedHoveredSlot and KeyDownSlot == self.LastDetectedHoveredSlot and self.OnSlotClickedEvent)then
            AudioManager(self):PlayUISound(self, "event:/ui/common/combat_bag_cell_click", nil, nil)
            self.OnSlotClickedEvent(self.EventReceiver,self.LastDetectedHoveredSlot,self.CurrentSelectedSlot)
        end
        return UE4.UWidgetBlueprintLibrary.Handled(),true
    end
    return UIUtils.Unhandled
end

--#endregion 按键输入

function M:PreInitByParam(Params)
    if Params then
        if Params.BehaviourType then
            if self._components and next(self._components) then
                -- do nothing
            else
                local BehaviourComp = nil

                self._components = {}
                if Params.BehaviourType == IN_BATTLE_MENU then
                    BehaviourComp = self.BehaviourComponent[IN_BATTLE_MENU]
                elseif Params.BehaviourType == ARMOURY_BATTLE_MENU then
                    BehaviourComp = self.BehaviourComponent[ARMOURY_BATTLE_MENU]
                end

                if BehaviourComp then
                    table.insert(self._components, BehaviourComp)
                end
                AssembleComponents(self)
            end
        end
    end
    if(self.InitContent)then
        self:InitContent(Params)
    end
end

function M:UpdateArgs(Params)
    self:PreInitByParam(Params)
end

function M:OnWheelCenterCalculated()
end

--#region 聚焦/导航相关

function M:OnAddedToFocusPath()
    if(self._OnAddedToFocusPath)then
        self._OnAddedToFocusPath(self.EventReceiver,self)
    end
end


function M:OnRemovedFromFocusPath(FocusEvent)
    if(self.bEnableClicked)then
        if(self.KeyDownSlot)then
            self:OnPressedChanged(self.KeyDownSlot,false)
        end
        self.KeyDownSlot = nil
    end
    self:HandleRemovedFromFocusPath(FocusEvent)
    if(self._OnRemovedFromFocusPath)then
        self._OnRemovedFromFocusPath(self.EventReceiver,self)
    end
end

function M:HandleRemovedFromFocusPath(FocusEvent)
end


--#endregion 聚焦相关

function M:UpdateWheelConfig()
    self:SetWheelCenter(self.WidgetForCalcCenter)
    self:SetWheelRadius(self.DesiredInnerWheelRadius, self.DesiredOuterWheelRadius)
end

function M:GetPointerPosition()
    if (self.bDeviceInPc) then
        return UWidgetLayoutLibrary.GetMousePositionOnPlatform()
    else
        return self.PointerPos
    end
end
function M:Hide(HideTag)
    M.Super.Hide(self, HideTag)
    
    self:OnHide()
end

function M:OnHide()
end

function M:OnChangeDisplayWheel()
end

function M:HandleJoystickSelect()
end

function M:CloseMenu()
    
end

function M:TryInitBgMat()
    if nil == self.BgMat then
        self.BgMat = self.Img_BG:GetDynamicMaterial()
    end
end

function M:UnHoverSlot()
    if self.BgMat then
        DebugPrint("gmy@WBP_Battle_Menu_C M:UnHoverSlot")
        self:StopAnimation(self.Hover)
        self:PlayAnimation(self.UnHover)
    end
end

function M:HoverSlot(SlotIndex)
    local BgIndex = self.SLOT_INDEX_2_BG_INDEX[SlotIndex]

    if self.BgMat then
        DebugPrint("gmy@WBP_Battle_Menu_C M:HoverSlot", SlotIndex, BgIndex)
        AudioManager(self):PlayUISound(self, "event:/ui/common/combat_bag_cell_hover", nil, nil)
        self.BgMat:SetScalarParameterValue("HoverOpacity", 0)
        self.BgMat:SetScalarParameterValue("InstallOpacity", 0)
        self.BgMat:SetScalarParameterValue("MenuID", BgIndex)
        self:StopAnimation(self.UnHover)
        self:PlayAnimation(self.Hover)
    end
end

-- TODO@chenyan: 其他状态
--function M:PressSlot(SlotIndex)

return M

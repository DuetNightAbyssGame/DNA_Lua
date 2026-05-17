
require "UnLua"

-- 封装touch事件判断(技能面板专用)
local CommonTouchComponent = {}

function CommonTouchComponent:Initialize(Initializer)
    self.WidgetStartLocalPos = nil           -- 交互对象的开始位置（Local）
    self.WidgetCurLocalPos = nil             -- 交互对象的当前位置（Local）
    self.NowTouchWorldPos = {}               -- 当前触控点位置（Key是PointerIndex）
    self.m_LastWorldPosTable = {}            -- 上一次停留的Pos位置（Key是PointerIndex）
    self.LastTouch_Time = 0		        -- 上一次点击时间
    self.Click_MaxLen = 5               -- 单击判断的最大距离
    self.DClick_Prepared = false        -- 是否可以触发连击
    self.Lpress_Began = false           -- 是否已经触发长按
    self.Lpress_Interval = 0.5          -- 长按最小时间间隔
    self.Lpress_MaxLen = 20             -- 长按最大移动距离
    self.Touching_Flag = {}             -- 标识符，当前手指是否正处于拖动（Key是PointerIndex）
    self.AllTouchItems = {}             -- 所有的可拖拽控件
    self.AllParentWidget = {}           -- 所有可拖动的SubWidget的父Widget
    self.SubTouchItems = {}             -- 正在拖动交互的所有SubWidget
    self.SubTouchParentWidget = {}      -- 正在拖动交互的所有SubWidget的父Widget
    self.SubTouchItemsName = {}         -- 正在拖动交互的所有SubWidget的Name
    self.SubTouchItemsStartWorldPos = {}     -- Widget在当前控件之中的起始位置   
    self.UpdatePosFlag = {}             -- 是否需要实际拖动子SubWidget(Widget位置发生改变)
    self.m_LastHandleMoveTimeStamp = {}     -- 上一次处理触控移动的时间戳
    self.CurrentTouchingGeometry = {}       -- 几何体信息（Key是PointerIndex）
    self.CurrentTouchingGestureEvent = {}   -- Gesture信息（Key是PointerIndex）
    self.AllTouchCallBack = {}              -- 所有的Touch回调函数
    self.Owner_Player = nil                 -- 所属的Player对象

    self.m_UpdateTimerFlag_X = false        -- X方向的回弹
    self.m_UpdateTimerFlag_Y = false        -- Y方向的回弹
    self.CanLimitRange = false              -- 是否限制拖动的范围
    self.LimitRangeParam = {}               -- 拖动范围信息参数
    self.IsAutoAdjustByMultiTouch = false   -- 是否需要在多指触控下自动调整自身大小
    self.DefaultPixelSeries = 1.5           -- 自定义的放大比例因子
    self.MultiTouchLastTimeStamp = -1       -- 多指触控上一次释放时间戳（多指变单指）
    self.bNotUseOptimizationMove = false    -- 是否不需要优化版本的移动触控
    self.BackgroundPlateOffset = 100
end

function CommonTouchComponent:SetClickMaxLen(MaxLen)
    self.ClickMaxLen = MaxLen
end

function CommonTouchComponent:SetLongTouchInterval(Interval)
    self.LpressInterval = Interval
end

function CommonTouchComponent:InitTouchLayer(OwnerPlayer, UpdatetimeX, UpdatetimeY, bNotUseOptimization)
    self.Owner_Player = OwnerPlayer
    self.m_SavePrePos = FVector2D(0, 0)
    self.m_SaveTarPos = FVector2D(0, 0)
    self.Updatetime_X = UpdatetimeX
    self.Updatetime_Y = UpdatetimeY
    self.m_LastHandleMoveTimeStamp = {}
    self.bNotUseOptimizationMove = bNotUseOptimization
end

function CommonTouchComponent:InitTouchListenEvent()
    EventManager:AddEvent(EventID.CharDie, self, self.HandleOnCharDie)
    EventManager:AddEvent(EventID.StartTalk, self, self.HandleEventByInterrupt)
    self:ListenForInputAction("OpenMenu", EInputEvent.IE_Pressed, false, {self, self.HandleEventByInterrupt})
end

function CommonTouchComponent:RemoveTouchListenEvent()
    EventManager:RemoveEvent(EventID.CharDie, self)
    EventManager:RemoveEvent(EventID.StartTalk, self)
    self:StopListeningForInputAction("OpenMenu", EInputEvent.IE_Pressed)
end

function CommonTouchComponent:HandleOnCharDie(Eid)
    local Entity = GWorld.Battle:GetEntity(Eid)
    if (Entity and Entity.IsMainPlayer and Entity:IsMainPlayer()) then
        self:HandleEventByInterrupt()
    end
end

function CommonTouchComponent:HandleEventByInterrupt()
    for k, CurrentGeometry in pairs(self.CurrentTouchingGeometry) do
        if (self.Touching_Flag[k]) then
            self:MouseOrTouchButtonUp(CurrentGeometry, self.CurrentTouchingGestureEvent[k], k - 1)  
        end
    end
end

function CommonTouchComponent:AddStaticSubTouchItem(SubTouchName, SubTouchItem, ParentWidget, AllCallBack)
    self.UpdatePosFlag[SubTouchName] = false
    for k, v in pairs(AllCallBack) do
        if (self.AllTouchCallBack[k] == nil) then
            self.AllTouchCallBack[k] = {{Name=SubTouchName,Value=v}}
        else
            table.insert(self.AllTouchCallBack[k], {Name=SubTouchName,Value=v})
        end 
    end
    self.AllParentWidget[SubTouchName] = ParentWidget
    self.AllTouchItems[SubTouchName] = SubTouchItem
end

function CommonTouchComponent:AddMovedSubTouchItem(SubTouchName, SubTouchItem, ParentWidget, AllCallBack, LimitParams)
    -- LimitParams为限制区域相关设置，常见的如矩形，椭圆
    self.UpdatePosFlag[SubTouchName] = true
    for k, v in pairs(AllCallBack) do
        if (self.AllTouchCallBack[k] == nil) then
            self.AllTouchCallBack[k] = {{Name=SubTouchName,Value=v}}
        else
            table.insert(self.AllTouchCallBack[k], {Name=SubTouchName,Value=v})
        end 
    end
    self.AllParentWidget[SubTouchName] = ParentWidget
    self.LimitRangeParam[SubTouchItem] = LimitParams
    self.AllTouchItems[SubTouchName] = SubTouchItem
end

function CommonTouchComponent:OnTouchStarted(InGeometry, InGestureEvent)
    return self:MouseOrTouchButtonDown(InGeometry, InGestureEvent)
end

function CommonTouchComponent:OnTouchMoved(InGeometry, InGestureEvent)
    return self:MouseOrTouchButtonMove(InGeometry, InGestureEvent)
end

function CommonTouchComponent:OnTouchEnded(InGeometry, InGestureEvent)
    return self:MouseOrTouchButtonUp(InGeometry, InGestureEvent)
end

function CommonTouchComponent:GetOwningPlayer()
    return self.Owner_Player
end

function CommonTouchComponent:GetWorldPos(Widget)
    -- 获取绝对坐标
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if (UIManager == nil) then
        return FVector2D(0, 0), FVector2D(0, 0)
    end
    return UIManager:GetWorldPosition(Widget), UIManager:GetWidgetAbsoluteSize(Widget)
end

function CommonTouchComponent:GetLastPosTableLength()
    local NowCount = 0
    for k, v in pairs(self.m_LastWorldPosTable) do
        NowCount = NowCount + 1
    end
    return NowCount
end

function CommonTouchComponent:GetNowTouchWorldPosTableLength()
    local NowCount = 0
    for k, v in pairs(self.NowTouchWorldPos) do
        NowCount = NowCount + 1
    end
    return NowCount
end

--处理鼠标/触摸按下事件
function CommonTouchComponent:MouseOrTouchButtonDown(InGeometry, InGestureEvent)
    local ScreenSpacePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InGestureEvent)
    local thisPos = UE4.UUIFunctionLibrary.ScreenSpaceToAbsolute(ScreenSpacePosition)
    local SubTouchItem, SubTouchItemName, SubTouchItemStartWorldPos, SubTouchParentWidget = nil, nil, nil, nil
    for k, v in pairs(self.AllTouchItems) do
        local WidgetWorldPos, WidgetWorldSize = self:GetWorldPos(v)
        local ParentWidgetNode = self.AllParentWidget[k]
        local WidgetLocalScale = ParentWidgetNode and ParentWidgetNode.RenderTransform.Scale.X or 1.0
        local ParentSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(ParentWidgetNode)
        local ParentAlignment = ParentSlot:GetAlignment()
        local StartCamparePosX = WidgetWorldPos.X + WidgetWorldSize.X * WidgetLocalScale * (ParentAlignment.X - 1)
        local EndCamparePosX = WidgetWorldPos.X + WidgetWorldSize.X * WidgetLocalScale * ParentAlignment.X

        if ((ScreenSpacePosition.X >= StartCamparePosX and ScreenSpacePosition.X <= EndCamparePosX) and 
            (ScreenSpacePosition.Y >= WidgetWorldPos.Y and ScreenSpacePosition.Y <= WidgetWorldPos.Y + WidgetWorldSize.Y * WidgetLocalScale)) then
            -- 认为触摸的是此控件
            if (SubTouchItem == nil) then
                -- 没有的话直接设置
                SubTouchItem = v
                SubTouchItemName = k
                SubTouchItemStartWorldPos = FVector2D(WidgetWorldPos.X + WidgetWorldSize.X * 0.5, WidgetWorldPos.Y + WidgetWorldSize.Y * 0.5)
                SubTouchParentWidget = ParentWidgetNode
            else
                -- 根据层级来获取最上层的触控层（只有Canvas插槽类型的才会比较）
                local ChooseCanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(SubTouchItem)
                local TouchCanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(v)
                if (ChooseCanvasSlot and TouchCanvasSlot) then
                    if (TouchCanvasSlot.ZOrder > ChooseCanvasSlot.ZOrder) then
                        SubTouchItem = v
                        SubTouchItemName = k
                        SubTouchItemStartWorldPos = FVector2D(WidgetWorldPos.X + WidgetWorldSize.X * 0.5, WidgetWorldPos.Y + WidgetWorldSize.Y * 0.5)
                        SubTouchParentWidget = ParentWidgetNode
                    end
                end
            end
            if (SubTouchItem ~= nil) then
                break
            end
        end
    end
    if (SubTouchItem == nil) then
        DebugPrint("CommonTouchComponent== MouseOrTouchButtonDown Error, Not Find Can Interactive Item")
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    
    local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(SubTouchItem)
    local PointerIndex = UE4.UKismetInputLibrary.PointerEvent_GetPointerIndex(InGestureEvent)

    self.CurrentTouchingGeometry[PointerIndex + 1] = InGeometry
    self.CurrentTouchingGestureEvent[PointerIndex + 1] = InGestureEvent

    self.SubTouchItems[PointerIndex + 1] = SubTouchItem
    self.SubTouchParentWidget[PointerIndex + 1] = SubTouchParentWidget
    self.SubTouchItemsName[PointerIndex + 1] = SubTouchItemName
    self.SubTouchItemsStartWorldPos[PointerIndex + 1] = SubTouchItemStartWorldPos 

    self.WidgetCurLocalPos = CanvasSlot:GetPosition()
    if (self.WidgetStartLocalPos == nil) then
        self.WidgetStartLocalPos = CanvasSlot:GetPosition()
    else
        local LimitRangeInfo = self.LimitRangeParam[SubTouchItem]
        if (LimitRangeInfo and LimitRangeInfo.NeedResetPos) then
            local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(SubTouchItem)
            if (CanvasSlot ~= nil) then
                CanvasSlot:SetPosition(self.WidgetStartLocalPos)
            end
        end 
    end
    self.Touching_Flag[PointerIndex + 1] = true
    local AllDownCallBack = self.AllTouchCallBack["Down"]
    if (type(AllDownCallBack) == "table") then
        for k, v in pairs(AllDownCallBack) do
            if (v.Name == SubTouchItemName and type(v.Value) == "function") then
                v.Value(self, PointerIndex, self.WidgetCurLocalPos)
                break
            end
        end
    end
    -- 单指或两指的处理
    local TotalTouchCount = self:GetNowTouchWorldPosTableLength()
    if TotalTouchCount <= 2 then
        self.NowTouchWorldPos[PointerIndex + 1] = thisPos
        if TotalTouchCount <= 1 then
            -- 单指或者虚拟拖动拖动
            self.CanLimitRange = true
            self.m_IsTap = true                 -- 单指按下
        elseif TotalTouchCount == 2 then
            -- 多指拖动
            if (SubTouchItem.PixelSeries == nil) then
                SubTouchItem.PixelSeries = self.DefaultPixelSeries
            end
            self.CanLimitRange = false
            local otherPos = FVector2D(0, 0)

            for i = 1, #self.NowTouchWorldPos do
                if i ~= PointerIndex + 1 then   -- 第二指按下的位置
                    otherPos = self.NowTouchWorldPos[i]
                end

                self.m_ZoomStartLength = UE4.UKismetMathLibrary.Distance2D(thisPos, otherPos)
                self.m_IsTap = false
                self.m_OriginPoint = (thisPos + otherPos) / 2
                self:CalcZoomRatio(PointerIndex)
                self.StartPixelSeries = SubTouchItem.PixelSeries
            end
        end
        local Handled = UE4.UWidgetBlueprintLibrary.Handled()
        return UE4.UWidgetBlueprintLibrary.CaptureMouse(Handled, self)
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

--处理鼠标/触摸移动事件
function CommonTouchComponent:MouseOrTouchButtonMove(InGeometry, InGestureEvent)
    local PointerIndex = UE4.UKismetInputLibrary.PointerEvent_GetPointerIndex(InGestureEvent)
    if self.Touching_Flag[PointerIndex + 1] then
        local SubTouchItem = self.SubTouchItems[PointerIndex + 1]
        local NowTime = UE4.UGameplayStatics.GetRealTimeSeconds(self:GetOwningPlayer())
        if (not self.bNotUseOptimizationMove) then
            local LastHandleMoveTimeStamp = self.m_LastHandleMoveTimeStamp[PointerIndex + 1]
            if (LastHandleMoveTimeStamp and NowTime - LastHandleMoveTimeStamp <= 0.033) then
                -- 避免短时间内多次执行
                return UIUtils.Handled
            end
        end

        self.m_LastHandleMoveTimeStamp[PointerIndex + 1] = NowTime

        local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(SubTouchItem)
        local ScreenSpacePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InGestureEvent)
        local thisPos = UE4.UUIFunctionLibrary.ScreenSpaceToAbsolute(ScreenSpacePosition)

        local AllSingleMoveCallBack = self.AllTouchCallBack["Move"]
        local AllMultiMoveCallBack = self.AllTouchCallBack["MultiMove"]

        self.CurrentTouchingGeometry[PointerIndex + 1] = InGeometry
        self.CurrentTouchingGestureEvent[PointerIndex + 1] = InGestureEvent

        local TotalTouchCount = self:GetNowTouchWorldPosTableLength()

        if self.NowTouchWorldPos[PointerIndex + 1] ~= nil then
            if TotalTouchCount == 1 then --单指处理拖动
                if (type(AllSingleMoveCallBack) == "table") then
                    for k, v in pairs(AllSingleMoveCallBack) do
                        if (v.Name == self.SubTouchItemsName[PointerIndex + 1] and type(v.Value) == "function" and NowTime - self.MultiTouchLastTimeStamp >= 0.2) then
                            -- 传入目前的触摸坐标，以及相对于开始的移动距离向量(注意是否需要有Scale值的影响)
                            v.Value(self, TotalTouchCount, PointerIndex, self.WidgetCurLocalPos, thisPos - self.SubTouchItemsStartWorldPos[PointerIndex + 1], thisPos - self.NowTouchWorldPos[PointerIndex + 1], thisPos)
                            break
                        end
                    end
                end
            elseif TotalTouchCount == 2 then --两指处理缩放
                local otherPos
                for i = 1, TotalTouchCount do
                    if i ~= PointerIndex + 1 then
                        otherPos = self.NowTouchWorldPos[i]
                    end
                end
                local MoveDist = UE4.UKismetMathLibrary.Distance2D(thisPos, otherPos)
                if (type(AllMultiMoveCallBack) == "table") then
                    for k, v in pairs(AllMultiMoveCallBack) do
                        if (v.Name == self.SubTouchItemsName[PointerIndex + 1] and type(v.Value) == "function") then
                            -- 传入触摸的点，以及两个点之间的距离
                            v.Value(self, TotalTouchCount, PointerIndex, thisPos, otherPos, MoveDist)
                            break
                        end
                    end
                elseif (type(AllSingleMoveCallBack) == "table") then
                    for k, v in pairs(AllSingleMoveCallBack) do
                        if (v.Name == self.SubTouchItemsName[PointerIndex + 1] and type(v.Value) == "function" and NowTime - self.MultiTouchLastTimeStamp >= 0.2) then
                            -- 传入目前的触摸坐标，以及相对于开始的移动距离向量(注意是否需要有Scale值的影响)
                            v.Value(self, TotalTouchCount, PointerIndex, self.WidgetCurLocalPos, thisPos - self.SubTouchItemsStartWorldPos[PointerIndex + 1], thisPos - self.NowTouchWorldPos[PointerIndex + 1], thisPos)
                            break
                        end
                    end
                end
                if self.IsAutoAdjustByMultiTouch then
                    self.CanLimitRange = false
                    if self.m_ZoomStartLength <= MoveDist then -- 扩大
                        local newPixelSeries = (MoveDist - self.m_ZoomStartLength) / 20
                        SubTouchItem.PixelSeries = self.StartPixelSeries + newPixelSeries
                        if SubTouchItem.PixelSeries > 80 then  -- 限制扩大的最大范围
                            SubTouchItem.PixelSeries = 80
                        end
                    else
                        local newPixelSeries = (self.m_ZoomStartLength - MoveDist) / 20
                        SubTouchItem.PixelSeries = self.StartPixelSeries - newPixelSeries
                        if SubTouchItem.PixelSeries < 30 then
                            SubTouchItem.PixelSeries = 30
                        end
                    end
                    -- 子页面的PixelSeries更改 可以调用自己封装的AdjustSize()来更新该控件的大小
                    if (SubTouchItem.AdjustSize) then
                        SubTouchItem:AdjustSize() 
                    end
                    self:SetZoomPos(PointerIndex)
                end
            end 
            -- 更新触控点坐标
            self.NowTouchWorldPos[PointerIndex + 1] = thisPos               
            -- local lastPos = self.m_LastWorldPosTable[PointerIndex + 1]
            if (self.UpdatePosFlag[self.SubTouchItemsName[PointerIndex + 1]] == true) then
                self.WidgetCurLocalPos = self:GetNextMoveLocalPos(InGeometry, thisPos, PointerIndex)
                CanvasSlot:SetPosition(self.WidgetCurLocalPos)
                self.m_LastWorldPosTable[PointerIndex + 1] = thisPos
            end
            return UIUtils.Handled
        end
    end
    return UIUtils.Unhandled
end

--处理鼠标、触摸抬起事件
function CommonTouchComponent:MouseOrTouchButtonUp(InGeometry, InGestureEvent, TargetPointerIndex)
    local PointerIndex = TargetPointerIndex or UE4.UKismetInputLibrary.PointerEvent_GetPointerIndex(InGestureEvent)
    local SubTouchItem = self.SubTouchItems[PointerIndex + 1]
    if (SubTouchItem == nil) then
        DebugPrint("CommonTouchComponent== MouseOrTouchButtonUp, Not Find Can Interactive Item", PointerIndex)
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    self.m_IsTap = false
    self.Touching_Flag[PointerIndex + 1] = nil
    self.m_LastHandleMoveTimeStamp[PointerIndex + 1] = nil
    
    self.CurrentTouchingGeometry[PointerIndex + 1] = InGeometry
    self.CurrentTouchingGestureEvent[PointerIndex + 1] = InGestureEvent
    local AllUpCallBack = self.AllTouchCallBack["Up"]
    if (type(AllUpCallBack) == "table") then
        for k, v in pairs(AllUpCallBack) do
            if (v.Name == self.SubTouchItemsName[PointerIndex + 1] and type(v.Value) == "function") then
                -- 传出当前节点坐标、目前的点击坐标、上一次图像坐标、上一次点击坐标、以及相对于开始的移动距离向量
                local ScreenSpacePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InGestureEvent)
                local thisPos = UE4.UUIFunctionLibrary.ScreenSpaceToAbsolute(ScreenSpacePosition)
                v.Value(self, PointerIndex, self.WidgetCurLocalPos, self.m_LastWorldPosTable[PointerIndex + 1], self.NowTouchWorldPos[PointerIndex + 1], thisPos - self.SubTouchItemsStartWorldPos[PointerIndex + 1])
                break
            end
        end
    end
    if self.NowTouchWorldPos[PointerIndex + 1] ~= nil then
        self.NowTouchWorldPos[PointerIndex + 1] = nil
        local TotalTouchCount = self:GetNowTouchWorldPosTableLength()
        if TotalTouchCount == 0 then
            if self.CanLimitRange then
                self:LimitRange(PointerIndex)
            end
        elseif TotalTouchCount == 1 then
            self.MultiTouchLastTimeStamp = UE4.UGameplayStatics.GetRealTimeSeconds(self:GetOwningPlayer())
        end
        local Handled = UE4.UWidgetBlueprintLibrary.Handled()
        if self.UpdatePosFlag[self.SubTouchItemsName[PointerIndex + 1]] == true then
            self.UpdatePosFlag[self.SubTouchItemsName[PointerIndex + 1]] = false
            self:OnUpdatePosFlag(PointerIndex)
            --self.UpdatePosTimerHandle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.OnUpdatePosFlag}, 0.01, true)
        end
        return UE4.UWidgetBlueprintLibrary.ReleaseMouseCapture(Handled)
    end
    if self.UpdatePosFlag[self.SubTouchItemsName[PointerIndex + 1]] == true then
        self.UpdatePosFlag[self.SubTouchItemsName[PointerIndex + 1]] = false
        self:OnUpdatePosFlag(PointerIndex)
        --self.UpdatePosTimerHandle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.OnUpdatePosFlag}, 0.01, true)
    else
        self:AfterTouchItemMove(PointerIndex)
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

--计算缩放比例
function CommonTouchComponent:CalcZoomRatio(PointerIndex)
    self.m_OriginPoint = self.m_OriginPoint + FVector2D(math.abs(self.WidgetCurLocalPos.X), math.abs(self.WidgetCurLocalPos.Y))
    self.m_LeftPointPoint = FVector2D(self.BackgroundPlateOffset, self.BackgroundPlateOffset)
    self.m_RelativePos = self.m_OriginPoint - self.m_LeftPointPoint
    local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.SubTouchItems[PointerIndex + 1])
	--计算按下位置相对于控件长宽的位置比例
    local W = CanvasSlot:GetSize().X
    local H = CanvasSlot:GetSize().Y
    self.m_RelativePosRatio = FVector2D(self.m_RelativePos.X / W, self.m_RelativePos.Y / H)
end

--计算设置缩放后的偏移位置
function CommonTouchComponent:SetZoomPos(PointerIndex)
    local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.SubTouchItems[PointerIndex + 1])
    local newW = CanvasSlot:GetSize().X
    local newH = CanvasSlot:GetSize().Y
    self.m_newRelativePos = FVector2D(newW * self.m_RelativePosRatio.X, newH * self.m_RelativePosRatio.Y)
    local newPos = self.WidgetCurLocalPos - self.m_newRelativePos + self.m_RelativePos
    CanvasSlot:SetPosition(newPos)
end

--拖动时限制拖动范围
function CommonTouchComponent:GetNextMoveLocalPos(InGeometry, PointWorldPos, PointerIndex)
    local StartTouchWorldPos = self.SubTouchItemsStartWorldPos[PointerIndex + 1]
    local PointLocalPos = UE4.USlateBlueprintLibrary.AbsoluteToLocal(InGeometry, PointWorldPos)
    local StartTouchLocalPos = UE4.USlateBlueprintLibrary.AbsoluteToLocal(InGeometry, StartTouchWorldPos)
    local ChangeLocalDis = PointLocalPos - StartTouchLocalPos
    local FinalLocalPos = self.WidgetStartLocalPos + ChangeLocalDis
    local LimitRangeInfo = self.LimitRangeParam[self.SubTouchItems[PointerIndex + 1]]
    if (LimitRangeInfo and LimitRangeInfo.Type == "Circle") then
        local TwoPointDistance = UE4.UKismetMathLibrary.Distance2D(FinalLocalPos, self.WidgetStartLocalPos)
        if (TwoPointDistance > LimitRangeInfo["Param"].Radius) then
            local k = ChangeLocalDis.Y / ChangeLocalDis.X
            local x, y = 0, 0
            if (ChangeLocalDis.X < 0) then
                -- 左方移动
                x = -LimitRangeInfo["Param"].Radius / math.sqrt(1 + k * k) + self.WidgetStartLocalPos.X
                y = -k * LimitRangeInfo["Param"].Radius / math.sqrt(1 + k * k) + self.WidgetStartLocalPos.Y
            else
                -- 右方移动
                x = LimitRangeInfo["Param"].Radius / math.sqrt(1 + k * k) + self.WidgetStartLocalPos.X
                y = k * LimitRangeInfo["Param"].Radius / math.sqrt(1 + k * k) + self.WidgetStartLocalPos.Y
            end
            FinalLocalPos.X = self.WidgetStartLocalPos.X + x
            FinalLocalPos.Y = self.WidgetStartLocalPos.Y + y
        end 
    end
    return FinalLocalPos
end

--抬起时限制拖动范围
function CommonTouchComponent:LimitRange(PointerIndex)
    local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.SubTouchItems[PointerIndex + 1])
    if (CanvasSlot == nil) then
        return
    end
    self.WidgetCurLocalPos = CanvasSlot:GetPosition()
    local LimitRangeInfo = self.LimitRangeParam[self.SubTouchItems[PointerIndex + 1]]
    if (LimitRangeInfo ~= nil) then
        --限制范围
        local UpLimitParam = LimitRangeInfo.UpLimitParam
        if (UpLimitParam ~= nil) then
            local IsNeedRebackX = false
            if (self.WidgetCurLocalPos.X + CanvasSlot:GetSize().X < UpLimitParam.LeftMoveLen) then
                self.m_SavePrePos.X = self.WidgetCurLocalPos.X
                self.m_SaveTarPos.X = -CanvasSlot:GetSize().X + UpLimitParam.LeftMoveLen
                IsNeedRebackX = true
            elseif (self.WidgetCurLocalPos.X + CanvasSlot:GetSize().X > UpLimitParam.RightMoveLen) then
                self.m_SavePrePos.X = self.WidgetCurLocalPos.X
                self.m_SaveTarPos.X = -CanvasSlot:GetSize().X + UpLimitParam.RightMoveLen
                IsNeedRebackX = true
            end
            if (self.m_UpdateTimerFlag_X == true and IsNeedRebackX) then
                self.m_UpdateTimerFlag_X = false
                self.TimerHandle_X = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.OnUpdateEdgeLerpTimer_X}, 0.02, true)
            end

            local IsNeedRebackY = false
            if (self.WidgetCurLocalPos.Y + CanvasSlot:GetSize().Y < UpLimitParam.DownMoveLen) then
                self.m_SavePrePos.Y = self.WidgetCurLocalPos.Y
                self.m_SaveTarPos.Y = -CanvasSlot:GetSize().Y + UpLimitParam.DownMoveLen
                IsNeedRebackY = true
            elseif (self.WidgetCurLocalPos.Y + CanvasSlot:GetSize().Y > UpLimitParam.UpMoveLen) then
                self.m_SavePrePos.Y = self.WidgetCurLocalPos.Y
                self.m_SaveTarPos.Y = -CanvasSlot:GetSize().Y + UpLimitParam.UpMoveLen
                IsNeedRebackY = true
            end
            if (self.m_UpdateTimerFlag_Y and IsNeedRebackY) == true then
                self.m_UpdateTimerFlag_Y = false
                self.TimerHandle_Y = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.OnUpdateEdgeLerpTimer_Y}, 0.02, true)
            end
            CanvasSlot:SetPosition(self.WidgetCurLocalPos)
        else
            local viewport_geometry = UE4.UWidgetLayoutLibrary.GetViewportWidgetGeometry(self:GetOwningPlayer())
            local viewportlocalsize = UE4.USlateBlueprintLibrary.GetLocalSize(viewport_geometry)
            if (self.WidgetCurLocalPos.X + CanvasSlot:GetSize().X < viewportlocalsize.X / 2 ) then
                self.m_SavePrePos.X = self.WidgetCurLocalPos.X
                self.m_SaveTarPos.X = -CanvasSlot:GetSize().X + viewportlocalsize.X / 2 
                if self.m_UpdateTimerFlag_X == true then
                    self.m_UpdateTimerFlag_X = false
                    self.TimerHandle_X = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.OnUpdateEdgeLerpTimer_X}, 0.02, true)
                end
            end
            if (self.WidgetCurLocalPos.Y + CanvasSlot:GetSize().Y < 0) then
                self.m_SavePrePos.Y = self.WidgetCurLocalPos.Y
                self.m_SaveTarPos.Y = -CanvasSlot:GetSize().Y
                if self.m_UpdateTimerFlag_Y == true then
                    self.m_UpdateTimerFlag_Y = false
                    self.TimerHandle_Y = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.OnUpdateEdgeLerpTimer_Y}, 0.02, true)
                end
            end
            CanvasSlot:SetPosition(self.WidgetCurLocalPos)
        end
    end
end

--X方向的拖拽回弹
function CommonTouchComponent:OnUpdateEdgeLerpTimer_X()
    self.Updatetime_X = self.Updatetime_X + 0.1
    self.WidgetCurLocalPos.X = UE4.UKismetMathLibrary.Lerp(self.m_SavePrePos.X, self.m_SaveTarPos.X, self.Updatetime_X)
    -- self:UpdateEdgeLerp()
    if (self.Updatetime_X > 1) then --超时,关闭定时器
        self.Updatetime_X = 0
        self.m_UpdateTimerFlag_X = true
        UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.TimerHandle_X)
    end
end

--Y方向的拖拽回弹
function CommonTouchComponent:OnUpdateEdgeLerpTimer_Y()
    self.Updatetime_Y = self.Updatetime_Y + 0.1
    self.WidgetCurLocalPos.Y = UE4.UKismetMathLibrary.Lerp(self.m_SavePrePos.Y, self.m_SaveTarPos.Y, self.Updatetime_Y)
    -- self:UpdateEdgeLerp()
    if (self.Updatetime_Y > 1) then
        self.Updatetime_Y = 0
        self.m_UpdateTimerFlag_X = true
        UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.TimerHandle_Y)
    end
end

--更新回弹的位置
-- function CommonTouchComponent:UpdateEdgeLerp(PointerIndex)
--     local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.SubTouchItems[PointerIndex + 1])
--     CanvasSlot:SetPosition(FVector2D(self.WidgetCurLocalPos.X, self.WidgetCurLocalPos.Y))
-- end

function CommonTouchComponent:OnUpdatePosFlag(PointerIndex)
    -- 处理实际的控件移动结束之后
    local SubTouchItem = self.SubTouchItems[PointerIndex + 1]
    local LimitRangeInfo = self.LimitRangeParam[SubTouchItem]
    if (LimitRangeInfo and LimitRangeInfo.TouchTimes == -1) then
        self.UpdatePosFlag[self.SubTouchItemsName[PointerIndex + 1]] = true
    end
    if (LimitRangeInfo and LimitRangeInfo.NeedResetPos) then
        local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(SubTouchItem)
        if (CanvasSlot ~= nil) then
            CanvasSlot:SetPosition(self.WidgetStartLocalPos)
        end
    end
    self:AfterTouchItemMove(PointerIndex)
    UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.UpdatePosTimerHandle)
end

function CommonTouchComponent:AfterTouchItemMove(PointerIndex)
    self.SubTouchItems[PointerIndex + 1] = nil
    self.SubTouchParentWidget[PointerIndex + 1] = nil
    self.SubTouchItemsName[PointerIndex + 1] = nil
    self.SubTouchItemsStartWorldPos[PointerIndex + 1] = nil 
    self.m_LastWorldPosTable[PointerIndex + 1] = nil
    self.CurrentTouchingGeometry[PointerIndex + 1] = nil
    self.CurrentTouchingGestureEvent[PointerIndex + 1] = nil
end

return CommonTouchComponent

--
-- DESCRIPTION
-- 可拖拽的 Widget 组件
-- @AUTHOR HY

local M = {}

-------------------------------------------外部接口--------------------------------------

--- 初始化可拖拽组件信息
---@param OwnerWidget UUserWidget 所属的用户界面 UserWidget
---@param WidgetInfo table 组件信息
function M:InitAllDraggableWidgetInfo(OwnerWidget, WidgetInfo)
    local ParentLayoutNode = OwnerWidget[WidgetInfo.ParentNodeName]
    local DraggableWidget = OwnerWidget[WidgetInfo.WidgetName]
    self:RegisterDraggableComponent(OwnerWidget, DraggableWidget, ParentLayoutNode, WidgetInfo)
end

--- 离开设计态
function M:LeaveDesignState()
    self:UnSelectWidget()
    self:UnRegisterDraggableComponent()
end

-- 选中组件
function M:SelectWidget()
    local TargetMaskWidget = self:GetSelectWidgetMaskWidget()
    if (TargetMaskWidget ~= nil) then
        TargetMaskWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end

    if (self.RelativeNodeName) then
        -- 更新并显示出关联节点
        self:UpdateRelativeNodeWhenSelected()
    end
    -- 通知所属UserWidget选中的Widget发生了更新
    if (self.OwnerWidget and type(self.OwnerWidget.OnDraggableWidgetSelected) == "function") then
        self.OwnerWidget:OnDraggableWidgetSelected(self)
    end
end

-- 取消选中组件
function M:UnSelectWidget()
    local TargetMaskWidget = self:GetSelectWidgetMaskWidget()
    if (TargetMaskWidget ~= nil) then
        TargetMaskWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    if (self.RelativeNodeName) then
        -- 隐藏关联节点
        self:HideRelativeNodeWhenUnSelected(true)
    end
end

-- 获取当前选中拖拽组件的遮罩节点
function M:GetSelectWidgetMaskWidget()
    local TargetMaskWidget = nil
    if (type(self.MaskNodeName) == "table") then
        local TargetMaskWidgetName = self.MaskNodeName[self.CurEditPlanIndex]
        if (TargetMaskWidgetName ~= nil) then
            TargetMaskWidget = self.OwnerWidget[TargetMaskWidgetName]
        end
    else
        TargetMaskWidget = self.OwnerWidget[self.MaskNodeName]
    end
    return TargetMaskWidget
end

-- 获取当前节点的文本映射信息
function M:GetSelectWidgetTextMapContent()
    return self.TextMapContent
end

-- 进入自定义设计状态
---@param CurEditPlanIndex number 当前编辑的方案索引
function M:EnterDesignState(CurEditPlanIndex)
    self.CurEditPlanIndex = CurEditPlanIndex
end

-- 根据偏移量移动组件位置
---@param Offset FVector2D 移动的偏移量
function M:MoveWidgetByOffset(Offset)
    if not IsValid(self.DraggableWidget) then
        return
    end
    local CurParentNodePos = self:GetWidgetPosition()
    local NewPosition = CurParentNodePos + Offset
    self:SetWidgetPosition(NewPosition)
    
    -- 通知所属UserWidget有位置发生了更新
    if (self.OwnerWidget and type(self.OwnerWidget.OnDraggableWidgetInfoChanged) == "function") then
        self.OwnerWidget:OnDraggableWidgetInfoChanged("Pos", self, NewPosition)
    end
end

-- 修改组件缩放比例
---@param ScaleValue number 缩放比例值
function M:ModifyWidgetScale(ScaleValue)
    local WidgetNode = self.ParentLayoutNode or self.DraggableWidget
    if not IsValid(WidgetNode) then
        DebugPrint("DraggableWidgetComponent== Error: ModifyWidgetScale failed, ParentLayoutNode is invalid!")
        return
    end
    WidgetNode:SetRenderScale(FVector2D(ScaleValue, ScaleValue))
    self:AdjustPositionByScaleValueChange(WidgetNode)

    -- 通知所属UserWidget有缩放发生了更新
    if (self.OwnerWidget and type(self.OwnerWidget.OnDraggableWidgetInfoChanged) == "function") then
        self.OwnerWidget:OnDraggableWidgetInfoChanged("Scale", self, ScaleValue)
    end
end

-------------------------------------------内部接口--------------------------------------

-- 注册组件函数
---@param OwnerWidget UUserWidget 所属的用户界面 UserWidget
---@param DraggableWidget UWidget 可拖拽的 Widget
---@param ParentLayoutNode UWidget 父布局节点
---@param WidgetInfo table 组件信息
function M:RegisterDraggableComponent(OwnerWidget, DraggableWidget, ParentLayoutNode, WidgetInfo)
    self.OwnerWidget = OwnerWidget
    self.DraggableWidget = DraggableWidget
    self.ParentLayoutNode = ParentLayoutNode
    self.WidgetNodeName = WidgetInfo.WidgetName
    self.TextMapContent = WidgetInfo.TextMapContent
    self.InnerActiveSlateName = WidgetInfo.InnerActiveSlateName
    self.MaskNodeName = WidgetInfo.MaskNodeName
    self.bHasExtraLimitArea = WidgetInfo.bHasExtraLimitArea
    self.bIsNeedManualAdd = WidgetInfo.bIsNeedManualAdd
    self.RelativeNodeName = WidgetInfo.RelativeNodeName
    self.bIsDragging = false                                    -- 是否正在拖拽
    self.StartPosition = FVector2D(0, 0)                        -- 开始拖拽时的位置
    self.CurrentPositionInScreen = FVector2D(0, 0)              -- 当前触控点在屏幕上的位置
    self.DragOffset = FVector2D(0, 0)                           -- 当前拖拽的偏移量
    self.TouchPointLocalOffset = nil                            -- 触控点相对Widget的偏移量
    self.LimitDraggableArea = nil                               -- 可拖拽的范围

    self:InitializeVariable()
end

-- 销毁组件函数
function M:UnRegisterDraggableComponent()
    self:SetDraggable(false)
    DebugPrint("DraggableWidgetComponent== DraggableWidget destroyed")
end

-- 初始化函数
function M:InitializeVariable()
    if not self.DraggableWidget then
        self.DraggableWidget = self
    end

    -- 启用交互
    self:SetDraggable(true)

    DebugPrint("DraggableWidgetComponent== Initialized Successfully!")
end

-- 设置是否可拖拽
---@param bEnabled boolean 是否启用拖拽
function M:SetDraggable(bEnabled)
    if IsValid(self.DraggableWidget) then
        if (bEnabled) then
            self.DraggableWidget:SetVisibility(UE4.ESlateVisibility.Visible)
        else
            self.DraggableWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    end
    if (type(self.InnerActiveSlateName) == "table") then
        -- 支持多层级查找
        for index, WidgetName in ipairs(self.InnerActiveSlateName) do
            local FindWidget = nil
            if (type(WidgetName) == "table") then
                local PathLength = #WidgetName
                FindWidget = self.DraggableWidget[WidgetName[1]]
                for i=2, PathLength do
                    FindWidget = FindWidget[WidgetName[i]]
                end 
            else
                FindWidget = self.DraggableWidget[WidgetName]
            end
            if (FindWidget ~= nil and IsValid(FindWidget)) then
                if (bEnabled) then
                    FindWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                else
                    FindWidget:SetVisibility(UE4.ESlateVisibility.Visible)
                end
            end
        end
    else
        local TargetWidget = self.DraggableWidget[self.InnerActiveSlateName]
        if IsValid(TargetWidget) then
            if (bEnabled) then
                TargetWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            else
                TargetWidget:SetVisibility(UE4.ESlateVisibility.Visible)
            end
        end
    end
    self.bDraggable = bEnabled
end

-- 通知可外显节点状态发生变化
function M:SetManualAddInSetting(bAddInSetting)
    -- 预留接口，暂时不需要做什么
end

--- 按下事件
function M:OnTouchStarted(MyGeometry, InGestureEvent)
    if not self.bDraggable then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    self.bIsDragging = true
    self:SelectWidget()

    local ScreenSpacePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InGestureEvent)

    self.StartPosition = ScreenSpacePosition

    -- local RenderLocalScale = self.ParentLayoutNode and self.ParentLayoutNode.RenderTransform.Scale.X or 1.0
    local LayoutWidgetGeometry = self.ParentLayoutNode:GetCachedGeometry()
    self.TouchPointLocalOffset = UE4.USlateBlueprintLibrary.AbsoluteToLocal(LayoutWidgetGeometry, ScreenSpacePosition)
    -- 设置可拖拽区域限制
    self:SetDraggableArea(LayoutWidgetGeometry)

    DebugPrint("DraggableWidgetComponent== Start dragging, Position in Screen Space is :", ScreenSpacePosition, ", TouchPoint LocalOffset is :", self.TouchPointLocalOffset)
    local Handled = UE4.UWidgetBlueprintLibrary.Handled()
    return UE4.UWidgetBlueprintLibrary.CaptureMouse(Handled, self.DraggableWidget)
end

-- 移动事件
function M:OnTouchMoved(MyGeometry, InGestureEvent)
    if not self.bIsDragging then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    
    -- 获取鼠标在屏幕上的绝对位置
    local ScreenSpacePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InGestureEvent)

    -- 限制位置在视口范围内
    ScreenSpacePosition = self:ClampPositionToViewport(ScreenSpacePosition)

    -- 计算新的Widget位置（鼠标位置减去偏移量）
    local FinalPosition = UIUtils.GetRelativePositionInParent(self.ParentLayoutNode, ScreenSpacePosition, self.TouchPointLocalOffset)
    -- local FinalPosition = UIUtils.ConvertScreenToChildLocalPosition(self, self.ParentLayoutNode, ScreenSpacePosition, self.TouchPointLocalOffset)
    
    -- 更新 Widget 位置
    self.DragOffset = ScreenSpacePosition - self.StartPosition
    self.CurrentPositionInScreen = ScreenSpacePosition
    self:SetWidgetPosition(FinalPosition)
    
    -- 通知所属UserWidget有位置发生了更新
    if (self.OwnerWidget and type(self.OwnerWidget.OnDraggableWidgetInfoChanged) == "function") then
        self.OwnerWidget:OnDraggableWidgetInfoChanged("Pos", self, FinalPosition)
    end
    DebugPrint("DraggableWidgetComponent== Dragging OnTouchMoved to:  ", FinalPosition)
    return UIUtils.Handled
end

-- 释放事件
function M:OnTouchEnded(MyGeometry, MouseEvent)
    if not self.bDraggable then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    self.bIsDragging = false
    self.DragOffset = FVector2D(0, 0)
    self.TouchPointLocalOffset = nil
    DebugPrint("DraggableWidgetComponent== Stop dragging")
    -- 释放鼠标捕获
    if (self.DraggableWidget:HasMouseCapture()) then
        local Handled = UE4.UWidgetBlueprintLibrary.Handled()
        return UE4.UWidgetBlueprintLibrary.ReleaseMouseCapture(Handled)
    else
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
end

-- 设置Widget位置
function M:SetWidgetPosition(Position)
    if self.ParentLayoutNode then
        local Slot = self.ParentLayoutNode.Slot
        if Slot then
            Slot:SetPosition(Position) 
        else
            -- 如果直接设置 Slot 失败，尝试使用 Anchors
            self.DraggableWidget:SetPositionInViewport(Position)
        end
    else
        self.DraggableWidget:SetPositionInViewport(Position)
    end
end

-- 获取Widget位置
function M:GetWidgetPosition()
    if self.ParentLayoutNode then
        local Slot = self.ParentLayoutNode.Slot
        if Slot then
            return Slot:GetPosition()
        else
            return FVector2D(0, 0)
        end
    else
        return FVector2D(0, 0)
    end
end

-- 将位置限制在视口范围内
function M:ClampPositionToViewport(Position)
    if (self.LimitDraggableArea == nil) then
        return Position
    end

    local StartClampedX = self.LimitDraggableArea.MinX
    local EndClampedX = self.LimitDraggableArea.MaxX
    local StartClampedY = self.LimitDraggableArea.MinY
    local EndClampedY = self.LimitDraggableArea.MaxY

    local ClampedX = UE.UKismetMathLibrary.FClamp(Position.X, StartClampedX, EndClampedX)
    local ClampedY = UE.UKismetMathLibrary.FClamp(Position.Y, StartClampedY, EndClampedY)

    return FVector2D(ClampedX, ClampedY)
end

-- 设置当前可以拖拽的范围
function M:SetDraggableArea(DraggableWidgetGeometry)
    -- 如果有安全区，则用安全区的大小
    local ParentGeometry = nil
    if (self.OwnerWidget.SafeZone) then
        local SafeZoneChildContent = self.OwnerWidget.SafeZone:GetContent()
        if (SafeZoneChildContent) then
            ParentGeometry = SafeZoneChildContent:GetCachedGeometry()
        else
            ParentGeometry = self.OwnerWidget:GetCachedGeometry()
        end
    else
        ParentGeometry = self.OwnerWidget:GetCachedGeometry()
    end

    if (ParentGeometry == nil) then
        self.LimitDraggableArea = nil
        return
    end

    local AbsoluteTopLeftPosition = UE4.USlateBlueprintLibrary.LocalToAbsolute(self.OwnerWidget:GetCachedGeometry(), UE4.USlateBlueprintLibrary.GetLocalTopLeft(ParentGeometry))
    local AbsoluteParentSize = UE4.USlateBlueprintLibrary.GetAbsoluteSize(ParentGeometry)

    -- local RenderLocalScale = self.ParentLayoutNode and self.ParentLayoutNode.RenderTransform.Scale.X or 1.0
    local WidgetAbsoluteSize = UE4.USlateBlueprintLibrary.GetAbsoluteSize(DraggableWidgetGeometry)
    local WidgetLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(DraggableWidgetGeometry)

    local StartClampedX = AbsoluteTopLeftPosition.X + WidgetAbsoluteSize.X * (self.TouchPointLocalOffset.X / WidgetLocalSize.X)
    local EndClampedX = AbsoluteTopLeftPosition.X + AbsoluteParentSize.X - WidgetAbsoluteSize.X * (1 - self.TouchPointLocalOffset.X / WidgetLocalSize.X)

    local StartClampedY = AbsoluteTopLeftPosition.Y + WidgetAbsoluteSize.Y * (self.TouchPointLocalOffset.Y / WidgetLocalSize.Y)
    local EndClampedY = AbsoluteTopLeftPosition.Y + AbsoluteParentSize.Y - WidgetAbsoluteSize.Y * (1 - self.TouchPointLocalOffset.Y / WidgetLocalSize.Y)

    -- 如果有额外的限制区域，可以在这里进行进一步的限制
    if (self.bHasExtraLimitArea) then
        self:UpdateLimitDraggableAreaFromDesign(StartClampedX, EndClampedX, StartClampedY, EndClampedY, AbsoluteParentSize)
    else
        self.LimitDraggableArea = {
            MinX = StartClampedX,
            MaxX = EndClampedX,
            MinY = StartClampedY,
            MaxY = EndClampedY,
        } 
    end
end

-- 根据设计态信息更新可拖拽范围（目前主要给摇杆那边用）
---@param StartClampedX number 可拖拽区域起始X位置
---@param EndClampedX number 可拖拽区域结束X位置
---@param StartClampedY number 可拖拽区域起始Y位置
---@param EndClampedY number 可拖拽区域结束Y位置
---@param AbsoluteParentSize FVector2D 父节点(布局控件)绝对大小
function M:UpdateLimitDraggableAreaFromDesign(StartClampedX, EndClampedX, StartClampedY, EndClampedY, AbsoluteParentSize)
    if (self.WidgetNodeName == "Move") then
        -- 摇杆有特殊的限制区域
        local CurAreaRangeXPercent = self.CurAreaRangeXPercent
        local CurAreaRangeYPercent = self.CurAreaRangeYPercent

        local NewEndClampedX = EndClampedX - AbsoluteParentSize.X * CurAreaRangeXPercent
        local NewStartClampedY = StartClampedY + AbsoluteParentSize.Y * (1.0 - CurAreaRangeYPercent)

        self.LimitDraggableArea = {
            MinX = StartClampedX,
            MaxX = NewEndClampedX,
            MinY = NewStartClampedY,
            MaxY = EndClampedY,
        } 
    else
        -- 其他组件使用默认限制区域
        self.LimitDraggableArea = {
            MinX = StartClampedX,
            MaxX = EndClampedX,
            MinY = StartClampedY,
            MaxY = EndClampedY,
        } 
    end
end

-- 根据缩放变化调整选中组件位置(避免缩放后位置出现在安全区外面)
---@param AdjustWidget UWidget 需要调整位置的 Widget
function M:AdjustPositionByScaleValueChange(AdjustWidget)
    -- 每次缩放需要重新计算可拖拽区域
    local DraggableWidgetGeometry = AdjustWidget:GetCachedGeometry()
    local AdjustWidgetAbsolutePos = UIManager(self.OwnerWidget):GetWorldPosition(AdjustWidget)
    local AdjustWidgetAbsoluteSize = UE4.USlateBlueprintLibrary.GetAbsoluteSize(DraggableWidgetGeometry)
    local AdjustWidgetAbsoluteCenterPos = FVector2D(
        AdjustWidgetAbsolutePos.X + AdjustWidgetAbsoluteSize.X / 2,
        AdjustWidgetAbsolutePos.Y + AdjustWidgetAbsoluteSize.Y / 2
    )
    -- 默认触控点在Widget中心位置
    local AdjustWidgetLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(DraggableWidgetGeometry)
    self.TouchPointLocalOffset = FVector2D(AdjustWidgetLocalSize.X / 2, AdjustWidgetLocalSize.Y / 2)
    self:SetDraggableArea(DraggableWidgetGeometry)

    -- 计算调整后的位置
    local FinalAbsolutePosition = self:ClampPositionToViewport(AdjustWidgetAbsoluteCenterPos)
    local FinalPosition = UIUtils.GetRelativePositionInParent(AdjustWidget, FinalAbsolutePosition, self.TouchPointLocalOffset)
    self:SetWidgetPosition(FinalPosition)
end

-- 根据相关节点变化调整选中组件位置（目前主要给摇杆那边用）
---@param AdjustWidget UWidget 需要调整位置的 Widget
function M:AdjustPositioByRelativeWidgetChange(AdjustWidget)
    self:AdjustPositionByScaleValueChange(AdjustWidget)
end

-- 获取当前是否正在拖拽
function M:IsDragging()
    return self.bIsDragging
end

return M
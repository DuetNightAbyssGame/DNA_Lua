local Component = {}

function Component:CreateDragUI(DisPlayItemId, ShapeOffsets, SyncData)
    local DragUI = UIManager(self):_CreateWidgetNew("BagGameDragUIItem")
    DragUI:InitAsDragUI(DisPlayItemId, ShapeOffsets, SyncData)
    return DragUI
end

function Component:InitAsDragUI(DisPlayItemId, ShapeOffsets, SyncData)
    self.LinkWidgets = {}
    self.ActiveLinkWidgets = {}

    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.DisPlayItemId = DisPlayItemId
    self.TemplateId = SyncData and SyncData.TemplateId or DisPlayItemId
    self.DragSyncData = SyncData
    
    if self.SetShape and ShapeOffsets then
        self:SetShape(ShapeOffsets)
    end

    if self.ApplyDragSyncData and SyncData then
        self:ApplyDragSyncData(SyncData)
    end
    
    self:PlayAnimation(self.Size_In)
end

function Component:SetCallbacks(Callbacks)
    self.OnDragCancelCallback = Callbacks.OnDragCancelCallback
    self.OnDropCallback = Callbacks.OnDropCallback
    self.OnDragEnterCallback = Callbacks.OnDragEnterCallback
    self.OnDragLeaveCallback = Callbacks.OnDragLeaveCallback
    self.OnDragDetectedCallback = Callbacks.OnDragDetectedCallback
    self.OnRemovedFromFocusPathCallback = Callbacks.OnRemovedFromFocusPathCallback
end

function Component:OnDragDetectedComponent(MyGeometry, PointerEvent,DisPlayItemId,ShapeOffsets)
    -- 创建拖拽操作对象
    local DragDropOperation = NewObject(UIUtils.GetCommonDragDropOperationClass())
    -- 传入形状数据
    local SyncData = nil
    if self.GetDragSyncData then
        SyncData = self:GetDragSyncData()
    end
    local DragUI = self:CreateDragUI(DisPlayItemId, ShapeOffsets, SyncData)
    -- 按形状更新 DragUI 的尺寸
    if DragUI and DragUI.SetItemSize then
        DragUI:SetItemSize()
    end
    -- 配置拖拽属性
    DragDropOperation.DefaultDragVisual = DragUI  -- 拖拽时显示的UI
    DragDropOperation.Pivot = UE.EDragPivot.CenterCenter  -- 中心为锚点
    DragDropOperation.InSlotUIData = self.SlotUIData  -- 源槽位数据
    DragDropOperation.Tag = "BagGameDisPlayItem"  -- 标签，用于类型识别
    DragDropOperation.SourceDisPlayItem = self  -- 源 DisPlayItem 引用
    
    -- 回调
    if self.OnDragDetectedCallback then
        self.OnDragDetectedCallback(self, PointerEvent, DragDropOperation)
    end
    
    return DragDropOperation  -- 返回拖拽操作对象
end

function Component:OnDragEnter(MyGeometry, PointerEvent, Operation)
    if Operation.Tag ~= "BagGameDisPlayItem" then
        return
    end

    if self.OnDragEnterCallback then
        self.OnDragEnterCallback(self, PointerEvent, Operation)
    end
end

function Component:OnDragLeave(PointerEvent, Operation)
    if Operation.Tag ~= "BagGameDisPlayItem" then
        return
    end

    if self.OnDragLeaveCallback then
        self.OnDragLeaveCallback(self, PointerEvent, Operation)
    end
end

function Component:OnDragCancelled(PointerEvent, Operation)
    if Operation.Tag ~= "BagGameDisPlayItem" then
        return
    end
    
    if self.OnDragCancelCallback then
        self.OnDragCancelCallback(self, PointerEvent, Operation)
    end
    
end

function Component:OnDrop(MyGeometry, PointerEvent, Operation)
    if Operation.Tag ~= "BagGameDisPlayItem" then
        return
    end

    -- 已确认放置的物品（SelfHitTestInvisible）的子控件会拦截 drop 事件，
    -- 阻止底层 ContainItem 接收。此处将 drop 委托给 PlayScreen 处理子弹装配/堆叠。
    if self.bIsConfirmed and self.PlayScreen and self.PlayScreen.PlaceItemAtCell then
        local DragUI = Operation.DefaultDragVisual
        if DragUI then
            local BagGameModel = require "BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel"
            local Record = BagGameModel:FindPlacedItemByWidget(self)
            if Record and Record.Cells and #Record.Cells > 0 then
                -- 使用被覆盖物品的第一个格子作为基准，触发 PlaceItemAtCell 的堆叠/装配重检测
                local Cell = Record.Cells[1]
                local bSuccess = self.PlayScreen:PlaceItemAtCell(Cell.Row, Cell.Col, DragUI, Operation)
                return bSuccess
            end
        end
    end

    if self.OnDropCallback then
        self.OnDropCallback(self, PointerEvent, Operation)
    end

    return true  -- 返回true表示接受放置
end

return Component
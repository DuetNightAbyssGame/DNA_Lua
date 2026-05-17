local Component = {}

local Const = UIConst.GamePadKey
local BagGameModel = require "BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel"
local GRID_ROWS = BagGameModel.GRID_ROWS
local GRID_COLS = BagGameModel.GRID_COLS

-- ==================== 设备监听 ====================

function Component:InitListenEvent()
    local PlayerController = self:GetOwningPlayer()
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    end
end

function Component:RefreshBaseInfo()
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(
            self.GameInputModeSubsystem:GetCurrentInputType(),
            self.GameInputModeSubsystem:GetCurrentGamepadName()
        )
    end
end

function Component:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then return end
    if CurInputDevice == UE4.ECommonInputType.Touch then return end
    self.CurGamepadName = CurGamepadName
    self.CurInputDevice = CurInputDevice
end

function Component:InitGamePadKey()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then return end
    if not self.Tab then return end
    self.Tab:Init({
        DynamicNode = {"Back", "BottomKey"},
        StyleName = "TextImage",
        TitleName = GText("Event_Title_103015"),
        OwnerPanel = self,
        BackCallback = self.CloseSelf,
        BottomKeyInfo = {
            {KeyInfoList = {{Type="Text", Text="Escape", ClickCallback=self.CloseSelf, Owner=self}},
            GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf}},
            Desc = GText("UI_BACK"), bLongPress = false}
        },
    })
    self:_UpdateBottomKeyByState("SCROLL")
end

--- 按手柄状态更新 Tab 底部按键提示
---@param State string "SCROLL" | "MOVING" | "FOCUS"
function Component:_UpdateBottomKeyByState(State)
    if not self.Tab then return end
    local ImgKey = UIConst.GamePadImgKey
    local LKey = {
        GamePadInfoList = {{Type="Img", ImgShortPath=ImgKey.LeftTriggerAnalog, Owner=self}},
        Desc = GText("UI_GameEvent_BagGame_Move"),
    }
    local AKey = {
        GamePadInfoList = {{Type="Img", ImgShortPath=ImgKey.FaceButtonBottom, Owner=self}},
        Desc = GText("UI_GameEvent_BagGame_Select"),
    }
    local LSKey = {
        GamePadInfoList = {{Type="Img", ImgShortPath=ImgKey.LeftThumb, Owner=self}},
        Desc = GText("UI_GameEvent_BagGame_SelectPlaced"),
    }
    local BKey = {
        KeyInfoList = {{Type="Text", Text="Escape", ClickCallback=self.CloseSelf, Owner=self}},
        GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf}},
        Desc = GText("UI_BACK"), bLongPress = false
    }

    local Info
    if State == "SCROLL" then
        Info = {LKey, AKey, LSKey, BKey}
    elseif State == "MOVING" then
        Info = {LKey, BKey}
    elseif State == "FOCUS" then
        Info = {LKey, AKey, BKey}
    else
        return
    end
    self.Tab:UpdateBottomKeyInfo(Info)
end

-- ==================== 初始化 ====================

--- 初始化手柄状态，监听 TileView 选中变化
--- 须在 InitView → InitDisPlayItem 之后调用
function Component:_InitGamepadItemList()
    self._GamepadState = "SCROLL"
    self._GamepadMoveRow = 1
    self._GamepadMoveCol = 1
    self._GamepadMoveValid = true   -- 当前视觉位置是否可确认放置
    self._GamepadLastDoubleReward = nil  -- 上一帧双倍状态，用于检测状态变化
    self._GamepadDragUI = nil
    self._GamepadDragOperation = nil
    self._GamepadDragSourceData = nil  -- 数据对象引用
    self._GamepadPlacedItem = nil
    self._GamepadSelectedContent = nil

    -- FOCUS 态变量
    self._FocusIndex = 1          -- 当前聚焦的已确认物品索引
    -- _ConfirmedPlacedItems 由 Play_C 初始化和维护（通过 ConfirmPlacedItem/UnconfirmPlacedItem）
    if not self._ConfirmedPlacedItems then
        self._ConfirmedPlacedItems = {}
    end

    -- 监听 TileView 选中变化（TileView 原生导航触发）
    if self.EMTileView1 then
        self.EMTileView1.BP_OnItemSelectionChanged:Add(self, self._OnDisPlayItemSelected)
    end

    -- 主动设置初始选中（TileView 初始聚焦可能在绑定监听前触发，或不触发选中事件）
    if self.DisPlayItemDataList and #self.DisPlayItemDataList > 0 then
        self._GamepadSelectedContent = self.DisPlayItemDataList[1]
    end
end

--- TileView 导航选中变化回调
function Component:_OnDisPlayItemSelected(Content, bIsSelected)
    if bIsSelected and Content then
        self._GamepadSelectedContent = Content
    end
end

-- ==================== 状态机主路由 ====================

function Component:HandleGamepadInput(InKeyName)
    -- B 键：MOVING 态回收物品回到 SCROLL；FOCUS 态退出 FOCUS；SCROLL 态退出界面
    if InKeyName == Const.FaceButtonRight then
        local State = self._GamepadState or "SCROLL"
        if State == "MOVING" then
            self:_ExitMovingMode()
        elseif State == "FOCUS" then
            self:_ExitFocusState()
        else
            self:CloseSelf()
        end
        return true
    end

    local State = self._GamepadState or "SCROLL"
    if State == "SCROLL" then
        return self:_HandleScrollInput(InKeyName)
    elseif State == "MOVING" then
        return self:_HandleMovingInput(InKeyName)
    elseif State == "FOCUS" then
        return self:_HandleFocusInput(InKeyName)
    end
    return false
end

-- ==================== SCROLL 状态 ====================
-- 方向键由 TileView 原生导航处理，此处仅处理 A 键

function Component:_HandleScrollInput(InKeyName)
    if InKeyName == Const.FaceButtonBottom then
        local ContentData = self._GamepadSelectedContent
        if ContentData and ContentData.SwitchIndex ~= 2 then
            self:_EnterMovingMode(ContentData)
        end
        return true
    end
    -- LS 键：进入 FOCUS 态（需要有已确认物品）
    if InKeyName == Const.LeftThumb then
        if self._ConfirmedPlacedItems and #self._ConfirmedPlacedItems > 0 then
            self:_EnterFocusState()
        end
        return true
    end
    return false
end

--- A 键选中道具后进入 MOVING 模式（接收数据对象）
function Component:_EnterMovingMode(ContentData)
    -- 有未确认物品时阻止进入
    if self:HasUnconfirmedItem() then
        self:ShowCannotDragToast()
        return
    end

    -- 直接创建 DragUI（不依赖 Entry Widget，兼容 TileView 回收复用）
    local SyncData = {
        TemplateId = ContentData.TemplateId,
        ItemType = ContentData.ItemType,
        GUIPath = ContentData.GUIPath,
        CurrentAmmo = ContentData.CurrentAmmo or 0,
        MaxAmmo = ContentData.MaxAmmo or 0,
        CurrentStack = ContentData.CurrentStack or 0,
        MaxStack = ContentData.MaxStack or 0,
    }
    local DragUI = UIManager(self):_CreateWidgetNew("BagGameDragUIItem")
    DragUI:InitAsDragUI(ContentData.DisPlayItemId or ContentData.TemplateId,
                        ContentData.ShapeOffsets, SyncData)

    -- 构造伪 Operation
    local Operation = {
        Tag = "BagGameDisPlayItem",
        DefaultDragVisual = DragUI,
        SourceDisPlayItemId = ContentData.DisPlayItemId or ContentData.TemplateId,
    }

    -- 更新数据对象状态（数据驱动 + 刷新可见 Widget）
    self:SetDisPlayItemSwitchIndex(ContentData.DisPlayItemId, 1)

    -- 保存状态变量
    self._GamepadMoveRow = 1
    self._GamepadMoveCol = 1
    self._GamepadDragUI = DragUI
    self._GamepadDragOperation = Operation
    self._GamepadDragSourceData = ContentData

    -- 根据形状尺寸计算有效扫描范围（确保 GetShapeCells 产生的所有格子在网格内）
    -- GetShapeCells 以 BaseRow/BaseCol 为中心，向两侧展开形状
    -- 如果从 (1,1) 开始扫描，大型形状的负方向格子会落在网格外（如 row=0）
    -- CanPlaceShapeAt 会跳过越界格子导致放置成功，但后续移动因越界格子而卡死
    local ShapeOff = DragUI.ShapeOffsets or {{0, 0}}
    local sMinR, sMaxR, sMinC, sMaxC = ShapeOff[1][1] or 0, ShapeOff[1][1] or 0, ShapeOff[1][2] or 0, ShapeOff[1][2] or 0
    for _, Off in ipairs(ShapeOff) do
        local R, C = Off[1] or 0, Off[2] or 0
        if R < sMinR then sMinR = R end
        if R > sMaxR then sMaxR = R end
        if C < sMinC then sMinC = C end
        if C > sMaxC then sMaxC = C end
    end
    local ShapeRows = math.max(1, sMaxR - sMinR + 1)
    local ShapeCols = math.max(1, sMaxC - sMinC + 1)
    local CtrRowOff = sMinR + math.floor((ShapeRows - 1) / 2)
    local CtrColOff = sMinC + math.floor((ShapeCols - 1) / 2)
    local scanRowStart = math.max(1, 1 + CtrRowOff - sMinR)
    local scanRowEnd   = math.min(GRID_ROWS, GRID_ROWS + CtrRowOff - sMaxR)
    local scanColStart = math.max(1, 1 + CtrColOff - sMinC)
    local scanColEnd   = math.min(GRID_COLS, GRID_COLS + CtrColOff - sMaxC)
    self._GamepadScanRowRange = {scanRowStart, scanRowEnd}
    self._GamepadScanColRange = {scanColStart, scanColEnd}

    -- 从有效范围内逐行逐列扫描，找第一个可放置的位置（左→右，上→下）
    local bSuccess = false
    local PlacedRow, PlacedCol = scanRowStart, scanColStart
    for row = scanRowStart, scanRowEnd do
        if bSuccess then break end
        for col = scanColStart, scanColEnd do
            self:ActivateShapeArea(row, col, DragUI)
            bSuccess = self:PlaceItemAtCell(row, col, DragUI, Operation)
            if bSuccess then
                PlacedRow, PlacedCol = row, col
                break
            end
        end
    end

    if bSuccess then
        -- 放置成功，进入 MOVING 已挂载子模式
        self._GamepadMoveRow = PlacedRow
        self._GamepadMoveCol = PlacedCol
        self._GamepadMoveValid = true
        self._GamepadPlacedItem = self.CurrentUnconfirmedItem
        self._GamepadDragUI = nil
        self._GamepadDragOperation = nil
        self._GamepadState = "MOVING"
        self:_UpdateBottomKeyByState("MOVING")

        -- 记录初始视觉格子（PlaceItemNormal 已播放 Put_Normal/Put_GetPoint）
        local InitialRecord = self.PlacedItems and self.PlacedItems[#self.PlacedItems]
        if InitialRecord and InitialRecord.Cells then
            self._GamepadVisualCells = InitialRecord.Cells
            self._GamepadLastDoubleReward = InitialRecord.IsDoubleReward
        end
    else
        -- 所有位置均无法放置，回退到 MOVING 让玩家手动选位置
        self._GamepadMoveRow = scanRowStart
        self._GamepadMoveCol = scanColStart
        self:ActivateShapeArea(scanRowStart, scanColStart, DragUI)
        self:OnDragStateChanged(true)
        self._GamepadState = "MOVING"
        self:_UpdateBottomKeyByState("MOVING")
    end

    -- 将焦点从 TileView 转移到主控件，防止 TileView 拦截方向键输入
    self:SetFocus()
end

-- ==================== MOVING 状态 ====================

--- 连续监听摇杆模拟轴，转换为离散方向事件并路由到状态机
--- SCROLL 态不处理（TileView 原生导航），仅 MOVING 态处理
function Component:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    -- 仅 MOVING 和 FOCUS 态处理模拟轴，SCROLL 态交给 TileView 原生导航
    local State = self._GamepadState or "SCROLL"
    if State ~= "MOVING" and State ~= "FOCUS" then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end

    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if InKeyName == "Gamepad_LeftX" then
        self._AnalogX = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    elseif InKeyName == "Gamepad_LeftY" then
        self._AnalogY = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    end

    -- 将模拟值转换为离散方向（阈值 0.5，Y 轴优先）
    local DirectionKey = nil
    local ay = self._AnalogY or 0
    local ax = self._AnalogX or 0

    if ay > 0.5 then
        DirectionKey = "Gamepad_LeftStick_Up"
    elseif ay < -0.5 then
        DirectionKey = "Gamepad_LeftStick_Down"
    elseif ax > 0.5 then
        DirectionKey = "Gamepad_LeftStick_Right"
    elseif ax < -0.5 then
        DirectionKey = "Gamepad_LeftStick_Left"
    end

    if DirectionKey then
        -- CD 节流，防止移动过快
        if self._AnalogCdTimer then
            return UE4.UWidgetBlueprintLibrary.Unhandled()
        end
        self:_StartAnalogCdTimer()
        self:HandleGamepadInput(DirectionKey)
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function Component:_StartAnalogCdTimer()
    self._AnalogCdTimer = self:AddTimer(0.15, function()
        self._AnalogCdTimer = nil
    end, nil, nil, nil, true)
end

function Component:_HandleMovingInput(InKeyName)
    local bItemPlaced = (self._GamepadPlacedItem ~= nil)

    -- 左摇杆 / DPad 方向（摇杆为连续输入经 OnAnalogValueChanged 节流，DPad 为离散输入）
    local dRow, dCol = 0, 0
    if InKeyName == Const.LeftStickUp or InKeyName == Const.DPadUp then
        dRow = -1
    elseif InKeyName == Const.LeftStickDown or InKeyName == Const.DPadDown then
        dRow = 1
    elseif InKeyName == Const.LeftStickLeft or InKeyName == Const.DPadLeft then
        dCol = -1
    elseif InKeyName == Const.LeftStickRight or InKeyName == Const.DPadRight then
        dCol = 1
    end

    if dRow ~= 0 or dCol ~= 0 then
        if bItemPlaced then
            -- 道具已挂载：移动已放置道具（取消旧位置，挂到新位置）
            self:_MovePlacedItemByDelta(dRow, dCol)
        else
            -- 放置失败回退：仅移动格子高亮（限制在有效扫描范围内）
            local minRow = self._GamepadScanRowRange and self._GamepadScanRowRange[1] or 1
            local maxRow = self._GamepadScanRowRange and self._GamepadScanRowRange[2] or GRID_ROWS
            local minCol = self._GamepadScanColRange and self._GamepadScanColRange[1] or 1
            local maxCol = self._GamepadScanColRange and self._GamepadScanColRange[2] or GRID_COLS
            local newRow = math.max(minRow, math.min(maxRow, self._GamepadMoveRow + dRow))
            local newCol = math.max(minCol, math.min(maxCol, self._GamepadMoveCol + dCol))
            self._GamepadMoveRow, self._GamepadMoveCol = newRow, newCol
            self:ActivateShapeArea(newRow, newCol, self._GamepadDragUI)
        end
        return true
    end

    -- A 键
    if InKeyName == Const.FaceButtonBottom then
        if bItemPlaced then
            -- 当前位置被占用时不允许确认
            if not self._GamepadMoveValid then
                self:ShowCannotDragToast()
                return true
            end
            -- 确认放置，回到 SCROLL
            self._GamepadVisualCells = nil  -- ConfirmPlacedItem 会播放确认动效
            self:ConfirmPlacedItem(self._GamepadPlacedItem)
            self._GamepadPlacedItem = nil
            self._GamepadDragSourceData = nil
            self._GamepadScanRowRange = nil
            self._GamepadScanColRange = nil
            self._GamepadLastDoubleReward = nil
            self._GamepadMoveValid = true
            self._GamepadState = "SCROLL"
            self:_UpdateBottomKeyByState("SCROLL")
            self:_RestoreScrollFocusToFirst()
        else
            -- 尝试放置（回退模式下的原有逻辑）
            local bSuccess = self:PlaceItemAtCell(
                self._GamepadMoveRow,
                self._GamepadMoveCol,
                self._GamepadDragUI,
                self._GamepadDragOperation
            )
            if bSuccess then
                self._GamepadPlacedItem = self.CurrentUnconfirmedItem
                self._GamepadDragUI = nil
                self._GamepadDragOperation = nil
                -- 留在 MOVING（现在有 PlacedItem，进入已挂载子模式）
            end
        end
        return true
    end

    -- LS 按下：取消/回收
    if InKeyName == Const.LeftThumb then
        self:_ExitMovingMode()
        return true
    end

    -- RS 按下：旋转
    if InKeyName == Const.RightThumb then
        if bItemPlaced then
            -- 调用 PlacedItem 自身的旋转方法（内部先更新 ShapeOffsets 再处理格子占用）
            if self._GamepadPlacedItem.OnRotationBtnClicked then
                self._GamepadPlacedItem:OnRotationBtnClicked()
                -- 旋转后同步视觉位置到实际占位位置，并重置合法标记
                local PlacedRecord = self:_GetPlacedRecord(self._GamepadPlacedItem)
                if PlacedRecord then
                    self._GamepadMoveRow = PlacedRecord.BaseRow
                    self._GamepadMoveCol = PlacedRecord.BaseCol
                    self._GamepadMoveValid = true
                    -- RotatePlacedItem 已处理占位格子的动效（entering/leaving）
                    -- 只需清理与占位不同的视觉格子（如从无效位置旋转时残留的高亮）
                    local OldVisualCells = self._GamepadVisualCells
                    if OldVisualCells then
                        local NewCellSet = {}
                        for _, C in ipairs(PlacedRecord.Cells) do
                            NewCellSet[C.Row * 100 + C.Col] = true
                        end
                        for _, C in ipairs(OldVisualCells) do
                            if not NewCellSet[C.Row * 100 + C.Col] then
                                local ContainItem = self:GetContainItemAt(C.Row, C.Col)
                                if ContainItem and ContainItem.DeactivateHighlight then
                                    ContainItem:DeactivateHighlight()
                                end
                            end
                        end
                    end
                    self._GamepadVisualCells = PlacedRecord.Cells
                    self._GamepadLastDoubleReward = PlacedRecord.IsDoubleReward
                end
            end
        else
            -- 旋转 DragUI（回退模式）
            if self._GamepadDragUI and self._GamepadDragUI.RotateShape90CW then
                self._GamepadDragUI.RotationCount = ((self._GamepadDragUI.RotationCount or 0) + 1) % 4
                self._GamepadDragUI:RotateShape90CW()
                self:ActivateShapeArea(self._GamepadMoveRow, self._GamepadMoveCol, self._GamepadDragUI)
            end
        end
        return true
    end

    return false
end

-- ==================== 移动已放置道具 ====================

--- 将已放置道具沿 (dRow, dCol) 方向移动一格
--- 手柄模式：视觉位置（_GamepadMoveRow/Col）与占位位置（PlacedRecord）分开维护
--- 视觉位置始终跟随移动（只检查边界），占位仅在目标格子合法时才更新
--- 目标格子被占时临时挂载，_GamepadMoveValid=false，阻止 A 键确认
function Component:_MovePlacedItemByDelta(dRow, dCol)
    local PlacedItem = self._GamepadPlacedItem
    if not PlacedItem then return false end

    -- 查找放置记录
    local PlacedRecord = nil
    for _, Record in ipairs(self.PlacedItems) do
        if Record.Widget == PlacedItem then
            PlacedRecord = Record
            break
        end
    end
    if not PlacedRecord then return false end

    -- 从当前视觉位置计算新视觉位置
    local NewBaseRow = self._GamepadMoveRow + dRow
    local NewBaseCol = self._GamepadMoveCol + dCol

    -- 根据 PlacedRecord 推算形状相对偏移（旋转后自动跟随最新 Shape）
    local ShapeOffsets = {}
    for _, Cell in ipairs(PlacedRecord.Cells) do
        table.insert(ShapeOffsets, {
            dRow = Cell.Row - PlacedRecord.BaseRow,
            dCol = Cell.Col - PlacedRecord.BaseCol,
        })
    end

    -- 以新视觉基点计算目标格子，边界检查
    local NewCells = {}
    for _, Offset in ipairs(ShapeOffsets) do
        local NR = NewBaseRow + Offset.dRow
        local NC = NewBaseCol + Offset.dCol
        if NR < 1 or NR > GRID_ROWS or NC < 1 or NC > GRID_COLS then
            return false  -- 越界不移动
        end
        table.insert(NewCells, {Row = NR, Col = NC})
    end

    -- 找目标区域左上角格子（用于 MountItemToCell）
    local TLRow, TLCol = NewCells[1].Row, NewCells[1].Col
    for _, C in ipairs(NewCells) do
        if C.Row < TLRow or (C.Row == TLRow and C.Col < TLCol) then
            TLRow, TLCol = C.Row, C.Col
        end
    end
    local TopLeftCell = self:GetContainItemAt(TLRow, TLCol)
    if not TopLeftCell then return false end

    -- 移动 Widget 到新视觉位置（无论是否合法均移动）
    PlacedItem:RemoveFromParent()
    self:MountItemToCell(PlacedItem, TopLeftCell, false)

    -- 清空上一帧全部视觉格子动效
    self:_ClearGamepadVisualCells()

    -- 更新视觉跟踪
    self._GamepadMoveRow = NewBaseRow
    self._GamepadMoveCol = NewBaseCol

    -- 校验新格子是否合法（临时清除当前占位以避免自碰撞误判）
    for _, Cell in ipairs(PlacedRecord.Cells) do
        self:ClearCellOccupied(Cell.Row, Cell.Col)
    end

    -- Other/Ammo 自动触发检测（格子已清，检测结果最准确）
    if self:_TryAutoTrigger(PlacedItem, PlacedRecord, NewCells) then
        return true
    end

    local bValid = self:CanPlaceShapeAt(NewBaseRow, NewBaseCol, NewCells)

    if bValid then
        -- 合法：更新占位数据
        for _, Cell in ipairs(NewCells) do
            self:MarkCellOccupied(Cell.Row, Cell.Col, PlacedItem)
        end
        PlacedRecord.Cells = NewCells
        PlacedRecord.BaseRow = NewBaseRow
        PlacedRecord.BaseCol = NewBaseCol
        self._GamepadMoveValid = true
    else
        -- 非法（被占用）：恢复原占位，仅视觉临时挂载
        for _, Cell in ipairs(PlacedRecord.Cells) do
            self:MarkCellOccupied(Cell.Row, Cell.Col, PlacedItem)
        end
        self._GamepadMoveValid = false
    end

    -- 刷新 UI
    self:RefreshPlacedItemDoubleState()
    self:UpdateScoreDisplay()

    -- 播放新位置的全部格子动效
    self:_PlayGamepadVisualCells(NewCells, bValid, PlacedRecord)

    return true
end

--- 查找 PlacedItem 对应的放置记录
function Component:_GetPlacedRecord(PlacedItem)
    if not PlacedItem or not self.PlacedItems then return nil end
    for _, Record in ipairs(self.PlacedItems) do
        if Record.Widget == PlacedItem then
            return Record
        end
    end
    return nil
end

-- ==================== 格子动效辅助 ====================

--- 清理当前视觉格子的动效，重置到初始态
function Component:_ClearGamepadVisualCells()
    if not self._GamepadVisualCells then return end
    for _, Cell in ipairs(self._GamepadVisualCells) do
        local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
        if ContainItem and ContainItem.DeactivateHighlight then
            ContainItem:DeactivateHighlight()
        end
    end
    self._GamepadVisualCells = nil
end

--- 播放新视觉格子的动效
--- 合法位置：双倍区播 Put_GetPoint，否则播 Put_Normal
--- 非法位置：播 Disable 高亮（红色提示）
function Component:_PlayGamepadVisualCells(NewCells, bValid, PlacedRecord)
    self._GamepadVisualCells = NewCells
    for _, Cell in ipairs(NewCells) do
        local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
        if ContainItem then
            if bValid then
                if PlacedRecord and PlacedRecord.IsDoubleReward then
                    ContainItem:PlayPutGetPoint()
                else
                    ContainItem:PlayPutNormal()
                end
            else
                ContainItem:ActivateHighlight(false)
            end
        end
    end
end

-- ==================== FOCUS 状态 ====================

--- 进入 FOCUS 态：将焦点锁定到已确认物品列表，格子高亮跟随
function Component:_EnterFocusState()
    self._GamepadState = "FOCUS"
    self._FocusIndex = 1
    self:_UpdateBottomKeyByState("FOCUS")
    self:_UpdateFocusHighlight(nil, self._ConfirmedPlacedItems[1])
    self:SetFocus()
    DebugPrint("GamepadComp: 进入 FOCUS 态，物品数=" .. #self._ConfirmedPlacedItems)
end

--- 退出 FOCUS 态（B 键或列表清空时）：回到 SCROLL（底图动效未被修改，无需恢复）
function Component:_ExitFocusState()
    self._GamepadState = "SCROLL"
    self:_UpdateBottomKeyByState("SCROLL")
    self._FocusIndex = 1
    if self.EMTileView1 then
        self.EMTileView1:SetFocus()
    end
    DebugPrint("GamepadComp: 退出 FOCUS 态，回到 SCROLL")
end

--- 处理 FOCUS 态输入
function Component:_HandleFocusInput(InKeyName)
    -- A 键：unconfirm 当前聚焦物品，进入 MOVING
    if InKeyName == Const.FaceButtonBottom then
        self:_EnterMovingFromFocus()
        return true
    end
    -- 方向键/摇杆：切换聚焦物品
    local dIdx = 0
    if InKeyName == Const.LeftStickRight or InKeyName == Const.DPadRight
        or InKeyName == Const.LeftStickDown or InKeyName == Const.DPadDown then
        dIdx = 1
    elseif InKeyName == Const.LeftStickLeft or InKeyName == Const.DPadLeft
        or InKeyName == Const.LeftStickUp or InKeyName == Const.DPadUp then
        dIdx = -1
    end
    if dIdx ~= 0 then
        self:_SwitchFocusIndex(dIdx)
        return true
    end
    return true  -- FOCUS 态全部拦截
end

--- 在 FOCUS 态切换聚焦物品索引（循环）
function Component:_SwitchFocusIndex(dIdx)
    local Count = self._ConfirmedPlacedItems and #self._ConfirmedPlacedItems or 0
    if Count <= 1 then return end  -- 只有一个物品时不切换
    local OldRecord = self._ConfirmedPlacedItems[self._FocusIndex]
    self._FocusIndex = ((self._FocusIndex - 1 + dIdx + Count) % Count) + 1
    local NewRecord = self._ConfirmedPlacedItems[self._FocusIndex]
    self:_UpdateFocusHighlight(OldRecord, NewRecord)
end

--- 更新聚焦指示：为新聚焦物品格子播一次性 Put_Flash 闪光，不影响底图动效
---@param OldRecord table|nil 旧聚焦的 PlacedRecord（底图动效未被修改，无需恢复）
---@param NewRecord table|nil 新聚焦的 PlacedRecord（nil 表示无需闪光）
function Component:_UpdateFocusHighlight(OldRecord, NewRecord)
    -- 新聚焦格子播一次性闪光（不 Stop 底图动效，叠加播放）
    if NewRecord and NewRecord.Cells then
        for _, Cell in ipairs(NewRecord.Cells) do
            local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
            if ContainItem then
                ContainItem:PlayPutFlash()
            end
        end
    end
end


--- FOCUS 态 A 键：unconfirm 当前聚焦物品，直接进入 MOVING 态
function Component:_EnterMovingFromFocus()
    local FocusRecord = self._ConfirmedPlacedItems and self._ConfirmedPlacedItems[self._FocusIndex]
    if not FocusRecord or not FocusRecord.Widget then
        self:_ExitFocusState()
        return
    end

    local PlacedItem = FocusRecord.Widget

    -- 调用 Play_C.UnconfirmPlacedItem（逆转确认，恢复 TileView，恢复操作按钮）
    -- 底图动效未被聚焦修改，UnconfirmPlacedItem 会自行处理动效切换
    -- 注意：UnconfirmPlacedItem 会同步更新 _ConfirmedPlacedItems 列表
    local bSuccess = self:UnconfirmPlacedItem(PlacedItem)
    if not bSuccess then
        -- 恢复失败（理论上不会发生），安全退出 FOCUS
        self:_ExitFocusState()
        return
    end

    -- 进入 MOVING 态（PlacedItem 已成为 CurrentUnconfirmedItem）
    self._GamepadPlacedItem = PlacedItem
    self._GamepadMoveRow = FocusRecord.BaseRow
    self._GamepadMoveCol = FocusRecord.BaseCol
    self._GamepadMoveValid = true
    self._GamepadDragSourceData = nil
    self._GamepadScanRowRange = nil
    self._GamepadScanColRange = nil

    -- 计算有效扫描范围（供后续移动使用，同 _EnterMovingMode 的逻辑）
    if PlacedItem.ShapeOffsets then
        local ShapeOff = PlacedItem.ShapeOffsets
        local sMinR, sMaxR = ShapeOff[1][1] or 0, ShapeOff[1][1] or 0
        local sMinC, sMaxC = ShapeOff[1][2] or 0, ShapeOff[1][2] or 0
        for _, Off in ipairs(ShapeOff) do
            local R, C = Off[1] or 0, Off[2] or 0
            if R < sMinR then sMinR = R end
            if R > sMaxR then sMaxR = R end
            if C < sMinC then sMinC = C end
            if C > sMaxC then sMaxC = C end
        end
        local ShapeRows = math.max(1, sMaxR - sMinR + 1)
        local ShapeCols = math.max(1, sMaxC - sMinC + 1)
        local CtrRowOff = sMinR + math.floor((ShapeRows - 1) / 2)
        local CtrColOff = sMinC + math.floor((ShapeCols - 1) / 2)
        self._GamepadScanRowRange = {
            math.max(1, 1 + CtrRowOff - sMinR),
            math.min(GRID_ROWS, GRID_ROWS + CtrRowOff - sMaxR)
        }
        self._GamepadScanColRange = {
            math.max(1, 1 + CtrColOff - sMinC),
            math.min(GRID_COLS, GRID_COLS + CtrColOff - sMaxC)
        }
    end

    -- 播放 MOVING 态格子动效（Put_Normal/Put_GetPoint）
    if FocusRecord.Cells then
        self._GamepadVisualCells = FocusRecord.Cells
        self._GamepadLastDoubleReward = FocusRecord.IsDoubleReward
        self:_PlayGamepadVisualCells(FocusRecord.Cells, true, FocusRecord)
    end

    self._FocusIndex = 1
    self._GamepadState = "MOVING"
    self:_UpdateBottomKeyByState("MOVING")
    self:SetFocus()
    DebugPrint("GamepadComp: FOCUS→MOVING，恢复物品 DisPlayItemId=" .. tostring(PlacedItem.DisPlayItemId))
end

-- ==================== 清理 ====================

--- 退出 MOVING 模式，清理所有相关状态
function Component:_ExitMovingMode()
    -- 清理视觉格子动效（可能与占位格子不同，需单独清理）
    self:_ClearGamepadVisualCells()

    if self._GamepadPlacedItem then
        -- 已放置道具：回收（清格子、移除 Widget、恢复源道具视觉）
        self:RecycleItem(self._GamepadPlacedItem)
        self._GamepadPlacedItem = nil
    else
        -- 未放置（高亮回退模式）：清理高亮和拖拽状态
        self:DeactivateShapeArea()
        self:OnDragStateChanged(false)
        -- 通过数据对象恢复 SwitchIndex（数据驱动 + 刷新可见 Widget）
        if self._GamepadDragSourceData then
            self:SetDisPlayItemSwitchIndex(self._GamepadDragSourceData.DisPlayItemId, 0)
        end
    end

    self._GamepadDragUI = nil
    self._GamepadDragOperation = nil
    self._GamepadDragSourceData = nil
    self._GamepadScanRowRange = nil
    self._GamepadScanColRange = nil
    self._GamepadLastDoubleReward = nil
    self._GamepadState = "SCROLL"
    self:_UpdateBottomKeyByState("SCROLL")
    self:_RestoreScrollFocus()
end

--- 恢复焦点到 TileView，让物品区导航恢复正常
function Component:_RestoreScrollFocus()
    if self.EMTileView1 then
        self.EMTileView1:SetFocus()
    end
end

--- 恢复焦点到 TileView 并选中第一个物品（确认放置后调用）
function Component:_RestoreScrollFocusToFirst()
    if self.EMTileView1 then
        self.EMTileView1:SetSelectedIndex(0)
        self.EMTileView1:NavigateToIndex(0)
        self.EMTileView1:SetFocus()
    end
end

--- MOVING 态移动时检测 Other 堆叠 / Ammo 装弹自动触发
--- 调用时机：当前物品格子已清除，NewCells 为目标位置坐标
---@param PlacedItem table 正在移动的 PlacedItem Widget
---@param PlacedRecord table 对应的放置记录
---@param NewCells table 目标格子坐标数组 {{Row,Col},...}
---@return boolean true=已触发并退出 MOVING；false=继续正常移动逻辑
function Component:_TryAutoTrigger(PlacedItem, PlacedRecord, NewCells)
    local ItemType = BagGameModel.ItemType
    local bTriggered = false

    if PlacedItem.ItemType == ItemType.Other then
        local TargetRecord, bCanStack = BagGameModel:FindOverlappingSameOther(PlacedItem.TemplateId, NewCells)
        -- 排除自身：BagGameModel.PlacedItems 仍包含正在移动的物品，多格形状移动时可能与旧格子重叠命中自身
        if TargetRecord and bCanStack and TargetRecord.Widget ~= PlacedItem then
            local bSuccess = self:ConsumeGamepadStackItem(PlacedItem, PlacedRecord, TargetRecord, true)
            if bSuccess then bTriggered = true end
        end
        -- bCanStack=false（目标已满）：不触发，走正常 CanPlaceShapeAt 逻辑（显示被占位）

    elseif PlacedItem.ItemType == ItemType.Ammo then
        local GunRecord, bCanLoad = BagGameModel:FindOverlappingGun(NewCells)
        if GunRecord and bCanLoad then
            local bSuccess = self:ConsumeGamepadAmmoItem(PlacedItem, PlacedRecord, GunRecord, true)
            if bSuccess then bTriggered = true end
        end
        -- bCanLoad=false（弹药已满）：不触发，走正常 CanPlaceShapeAt 逻辑
    end

    if bTriggered then
        -- 清空 MOVING 态变量，镜像 _ExitMovingMode 的清理（但不调用 RecycleItem）
        self:_ClearGamepadVisualCells()
        self._GamepadPlacedItem = nil
        self._GamepadDragUI = nil
        self._GamepadDragOperation = nil
        self._GamepadDragSourceData = nil
        self._GamepadScanRowRange = nil
        self._GamepadScanColRange = nil
        self._GamepadLastDoubleReward = nil
        self._GamepadMoveValid = false
        self._GamepadState = "SCROLL"
        self:_UpdateBottomKeyByState("SCROLL")
        self:_RestoreScrollFocus()
        return true
    end

    return false
end

return Component

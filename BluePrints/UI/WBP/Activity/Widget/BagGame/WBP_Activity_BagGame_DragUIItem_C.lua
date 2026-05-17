--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local BagGameModel = require "BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel"

local ItemType = BagGameModel.ItemType

---@type WBP_Activity_BagGame_PlayItem04_C
local M = Class({"BluePrints.UI.BP_UIState_C",
"BluePrints.UI.WBP.Activity.Widget.BagGame.Activity_BagGame_DragComponent"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    -- 形状数据：相对于基准格子的偏移坐标 {RowOffset, ColOffset}默认形状为单格 {{0, 0}}
    self.Overlay_Double:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Stop.OnClicked:Add(self, self.OnStopBtnClicked)
    self.Btn_Rotation.OnClicked:Add(self, self.OnRotationBtnClicked)
    self.Btn_Check.OnClicked:Add(self, self.OnCheckBtnClicked)
    -- Btn_Recover 可能不存在（蓝图未添加时容错）
    if self.Btn_Recover then
        self.Btn_Recover.OnClicked:Add(self, self.OnRecoverBtnClicked)
        self.Btn_Recover:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    self.bIsConfirmed = false  -- 是否已确认（确认后不能再拖拽拉起）
    self.bIsPlaced = false     -- 是否是放置状态（区分拖拽中和已放置）
    self.bIsInDoubleReward = false
    self.Text_Double:SetText(GText("UI_GameEvent_BagGame_Toast_DoubleScore"))
end

--- 根据路径设置物品图标
---@param GUIPath string
function M:SetItemIconByPath(GUIPath)
    if not self.Image_Icon or type(GUIPath) ~= "string" or GUIPath == "" then
        return
    end
    local IconObj = LoadObject(GUIPath)
    if not IconObj then
        return
    end
    self.Image_Icon:SetBrushResourceObject(IconObj)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--- 点击取消按钮，回收此道具
function M:OnStopBtnClicked()
    if self.PlayScreen and self.PlayScreen.RecycleItem then
        self.PlayScreen:RecycleItem(self)
    else
        DebugPrint("OnStopBtnClicked: PlayScreen 引用无效")
    end
end

--- 点击旋转按钮，顺时针旋转90°
function M:OnRotationBtnClicked()
    if not self.ShapeOffsets or #self.ShapeOffsets == 0 then
        return
    end

    self.RotationCount = ((self.RotationCount or 0) + 1) % 4
    self:RotateShape90CW()

    if self.PlayScreen and self.PlayScreen.RotatePlacedItem then
        self.PlayScreen:RotatePlacedItem(self)
    end

    DebugPrint("OnRotationBtnClicked: 旋转次数=" .. self.RotationCount)
end

--- 顺时针旋转形状90°（虚拟正方形外框 + 四方向对齐）
function M:RotateShape90CW()
    local NewOffsets = self:CalculateRotatedOffsets(self.RotationCount or 0)
    self.ShapeOffsets = NewOffsets
    if self.SetItemSize then
        self:SetItemSize()
    end
    self:UpdateVisualRotation()
end

--- 归一化偏移坐标，使最小值从0开始
---@param Offsets table 原始偏移数组
---@return table 归一化后的偏移数组
function M:NormalizeOffsets(Offsets)
    if not Offsets or #Offsets == 0 then
        return {{0, 0}}
    end
    
    local MinRow, MinCol = Offsets[1][1], Offsets[1][2]
    for _, Offset in ipairs(Offsets) do
        MinRow = math.min(MinRow, Offset[1])
        MinCol = math.min(MinCol, Offset[2])
    end
    
    local Normalized = {}
    for _, Offset in ipairs(Offsets) do
        table.insert(Normalized, {Offset[1] - MinRow, Offset[2] - MinCol})
    end
    
    return Normalized
end

--- 纯计算：根据旋转次数，从原始形状计算虚拟外框内对齐后的 ShapeOffsets
---@param RotCount number 旋转次数 (0-3)
---@return table 对齐后的 ShapeOffsets
---@return number 旋转后实际行数
---@return number 旋转后实际列数
function M:CalculateRotatedOffsets(RotCount)
    if not self.OriginalShapeOffsets then
        return self.ShapeOffsets or {{0, 0}}, 1, 1
    end

    local S = self.FrameSize
    local CurRows = self.OriginalRows
    local CurCols = self.OriginalCols

    local Rotated = {}
    for _, Off in ipairs(self.OriginalShapeOffsets) do
        local R, C = Off[1], Off[2]
        local StepRows = CurRows
        for _ = 1, RotCount do
            R, C = C, (StepRows - 1) - R
            StepRows = CurCols
            CurRows, CurCols = CurCols, CurRows
        end
        table.insert(Rotated, {R, C})
        CurRows = self.OriginalRows
        CurCols = self.OriginalCols
    end

    -- 每轮循环内 CurRows/CurCols 被局部交换了，这里重新正确计算
    if RotCount % 2 == 1 then
        CurRows = self.OriginalCols
        CurCols = self.OriginalRows
    else
        CurRows = self.OriginalRows
        CurCols = self.OriginalCols
    end

    Rotated = self:NormalizeOffsets(Rotated)

    local RowShift, ColShift = 0, 0
    if RotCount == 0 then
        -- 左对齐：行列都从 0 开始
    elseif RotCount == 1 then
        -- 上对齐：行列都从 0 开始
    elseif RotCount == 2 then
        -- 右对齐：列偏移到右侧
        ColShift = S - CurCols
    elseif RotCount == 3 then
        -- 下对齐：行偏移到下侧
        RowShift = S - CurRows
    end

    if RowShift ~= 0 or ColShift ~= 0 then
        for i, Off in ipairs(Rotated) do
            Rotated[i] = {Off[1] + RowShift, Off[2] + ColShift}
        end
    end

    return Rotated, CurRows, CurCols
end

--- 获取指定旋转次数下的对齐偏移（虚拟外框内 item 左上角相对于外框左上角的偏移）
---@param RotCount number 旋转次数 (0-3)
---@return number RowShift, number ColShift
function M:GetAlignShift(RotCount)
    if not self.OriginalShapeOffsets then
        return 0, 0
    end
    local S = self.FrameSize
    local CurRows, CurCols
    if RotCount % 2 == 1 then
        CurRows = self.OriginalCols
        CurCols = self.OriginalRows
    else
        CurRows = self.OriginalRows
        CurCols = self.OriginalCols
    end

    if RotCount == 2 then
        return 0, S - CurCols
    elseif RotCount == 3 then
        return S - CurRows, 0
    end
    return 0, 0
end

--- 更新视觉旋转（旋转图片）
function M:UpdateVisualRotation()
    local Angle = (self.RotationCount or 0) * 90
    -- Main 保持不旋转，避免其子控件（按钮/标签等）跟随旋转
    if self.Main then
        self.Main:SetRenderTransformAngle(0)
    end
    -- 仅旋转图标本体
    if self.Image_Icon then
        self.Image_Icon:SetRenderTransformAngle(Angle)
    end
end

function M:OnCheckBtnClicked()
    print("OnCheckBtnClicked")
    -- 调用 PlayScreen 的确认方法
    if self.PlayScreen and self.PlayScreen.ConfirmPlacedItem then
        self.PlayScreen:ConfirmPlacedItem(self)
    else
        -- 备用：直接播放动画
        self:PlayAnimation(self.Btn_Out)
    end
    -- @todo 检查是否可以放置,不可放置按钮forbiden， 其他所有按键也禁用
end

--- 点击恢复按钮，将已确认物品恢复为未确认放置状态
function M:OnRecoverBtnClicked()
    if self.PlayScreen and self.PlayScreen.UnconfirmPlacedItem then
        self.PlayScreen:UnconfirmPlacedItem(self)
    end
end

--- 显示恢复按钮（确认放置后调用）
function M:ShowRecoverBtn()
    if self.Btn_Recover then
        self.Btn_Recover:SetVisibility(UIConst.VisibilityOp.Visible)
    end
end

--- 隐藏恢复按钮（unconfirm 后调用）
function M:HideRecoverBtn()
    if self.Btn_Recover then
        self.Btn_Recover:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

--- 设置恢复按钮的 hit-test（拖拽期间禁用，避免阻挡 ContainItem）
---@param bEnabled boolean true=可点击, false=HitTestInvisible
function M:SetRecoverBtnHitTest(bEnabled)
    if self.Btn_Recover then
        if bEnabled then
            self.Btn_Recover:SetVisibility(UIConst.VisibilityOp.Visible)
        else
            self.Btn_Recover:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        end
    end
end

-- ==================== 拖拽拉起逻辑（与 DisPlayItem 一致） ====================

--- 鼠标按下事件 - 检测拖拽
function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    -- 已确认的物品或非放置状态不能拖拽拉起    布尔值状态有问题
    -- if self.bIsConfirmed or not self.bIsPlaced then
    --     return UE4.UWidgetBlueprintLibrary.Unhandled()
    -- end
    
    local MouseButton = UE4.UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent)
    if MouseButton.KeyName == "LeftMouseButton" then
        -- 使用 DetectDragIfPressed，与 DisPlayItem 一致
        local Reply = UE4.UWidgetBlueprintLibrary.DetectDragIfPressed(MouseEvent, self, UE.EKeys.LeftMouseButton)
        return Reply
    end
    
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

--- 拖拽检测事件 - 拉起已放置的物品
function M:OnDragDetected(MyGeometry, PointerEvent)
    -- 已确认的物品或非放置状态不能拖拽    布尔值状态有问题
    -- if self.bIsConfirmed or not self.bIsPlaced then
    --     return nil
    -- end
    
    -- 先保存需要的数据（因为后续会清理状态）
    local SavedDisPlayItemId = self.DisPlayItemId
    local SavedShapeOffsets = self.ShapeOffsets
    
    -- 通知 PlayScreen 清理放置状态（格子占用、列表记录等，但不移除 Widget）
    if self.PlayScreen and self.PlayScreen.PickUpPlacedItem then
        self.PlayScreen:PickUpPlacedItem(self)
    end
    
    -- 创建新的拖拽（新 DragUI 通过 InitAsDragUI 设置为 HitTestInvisible）
    local DragDropOperation = self:OnDragDetectedComponent(MyGeometry, PointerEvent, SavedDisPlayItemId, SavedShapeOffsets)
    
    -- 创建完拖拽后，移除当前放置状态的 Widget（自己）
    self:RemoveFromParent()
    
    return DragDropOperation
end

--- 设置形状数据（同时记录原始形状，用于旋转计算）
--- ShapeOffsets: 相对坐标数组，如 {{0,0}, {1,0}, {0,1}, {1,1}} 表示2x2方块
--- 坐标含义：{RowOffset, ColOffset}，正数表示向下/向右偏移
---@param ShapeOffsets table 形状坐标数组
function M:SetShape(ShapeOffsets)
    self.ShapeOffsets = ShapeOffsets or {{0, 0}}

    if not self.OriginalShapeOffsets then
        self.OriginalShapeOffsets = {}
        for _, Off in ipairs(self.ShapeOffsets) do
            table.insert(self.OriginalShapeOffsets, {Off[1], Off[2]})
        end

        local MinR, MaxR, MinC, MaxC = 0, 0, 0, 0
        for _, Off in ipairs(self.OriginalShapeOffsets) do
            MinR = math.min(MinR, Off[1])
            MaxR = math.max(MaxR, Off[1])
            MinC = math.min(MinC, Off[2])
            MaxC = math.max(MaxC, Off[2])
        end
        self.OriginalRows = MaxR - MinR + 1
        self.OriginalCols = MaxC - MinC + 1
        self.FrameSize = math.max(self.OriginalRows, self.OriginalCols)
    end
end

--- 获取形状数据
---@return table 形状坐标数组
function M:GetShape()
    return self.ShapeOffsets
end

--- 根据基准格子位置，计算形状覆盖的所有格子坐标
---@param BaseRow number 基准格子行
---@param BaseCol number 基准格子列
---@return table 格子坐标数组 {{Row, Col}, ...}
function M:GetShapeCells(BaseRow, BaseCol)
    local Cells = {}
    local MinRow, MinCol = 0, 0
    local MaxRow, MaxCol = 0, 0
    if self.ShapeOffsets and #self.ShapeOffsets > 0 then
        MinRow = self.ShapeOffsets[1][1] or 0
        MinCol = self.ShapeOffsets[1][2] or 0
        MaxRow = MinRow
        MaxCol = MinCol
        for _, Offset in ipairs(self.ShapeOffsets) do
            local Row = Offset[1] or 0
            local Col = Offset[2] or 0
            MinRow = math.min(MinRow, Row)
            MinCol = math.min(MinCol, Col)
            MaxRow = math.max(MaxRow, Row)
            MaxCol = math.max(MaxCol, Col)
        end
    end

    local Rows = math.max(1, MaxRow - MinRow + 1)
    local Cols = math.max(1, MaxCol - MinCol + 1)
    -- 基准格子在形状中心；偶数取左/上侧格子
    local CenterRowOffset = MinRow + math.floor((Rows - 1) / 2)
    local CenterColOffset = MinCol + math.floor((Cols - 1) / 2)

    for _, Offset in ipairs(self.ShapeOffsets) do
        local Row = BaseRow + ((Offset[1] or 0) - CenterRowOffset)
        local Col = BaseCol + ((Offset[2] or 0) - CenterColOffset)
        table.insert(Cells, {Row = Row, Col = Col})
    end
    return Cells
end

function M:Destruct()
    self.Btn_Stop.OnClicked:Remove(self, self.OnStopBtnClicked)
    self.Btn_Rotation.OnClicked:Remove(self, self.OnRotationBtnClicked)
    self.Btn_Check.OnClicked:Remove(self, self.OnCheckBtnClicked)
    if self.Btn_Recover then
        self.Btn_Recover.OnClicked:Remove(self, self.OnRecoverBtnClicked)
    end
end

function M:SetItemSize()
    if not self.Image_bg then
        return
    end

    local Rows, Cols = 1, 1
    if self.ShapeOffsets and #self.ShapeOffsets > 0 then
        local MinRow, MaxRow = self.ShapeOffsets[1][1] or 0, self.ShapeOffsets[1][1] or 0
        local MinCol, MaxCol = self.ShapeOffsets[1][2] or 0, self.ShapeOffsets[1][2] or 0
        for _, Offset in ipairs(self.ShapeOffsets) do
            local Row = Offset[1] or 0
            local Col = Offset[2] or 0
            MinRow = math.min(MinRow, Row)
            MaxRow = math.max(MaxRow, Row)
            MinCol = math.min(MinCol, Col)
            MaxCol = math.max(MaxCol, Col)
        end
        Rows = math.max(1, MaxRow - MinRow + 1)
        Cols = math.max(1, MaxCol - MinCol + 1)
    end
    
    -- SizeXY: X=列数(宽), Y=行数(高)
    local SizeKey = "Size" .. tostring(Cols) .. tostring(Rows)
    local TargetSize = self[SizeKey]
    if not TargetSize and self.Size11 then
        TargetSize = FVector2D(self.Size11.X * Cols, self.Size11.Y * Rows)
    end
    if TargetSize then
        local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Main)
        if CanvasSlot then
            local Anchors = CanvasSlot:GetAnchors()
            -- Anchors.Minimum = FVector2D(0.0, 0.0)
            -- Anchors.Maximum = FVector2D(0.0, 0.0)
            -- CanvasSlot:SetAnchors(Anchors)
            -- CanvasSlot:SetAlignment(FVector2D(0.0, 0.0))
            -- CanvasSlot:SetPosition(FVector2D(0.0, 0.0))
            local BaseSize = CanvasSlot:GetSize()
            if BaseSize and BaseSize.X > 0 and BaseSize.Y > 0 then
                -- 用 Size11 作为单位尺寸计算缩放
                local ScaleX = (TargetSize.X / BaseSize.X) * 0.75
                local ScaleY = (TargetSize.Y / BaseSize.Y) * 0.75
                CanvasSlot:SetSize(FVector2D(BaseSize.X * ScaleX, BaseSize.Y * ScaleY))
            end
        end
    end
end

function M:SetStackNumber(StackNum)
    self.StackNumber = StackNum or 0
    self.CurrentStack = self.StackNumber
    self.DragSyncData = self.DragSyncData or {}
    self.DragSyncData.CurrentStack = self.CurrentStack
    if self.Text_Lable then
        if self.bIsOtherType then
            self.Text_Lable:SetText("x" .. tostring(self.StackNumber))
        else
            self.Text_Lable:SetText(self.StackNumber)
        end
    end
end

function M:SetAmmoNumber(CurrentNum, MaxNum)
    self.CurrentNum = CurrentNum or 0
    self.MaxNum = MaxNum or 0
    self.CurrentAmmo = self.CurrentNum
    self.MaxAmmo = self.MaxNum
    self.DragSyncData = self.DragSyncData or {}
    self.DragSyncData.CurrentAmmo = self.CurrentAmmo
    self.DragSyncData.MaxAmmo = self.MaxAmmo
    if self.Text_Lable then
        if self.MaxNum > 0 then
            self.Text_Lable:SetText(self.CurrentNum .. "/" .. self.MaxNum)
        else
            self.Text_Lable:SetText(self.CurrentNum)
        end
    end
end

--- 应用从 DisPlayItem 同步过来的类型和数量显示
---@param SyncData table
function M:ApplyDragSyncData(SyncData)
    if not SyncData then
        return
    end

    self.TemplateId = SyncData.TemplateId or self.TemplateId
    self.ItemType = SyncData.ItemType
    self.GUIPath = SyncData.GUIPath
    self.bIsOtherType = self.ItemType == ItemType.Other
    self.DragSyncData = {
        TemplateId = SyncData.TemplateId,
        ItemType = SyncData.ItemType,
        GUIPath = SyncData.GUIPath,
        CurrentAmmo = SyncData.CurrentAmmo or 0,
        MaxAmmo = SyncData.MaxAmmo or 0,
        CurrentStack = SyncData.CurrentStack or 0,
        MaxStack = SyncData.MaxStack or 0,
    }
    self:SetItemIconByPath(self.GUIPath)

    if self.Image_Ammo then
        if self.bIsOtherType then
            self.Image_Ammo:SetVisibility(UIConst.VisibilityOp.Collapsed)
        else
            self.Image_Ammo:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
    end

    if self.ItemType == ItemType.Gun then
        self:SetAmmoNumber(SyncData.CurrentAmmo or 0, SyncData.MaxAmmo or 0)
    else
        self:SetStackNumber(SyncData.CurrentStack or 0)
    end

    if SyncData.OriginalShapeOffsets then
        self.OriginalShapeOffsets = {}
        for _, Off in ipairs(SyncData.OriginalShapeOffsets) do
            table.insert(self.OriginalShapeOffsets, {Off[1], Off[2]})
        end
        self.OriginalRows = SyncData.OriginalRows
        self.OriginalCols = SyncData.OriginalCols
        self.FrameSize = SyncData.FrameSize
    end
    if SyncData.RotationCount then
        self.RotationCount = SyncData.RotationCount
        if self.SetItemSize then
            self:SetItemSize()
        end
        self:UpdateVisualRotation()
    end
end

--- 提供给再次拖拽创建的新 DragUI 的同步数据
---@return table|nil
function M:GetDragSyncData()
    local Data
    if self.DragSyncData then
        Data = {
            TemplateId = self.DragSyncData.TemplateId or self.TemplateId,
            ItemType = self.DragSyncData.ItemType or self.ItemType,
            GUIPath = self.DragSyncData.GUIPath or self.GUIPath,
            CurrentAmmo = self.DragSyncData.CurrentAmmo or self.CurrentAmmo or self.CurrentNum or 0,
            MaxAmmo = self.DragSyncData.MaxAmmo or self.MaxAmmo or self.MaxNum or 0,
            CurrentStack = self.DragSyncData.CurrentStack or self.CurrentStack or self.StackNumber or 0,
            MaxStack = self.DragSyncData.MaxStack or 0,
        }
    elseif self.ItemType then
        Data = {
            TemplateId = self.TemplateId,
            ItemType = self.ItemType,
            GUIPath = self.GUIPath,
            CurrentAmmo = self.CurrentAmmo or self.CurrentNum or 0,
            MaxAmmo = self.MaxAmmo or self.MaxNum or 0,
            CurrentStack = self.CurrentStack or self.StackNumber or 0,
            MaxStack = self.MaxStack or 0,
        }
    else
        return nil
    end

    Data.OriginalShapeOffsets = self.OriginalShapeOffsets
    Data.OriginalRows = self.OriginalRows
    Data.OriginalCols = self.OriginalCols
    Data.FrameSize = self.FrameSize
    Data.RotationCount = self.RotationCount or 0
    return Data
end

--- 武器弹药显示更新（给 PlayScreen 调用）
---@param CurrentAmmo number
function M:UpdateAmmoDisplay(CurrentAmmo)
    local MaxAmmo = self.MaxAmmo or self.MaxNum or 0
    self:SetAmmoNumber(CurrentAmmo or 0, MaxAmmo)
end

--- 堆叠显示更新（给 PlayScreen 调用）
---@param CurrentStack number
---@param MaxStack number
function M:UpdateStackDisplay(CurrentStack, MaxStack)
    self.MaxStack = MaxStack or self.MaxStack or 0
    if self.DragSyncData then
        self.DragSyncData.MaxStack = self.MaxStack
    end
    self:SetStackNumber(CurrentStack or 0)
end

--- 切换双倍积分状态特效
---@param IsInDoubleReward boolean
function M:SetDoubleRewardState(IsInDoubleReward)
    local bNewState = IsInDoubleReward == true
    if self.bIsInDoubleReward == bNewState then
        return
    end

    self.bIsInDoubleReward = bNewState

    if bNewState then
        if self.Overlay_Double then
            self.Overlay_Double:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
        if self.Double_in then
            self:PlayAnimation(self.Double_in)
        elseif self.Double_In then
            self:PlayAnimation(self.Double_In)
        end
    else
        if self.Double_out then
            self:PlayAnimation(self.Double_out)
        elseif self.Double_Out then
            self:PlayAnimation(self.Double_Out)
        elseif self.Overlay_Double then
            self.Overlay_Double:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
end

-- DragUIItem 是 HitTestInvisible，不会接收鼠标事件，因此不需要 OnMouseButtonDown

return M

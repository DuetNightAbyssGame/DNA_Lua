require "UnLua"
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")

-- 背包输入组件：统一处理手柄、键鼠、触屏三种输入模式下的拖拽检测与 hover 路由。
-- 使用方式：将此 Component mixin 到具体 Grid Widget 上，实现对应的 Custom* 回调即可。
--
-- 拖拽检测状态机（存放在 InventoryController 上，跨 Grid 共享）：
--   bDetectDrag         = 正在检测拖拽起始（按下后、拖拽触发前）
--   StartDetectDragGrid = 发起检测的 Grid
--   StartDetectDragPos  = 按下时的屏幕坐标
--   bDetectDragIsMouse  = 当前检测是否为键鼠模式（影响移动时的判定策略）
--   bDraging            = 拖拽已触发，正在进行中
local Component = {}

-- ─── 内部工具 ───────────────────────────────────────────────────────────────

-- 从 PointerEvent 中提取按键名。
-- UE 触屏事件的 EffectingButton 有时返回 "None"，此时需要走 GetKey 路径。
local function GetKeyName(MouseEvent)
    local MouseButton = UE4.UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent)
    if MouseButton.KeyName ~= "None" then
        return MouseButton.KeyName
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(MouseEvent)
    return UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
end

-- 在手柄模式下，对 hover 回调做帧级防抖处理，避免光标在两个 Grid 边界快速穿越时
-- 产生误触发（Enter/Leave 连续闪烁）。bRecycle 格子不需要防抖。
local function FireHoverWithDebounce(self, callback, delayFrames)
    self._hoverToken = (self._hoverToken or 0) + 1
    local token = self._hoverToken
    self:AddDelayFrameFunc(function()
        if self.bMouseEntering and self._hoverToken == token then
            self._hoverTriggered = true
            callback()
        end
    end, delayFrames)
end

-- 启动拖拽检测计时器。
-- 计时结束时若 bDetectDrag 仍为 true（未被移动或抬起打断），则触发拖拽。
local function StartDragHoldTimer(self)
    local holdTime = InventoryController.MainWidget and InventoryController.MainWidget.DetectDragHoldTime or 0.2
    self:AddTimer(holdTime, function()
        if InventoryController.bDetectDrag then
            InventoryController.StartDetectDragGrid:CustomOnDragDetected()
        end
    end, false, 0, "RequestAdsorptionToFirst")
end

-- 重置所有拖拽检测状态。
local function ClearDetectDragState()
    InventoryController.bDetectDrag = false
    InventoryController.bDetectDragIsMouse = false
    InventoryController.StartDetectDragGrid = nil
    InventoryController.StartDetectDragPos = nil
end

-- ─── 按下 ────────────────────────────────────────────────────────────────────

function Component:OnPreviewMouseButtonDown(MyGeometry, MouseEvent)
    local KeyName = GetKeyName(MouseEvent)

    local IsHandled = false
    if self.CustomOnPreviewMouseButtonDown then
        IsHandled = self:CustomOnPreviewMouseButtonDown(MyGeometry, MouseEvent)
    end

    -- PocketData 为空说明此格子尚未绑定背包数据，不处理拖拽
    if self.PocketData == nil then return UE4.UWidgetBlueprintLibrary.Unhandled() end

    local GridData = InventoryController:GetGridData(self.PocketData.Name, self.Position)
    local TreasureData = GridData and GridData.TreasureData or nil

    local isConfirmKey = KeyName == "LeftMouseButton" or KeyName == Const.GamepadFaceButtonDown
    if isConfirmKey and not InventoryController.bDetectDrag and TreasureData then
        if not UIUtils.IsGamepadInput() then
            -- 手柄不在这里检测，手柄拖拽在 OnMouseButtonUp 的松手时触发
            InventoryController.bDetectDrag = true
            InventoryController.StartDetectDragGrid = self
            InventoryController.StartDetectDragPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)

            -- 键鼠端：长按 OR 移动超过阈值均可触发拖拽
            -- 移动端：移动会立即打断计时器（见 OnMouseMove），只能靠长按触发
            InventoryController.bDetectDragIsMouse = UIUtils.IsKeyboardInput()

            StartDragHoldTimer(self)
        end
        IsHandled = true
    end

    return IsHandled and UE4.UWidgetBlueprintLibrary.Handled() or UE4.UWidgetBlueprintLibrary.Unhandled()
end

-- ─── 抬起 ────────────────────────────────────────────────────────────────────

function Component:OnMouseButtonUp(MyGeometry, MouseEvent)
    local KeyName = GetKeyName(MouseEvent)

    local IsHandled = false
    if self.CustomOnMouseButtonUp then
        IsHandled = self:CustomOnMouseButtonUp(MyGeometry, MouseEvent)
    end

    local isConfirmKey = KeyName == "LeftMouseButton" or KeyName == Const.GamepadFaceButtonDown
    if isConfirmKey then
        if InventoryController.bDraging and self.CustomOnDrop and not self.bRecycle then
            -- 拖拽进行中：在当前格子上松手 → 触发放置
            ClearDetectDragState()
            self:CustomOnDrop()
            IsHandled = true
        elseif not InventoryController.bDraging and UIUtils.IsGamepadInput() then
            -- 手柄模式：拖拽未在 Down 时发起，改为在 Up 时直接触发
            -- （手柄无法"边按边移"，点击即等同于拾起）
            ClearDetectDragState()
            InventoryController.StartDetectDragGrid = self
            self:CustomOnDragDetected()
            IsHandled = true
        else
            ClearDetectDragState()
        end
    end

    return IsHandled and UE4.UWidgetBlueprintLibrary.Handled() or UE4.UWidgetBlueprintLibrary.Unhandled()
end

-- ─── Hover ───────────────────────────────────────────────────────────────────

function Component:OnMouseEnter(MyGeometry, MouseEvent)
    if UIUtils.IsGamepadInput() then
        -- 手柄用摇杆/光标模拟鼠标，需要防抖避免边界闪烁
        self.bMouseEntering = true
        if self.bRecycle then
            -- 回收格不需要防抖，直接触发
            if self.CustomOnMouseEnter then
                self:CustomOnMouseEnter(MyGeometry, MouseEvent)
            end
        else
            FireHoverWithDebounce(self, function()
                if self.CustomOnMouseEnter then
                    self:CustomOnMouseEnter(MyGeometry, MouseEvent)
                end
            end, 3)
        end
    else
        if self.CustomOnMouseEnter then
            self:CustomOnMouseEnter(MyGeometry, MouseEvent)
        end
    end

    -- 拖拽进行中：进入新格子时通知目标格子（用于高亮预览落点）
    if InventoryController.bDraging and self.CustomOnDragEnter then
        self:CustomOnDragEnter(MyGeometry, MouseEvent)
    end
end

function Component:OnMouseLeave(MouseEvent)
    if UIUtils.IsGamepadInput() then
        self.bMouseEntering = false
        self._leaveToken = (self._leaveToken or 0) + 1
        local token = self._leaveToken
        if self.bRecycle then
            if self.CustomOnMouseLeave then
                self:CustomOnMouseLeave(MouseEvent)
            end
        else
            -- 延迟几帧确认光标确实离开，避免与 Enter 防抖竞争产生误触发
            self:AddDelayFrameFunc(function()
                if not self.bMouseEntering and self._leaveToken == token then
                    -- _hoverTriggered 标记 Enter 的防抖是否真正触发过
                    -- 只有 Enter 触发过，才需要配对触发 Leave
                    if self.CustomOnMouseLeave and self._hoverTriggered then
                        self._hoverTriggered = false
                        self:CustomOnMouseLeave(MouseEvent)
                    end
                end
            end, 3)
        end
    else
        if self.CustomOnMouseLeave then
            self:CustomOnMouseLeave(MouseEvent)
        end
    end

    -- 拖拽进行中：离开格子时通知（用于取消高亮预览）
    if InventoryController.bDraging and self.CustomOnDragLeave then
        self:CustomOnDragLeave(MouseEvent)
    end
end

-- ─── 移动 ────────────────────────────────────────────────────────────────────

function Component:OnMouseMove(MyGeometry, MouseEvent)
    local IsHandled = false
    if self.CustomOnMouseMove then
        IsHandled = self:CustomOnMouseMove(MyGeometry, MouseEvent)
    end

    -- 拖拽进行中：持续通知当前悬停格子（用于实时更新落点预览）
    if InventoryController.bDraging and self.CustomOnDragOver then
        self:CustomOnDragOver(MyGeometry, MouseEvent)
        IsHandled = true
    end

    -- 拖拽检测中：根据平台策略决定是否触发或打断检测
    if InventoryController.bDetectDrag then
        local MovePos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
        local StartPos = InventoryController.StartDetectDragPos
        if MovePos and StartPos then
            if InventoryController.bDetectDragIsMouse then
                -- 键鼠端：移动超过阈值立即触发拖拽，无需等待长按计时器
                -- 使用平方距离比较，避免开方运算
                local dx = MovePos.X - StartPos.X
                local dy = MovePos.Y - StartPos.Y
                local threshold = InventoryCommonConst.DragDetectedThreshold
                if dx * dx + dy * dy >= threshold * threshold then
                    InventoryController.bDetectDrag = false
                    InventoryController.StartDetectDragGrid:CustomOnDragDetected()
                end
            else
                -- 移动端：任何移动均打断长按计时器，将事件交还给 ScrollBox 处理滑动
                if MovePos.X ~= StartPos.X or MovePos.Y ~= StartPos.Y then
                    InventoryController.bDetectDrag = false
                end
            end
        else
            InventoryController.bDetectDrag = false
        end
    end

    return IsHandled and UE4.UWidgetBlueprintLibrary.Handled() or UE4.UWidgetBlueprintLibrary.Unhandled()
end

-- ─── 触屏透传 ─────────────────────────────────────────────────────────────────
-- 触屏事件直接复用鼠标事件逻辑。
-- 平台差异（触屏 vs 键鼠）通过 UIUtils.IsMobileInput() / IsKeyboardInput() 在各函数内部区分，
-- 不在这一层做分支。

function Component:OnTouchStarted(MyGeometry, TouchEvent)
    return self:OnPreviewMouseButtonDown(MyGeometry, TouchEvent)
end

function Component:OnTouchEnded(MyGeometry, TouchEvent)
    return self:OnMouseButtonUp(MyGeometry, TouchEvent)
end

function Component:OnTouchMoved(MyGeometry, TouchEvent)
    -- 触屏滑动需要额外通知 MainWidget（用于整体背包面板的触屏平移）
    if InventoryController.MainWidget and InventoryController.MainWidget.OnTouchMoved then
        InventoryController.MainWidget:OnTouchMoved(MyGeometry, TouchEvent)
    end
    return self:OnMouseMove(MyGeometry, TouchEvent)
end

return Component

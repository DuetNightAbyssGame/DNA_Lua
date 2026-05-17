require "UnLua"
local EMCache = require "EMCache.EMCache"

---@type WBP_Battle_Record_C
local M = Class("BluePrints.UI.BP_UIState_C")

local Anim = {
    Normal = "Normal",
    Press  = "Press",
    Start  = "Start",
    Stop   = "Stop",
    Click  = "Click",
}
local DRAG_THRESHOLD = 10

function M:Construct()
    self.Super.Construct(self)

    self.IsRecording = false
    self.InputLocked = false

    self.ElapsedSec = 0
    self.TimerKey = "RecordTimer_" .. tostring(self)

    -- 初始：Normal
    self:ApplyUI()
    self:PlayAnim(Anim.Normal)
end

function M:Destruct()
    self.Super.Destruct(self)
    self:StopTimer()
end

--========================
-- Events
--========================
function M:OnPressed()
    if self.InputLocked then return end
    self:PlayAnim(Anim.Press)
end

function M:OnClicked()
    if self.InputLocked then return end

    -- 防止一次点击链路里重复触发（或极短连点）
    self.InputLocked = true

    if not self.IsRecording then
        -- 检查是否首次点击录制（使用EMCache记录）
        local GuideKey = "BattleRecord_FirstClickGuide_120"
        local HasShownGuide = EMCache:Get(GuideKey, true)
        if not HasShownGuide then
            -- 首次点击，弹出图文引导
            EMCache:Set(GuideKey, true, true)
            local GameInstance = GWorld.GameInstance
            if GameInstance then
                UE4.UUIStateAsyncActionBase.ShowGuideUI(GameInstance, 120)
            end
        end

        -- 第一次点击：开始录制 + 播 Start
        local ok, err = self:DoStartRecord()
        -- DebugPrint("DoStartRecord:", tostring(ok), tostring(err))

        if ok then
            self.IsRecording = true
            self:StartTimer()
            self:PlayAnim(Anim.Click)
            self:PlayAnim(Anim.Start)
        else
            -- 启动失败：回到 Normal
            self.IsRecording = false
            self:StopTimer()
            self:PlayAnim(Anim.Normal)
        end
    else
        -- 第二次点击：结束录制 + 播 Stop（不播 Normal）
        local ok, err = self:DoStopRecord()
        -- DebugPrint("DoStopRecord:", tostring(ok), tostring(err))

        self.IsRecording = false
        self:StopTimer()
        self:PlayAnim(Anim.Click)
        self:PlayAnim(Anim.Stop)
    end

    -- 下一帧解锁
    self:AddTimer(0, function()
        self.InputLocked = false
    end, false)
end

--========================
-- Record hooks (接SDK)
--========================
function M:DoStartRecord()
    -- TODO: 调用 SDK 开始录屏
    local EMHeroUSDKSubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance,
        UEMHeroUSDKSubsystem:StaticClass())
    if EMHeroUSDKSubsystem then
        EMHeroUSDKSubsystem:StartRecord()
        return true
    end
    return false
end

function M:DoStopRecord()
    -- TODO: 调用 SDK 结束录屏
    local EMHeroUSDKSubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance,
        UEMHeroUSDKSubsystem:StaticClass())
    if EMHeroUSDKSubsystem then
        EMHeroUSDKSubsystem:StopRecord()
        return true
    end
    return false
end

--========================
-- Timer & UI
--========================
function M:StartTimer()
    self.ElapsedSec = 0
    if self.TextTime then
        self.TextTime:SetVisibility(ESlateVisibility.Visible)
        self.TextTime:SetText("00:00")
    end

    self:RemoveTimer(self.TimerKey)
    self:AddTimer(1, function() self:TickTimer() end, true, 0, self.TimerKey)
end

function M:StopTimer()
    self:RemoveTimer(self.TimerKey)
    if self.TextTime then
        self.TextTime:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:TickTimer()
    if not self.IsRecording or not self.TextTime then return end
    self.ElapsedSec = self.ElapsedSec + 1
    local m = math.floor(self.ElapsedSec / 60)
    local s = self.ElapsedSec % 60
    self.TextTime:SetText(string.format("%02d:%02d", m, s))
end

function M:ApplyUI()
    if self.TextTime then
        self.TextTime:SetVisibility(self.IsRecording and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    end
end

function M:PlayAnim(name)
    local anim = name and self[name] or nil
    if anim then
        if self.StopAllAnimations then self:StopAllAnimations() end
        self:PlayAnimation(anim)
    end
    DebugPrint("Play animation:", tostring(name), " Recording=", tostring(self.IsRecording))
end

--========================
-- 拖拽实现
--========================
function M:SetDraggableAreaForDragRoot()
    self.LimitDraggableArea = nil
    if not self.DragRoot or not self.TouchPointLocalOffset then
        return
    end

    -- 获取 Viewport Geometry
    local viewportGeo = UE4.UWidgetLayoutLibrary.GetViewportWidgetGeometry(self)
    if not viewportGeo then return end

    local absTopLeft = UE4.USlateBlueprintLibrary.LocalToAbsolute(
        viewportGeo,
        UE4.USlateBlueprintLibrary.GetLocalTopLeft(viewportGeo)
    )

    local absViewportSize = UE4.USlateBlueprintLibrary.GetAbsoluteSize(viewportGeo)

    local dragGeo = self.DragRoot:GetCachedGeometry()
    if not dragGeo then return end

    local widgetAbsSize = UE4.USlateBlueprintLibrary.GetAbsoluteSize(dragGeo)
    local widgetLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(dragGeo)

    if widgetAbsSize.X <= 1 or widgetAbsSize.Y <= 1 then
        return
    end

    local offX = self.TouchPointLocalOffset.X / math.max(1, widgetLocalSize.X)
    local offY = self.TouchPointLocalOffset.Y / math.max(1, widgetLocalSize.Y)

    local minX = absTopLeft.X + widgetAbsSize.X * offX
    local maxX = absTopLeft.X + absViewportSize.X - widgetAbsSize.X * (1 - offX)

    local minY = absTopLeft.Y + widgetAbsSize.Y * offY
    local maxY = absTopLeft.Y + absViewportSize.Y - widgetAbsSize.Y * (1 - offY)

    self.LimitDraggableArea = {
        MinX = minX,
        MaxX = maxX,
        MinY = minY,
        MaxY = maxY,
    }
end

function M:ClampPositionToViewport(absPos)
    if not self.LimitDraggableArea then return absPos end
    local a = self.LimitDraggableArea
    return UE4.FVector2D(
        UE4.UKismetMathLibrary.FClamp(absPos.X, a.MinX, a.MaxX),
        UE4.UKismetMathLibrary.FClamp(absPos.Y, a.MinY, a.MaxY)
    )
end

--========================
-- Touch：加阈值，避免误触 Click
--========================
function M:OnTouchStarted(MyGeometry, InGestureEvent)
    if self.InputLocked or not self.DragRoot then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end

    -- 播放按压动画
    self:PlayAnim(Anim.Press)

    self.bIsDragging = true
    self.bDragMoved = false

    local absPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InGestureEvent)
    self.StartPosition = absPos

    local dragGeo = self.DragRoot:GetCachedGeometry()
    self.TouchPointLocalOffset = UE4.USlateBlueprintLibrary.AbsoluteToLocal(dragGeo, absPos)

    self:SetDraggableAreaForDragRoot()

    local handled = UE4.UWidgetBlueprintLibrary.Handled()
    return UE4.UWidgetBlueprintLibrary.CaptureMouse(handled, self)
end

function M:OnTouchMoved(MyGeometry, InGestureEvent)
    if not self.bIsDragging or not self.DragRoot then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end

    local absPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InGestureEvent)

    -- 阈值：超过才认为拖拽
    local dx = absPos.X - self.StartPosition.X
    local dy = absPos.Y - self.StartPosition.Y
    if (not self.bDragMoved) and (dx*dx + dy*dy >= DRAG_THRESHOLD*DRAG_THRESHOLD) then
        self.bDragMoved = true
    end

    absPos = self:ClampPositionToViewport(absPos)

    local parent = self.DragRoot:GetParent()
    if not parent then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    local parentGeo = parent:GetCachedGeometry()
    local localInParent = UE4.USlateBlueprintLibrary.AbsoluteToLocal(parentGeo, absPos)

    local newPos = UE4.FVector2D(localInParent.X - self.TouchPointLocalOffset.X, localInParent.Y - self.TouchPointLocalOffset.Y)

    local slot = self.DragRoot.Slot
    if slot and slot.SetPosition then
        slot:SetPosition(newPos)
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnTouchEnded(MyGeometry, MouseEvent)
    if not self.bIsDragging then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end

    -- 记录是否发生了拖拽
    local bWasDragging = self.bDragMoved

    self.bIsDragging = false
    self.bDragMoved = false
    self.TouchPointLocalOffset = nil

    if self:HasMouseCapture() then
        local handled = UE4.UWidgetBlueprintLibrary.Handled()
        UE4.UWidgetBlueprintLibrary.ReleaseMouseCapture(handled)
    end

    -- 只有没有发生拖拽时才触发点击事件
    -- 这样可以区分拖拽操作和点击操作
    if not bWasDragging and not self.InputLocked then
        self:OnClicked()
    else
        -- 非点击操作（拖拽或锁定状态），抬起后恢复 Normal
        self:PlayAnim(Anim.Normal)
    end

    return UE4.UWidgetBlueprintLibrary.Handled()
end


return M
require "UnLua"

local Unhandled = UE4.UWidgetBlueprintLibrary.Unhandled()

---负责控制军械库鼠标输入
---@type WBP_Armory_Main_P_C|WBP_Armory_Main_M_C
local M = {}

function M:Construct()
    self.TouchInfo = self.TouchInfo or {}
    self.EnableDrag = true
    self.EnableMouseWheel = true
end

function M:OnMouseWheelScroll(MyGeometry, MouseEvent)
    local WheelDelta = UE4.UKismetInputLibrary.PointerEvent_GetWheelDelta(MouseEvent)
    self:ScrollCamera(WheelDelta)
    return Unhandled
end

function M:ScrollCamera(DeltaMove)
    if(not self.EnableMouseWheel)then
        return
    end
    if(self.ActorController)then
        self.ActorController:OnScrolling(DeltaMove)
    end
end

function M:OnPointerDown(MyGeometry, MouseEvent)
    if(UKismetInputLibrary.PointerEvent_IsTouchEvent(MouseEvent))then
        local PointerIndex= UE4.UKismetInputLibrary.PointerEvent_GetPointerIndex(MouseEvent)
        if(PointerIndex == 0 or PointerIndex == 1)then
            self.TouchInfo[PointerIndex] = UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
        end
        self.TouchInfo[PointerIndex] = UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
        if(self.TouchInfo[0] and self.TouchInfo[1])then
            self.DualTouchDistance = (self.TouchInfo[0] - self.TouchInfo[1]):Size()
        end
        if(PointerIndex == 0)then
            return self:OnSinglePointerDown(MyGeometry, MouseEvent)
        else
            return Unhandled
        end
    else
        return self:OnSinglePointerDown(MyGeometry, MouseEvent)
    end
end

function M:OnSinglePointerDown(MyGeometry, MouseEvent)
    self.IsDragging = true
    self.MovedWhileDragging = false
    return Unhandled
end

function M:OnPointerUp(MyGeometry, MouseEvent)
    if(UKismetInputLibrary.PointerEvent_IsTouchEvent(MouseEvent))then
        local PointerIndex= UE4.UKismetInputLibrary.PointerEvent_GetPointerIndex(MouseEvent)
        self.TouchInfo[PointerIndex] = nil
        if(not self.TouchInfo[0] or not self.TouchInfo[1])then
            self.DualTouchDistance = 0
        end
        if(PointerIndex == 0)then
            return self:OnSinglePointerUp(MyGeometry, MouseEvent)
        else
            return Unhandled
        end
    else
        return self:OnSinglePointerUp(MyGeometry, MouseEvent)
    end
end

function M:OnSinglePointerUp(MyGeometry, MouseEvent)
    if(self.IsDragging and not self.MovedWhileDragging)then
        if(self.OnBackgroundClicked)then
            self:OnBackgroundClicked()
        end
    end
    self.MovedWhileDragging = false
    self.IsDragging = false
    if(self:HasMouseCapture())then
        return UWidgetBlueprintLibrary.ReleaseMouseCapture(UWidgetBlueprintLibrary.Unhandled())
    else
        return Unhandled
    end
end

function M:OnPointerMove(MyGeometry, MouseEvent)
    if(UKismetInputLibrary.PointerEvent_IsTouchEvent(MouseEvent))then
        local PointerIndex= UE4.UKismetInputLibrary.PointerEvent_GetPointerIndex(MouseEvent)
        self.TouchInfo[PointerIndex] = UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
        if(self.TouchInfo[0])then
            if(self.TouchInfo[1])then
                --双指
                local NewDistance = (self.TouchInfo[0] - self.TouchInfo[1]):Size()
                self:ScrollCamera((NewDistance - self.DualTouchDistance) / 5)
                self.DualTouchDistance = NewDistance
            else
                --单指
                if(PointerIndex == 0)then
                    return self:OnSinglePointerMove(MyGeometry, MouseEvent)
                end
            end
        end
    else
        return self:OnSinglePointerMove(MyGeometry, MouseEvent)
    end
    return Unhandled
end

function M:OnSinglePointerMove(MyGeometry, MouseEvent)
    if(self.EnableDrag and self.IsDragging)then
        local CursorDelta = UE4.UKismetInputLibrary.PointerEvent_GetCursorDelta(MouseEvent)
        if(CursorDelta.X ==0 and CursorDelta.Y == 0)then
            return Unhandled
        end
        self.MovedWhileDragging = true
        if(self.ActorController)then
            self.ActorController:OnDragViewActor(CursorDelta)
        end
        if(not self:HasMouseCapture())then
            return UWidgetBlueprintLibrary.CaptureMouse(UWidgetBlueprintLibrary.Handled(),self)
        end
    end
    return Unhandled
end

function M:OnPointerCaptureLost()
    self.IsDragging = false
end

return M
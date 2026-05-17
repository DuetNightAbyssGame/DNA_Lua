--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local WBP_Battle_FSVjoy_C=Class({
    "BluePrints.Common.TimerMgr",
})

-- WBP_Battle_FSVjoy_C._components = {
--     "BluePrints.UI.UIComponent.TouchComponent",
-- }

-- function WBP_Battle_FSVjoy_C:TouchJoySticksMultiMove(TouchFingerCount, Index, Pos1, Pos2, TwoPointDist)
--     local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
--     if (not UE4.UKismetSystemLibrary.IsValid(Player) or TouchFingerCount <= 1) then
--         return
--     end
--     if (self.LastTouchMultiDist == nil) then
--         self.LastTouchMultiDist = TwoPointDist
--         return
--     end
--     local DeltaDis = TwoPointDist - self.LastTouchMultiDist
--     if (DeltaDis >= 10) then
--         -- 拉近
--         Player:ChangeCameraOffsetOnMouseWheel(true)
--         Player:ChangeCameraLengthOnMouseWheel(true)
--     elseif (DeltaDis <= -10) then 
--         -- 拉远
--         Player:ChangeCameraOffsetOnMouseWheel(false)
--         Player:ChangeCameraLengthOnMouseWheel(false)
--     end
--     self.LastTouchMultiDist = TwoPointDist
-- end

function WBP_Battle_FSVjoy_C:SetPosition()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    local ScreenSize=UIManager:GetDesignedScreenSize()
    local Position=UIManager:GetVirtualJoystick()
    -- 这里需要加上遥感右侧的留白区，这个值后面会动态读入
    Position.X=(Position.X-1 + 78 / ScreenSize.X)*ScreenSize.X
    Position.Y=Position.Y*ScreenSize.Y
    local CanvasSlot=UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Bg)
    CanvasSlot:SetPosition(Position)
end

-- AssembleComponents(WBP_Battle_FSVjoy_C)
return WBP_Battle_FSVjoy_C

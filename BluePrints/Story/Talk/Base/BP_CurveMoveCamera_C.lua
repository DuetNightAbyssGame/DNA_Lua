--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
---@type BP_CurveMoveCamera_C
local M = Class()

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

function M:ReceiveBeginPlay()
    EventManager:AddEvent(EventID.OnCurveCameraStartMove, self, self.StartMove)
    EventManager:AddEvent(EventID.OnSelectWeapon, self, self.K2_DestroyActor)
end

function M:ReceiveEndPlay()
    EventManager:RemoveEvent(EventID.OnCurveCameraStartMove, self)
    EventManager:RemoveEvent(EventID.OnSelectWeapon, self)
end

function M:ReceiveTick(DeltaSeconds)
    self:MoveCamera(DeltaSeconds)
    if not self.SelectUI and self.CurrentTime >= self.MoveTime then
	    self.SelectUI = UIManager(self):LoadUI(UIConst.STORYWEAPONSELECT, "StoryWeaponSelect", UIConst.ZORDER_FOR_DESKTOP_TEMP)
        -- self.SelectUI = UIManager(self):LoadUI(UIConst.DUNGEONBATTLECOUNT, "StoryWeaponSelect", UIConst.ZORDER_ABOVE_ALL)
    end
end

function M:StartMove(MoveTime)
    self.CanMoveCamera = true
    self.MoveTime = MoveTime
end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return M

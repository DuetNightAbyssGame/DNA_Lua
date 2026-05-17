--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_DefenceMoveComponent_C
local BP_DefenceMoveComponent_C = Class({
	"BluePrints.GameMode.DungeonComponents.BP_DefenceComponent_C",
})

function BP_DefenceMoveComponent_C:InitDefenceMoveComponent()
    self:InitDefenceComponent()
end

function BP_DefenceMoveComponent_C:GetDataMgrInfo()
	return DataMgr.DefenceMove[self.GameMode.DungeonId]
end

-- 移到基类了
-- function BP_DefenceMoveComponent_C:OnDefenceCoreActive()
-- 	self.GameMode.EMGameState:SetDungeonUIState(Const.EDungeonUIState.OnTarget)
-- end

-- function M:Initialize(Initializer)
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

return BP_DefenceMoveComponent_C

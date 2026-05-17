local M = {}

function M:AddFlow(Channel, OnExecute, OnBlocked, OnRemoved)
	local GameFlowManager = USubsystemBlueprintLibrary.GetWorldSubsystem(GWorld.GameInstance, UGameFlowManager)
	if (not IsValid(GameFlowManager)) then
		return
	end

	return GameFlowManager:AddFlowByTable(Channel, OnExecute, OnBlocked, OnRemoved)
end

function M:RemoveFlow(Id)
	local GameFlowManager = USubsystemBlueprintLibrary.GetWorldSubsystem(GWorld.GameInstance, UGameFlowManager)
	if (not IsValid(GameFlowManager)) then
		return
	end

	GameFlowManager:RemoveFlow(Id)
end

return M

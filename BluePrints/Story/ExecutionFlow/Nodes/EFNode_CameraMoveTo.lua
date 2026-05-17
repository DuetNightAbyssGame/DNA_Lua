local ECameraBlendFunc = {
	linear = 0,
	easeInQuad = 1,
	easeOutQuad = 2,
	easeInOutQuad = 3,
}

local M = {}

local ScriptLogType = UE.EStoryLogType.Script

function M:CreateNode(Flow, TalkTask, Params)
	local TargetPosition = Params.TargetPosition
	local Duration = Params.duration or 0
	local CurveName = Params.Blend

	local PlayerController = UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)

	if (CurveName and ECameraBlendFunc[CurveName] == nil) then
		local Message = string.format("Invalid curve name: %s, DialogueId: %d", CurveName, Flow.DialogueId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "CameraMoveTo脚本执行失败: Curve无效", Message)
		return
	end

	local TalkContext = GWorld.GameInstance:GetTalkContext()
	if (not IsValid(TalkContext)) then
		local Message = string.format("TalkContext not found, DialogueId: %d", Flow.DialogueId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "CameraMoveTo脚本执行失败: TalkContext无效", Message)
		return
	end

	local CameraMoveToNode = Flow:CreateNode(UEFNode_Delegate)
	CameraMoveToNode.DebugLog = string.format("CameraMoveTo TargetPosition: %s, Duration: %s, CurveName: %s", TargetPosition, Duration, CurveName)

	CameraMoveToNode.OnStart:Add(CameraMoveToNode, function(Node)
		if (TalkTask.TalkTaskData.CameraType == "PlayerCamera" or TalkTask.TalkTaskData.CameraType == "FreeCamera") then
			local Message = string.format("Camera type can't be %s, DialogueId: %s", TalkTask.TalkTaskData.CameraType, Flow.DialogueId)
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "CameraMoveTo脚本执行失败: Camera Type无效", Message)
		else
			TalkContext.TalkCameraManager:_StartCameraBreathe_FinalCameraConfig(nil, TargetPosition, Duration, TalkTask.TalkTaskData.TalkStage, CurveName)
		end
		Node:Finish({ Node.FinishPin })
	end)

	CameraMoveToNode.OnSkip:Add(CameraMoveToNode, function(Node)
		TalkContext.TalkCameraManager:ClearCameraBreatheCallback()
		Node:Finish({ Node.FinishPin })
	end)

	local CacheControllerPausedParam = PlayerController.bShouldPerformFullTickWhenPaused
	CameraMoveToNode.OnPause:Add(CameraMoveToNode, function(Node)
		PlayerController.bShouldPerformFullTickWhenPaused = false
		UGameplayStatics.SetGamePaused(GWorld.GameInstance, true)
		TalkContext.TalkCameraManager:PauseCameraBreathe(true)
		-- TalkContext:PauseTimer(self)
	end)

	CameraMoveToNode.OnResume:Add(CameraMoveToNode, function(Node)
		PlayerController.bShouldPerformFullTickWhenPaused = CacheControllerPausedParam
		UGameplayStatics.SetGamePaused(GWorld.GameInstance, false)
		TalkContext.TalkCameraManager:PauseCameraBreathe(false)
		-- TalkContext:UnPauseTimer(self)
	end)

	return CameraMoveToNode
end

return M

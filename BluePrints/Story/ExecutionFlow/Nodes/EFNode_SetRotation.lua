local M = {}
local ScriptLogType = UE.EStoryLogType.Script

function M:CreateNode(Flow, TalkTask, Params)
	local RotationDescription = Params.SetRotationDescription

	local TalkContext = GWorld.GameInstance:GetTalkContext()
	if (not IsValid(TalkContext)) then
		local Message = string.format("SetLocation create failed: TalkContext not found, DialogueId: %d", Flow.DialogueId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "SetLocation脚本执行失败: TalkContext无效", Message)
		return
	end

	local SetRotationNode = Flow:CreateNode(UEFNode_Delegate)
	SetRotationNode.DebugLog = string.format("SetRotation RotationDescription: %s", RotationDescription)

	SetRotationNode.OnStart:Add(SetRotationNode, function(Node)
		TalkContext.TalkActionManager:SyncSetActorRotation(TalkTask, TalkContext, RotationDescription, function()
		end)
		Node:Finish({ Node.FinishPin })
	end)

	return SetRotationNode
end

return M

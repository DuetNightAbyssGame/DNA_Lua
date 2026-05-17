local M = {}
local ScriptLogType = UE.EStoryLogType.Script

function M:CreateNode(Flow, TalkTask, Params)
	local TargetPointName = Params.TargetPoint

	local TalkContext = GWorld.GameInstance:GetTalkContext()
	if (not IsValid(TalkContext)) then
		local Message = string.format("SetPlayerLoc create failed: TalkContext not found, DialogueId: %d", Flow.DialogueId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "SetPlayerLoc脚本执行失败: TalkContext无效", Message)
		return
	end

	local SetPlayerLocNode = Flow:CreateNode(UEFNode_Delegate)
	SetPlayerLocNode.DebugLog = string.format("SetPlayerLoc TargetPointName: %s", TargetPointName)

	SetPlayerLocNode.OnStart:Add(SetPlayerLocNode, function(Node)
		TalkContext:SetPlayerLocWithLoadLevel(TargetPointName, function()
			Node:Finish({ Node.FinishPin })
		end)
	end)

	SetPlayerLocNode.OnFinish:Add(SetPlayerLocNode, function(Node)
	end)

	SetPlayerLocNode.OnSkip:Add(SetPlayerLocNode, function(Node)
		Node:Finish({ Node.FinishPin })
	end)

	return SetPlayerLocNode
end

return M

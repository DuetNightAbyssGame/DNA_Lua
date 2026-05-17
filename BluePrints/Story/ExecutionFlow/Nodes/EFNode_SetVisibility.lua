local M = {}

local ETalkVisibility = {
	Show = "Show",
	Hide = "Hide"
}

local ScriptLogType = UE.EStoryLogType.Script

function M:CreateNode(Flow, TalkTask, Params)
	local ActorId = Params.ActorId
	local Visibility = Params.Visibility

	local TalkContext = GWorld.GameInstance:GetTalkContext()
	if (not IsValid(TalkContext)) then
		local Message = string.format("SetVisibility create failed: TalkContext not found, DialogueId: %d", Flow.DialogueId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "SetVisibility脚本执行出错：TalkContext无效", Message)
		return
	end

	local TalkActorData = TalkContext:GetTalkActorData(TalkTask, ActorId)
	if (not TalkActorData) then
		local Message = string.format("SetVisibility create failed: TalkActorData not found, ActorId: %d, DialogueId: %d", ActorId, Flow.DialogueId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType,  "SetVisibility脚本执行出错：TalkActorData无效", Message)
		return
	end

	local SetVisNode = Flow:CreateNode(UEFNode_Delegate)
	SetVisNode.DebugLog = string.format("SetVisibility ActorId: %d, Visibility: %s", ActorId, Visibility)

	SetVisNode.OnStart:Add(SetVisNode, function(Node)
		if (Visibility == ETalkVisibility.Show) then
			TalkContext:ShowActor(TalkActorData, true, true)
		elseif (Visibility == ETalkVisibility.Hide) then
			TalkContext:HideActor(TalkActorData, true, true)
		end
		Node:Finish({ Node.FinishPin })
	end)

	return SetVisNode
end

return M

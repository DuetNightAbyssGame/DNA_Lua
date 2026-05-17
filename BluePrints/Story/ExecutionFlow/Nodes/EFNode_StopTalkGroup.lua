local Timeutils = require("Utils.TimeUtils")
local M = {}
local ScriptLogType = UE.EStoryLogType.Script

function M:CreateNode(Flow, TalkTask, Params)
	local ActorId = Params.ActorId
	local Duration = Params.Duration or 0.5

	local StopTalkGroupNode = Flow:CreateNode(UEFNode_Delegate)
	StopTalkGroupNode.DebugLog = string.format("StopTalkGroup ActorId: %s, Duration: %s", ActorId, Duration)

	StopTalkGroupNode.OnStart:Add(StopTalkGroupNode, function(Node)
		local TalkContext = GWorld.GameInstance:GetTalkContext()
		local TalkActorData = TalkContext:GetTalkActorData(TalkTask, ActorId) or {}
		local TalkActor = TalkActorData.TalkActor
		if not IsValid(TalkActor) then
			local DialogueData = DataMgr.Dialogue[Flow.DialogueId]
			local Scripts = (DialogueData and DialogueData.Scripts) or ""
			local Message = "StopTalkGroup找不到对应Actor,Id：" .. tostring(ActorId) .. "\n台词Id:" .. Flow.DialogueId .. "\n脚本：\n" .. Scripts
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "StopTalkGroup脚本运行出错：TalkActor无效", Message)
			Node:Finish({ Node.FinishPin })
			return
		end
		TalkActor:StopAllTalkAction()
		Node.DurationHandle = UKismetSystemLibrary.K2_SetTimerDelegate({ Node,  function()
			if not IsValid(Node) then return end
			Node:Finish({ Node.FinishPin })
		end }, Duration, false)
		-- Node.StartTime = Timeutils.NowTime()
		-- Node.LastDuration = Duration
	end)


	-- StopTalkGroupNode.OnPause:Add(StopTalkGroupNode, function(Node)
	-- 	if Node.DurationHandle then
	-- 		UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(Node.DurationHandle)
	-- 		Node.DurationHandle = nil
	-- 	end
	-- 	local NowTime = Timeutils.NowTime()
	-- 	local CostTime = NowTime - Node.StartTime
	-- 	Node.LastDuration = Node.LastDuration - CostTime
	-- 	Node.StartTime = NowTime
	-- end)

	-- StopTalkGroupNode.OnResume:Add(StopTalkGroupNode, function(Node)
	-- 	if Node.DurationHandle then
	-- 		Node.DurationHandle = UKismetSystemLibrary.K2_SetTimerDelegate({ Node, Node.Finish }, Node.LastDuration, false)
	-- 	end
	-- end)

	-- StopTalkGroupNode.OnStop:Add(StopTalkGroupNode, function(Node)
	-- 	if Node.DurationHandle then
	-- 		UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(Node.DurationHandle)
	-- 		Node.DurationHandle = nil
	-- 	end
	-- end)

	StopTalkGroupNode.OnSkip:Add(StopTalkGroupNode, function(Node)
		if Node.DurationHandle then
			UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(Node.DurationHandle)
			Node.DurationHandle = nil
		end
		Node:Finish({ Node.FinishPin })
	end)

	return StopTalkGroupNode
end

return M

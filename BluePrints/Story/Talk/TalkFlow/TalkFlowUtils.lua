local FCheckOptionConditionNode = require "BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_Condition"
local FDialogueNode = require "BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_Dialogue"
local FOptionNode = require "BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_Option"
local FStartNode = require "BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_Start"
local FEndNode = require "BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_End"

local FEFNode_PlayAudio = require "BluePrints.Story.Talk.TalkFlow.DelegateNodes.EFNode_PlayAudio"

local FlowUtils = require "BluePrints.Story.ExecutionFlow.ExecutionFlowUtils"

local TalkFlowController = require "BluePrints.Story.Talk.TalkFlow.TalkFlowController"

local M = {}

function M:GetOrCreateNode(NodeType, DialogueId, TalkTask, Comps, NodeMaps, Events)
	local Flow = TalkFlowController:GetTalkFlow()
	local Node = self:TryGetNode(NodeType, DialogueId, NodeMaps)
	--DebugPrint("lhr@GetOrCreateNode", NodeType, DialogueId)
	if Node ~= nil then
		return Node
	end

	if NodeType == "Dialogue" then
		Node = FDialogueNode:New(DialogueId, TalkTask, Comps, NodeMaps, Events)
	elseif NodeType == "Option" then
		Node = FOptionNode:New(DialogueId, TalkTask, Comps, NodeMaps, Events)
	elseif NodeType == "CheckOptionCondition" then
		Node = FCheckOptionConditionNode:New(DialogueId, TalkTask, Comps, NodeMaps, Events)
	elseif NodeType == "Start" then
		Node = FStartNode:New(DialogueId, TalkTask, Comps, NodeMaps, Events)
	elseif NodeType == "End" then
		Node = FEndNode:New(nil, nil, nil, nil, Events)
	else
		DebugPrint("FTalkFlow:GetOrCreateNode: NodeType无效", NodeType)
		return
	end
	return Node
end

function M:TryGetNode(NodeType, DialogueId, NodeMaps)
	if not NodeMaps then return end
	local NodeMap
	if NodeType == "Dialogue" then
		local NodeMap = NodeMaps.DialogueNodeMap
	elseif NodeType == "Option" then
		local NodeMap = NodeMaps.OptionNodeMap
	elseif NodeType == "CheckOptionCondition" then
		local NodeMap = NodeMaps.CheckConditionNodeMap
	end
	return NodeMap and NodeMap[DialogueId]
end

function M:CreateFlow(DialogueId, TalkTask, OnFinished)
	local DialogueData = DataMgr.Dialogue[DialogueId]
	local DialogueScriptTable = DataMgr.DialogueConvert[DialogueId]
	local TalkSubsystem = USubsystemBlueprintLibrary.GetWorldSubsystem(GWorld.GameInstance, UTalkSubsystem)
	if (TalkSubsystem == nil) then
		DebugPrint("TalkFlowUtils@CreateFlow: Create flow failed: talk subsystem is nil")
		return nil
	end

	local Flow = TalkSubsystem:CreateDialogueFlow(DialogueId)
	Flow.DialogueId = DialogueId
	Flow.bAllowClick = DialogueData.bAllowClick

	Flow.OnFinish:Add(TalkSubsystem, function()
		TalkSubsystem:DestroyDialogueFlow(DialogueId)
		if (OnFinished) then
			OnFinished()
		end
	end)

	Flow.OnStop:Add(TalkSubsystem, function()
		TalkSubsystem:DestroyDialogueFlow(DialogueId)
		if (OnFinished) then
			OnFinished()
		end
	end)

	local StartNode = Flow.StartNode
	local FinishNode = Flow.FinishNode

	local ParallelNode = Flow:CreateNode(UEFNode_Parallel)
	local WaitAllNode = Flow:CreateNode(UEFNode_WaitAll)

	StartNode.FinishPin:LinkTo(ParallelNode.StartPin)
	ParallelNode.FinishPin:LinkTo(WaitAllNode.StartPin)
	WaitAllNode.FinishPin:LinkTo(FinishNode.StartPin)

	if DialogueScriptTable then
		local NodeStartPin, NodeFinishPin = FlowUtils:PARA(Flow, TalkTask, DialogueScriptTable.Operations)
		if (NodeStartPin and NodeFinishPin) then
			ParallelNode.FinishPin:LinkTo(NodeStartPin)
			NodeFinishPin:LinkTo(WaitAllNode.StartPin)
		end
	end

	return Flow, ParallelNode, WaitAllNode
end

function M:PlayAudioNode(Flow, Params)
	local PlayAudioNode = FEFNode_PlayAudio:CreateNode(Flow, Params)
	if (PlayAudioNode == nil) then
		return
	end

	return PlayAudioNode.StartPin, PlayAudioNode.FinishPin
end

return M
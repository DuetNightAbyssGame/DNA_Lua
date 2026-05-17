local FCheckOptionConditionNode = require "BluePrints.Story.StoryIteration.CheckOptionConditionNode"
local ImpressionTypes = require"BluePrints.UI.UI_PC.Impression.ImpressionConst".ImpressionTypes
local FTalkTriggerComponent = require "BluePrints.Story.Talk.Component.TalkTriggerComponent"
local FIterationStartNode = require "BluePrints.Story.StoryIteration.IterationStartNode"
local FIterationEndNode = require "BluePrints.Story.StoryIteration.IterationEndNode"
local FDialogueNode = require "BluePrints.Story.StoryIteration.DialogueNode"
local ReviewUtils = require"BluePrints.UI.WBP.StoryReview.StoryReviewUtils"
local FOptionNode = require "BluePrints.Story.StoryIteration.OptionNode"
local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"
local ETalkType = require"BluePrints.Story.Talk.Base.ETalkType"
local EDialogueNodeType = TalkUtils.EDialogueNodeType

local FStoryIterationGraph = {}

function FStoryIterationGraph:New(Dialogues, InitialDialogueId, TalkTask) 
	local StoryIterationGraph = setmetatable({}, {
		__index = FStoryIterationGraph
	})
	StoryIterationGraph.TalkTask = TalkTask
	StoryIterationGraph.InitialDialogueId = InitialDialogueId
	StoryIterationGraph.BasicTalkType = TalkTask:GetBasicTalkType()
	StoryIterationGraph.TalkTriggerComponent = FTalkTriggerComponent:New()
	StoryIterationGraph.bShowInStoryReview = TalkTask.TalkTaskData.bShowInStoryReview
	StoryIterationGraph:Init(Dialogues, InitialDialogueId)
	return StoryIterationGraph
end

function FStoryIterationGraph:Init(Dialogues, InitialDialogueId)
	if not InitialDialogueId or not Dialogues[InitialDialogueId] then
		DebugPrint("lhr@FStoryIterationGraph:Init, Dialogue is nil", InitialDialogueId)
		return
	end
	self:InitNodeMaps()
	self.Dialogues = Dialogues
	self.EndNode = FIterationEndNode:New(self)
	self.CurrentNode = FIterationStartNode:New(Dialogues, InitialDialogueId, self)
end

function FStoryIterationGraph:InitNodeMaps()
	self.CheckConditionNodeMap = {}
	self.DialogueNodeMap = {}
	self.OptionNodeMap = {}
end

function FStoryIterationGraph:GetOrCreateNode(NodeType, DialogueId)
	local Node = self:GetNode(NodeType, DialogueId)
	--DebugPrint("lhr@GetOrCreateNode", NodeType, DialogueId)
	if Node ~= nil then
		return Node
	end

	if NodeType == "Dialogue" then
		Node = FDialogueNode:New(self.Dialogues, DialogueId, self)
	elseif NodeType == "Option" then
		Node = FOptionNode:New(self.Dialogues, DialogueId, self)
	elseif NodeType == "CheckOptionCondition" then
		Node = FCheckOptionConditionNode:New(self.Dialogues, DialogueId, self)
	elseif NodeType == "Start" then
		DebugPrint("FStoryIterationGraph@GetOrCreateNode: 不能创建Start节点")
		return
	elseif NodeType == "End" then
		DebugPrint("FStoryIterationGraph@GetOrCreateNode: 不能创建End节点")
		return
	else
		DebugPrint("FStoryIterationGraph@GetOrCreateNode: NodeType无效", NodeType)
		return
	end

	return Node
end

function FStoryIterationGraph:GetNode(NodeType, DialogueId)
	if NodeType == "End" then
		return self.EndNode
	elseif NodeType == "Dialogue" then
		return self.DialogueNodeMap[DialogueId]
	elseif NodeType == "Option" then
		return self.OptionNodeMap[DialogueId]
	elseif NodeType == "CheckOptionCondition" then
		return self.CheckConditionNodeMap[DialogueId]
	end
end

function FStoryIterationGraph:Iterate(...)
	self.CurrentNode:Iterate(...)
end

function FStoryIterationGraph:OnNodeEnter(Node)
	if not Node then
		DebugPrint("FStoryIterationGraph@OnNodeEnter: Node无效")
		return
	end
	if self.CurrentNode == Node then
		DebugPrint("FStoryIterationGraph@OnNodeEnter: 重复进入节点")
		return
	end
	self.CurrentNode = Node
end

function FStoryIterationGraph:OnNodeRecord(Node, ...)
	--NOTHING
end

function FStoryIterationGraph:Skip()
	local bSkipFail = self.CurrentNode:Skip()
	return not bSkipFail
end

function FStoryIterationGraph:IsBlack()
	return self.BasicTalkType == ETalkType.Black
end

function FStoryIterationGraph:IsCinematic()
	return self.BasicTalkType == ETalkType.Cinematic
end

function FStoryIterationGraph:UsingImpressionUI()
	return self.TalkTask.TalkType == "Impression" or self.TalkTask.TalkType == "QuestImpression"
end

function FStoryIterationGraph:GetCurrentNode()
	return self.CurrentNode
end

function FStoryIterationGraph:GetDesiredNode(Node)
	if Node then
		return Node:GetDesiredNode()
	end
	return nil
end

function FStoryIterationGraph:RecordCheckResult(CheckRes, CheckValue)
	if self.CheckHandle then
		self.CheckHandle:InsertCheckData(CheckRes, CheckValue)
	end
end

function FStoryIterationGraph:SetRestartTag(RestartDialogueId)
	self.RestartDialogueId = RestartDialogueId
end

function FStoryIterationGraph:GetRestartTag()
	return self.RestartDialogueId
end

return FStoryIterationGraph
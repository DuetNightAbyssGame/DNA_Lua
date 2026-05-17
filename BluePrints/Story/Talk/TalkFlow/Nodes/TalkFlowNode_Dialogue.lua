
local TalkFlowUTils = require "BluePrints.Story.Talk.TalkFlow.TalkFlowUTils"
local ReviewUtils = require"BluePrints.UI.WBP.StoryReview.StoryReviewUtils"
local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"
local EDialogueNodeType = TalkUtils.EDialogueNodeType
local EDialogueIterType = TalkUtils.EDialogueIterType

local M = Class({"BluePrints.Story.StoryIteration.StoryIterationNode"})

M.NodeType = EDialogueNodeType.Dialogue

function M:BuildNode(DialogueId, Comps)
	rawset(self, "DialogueRecordComponent", Comps.RecordComp)
	rawset(self, "DialogueWikiComponent",  Comps.WikiComp)
	M.Super.BuildNode(self, DialogueId, Comps)
	self:CreateSubFlow(DialogueId)
end

function M:CreateSubFlow(DialogueId)
	local SubFlow, ParallelNode, WaitAllNode = TalkFlowUTils:CreateFlow(DialogueId, self.TalkTask, function()
		self:Iterate(EDialogueIterType.Out)
		self.SubFlow = nil
	end)
	self.SubFlow = SubFlow
	if self.OnFlowCreated then
		self.OnFlowCreated(self.EventReceiver, self.SubFlow, ParallelNode, WaitAllNode)
	end
end

function M:CreateNodeData(DialogueId)
	local Dialogue = DataMgr.Dialogue[DialogueId]

	self.Dialogue = Dialogue
	self.NextOptions = Dialogue.NextOptions
	self.NextDialogue = Dialogue.NextDialogue
	self.FinalDialogue = Dialogue.FinalDialogueId
	self.Content = TalkUtils:DialogueIdToContent(DialogueId)

	if self.DialogueWikiComponent and Dialogue.RelatedWikiId then
		self.DialogueWikiComponent:AddListenWikiId(Dialogue.RelatedWikiId)
	end

	--将自身记录在Graph中，防止递归
	self:RecordNodeInMap(DialogueId, self.NodeMaps)

	M.Super.CreateNodeData(self, DialogueId)
end

function M:GenerateNextNodes()
	--对于既有NextDialogue，也有NextOptions的Dialogue节点，创建一个分支节点
	if self.NextDialogue and self.NextOptions then
		local DialogueId = self.Dialogue.DialogueId
		local NextNode = self:CreateNextNode("CheckOptionCondition", DialogueId)
		self:SetOutPort(EDialogueIterType.Out, NextNode)
		return
	end
	--对于普通Dialogue节点，下个节点也是Dialogue节点
	if self.NextDialogue then
		local DialogueId = self.NextDialogue
		local NextNode = self:CreateNextNode("Dialogue", DialogueId)
		self:SetOutPort(EDialogueIterType.Out, NextNode)
	--对于带有选项的Dialogue节点，创建一个Option节点并连接
	elseif self.NextOptions then
		local DialogueId = self.Dialogue.DialogueId
		local NextOptionNode = self:CreateNextNode("Option", DialogueId)
		self:SetOutPort(EDialogueIterType.Out, NextOptionNode)
	--NextDialogue与NextOptions都为空的节点，直接连接End节点
	else
		if self.FinalDialogue then
			local NextNode = self:CreateNextNode("Dialogue", self.FinalDialogue)
			self:SetOutPort(EDialogueIterType.Final, NextNode)
		else
			local NextNode = self:CreateNextNode("End")
			self:SetOutPort(EDialogueIterType.Out, NextNode)
		end
	end
end

function M:RecordNodeInMap(DialogueId, NodeMaps)
	if not NodeMaps then return end
	local NodeMap = NodeMaps.DialogueNodeMap
	if NodeMap then
		rawset(NodeMap, DialogueId, self)
	end
end

function M:Enter(bSkip)
	M.Super.Enter(self, bSkip)
	self:Record()
end

function M:Execute(bSkip)
	-- DebugPrint("lhr@Execute: DialogueNode")
	self.TalkTask:PlayDialogue(nil, bSkip)
end

function M:Pause()
	if self.SubFlow then
		self.SubFlow:Pause()
	end
end

function M:Resume()
	-- DebugPrint("lhr@Resume: DialogueNode")
	if self.SubFlow then
		self.SubFlow:Resume()
	end
end

function M:AllowSkip()
	return self.SubFlow and self.SubFlow.bAllowClick or false
end

function M:RealSkip()
	if self.SubFlow then
		self.SubFlow:Skip()
	end
end

function M:Record()
	M.Super.Record(self)
	self.DialogueRecordComponent:OnDialogueRecord(self.Dialogue.DialogueId, self.Dialogue)
end

return M
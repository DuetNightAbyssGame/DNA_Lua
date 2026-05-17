
local ReviewUtils = require"BluePrints.UI.WBP.StoryReview.StoryReviewUtils"
local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"
local EDialogueNodeType = TalkUtils.EDialogueNodeType
local EDialogueIterType = TalkUtils.EDialogueIterType

local FDialogueNode = Class({"BluePrints.Story.StoryIteration.StoryIterationNode"})

FDialogueNode.NodeType = EDialogueNodeType.Dialogue

function FDialogueNode:CreateNodeData(DialogueId)
	local Dialogue = self.Dialogues[DialogueId]

	self.Dialogue = Dialogue
	self.NextOptions = Dialogue.NextOptions
	self.NextDialogue = Dialogue.NextDialogue
	self.FinalDialogue = Dialogue.FinalDialogueId
	self.Content = TalkUtils:DialogueIdToContent(DialogueId)

	self.bDone = false
	self.bPaused = false
	self.IterateArgs = {}

	--将自身记录在Graph中，防止递归
	self.IterGraph.DialogueNodeMap[DialogueId] = self

	if Dialogue.RelatedWikiId and self.DialogueWikiComponent then
		self.DialogueWikiComponent:AddListenWikiId(Dialogue.RelatedWikiId)
	end
end

function FDialogueNode:GenerateNextNodes()
	--对于既有NextDialogue，也有NextOptions的Dialogue节点，创建一个分支节点
	if self.NextDialogue and self.NextOptions then
		local DialogueId = self.Dialogue.DialogueId
		local NextNode = self.IterGraph:GetOrCreateNode("CheckOptionCondition", DialogueId)
		self:SetOutPort(EDialogueIterType.Out, NextNode)
		return
	end
	--对于普通Dialogue节点，下个节点也是Dialogue节点
	if self.NextDialogue then
		local DialogueId = self.NextDialogue
		local NextNode = self.IterGraph:GetOrCreateNode("Dialogue", DialogueId)
		self:SetOutPort(EDialogueIterType.Out, NextNode)
	--对于带有选项的Dialogue节点，创建一个Option节点并连接
	elseif self.NextOptions then
		local DialogueId = self.Dialogue.DialogueId
		local NextOptionNode = self.IterGraph:GetOrCreateNode("Option", DialogueId)
		self:SetOutPort(EDialogueIterType.Out, NextOptionNode)
	--NextDialogue与NextOptions都为空的节点，直接连接End节点
	else
		if self.FinalDialogue then
			local NextNode = self.IterGraph:GetOrCreateNode("Dialogue", self.FinalDialogue)
			self:SetOutPort(EDialogueIterType.Final, NextNode)
		else
			local NextNode = self.IterGraph:GetOrCreateNode("End")
			self:SetOutPort(EDialogueIterType.Out, NextNode)
		end
	end
end

function FDialogueNode:Enter(bSkip)
	FDialogueNode.Super.Enter(self, bSkip)
	self:Record()
end

function FDialogueNode:Execute(bSkip)
	-- DebugPrint("lhr@Execute: DialogueNode")
	self.TalkTask:PlayDialogue(nil, bSkip)
end

function FDialogueNode:Pause()
	-- DebugPrint("lhr@Resume: DialogueNode")
	self.bPaused = true
end

function FDialogueNode:Resume()
	-- DebugPrint("lhr@Resume: DialogueNode")
	self.bPaused = false
	if self.bDone then
		self:Iterate(table.unpack(self.IterateArgs))
	else
		self.TalkTask:PlayDialogue(true)
	end
end

function FDialogueNode:Iterate(...)
	if self.bPaused then
		self.bDone = true
		self.IterateArgs = {...}
		return
	end
	FDialogueNode.Super.Iterate(self, ...)
end

function FDialogueNode:RealSkip()
	self.TalkTask:SkipDialogue()
end

function FDialogueNode:Record()
	FDialogueNode.Super.Record(self)
	self.DialogueRecordComponent:OnDialogueRecord(self.Dialogue.DialogueId, self.Dialogue)
end

return FDialogueNode
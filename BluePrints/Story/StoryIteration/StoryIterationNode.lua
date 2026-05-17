local EDialogueIterType = require "BluePrints.Story.Talk.View.TalkUtils".EDialogueIterType

local FStoryIterationNode = Class()

function FStoryIterationNode:New(Dialogues, DialogueId, IterGraph)
	local StoryIterationNode = setmetatable({}, {
		__index = self
	})

	StoryIterationNode:Init(Dialogues, DialogueId, IterGraph)
	-- DebugPrint("lhr@NewNode", DialogueId, self.NodeType, self)
	return StoryIterationNode
end

function FStoryIterationNode:Init(Dialogues, DialogueId, IterGraph)
	if not DialogueId or not Dialogues[DialogueId] then
		DebugPrint("lhr@FStoryIterationNode:Init, Dialogue is nil, DialogueId: ", DialogueId, self.NodeType)
		return
	end
	self.IterGraph = IterGraph
	self.Dialogues = Dialogues
	local TalkTask = IterGraph.TalkTask
	self.TalkTask = TalkTask
	self.DialogueWikiComponent = TalkTask.DialogueWikiComponent
	self:CreateNodeData(DialogueId)
	self.DialogueRecordComponent = TalkTask.DialogueRecordComponent
	self.NextNodeMap = {}
	self:GenerateNextNodes()
end

function FStoryIterationNode:Enter(bSkip)
	self.IterGraph:OnNodeEnter(self)
	self:Execute(bSkip)
end

function FStoryIterationNode:Record(...)
	if self.bRecorded then
		return
	end
	self.bRecorded = true
end

-- function FStoryIterationNode:OnNodeRecord(...)
-- end
function FStoryIterationNode:Execute(bSkip)
	--待子类中实现
end

function FStoryIterationNode:Pause()
	--待子类中实现
end

function FStoryIterationNode:Resume()
	--待子类中实现
end

function FStoryIterationNode:RealSkip()
	--待子类中实现
end

function FStoryIterationNode:Skip()
	self:RealSkip()
	local NextNode = self:GetOutPort(EDialogueIterType.Out)
	if NextNode then
		NextNode:Enter(true)
	end
	return false
end

function FStoryIterationNode:CreateNodeData(DialogueId)
	--待子类中实现
end

function FStoryIterationNode:GenerateNextNodes()
	--待子类中实现
end

function FStoryIterationNode:SetOutPort(OutPortName, IterNode)
	self.NextNodeMap[OutPortName] = IterNode
end

function FStoryIterationNode:GetOutPort(OutPortName)
	return self.IterGraph:GetDesiredNode(self.NextNodeMap[OutPortName])
end

function FStoryIterationNode:Iterate(...)
	local OutPortName = ... or EDialogueIterType.Out
	local NextNode = self:GetOutPort(OutPortName)
	if NextNode then
		NextNode:Enter()
	end
end

function FStoryIterationNode:GetType()
	return self.NodeType
end

function FStoryIterationNode:GetDesiredNode()
	return self
end

return FStoryIterationNode
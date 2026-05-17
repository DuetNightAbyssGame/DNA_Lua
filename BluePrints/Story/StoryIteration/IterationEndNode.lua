local EDialogueNodeType = require "BluePrints.Story.Talk.View.TalkUtils".EDialogueNodeType

local FIterationEndNode = Class({"BluePrints.Story.StoryIteration.StoryIterationNode"})

FIterationEndNode.NodeType = EDialogueNodeType.End

function FIterationEndNode:Init(IterGraph)
	self.IterGraph = IterGraph
	self.TalkTask = IterGraph.TalkTask
end

function FIterationEndNode:Execute(bSkip)
	-- DebugPrint("lhr@Execute: EndNode")
	if bSkip then
		return
	end
	self.TalkTask:EndDialogue()
end

function FIterationEndNode:Iterate(...)
	local Message = "尝试在EndNode进行Iterate，对话FirstDialogue："..self.IterGraph.InitialDialogueId
    local Title = "FStoryIterationGraph迭代错误"
    UStoryLogUtils.PrintToFeiShu(self, UE.EStoryLogType.Talk, Title, Message)
end

return FIterationEndNode
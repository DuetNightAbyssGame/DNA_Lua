local EDialogueNodeType = require "BluePrints.Story.Talk.View.TalkUtils".EDialogueNodeType

local M = Class({"BluePrints.Story.StoryIteration.StoryIterationNode"})

M.NodeType = EDialogueNodeType.End

function M:BuildNode()
	--NONE
end

function M:Execute(bSkip)
	-- DebugPrint("lhr@Execute: EndNode")
	if bSkip then
		return
	end
	self.TalkTask:EndDialogue()
end

function M:Iterate(...)
	local Message = "TalkFlow:尝试在EndNode进行Iterate，对话FirstDialogue："..self.Flow.InitialDialogueId
    local Title = "FStoryIterationGraph迭代错误"
    UStoryLogUtils.PrintToFeiShu(self, UE.EStoryLogType.Talk, Title, Message)
end

return M
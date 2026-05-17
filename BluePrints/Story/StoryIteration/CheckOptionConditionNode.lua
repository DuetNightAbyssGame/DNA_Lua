
local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"
local EDialogueNodeType = TalkUtils.EDialogueNodeType
local EDialogueIterType = TalkUtils.EDialogueIterType

local Node = Class({"BluePrints.Story.StoryIteration.StoryIterationNode"})

Node.NodeType = EDialogueNodeType.CheckCondition

function Node:CreateNodeData(DialogueId)
	local Dialogue = self.Dialogues[DialogueId]

	self.DialogueId = DialogueId
	self.NextOptions = Dialogue.NextOptions
	self.NextDialogue = Dialogue.NextDialogue

	--将自身记录在Graph中，防止递归
	self.IterGraph.CheckConditionNodeMap[DialogueId] = self
end

function Node:Execute(bSkip)
	-- DebugPrint("lhr@Execute: StartNode")
	self:Iterate(bSkip)
end

function Node:Iterate(bSkip)
	local OutPortName = EDialogueIterType.Out.."Dialogue"
	for _, OptionId in pairs(self.NextOptions) do
		if self.IterGraph.TalkTriggerComponent:CheckDialogueCondition(OptionId) then
			OutPortName = EDialogueIterType.Out.."Option"
			break
		end
	end
	local NextNode = self:GetOutPort(OutPortName)
	if NextNode then
		NextNode:Enter(bSkip)
	end
end

function Node:GenerateNextNodes()
	if not self.NextDialogue or not self.NextOptions then
		DebugPrint("CheckOptionConditionNode@GenerateNextNodes: NextDialogue或NextOptions为空", self.NextDialogue, self.NextOptions)
		return
	end
	local NextNode = self.IterGraph:GetOrCreateNode("Dialogue", self.NextDialogue)
	self:SetOutPort(EDialogueIterType.Out.."Dialogue", NextNode)

	local NextOptionNode = self.IterGraph:GetOrCreateNode("Option", self.DialogueId)
	self:SetOutPort(EDialogueIterType.Out.."Option", NextOptionNode)
end

return Node
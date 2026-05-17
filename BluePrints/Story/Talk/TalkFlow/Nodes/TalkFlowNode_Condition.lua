
local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"
local EDialogueNodeType = TalkUtils.EDialogueNodeType
local EDialogueIterType = TalkUtils.EDialogueIterType

local M = Class({"BluePrints.Story.StoryIteration.StoryIterationNode"})

M.NodeType = EDialogueNodeType.CheckCondition

function M:CreateNodeData(DialogueId)
	local Dialogue = DataMgr.Dialogue[DialogueId]

	self.DialogueId = DialogueId
	self.NextOptions = Dialogue.NextOptions
	self.NextDialogue = Dialogue.NextDialogue

	--将自身记录在Graph中，防止递归
	self:RecordNodeInMap(DialogueId, self.NodeMaps)

	M.Super.CreateNodeData(self, DialogueId)
end

function M:RecordNodeInMap(DialogueId, NodeMaps)
	if not NodeMaps then return end
	local NodeMap = NodeMaps.CheckConditionNodeMap
	if NodeMap then
		rawset(NodeMap, DialogueId, self)
	end
end

function M:Execute(bSkip)
	-- DebugPrint("lhr@Execute: StartNode")
	self:Iterate(bSkip)
end

function M:CheckCondition(DialogueId)
	if not IsValid(self.StorySubSystem) then
		self.StorySubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
	end
	if not IsValid(self.StorySubSystem) then
		return false
	end
	return self.StorySubSystem:CheckDialogueCondition(DialogueId)
end

function M:Iterate(bSkip)
	local OutPortName = EDialogueIterType.Out.."Dialogue"
	for _, OptionId in pairs(self.NextOptions) do
		if self:CheckCondition(OptionId) then
			OutPortName = EDialogueIterType.Out.."Option"
			break
		end
	end
	local NextNode = self:GetOutPort(OutPortName)
	if NextNode then
		NextNode:Enter(bSkip)
	end
end

function M:GenerateNextNodes()
	if not self.NextDialogue or not self.NextOptions then
		DebugPrint("CheckOptionConditionNode@GenerateNextNodes: NextDialogue或NextOptions为空", self.NextDialogue, self.NextOptions)
		return
	end
	local NextNode = self:CreateNextNode("Dialogue", self.NextDialogue)
	self:SetOutPort(EDialogueIterType.Out.."Dialogue", NextNode)

	local NextOptionNode = self:CreateNextNode("Option", self.DialogueId)
	self:SetOutPort(EDialogueIterType.Out.."Option", NextOptionNode)
end

return M
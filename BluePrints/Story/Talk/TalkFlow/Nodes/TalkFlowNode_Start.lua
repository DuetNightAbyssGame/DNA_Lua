local EDialogueNodeType = require "BluePrints.Story.Talk.View.TalkUtils".EDialogueNodeType
local EDialogueIterType = require "BluePrints.Story.Talk.View.TalkUtils".EDialogueIterType

local M = Class({"BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode"})

M.NodeType = EDialogueNodeType.Start

function M:BuildNode(InitialDialogueId, Comps)
	rawset(self, "NextDialogueId", InitialDialogueId)
	rawset(self, "DialogueRecordComponent", Comps.RecordComp)
	self:CreateNextNodeMap()
	if self.OnNodeCreated then
		self.OnNodeCreated(self.EventReceiver, self)
	end
	self:GenerateNextNodes()
end

function M:Execute()
	-- DebugPrint("lhr@Execute: StartNode")
	self:Record()
	self:Iterate()
end

function M:RealSkip()
	self:Record()
end

function M:Record(...)
	M.Super.Record(self, ...)
	if self.DialogueRecordComponent then
		self.DialogueRecordComponent:OnTalkStart(self.NextDialogueId)
	end
end

function M:GenerateNextNodes()
	if self.NextDialogueId then
		local DialogueId = self.NextDialogueId
		local NextNode = self:CreateNextNode("Dialogue", DialogueId)
		self:SetOutPort(EDialogueIterType.Out, NextNode)
	end
end

return M
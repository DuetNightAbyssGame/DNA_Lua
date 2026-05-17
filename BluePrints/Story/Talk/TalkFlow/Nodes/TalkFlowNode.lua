local EDialogueIterType = require "BluePrints.Story.Talk.View.TalkUtils".EDialogueIterType
local TalkFlowUTils = require "BluePrints.Story.Talk.TalkFlow.TalkFlowUTils"

local M = Class()

function M:New(DialogueId, TalkTask, Comps, NodeMaps, Events)
	local TalkFlowNode = setmetatable({}, {
		__index = self
	})
	rawset(TalkFlowNode, "TalkTask", TalkTask)
	rawset(TalkFlowNode, "Comps", Comps)
	rawset(TalkFlowNode, "NodeMaps", NodeMaps)
	rawset(TalkFlowNode, "Events", Events)
	-- DebugPrint("lhr@NewNode", DialogueId, self.NodeType, self)
	TalkFlowNode:BindNodeEvents(Events)
	TalkFlowNode:BuildNode(DialogueId, Comps)
	return TalkFlowNode
end

function M:CreateNextNodeMap()
	rawset(self, "NextNodeMap", {})
end

function M:BuildNode(DialogueId)
	if not DialogueId or not DataMgr.Dialogue[DialogueId] then
		DebugPrint("FTalkFlowNode:BuildNode, Dialogue is nil, DialogueId: ", DialogueId, self.NodeType)
		return
	end
	self:CreateNextNodeMap()
	self:CreateNodeData(DialogueId)

	self:GenerateNextNodes()
end

function M:Enter(bSkip)
	if self.OnNodeEnter then
		self.OnNodeEnter(self.EventReceiver, self)
	end
	self:Execute(bSkip)
end

function M:Record(...)
	if self.bRecorded then
		return
	end
	self.bRecorded = true
end

function M:Execute(bSkip)
	--待子类中实现
end

function M:Pause()
	--待子类中实现
end

function M:Resume()
	--待子类中实现
end

function M:RealSkip()
	--待子类中实现
end

function M:AllowSkip()
	return true
end

function M:Skip()
	if not self:AllowSkip() then
		return false
	end
	self:RealSkip()
	local NextNode = self:GetOutPort(EDialogueIterType.Out)
	if NextNode then
		NextNode:Enter(true)
	end
	return false
end

function M:RecordNodeInMap(DialogueId, NodeMaps)
	--待子类中实现
end

function M:BindNodeEvents(Events)
    self.EventReceiver = Events.EventReceiver
    self.OnNodeEnter = Events.OnNodeEnter
    self.OnNodeCreated = Events.OnNodeCreated
    self.OnFlowCreated = Events.OnFlowCreated
end

function M:CreateNodeData(DialogueId)
	if self.OnNodeCreated then
		self.OnNodeCreated(self.EventReceiver, self)
	end
end

function M:GenerateNextNodes()
	--待子类中实现
end

function M:CreateNextNode(NodeType, DialogueId)
	return TalkFlowUTils:GetOrCreateNode(NodeType, DialogueId, self.TalkTask, self.Comps, self.NodeMaps, self.Events)
end

function M:SetOutPort(OutPortName, IterNode)
	self.NextNodeMap[OutPortName] = IterNode
end

function M:GetOutPort(OutPortName)
	return self.NextNodeMap[OutPortName] and self.NextNodeMap[OutPortName]:GetDesiredNode()
end

function M:Iterate(...)
	local OutPortName = ... or EDialogueIterType.Out
	local NextNode = self:GetOutPort(OutPortName)
	if NextNode then
		NextNode:Enter()
	end
end

function M:GetType()
	return self.NodeType
end

function M:GetDesiredNode()
	return self
end

return M
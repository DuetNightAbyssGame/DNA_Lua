local EDialogueNodeType = require "BluePrints.Story.Talk.View.TalkUtils".EDialogueNodeType
local EDialogueIterType = require "BluePrints.Story.Talk.View.TalkUtils".EDialogueIterType
local TalkFlowUTils = require "BluePrints.Story.Talk.TalkFlow.TalkFlowUTils"

local M = {}

function M:New(FlowId, TalkTask, Comps) 
	local TalkFlow = setmetatable({}, {
		__index = M
	})
	rawset(TalkFlow, "FlowId", FlowId)
	TalkFlow:BuildFlow(FlowId, TalkTask, Comps)
	return TalkFlow
end

function M:CreateNodeMaps()
	rawset(self, "CheckConditionNodeMap", {})
	rawset(self, "DialogueNodeMap", {})
	rawset(self, "OptionNodeMap", {})
end

function M:BuildFlow(FirstDialogueId, TalkTask, Comps)
	if not FirstDialogueId or not DataMgr.Dialogue[FirstDialogueId] then
		DebugPrint("FTalkFlow:BuildFlow, FirstDialogueId is Invalid", FirstDialogueId)
		return
	end
	if not TalkTask then
		DebugPrint("FTalkFlow:BuildFlow, TalkTask is nil", FirstDialogueId)
		return
	end
	self:CreateNodeMaps()
	local NodeMaps = {
		CheckConditionNodeMap = self.CheckConditionNodeMap,
		DialogueNodeMap = self.DialogueNodeMap,
		OptionNodeMap = self.OptionNodeMap,
	}
	local NodeEvents = {
		EventReceiver = self,
		OnNodeEnter = self.OnNodeEnter,
		OnNodeCreated = self.OnNodeCreated,
		OnFlowCreated = self.OnFlowCreated,
	}
	self.EndNode = TalkFlowUTils:GetOrCreateNode("End", nil, nil, nil, nil, NodeEvents)
	self.StartNode = TalkFlowUTils:GetOrCreateNode("Start", FirstDialogueId, TalkTask, Comps, NodeMaps, NodeEvents)
	self.CurrentNode = self.StartNode
end

function M:Start()
	if self.CurrentNode then
		self.CurrentNode:Execute()
	else
		DebugPrint("FTalkFlow:Start(),CurrentNode is nil")
	end
end

function M:Iterate(...)
	if self.CurrentNode then
		self.CurrentNode:Iterate(...)
	else
		DebugPrint("FTalkFlow:Iterate(),CurrentNode is nil", ...)
	end
end

function M:Pause()
	if self.CurrentNode then
		self.CurrentNode:Pause()
	else
		DebugPrint("FTalkFlow:Pause(),CurrentNode is nil")
	end
end

function M:Resume()
	if self.CurrentNode then
		self.CurrentNode:Resume()
	else
		DebugPrint("FTalkFlow:Resume(),CurrentNode is nil")
	end
end

function M:Skip()
	local bSkipFail = self.CurrentNode:Skip()
	return not bSkipFail
end

function M:End()
	if self.OnEndDelegate then
		self.OnEndDelegate()
	end
	self:Clear()
end

function M:Clear()

end

function M:OnNodeEnd(...)

end

function M:BindDelegateOnEnd(Func)
	self.OnEndDelegate = Func
end

function M:OnNodeCreated(Node)
	if Node:GetType() == EDialogueNodeType.Option then
		if Node.RestartTag then
			self:SetRestartTag(Node.RestartTag)
		end
	end
end

function M:BindOnFlowCreatedEvent(Event)
	self.OnFlowCreatedEvent = Event
end

function M:OnFlowCreated(Flow, ParallelNode, WaitAllNode)
	if self.OnFlowCreatedEvent then
		self.OnFlowCreatedEvent(Flow, ParallelNode, WaitAllNode)
	end
end

function M:OnNodeEnter(Node)
	if not Node then
		DebugPrint("FTalkFlow:OnNodeEnter: Node无效")
		return
	end
	if self.CurrentNode == Node then
		DebugPrint("FTalkFlow:OnNodeEnter: 重复进入节点")
		return
	end
	self.CurrentNode = Node
end

function M:GetCurrentNode()
	return self.CurrentNode
end

function M:GetDialogue()
	if (self:IsInText() == false) then
		return nil
	end
	return self.CurrentNode.Dialogue
end

function M:GetSavedOptions()
	if (self:IsInOption() == false) then
		return nil
	end

	return self.CurrentNode and self.CurrentNode.LastSelectedId
end

function M:GetOptions()
	if (self:IsInOption() == false) then
		return nil
	end

	return self.CurrentNode and self.CurrentNode:GetOptions()
end

function M:IsInImpression()
	return self.CurrentNode and self.CurrentNode.IsImpression
end

function M:IsInText()
	return self.CurrentNode and self.CurrentNode:GetType() == EDialogueNodeType.Dialogue
end

function M:IsInOption()
	return self.CurrentNode and self.CurrentNode:GetType() == EDialogueNodeType.Option
end

function M:IsStart()
	return self.CurrentNode and self.CurrentNode:GetType() == EDialogueNodeType.Start
end

function M:IsEnd()
	return self.CurrentNode and self.CurrentNode:GetType() == EDialogueNodeType.End
end

function M:IsLastText()
	if not self:IsInText() then
		return false
	end
	local NextNode = self.CurrentNode:GetOutPort(EDialogueIterType.Out)
	if not NextNode then
		return false
	end
	return NextNode:GetType() == EDialogueNodeType.End
end

function M:IsLastAndOnlyOption()
	if not self:IsInOption() then
		return false
	end
	local Options = self:GetOptions()
	if not Options or #self:GetOptions() ~= 1 then
		return false
	end
	local NextNode = self.CurrentNode:GetOutPort(EDialogueIterType.Option..1)
	if not NextNode then
		return false
	end
	return NextNode:GetType() == EDialogueNodeType.End
end

function M:IsSelectedOption(OptionId)
	local CurrentNode = self.CurrentNode
	if not CurrentNode or CurrentNode:GetType() ~= EDialogueNodeType.Option then
		return false
	end

	return CurrentNode.VisitedOptions[OptionId]
end

function M:HasFinalDialogue()
	local CurrentNode = self.CurrentNode
	if not CurrentNode or CurrentNode:GetType() ~= EDialogueNodeType.Option then
		return false
	end
	return CurrentNode:HasFinalDialogue()
end

function M:GetCurrentNodeType()
	return self.CurrentNode and self.CurrentNode.NodeType
end

function M:SetRestartTag(RestartDialogueId)
	self.RestartDialogueId = RestartDialogueId
end

function M:GetRestartTag()
	return self.RestartDialogueId
end

return M
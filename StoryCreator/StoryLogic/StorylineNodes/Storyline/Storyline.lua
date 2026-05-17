
local StorylineUtils = require 'StoryCreator.StoryLogic.StorylineUtils'
local STLogType = UE.EStoryLogType.STL

---@class Storyline
local Storyline = Class('StoryCreator.StoryLogic.StorylineNodes.Storyline.BaseStoryline')

---@param Payload table<string, any>
function Storyline:Init(StorylineData, FileName, EndCallback, StopCallback, Payload)
	Storyline.Super.Init(self, StorylineData, FileName, EndCallback, StopCallback, Payload)
	self.Data = StorylineData
	self.FileName = FileName
	self.FilePath = FileName
	self.EndCallback = EndCallback
	self.StopCallback = StopCallback
	self.Payload = Payload
	self:TimerInit()
	self.WaitingRestartNodeList = {}
	self.RunningNodeList = {}
	self.bLockRunningNodeList = false
	self:BuildStoryline()
end

function Storyline:GetPayload(Key)
	return self.Payload and self.Payload[Key]
end

function Storyline:AddPayload(Key, Value)
	if not self.Payload then
		self.Payload = {}
	end
	self.Payload[Key] = Value
end

function Storyline:BuildStoryline()
	for NodeId, NodeData in pairs(self.Data.storyNodeData) do
		local Node = StorylineUtils.CreateStoryNode(NodeData.type, self)
		if Node.IsStartNode then
			self:SetStartNode(Node)
		elseif Node.IsEndNode then
			self:SetEndNode(Node)
		elseif Node.IsSuccessNode then
			self:SetSuccessNode(Node)
		elseif Node.IsFailNode then
			self:SetFailNode(Node)
		end
		Node:BuildNode(NodeId, NodeData, nil)
		self:AddNode(NodeId, Node)
	end

	if not self:GetStartNode() then
		local Message = "任务链没有StartStoryNode连线"..
        "\nFileName:"..self.FileName
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务链没有StartStoryNode连线", Message)
		--DebugPrint('BuildStoryline StartNode is Empty')
		return
	end

	self.QuestChainId = self._StartNode.QuestChainId or 0

	DebugPrint('StorylineBuilder BuildStoryline QuestChainId', self.QuestChainId)

	self:BuildAdjacencyMap(self.Data.lineData, "startStory", "endStory")

	self.QuestIdNodeList = {}
	for _, Node in pairs(self:GetNodes()) do
		if Node.QuestId then
			self.QuestIdNodeList[Node.QuestId] = Node
		end
	end

end

function Storyline:StartStory(QuestId, NodeId)
	DebugPrint('Storyline StartStory QuestId:', QuestId, ",NodeId:", NodeId)
	if self.HasStarted then
		self.StartedNode = self.QuestIdNodeList[QuestId]
		self:StartNode(self.StartedNode, NodeId)
		return
	end

	if QuestId and QuestId ~= 0 then
		self.StartedNode = self.QuestIdNodeList[QuestId]
		if not self.StartedNode then
			local Message = "任务Id不存在"..
			"\nFileName:"..self.FileName..
			"\nQuestChainId:"..self.QuestChainId..
			"\nQuestId:"..QuestId
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务Id不存在", Message)
			--DebugPrint('Storyline StartStory QuestId Not Exist!!!!!!!!!!!!!!!!!!!!', self.QuestChainId, QuestId)
			self:FinishStory()
			return
		end

		if self.QuestChainId and self.QuestChainId ~= 0 then
			local Avatar = GWorld:GetAvatar()
			if Avatar:IsQuestFinished(QuestId) then
				self.StartedNode:Finish("Success")
				return
			end
		end
	else
		self.StartedNode = self._StartNode
	end

	DebugPrint('Storyline Start', self.QuestChainId)

	self.RunningNodeList = {}
	self.HasStarted = true
	self.HasFinished = false

	self:StartNode(self.StartedNode, NodeId)
end

function Storyline:StartNode(Node, NodeId)
	if self.HasFinished then
		local Message = string.format("FileName: %s\nNodeInfo: %s", self.FileName, Node:ToString())
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "Storyline 已结束，开始节点失败", Message)
		return
	end

	if (self.bLockRunningNodeList) then
		local Message = string.format("FileName: %s\nNodeInfo: %s", self.FileName, Node:ToString())
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务链已锁定，开始节点失败", Message)
		return
	end

	if Node.HasStarted then
		local Message = string.format("FileName: %s\nNodeInfo: %s", self.FileName, Node:ToString())
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "节点已开始，开始节点失败", Message)
		return
	end

	if Node.QuestId then
		GWorld.StoryMgr:TryRemoveStoryBlackScreenOnSucc(self.QuestChainId, Node.QuestId)
	end

	Node.HasStarted = true
	Node.HasFinished = false
	self.RunningNodeList[Node.Key] = Node

	DebugPrint('----------------------------------------------------------StartNode ', Node:ToString())
	Node:Start(self, NodeId)
end

function Storyline:FinishNode(Node, OutPortNames, Result)
	if self.HasFinished then
		local Message = string.format("FileName: %s\nNodeInfo: %s", self.FileName, Node:ToString())
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "Storyline 已结束，完成节点失败", Message)
		return
	end

	if (self.bLockRunningNodeList) then
		local Message = string.format("FileName: %s\nNodeInfo: %s", self.FileName, Node:ToString())
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务链已锁定，完成节点失败", Message)
		return
	end

	if Node.HasFinished then
		local Message = string.format("FileName: %s\nNodeInfo: %s", self.FileName, Node:ToString())
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "节点已完成，完成节点失败", Message)
		return
	end

	Node.HasFinished = true
	Node.HasStarted = false
	self.RunningNodeList[Node.Key] = nil

	DebugPrint('----------------------------------------------------------FinishNode', Result, Node:ToString())

	-- PrintTable({s=1,OutPortName=OutPortName, Result=Result,Q=self.QuestChainId})
	if Node == self._EndNode then
		self:FinishStory()
		return
	end

	-- 非任务系统，继续跑
	if not self.QuestChainId or self.QuestChainId == 0 then
		local HaveFailOutPort = self:CheckHaveOutPort(OutPortNames, "Fail")
		local HaveNextNode = self:CheckHaveNextNode(Node, OutPortNames)
		if Result == false and HaveNextNode == false and HaveFailOutPort then
			self:StartNode(self._EndNode)
		else
			for _, OutPortName in pairs(OutPortNames) do
				local NodeInfoList = self:GetNextNodeInfoListByPortName(Node, OutPortName)
				if NodeInfoList then
					for _, NextNodeInfo in pairs(NodeInfoList) do
						local NextNode = NextNodeInfo.Node
						self:StartNode(NextNode)
					end
				end
			end
		end
	-- 如果是任务
	else
		-- 失败了重跑，成功了不管，由服务器通知
		if not Result then
			-- 任务失败重新跑任务
			-- Node.HasFinished = false
			-- self:StartNode(Node, nil)
			-- 任务失败等待区域数据恢复
			self:AddToWaitingRestartNodeList(Node)
			GWorld.StoryMgr:AddToWaitingRestartList(self)
			if Node.bIsPlayBlackScreenOnFail then
				GWorld.StoryMgr:AddStoryBlackScreenOnFail()
			end
		else
			if Node.bIsPlayBlackScreenOnComplete then
				local WaitingQuest = {}
				local QuestChainInfo = DataMgr.STLExportQuestChain[self.QuestChainId]
				if Node.QuestId == QuestChainInfo.EndQuestId then
					local QuestChainCInfo = DataMgr.ConditionId2QuestChainId[self.QuestChainId]
					if QuestChainCInfo then
						for QuestChainId, value in pairs(QuestChainCInfo) do
							local Avatar = GWorld:GetAvatar()
							local QuestChain = Avatar.QuestChains:GetQuestChain(QuestChainId)
							if QuestChain.IfAutoStart then
								table.insert(WaitingQuest, QuestChainId)
							end
						end
					end
				else
					local nextQuestInfo = QuestChainInfo.Quests[Node.QuestId]
					local nextQuestId = nextQuestInfo.nextQuestId
					table.insert(WaitingQuest, nextQuestId)
				end
				GWorld.StoryMgr:AddStoryBlackScreenOnSucc(WaitingQuest)
			end
		end
	end
end

function Storyline:FinishStory()
	if self.HasFinished then
		local Message = "任务链已结束"..
		"\nFileName:"..self.FileName..
		"\nQuestChainId:"..self.QuestChainId
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务链已结束", Message)
		--DebugPrint('Storyline Has Finished!!!!!!!!!!!!', self.QuestChainId)
		return
	end

	self:ClearStory()

	self.HasFinished = true
	self.HasStarted = false

	DebugPrint('Storyline Finish', self.QuestChainId)

	if self.EndCallback then
		self:EndCallback()
	end

	GWorld.StoryMgr:FinishStory(self.FilePath)
end

function Storyline:ClearStory(IgnoreFinishClear)
	self.bLockRunningNodeList = true
	local RunningNodes = {}
	for _, Node in pairs(self.RunningNodeList) do
		table.insert(RunningNodes, Node)
	end

	for _, Node in pairs(RunningNodes) do
		if Node.StopQuest then
			Node:StopQuest(IgnoreFinishClear)
		end
	end
	self.bLockRunningNodeList = false
	self.RunningNodeList = {}
	self.WaitingRestartNodeList = {}
end

function Storyline:Stop(IgnoreFinishClear)
	self:ClearStory(IgnoreFinishClear)

	self.HasFinished = true
	self.HasStarted = false

	if self.StopCallback then
		self:StopCallback()
	end
end

function Storyline:Success()
	for _, StoryNode in pairs(self.RunningNodeList) do
		if (StoryNode.SuccessQuest) then
			StoryNode:SuccessQuest()
		end
	end
end

function Storyline:PrintInfo()
	DebugPrint('---------------------------StorylineInfo---------------------------')
	DebugPrint('QuestchainId: ', self.QuestChainId)
	for _, StoryNode in pairs(self.RunningNodeList) do
		if (StoryNode.PrintInfo) then
			StoryNode:PrintInfo()
		end
	end
	DebugPrint('---------------------------StorylineInfo---------------------------')
end

function Storyline:TimerInit()
	if self.TimerHandles == nil then
		self.TimerHandles = {}
		self.TimerKeyIdx = 0
	end
end

function Storyline:GetTimerSource(IsRealTime)
    if IsRealTime then 
        return URuntimeCommonFunctionLibrary
    else
        return UE4.UKismetSystemLibrary
    end
end

function Storyline:StopStory()
	GWorld.StoryMgr:StopStoryline(self.FilePath)
end

function Storyline:CheckHaveNextNode(Node, OutPortNames)
	for _, OutPortName in pairs(OutPortNames) do
		local NodeInfoList = self:GetNextNodeInfoListByPortName(Node, OutPortName)
		if NodeInfoList then
			return true
		end
	end
	return false
end

function Storyline:CheckHaveOutPort(OutPortNames, TargetOutPortName)
	for _, OutPortName in pairs(OutPortNames) do
		if OutPortName == TargetOutPortName then
			return true
		end
	end
	return false
end

function Storyline:AddToWaitingRestartNodeList(Node)
	self.WaitingRestartNodeList[Node.Key] = Node
end

function Storyline:RestartNodes()
	local WaitingRestartNodes = {}
	for _, Node in pairs(self.WaitingRestartNodeList) do
		table.insert(WaitingRestartNodes, Node)
	end
	for _,Node in pairs(WaitingRestartNodes) do
		DebugPrint('Storyline RestartNode')
		Node.HasFinished = false
		self:StartNode(Node, nil)
	end
	self.WaitingRestartNodeList = {}
end

return Storyline

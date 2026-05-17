local StorylineUtils = require 'StoryCreator.StoryLogic.StorylineUtils'

local Questline = Class('StoryCreator.StoryLogic.StorylineNodes.Storyline.BaseStoryline')
local STLogType = UE.EStoryLogType.STL

function Questline:Init(QuestlineData, Storyline, StoryNode)
	-- PrintTable({QuestlineData=QuestlineData, Storyline=Storyline, StoryNode=StoryNode})
	Questline.Super.Init(self, QuestlineData, Storyline, StoryNode)
	-- print('Questline __init__')
	self.Data = QuestlineData
	self.Storyline = Storyline
	self.StoryNode = StoryNode
	self.QuestChainId = Storyline.QuestChainId
	self.FileName = Storyline.FileName
	self.FilePath = Storyline.FilePath
	self.QuestData = QuestlineData.propsData
	self.QuestId = self.QuestData.QuestId
	self.QuestData.QuestChainId = self.QuestChainId
	self.RunningNodeList = {}
	self.bLockRunningNodeList = false
	self.FinishedNodeList = {}
	self.STLData = {}
	self:BuildQuestline()
end

function Questline:BuildQuestline()
	for NodeId, NodeData in pairs(self.Data.questNodeData.nodeData) do
		local Node = StorylineUtils.CreateQuestNode(NodeData.type, self)
		if Node.IsStartNode then
			self:SetStartNode(Node)
		elseif Node.IsEndNode then
			self:SetEndNode(Node)
		elseif Node.IsSuccessNode then
			self:SetSuccessNode(Node)
		elseif Node.IsFailNode then
			self:SetFailNode(Node)
		end
		Node:BuildNode(NodeId, NodeData, self.QuestData)
		-- PrintTable({NodeId=NodeId,Node=Node})
		self:AddNode(NodeId, Node)
		-- self.QuestNodeList[Key] = Node
	end
	
	if not self:GetStartNode() then
		local Message = "任务没有StartNode连线"..
        "\nFileName:"..self.FileName..
        "\nQuestChainId:"..self.QuestChainId..
        "\nQuestId:"..self.QuestId..
        "\nStoryNodeKey:"..self.Data.key
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务没有StartNode连线", Message)
		--DebugPrint('BuildQuestline StartNode is Empty')
		return
	end

	self:BuildAdjacencyMap(self.Data.questNodeData.lineData, "startQuest", "endQuest")

	self.HasStarted = false
	self.HasFinished = true
end

function Questline:StartQuest(NodeId)
	if self.Storyline.HasFinished then
		local Message = "开始任务时，任务链已结束"..
		"\nFileName:"..self.FileName..
		"\nQuestChainId:"..self.QuestChainId..
		"\nQuestId:"..self.QuestId..
		"\nStoryNodeKey:"..self.Data.key
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "开始任务时，任务链已结束", Message)
		--DebugPrint('Storyline Has Finished', self.QuestId)
		return
	end

	if self.HasStarted then
		local Message = "任务已开始"..
		"\nFileName:"..self.FileName..
		"\nQuestChainId:"..self.QuestChainId..
		"\nQuestId:"..self.QuestId..
		"\nStoryNodeKey:"..self.Data.key
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务已开始", Message)
		--DebugPrint('Questline Has Started!!!!!!!!!!!!', self.QuestId)
		return
	end

	if NodeId and NodeId ~= 0 then
		self.StartedNode = self:GetNode(NodeId)
		if not self.StartedNode then
			local Message = "NodeId不存在"..
			"\nFileName:"..self.FileName..
			"\nQuestChainId:"..self.QuestChainId..
			"\nQuestId:"..self.QuestId..
			"\nStoryNodeKey:"..self.Data.key..
			"\nQuestNodeKey:"..NodeId
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "NodeId不存在", Message)
			--DebugPrint('Questline NodeId Not Exist!!!!!!!!!!!!!!!!!!!!', self.QuestChainId, self.QuestId, NodeId)
			return
		end
	else
		self.StartedNode = self._StartNode
	end

	DebugPrint('Questline Start', self.QuestId)

	self.RunningNodeList = {}
	self.HasStarted = true
	self.HasFinished = false
	self:HandleActivateSkill(self.QuestId, "Start")
	self:StartNode(self.StartedNode)
end

function Questline:HandleActivateSkill(QuestId, QuestLineState)
	local QuestActiveSkillConfig = DataMgr.QuestActiveSkill[QuestId]
	if not QuestActiveSkillConfig then
		return
	end
	if QuestActiveSkillConfig.QuestStartorSuccess ~= QuestLineState then
		return
	end
	local Controller = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
	local PlayerController = Controller:Cast(UE4.ASinglePlayerController)
	local ActivateHandle = QuestActiveSkillConfig.InactiveorActive == "Active"
	if QuestActiveSkillConfig.ActiveType == "Lock" then
		local SkillNamesArray = TArray(0)
		for _, SkillType in pairs(QuestActiveSkillConfig.SkillId) do
			if PlayerController:CheckSkillInActive(ESkillName[SkillType]) then
				if ActivateHandle then
					SkillNamesArray:Add(ESkillName[SkillType])
				end
			elseif not ActivateHandle then
				SkillNamesArray:Add(ESkillName[SkillType])
			end
		end
		if ActivateHandle then
			PlayerController:ActiveSkills(SkillNamesArray, "UnLock")
		else
			PlayerController:InActiveSkills(SkillNamesArray, "Lock")
		end
	else
		local SkillNamesArray = TArray(0)
		for _, SkillType in pairs(QuestActiveSkillConfig.SkillId) do
			if PlayerController:CheckSkillInActive(ESkillName[SkillType]) then
				if ActivateHandle then
					SkillNamesArray:Add(ESkillName[SkillType])
				end
			elseif not ActivateHandle then
				SkillNamesArray:Add(ESkillName[SkillType])
			end
		end
		if ActivateHandle then
			PlayerController:UnEmptySkills(SkillNamesArray)
		else
			PlayerController:EmptySkills(SkillNamesArray)
		end
	end
end

function Questline:StartNode(NextNode, InportInfo)
	if self.Storyline.HasFinished then
		local Message = string.format("FileName: %s\nNodeInfo: %s", self.FileName, NextNode:ToString())
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "Storyline 已结束，开始节点失败", Message)
		return
	end

	if self.HasFinished then
		local Message = string.format("FileName: %s\nNodeInfo: %s", self.FileName, NextNode:ToString())
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "Questline 已结束，开始节点失败", Message)
		return
	end

	if (self.bLockRunningNodeList) then
		local Message = string.format("FileName: %s\nNodeInfo: %s", self.FileName, NextNode:ToString())
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "Questline 已锁定，开始节点失败", Message)
		return
	end

	if (NextNode.HasStopped) then
		--local Message = "开始QuestNode时，任务节点已标记为停止" .. "\nFileName:" .. self.FileName .. "\nNodeInfo:" .. NextNode:ToString()
		--UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, "开始QuestNode时，任务节点已标记为停止", Message)
		return
	end

	if (InportInfo == "Stop") then
		NextNode.HasStopped = true

		DebugPrint('----------------------------------------------------------StopNode ', NextNode:ToString())
		NextNode:Stop()
	else
		NextNode.HasStarted = true
		NextNode.HasFinished = false
		self.RunningNodeList[NextNode.Key] = NextNode

		DebugPrint('----------------------------------------------------------StartNode ', NextNode:ToString())
		self:TryAddAfterSpecialQuestFailMark(NextNode)
		NextNode:Start(self, InportInfo)
	end
end

function Questline:FinishNode(Node, OutPortNames, Result)
	if self.Storyline.HasFinished then
		local Message = string.format("FileName: %s\nNodeInfo: %s", self.FileName, Node:ToString())
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "Storyline 已结束，完成节点失败", Message)
		return
	end

	if self.HasFinished then
		local Message = string.format("FileName: %s\nNodeInfo: %s", self.FileName, Node:ToString())
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "Questline 已结束，完成节点失败", Message)
		return
	end

	if (self.bLockRunningNodeList) then
		local Message = string.format("FileName: %s\nNodeInfo: %s", self.FileName, Node:ToString())
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "Questline 已锁定，完成节点失败", Message)
		return
	end

	if Node.HasFinished then
		local Message = string.format("FileName: %s\nNodeInfo: %s", self.FileName, Node:ToString())
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "QuestNode 已结束", Message)
		return
	end

	DebugPrint('----------------------------------------------------------FinishNode', Result, Node:ToString())

	Node.HasFinished = true
	Node.HasStarted = false
	table.insert(self.FinishedNodeList, Node)
	self.RunningNodeList[Node.Key] = nil

	if Node == self._SuccessNode then
		self:FinishQuest("Success", true)
		return
	elseif Node == self._FailNode then
		self:FinishQuest("Fail", false)
		return
	elseif Node.bIsConditionNode then
		self:FinishQuest(Node:GetPortName(), true)
		return
	end

	for _, OutPortName in pairs(OutPortNames) do
		local NodeInfoList = self:GetNextNodeInfoListByPortName(Node, OutPortName)
		if NodeInfoList then
			for _, NextNodeInfo in pairs(NodeInfoList) do
				if self.HasFinished then
					DebugPrint('OutPort Have Multiple Connections,But Questline Is Finished. nNodeInfo:', Node:ToString())
					return
				end
				local NextNode = NextNodeInfo.Node
				local InPortName = NextNodeInfo.InPortName
				self:StartNode(NextNode, InPortName)
			end
		end
	end
end

function Questline:FinishQuest(OutPortName, bSucceeded)
	if self.Storyline.HasFinished then
		local Message = "结束任务时，任务链已结束"..
		"\nFileName:"..self.FileName..
		"\nQuestChainId:"..self.QuestChainId..
		"\nQuestId:"..self.QuestId..
		"\nStoryNodeKey:"..self.Data.key
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "结束任务时，任务链已结束", Message)
		--DebugPrint('Storyline Has Finished, Node is ', self.QuestId)
		return
	end

	if self.HasFinished then
		local Message = "任务已结束"..
		"\nFileName:"..self.FileName..
		"\nQuestChainId:"..self.QuestChainId..
		"\nQuestId:"..self.QuestId..
		"\nStoryNodeKey:"..self.Data.key
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务已结束", Message)
		--DebugPrint('Questline Has Finished!!!!!!!!!!!!', self.QuestId)
		return
	end

	self.HasFinished = true
	self.HasStarted = false

	self:ClearQuest()
	self:ClearNodeWhenQuestFinish(bSucceeded)

	DebugPrint('Questline Finish', self.QuestId)
	self.StoryNode:FinishQuest(OutPortName, bSucceeded)
end

function Questline:ClearQuest()
	self.bLockRunningNodeList = true
	local RunningNodes = {}
	for _, Node in pairs(self.RunningNodeList) do
		table.insert(RunningNodes, Node)
	end

	for _, Node in pairs(RunningNodes) do
		if Node.Clear then
			Node:Clear()
		end
		Node.HasFinished = true
		Node.HasStarted = false
		table.insert(self.FinishedNodeList, Node)
		self:CheckAfterSpecialQuestFailMark(Node)
	end
	self.bLockRunningNodeList = false
	self.RunningNodeList = {}

	-- 在任务结束的时候清除该任务链关联的所有临时变量
	if self.QuestChainId > 0 and self.QuestId > 0 then
		local StorySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
		if StorySubsystem then
			StorySubsystem:ClearVarByQuestChainId(self.QuestChainId)
		end
	end
end

function Questline:ClearNodeWhenQuestFinish(IsSuccess)
	if IsSuccess then
		for _, Node in ipairs(self.FinishedNodeList) do
			if Node.HasFinished then
				Node:ClearWhenQuestSuccess()
			end
		end
	else
		for i = #self.FinishedNodeList, 1, -1 do
			local Node = self.FinishedNodeList[i]
			if Node.HasFinished then
				Node:ClearWhenQuestFail()
			end
		end
		-- for _, Node in pairs(self.RunningNodeList) do
		-- 	if Node.Clear then
		-- 		Node:Clear()
		-- 	end
		-- 	Node:ClearWhenQuestFail()
		-- end
	end
	self.FinishedNodeList = {}
end

function Questline:StopQuest(IgnoreFinishClear)
	self.HasFinished = true
	self.HasStarted = false
	self:ClearQuest()
	if not IgnoreFinishClear then
		self:ClearNodeWhenQuestFinish(false)
		self:QuestlineEnd("Stop")
	end
end

function Questline:RestartQuest()
	self:ClearQuest()
	self:ClearNodeWhenQuestFinish(false)
	self:BuildQuestline()
	self:StartQuest()
end

function Questline:SuccessQuest()
	self:ClearQuest()
	self._SuccessNode:Start(self)
end

function Questline:FailQuest()
	self:ClearQuest()
	self._FailNode:Start(self)
end

function Questline:PrintInfo()
	DebugPrint('---------------------------QuestInfo---------------------------')
	DebugPrint('QuestId: ', self.QuestId)
	DebugPrint('任务描述: ', self.QuestDescriptionComment)
	for _, Node in pairs(self.RunningNodeList) do
		DebugPrint('---------------------------NodeInfo---------------------------')
		DebugPrint(Node:ToString())
		DebugPrint('---------------------------NodeInfo---------------------------')
	end
	DebugPrint('---------------------------QuestInfo---------------------------')
end

function Questline:SaveSuitUpdateData(FunctionName, SuitType, SuitSubType, SuitKey, ...)
	if not self.STLData then
		self.STLData = {}
	end
	local SuitValue = {...}
	if #SuitValue <= 1 then
		SuitValue = table.unpack(SuitValue)
	end
	local SuitUpdateData = {
		FunctionName = FunctionName,
		SuitType = SuitType,
		SuitSubType = SuitSubType,
		Param = {
			SuitKey = SuitKey,
			SuitValue = SuitValue,
		},
	}
	table.insert(self.STLData, SuitUpdateData)
end

function Questline:StopStory()
	self.StoryNode:StopStory()
end


function Questline:GetAllLineData()
	return self.Data.questNodeData.lineData
end

function Questline:GetPayload(...)
	if self.Storyline then
		return self.Storyline:GetPayload(...)
	else
		return nil
	end
end

function Questline:AddPayload(Key, Value)
	if self.Storyline then
		self.Storyline:AddPayload(Key, Value)
	end
end

function Questline:TryAddAfterSpecialQuestFailMark(Node)
	if self:GetPayload("SpecialQuestFail") then
		Node.StartAfterSpecialQuestFail = true
	end
end

function Questline:CheckAfterSpecialQuestFailMark(Node)
	if Node.StartAfterSpecialQuestFail then
		local Message = "特殊任务失败后运行了异步节点"..
		"\nFileName:"..self.FileName..
		"\nSpecialQuestId:"..self:GetPayload("SpecialQuestId")..
		"\nNodeInfo:"..Node:ToString()
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "特殊任务失败后运行了异步节点", Message)
	end
end

function Questline:QuestlineEnd(Reason)
	if Reason == "Stop" then
		local Avatar = GWorld:GetAvatar()
		local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
		if self.QuestChainId > 0 and self.QuestId > 0 and Avatar and GameMode then
			local TaskInfo = {TaskChainId=self.QuestChainId, TaskId=self.QuestId,IsChainLastTask=self.QuestData.bIsEndQuest,IsChapterEnd = self.QuestData.bIsEndChapter}
			Avatar:DoRefreshTaskItemUIInfo("Add", TaskInfo)
			GameMode:RecoverDataByQuestChainId(self.QuestChainId, self.QuestId)
		end
		-- local GameInstance = GWorld.GameInstance
		-- AudioManager(GameInstance):RecoverLastSTLBGM()
	end
end

return Questline

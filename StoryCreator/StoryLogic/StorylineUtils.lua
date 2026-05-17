local FQuestDetails = require 'StoryCreator.StoryLogic.QuestDetails'

local StorylineUtils = {}

StorylineUtils.QuestNodePath = "StoryCreator.StoryLogic.StorylineNodes.QuestNodes"
StorylineUtils.StoryNodePath = "StoryCreator.StoryLogic.StorylineNodes.StoryNodes"
StorylineUtils.StorylinePath = "StoryCreator.StoryLogic.StorylineNodes.Storyline"
StorylineUtils.QuestlinePath = "StoryCreator.StoryLogic.StorylineNodes.Questline"
StorylineUtils.ImpressionlinePath = "StoryCreator.StoryLogic.StorylineNodes.Impressionline"

function StorylineUtils.GMCreateQuestNode(NodeType, Args)
	local Node = StorylineUtils.CreateQuestNode(NodeType, CommonUtils.EmptyProxy)
	Node:BuildNode(nil, {propsData=Args}, {})
	return Node
end

StorylineUtils.ETalkNodeFinishType = {
    Stop = 1,
    Out = 2,
    Option = 3,
    Fail = 4
}

StorylineUtils.EMonitorNodeFinishType = {
    Changed = 1,
    Unchanged = 2
}

StorylineUtils.EActorEventType = {
	OnCreated = "OnCreated",
	OnTriggerAOIBase = "OnTriggerAOIBase",
	OnActorDestroyed = "OnActorDestroyed",
	OnMonsterDeath = "OnMonsterDeath",
}

StorylineUtils.EssentialStoryNode = {
	StoryStartNode = "StoryStartNode",
	StoryEndNode = "StoryEndNode",
}

StorylineUtils.EssentialQuestNode = {
	QuestStartNode = "QuestStartNode",
	QuestSuccessNode = "QuestSuccessNode",
	QuestFailNode = 'QuestFailNode'
}

local NodeClassList = {}

function StorylineUtils._CreateNode(Path, NodeType, Context)
	if not NodeClassList[NodeType] then
		if string.sub(NodeType, -4) ~= 'Node' then
			local Message = "所创建节点的类型名没有以Node结尾"..
			"\nNodeType:"..NodeType
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.STL,  "所创建节点的类型名没有以Node结尾", Message)
			--assert(false, string.format("%s 没有以Node结尾！！！！！！！！！！！！！！！", NodeType))
			return
		end
		local QuestNodeFileName = string.format('%s.%s', Path, NodeType)
		local NodeClass = require(QuestNodeFileName)
		if NodeClass then
			NodeClassList[NodeType] = NodeClass
		end
	end

	local NodeClass = NodeClassList[NodeType]
	if NodeClass then
		return NodeClass(Context)
	else
		local Message = "创建节点时，未找到对应类型的节点"..
		"\nNodeType:"..NodeType
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.STL, "开始StoryNode时，任务链已结束", Message)
		--assert(false, string.format("Can't not found quest node class named %s", NodeType))
		return nil
	end
end

function StorylineUtils.CreateStoryNode(NodeType, Context)
	local Path = StorylineUtils.StoryNodePath
	if StorylineUtils.EssentialStoryNode[NodeType] or NodeType == 'StoryNode' or NodeType == 'PreStoryNode' then
		Path = StorylineUtils.StorylinePath
	end
	return StorylineUtils._CreateNode(Path, NodeType, Context)
end

function StorylineUtils.CreateQuestNode(NodeType, Context)
	local Path = StorylineUtils.QuestNodePath
	if StorylineUtils.EssentialQuestNode[NodeType] then
		Path = StorylineUtils.QuestlinePath
	end
	return StorylineUtils._CreateNode(Path, NodeType, Context)
end

function StorylineUtils.BuildStoryline(FileName, EndCallback, StopCallback, Payload)
	local FileData = StorylineUtils.GetFileData(FileName)
	if FileData == nil then
		DebugPrint('Warning: StorylineUtils.BuildStoryline: FileData is Empty')
		return nil
	end

	local Storyline = require 'StoryCreator.StoryLogic.StorylineNodes.Storyline.Storyline'
	return Storyline(FileData, FileName, EndCallback, StopCallback, Payload)
end

---@param FileName string
---@param QuestId integer
---@return FStoryNodeQuestInfo
function StorylineUtils.CreateQuestDetails(QuestChainId)
	local QuestChainInfo = DataMgr.QuestChain[QuestChainId]
	if QuestChainInfo == nil then
		DebugPrint('Warning: StorylineUtils.CreateQuestDetails: QuestChainInfo is Empty')
		return nil
	end

	local FileName = QuestChainInfo.StoryPath
	if FileName == nil then
		DebugPrint('Warning: StorylineUtils.CreateQuestDetails: FileName is Empty')
		return nil
	end

	local Storyline = GWorld.StoryMgr:GetStory(FileName)
	if not Storyline then
		Storyline = StorylineUtils.BuildStoryline(FileName)
	end
	if Storyline == nil then
		DebugPrint('Warning: StorylineUtils.CreateQuestDetails: Storyline is Empty')
		return nil
	end

	return FQuestDetails:New(Storyline)
end

---@param FileName string
---@return table<string, any>
function StorylineUtils.GetFileData(FileName)
	local RequirePath = StorylineUtils.GetRequirePath(FileName)
	if RequirePath == nil then
		DebugPrint('Warning: StorylineUtils.GetFileData: RequirePath is Empty')
		return nil
	end

	return require(RequirePath)
end

---@param FileName string
---@return string
function StorylineUtils.GetRequirePath(FileName)
	local BaseFileName = StorylineUtils.GetBaseFileName(FileName)
	if BaseFileName == nil then
		DebugPrint('Warning: StorylineUtils.GetRequirePath: BaseFileName is Empty')
		return nil
	end

	return "StoryCreator.StoryFiles." .. BaseFileName
end

---@param FileName string
---@return string
function StorylineUtils.GetBaseFileName(FileName)
	if FileName == nil then
		DebugPrint('Warning: StorylineUtils.GetBaseFileName: FileName is Empty')
		return nil
	end

	if string.sub(FileName, -6) == '.story' then
		return string.sub(FileName, 1, string.len(FileName) - 6)
	end
	return FileName
end

function StorylineUtils.MarkGuideStoryError()
	StorylineUtils.IsGuideStoryError = true
end

function StorylineUtils.GetOnceGuideStoryError()
	local Error = StorylineUtils.IsGuideStoryError
	StorylineUtils.IsGuideStoryError = nil
	return Error
end

function StorylineUtils.IsGuideNodeRunning()
	if SystemGuideManager.IsGuideStoryRunning then
		return true and (not StorylineUtils.IsGuideStoryError)
	end
	for _, Storyline in pairs(GWorld.StoryMgr.Storylines) do
		if Storyline.HasFinished then goto continue end
		for _,StoryNode in pairs(Storyline.RunningNodeList or {}) do
			if StoryNode.Questline and (not StoryNode.Questline.HasFinished) then
				for _, QuestNode in pairs(StoryNode.Questline.RunningNodeList or {}) do
					if QuestNode.IsGuideNode and QuestNode:IsGuideNode() then 
						return true and (not StorylineUtils.IsGuideStoryError)
					end
				end
			end
			if StoryNode.Impressionline and (not StoryNode.Impressionline.HasFinished) then
				for _, QuestNode in pairs(StoryNode.Impressionline.RunningNodeList or {}) do
					if QuestNode.IsGuideNode and  QuestNode:IsGuideNode() then 
						return true and (not StorylineUtils.IsGuideStoryError)
					end
				end
			end
		end
		if string.startswith(string.lower(Storyline.FilePath), "guide/") then
			return true and (not StorylineUtils.IsGuideStoryError)
		end
		::continue::
	end
	return false
end
return StorylineUtils

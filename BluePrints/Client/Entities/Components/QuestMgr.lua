require "UnLua"
local EMCache = require "EMCache.EMCache"
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
local GuidePointLocData = require ("BluePrints.UI.TaskPanel/QuestGuidePointLocData")
local StorylineUtils = require 'StoryCreator.StoryLogic.StorylineUtils'
local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
local WBP_Task_Main_C = require "BluePrints.UI.TaskPanel.WBP_Task_Main_C"

---@type ClientAvatar
local Component = {}

-- 区域全部准备完毕
function Component:NotifyAvatarRegionAllReady()
	if TaskUtils and TaskUtils.RemoveAllQuestExtraInfo then
		TaskUtils:RemoveAllQuestExtraInfo()
	end
	if MissionIndicatorManager and MissionIndicatorManager.MissionNpcSideBubbles then
		MissionIndicatorManager.MissionNpcSideBubbles = {}
	end

	self:TriggerQuestChain()
	EventManager:FireEvent(EventID.OnRegionLoaded)
end
---------------------------------------------------------------------
-------------------------- 任务逻辑 ----------------------------------
---------------------------------------------------------------------
-------------------------- EnterWorld --------------------------------
function Component:EnterWorld()
	DebugPrint("QuestMgr EnterWorld")
	self.DoingQuestChainIds = {}
	self.DoingQuestIds = {}
end
function Component:OnLoginSuccess()
		self:RefreshTaskRedDot()
end


function Component:RefreshTaskRedDot()
	for QuestChainId, Info in pairs(DataMgr.QuestChain) do
		local Quest = self.QuestChains[QuestChainId]
		if Quest and Quest.State == CommonConst.QuestChainState.finish then
			local Type = DataMgr.QuestChain[QuestChainId].QuestChainType
			local TypeName = CommonConst.QuestTypeName[Type]
			local NodeName = DataMgr.ReddotNode[TypeName].Name
			if not ReddotManager.GetTreeNode(NodeName) then
				ReddotManager.AddNode(NodeName,nil,1)
			end
			if ReddotManager.GetLeafNodeCacheDetail(NodeName)[QuestChainId] ~= nil then
				ReddotManager.GetLeafNodeCacheDetail(NodeName)[QuestChainId] = nil
				ReddotManager.DecreaseLeafNodeCount(NodeName, 1, {QuestId = QuestChainId})
			end
		end
	end
end

function Component:GetCurrentDoingQuest()
	local DoingQuestChainIds = {}
	local DoingQuestIds = {}
	for QuestChainId, QuestChain in pairs(self.QuestChains) do
		if QuestChain:IsDoing() then
			table.insert(DoingQuestChainIds, QuestChainId)
			local id = QuestChain.DoingQuestId
			if id and id > 0 then
				table.insert(DoingQuestIds, id)
			end
		end
	end
	return DoingQuestChainIds, DoingQuestIds
end

function Component:GetCurrenCanReciveQuest()
	local CanReciveQuestChainIds = {}
	local CanReciveQuestIds = {}
	for QuestChainId, QuestChain in pairs(self.QuestChains) do
		if QuestChain:IsUnlock() then
			table.insert(CanReciveQuestChainIds, QuestChainId)
			local id = QuestChain.DoingQuestId
			if id and id > 0 then
				table.insert(CanReciveQuestIds, id)
			end
		end
		if QuestChain:IsDoing() then
			table.insert(CanReciveQuestChainIds, QuestChainId)
			local id = QuestChain.DoingQuestId
			if id and id > 0 then
				table.insert(CanReciveQuestIds, id)
			end
		end
	end
	
	return CanReciveQuestChainIds, CanReciveQuestIds
end

function Component:CheckQuestCanStart()
	local GameMode = UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if not GameMode then
		return false, GameMode
	end
	if not GameMode.IsInRegion then
		return false, GameMode
	end
	if not GameMode:IsInRegion() then
		return false, GameMode
	end
	if not GameMode.IsRegionAllReady or not GameMode:IsRegionAllReady() then
		return false, GameMode
	end
	return true, GameMode
end
function Component:OnPrintToFeiShu_Quest(ClientErrorCode, ServerErrorCode, FunctionName, QuestChainId, QuestId, ...)
	-- if self:CheckRegionErrorCode(ServerErrorCode) then return end
	-- local MsgInfo = {}
	-- local ServerErrorCodeContent, ClientErrorCodeContent
	-- local Title = "|任务流程异常|"
	-- if self:CheckRegionErrorCode(ServerErrorCode) then
	-- 	ServerErrorCodeContent = "服务端流程正常"
	-- else
	-- 	if DataMgr.ErrorCode[ServerErrorCode] then
	-- 		ServerErrorCodeContent = (DataMgr.ErrorCode[ServerErrorCode].ErrorCodeContent or "服务器错误码未配置Content：")..ServerErrorCode
	-- 	else
	-- 		ServerErrorCodeContent = "服务器错误码未配置表："..ServerErrorCode
	-- 	end
	-- end
	-- if self:CheckRegionErrorCode(ClientErrorCode) then
	-- 	ClientErrorCodeContent = "客户端流程正常"
	-- else
	-- 	if DataMgr.ErrorCode[ClientErrorCode] then
	-- 		ClientErrorCodeContent = (DataMgr.ErrorCode[ClientErrorCode].ErrorCodeContent or "客户端错误码未配置Content：")..ClientErrorCode
	-- 	else
	-- 		ClientErrorCodeContent = "客户端错误码未配置表："..ClientErrorCode
	-- 	end
	-- end
	-- table.insert(MsgInfo,"报错的来源：".. FunctionName)
	-- table.insert(MsgInfo,"所处的任务链Id：".. (QuestChainId or ""))
	-- table.insert(MsgInfo,"所处的任务Id："..(QuestId or ""))
	-- table.insert(MsgInfo,"服务器错误码指示内容：".. ServerErrorCodeContent )
	-- table.insert(MsgInfo,"客户端错误码指示内容：".. ClientErrorCodeContent )
	-- -- table.insert(MsgInfo,"额外信息：".. table.concat({...}))
	-- self:SendToFeishuForJQ(CommonUtils:TableToStr(MsgInfo), Title)
end
function Component:TriggerQuestChain()
	if not self:CheckQuestCanStart() then return end
	local Chain = nil
	self.CanReciveQuestChainIds, self.CanReciveQuestIds = self:GetCurrenCanReciveQuest()
	self.CanReciveQuestId2QuestChainId = {}

	for index, id in ipairs(self.CanReciveQuestChainIds) do
		Chain = self.QuestChains[id]
		if Chain and Chain:IsUnlock() then
			-- 开始任务链
			if Chain.DoingQuestId and Chain.DoingQuestId > 0 then
				self.CanReciveQuestId2QuestChainId[Chain.DoingQuestId] = id
			end

			if GWorld.StoryMgr:IsRunningStoryline(DataMgr.QuestChain[Chain.QuestChainId].StoryPath) == false then
				GWorld.StoryMgr:RunStory(DataMgr.QuestChain[Chain.QuestChainId].StoryPath, Chain.DoingQuestId)
			end
		end

		if Chain and Chain:IsDoing() then
			-- 开始任务链
			if Chain.DoingQuestId and Chain.DoingQuestId > 0 then
				self.CanReciveQuestId2QuestChainId[Chain.DoingQuestId] = id
			end

			if GWorld.StoryMgr:IsRunningStoryline(DataMgr.QuestChain[Chain.QuestChainId].StoryPath) == false then
				GWorld.StoryMgr:RunStory(DataMgr.QuestChain[Chain.QuestChainId].StoryPath, Chain.DoingQuestId)
			end

			EventManager:FireEvent(EventID.SetNpcFlexibShowOrHideDynamic, 'Quest', Chain.DoingQuestId)
	        EventManager:FireEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic, 'Quest', Chain.DoingQuestId)
	        EventManager:FireEvent(EventID.TriggerFlexibleActive)
		end
	end
end

function Component:CheckQuestIdIsInStory(InPath, TargetQuestId)
	local FileData = StorylineUtils.GetFileData(InPath)
	if FileData == nil then
		DebugPrint('Warning: QuestMgr.CheckQuestIdIsInStory: FileData is Empty')
		return false
	end
	local IsIn = false
	for _, Node in pairs(FileData.storyNodeData) do
		if Node and Node.propsData.QuestId ~= nil and Node.propsData.QuestId == TargetQuestId then
			IsIn = true
			break
		end
	end
	return IsIn
end

-- 服务器通知某个任务开始
function Component:ServerStartQuest(Ret, QuestChainId, ClientVarParams)
	DebugPrint("ZJT_ ServerStartQuest ", Ret, QuestChainId, ClientVarParams)
	local CheckRet, GameMode, QuestChain = self:IsCanRunQuestConditionCheck(Ret, QuestChainId)
	if not self:CheckRegionErrorCode(CheckRet) then
		self:OnPrintToFeiShu_Quest(CheckRet, Ret, " ServerStartQuest_服务器告知客户端开始任务 ", QuestChainId)
		return
	end
	table.insert(self.DoingQuestIds, QuestChain.DoingQuestId)

	EventManager:FireEvent(EventID.SetNpcFlexibShowOrHideDynamic, 'Quest', QuestChain.DoingQuestId)
	EventManager:FireEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic, 'Quest', QuestChain.DoingQuestId)
	EventManager:FireEvent(EventID.TriggerFlexibleActive)

	local Story = GWorld.StoryMgr:GetStory(QuestChain.StoryPath)
	GameMode:TriggerQuestArtLevelChange(ClientVarParams)
	if not Story then
		local MainStoryData = DataMgr.QuestChain[QuestChainId]
		if QuestChainId and QuestChainId > 0 and MainStoryData ~= nil and MainStoryData.StoryPath ~= nil then
			GWorld.StoryMgr:RunStory(MainStoryData.StoryPath, self.QuestChains[QuestChainId].DoingQuestId)
		end
		return
	end
	Story:StartStory(QuestChain.DoingQuestId)
end

function Component:_OnPropChangeTrackingQuestChainId(key)
	local Avatar = GWorld:GetAvatar()
	local ServerTrackingQuestChainId = Avatar.TrackingQuestChainId
	if ServerTrackingQuestChainId and ServerTrackingQuestChainId ~= 0 then
		self:SetQuestTracking(ServerTrackingQuestChainId)
	end
	self.LastTrackingQuestChainId = self.TrackingQuestChainId
	
end

function Component:RealUpdateQuestChain(QuestChainId)
	local QuestChain = self.QuestChains[QuestChainId]
	local Type = DataMgr.QuestChain[QuestChainId].QuestChainType
	local TypeName = CommonConst.QuestTypeName[Type]
	local NodeName = DataMgr.ReddotNode[TypeName].Name
	if ReddotManager.GetTreeNode(NodeName) then
		if ReddotManager.GetLeafNodeCacheDetail(NodeName)[QuestChainId] == nil then
			ReddotManager.IncreaseLeafNodeCount(NodeName, 1, {QuestId = QuestChainId})
		end
	end
	if not self:CheckQuestCanStart() then return end
	if not QuestChain or not QuestChain:IsDoing() then return end
	DebugPrint("ZJT_ RealUpdateQuestChain ", QuestChainId)

	GWorld.StoryMgr:RunStory(QuestChain.StoryPath, QuestChain.DoingQuestId)
end

function Component:IsCanRunQuestConditionCheck(Ret, QuestChainId)
	local QuestChain, GameMode, Result
	Result, GameMode = self:CheckQuestCanStart()
	if not Result then
		return ErrorCode.RET_QUEST_REGION_NOT_ALLREADY, GameMode, QuestChain
	end
	QuestChain = self.QuestChains[QuestChainId]
	if not QuestChain then
		return ErrorCode.RET_QUESTCHAIN_NOT_EXIST, GameMode, QuestChain
	end
	if not self:CheckRegionErrorCode(Ret or ErrorCode.RET_SUCCESS) then
		return Ret, GameMode, QuestChain
	end
	return ErrorCode.RET_SUCCESS, GameMode, QuestChain
end

function Component:CheckQuestIdIsDoing(QuestId)
	if not self.DoingQuestId2QuestChainId then
		return false
	end
	if self.DoingQuestId2QuestChainId[QuestId] then
		return true
	end
	return false
end

-- 任务链结束,改为服务器通知
function Component:QuestChainFinish(Ret, QuestChainId, RewardBox, TargetCompleteQuestIds, TargetClientVarParams)
	self.logger.info("QuestChainFinish", QuestChainId, Ret)
	PrintTable({TargetClientVarParams = TargetClientVarParams }, 10)
	local CheckRet, GameMode, QuestChain = self:IsCanRunQuestConditionCheck(Ret, QuestChainId)
	self:UpdateAllQuestChainReddotSetByFinishedQuestChain(QuestChainId)
	if not self:CheckRegionErrorCode(CheckRet) then
		self:OnPrintToFeiShu_Quest(CheckRet, Ret, " QuestChainFinish_任务链完成失败 ", QuestChainId, nil, RewardBox)
		return
	end
	self:HandleNotifyQuestComplete(nil, QuestChainId, TargetCompleteQuestIds)
	EventManager:FireEvent(EventID.SetNpcFlexibShowOrHideDynamic, 'QuestChain', QuestChainId)
	EventManager:FireEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic, 'QuestChain', QuestChainId)
	EventManager:FireEvent(EventID.TriggerFlexibleActive)
	-- 任务链完成，停止任务链STL
	local StoryPath = QuestChain.StoryPath
	GWorld.StoryMgr:StopStoryline(StoryPath)

	-- 清理任务链数据
	GWorld.UploadQuestChainData = true
	GameMode:HandleQuestChainFinish(QuestChainId)
	GWorld.UploadQuestChainData = false

	-- 不知道什么逻辑-开始
	CommonUtils.RemoveValue(self.CanReciveQuestChainIds, QuestChainId)
	EventManager:FireEvent(EventID.QuestChainFinished,QuestChainId)
	GameMode:TriggerQuestArtLevelChange(TargetClientVarParams)
	if TaskUtils and TaskUtils.ShowQuestChainFinishCommonHudReward then
		TaskUtils:ShowQuestChainFinishCommonHudReward(QuestChainId, RewardBox)
	end
end

-- 任务链结束


-- 获取正在进行中的任务
function Component:GetQuestDoing()
	return self.DoingQuestIds
end

function Component:IsQuestChainDoing(QuestChainId)
	local QuestChain = self.QuestChains[QuestChainId]
	if QuestChain and QuestChain:IsDoing() then
		return true
	end
	return false 
end

function Component:IsQuestDoing(QuestId)
	for QuestChainId, QuestChain in pairs(self.QuestChains) do
		if (QuestChain:CheckQuestIdDoing(QuestId)) then
			return true
		end
	end
	return false
end

function Component:UpdateAllQuestChainReddotSetByFinishedQuestChain(InQuestChainId)
	-- local AllQuestChainReddotCache = EMCache:Get("AllQuestChainReddotSet", true) or {}
	-- for Type, Caches in pairs(AllQuestChainReddotCache) do
	-- 	for ChainId, _ in pairs(Caches) do
	-- 		if ChainId == InQuestChainId then
	-- 			AllQuestChainReddotCache[Type][ChainId] = true
	-- 		end
	-- 	end
	-- end

	-- EMCache:Set("AllQuestChainReddotSet", AllQuestChainReddotCache, true)
	local Type = DataMgr.QuestChain[InQuestChainId].QuestChainType
	local TypeName = CommonConst.QuestTypeName[Type]
	local NodeName = DataMgr.ReddotNode[TypeName].Name
	if ReddotManager.GetLeafNodeCacheDetail(NodeName) and ReddotManager.GetLeafNodeCacheDetail(NodeName)[InQuestChainId] == 1 then
		ReddotManager.DecreaseLeafNodeCount(NodeName, 1, {QuestId = InQuestChainId})
	end
end

function Component:IsQuestChainFinished(QuestChainId)
	local QuestChain = self.QuestChains[QuestChainId]
	if QuestChain and QuestChain:IsFinish() then
		return true
	end
	return false
end

function Component:IsQuestChainAssumeFinished(QuestChainId)
	local QuestChain = self.QuestChains[QuestChainId]
	if QuestChain and QuestChain:GetAssumeFinish() then
		return true
	end
	return false
end

function Component:IsQuestFinished(QuestId)
	local length = CommonUtils:GetIntNumLength(QuestId)
	assert(length>=6,"QuestId:"..QuestId.."无效")
	local QuestChainId = CommonUtils:GetFrontNum(QuestId, 6)
	local QuestChain = self.QuestChains[QuestChainId]
	if QuestChain then
		if QuestChain:IsFinish() or QuestChain:CheckQuestIdComplete(QuestId) then
			return true
		end
	end
	return false
end

function Component:IsQuestAssumeFinished(QuestId)
	local length = CommonUtils:GetIntNumLength(QuestId)
	assert(length>=6,"QuestId:"..QuestId.."无效")
	local QuestChainId = CommonUtils:GetFrontNum(QuestId, 6)
	local QuestChain = self.QuestChains[QuestChainId]
	if QuestChain then
		if QuestChain:GetAssumeFinish() then
			return true
		end
	end
	return false
end

function Component:IsQuestChainLock(QuestChainId)
	local QuestChain = self.QuestChains[QuestChainId]
	if QuestChain and QuestChain:IsLock() then
		return true
	end
	return false
end

function Component:IsQuestChainUnlock(QuestChainId)
	local QuestChain = self.QuestChains[QuestChainId]
	if QuestChain and QuestChain:IsUnlock() then
		return true
	end
	return false
end

-- 后面再删除该方法 开始任务
function Component:StartQuest(QuestChainId, QuestId, ManualTrigger, TargetId, Count)
	
end

function Component:GMStartQuest(QuestChainId, QuestId)
	self:CallServerMethod("GMStartQuest", QuestChainId, QuestId)
end
-- 成功完成任务
function Component:CompleteQuestSuccess(ServerParamTable)
	local QuestChain = self.QuestChains[ServerParamTable.QuestChainId]
	if QuestChain then
		if QuestChain:IsFinish() then
			local Message = "任务链已经完成"..
			"\nQuestChainId:"..ServerParamTable.QuestChainId..
			"\nQuestId:"..ServerParamTable.QuestId
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "任务链已经完成", Message)
			return
		elseif QuestChain:CheckQuestIdComplete(ServerParamTable.QuestId) then
			local Message = "任务已经完成"..
			"\nQuestChainId:"..ServerParamTable.QuestChainId..
			"\nQuestId:"..ServerParamTable.QuestId
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "任务已经完成", Message)
			return
		end
	end
	self:OnQuestTrigger(ServerParamTable, ServerParamTable.ManualTrigger)
end

function Component:HandleClientQuestCompleteEvent(Ret, ManualTrigger, QuestId, QuestChainId, TargetCompleteQuestIds, ClientVarParams)
	if not ErrorCode:Check(Ret) then return end
	PrintTable({ClientVarParams = ClientVarParams, Ret = Ret, QuestChainId = QuestChainId, QuestId = QuestId, TargetCompleteQuestIds = TargetCompleteQuestIds}, 10)
	DebugPrint("ZJT_ 1111111 HandleClientQuestCompleteEvent ", Ret, ManualTrigger, QuestId, QuestChainId, TargetCompleteQuestIds, ClientVarParams)
	EventManager:FireEvent(EventID.SetNpcFlexibShowOrHideDynamic, 'Quest',QuestId)
	EventManager:FireEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic, 'Quest', QuestId)
	EventManager:FireEvent(EventID.QuestFinished, QuestId)
	EventManager:FireEvent(EventID.TriggerFlexibleActive)
	CommonUtils.RemoveValue(self.DoingQuestIds, QuestId)
	self:HandleNotifyQuestComplete(QuestId, QuestChainId, TargetCompleteQuestIds)
	local GameMode = GWorld.GameInstance:GetCurrentGameMode()
	GameMode:TriggerQuestArtLevelChange(ClientVarParams)
	if ManualTrigger then
		self:TriggerQuestChain()
	end
end

---- 第一个参数是完成的任务ID Normal, TargetCompleteQuestIds是完成的目标任务到开始任务ID任务集合 GM
---- 当我现在处于A任务--->B ---->C ---->D，如果直接完成D，那么 TargetCompleteQuestIds = {A, B, C, D}
function Component:HandleNotifyQuestComplete(CompleteQuestId, QuestChainId, TargetCompleteQuestIds)
	if not TargetCompleteQuestIds or next(TargetCompleteQuestIds) == nil then
		if CompleteQuestId then
			self:OnQuestComplete(QuestChainId, CompleteQuestId)
		else
			PrintTable({
				CompleteQuestId = CompleteQuestId or 0,
				QuestChainId = QuestChainId or 0,
				TargetCompleteQuestIds = TargetCompleteQuestIds,
				Reason = "ZJT_FailedCompleteQuestId",
			}, 10)
		end
	else
		if type(TargetCompleteQuestIds) == 'table' then
			for _, QuestId in ipairs(TargetCompleteQuestIds) do
				self:OnQuestComplete(QuestChainId, QuestId)
			end
		else
			PrintTable({
				CompleteQuestId = CompleteQuestId or 0,
				QuestChainId = QuestChainId or 0,
				TargetCompleteQuestIds = TargetCompleteQuestIds,
				Reason = "ZJT_FailedTargetCompleteQuestIds"
			}, 10)
		end
	end
end

-- 任务某一个条件触发后执行
function Component:OnQuestTrigger(ServerParamTable, ManualTrigger)
	DebugPrint("ZJT_ OnQuestTrigger  ", os.time(), ServerParamTable.TriggerType,ServerParamTable.QuestChainId, ServerParamTable.QuestId,
	ManualTrigger,ServerParamTable.TargetId, ServerParamTable.TargetCount, ServerParamTable.STLData, ServerParamTable.QuestDatas)
	PrintTable({QuestDatas = ServerParamTable.RegionQuestDatas, ServerParamTable.STLData, ServerParamTable = ServerParamTable}, 10)
	local function callback(Ret, Reward, ClientVarParams)
		self:HandleServerQuestComplete(Ret, Reward, ServerParamTable, ManualTrigger, ClientVarParams)
	end
	if ServerParamTable.QuestChainId > 0 and ServerParamTable.QuestId > 0 then
		self:HandleAddBlackScreenOnDelivery(ServerParamTable.bIsPlayBlackScreenOnComplete, ServerParamTable.QuestChainId, ServerParamTable.QuestId)
		self:CallServer("OnQuestTrigger", callback, ServerParamTable)
	end
end

function Component:HandleServerQuestComplete(Ret, Reward, ServerParamTable, ManualTrigger, ClientVarParams)
	local TaskChainConfig = DataMgr.QuestChain[ServerParamTable.QuestChainId]
	if next(Reward) and TaskChainConfig.QuestReward and TaskChainConfig.QuestReward[ServerParamTable.QuestId] then
		if Reward ~= nil and next(Reward) ~= nil and not Reward.bEmpty then
			UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Reward)
		end
	end
	self:HandleRemoveBlackScreenOnDelivery(ServerParamTable.bIsPlayBlackScreenOnComplete, ServerParamTable.QuestChainId, ServerParamTable.QuestId)

	self.logger.debug("ZJT_ OnQuestTrigger ServerCallClient ", ServerParamTable.TriggerType, ServerParamTable.QuestChainId, ServerParamTable.QuestId, Ret, ClientVarParams)
	self:HandleClientQuestCompleteEvent(Ret, ManualTrigger, ServerParamTable.QuestId, ServerParamTable.QuestChainId, nil, ClientVarParams)

	local EventNames = DataMgr.MSDKUploadConvert.QuestSuccessInfo[ServerParamTable.QuestId]
	if EventNames then
		for i,EventName in ipairs(EventNames) do
			local EMHeroUSDKSubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UEMHeroUSDKSubsystem:StaticClass())
			EMHeroUSDKSubsystem:MSDKUploadCommonEventByEventName(EventName)
		end
	end

	self:HandleClientQuestFakeComplete(Ret, ServerParamTable.SelectRes)
end

function Component:HandleClientQuestFakeComplete(Ret, SelectRes)
	if not ErrorCode:Check(Ret) then return end
	if SelectRes then
		GWorld.NetworkMgr:OnDisconnectAndLoginAgain()
	end
end


-- 开始某个任务后的回调
function Component:OnQuestStart(QuestChainId, QuestId)
end

-- 完成某个任务后的回调
function Component:OnQuestComplete(QuestChainId, QuestId)
	local GameMode = GWorld.GameInstance:GetCurrentGameMode()
	DebugPrint("ZJT_ OnQuestComplete ", QuestChainId, QuestId, GameMode:GetName(), GameMode:IsSubGameMode() )
	if not IsValid(GameMode) then return end
	GameMode:TriggerOnQuestComplete(QuestChainId, QuestId)
	EventManager:FireEvent(EventID.OnCompleteQuestChain, QuestChainId, QuestId)
end


function Component:UpdateQuestChain(QuestChainId)
	EventManager:FireEvent(EventID.OnUpdateQuestChain, QuestChainId)
	self:RealUpdateQuestChain(QuestChainId)
end

---------------------------------------------------------------------
-------------------------- 任务GM -----------------------------------
---------------------------------------------------------------------
function Component:GMStartQuestChain(QuestChainId)
	self.logger.debug("GMStartQuestChain", QuestChainId, type(QuestChainId))
	local QuestChain = self.QuestChains[QuestChainId]
	if QuestChain then
		if QuestChain:IsFinish() then
			DebugPrint("ZJT_ 任务链已经完成 ", QuestChainId)
			return
		end
		if QuestChain:IsDoing() then
			DebugPrint("任务链正在进行 ", QuestChainId)
			return
		end
		if QuestChain:IsUnlock() then
			DebugPrint("正在进行前置任务 ", QuestChainId)
			return
		end
    end
	local function callback(Ret)
		self.logger.debug("ServerCallClient GMStartQuestChain callback", Ret)
		local CheckRet, GameMode, QuestChain = self:IsCanRunQuestConditionCheck(Ret, QuestChainId)
		if not self:CheckRegionErrorCode(CheckRet) then
			self:OnPrintToFeiShu_Quest(CheckRet, Ret, " GMStartQuestChain_GM开始任务链失败 ", QuestChainId)
			return
		end
		table.insert(self.CanReciveQuestChainIds, QuestChainId)
		self:TriggerQuestChain()
	end
	self:CallServer("GMStartQuestChain", callback, QuestChainId)
end

function Component:GMSuccQuestChain(QuestChainId, bIsTriggerQuestChain)
	self.logger.debug("GMSuccQuestChain", QuestChainId, type(QuestChainId), bIsTriggerQuestChain, type(bIsTriggerQuestChain))
	local QuestChain = self.QuestChains[QuestChainId]
    if QuestChain and QuestChain:IsFinish() then
        DebugPrint("ZJT_ 任务链已经完成 ", QuestChainId)
        return 
    end
	self:CallServerMethod("GMSuccQuestChain", QuestChainId)
end

function Component:GMCleanQuestChain(QuestChainId)
	print(_G.LogTag, "GMCleanQuestChain", QuestChainId)
	local function callback(ret)
		self.logger.debug("GMCleanQuestChain callback", ret)
	end
	self:CallServer("GMCleanQuestChain", callback, QuestChainId)
end

function Component:GMCleanAllQuest()
	self.QuestChains:Clear()
	local function callback(Ret)
		if ErrorCode:Check(Ret) then
		end
	end
	self:CallServer("GMCleanAllQuest", callback)
end

function Component:SaveQuestPopUIIdState(QuestId, PopUIId)
	local function Callback(Ret)
		self.logger.debug("ZJT_ SaveQuestPopUIIdState ", Ret, QuestId, PopUIId)
	end
	self:CallServer("SaveQuestPopUIIdState", Callback, QuestId, PopUIId)
end

---------------------------------------------------------------------
-------------------------- 任务UI -----------------------------------
---------------------------------------------------------------------
--节点调用
function Component:DoRefreshTaskItemUIInfo(OpType, TaskInfo, TaskExtraInfo)
	-- 更新一下任务的listview
	local GameInstance = GWorld.GameInstance
	local UIManager = GameInstance:GetGameUIManager()
	if (UIManager == nil) then
		return
	end

	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end

	local BattleMain = UIManager:GetUIObj("BattleMain")
	if BattleMain and BattleMain.Pos_TaskBar:GetChildAt(0) and BattleMain.Pos_TaskBar.Visibility == UE4.ESlateVisibility.Collapsed and Avatar.TrackingQuestChainId > 0 and Avatar.TrackingQuestChainId ~= nil then
		BattleMain.Pos_TaskBar:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
	elseif BattleMain and BattleMain.Pos_TaskBar:GetChildAt(0) and BattleMain.Pos_TaskBar.Visibility == UE4.ESlateVisibility.Collapsed and TaskUtils:GetUnlockMainStory() then
		BattleMain.Pos_TaskBar:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
		BattleMain.Pos_TaskBar:GetChildAt(0).VBox_TaskBar:SetVisibility(UE4.ESlateVisibility.Collapsed)
	end

	if TaskInfo and OpType == "Add" then
		

		-- local NewQuestReddotSet = EMCache:Get("NewQuestReddotSet", true) or {}
		-- if TaskInfo.TaskChainId ~= nil and TaskInfo.TaskChainId ~= 0 and NewQuestReddotSet[TaskInfo.TaskChainId] == nil then
		-- 	NewQuestReddotSet[TaskInfo.TaskChainId] = true
		-- 	EMCache:Set("NewQuestReddotSet", NewQuestReddotSet, true)
		-- 	EventManager:FireEvent(EventID.OnReceiveNewQuest)
		-- end

		--local AllQuestChainReddotCache = EMCache:Get("AllQuestChainReddotSet", true) or {}
		local QuestChainData = DataMgr.QuestChain[TaskInfo.TaskChainId]
		local STLExportInfo = DataMgr.STLExportQuestChain[TaskInfo.TaskChainId]
		if QuestChainData and QuestChainData.QuestChainType then
			if STLExportInfo ~= nil and STLExportInfo.Quests ~= nil and STLExportInfo.Quests[TaskInfo.TaskId] ~= nil then
				if STLExportInfo.Quests[TaskInfo.TaskId].IsPreQuest == nil then
					local TypeName = CommonConst.QuestTypeName[QuestChainData.QuestChainType]
					local NodeName = DataMgr.ReddotNode[TypeName].Name
					if ReddotManager.GetTreeNode(NodeName) then
						local NodeDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
						if ReddotManager.GetLeafNodeCacheDetail(NodeName)[TaskInfo.TaskChainId] == nil then
							ReddotManager.IncreaseLeafNodeCount(NodeName, 1, {QuestId = TaskInfo.TaskChainId})
						end
					end
					-- AllQuestChainReddotCache[QuestChainData.QuestChainType] = AllQuestChainReddotCache[QuestChainData.QuestChainType] or {}
					-- if AllQuestChainReddotCache[QuestChainData.QuestChainType][TaskInfo.TaskChainId] == nil and
					--  Avatar.QuestChains[TaskInfo.TaskChainId] and Avatar.QuestChains[TaskInfo.TaskChainId].State ~= 3 then
					-- 	AllQuestChainReddotCache[QuestChainData.QuestChainType][TaskInfo.TaskChainId] = false
					-- end
					--EMCache:Set("AllQuestChainReddotSet", AllQuestChainReddotCache, true)
				end
			end
		end
	end

	local TaskPanel = nil
	local BattleMainUI = UIManager:GetUIObj("BattleMain")
	if BattleMainUI ~= nil then
		if TaskInfo and TaskInfo.IsDynamicEvent then
			TaskPanel=BattleMainUI:GetOrAddDynamicEventWidget()
		else
			-- body
			TaskPanel = BattleMainUI.Pos_TaskBar:GetChildAt(0)
		end
	end

	if TaskPanel == nil then
		return
	end
	if TaskInfo and TaskInfo.IsDynamicEvent then
		TaskPanel:UpdateTaskInfo(TaskInfo, OpType)
	else
		-- body
		if TaskExtraInfo ~= nil then
			TaskPanel:UpdateTaskExtraInfo(OpType, TaskExtraInfo)
		else
			local TrackingQuestId = Avatar.TrackingQuestChainId
			local RefreshTaskChainId = TaskInfo.TaskChainId
			if TrackingQuestId == RefreshTaskChainId then --任务A的QuestSuccessNode完成情况下开始任务B的QuestStartNode不走这里,走TaskBar动效结束的切换
				TaskPanel:UpdateTaskInfo(TaskInfo, OpType)
			end
		end
	end

end


-- function Component:AutoAddTaskIndicatorAfterLoadScene()
-- 	-- 切换场景之后加载当前场景需要显示的任务指引
-- 	local AllDoingTask = self:GetQuestDoing()
-- 	for index, QuestId in ipairs(AllDoingTask) do
-- 		local TaskConfig = DataMgr.Quest[QuestId]
-- 		local TaskChainConfig = DataMgr.QuestChain[TaskConfig.QuestChainId]
-- 		if (TaskConfig ~= nil and TaskChainConfig ~= nil and TaskConfig.QuestGuide ~= nil) then
-- 			-- 开启任务指引
-- 			local GameInstance = GWorld.GameInstance
-- 			local UIManager = GameInstance:GetGameUIManager()
-- 			-- local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
-- 			-- local GameState = UE4.UGameplayStatics.GetGameState(self)
-- 			local UIName = TaskChainConfig.QuestChainType.."TaskIndicator"
-- 			local TaskIndicatorUI = UIManager:GetUIObj(UIName)
-- 			if (TaskIndicatorUI ~= nil) then
-- 				local CurTaskId = TaskIndicatorUI:GetQuestId()
-- 				if (QuestId > CurTaskId) then
-- 					TaskIndicatorUI:InitIndicatorInfo(QuestId)
-- 				end
-- 			else
-- 				TaskIndicatorUI = UIManager:LoadUI(UIConst.TASKINDICATORUI, TaskChainConfig.QuestChainType.."TaskIndicator", UIConst.ZORDER_FOR_INDICATORS)
-- 				if (TaskIndicatorUI ~= nil) then
-- 					TaskIndicatorUI:InitIndicatorInfo(QuestId)
-- 				end
-- 			end
-- 		end
-- 	end
-- end


-- function Component:UpdateTaskIndicator(bShow, QuestId, QuestType)
-- 	local GameInstance = GWorld.GameInstance
-- 	local UIManager = GameInstance:GetGameUIManager()
-- 	if bShow then
-- 		-- 开启任务指引
-- 		local TaskIndicatorUI = UIManager:LoadUI(UIConst.TASKINDICATORUI, QuestType.."TaskIndicator", UIConst.ZORDER_FOR_INDICATORS)
-- 		if (TaskIndicatorUI ~= nil) then
-- 			TaskIndicatorUI:InitIndicatorInfo(QuestId)
-- 		end
-- 	else
-- 		-- 关闭任务指引
-- 		local TaskIndicator = UIManager:GetUIObj(QuestType.."TaskIndicator")
-- 		if (TaskIndicator ~= nil) then
-- 			-- Note hxp: 修改卸载指引为隐藏指引，防止在对话过程中，指引被重新创建，造成对话隐藏无效。
-- 			-- UIManager:UnLoadUI(QuestType.."TaskIndicator")
-- 			-- TaskIndicator:Hide()
-- 			TaskIndicator:InitIndicatorInfo(QuestId, nil, true)
-- 		end
-- 	end
-- end

-- 这里残留了旧的任务数据结构，这个函数不应该再使用了
-- function Component:TryToDoQuest(QuestChainId, QuestId)
-- 	local Quest = self:GetQuest(QuestChainId, QuestId)
-- 	if (Quest ~= nil) then
-- 		print(_G.LogTag, "QuestMgr, TryToDoQuest, QuestId is ", QuestId)
-- 	end
-- end

function Component:SetQuestTracking(QuestChainId, SubRegionId)
	local function Callback(Ret)
		if not self:CheckRegionErrorCode(Ret) then
			self:OnPrintToFeiShu_Quest(ErrorCode.RET_SUCCESS, Ret, " SetQuestTracking_设置追踪任务链失败 ", QuestChainId)
			return
		end
		local UIManager = GWorld.GameInstance:GetGameUIManager()
		local BattleMain = UIManager:GetUIObj("BattleMain")
		if BattleMain and BattleMain.Pos_TaskBar:GetChildAt(0) then
			BattleMain.Pos_TaskBar:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
			BattleMain.Pos_TaskBar:GetChildAt(0):SwitchTaskBarContentByTracking(true, true)
		end
		EventManager:FireEvent(EventID.UpdateMiniMap, nil, "Task", "Clear")
		
		local UIObjs = MissionIndicatorManager:GetIndicatorUIObjBySTLType("Task")
		local TargetSubRegionId = 0
		if not IsEmptyTable(UIObjs) then
			for k, UI in pairs(UIObjs) do
				if UI.CurGuideChainId ==  self.TrackingQuestChainId then
					local TargetKey = UI.GuideInfoCache.PointOrStaticCreatorName
					if TargetKey and GuidePointLocData[TargetKey] then
						TargetSubRegionId = GuidePointLocData[TargetKey].SubRegionId
					end
					local NpcUnitId = UI:GetTaskGuideNpcUnitIdFromCache()
					if NpcUnitId ~= nil and TaskUtils and TaskUtils.UpdateAllMissionNpcGuideMaps then
						TaskUtils:UpdateAllMissionNpcGuideMaps(true, k, NpcUnitId)
					end
					-- UI:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
					UI:Show("TrackQuest")

					UI:UpdateTaskIndicator()
					UI.PlayerRegionId = self.CurrentRegionId
					EventManager:FireEvent(EventID.UpdateMiniMap, UI:GetName(), "Task", "Add")
				else
					UI:Hide("TrackQuest")
				end
			end
		end
		EventManager:FireEvent(EventID.OnChangeTaskIndicator, TaskUtils.MissionNpcGuideMaps)
		
		if MissionIndicatorManager.TrackingSpecialSideQuestChainId ~= nil then
			local UnSpecialUIObjs = MissionIndicatorManager:GetSpecialSideIndicatorUIObj()
			if not IsEmptyTable(UnSpecialUIObjs) then
				for _, UI in pairs(UnSpecialUIObjs) do
					if IsValid(UI) and UI.OwenrQuestNpcId then
						EventManager:FireEvent(EventID.UpdateMiniMap, UI.OwenrQuestNpcId, "SpecialSide", "Add")
					end
				end
			end
		end

		-- local HasTeleport = false
        -- for _, Data in pairs(DataMgr.TeleportPoint) do
		-- 	if self.CurrentRegionId ~= TargetSubRegionId and TargetSubRegionId == HomeBaseRegionId then
		-- 		HasTeleport = true
		-- 		break
		-- 	elseif Data and Data.TeleportPointSubRegion and Data.TeleportPointSubRegion == TargetSubRegionId then
        --         HasTeleport =  true
        --     end
        -- end

		TaskUtils:UpdatePlayerSubRegionIdInfo(self.CurrentRegionId)
		-- local _, RegionMapId = TaskUtils:GetTrackingQuestMapInfo()
		-- local TrackingQuestData = TaskUtils:GetTrackingQuestDetailInfo()
		-- local IsFairyLand = false
		-- if TrackingQuestData and TrackingQuestData.IsFairyLand then
		-- 	IsFairyLand = TrackingQuestData.IsFairyLand
		-- end
		-- if not DataMgr.RegionMap[RegionMapId] or not DataMgr.RegionMap[RegionMapId].RegionId then
		-- 	return
		-- end
		-- local RegionId =  DataMgr.RegionMap[RegionMapId].RegionId
		-- local IsInRegion = self.CurrentRegionId and self.CurrentRegionId == TargetSubRegionId
		-- if CheckIsNeedShowLevelMap(self.CurrentRegionId, TargetSubRegionId) and
		-- (IsInRegion == false and IsFairyLand == false and HasTeleport == true) then --取消追踪之后，关闭任务面板又追踪
		-- 	local MainMap = UIManager:GetUIObj("LevelMapMain")
        --     if MainMap == nil then
        --         MainMap = UIManager:LoadUINew("LevelMapMain")
        --     end
		-- 	TaskUtils.bShowLevelMap = true
		-- 	-- MainMap.RealWildMap:ChangeRegion(RegionId)
		-- 	MainMap.RealWildMap:ChangeRegionForSmartIndicator(TargetSubRegionId)
		-- 	MainMap.RealWildMap:MoveMapToQuestTarget(self.TrackingQuestChainId)
		-- else
		-- 	EventManager:FireEvent(EventID.OnSetQuestTracking, QuestChainId)
		-- 	EventManager:FireEvent(EventID.PlayLoopAnimAfterBarAnim)
		-- end
		if SubRegionId and SubRegionId > 0 then
			EventManager:FireEvent(EventID.CheckShowMap, QuestChainId)
		end
	end
	if QuestChainId ~= self.TrackingQuestChainId or self.LastTrackingQuestChainId ~= self.TrackingQuestChainId then
		self:CallServer("SetQuestTracking", Callback, QuestChainId)
	else
		if SubRegionId and SubRegionId > 0 then
			EventManager:FireEvent(EventID.CheckShowMap, QuestChainId)
		end
	end
	
end

-- function Component:ShowDeliverPopupUI(InFairyLandRegionId, InQuestChainId)
-- 	if self.CurrentRegionId ~= InFairyLandRegionId then
-- 		local UIManager = GWorld.GameInstance:GetGameUIManager()
-- 		if not DataMgr.QuestChain[InQuestChainId] then
-- 			return
-- 		end
-- 		local TaskName = DataMgr.QuestChain[InQuestChainId].QuestChainName
-- 		local Params =
--         {
--         	ShortText = string.format("%s(%s)", GText("UI_Prompt_QuestTrans"), GText(TaskName)),
-- 			LeftCallbackObj = self,
-- 			LeftCallbackFunction = self.CancelDeliverTo,
-- 			RightCallbackObj = self,
-- 			RightCallbackFunction = self.DoDeliverTo,
-- 			CloseBtnCallbackObj = self,
-- 			CloseBtnCallbackFunction = self.CancelDeliverTo
--         }
--         UIManager:ShowCommonPopupUI(100160, Params)
-- 	end
-- end

-- function Component:CancelDeliverTo()
	
-- end

-- function Component:DoDeliverTo()
-- 	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
-- 	local TrackingQuestData = TaskUtils:GetTrackingQuestDetailInfo()
-- 	if IsValid(GameMode) and TrackingQuestData and TrackingQuestData.SubRegionId > 0 then
-- 		GameMode:HandleLevelDeliver(UE4.EModeType.ModeRegion, TrackingQuestData.SubRegionId, 1, true)
-- 	end
-- end

function Component:CancelQuestTracking(QuestChainId)
	local function Callback(Ret)
		if not self:CheckRegionErrorCode(Ret) then
			self:OnPrintToFeiShu_Quest(ErrorCode.RET_SUCCESS, Ret, " CancelQuestTracking_取消追踪任务链失败 ", QuestChainId)
			return
		end
		local UIManager = GWorld.GameInstance:GetGameUIManager()
		local BattleMain = UIManager:GetUIObj("BattleMain")
		if BattleMain then
			BattleMain.Pos_TaskBar:GetChildAt(0):SwitchTaskBarContentByTracking(false, false)
		end
		local UI = UIManager:GetUIObj("TaskIndicator")
		if UI then
			UI.CurGuideChainId = 0
		end
		-- 发送取消任务追踪事件
		EventManager:FireEvent(EventID.OnCancelQuestTracking, QuestChainId)
		local UIObjs = MissionIndicatorManager:GetIndicatorUIObjByQuestChainIdWithType(QuestChainId, "Task")
		if not IsEmptyTable(UIObjs) then
			for k, UI in pairs(UIObjs) do
				if TaskUtils and TaskUtils.UpdateAllMissionNpcGuideMaps then
					TaskUtils:UpdateAllMissionNpcGuideMaps(false, k, nil)
				end
			end
		end
		EventManager:FireEvent(EventID.OnChangeTaskIndicator, TaskUtils.MissionNpcGuideMaps)
		EventManager:FireEvent(EventID.UpdateMiniMap, nil, "Task", "Clear")
	end
	self:CallServer("CancelQuestTracking", Callback, QuestChainId)

end

function Component:OnQuestTargetFinish(Ret)
	DebugPrint("ZJT_ OnQuestTargetFinish ", Ret)
	if not self:CheckRegionErrorCode(Ret) then
		self:OnPrintToFeiShu_Quest(ErrorCode.RET_SUCCESS, Ret, " OnQuestTargetUpdate_更新完成进度错误 ")
		return
	end
	EventManager:FireEvent(EventID.OnGameModeComplete)
end

function Component:OnQuestTargetUpdate(Ret)
	DebugPrint("ZJT_ OnQuestTargetUpdate ", Ret)
	if not self:CheckRegionErrorCode(Ret) then
		self:OnPrintToFeiShu_Quest(ErrorCode.RET_SUCCESS, Ret, " OnQuestTargetUpdate_更新进度错误 ")
		return
	end
	EventManager:FireEvent(EventID.OnGameModeComplete)
end



---@field private 复用拾取物UI，显示任务链完成时获得的奖励
---@param RewardBox RewardBox 
function Component:ShowQuestChainRewardUI(RewardBox)
	if not RewardBox then return end
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	local BattleMain = UIManager:GetUIObj("BattleMain")
	if not BattleMain then
		print(WarningTag, "当前在据点中，目前据点主UI与野外主UI不统一，据点暂时不显示任务链完成奖励")
		return
	end

	---@see DungeonMgr#AddRewardsToCache Avatar的组件类成员
	self:AddRewardsToCache(RewardBox)
	for _,DataType in pairs(CommonConst.DataType) do
		local RewardProps = RewardBox[DataType.."s"];
		if not RewardProps then goto continue end
		self:ShowRewardUI(RewardProps, DataType, CommonConst.RewardReason.Quest)
		::continue::
	end
end

---@field public 通用的战斗界面奖励列表显示逻辑
---@param RewardProps table
---@param RewardReason CommonConst.RewardReason
---@param DataType CommonConst.DataType
function Component:ShowRewardUI(RewardProps, DataType, RewardReason)
	---@see BonusMgr#ShowDungeonRewardUI Avatar的组件类成员
	UIUtils.ShowDungeonRewardUI(RewardProps, RewardReason, DataType)
end

function Component:FailerSpecialQuest(SpecialQuestId, infos, NodeCallback)
	local function Callback(Ret)
		DebugPrint("ZJT_ FailerSpecialQuest ", Ret, SpecialQuestId)
		if ErrorCode:Check(Ret) then
			NodeCallback()
		else
			self:OnPrintToFeiShu_Quest(ErrorCode.RET_SUCCESS, Ret, " FailerSpecialQuest_特殊任务失败错误 ", SpecialQuestId)
		end
	end
	self:CallServer("FailerSpecialQuest",Callback, SpecialQuestId, infos)
end

function Component:SuccessSpecialQuest(SpecialQuestId, infos, NodeCallback)
	local function Callback(Ret)
		DebugPrint("ZJT_ SuccessSpecialQuest ", Ret, SpecialQuestId)
		if ErrorCode:Check(Ret) then
			NodeCallback()
		else
			self:OnPrintToFeiShu_Quest(ErrorCode.RET_SUCCESS, Ret, " SuccessSpecialQuest_成功特殊任务失败 ", SpecialQuestId)
		end
	end
	self:CallServer("SuccessSpecialQuest", Callback, SpecialQuestId, infos)
end

function Component:StartSpecialQuest(SpecialQuestId, infos, NodeCallback)
	local function Callback(Ret)
		DebugPrint("ZJT_ StartSpecialQuest ServerCallBack ", Ret, SpecialQuestId)
		if ErrorCode:Check(Ret) then
			NodeCallback()
		else
			self:OnPrintToFeiShu_Quest(ErrorCode.RET_SUCCESS, Ret, " StartSpecialQuest_开始特殊任务错误 ", SpecialQuestId)
		end
	end
	self:CallServer("StartSpecialQuest",Callback, SpecialQuestId, infos)
end

function Component:StopQuestChainExcept(ChainId)
	local chain = nil
	for index, id in ipairs(self.CanReciveQuestChainIds) do
		chain = self.QuestChains[id]
		if chain and id ~= ChainId and (chain:IsDoing() or chain:IsUnlock()) then
			local FilePath = chain.StoryPath
			GWorld.StoryMgr:StopStoryline(FilePath)
		end
	end
end

function Component:HandleQuestChainDoing(QuestChainId, cb)
	local function Callback(Ret)
		self.logger.debug("ZJT_ HandleQuestChainDoing ", Ret, QuestChainId)
		if cb then
			cb(Ret)
		end
		if not self:CheckRegionErrorCode(Ret) then 
			self:OnPrintToFeiShu_Quest(ErrorCode.RET_SUCCESS, Ret, " HandleQuestChainDoing_手动开始任务错误 ", QuestChainId)
			return
		end
	end
	self:CallServer("HandleQuestChainDoing", Callback, QuestChainId)
end

--- 这里有且只可能是同区域传送
function Component:NotifyQuestDeliver(DeliverId, DeliverStartIndex, IsWhite)
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	DebugPrint("ZJT_ NotifyQuestDeliver ", DeliverId, DeliverStartIndex, self.CurrentRegionId, IsWhite)
	if IsValid(GameMode) then
		local bIsInvitation = nil
		local bIsFromMap = nil
		local bShouldReturnAndDownloadPatch = true
		DebugPrint("TTT:Talk:QuestMgr")
		GameMode:HandleLevelDeliver(UE4.EModeType.ModeRegion, DeliverId, DeliverStartIndex, IsWhite, bIsInvitation, bIsFromMap, bShouldReturnAndDownloadPatch)
	end
end

function Component:RegisterQuestPickId(QuestPickId, CallbackFunc)
	local function Callback(Ret)
		if not self:CheckRegionErrorCode(Ret) then 
			self:OnPrintToFeiShu_Quest(ErrorCode.RET_SUCCESS, Ret, " RegisterQuestPickId_注册拾取掉落物错误 ", QuestPickId)
			return
		end
		if ErrorCode:Check(Ret) then
			CallbackFunc()
		end
	end
	self:CallServer("RegisterQuestPickId", Callback, QuestPickId)
end

function Component:QuestPickComplete(CompleteTable)
	for _,QuestPickupId in pairs(CompleteTable) do
		local QuestPickupId2Callback = GWorld.StoryMgr.QuestPickupId2Callback
		if QuestPickupId2Callback and QuestPickupId2Callback[QuestPickupId] then
			QuestPickupId2Callback[QuestPickupId]()
			GWorld.StoryMgr.QuestPickupId2Callback[QuestPickupId] = nil
		end
	end
end

function Component:UpdateStoryVariable(StoryVariableName, StoryVariableValue)
	local function Callback( Ret )
		if ErrorCode:Check(Ret) then
			EventManager:FireEvent(EventID.OnStoryVarUpdated, StoryVariableName, StoryVariableValue)
		end
		self.logger.debug("ZJT_ UpdateStoryVariable ", Ret, StoryVariableName, StoryVariableValue)
	end
	self:CallServer("UpdateStoryVariable", Callback, StoryVariableName, StoryVariableValue)
end

function Component:RemoveStoryVariable(StoryVariableName)
	local function Callback( Ret )
		self.logger.debug("ZJT_ RemoveStoryVariable ", Ret, StoryVariableName)
	end
	self:CallServer("RemoveStoryVariable", Callback, StoryVariableName)
end

function Component:S2C_SwitchGuide_QuestChain()
	EventManager:FireEvent(EventID.OnChangeTaskIndicator, TaskUtils.MissionNpcGuideMaps)

	local Avatar = GWorld:GetAvatar()
	if not Avatar then return end
	local TrackQuestChainId = Avatar.TrackingQuestChainId
	-- local TaskBar = TaskUtils:GetTaskBarWidget()
	-- if TaskBar then
	-- 	TaskBar:ChangeTrackingChainByFinishQuest()
	-- end
	if Avatar.InSpecialQuest and ClientEventUtils:GetCurrentEvent() and ClientEventUtils:GetCurrentEvent().PreQuestChainId then
		TrackQuestChainId = ClientEventUtils:GetCurrentEvent().PreQuestChainId
	end
	local QuestChain = Avatar.QuestChains[TrackQuestChainId] 
	if not QuestChain then return end
	local DoingQuestId = QuestChain.DoingQuestId
	AudioManager(GWorld):UpdateQuestChainIdAndQuestId(TrackQuestChainId, DoingQuestId)
	local UIObjs = MissionIndicatorManager:GetIndicatorUIObjBySTLType("Task")
	local TargetSubRegionId = 0
	if not IsEmptyTable(UIObjs) then
		for k, UI in pairs(UIObjs) do
			if UI.CurGuideChainId == self.TrackingQuestChainId then
				UI:Show("TrackQuest")
				EventManager:FireEvent(EventID.UpdateMiniMap, UI:GetName(), "Task", "Add")
			end
		end
	end
end

function Component:HandleQuestChainDoing_QuestComplete(ServerParamTable)
	local QuestChainId = ServerParamTable.QuestChainId
	if DataMgr.QuestChain[QuestChainId] and DataMgr.QuestChain[QuestChainId].QuestNpcId then
		MissionIndicatorManager:ReactiveMissionIndicatorByRegionMap(DataMgr.QuestChain[QuestChainId].QuestNpcId)
	end

	local function CallBack(Ret, RewardBox)
		self:HandleRemoveBlackScreenOnDelivery(ServerParamTable.bIsPlayBlackScreenOnComplete, ServerParamTable.QuestChainId, ServerParamTable.QuestId)
		UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Quest_GetQuestSuccess"))
		self.logger.debug("ZJT_ HandleQuestChainDoing_QuestComplete ", Ret)
		local TaslBar = TaskUtils:GetTaskBarWidget()
		if self.TrackingQuestChainId == 0 then
			if TaslBar and QuestChainId > 0 then
				local IconTexture = TaskUtils:GetIconTextureByTrackQuestChainType(QuestChainId)
				if IconTexture then
					TaslBar.Icon_GuidePoint:SetBrushResourceObject(IconTexture)
				end
			end
		else
			if TaslBar and self.TrackingQuestChainId > 0 then
				local IconTexture = TaskUtils:GetIconTextureByTrackQuestChainType(self.TrackingQuestChainId)
				if IconTexture then
					TaslBar.Icon_GuidePoint:SetBrushResourceObject(IconTexture)
				end
			end
		end
	end
	self:HandleAddBlackScreenOnDelivery(ServerParamTable.bIsPlayBlackScreenOnComplete, ServerParamTable.QuestChainId, ServerParamTable.QuestId)
	self:CallServer("HandleQuestChainDoing_QuestComplete", CallBack, ServerParamTable)
end

function Component:NotifyActiveQuestChainEnd(QuestChainId)
	local Avatar = GWorld:GetAvatar()
	if Avatar then
		DebugPrint("LHQ@@@NotifyActiveQuestChainEnd:", Avatar.TrackingQuestChainId)
	end
	self.logger.debug("ZJT_ ServerCallClient NotifyActiveQuestChainEnd ", QuestChainId)

	local SpecialQuestIds = DataMgr.SpecialQuestId2QuestChainId[QuestChainId]
	if SpecialQuestIds then
		for _,SpecialQuestId in pairs(SpecialQuestIds) do
			ClientEventUtils:TryInterruptSpecialQuestEvent(SpecialQuestId, "ServerNotifyEnd")
		end
	end

	local QuestChain = self.QuestChains[QuestChainId]
	local StoryPath = QuestChain.StoryPath
	GWorld.StoryMgr:StopStoryline(StoryPath)

	local GameMode = UGameplayStatics.GetGameMode(GWorld.GameInstance)
	GameMode:ClearRegionActorData("QuestChainId", QuestChainId, EDestroyReason.QuestChainClear, function(Target, Key, Value)
        return Target.QuestChainId == Value
    end)

	local TaslBar = TaskUtils:GetTaskBarWidget()
	if TaslBar then
		TaslBar:SwitchTaskBarContentByTracking(true, true)
	end

	local Indicators = MissionIndicatorManager:GetIndicatorUIObjByQuestChainIdWithType(QuestChainId, "Task")
	if IsEmptyTable(Indicators) == false then
		for _, Indicator in pairs(Indicators) do
			if Indicator then
				Indicator:CloseIndicator()
			end
		end
	end
end

function Component:CheckHaveSuccQuestDeliver(QuestChain, QuestId)
	local QuestChainInfo = DataMgr.STLExportQuestChain[QuestChain]
	local QuestInfo = QuestChainInfo.Quests[QuestId]
	local QuestDeliverInfo = QuestInfo.SuccQuestDeliver
	if not QuestInfo.SuccQuestDeliver then
		return false
	end
	if QuestDeliverInfo.DeliverType == 1 then
		if not self:CheckSubRegionId(QuestDeliverInfo.Id) then
			return false
		end
	elseif QuestDeliverInfo.DeliverType == 2 then
		if not self:DungeonIdCheck(QuestDeliverInfo.Id) then
			return false
		end
	else
		return false
	end
	return true
end

function Component:HandleAddBlackScreenOnDelivery(bIsPlayBlackScreenOnComplete, QuestChain, QuestId)
	if bIsPlayBlackScreenOnComplete and self:CheckHaveSuccQuestDeliver(QuestChain, QuestId) then
		DebugPrint("gyy@HandleAddBlackScreenOnDelivery ",QuestChain, QuestId)
		GWorld.StoryMgr:AddStoryBlackScreenOnDelivery()
	end
end

function Component:HandleRemoveBlackScreenOnDelivery(bIsPlayBlackScreenOnComplete, QuestChain, QuestId)
	if bIsPlayBlackScreenOnComplete and self:CheckHaveSuccQuestDeliver(QuestChain, QuestId) then
		DebugPrint("gyy@HandleRemoveBlackScreenOnDelivery ",QuestChain, QuestId)
		GWorld.StoryMgr:RemoveStoryBlackScreenOnDelivery()
	end
end

function Component:GMSuccQuestComplete(Ret, QuestId, QuestChainId, TargetCompleteQuestIds, RewardBox, TargetClientVarParams)
	if Ret ~= ErrorCode.RET_SUCCESS then
		self.logger.error("ZJT_ 11111111 GMSuccQuestComplete 失败 ", Ret, QuestId, QuestChainId, TargetCompleteQuestIds, RewardBox, TargetClientVarParams)
		return
	end
	PrintTable({RewardBox = RewardBox}, 10)
	local TaskChainConfig = DataMgr.QuestChain[QuestChainId]
	if next(RewardBox) and TaskChainConfig.QuestReward and TaskChainConfig.QuestReward[QuestId] then
		if RewardBox ~= nil and next(RewardBox) ~= nil and not RewardBox.bEmpty then
			UIUtils.ShowGetItemPage(nil, nil, nil, RewardBox)
		end
	end
	self:HandleClientQuestCompleteEvent(Ret, false, QuestId, QuestChainId, TargetCompleteQuestIds, TargetClientVarParams)
end

function Component:SelectStoryOption(OptionId)
	self.SelectedKeyOption = self.SelectedKeyOption or {}
	self.SelectedKeyOption[OptionId] = true
end

function Component:IsStoryOptionSelected(OptionId)
	self.SelectedKeyOption = self.SelectedKeyOption or {}
	return self.SelectedKeyOption[OptionId] == true
end

-- 提交物品是否已完成
function Component:GetIsSubmitComplete(SubmitId)
	return false
end

-- 提交物品（提交物品节点）
function Component:SubmitQuestItems(SubmitId, InCallback)
	local function Callback(Ret)
		if InCallback then
			InCallback(ErrorCode:Check(Ret))
		end
		self.logger.debug("SubmitQuestItems ", Ret, SubmitId)
	end
	self:CallServer("SubmitQuestItems", Callback, SubmitId)
	Callback(0)
end

return Component


-- local Class = require 'StoryCreator.StoryLogic.Class'
local StorylineUtils = require 'StoryCreator.StoryLogic.StorylineUtils'
local GuidePointLocData = require ("BluePrints.UI.TaskPanel/QuestGuidePointLocData")
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"

---@class StoryMgr
---@field protected Storylins table<string, Storyline>
---@field protected StaticCreatorActorEvents table<integer, table<integer, any>>
-- local StoryMgr = Class.Class('StoryMgr')
local StoryMgr = Class('StoryCreator.StoryLogic.StorylineNodes.NodeObject')

local STLogType = UE.EStoryLogType.STL

function StoryMgr:Init()
	self.Storylines = {}
	self.StorylinesNeedRestart = {}
	self.StaticCreatorActorEvents = {}
	self.NpcInteractiveTalkDetail = {}
	self.NpcInteractiveTalkId = 0
	self.WaitTalkTriggerCompleted = {}
	self.bEnableStory = true
end

function StoryMgr:IsCanRunStoryMgr()
	if (IsStandAlone(GWorld.GameInstance) or IsClient(GWorld.GameInstance)) then
		return true
	end
	return false
end

function StoryMgr:EnableStory()
	self.bEnableStory = true
	EventManager:FireEvent(EventID.OnEnableStory)
	EventManager:AddEvent(EventID.InLoading, self, self.HandleInLoading)
end

function StoryMgr:DisableStory()
	self.bEnableStory = false
	EventManager:RemoveEvent(EventID.InLoading, self)
end

function StoryMgr:HandleInLoading()
	self:DisableStory()
	if (self:IsCanRunStoryMgr() == false) then
		return
	end
	if TaskUtils and TaskUtils.RemoveAllQuestExtraInfo then
		TaskUtils:RemoveAllQuestExtraInfo()
	end
	self:Clear()
end

function StoryMgr:Clear()
	DebugPrint("StoryMgr:Clear")
	self:StopAllStoryline()
	self:ClearStaticCreatorActorEvent()
	self:UnbindAllNPCInteractiveTalk()
	self:ClearAllWaitCompleteTalkTrigger()
end

function StoryMgr:RunStory(StoryPath, QuestId, NodeId, EndCallback, StopCallback, Payload)
	if self.Storylines[StoryPath] then
		DebugPrint("StoryMgr:RunStory:Already Exit", StoryPath, QuestId, NodeId, EndCallback, StopCallback, Payload)
		return
	end

	local Storyline = StorylineUtils.BuildStoryline(StoryPath, EndCallback, StopCallback, Payload)

	if (self.bEnableStory == false) then
		local Title = "STL 已禁用"
		local Message = string.format("试图在禁用时运行新的 STL %s", StoryPath)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, Title, Message)
	end

	if not Storyline then
		local Message = "Story不存在"..
        "\nFileName:"..StoryPath
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "Story不存在", Message)
		return
	end
	DebugPrint("StoryMgr:RunStory", StoryPath, QuestId, NodeId, EndCallback, StopCallback, Payload)
	self.Storylines[StoryPath] = Storyline
	Storyline:StartStory(tonumber(QuestId), NodeId)

	return Storyline.FilePath
end

function StoryMgr:GetStory(StoryPath)
	local Storyline = self.Storylines[StoryPath]
	return Storyline
end

function StoryMgr:IsRunningStoryline(StoryPath)
	return self.Storylines[StoryPath] ~= nil
end

function StoryMgr:StopStoryline(StoryPath, IgnoreFinishClear)
	local Storyline = self.Storylines[StoryPath]
	if Storyline then
		Storyline:Stop(IgnoreFinishClear)
		self.Storylines[StoryPath] = nil
		self.StorylinesNeedRestart[StoryPath] = nil
	end
end

function StoryMgr:FinishStory(StoryPath)
	self.Storylines[StoryPath] = nil
	self.StorylinesNeedRestart[StoryPath] = nil
end

function StoryMgr:StopAllStoryline()
	local Storylines = {}
	for _, Storyline in pairs(self.Storylines) do
		table.insert(Storylines, Storyline)
	end

	for _, Storyline in pairs(Storylines) do
		Storyline:Stop()
	end

	self.Storylines = {}
	self.StorylinesNeedRestart = {}
end

function StoryMgr:SuccessAllQuest()
	for _, Storyline in pairs(self.Storylines) do
		Storyline:Success()
	end
end

function StoryMgr:BindStaticCreatorActorEvent(StaticCreatorId, ActorEventType, Obj, Func)
	local ActorEvents = self.StaticCreatorActorEvents[StaticCreatorId]
	if ActorEvents == nil then
		ActorEvents = {}
		self.StaticCreatorActorEvents[StaticCreatorId] = ActorEvents
	end
	ActorEvents[ActorEventType] = {Obj, Func}
end

function StoryMgr:UnbindStaticCreatorActorEvent(StaticCreatorId)
	if self.StaticCreatorActorEvents[StaticCreatorId] then
		self.StaticCreatorActorEvents[StaticCreatorId] = nil
	end
end

function StoryMgr:UnbindStaticCreatorActorEventByType(StaticCreatorId, ActorEventType)
	if self.StaticCreatorActorEvents[StaticCreatorId] then
		if self.StaticCreatorActorEvents[StaticCreatorId][ActorEventType] then
			self.StaticCreatorActorEvents[StaticCreatorId][ActorEventType] = nil
		end
	end
end

function StoryMgr:TryExecStorylineActorEvent(StaticCreatorId, ActorEventType, Info)
	local ActorEvents = self.StaticCreatorActorEvents[StaticCreatorId]
	if ActorEvents then
		local ActorEvent = ActorEvents[ActorEventType]
		if ActorEvent and ActorEvent[1] and ActorEvent[2] then
			ActorEvent[2](ActorEvent[1], Info)
		end
	end
end

function StoryMgr:ClearStaticCreatorActorEvent()
	self.StaticCreatorActorEvents = {}
end

function StoryMgr:BindNPCInteractiveTalk(NPCId, Detail)
	self.NpcInteractiveTalkId = self.NpcInteractiveTalkId + 1
	local BindId = self.NpcInteractiveTalkId
	if not self.NpcInteractiveTalkDetail[NPCId] then
		self.NpcInteractiveTalkDetail[NPCId] = {}
	end
	self.NpcInteractiveTalkDetail[NPCId][BindId] = Detail
	return BindId
end

function StoryMgr:UnbindNPCInteractiveTalk(NPCId, BindId)
	if not BindId then return end
	local BindInfos = self.NpcInteractiveTalkDetail[NPCId]
	if not BindInfos then return end
	BindInfos[BindId] = nil
end

function StoryMgr:GetNPCInteractiveTalkDetails(NPCId)
	return self.NpcInteractiveTalkDetail[NPCId]
end

function StoryMgr:ExistedNPCInteractiveTalk(NPCId)
	local BindInfos = self.NpcInteractiveTalkDetail[NPCId]
	return BindInfos and next(BindInfos) ~= nil
end

function StoryMgr:TryGetWaitTalkCompletedQuest(TalkTriggerId)
	return self.WaitTalkTriggerCompleted[TalkTriggerId]
end

function StoryMgr:RegisterWaitTalkCompleted(TalkTriggerId, QuestChainId, SpecialQuestId, DynQuestId, ShowGuide)
	self.WaitTalkTriggerCompleted[TalkTriggerId] = {QuestChainId = QuestChainId, SpecialQuestId = SpecialQuestId, ShowGuide = ShowGuide, DynQuestId = DynQuestId }
end

function StoryMgr:UnRegisterWaitTalkCompleted(TalkTriggerId)
	self.WaitTalkTriggerCompleted[TalkTriggerId] = nil
end

function StoryMgr:ClearAllWaitCompleteTalkTrigger()
	self.WaitTalkTriggerCompleted = {}
end

function StoryMgr:TryExecNPCInteractiveTalk(NPCId, NPC, BindId, TalkEndCallback)
	local BindInfos = self.NpcInteractiveTalkDetail[NPCId]
	if not BindInfos then 
		if TalkEndCallback and TalkEndCallback.Func then
			TalkEndCallback.Func(TalkEndCallback.Obj)
		end
		return
	end
	if not BindId then
		BindId = next(BindInfos)
	end
	local Detail = BindInfos[BindId]
	if Detail and Detail.Func then
		Detail.Func(NPC, TalkEndCallback)
	else
		if TalkEndCallback and TalkEndCallback.Func then
			TalkEndCallback.Func(TalkEndCallback.Obj)
		end
	end
end

function StoryMgr:UnbindAllNPCInteractiveTalk()
	self.NpcInteractiveTalkDetail = {}
	self.NpcInteractiveTalkId = 0
end

function StoryMgr:PrintStorylineInfo()
	for _, Storyline in pairs(self.Storylines) do
		Storyline:PrintInfo()
	end
end

function StoryMgr:CreateQuestPickupId2Callback(QuestPickupId, Callback)
	if not self.QuestPickupId2Callback then
		self.QuestPickupId2Callback = {}
	end
	self.QuestPickupId2Callback[QuestPickupId] = Callback
end

function StoryMgr:GetRunningNodeTableByType(NodeType, OutRunningNodeTable)
	for _, Storyline in pairs(self.Storylines) do
		Storyline:GetRunningNodeTableByType(NodeType, OutRunningNodeTable)
	end
end

function StoryMgr:GetResurgencePointInfo()
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end
	if not Avatar.TrackingQuestChainId then
		return
	end
	local CurrentRegionId = Avatar:GetCurrentRegionId()
	if not CurrentRegionId or CurrentRegionId <= 0 then
		return
	end
	local QuestChain = Avatar.QuestChains[Avatar.TrackingQuestChainId]
	local DoingQuestId = QuestChain.DoingQuestId
	local Storyline = self.Storylines[QuestChain.StoryPath]
	local StoryNode = Storyline.QuestIdNodeList[DoingQuestId]
	if StoryNode.ResurgencePoint ~= "" then
		local PointInfo = GuidePointLocData[StoryNode.ResurgencePoint]
		if not PointInfo then
			local Message = "StoryNode中配置的复活点在QuestGuidePointLoc表中不存在"..
			"\nFileName:"..QuestChain.StoryPath..
			"\nQuestChainId:"..Storyline.QuestChainId..
			"\nQuestId:"..DoingQuestId..
			"\nResurgencePoint:"..StoryNode.ResurgencePoint
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "StoryNode中配置的复活点在QuestGuidePointLoc表中不存在", Message)
			return
		end
		if not PointInfo.SubRegionId or PointInfo.SubRegionId <= 0 then
			local Message = "StoryNode中配置的复活点在QuestGuidePointLoc表中无SubRegionId"..
			"\nFileName:"..QuestChain.StoryPath..
			"\nQuestChainId:"..Storyline.QuestChainId..
			"\nQuestId:"..DoingQuestId..
			"\nResurgencePoint:"..StoryNode.ResurgencePoint
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "StoryNode中配置的复活点在QuestGuidePointLoc表中无SubRegionId", Message)
			return
		end
		if DataMgr.SubRegion[CurrentRegionId].RegionId == DataMgr.SubRegion[PointInfo.SubRegionId].RegionId then
			local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
			local NewTargetPoint = GameState:GetTargetPoint(StoryNode.ResurgencePoint)
			if (IsValid(NewTargetPoint)) then
				return {Transform = NewTargetPoint:GetTransform(), FailBlackScreenText = StoryNode.FailBlackScreenText,
				FadeInTime = StoryNode.FadeInTime, FadeOutTime = StoryNode.FadeOutTime, ContinueTime = StoryNode.ContinueTime}
			else
				DebugPrint("gyy@ Use ResurgencePoint, NewTargetPoint is not valid")
				return
			end
		else
			DebugPrint("gyy@ Use ResurgencePoint, CurrentRegionId and TargetRegionId are not equal")
			return
		end
	else
		if not StoryNode.bUseQuestCoordinate then
			return
		end
		local QuestCoordinate = QuestChain.QuestCoordinate
		if not QuestCoordinate then
			return
		end
		local TargetRegionId = QuestCoordinate.SubRegionId
		if not TargetRegionId or TargetRegionId < 0 then
			return
		elseif TargetRegionId == 0 then
			local Message = "任务链中的第一个任务，想要使用复活功能需要配置复活点位"..
			"\nFileName:"..QuestChain.StoryPath..
			"\nQuestChainId:"..Storyline.QuestChainId..
			"\nQuestId:"..DoingQuestId
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务链中的第一个任务，想要使用复活功能需要配置复活点位", Message)
			return
		end
		if DataMgr.SubRegion[CurrentRegionId].RegionId ~= DataMgr.SubRegion[TargetRegionId].RegionId then
			DebugPrint("gyy@ CurrentRegionId and TargetRegionId are not equal")
			return
		end
		if QuestCoordinate.StartIndex > 0 then
			local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
			local LevelLoader = GameMode:GetLevelLoader()
			local LevelId = LevelLoader:GetLevelIdByRegionId(QuestCoordinate.SubRegionId)
			local TargtePoint = LevelLoader:GetStartPointByManager(LevelId, QuestCoordinate.StartIndex)
			if (IsValid(TargtePoint)) then
				return {Transform = TargtePoint:GetTransform(), FailBlackScreenText = StoryNode.FailBlackScreenText,
				FadeInTime = StoryNode.FadeInTime, FadeOutTime = StoryNode.FadeOutTime, ContinueTime = StoryNode.ContinueTime}
			else
				DebugPrint("gyy@ Use StartIndex, TargtePoint is not valid")
				return
			end
		else
			local TargetTransform = UE4.UKismetMathLibrary.MakeTransform(FVector(QuestCoordinate.Location[1],QuestCoordinate.Location[2],QuestCoordinate.Location[3]),
				FRotator(QuestCoordinate.Rotation[1],QuestCoordinate.Rotation[2],QuestCoordinate.Rotation[3]) , FVector(1, 1, 1))
			return {Transform = TargetTransform, FailBlackScreenText = StoryNode.FailBlackScreenText,
			FadeInTime = StoryNode.FadeInTime, FadeOutTime = StoryNode.FadeOutTime, ContinueTime = StoryNode.ContinueTime}
		end
	end
end

function StoryMgr:FailCurrentQuestWhenDead()
	local StoryNode = self:GetCurrentStoryNode()
	if not StoryNode then
		return
	end
	if not StoryNode.bDeadTriggerQuestFail then
		return
	end
	StoryNode.Questline:FailQuest()
end

function StoryMgr:GetCurrentStoryNode()
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end
	if not Avatar.TrackingQuestChainId then
		return
	end
	if Avatar.TrackingQuestChainId <= 0 then
		return
	end
	if Avatar:IsQuestChainFinished(Avatar.TrackingQuestChainId) then
		return
	end
	local QuestChain = Avatar.QuestChains[Avatar.TrackingQuestChainId]
	if not QuestChain then
		return
	end
	local DoingQuestId = QuestChain.DoingQuestId
	if not DoingQuestId then
		return
	end
	local Storyline = self.Storylines[QuestChain.StoryPath]
	if not Storyline then
		return
	end
	return Storyline.QuestIdNodeList[DoingQuestId]
end

function StoryMgr:AddToWaitingRestartList(Storyline)
	self.StorylinesNeedRestart[Storyline.FilePath] = Storyline
end

function StoryMgr:TryRestartStoryline()
	DebugPrint('StoryMgr TryRestartStoryline')
	local Flag = false
	local RestartStorylines = {}
	for _, Storyline in pairs(self.StorylinesNeedRestart) do
		Flag = true
		table.insert(RestartStorylines, Storyline)
	end
	if Flag then
		DebugPrint('StoryMgr RestartStoryline')
		for _,Storyline in pairs(RestartStorylines) do
			Storyline:RestartNodes()
		end
		self:RemoveStoryBlackScreenOnFail()
	end
	self.StorylinesNeedRestart = {}
end

function StoryMgr:PrintStorylineNeedRestartInfo()
	for _, Storyline in pairs(self.StorylinesNeedRestart) do
		Storyline:PrintInfo()
	end
end

function StoryMgr:AddStoryBlackScreen(ExtralInfo)
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	if not UIManager:IsCommonBlackScreenExist(ExtralInfo.HandleName) then
		local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
		local Params = {}
		Params.BlackScreenHandle = ExtralInfo.HandleName
		Params.InAnimationPlayTime = ExtralInfo.InTime or 0
		Params.OutAnimationPlayTime = ExtralInfo.OutTime or 0
		if IsValid(Player) then
			Player:AddDisableInputTag(ExtralInfo.HandleName)
		end
		UIManager:SetBannedActionCallback("BlackScreen", true, ExtralInfo.HandleName)
		UIManager:ShowCommonBlackScreen(Params)
	end
	local BlackUIFadeOut = function()
		if ExtralInfo.TimeOverCallback then
			local Obj = ExtralInfo.TimeOverCallback.Obj
			local Func = ExtralInfo.TimeOverCallback.Func
			local Params = ExtralInfo.TimeOverCallback.Params
			Func(Obj,Params)
		end
		self:RemoveStoryBlackScreen(ExtralInfo.HandleName)
	end
	GWorld.GameInstance:AddTimer(ExtralInfo.ContinueTime or 10,BlackUIFadeOut,false,nil,ExtralInfo.HandleName,true)
end

function StoryMgr:RemoveStoryBlackScreen(HandleName)
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	if UIManager:IsCommonBlackScreenExist(HandleName) then
		GWorld.GameInstance:RemoveTimer(HandleName)
		local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
		if IsValid(Player) then
			Player:RemoveDisableInputTag(HandleName)
		end
		UIManager:SetBannedActionCallback("BlackScreen", false, HandleName)
		UIManager:HideCommonBlackScreen(HandleName)
	end
end

function StoryMgr:AddStoryBlackScreenOnFail()
	local ExtralInfo = {
		HandleName = "StoryBlackScreenOnFail",
	}
	self:AddStoryBlackScreen(ExtralInfo)
end

function StoryMgr:RemoveStoryBlackScreenOnFail()
	local HandleName = "StoryBlackScreenOnFail"
	self:RemoveStoryBlackScreen(HandleName)
end

function StoryMgr:AddStoryBlackScreenOnSucc(WaitingQuest)
	if not self.WaitingQuest then
		self.WaitingQuest = {}
	end
	local AddFlag = false
	for _,Id in pairs(WaitingQuest) do
		if not self.WaitingQuest[Id] then
			self.WaitingQuest[Id] = 1
			AddFlag = true
		end
	end
	if AddFlag then
		local ExtralInfo = {
			HandleName = "StoryBlackScreenOnSucc",
			TimeOverCallback = {
				Obj = self,
				Func = self.RemoveWaitingQuest
			}
		}
		self:AddStoryBlackScreen(ExtralInfo)
	end
end

function StoryMgr:RemoveWaitingQuest()
	self.WaitingQuest = nil
end

function StoryMgr:TryRemoveStoryBlackScreenOnSucc(QuestChainId, QuestId)
	if not (self.WaitingQuest and (self.WaitingQuest[QuestChainId] or self.WaitingQuest[QuestId])) then
		return
	end
	self.WaitingQuest[QuestChainId] = nil
	self.WaitingQuest[QuestId] = nil
	if not next(self.WaitingQuest) then
		self:RemoveStoryBlackScreenOnSucc()
	end
end

function StoryMgr:RemoveStoryBlackScreenOnSucc()
	local HandleName = "StoryBlackScreenOnSucc"
	self:RemoveWaitingQuest()
	self:RemoveStoryBlackScreen(HandleName)
end

function StoryMgr:AddStoryBlackScreenOnDelivery()
	local ExtralInfo = {
		HandleName = "StoryBlackScreenOnDelivery",
	}
	self:AddStoryBlackScreen(ExtralInfo)
end

function StoryMgr:RemoveStoryBlackScreenOnDelivery()
	local HandleName = "StoryBlackScreenOnDelivery"
	self:RemoveStoryBlackScreen(HandleName)
end

return StoryMgr


-------------------------Quest Start Node-----------------------------

local QuestStartNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
local QuestNodeUtils = require 'StoryCreator.StoryLogic.QuestNodeUtils'
local EActorEventType = require 'StoryCreator.StoryLogic.StorylineUtils'.EActorEventType

QuestStartNode.IsStartNode = true

function QuestStartNode:Start(Context, InPortName)
	self.GoToRegionSubIds = {}
	if self.SubRegionIdList then
		for i = 1, #self.SubRegionIdList do
			self.GoToRegionSubIds[self.SubRegionIdList[i]] = true
		end
	end
	if self.SubRegionId and self.SubRegionId ~= 0 then
		self.GoToRegionSubIds[self.SubRegionId] = true
	end
	self.Super.Start(self, Context, InPortName)
end

function QuestStartNode:RemoveAllSubRegionCallBack()
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end
	for SubRegionId, _ in pairs(self.GoToRegionSubIds) do
		Avatar:RemoveSubRegionSkipCallback(SubRegionId, self, self.GoToRegionCallBack)
	end
end

function QuestStartNode:GoToRegionCallBack()
	local Avatar = GWorld:GetAvatar()
	if not self.GoToRegionSubIds[Avatar.CurrentRegionId] then
		return
	end
	DebugPrint("XXN_ Exce RegionSkipCallBack GoToRegionNode:GoToRegion Callback, RegionId, ", self.GoToRegionSubIds[Avatar.CurrentRegionId], " CurrentRegionId", Avatar.CurrentRegionId)
	self:SuccessExecuteStartNode()
	self:RemoveAllSubRegionCallBack()
	self.IsSetGotoRegionCallback = false
end

function QuestStartNode:Execute(Callback)
	self.QuestStartCallback = Callback
	self:UpdateStartNodeTaskBarInfo()
	if self.StoryGuidePointName ~= "" then
		self:TriggerShowOrCloseMissionIndicator(true)
	end
	if self.JumpId ~= 0 then
		TaskUtils:SetQuestInterfaceJump(self.QuestId, true, self.JumpId, false)
	end

	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if self.IsFairyLand and self.FairyLandStaticCreatorId and self.FairyLandStaticCreatorId ~= 0 and GameMode then
		GWorld.StoryMgr:BindStaticCreatorActorEvent(self.FairyLandStaticCreatorId, EActorEventType.OnCreated, self, self.LoadFinishCallback)
		QuestNodeUtils.STLTriggerActiveStaticCreator(self, {self.FairyLandStaticCreatorId})
	end

	if self.GoToRegionSubIds and CommonUtils.TableLength(self.GoToRegionSubIds) > 0 and self.QuestChainId > 0 then
		local Avatar = GWorld:GetAvatar()
		if not GameMode or not Avatar then
			GWorld.logger.error("XXN_ QuestStartNode Error GameMode: "..GameMode.."Avatar: ", Avatar)
			return
		end
		if self.GoToRegionSubIds[Avatar.CurrentRegionId] then
			self:SuccessExecuteStartNode()
			return
		end
		for SubRegionId, _ in pairs(self.GoToRegionSubIds) do
			DebugPrint("XXN_ Add RegionSkipCallBack QuestStartNode ", SubRegionId, Avatar.CurrentRegionId)
			Avatar:AddRegionSkipCallback(SubRegionId, self, self.GoToRegionCallBack)
		end
		self.IsSetGotoRegionCallback = true
	else
		self:SuccessExecuteStartNode()
	end
end

function QuestStartNode:LoadFinishCallback(InfoTable)
	if not InfoTable or not InfoTable.Actor then return end
	DebugPrint("zwkzwk 激活完成回调 ", InfoTable.Actor:GetName())
	-- 给NPC或机关挂交互组件
	local ComponentClass = LoadClass('/Game/BluePrints/Story/Interactive/InteractiveComponent/BP_HuanJingRuKouInteract.BP_HuanJingRuKouInteract')
	local Component = InfoTable.Actor:AddComponentByClass(ComponentClass, false, FTransform(), false)
	-- 传送组件现在继续用单独填的任务子区域这个字段
	Component:SetComponentInfo(self.QuestChainId, self.SubRegionId or 0)
	local FailryQuestNode = self
	FailryQuestNode.CreateId = self.FairyLandStaticCreatorId
	MissionIndicatorManager:ActiveFailryQuestIndicatorBy(FailryQuestNode)
end

function QuestStartNode:Clear()
	if not self.IsSetGotoRegionCallback then
		return
	end
	self:RemoveAllSubRegionCallBack()
	self.IsSetGotoRegionCallback = false
	if self.FairyLandStaticCreatorId and self.FairyLandStaticCreatorId ~= 0 then
		GWorld.StoryMgr:UnbindStaticCreatorActorEventByType(self.FairyLandStaticCreatorId, EActorEventType.OnCreated)
	end
end

function QuestStartNode:TriggerShowOrCloseMissionIndicator(IsShow)
	if self.GoToRegionSubIds and CommonUtils.TableLength(self.GoToRegionSubIds) > 0 then
		if IsShow then
			MissionIndicatorManager:ActiveMissionIndicatorByNode(self)
		else
			MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
		end
	end
end

function QuestStartNode:SuccessExecuteStartNode()
	-- 任务开始
	self.QuestStartCallback("QuestStart")
	local Avatar = GWorld:GetAvatar()
	if Avatar then
		Avatar:StartQuest(self.QuestChainId, self.QuestId)
	end
	EventManager:FireEvent(EventID.QuestStart)
	if self.StoryGuidePointName ~= "" then
		self:TriggerShowOrCloseMissionIndicator(false)
	end
end

function QuestStartNode:UpdateStartNodeTaskBarInfo()
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end
	-- PrintTable({QuestChainId=self.QuestChainId,QuestId=self.QuestId,self=self},2)
	-- QuestChainId为0是全部stl，不为0则是任务stl
	if self.QuestChainId > 0 and self.QuestId > 0 and Avatar and not TaskUtils:CheckSpecialTaskDoing() then
		local TaskInfo = {TaskChainId = self.QuestChainId, TaskId = self.QuestId, TaskName = GText(DataMgr.QuestChain[self.QuestChainId].QuestChainName),
						  TaskDescription = GText(self.QuestDescription), IsChainFirstTask = self.bIsStartQuest, IsChapterStart = self.bIsStartChapter, QuestUIId = self.QuestUIId}
		Avatar:DoRefreshTaskItemUIInfo("Add", TaskInfo)
	end
	if self.bIsDynamicEvent then
		local TaskInfo = {TaskDescription = self.QuestDescription, IsChainFirstTask = self.bIsStartQuest,IsChapterStart = self.bIsStartChapter,
						  IsDynamicEvent=self.bIsDynamicEvent}
		Avatar:DoRefreshTaskItemUIInfo("Add", TaskInfo)
	end
	if TaskUtils:CheckSpecialTaskDoing() and self.QuestDescription ~= "" and self.QuestDeatil ~= "" then
		local SpecialQuestChainId = TaskUtils:GetSpcialPreQuestChainIdByConfig(self.Context.FilePath)
		if SpecialQuestChainId ~= 0 and DataMgr.QuestChain[SpecialQuestChainId] and DataMgr.QuestChain[SpecialQuestChainId].QuestChainName then
			local SpecialQuestChainName = DataMgr.QuestChain[SpecialQuestChainId].QuestChainName
			TaskUtils:UpdateSpecialTaskInfo("AddSpecialTaskInfo", {TaskName = GText(SpecialQuestChainName), TaskDescribe = GText(self.QuestDescription)})
		end
	end
end

return QuestStartNode
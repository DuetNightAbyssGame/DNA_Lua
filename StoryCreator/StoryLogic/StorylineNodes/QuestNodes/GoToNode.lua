local QuestNodeUtils = require 'StoryCreator.StoryLogic.QuestNodeUtils'
local EActorEventType = require 'StoryCreator.StoryLogic.StorylineUtils'.EActorEventType
local GoToNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

function GoToNode:Init()
	self.GuideUIEnable = false
	self.StaticCreatorId = nil
	self.GuideType = nil
	self.GuidePointName = nil
end

function GoToNode:Execute(Callback)
	self:CheckResurgencePoint()

	DebugPrint("LXZ AOITriggerBox, GoToNode:Execute", self.StaticCreatorId)
	GWorld.StoryMgr:BindStaticCreatorActorEvent(self.StaticCreatorId, EActorEventType.OnTriggerAOIBase, self, function(_, Info)
		if (Info.TriggerType ~= "BeginOverlap") then
			return
		end

		Callback()
	end)

	QuestNodeUtils.STLTriggerActiveStaticCreator(self, { self.StaticCreatorId })

	if self.GuideUIEnable then
		MissionIndicatorManager:ActiveMissionIndicatorByNode(self)
	end
end

function GoToNode:Clear()
	GWorld.StoryMgr:UnbindStaticCreatorActorEvent(self.StaticCreatorId)

	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if IsValid(GameMode) then
		GameMode:TriggerInactiveStaticCreator({ self.StaticCreatorId }, false, EDestroyReason.StoryLine)
	end

	if self.GuideUIEnable then
		MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
	end
end

function GoToNode:CheckResurgencePoint()
	local GuidePointLocData = require("BluePrints.UI.TaskPanel/QuestGuidePointLocData")
	if self.Context.QuestData.bUseQuestCoordinate and self.Context.QuestData.ResurgencePoint == "" then
		local Avatar = GWorld:GetAvatar()
		if not Avatar then
			return
		end
		local QuestChain = Avatar.QuestChains[self.Context.QuestChainId]
		local QuestCoordinate = QuestChain.QuestCoordinate
		if not QuestCoordinate then
			return
		end
		if not self.GuidePointName then
			return
		end
		local PointInfo = GuidePointLocData[self.GuidePointName]
		if not PointInfo then
			return
		end
		if not PointInfo.SubRegionId or PointInfo.SubRegionId <= 0 then
			return
		end
		if PointInfo.SubRegionId ~= QuestCoordinate.SubRegionId then
			local Message = "GoToNode所在任务链的StoryNode需要配置ResurgencePoint" ..
					"\nFileName:" .. self.Context.FileName ..
					"\nQuestChainId:" .. self.Context.QuestChainId ..
					"\nQuestId:" .. self.Context.QuestId ..
					"\nStoryNodeKey:" .. self.Context.Data.key
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "GoToNode所在任务链的StoryNode需要配置ResurgencePoint", Message)
			return
		end
	end
end

return GoToNode

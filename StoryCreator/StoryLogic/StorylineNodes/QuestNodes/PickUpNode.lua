




local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
local GuidePointLocData = require ("BluePrints.UI.TaskPanel/QuestGuidePointLocData")

local PickUpNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')
local QuestNodeUtils = require 'StoryCreator.StoryLogic.QuestNodeUtils'


function PickUpNode:Init()
	self.bActiveEnable = true
	self.StaticCreatorIdList = {}
	self.UnitId = 0
	self.UnitCount = 0
	self.QuestPickupId = -1
	self.bGuideUIEnable = false
	self.GuideType = ''
	self.GuidePointName = ''
	self.StaticCreatorArray = TArray(0)
	self.GuideCreator = {}
	self.NearestCreator = nil
	self.NearestDistance = 0
	self.NearestTimer = nil
	self.Player = nil
	self.GameState = nil
	self.PickupNodeProtectDistance = DataMgr.GlobalConstant['PickupNodeProtectDistance'].ConstantValue or 0
	self.MaxPickUpCount = 0
end

-- function PickUpNode:Start(Context)
-- 	self.Context = Context	
-- 	self:PickUp(self.Context)
-- end

function PickUpNode:Execute(Callback)
    DebugPrint("------------ PickUpNode ------------------")

	if self.QuestPickupId ~= -1 then
		if not DataMgr.QuestPickup[self.QuestPickupId] then
			local Message = "PickUpNode填了QuestPickupId，QuestPickup表中没有对应的数据"..
			"\nFileName:"..self.Context.FileName..
			"\nQuestChainId:"..self.Context.QuestChainId..
			"\nQuestId:"..self.Context.QuestId..
			"\nStoryNodeKey:"..self.Context.Data.key
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "PickUpNode填了QuestPickupId，QuestPickup表中没有对应的数据", Message)
			return
		end
		if self.Context.QuestChainId ~= DataMgr.QuestPickup[self.QuestPickupId].QuestChainId then
			local Message = "PickUpNode填了QuestPickupId，但QuestPickup表中的QuestChainId与该任务的QuestChainId不一致"..
			"\nFileName:"..self.Context.FileName..
			"\nQuestChainId:"..self.Context.QuestChainId..
			"\nQuestId:"..self.Context.QuestId..
			"\nStoryNodeKey:"..self.Context.Data.key
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "PickUpNode填了QuestPickupId，但QuestPickup表中的QuestChainId与该任务的QuestChainId不一致", Message)
			return
		end
		self:ExecuteQuestPickup(Callback)
		return
	end

    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)

	local PlayerAvatar = GWorld:GetAvatar()
	local DropInfo = DataMgr.Drop[self.UnitId]
	local Count = 0
	if PlayerAvatar then
		if DropInfo.UseEffectType == 'GetWeapon' then
			local WeaponId = DropInfo.UseParam
			for Id, Weapon in pairs(PlayerAvatar.Weapons) do
	            if Weapon.WeaponId == WeaponId then
	            	Count = Count + 1
	            end
	        end
		elseif DropInfo.UseEffectType == 'GetMod' then
			local ModId = DropInfo.UseParam
			for Id,Mod in pairs(PlayerAvatar.Mods) do
	            if Mod.ModId == ModId then
	            	Count = Count + Mod.Count
	            end
	        end
		elseif DropInfo.UseEffectType == 'GetResource' then
			local ResourceId = DropInfo.UseParam
			local Resource = PlayerAvatar.Resources[ResourceId]
			if Resource then
				Count = Count + Resource.Count
			end
		end
	end

	if self.IsUseCount then
		self.MaxPickUpCount = self.UnitCount
		local Avatar = GWorld:GetAvatar()
		if Avatar and self.bIsDynamicEvent == false then
			local ChainId = self.QuestChainId
			if Avatar.InSpecialQuest then
				ChainId = ClientEventUtils:GetCurrentEvent().PreQuestChainId
			end
			local DoingQuestId = Avatar.QuestChains[ChainId].DoingQuestId
			Avatar:DoRefreshTaskItemUIInfo("Modify", nil, {0, self.MaxPickUpCount, ChainId, DoingQuestId, self})
		end
	end

	if Count >= self.UnitCount then
		Callback(nil)
		return
	end

	local MinCount = 1;
	if DropInfo.UseEffectType == 'GetResource' then
		if DropInfo.UseParam2 then
			MinCount = DropInfo.UseParam2[1]
		end
	end

    if self.bActiveEnable then
	    for _, StaticCreatorId in pairs(self.StaticCreatorIdList) do
	    	if Count < self.UnitCount then
	    		self.StaticCreatorArray:Add(StaticCreatorId)
	    	end
	    	Count = Count + MinCount
	    end
	    QuestNodeUtils.STLTriggerActiveStaticCreator(self, self.StaticCreatorArray)
	end

	self.StartCount = self.UnitCount
	local function SuccessCallback()
    	self.StartCount = self.StartCount - MinCount

		if self.IsUseCount then
			local Avatar = GWorld:GetAvatar()
			if Avatar and self.bIsDynamicEvent == false then
				local ChainId = self.QuestChainId
				if Avatar.InSpecialQuest then
					ChainId = ClientEventUtils:GetCurrentEvent().PreQuestChainId
				end
				local DoingQuestId = Avatar.QuestChains[ChainId].DoingQuestId
				Avatar:DoRefreshTaskItemUIInfo("Modify", nil, {self.MaxPickUpCount - self.StartCount, self.MaxPickUpCount, ChainId, DoingQuestId, self})
			end
		end

		local UIManager = GWorld.GameInstance:GetGameUIManager()
		local IndicatorName = ""
		if self.bIsDynamicEvent then
			IndicatorName = "DynamicEventIndicator_"..self.Key
		else
			IndicatorName = "TaskIndicator_"..self.Key
		end

		local UIObj = UIManager:GetUIObj(IndicatorName)
    	if UIObj and UIObj.GuideInfoCache then
			local TargetKey = UIObj.GuideInfoCache.PointOrStaticCreatorName
            if TargetKey and GuidePointLocData[TargetKey] and GuidePointLocData[TargetKey].SubRegionId > 0 and self.StartCount <= 0 then
				MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
			elseif TargetKey and GuidePointLocData[TargetKey] and GuidePointLocData[TargetKey].SubRegionId == 0 then
				MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
			end
    	end

    	if self.StartCount <= 0 then
	    	GameMode:RemovePickUpSuccessCallback(self.UnitId, self.NodeId )
			Callback(nil)
    	end
    end

    GameMode:AddPickUpSuccessCallback(self.UnitId, self.NodeId, SuccessCallback)

	self:AddGuide()
end

function PickUpNode:OnCancelTrack()
    
end

function PickUpNode:OnChooseTrack()
	if self.IsUseCount then
		local Avatar = GWorld:GetAvatar()
		if Avatar and self.bIsDynamicEvent == false then
			local ChainId = self.QuestChainId
			if Avatar.InSpecialQuest then
				ChainId = ClientEventUtils:GetCurrentEvent().PreQuestChainId
			end
			local DoingQuestId = Avatar.QuestChains[ChainId].DoingQuestId
			Avatar:DoRefreshTaskItemUIInfo("Modify", nil, {self.MaxPickUpCount - self.UnitCount, self.MaxPickUpCount, ChainId, DoingQuestId, self})
		end
	end
end

function PickUpNode:TickGuideCreator()
	local MinDistance = -1
	local NearestCreator = nil
	for _,Creator in pairs(self.GuideCreator) do
		if Creator then
			local ChildDrop = Creator:GetChildEids():ToTable()
			local CreatorActive = #ChildDrop ~= 0
			if CreatorActive then
				local Drop = self.GameState.CombatItemMap:FindRef(ChildDrop[1])
				if not Drop then
					CreatorActive = false
				end
			end
			if CreatorActive then
				local Distance = UKismetMathLibrary.Vector_Distance(self.Player.CurrentLocation,Creator:k2_GetActorLocation())
				if Distance < MinDistance or MinDistance < 0 then
					MinDistance = Distance 
					NearestCreator = Creator
				end
				if Creator == self.NearestCreator then
					self.NearestDistance = Distance
				end
			else
				if Creator == self.NearestCreator then
					self.NearestCreator = nil
				end
			end
		end
	end
	if (self.NearestCreator ~= NearestCreator and self.NearestDistance - self.PickupNodeProtectDistance > MinDistance) 
	or (self.NearestCreator == nil and NearestCreator ~=nil) then
		MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
		self.NearestCreator = NearestCreator
		self.NearestDistance = MinDistance
		self.GuideType = 'Drop'
		self.GuidePointName = NearestCreator.DisplayName
		MissionIndicatorManager:ActiveMissionIndicatorByNode(self)
	end
end

-- function PickUpNode:FinishAction()
-- 	if self.bGuideUIEnable then
-- 		local UIManager = GWorld.GameInstance:GetGameUIManager()
-- 		local TaskIndicatorUI = UIManager:LoadUI(UIConst.TASKINDICATORUI, "TaskIndicator", UIConst.ZORDER_FOR_INDICATORS)
-- 		if TaskIndicatorUI then
-- 			TaskIndicatorUI:Close(tostring(self.QuestData.QuestId).."_PickUpNode_"..self.Key)
-- 		end
-- 	end
-- 	self:Finish()
-- end

function PickUpNode:ExecuteQuestPickup(Callback)
	local Avatar = GWorld:GetAvatar()
	if Avatar then
		local CreatePickup = function()
			local TargetQuestPick = Avatar.QuestChains[self.Context.QuestChainId].QuestPicks:GetQuestPickAttr(self.QuestPickupId)
			if TargetQuestPick:IsComplete() then
				Callback()
				return
			end
			local TargetDropCount = TargetQuestPick.TargetPickCount - TargetQuestPick :GetCurrentPickCount()
			if TargetDropCount <= 0 then
				Callback()
				return
			end

			GWorld.StoryMgr:CreateQuestPickupId2Callback(self.QuestPickupId, Callback)

			local MinCount = 1
			if self.bActiveEnable then
				for _, StaticCreatorId in pairs(self.StaticCreatorIdList) do
					if TargetDropCount > 0 then
						self.StaticCreatorArray:Add(StaticCreatorId)
					end
					TargetDropCount = TargetDropCount - MinCount
				end
				QuestNodeUtils.STLTriggerActiveStaticCreator(self, self.StaticCreatorArray)
			end
			self:AddGuide()
		end
		local TargetQuestPick = Avatar.QuestChains[self.Context.QuestChainId].QuestPicks:GetQuestPickAttr(self.QuestPickupId)
		if not TargetQuestPick then
			Avatar:RegisterQuestPickId(self.QuestPickupId, CreatePickup)
		else
			CreatePickup()
		end
	end
end

function PickUpNode:AddGuide()
	if self.bGuideUIEnable then
		local GuideType = self.GuideType
		local GuidePointName = self.GuidePointName
		if self.GuideType == '' or self.GuidePointName == '' and #self.StaticCreatorIdList > 0 then
			GuideType = 'Drop'
			self.GuideType = GuideType
			self.GameState = UGameplayStatics.GetGameState(GWorld.GameInstance)
			if #self.StaticCreatorIdList == 1 then
				local StaticCreator = self.GameState:GetStaticCreatorInfo(self.StaticCreatorIdList[1])
				if StaticCreator then
					GuidePointName = StaticCreator.DisplayName
					self.GuidePointName = GuidePointName
				end
			else
				for _, StaticCreatorId in pairs(self.StaticCreatorIdList) do
					local StaticCreator = self.GameState:GetStaticCreatorInfo(StaticCreatorId)
					if StaticCreator then
						table.insert(self.GuideCreator,StaticCreator)
					end
				end
				self.Player = UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
				self:TickGuideCreator()
				self.NearestTimer = GWorld.GameInstance:AddTimer(0.2,function()
					self:TickGuideCreator()
				end,true)
				return
			end
		end
    	MissionIndicatorManager:ActiveMissionIndicatorByNode(self)
	end
end

function PickUpNode:Clear()
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if self.bActiveEnable then
	    GameMode:TriggerInactiveStaticCreator(self.StaticCreatorArray)
	end
	GameMode:RemovePickUpSuccessCallback(self.UnitId, self.NodeId )
	if self.NearestTimer then
		GWorld.GameInstance:RemoveTimer(self.NearestTimer)
	end
	--清理指引
	if self.bGuideUIEnable then
		MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
	end
end

return PickUpNode
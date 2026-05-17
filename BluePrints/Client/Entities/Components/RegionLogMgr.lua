local Component = {}

-------------------------------------- 缓存数据打印 -------------------------------------------------

function Component:PrintRegionCache()
	self:PrintCurrentQuestDataCache()
	self:PrintCurrentRarelyDataCache()
	self:PrintCurrentCommonDataCache()
	self:PrintCurrentMistakeDataCache()
	self:PrintCurrentStaticCreatorCache()
	self:PrintCurrentManualItemCache()
	self:PrintCurrentSpawnActorCache()
	self:PrintCurrentWorldRegionActorCache()
	self:PrintCurrentSerializeCreator()
	self:PrintCurrentExplore()
end

function Component:PrintCurrentQuestDataCache()
	if not self.QuestDatas then
		DebugPrint("ZJT_ 当前不存在待提交服务端任务缓存数据 ")
		return
	end
	DebugPrint("ZJT_ -------------------------- Start PrintCurrentQuestDataCache --------------------------")
	for QuestId, WorldRegionEids in pairs(self.QuestDatas) do
		for WorldRegionEid, RegionBaseData in pairs(WorldRegionEids) do
			DebugPrint("ZJT_ PrintCurrentQuestDataCache Incomplete Quest", WorldRegionEid, QuestId, self:CheckQuestIdIsDoing(RegionBaseData.QuestId), RegionBaseData.CreatorId)
		end
	end
	for QuestId, WorldRegionEids in pairs(self.QuestUpdateDatas) do
		for WorldRegionEid, RegionBaseData in pairs(WorldRegionEids) do
			DebugPrint("ZJT_ PrintCurrentQuestUpdateDatasCache Incomplete Quest", WorldRegionEid, QuestId, self:CheckQuestIdIsDoing(RegionBaseData.QuestId), RegionBaseData.CreatorId)
		end
	end
	DebugPrint("ZJT_ -------------------------- End PrintCurrentQuestDataCache --------------------------")
end

function Component:PrintCurrentRarelyDataCache()
	if not self.RarelyDatas then
		DebugPrint("ZJT_ 当前不存在待提交服务端探索缓存数据 ")
		return
	end
	DebugPrint("ZJT_ -------------------------- ***** Start ***** PrintCurrentRarelyDataCache --------------------------")
	for RarelyId, WorldRegionEids in pairs(self.RarelyDatas) do
		for WorldRegionEid, RegionBaseData in pairs(WorldRegionEids) do
			DebugPrint("ZJT_ PrintCurrentRarelyDataCache ", WorldRegionEid, RarelyId, self:UpdateRarelyDataToServer(RegionBaseData), RegionBaseData.CreatorId)
		end
	end
	DebugPrint("ZJT_ -------------------------- ***** End ***** PrintCurrentRarelyDataCache --------------------------")
end

function Component:PrintCurrentCommonDataCache()
	if not self.CommonDatas then
		DebugPrint("ZJT_ 当前不存在待提交服务端常规缓存数据 ")
		return
	end
	DebugPrint("ZJT_ -------------------- Start PrintCurrentCommonDataCache -------------------- ")
	for RegionId, RegionLevelDatas in pairs(self.CommonDatas) do
		for LevelName, WorldRegionEids in pairs(RegionLevelDatas) do
			for WorldRegionEid, RegionBaseData in pairs(WorldRegionEids) do
				PrintTable({RegionBaseData = RegionBaseData}, 10)
			end
		end
	end
	DebugPrint("ZJT_ -------------------- End PrintCurrentCommonDataCache -------------------- ")
end

function Component:PrintCurrentMistakeDataCache()
	if not self.MistakeDatas then
		DebugPrint("ZJT_ 当前不存在非存储缓存数据 ")
		return
	end
	DebugPrint("ZJT_ -------------------- Start PrintCurrentMistakeDataCache -------------------- ")
	for RegionId, RegionLevelDatas in pairs(self.MistakeDatas) do
		for LevelName, WorldRegionEids in pairs(RegionLevelDatas) do
			for WorldRegionEid, RegionBaseData in pairs(WorldRegionEids) do
				PrintTable({RegionBaseData = RegionBaseData}, 10)
			end
		end
	end
	DebugPrint("ZJT_ -------------------- End PrintCurrentMistakeDataCache -------------------- ")
end

function Component:PrintCurrentStaticCreatorCache()
	if not self.StaticIdControlCache then
		DebugPrint("ZJT_ 当前不存在静态刷新点缓存数据 ")
		return
	end
	DebugPrint("ZJT_ -------------------- Start PrintCurrentStaticCreatorCache -------------------- ")
	for CreatorId, WorldRegionEids in pairs(self.StaticIdControlCache) do
		for WorldRegionEid, SubRegionId in pairs(WorldRegionEids) do
			DebugPrint("ZJT_ PrintCurrentStaticCreatorCache ", CreatorId, WorldRegionEid, SubRegionId)
		end
	end
	DebugPrint("ZJT_ -------------------- End PrintCurrentStaticCreatorCache -------------------- ")
end

function Component:PrintCurrentManualItemCache()
	for ManualItemId, WorldRegionEid in pairs(self.ManualDatas) do
		DebugPrint("ZJT_ PrintCurrentManualItemCache ", ManualItemId, WorldRegionEid)
	end
end
function Component:PrintCurrentWorldRegionActorCache()
	for RegionId, LevelActors in pairs(self.WorldRegionEid2Actor) do
		for WorldRegionEid, TargetActor in pairs(LevelActors) do
			if IsValid(TargetActor) then
				DebugPrint("ZJT_ PrintCurrentWorldRegionActorCache ", RegionId, WorldRegionEid, TargetActor.RegionDataType, TargetActor.QuestId, TargetActor.CreatorId, TargetActor.Eid,
				TargetActor:GetName(), TargetActor.RarelyId)
			else
				DebugPrint("ZJT_ PrintCurrentWorldRegionActorCache TargetActor Not Exist", RegionId, WorldRegionEid)
			end
		end
	end
end

function Component:PrintCurrentSerializeCreator()
	for SubRegionId, StaticCreatorId in pairs(self.SerializeStaticCretor) do
		local TempEid = self.SerializeStaticCretor[SubRegionId][StaticCreatorId]
		DebugPrint("ZJT_ PrintCurrentSerializeCreator ", SubRegionId, StaticCreatorId, TempEid)
	end
end

function Component:PrintInfoByWorldRegionEid(WorldRegionEid)
end

function Component:PrintCurrentExplore()
	for RarelyId, Explore in pairs(self.Explores) do
		self.logger.debug("ZJT_  PrintCurrentExplore RarelyId, Blue ", RarelyId, Explore.RarelyId, Explore.ExploreState)
		if Explore:IsDoing() then
			self.logger.debug("ZJT_ PrintExplore 正在执行 ", RarelyId,Explore.RarelyId, Explore.ExploreState)
		end
		if Explore:IsComplete() then
			self.logger.debug("ZJT_ PrintExplore 执行完成 ", RarelyId, Explore.RarelyId, Explore.ExploreState)
		end
	end
end

-------------------------------------- 缓存数据打印 -------------------------------------------------

return Component
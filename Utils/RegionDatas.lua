

local RegionDatas = {}

-- local Eid2UnitRegionData = {}
-- RegionDatas.Eid2UnitRegionData = Eid2UnitRegionData

-- -- 从RegionDatas中获取数据
-- local _GetUnitRegionData = function(TypeRegionDatas, SubRegionId, LevelName, WorldRegionEid)
--     SubRegionId = tostring(SubRegionId)
--     if not TypeRegionDatas then
--         return nil
--     end
--     local RegionData = TypeRegionDatas[SubRegionId]
--     if not RegionData then
--         return nil
--     end
--     local LevelData = RegionData[LevelName]
--     if not LevelData then
--         return nil
--     end

--     return LevelData[WorldRegionEid]
-- end

-- -- 添加数据到RegionDatas中
-- local _SetUnitRegionData = function(TypeRegionDatas, SubRegionId, LevelName, WorldRegionEid, UnitRegionData)
--     if not SubRegionId or not LevelName or not WorldRegionEid then
--         PrintTable(UnitRegionData, 10)
--     end
--     assert(SubRegionId, "SubRegionId为空") 
--     assert(LevelName, "LevelName为空") 
--     assert(WorldRegionEid, "WorldRegionEid为空")
--     TypeRegionDatas[SubRegionId] = TypeRegionDatas[SubRegionId] or {}
--     TypeRegionDatas[SubRegionId][LevelName] = TypeRegionDatas[SubRegionId][LevelName] or {}
--     TypeRegionDatas[SubRegionId][LevelName][WorldRegionEid] = UnitRegionData

--     RegionDatas.Eid2UnitRegionData[WorldRegionEid] = UnitRegionData
-- end

-- -- 根据WorldRegionEid获取UnitRegionData
-- RegionDatas.GetUnitRegionDataByWorldRegionEid = function(WorldRegionEid)
--     local UnitRegionData = RegionDatas.Eid2UnitRegionData[WorldRegionEid]
--     if not UnitRegionData then
--         GWorld.logger.error("Eid2UnitRegionData中找不到WorldRegionEid:【" .. tostring(WorldRegionEid) .. "】的数据")
--     end
--     return UnitRegionData
-- end

-- -- 从区域中获取Actor的UnitRegionData
-- RegionDatas.GetUnitRegionDataByActor = function(TargetActor)
--     local RegionDataType = TargetActor.RegionDataType
--     local Avatar = GWorld:GetAvatar()
--     local TypeRegionDatas = Avatar:GetRegionDatasByIdType(RegionDataType)
--     local UnitRegionData = _GetUnitRegionData(TypeRegionDatas, TargetActor.SubRegionId, TargetActor.LevelName, TargetActor.WorldRegionEid)
--     if not UnitRegionData then
--         GWorld.logger.error("在RegionDatas[Type:".. tostring(RegionDataType) .. "]中找不到" .. tostring(UE4.UKismetSystemLibrary.GetDisplayName(TargetActor)) .. "的数据")
--     end
--     return UnitRegionData
-- end

-- -- 添加数据到RegionDatas中
-- RegionDatas.AddUnitRegionData = function(UnitRegionData)
--     -- UnitRegionData = CommonUtils.DeepCopy(UnitRegionData)
--     local RegionDataType = UnitRegionData.RegionDataType
--     local Avatar = GWorld:GetAvatar()
--     local TypeRegionDatas = Avatar:GetRegionDatasByIdType(RegionDataType)
--     if not TypeRegionDatas then
--         GWorld.logger.error("在RegionDatas[Type:".. tostring(RegionDataType) .. "]中找不到WorldRegionEid:【" .. tostring(UnitRegionData.WorldRegionEid) .. "】的数据")
--         return
--     end
--     local SubRegionId = UnitRegionData.SubRegionId
--     local LevelName = UnitRegionData.LevelName
--     local WorldRegionEid = UnitRegionData.WorldRegionEid
--     _SetUnitRegionData(TypeRegionDatas, SubRegionId, LevelName, WorldRegionEid, UnitRegionData)
-- end

-- -- 移除RegionDatas中的数据
-- RegionDatas.RemoveUnitRegionData = function(WorldRegionEid)
--     local UnitRegionData = RegionDatas.GetUnitRegionDataByWorldRegionEid(WorldRegionEid)
--     if not UnitRegionData then
--         return
--     end

--     local RegionDataType = UnitRegionData.RegionDataType
--     local Avatar = GWorld:GetAvatar()
--     local TypeRegionDatas = Avatar:GetRegionDatasByIdType(RegionDataType)
--     if not TypeRegionDatas then
--         GWorld.logger.error("在RegionDatas[Type:".. tostring(RegionDataType) .. "]中找不到WorldRegionEid:【" .. tostring(WorldRegionEid) .. "】的数据")
--         return
--     end
--     local SubRegionId = UnitRegionData.SubRegionId
--     local LevelName = UnitRegionData.LevelName
--     local WorldRegionEid = UnitRegionData.WorldRegionEid
--     _SetUnitRegionData(TypeRegionDatas, SubRegionId, LevelName, WorldRegionEid, nil)
-- end

-- -- -- 添加Actor数据到RegionDatas中
-- -- RegionDatas.AddUnitRegionDataByActor = function(TargetActor)
-- --     local GameMode = UGameplayStatics.GetGameMode(TargetActor)
-- --     local UnitRegionData = GameMode:ConstructUnitRegionDataByUnit(TargetActor)
-- --     return RegionDatas.AddUnitRegionData(UnitRegionData)
-- -- end

-- -- 更新UnitRegionData在RegionDatas中的数据
-- RegionDatas.UpdateUnitRegionData = function(UnitRegionData)
--     local WorldRegionEid = UnitRegionData.WorldRegionEid

--     RegionDatas.RemoveUnitRegionData(WorldRegionEid)
--     RegionDatas.AddUnitRegionData(UnitRegionData)

--     return UnitRegionData
-- end

-- -- 更新Actor在RegionDatas中的数据
-- RegionDatas.UpdateUnitRegionDataByActor = function(TargetActor)
--     local GameMode = UGameplayStatics.GetGameMode(TargetActor)
--     local NewUnitRegionData = GameMode:ConstructUnitRegionDataByUnit(TargetActor)
--     return RegionDatas.UpdateUnitRegionData(NewUnitRegionData)
-- end

-- RegionDatas.UpdateQuestRegionDatas = function(QuestChainId, RegionUpdataData)
--     local Avatar = GWorld:GetAvatar()
--     GWorld.logger.debug("任务链:【"..tostring(QuestChainId).."】更新数据量:"..tostring(#RegionUpdataData))
--     local QuestRegionDatas = Avatar:GetRegionDatasByIdType(ERegionDataType.RDT_QuestData)
--     for _, RegionData in pairs(QuestRegionDatas) do
--         for _, LevelData in pairs(RegionData) do
--             for _, WorldRegionEid in pairs(CommonUtils.Keys(LevelData)) do
--                 local UnitRegionData = LevelData[WorldRegionEid]
--                 if UnitRegionData.QuestChainId == QuestChainId then
--                     RegionDatas.RemoveUnitRegionData(WorldRegionEid)
--                     GWorld.logger.debug("任务链:【"..tostring(QuestChainId).."】删除了:"..tostring(UnitRegionData.WorldRegionEid))
--                 end
--             end
--         end
--     end

--     for _, UnitRegionData in ipairs(RegionUpdataData) do
--         RegionDatas.AddUnitRegionData(UnitRegionData)
--         GWorld.logger.debug("任务链:【"..tostring(QuestChainId).."】添加了:"..tostring(UnitRegionData.WorldRegionEid))
--     end
-- end

return RegionDatas


local RegionUtils = {}

-- Utils.MontageProxyInstance = nil

-- ---@class RegionUtils
-- ----- 初始化Info中区域独有数据初始化
-- RegionUtils.SetActorRegionInfo = function (TargetActor, Info)
--     local Result, Avatar, GameMode = RegionUtils.IsCanTriggerRegionDataHandle()
--     if not Result then 
--         return 
--     end
--     if not IsValid(TargetActor) or not Info then 
--         return 
--     end
--     TargetActor.LevelName = Info.LevelName or GameMode:GetActorLevelName(TargetActor)
--     TargetActor.SubRegionId = Info.SubRegionId or GameMode:GetRegionIdByLocation(TargetActor:k2_GetActorLocation())
--     TargetActor.WorldRegionEid = Info.WorldRegionEid or Avatar:GetWorldRegionEid(TargetActor)
--     TargetActor.RegionDataType = Info.RegionDataType
--     TargetActor.QuestChainId = Info.QuestChainId
--     if IsValid(Info.Creator) then
--         TargetActor.RarelyId = Info.RarelyId or Info.Creator.RarelyId
--     else
--         TargetActor.RarelyId = Info.RarelyId or 0
--     end
-- end

-- -- 初始化Info中区域数据有但不是独有数据初始化,不包括UnitId，UnitType，Eid(这几个要放preinit？)
-- RegionUtils.SetActorRegionCommonInfo = function (TargetActor, Info)
--     TargetActor.BornPos = Info.BornPos or Info.Loc
--     TargetActor.BornRot = Info.BornRot or Info.Rotation
--     if IsValid(Info.Creator) then
--         local GameMode = UE4.UGameplayStatics.GetGameMode(TargetActor)
--         local Creator = Info.Creator
--         TargetActor.CreatorId = Info.CreatorId or Creator.StaticCreatorId
--         TargetActor.RandomCreatorId = Info.RandomCreatorId or 0
--         TargetActor.RandomRuleId = Info.RandomRuleId or 0
--         TargetActor.RandomTableId = Info.RandomTableId or 0
--         TargetActor.RandomIdxInRule = Info.RandomIdxInRule or GameMode.RandomActorManager:GetCreatorRegionDataIdxInRule(Info.RandomRuleId, Info.RandomCreatorId)
--     else
--         TargetActor.CreatorId = Info.CreatorId or 0
--         TargetActor.RandomCreatorId = Info.RandomCreatorId or 0
--         TargetActor.RandomRuleId = Info.RandomRuleId or 0
--         TargetActor.RandomTableId = Info.RandomTableId or 0
--         TargetActor.RandomIdxInRule = Info.RandomIdxInRule or 0
--     end
-- end



-- -- RegionUtils.SetWorldRegionId = function(TargetActor, Info)
-- --     TargetActor.SubRegionId = Info.SubRegionId
-- -- end

-- -- RegionUtils.SetWorldRegionEid = function(TargetActor, Info)
-- --     TargetActor.WorldRegionEid = Info.WorldRegionEid

-- -- end

-- -- RegionUtils.SetWorldLevelName = function(TargetActor, Info)
-- --     local GameMode = UGameplayStatics.GetGameMode(TargetActor)
-- --     if not URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(TargetActor) then
-- --         TargetActor.LevelName = Info.LevelName or GameMode:GetActorLevelName(TargetActor)
-- -- 		return
-- -- 	end
-- --     TargetActor.LevelName = Info.LevelName or GameMode:GetWCSubSystem():GetLocationLevelName(TargetActor:K2_GetActorLocation())
-- -- end

-- RegionUtils.AddRegionDataByActor = function(TargetActor, Info, AddRegionDataType, ActorPath)
--     local Creator = Info.Creator
--     local Result, Avatar, GameMode = RegionUtils.IsCanTriggerRegionDataHandle()
--     if not Result then return end
--     local WorldLoader = GameMode:GetLevelLoader()
--     if not WorldLoader or not WorldLoader.IsWorldLoader then return end
--     if Creator then
--         TargetActor.RegionDataType = Info.RegionDataType or Creator.RegionDataType
--         TargetActor.QuestChainId = Info.QuestChainId or Creator.QuestChainId
--         TargetActor.RarelyId = Info.RarelyId or Creator.RarelyId
--     else
--         TargetActor.RegionDataType = Info.RegionDataType or TargetActor.RegionDataType
--         TargetActor.QuestChainId = Info.QuestChainId or TargetActor.QuestChainId
--         TargetActor.RarelyId = Info.RarelyId or TargetActor.RarelyId
--     end

--     if AddRegionDataType == CommonConst.AddRegionDataType.Random then
--         local LevelName, LevelGameMode = GameMode:GetLevelGamemModeAndLevelName(TargetActor.SubRegionId )
--         TargetActor.RegionDataType = GameMode.RandomActorManager:GetCreatorRegionDataType(TargetActor.RandomRuleId, TargetActor.RandomCreatorId)
--         TargetActor.RandomIdxInRule = GameMode.RandomActorManager:GetCreatorRegionDataIdxInRule(TargetActor.RandomRuleId, TargetActor.RandomCreatorId)
--     end
--     GameMode:RegionAddDataByUnit(TargetActor)

--     Avatar:AddActorToActiveCreatorByActorCache(TargetActor.WorldRegionEid)
-- end

-- RegionUtils.DeadRegionActorData = function(TargetActor, DestroyReason)
--     local Result, Avatar, GameMode = RegionUtils.IsCanTriggerRegionDataHandle()
--     if not Result then 
--         return 
--     end
--     local WorldLoader = GameMode:GetLevelLoader()
--     if not WorldLoader or not WorldLoader.IsWorldLoader then 
--         return 
--     end
--     local NewLevelName = GameMode:GetActorLevelName(TargetActor)
--     local NewSubRegionId = WorldLoader:GetRegionIdByLocation(TargetActor:K2_GetActorLocation())
--     Avatar:RegionActorDead(TargetActor, DestroyReason, NewSubRegionId, NewLevelName)
--     RegionUtils.RemoveActorToActiveCreatorByActorCache(TargetActor.WorldRegionEid)
--     TargetActor.WorldRegionEid = nil--掉落物启用了对象池，直接清掉
-- end

-- RegionUtils.UpdateRegionActorData = function(TargetActor, RegionData)
--     local Result, Avatar, GameMode = RegionUtils.IsCanTriggerRegionDataHandle()
--     if not Result then
--         return
--     end
--     local WorldLoader = GameMode:GetLevelLoader()
--     if not WorldLoader or not WorldLoader.IsWorldLoader then
--         return
--     end
--     local NewLevelName = GameMode:GetActorLevelName(TargetActor)
--     local NewSubRegionId = WorldLoader:GetRegionIdByLocation(TargetActor:K2_GetActorLocation())
--     Avatar:RegionActorUpdate(TargetActor, NewSubRegionId, NewLevelName, RegionData)
-- end

-- RegionUtils.RemoveActorToActiveCreatorByActorCache = function(WorldRegionEid)
--     local Result, Avatar, GameMode = RegionUtils.IsCanTriggerRegionDataHandle()
--     if not Result then return end
--     Avatar:RemoveActorToActiveCreatorByActorCache(WorldRegionEid)
-- end

-- RegionUtils.IsExistChildWorldEid = function(WorldRegionEid)
--     local Result, Avatar, GameMode = RegionUtils.IsCanTriggerRegionDataHandle()
--     if not Result then return end
--     return Avatar:IsExistChildWorldEid(WorldRegionEid)
-- end

-- RegionUtils.IsCanTriggerRegionDataHandle = function()
--     local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
--     local Avatar = GWorld:GetAvatar()
--     if not GameMode or not GameMode:IsInRegion() then return false, Avatar, GameMode end
--     if not Avatar or not Avatar:CheckCurrentSubRegion() then return false, Avatar, GameMode end
--     return true, Avatar, GameMode
-- end


-- local RegionDatas = require "Utils.RegionDatas"
-- RegionUtils.RegionDatas = RegionDatas

return RegionUtils

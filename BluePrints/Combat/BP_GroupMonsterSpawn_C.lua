--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_GroupMonsterSpawn_C
require "UnLua"

local BP_GroupMonsterSpawn_C = Class({
    "BluePrints.Combat.BP_MonsterSpawn_C",
})

-- function BP_GroupMonsterSpawn_C:GroupRealCreateUnits(UnitId, UnitNum, PresetTarget, MonsterLevel)
-- 	for i = 1, UnitNum do
-- 		if not self:DetectMonsterSpawnTotalNum() then
-- 			DebugPrint("BP_GroupMonsterSpawn_C 刷怪过程中数量已达上限, 直接返回  MonsterSpawnId:", self.UnitSpawnId)
-- 			return
-- 		end
-- 		local Location = self.Locations[self.LocationIndex % self.Locations:Num() + 1]
-- 		-- Location = UE.UNavigationFunctionLibrary.GetGroundPos(self, Location) -- 贴地
-- 		self.LocationIndex = self.LocationIndex + 1
-- 		if Const.UseNewCreateUnit then
-- 			local Context = FCreateUnitContext()
-- 			Context.UnitType = "Monster"
-- 			Context.UnitId = UnitId
-- 			Context.Loc = Location
-- 			Context.MonsterSpawn = self
-- 			Context.BoolParams:Add("RelationSpawn", false)
-- 			Context.IntParams:Add("Level", MonsterLevel)
-- 			Context:AddObjectParams("PresetTarget", PresetTarget)
-- 			self.GameState.EventMgr:CreateUnitNew(Context)
-- 		else
-- 			self.GameState.EventMgr:CreateUnit({
-- 				UnitType = "Monster",
-- 				UnitId = UnitId,
-- 				Loc = Location,
-- 				MonsterSpawn = self,
-- 				RelationSpawn = false,
-- 				Level = MonsterLevel,
-- 				PresetTarget = PresetTarget
-- 			})
-- 		end
--         self:UpdateMonsterSpawnTotalNum(-1)-- 总数减1
--         self.UnitSpawningNum = self.UnitSpawningNum + 1 --SpawningNum +1
-- 	end
-- end

-- function BP_GroupMonsterSpawn_C:GetAroundDivisionInfos(Loc)
--     local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
--     if not PlayerCharacter then
--         return self.GameMode:GetAroundDivisionInfos(Loc)
--     end
--     local Res = TMap(0, FMonsterSpawnPointParam)
--     local Index = 1
--     local AroundKeys = self.GameMode:GetAroundKeys(self.GameMode.MonsterSpawnDivSize, Loc)
--     local LevelLoader = self.GameMode:GetLevelLoader()
--     for i, Key in pairs(AroundKeys) do
--         local Points = self.GameMode.MonsterSpawnDivisions[Key] or {}
--         for ii, TmpMonsterSpawnPoint in pairs(Points) do
--             local IsPointEnable = self:CheckPointEnable(TmpMonsterSpawnPoint, LevelLoader)
--             if IsPointEnable then
--                 Res:Add(Index, TmpMonsterSpawnPoint)
--                 Index = Index + 1
--             end
--         end
--     end
--     return Res
-- 	-- return self.GameMode:GetAroundDivisionInfos(Loc)
-- end

return BP_GroupMonsterSpawn_C

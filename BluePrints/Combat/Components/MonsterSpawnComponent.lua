
require "UnLua"

local Component = Class()

-- function Component:InitRelationSpawn()
-- 	if not self.Data then
-- 		return
-- 	end
-- 	if not self.Data.RelationId then 
-- 		return
-- 	end
-- 	self.RelationData = DataMgr.RelationSpawn[self.Data.RelationId]
-- 	if not self.RelationData then 
-- 		return
-- 	end
-- 	self.RelationLength = math.min(#self.RelationData.UnitId, #self.RelationData.UnitWeight)
-- 	self.TotalWeight = self:GetTotalWeight()
-- 	self.RelationSpawnNum = self.RelationData.RelationSpawnTotalNum[self:GetRelationMultiInfo()] or 0
-- 	self.RelationSpawnLevel = self.RelationData.UnitLevel or 0
-- 	self:RelationCreateMonsters()
-- end

-- function Component:GetRelationMultiInfo()
-- 	local Res = self:GetMultiInfo():Num()
-- 	if Res == 0 then
-- 		return 1
-- 	end
-- 	return Res
-- end

-- function Component:GetTotalWeight()
-- 	local TotalWeight = 0
-- 	for i = 1, self.RelationLength do
-- 		TotalWeight = TotalWeight + self.RelationData.UnitWeight[i]
-- 	end
-- 	return TotalWeight
-- end

-- function Component:GetRelationCMBaseInfo()
-- 	local RelationInfo = {}
-- 	for i = 1, self.RelationSpawnNum do
-- 		local RelationUnitId = self:GetRelationUnitId()
-- 		if RelationInfo[RelationUnitId] then 
-- 			RelationInfo[RelationUnitId] = RelationInfo[RelationUnitId] + 1
-- 		else
-- 			RelationInfo[RelationUnitId] = 1
-- 		end
-- 	end
-- 	if IsEmptyTable(RelationInfo) then 
-- 		return {}
-- 	end
-- 	local PresetTargets = self:GetPresetTarget() 
-- 	local DistributedInfo = self:DistributedMonster(PresetTargets:ToTable(), RelationInfo, self:GetSpawnTypeIsBalance())
-- 	return DistributedInfo
-- end

-- function Component:RelationCreateMonsters()
-- 	-- 获取刷怪的基本信息
-- 	local DistributedInfo = self:GetRelationCMBaseInfo()
-- 	-- 获取刷怪的全部位置
-- 	local TotalSpawnLocs = self:GetLocations(DistributedInfo)

-- 	-- 对每个预设目标开始刷怪
-- 	for PresetTarget, TargetNeedSpawnInfo in pairs(DistributedInfo) do
-- 		-- 获取刷怪的位置
-- 		self.Locations = TotalSpawnLocs[PresetTarget]
-- 		self.LocationIndex = 0
-- 		self:TryCreateMonsters(PresetTarget, TargetNeedSpawnInfo, "Relation", PresetTarget.Eid)
-- 	end
-- end

-- function Component:GetRelationUnitId()
-- 	local RandomValue = math.random(0, self.TotalWeight)
-- 	local RandomCount = 0
-- 	for i = 1, self.RelationLength do
-- 		RandomCount = RandomCount + self.RelationData.UnitWeight[i]
-- 		if RandomValue <= RandomCount then 
-- 			return self.RelationData.UnitId[i]
-- 		end
-- 	end
-- 	return self.RelationData.UnitId[1]
-- end

return Component
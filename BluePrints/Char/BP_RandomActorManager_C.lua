--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
---@type BP_RandomActorManager_C
local BP_RandomActorManager_C = Class("BluePrints.Common.TimerMgr")

function BP_RandomActorManager_C:GetRandomCount(RandomId)
	if not DataMgr.RandomCreator[RandomId] then
		GWorld.logger.error("哦我的上帝，这里有一个随机刷新规则"..RandomId.."找不到它亲爱的配表数据，亲爱的策划能改一下GameMode配置吗")
		return 0
	end
	local Count = DataMgr.RandomCreator[RandomId].Count
	return Count
end

--     2025.2.7 掩体功能废弃
-- function BP_RandomActorManager_C:ShowCoverPoint(bShow)
-- 	if bShow ~= 0 then
-- 		local DebugHandle = self:AddTimer(0.1, self.DrawDebug, true, 0)
-- 	else
-- 		self:RemoveTimer(DebugHandle)
-- 	end
-- end

function BP_RandomActorManager_C:DrawDebug()
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	for i,v in pairs(GameState.CoverPointInfos) do
		if v.UsingEid ~= 0 then
			local Monster = Battle(self):GetEntity(v.UsingEid)
			local Red = UE4.UKismetMathLibrary.LinearColor_Red()
			UE4.UKismetSystemLibrary.DrawDebugSphere(self, v:GetCoverPointLoc(self), 20, 12, Red, 0.1)
			UE4.UKismetSystemLibrary.DrawDebugLine(self, v:GetCoverPointLoc(self), Monster:K2_GetActorLocation(), Red, 0.1)
		end
	end
end

function BP_RandomActorManager_C:CreateDataParamIndex(RuleId, LevelName, IdxInRule, DataParamIndex)
	if self.DataParamTable == nil then
		self.DataParamTable = {}
	end

	if self.DataParamTable[RuleId] == nil then
		self.DataParamTable[RuleId] = {}
	end

	if self.DataParamTable[RuleId][LevelName] == nil then
		self.DataParamTable[RuleId][LevelName] = {}
	end
	self.DataParamTable[RuleId][LevelName][IdxInRule] = DataParamIndex
end

function BP_RandomActorManager_C:IndexDataByLevelNameAndIdxInRule(RuleId, LevelName, IdxInRule)
	-- print(_G.LogTag,"LXZ IndexDataByLevelNameAndIdxInRule", RuleId, LevelName, IdxInRule)
	-- print(_G.LogTag,"LXZ IndexDataByLevelNameAndIdxInRule111", self.DataParamTable[RuleId])
	-- print(_G.LogTag,"LXZ IndexDataByLevelNameAndIdxInRule222", self.DataParamTable[RuleId][LevelName])
	if not self.DataParamTable[RuleId][LevelName] then
		DebugPrint("RandomCreator中不存在如下数据： RuleId = ", RuleId, " LevelName = ", LevelName)
		return{}
	end
	-- print(_G.LogTag,"LXZ IndexDataByLevelNameAndIdxInRule333", self.DataParamTable[RuleId][LevelName][IdxInRule])
	return self.DataParamTable[RuleId][LevelName][IdxInRule]
end

function BP_RandomActorManager_C:ProgressDataRecoverRandomActor(RuleId, LevelName, IdxInRule, TableIdx, ItemData)
    local UnitLevel = DataMgr.RandomCreator[RuleId].RandomInfos[TableIdx].UnitLevel or 0
    local RandomCreatorId = self:GetParamActorId(RuleId, LevelName, IdxInRule)
	local GameState = UE4.UGameplayStatics.GetGameState(self)

    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    UnitLevel = UnitLevel + GameMode:GetFixedGamemodeLevel()
    local ParamRot = self:GetCreatorRegionDataRot(RuleId, RandomCreatorId)
    local ManagerRot = GameState.RandomCreatorDataMap:Find(LevelName):K2_GetActorRotation()
    local Rot = FRotator(ParamRot.Pitch + ManagerRot.Pitch, ParamRot.Yaw + ManagerRot.Yaw, ParamRot.Roll + ManagerRot.Roll)

	local Context = AEventMgr.CreateUnitContext()
	Context.UnitType = DataMgr.RandomCreator[RuleId].UnitType
	Context.UnitId = DataMgr.RandomCreator[RuleId].RandomInfos[TableIdx].UnitId
	Context.Loc = self:GetCreatorRegionDataLoc(RuleId, RandomCreatorId)
	Context.Rotation = Rot
	Context.Creator =  self:GetCreator(RuleId, LevelName, IdxInRule)
	Context.IntParams:Add("Level", UnitLevel)
	Context.IntParams:Add("RandomCreatorId", RandomCreatorId)
	Context.IntParams:Add("RandomRuleId", RuleId)
	Context.IntParams:Add("RandomTableId", TableIdx)
	Context:AddLuaTable("DungeonState", ItemData)
	GameMode.EMGameState.EventMgr:CreateUnitNew(Context, false)
end

return BP_RandomActorManager_C

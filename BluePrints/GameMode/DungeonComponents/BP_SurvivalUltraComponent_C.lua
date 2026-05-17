--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_SurvivalUltraComponent_C
local M = Class({
	"BluePrints.GameMode.DungeonComponents.BP_SurvivalMiniBaseComponent_C",
    "BluePrints.GameMode.DungeonComponents.BP_DungeonVoteComponent_C",
})

function M:InitSurvivalUltraComponent()
    self:InitSurvivalMiniBaseComponent()
    self:InitVoteComponent()

    self.SurvivalUltraInfo = DataMgr.SurvivalUltra[self.GameMode.DungeonId]
    if not self.SurvivalUltraInfo then
		GameState(self):ShowDungeonError("SurvivalUltraComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id："..self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end

	self.MonsterSpawnIds = self.SurvivalUltraInfo.MonsterSpawnId
	self.StrongLoopSpawnIds = self.SurvivalUltraInfo.StrongLoopSpawnId
	self.LevelThresholds = self.SurvivalUltraInfo.LevelThreshold

	self.ExtraLevel = 0 	-- 之后服务器会给道具等级，等正式接入之后再改
end

function M:InitSurvivalUltraBaseInfo()
	local CurLevel = self.GameMode:GetGameModeLevel()
	self.GameMode:SetGameModeLevel(CurLevel + self.ExtraLevel)
end

-- function M:RecordDungeonRoundData()
-- 	local RoundData = {
--         -- 这俩为啥不放外面呢？ todo: 移到通用的流程里
-- 		DungeonProgress = self.GameMode.EMGameState.DungeonProgress,
-- 		GameModeLevel = self.GameMode:GetGameModeLevel(),
-- 		EnergySupplyCount = self.GameMode.EMGameState.EnergySupplyCount,
-- 	}
-- 	PrintTable(RoundData, 3)
-- 	return RoundData
-- end

-- function M:RecoverDungeonRoundData(Data)
-- 	PrintTable(Data, 3)
-- 	self.GameMode.EMGameState:SetDungeonProgress(Data.DungeonProgress)
-- 	self.GameMode.EMGameState:SetGameModeLevel(Data.GameModeLevel)
-- 	self.GameMode.EMGameState:AddEnergySupplyCount(Data.EnergySupplyCount)

-- 	self.GameMode.EMGameState:SetDungeonUIState(Const.EDungeonUIState.OnTarget)
-- end

function M:StartRound()
    M.Super.StartRound(self)
end

function M:SpawnMonsters()
    local CurRoundIndex = self:GetRoundIndex()

	if self.LastSpanwnIdsCache then
		local LastSpawnIdArray = self:TableToTArray(self.LastSpanwnIdsCache)
		self.GameMode:TriggerDestoryMonsterSpawn(LastSpawnIdArray)
		self.GameMode:DeleteMonsterSpawnDropRuleByArray(LastSpawnIdArray)
	end

	local NewSpawnIds = self:GetMonsterSpawnIdByRoundIndex(CurRoundIndex)
	local NesSpawnIdArray = self:TableToTArray(NewSpawnIds)
    self.GameMode:TriggerCreateMonsterSpawn(NesSpawnIdArray)
	self.GameMode:AddMonsterSpawnDropRuleByArray(NesSpawnIdArray)

	self.LastSpanwnIdsCache = NewSpawnIds
end

function M:GetRoundIndex()
    return self.GameMode.EMGameState.DungeonProgress
end

function M:GetWaveIndex()
	return self:GetRoundIndex()
end

---@return table @当前轮所有刷怪规则，注意类型是table 和生存不一样
function M:GetMonsterSpawnIdByRoundIndex(RoundIndex)
	local ResTable = {}
    if RoundIndex < 1 then
        return ResTable
    end

	-- 轮次index 映射到 每轮刷怪规则 真实index
	local RealMonsterIndex = RoundIndex % #self.MonsterSpawnIds
	if RealMonsterIndex == 0 then
		RealMonsterIndex = #self.MonsterSpawnIds
	end
	for _, Id in pairs(self.MonsterSpawnIds[RealMonsterIndex]) do
		table.insert(ResTable, Id)
	end

	local CurStrongSpawnIds = self:GetCurStrongSpawnIds()
	if CurStrongSpawnIds then
		-- 轮次index 映射到 每轮号令者规则 真实index
		local RealStrongIndex = RoundIndex % #CurStrongSpawnIds
		if RealStrongIndex == 0 then
			RealStrongIndex = #CurStrongSpawnIds
		end
		table.insert(ResTable, CurStrongSpawnIds[RealStrongIndex])
	end

	return ResTable
end

---@return table @当前被轮换到的 号令者循环刷怪组
function M:GetCurStrongSpawnIds()
	local CurLevel = self.GameMode:GetGameModeLevel()
	local Index = 1 
	for _, LevelThreshold in pairs(self.LevelThresholds) do
		if CurLevel >= LevelThreshold then
			Index = Index + 1
		end
	end
	
	return self.StrongLoopSpawnIds[Index]
end

-- function M:OnSurvivalMiniValueChanged(NewValue)
-- 	M.Super.OnSurvivalMiniValueChanged(self, NewValue)
-- end

-- function M:Initialize(Initializer)
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

return M

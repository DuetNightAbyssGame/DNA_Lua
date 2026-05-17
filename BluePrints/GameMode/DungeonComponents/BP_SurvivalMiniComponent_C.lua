--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_SurvivalMiniComponent_C
local M = Class({
	"BluePrints.GameMode.DungeonComponents.BP_SurvivalMiniBaseComponent_C",
    "BluePrints.GameMode.DungeonComponents.BP_DungeonVoteComponent_C",
})

function M:InitSurvivalMiniComponent()
    self:InitSurvivalMiniBaseComponent()
    self:InitVoteComponent()

    self.SurvivalMiniInfo = DataMgr.SurvivalMini[self.GameMode.DungeonId]
    if not self.SurvivalMiniInfo then
		GameState(self):ShowDungeonError("SurvivalMiniComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id："..self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end

    self.MonsterSpawnIds = self.SurvivalMiniInfo.MonsterSpawnId
	self.EventValue = self.SurvivalMiniInfo.EventValue or 50
	self.IsEventTrigger = false

	self.GameMode:InitCreateEmergencyMonsterProb("Treasure", self, self.SurvivalMiniInfo)
	self.GameMode:InitCreateEmergencyMonsterProb("Butcher", self, self.SurvivalMiniInfo)
end

function M:InitSurvivalMiniBaseInfo()

end

function M:RecordDungeonRoundData()
	local RoundData = {
        -- 这俩为啥不放外面呢？ todo: 移到通用的流程里
		DungeonProgress = self.GameMode.EMGameState.DungeonProgress,
		GameModeLevel = self.GameMode:GetGameModeLevel(),
		EnergySupplyCount = self.GameMode.EMGameState.EnergySupplyCount,
	}
	PrintTable(RoundData, 3)
	return RoundData
end

function M:RecoverDungeonRoundData(Data)
	PrintTable(Data, 3)
	self.GameMode.EMGameState:SetDungeonProgress(Data.DungeonProgress)
	self.GameMode.EMGameState:SetGameModeLevel(Data.GameModeLevel)
	self.GameMode.EMGameState:AddEnergySupplyCount(Data.EnergySupplyCount)

	self.GameMode.EMGameState:SetDungeonUIState(Const.EDungeonUIState.OnTarget)
end

function M:StartRound()
	if self.IsRoundBegin then
		return
	end

    M.Super.StartRound(self)

	self.GameMode:CreateEmergencyMonsterEachWave("Treasure", self, self.SurvivalMiniInfo)
	self.GameMode:CreateEmergencyMonsterEachWave("Butcher", self, self.SurvivalMiniInfo)

	if self:GetRoundIndex() == 2 then
		if self.GameMode:GetNeedCreateEmergencyMonster("Pet") then
			self.GameMode:TriggerSpawnPet()
		end
	end

	self.IsEventTrigger = false
end

function M:SpawnMonsters()
    local CurRoundIndex = self:GetRoundIndex()

	local LastSpawnIds = self:GetMonsterSpawnIdByRoundIndex(CurRoundIndex - 1)
    self.GameMode:TriggerDestoryMonsterSpawn(LastSpawnIds)
	for _, MonsterSpawnId in pairs(LastSpawnIds) do			-- 改不了c++了 先这样吧
		self.GameMode:DeleteMonsterSpawnDropRule(MonsterSpawnId)
	end

	local NewSpawnIds = self:GetMonsterSpawnIdByRoundIndex(CurRoundIndex)
    self.GameMode:TriggerCreateMonsterSpawn(NewSpawnIds)
	self.GameMode:AddMonsterSpawnDropRuleByArray(NewSpawnIds)
end

function M:GetRoundIndex()
    return self.GameMode.EMGameState.DungeonProgress
end

function M:GetWaveIndex()
	return self:GetRoundIndex()
end

function M:GetMonsterSpawnIdByRoundIndex(RoundIndex)
    if RoundIndex < 1 then
        return TArray(0)
    end

	local RealIndex = RoundIndex % #self.MonsterSpawnIds
	if RealIndex == 0 then
		RealIndex = #self.MonsterSpawnIds
	end
	return self:TableToTArray(self.MonsterSpawnIds[RealIndex])
end

function M:OnSurvivalMiniValueChanged(NewValue)
	if not self.IsEventTrigger then
		if NewValue >= self.EventValue then
			self.IsEventTrigger = true
			self.GameMode:TriggerGameModeEvent("Event_OnSurvivalMiniEvent")
		end
	end
	M.Super.OnSurvivalMiniValueChanged(self, NewValue)
end

-- function M:Initialize(Initializer)
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

return M

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_SurvivalMiniProComponent_C
local M = Class({
	"BluePrints.GameMode.DungeonComponents.BP_SurvivalMiniBaseComponent_C",
})

function M:InitSurvivalMiniProComponent()
    self:InitSurvivalMiniBaseComponent()

    local SurvivalMiniProInfo = DataMgr.SurvivalMiniPro[self.GameMode.DungeonId]
    if not SurvivalMiniProInfo then
		GameState(self):ShowDungeonError("SurvivalMiniProComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id："..self.GameMode.DungeonId)
		return
	end

    self.MonsterSpawnId = SurvivalMiniProInfo.MonsterSpawnId or {}
    self.SpMonsterSpawnId = SurvivalMiniProInfo.SpMonsterSpawnId or {}
    self.SpMonsterSpawnTime = SurvivalMiniProInfo.SpMonsterSpawnTime or 20
    self.IsCycleSpawn = SurvivalMiniProInfo.IsCycleSpawn or false

    self.CurCycleIndex = 0
end

function M:InitSurvivalMiniProBaseInfo()
    
end

function M:StartRound()
    if self.IsRoundBegin then
		return
	end

    M.Super.StartRound(self)

    local Interval = DataMgr.GlobalConstant.SurvivalCostRate.ConstantValue
	local function AutoCostSurvivalValue()
		if not self.GameMode.EMGameState:CheckGameModeStateEnable() then
			self:RemoveTimer("AutoCostSurvivalValue")
            return
        end
		self:AddSurvivalMiniValue(-1)
	end
	self:AddTimer(Interval, AutoCostSurvivalValue, true, 0, "AutoCostSurvivalValue")
end

function M:SpawnMonsters()
    self.GameMode:TriggerCreateMonsterSpawn(self:TableToTArray(self.MonsterSpawnId))
    self:AddTimer(self.SpMonsterSpawnTime - 2, self.SpawnSpMonstersAlarm)
    self:AddTimer(self.SpMonsterSpawnTime, self.SpawnSpMonsters)
end

-- 交互要求 毒怪出现前2s要有预警提示
function M:SpawnSpMonstersAlarm()
    if not self.IsRoundBegin then
        return
    end

    self.GameMode:NotifyClientShowDungeonToast("", 2, EToastType.SabotageAlarm)
end

function M:SpawnSpMonsters()
    if not self.IsRoundBegin then
        return
    end

    if self.IsCycleSpawn then
        self:DoCycleSpawn()
    else
        self.GameMode:TriggerCreateMonsterSpawn(self:TableToTArray(self.SpMonsterSpawnId))
        self.GameMode:TriggerGameModeEvent("Event_OnSpawnSpMonsters")
    end
end

function M:DoCycleSpawn()
    self.CurCycleIndex = self.CurCycleIndex + 1
    if self.CurCycleIndex > #self.SpMonsterSpawnId then
        return
    end

    local CurCycleSpawnId = self.SpMonsterSpawnId[self.CurCycleIndex]
    local SpawnIdArray = TArray(0)
    SpawnIdArray:Add(CurCycleSpawnId)
    self.GameMode:TriggerCreateMonsterSpawn(SpawnIdArray)

    self.GameMode:TriggerGameModeEvent("Event_OnSpawnSpMonsters")
end

function M:OnMonsterSpawnDestroy(MonsterSpawnId)
    if not self.IsCycleSpawn then
        return
    end
    if self.CurCycleIndex > #self.SpMonsterSpawnId then
        return
    end

    local CurCycleSpawnId = self.SpMonsterSpawnId[self.CurCycleIndex]
    if CurCycleSpawnId == MonsterSpawnId then
        self:SpawnSpMonstersAlarm()
        self:AddTimer(2, self.DoCycleSpawn)
    end
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

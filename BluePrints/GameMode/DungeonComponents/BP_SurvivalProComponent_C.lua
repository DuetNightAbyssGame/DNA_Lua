require "UnLua"

local BP_SurvivalProComponent_C = Class({
    "BluePrints.Common.TimerMgr",
    "BluePrints.GameMode.DungeonComponents.BP_SurvivalComponent_C",
})

function BP_SurvivalProComponent_C:InitSurvivalProComponent()
    self.GameMode = self:GetOwner()
    self.GameState = self.GameMode.EMGameState
    self:InitVoteComponent()
    self.SurvivalVitaminStop = false
    self.MinExtraFixVitamin = DataMgr.GlobalConstant.MinExtraFixVitamin.ConstantValue
	self.MaxSurvivalValue = DataMgr.GlobalConstant.SurvivalValue.ConstantValue

    self.SurvivalProInfo = DataMgr.SurvivalPro[self.GameMode.DungeonId]
    if not self.SurvivalProInfo then
        GameState(self):ShowDungeonError("SurvivalProComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id："..self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end
    self.RoundTime = self.SurvivalProInfo.RoundTime or 180.0  -- 发放奖励/暂停并投票间隔
    self.MonsterFirstSpawnId = self.SurvivalProInfo.MonsterFirstSpawnId or {501} -- 首次进入刷怪规则
    self.LoopRule = self.SurvivalProInfo.LoopRule or {1}  
    self.MonsterSpawnIds = self.SurvivalProInfo.MonsterSpawnId or {501}  -- 小怪刷怪规则
    self.MonsterSpawnDelay = self.SurvivalProInfo.MonsterSpawnDelay or 0.0  -- 每次刷新特殊怪之后，刷怪规则更新延迟
    self.SpLoopRule = self.SurvivalProInfo.SpLoopRule or {1}  -- 特殊怪循环规则
    self.SpMonsterSpawnRules = self.SurvivalProInfo.SpMonster  -- 特殊怪刷新规则

	self.MonsterSpawnIndex = 0  -- 小怪刷怪波次
    self.bIsFirstRound = true  -- 处理第一轮相关逻辑
    self.SpMonsterInfos = {}  -- 特殊怪相关参数(播对话、弹Toast)

	self.GameMode:InitCreateEmergencyMonsterProb("Butcher", self, self.SurvivalProInfo)
end

function BP_SurvivalProComponent_C:InitSurvivalProBaseInfo()
end

function BP_SurvivalProComponent_C:RecordDungeonRoundData()
	local RoundData = {
		DungeonProgress = self.GameMode.EMGameState.DungeonProgress,
		GameModeLevel = self.GameMode:GetGameModeLevel(),
		SurvivalValue = self.GameMode.EMGameState.SurvivalValue,
        SurvivalTime = self.GameMode.EMGameState.CumulativeSurvivalTime,
		MonsterSpawnIndex = self.MonsterSpawnIndex,
        bIsFirstRound = self.bIsFirstRound
	}
	PrintTable(RoundData, 3)
	return RoundData
end

function BP_SurvivalProComponent_C:RecoverDungeonRoundData(Data)
	PrintTable(Data, 3)
	self.GameMode.EMGameState:SetDungeonProgress(Data.DungeonProgress)
	self.GameMode.EMGameState:SetGameModeLevel(Data.GameModeLevel)
	self.TmpSurvivalValue = Data.SurvivalValue  -- 暂存一下，重新激活维生流程时再赋值
    self.TmpSurvivalTime = Data.SurvivalTime -- 暂存一下，重新激活维生流程时再赋值
	self.MonsterSpawnIndex = Data.MonsterSpawnIndex
    self.bIsFirstRound = Data.bIsFirstRound
end

function BP_SurvivalProComponent_C:OnMonsterDeadOut()
    if not IsStandAlone(self) then
        return
    end
    local MaxMonsterDeadOut = DataMgr.GlobalConstant.MaxMonsterDeadOut.ConstantValue
    self.MonsterDeadOut = self.MonsterDeadOut + 1
    if self.MonsterDeadOut >= MaxMonsterDeadOut and self.HasInEnergySurvival then
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
        UE4.UPlayTalkAsyncAction.PlayTalk(GameInstance, 600306,nil)
        self.MonsterDeadOut = 0
    end
end

function BP_SurvivalProComponent_C:TryToPostSurpossedLeave()
    local SupplyArray = UE4.UGameplayStatics.GetGameState(self).MechanismMap:FindRef("Supply").Array
    for i = 1, SupplyArray:Length() do
        if IsValid(SupplyArray[i]) and SupplyArray[i].NowEnergy ~= 0 then
            return
        end
    end
    if not self.HasPostSurpossedLeave and self.Success then
        self.GameMode:PostCustomEvent("SurvivalProSurpossedLeave", Const.GameModeEventServerClient)
        self.HasPostSurpossedLeave = true
    end
end

function BP_SurvivalProComponent_C:TryToPostBeginTutorial()
    if not self.HasPostBeginTutorial then
        self.GameMode:PostCustomEvent("SurvivalProBeginTutorial", Const.GameModeEventServerClient)
        self.HasPostBeginTutorial = true
    end
end

function BP_SurvivalProComponent_C:TryToPostFinishTutorial()
    if not self.HasPostFinishTutorial and self.HasPostBeginTutorial then
        self.GameMode:PostCustomEvent("SurvivalProFinishTutorial", Const.GameModeEventServerClient)
        self.HasPostFinishTutorial = true
    end
end

----------------------怪物生成逻辑---------------------------

-- 发轮次奖励，暂停并投票相关
function BP_SurvivalProComponent_C:RoundsStart()
    DebugPrint("SurvivalProComponent: RoundsStart", self.GameMode.EMGameState.DungeonProgress)

    if self.GameMode.EMGameState.DungeonProgress == 2 then
        if self.GameMode:GetNeedCreateEmergencyMonster("Pet") then
			self.GameMode:TriggerSpawnPet()
		end
    end

    self:AddTimer(self.RoundTime, self.RoundsEnd, false, 0, "RoundsTimer")
end

function BP_SurvivalProComponent_C:RoundsEnd()
    if not self.GameMode.EMGameState:CheckGameModeStateEnable() then
		return
	end

    DebugPrint("SurvivalProComponent: RoundsEnd", self.GameMode.EMGameState.DungeonProgress)
    -- 单独处理第一轮结束逻辑
    if self.bIsFirstRound then
        self.bIsFirstRound = false

        self.GameMode:TriggerDestoryMonsterSpawn(self:TableToTArray(self.MonsterFirstSpawnId))  -- 清除首次进入的刷怪规则

        self.GameMode:TriggerGameModeEvent("OnFirstRoundEnd")
    end

    self.GameMode:TriggerGameModeEvent("OnEachRoundEnd")  -- 暂停并投票  投票结束后会走OnBattle，通过OnBattle触发TriggerMonsterSpawn()
end

-- 为了方便轮次数据异常恢复，把刷怪逻辑拆分出来
-- 正常流程触发时机是每轮结束之后触发
-- 异常恢复直接OnBattle触发该逻辑
function BP_SurvivalProComponent_C:TriggerMonsterSpawn()
    if self.bIsFirstRound then return end
    if not self.GameMode.EMGameState:CheckGameModeStateEnable() then
		return
	end
    
    self:TriggerSpecialMonsterSpawn() -- 刷特殊怪

    self:ClearPreviousMonsterSpawnRule()
    self:UpdateNewMonsterSpawnRule() -- 更新刷怪规则

    self:RoundsStart()  -- 开启下一轮
end

-- 小怪刷怪规则相关
function BP_SurvivalProComponent_C:ClearPreviousMonsterSpawnRule()
    if self.MonsterSpawnIndex > 0 then
        self.GameMode:TriggerDestoryMonsterSpawn(self:GetMonsterSpawnIdPro())  -- 清除上一波刷怪规则
    end
end

function BP_SurvivalProComponent_C:UpdateNewMonsterSpawnRule()
    self.MonsterSpawnIndex = self.MonsterSpawnIndex + 1 
    self.GameMode:TriggerCreateMonsterSpawn(self:GetMonsterSpawnIdPro())  -- 更新新一波刷怪规则
    self.GameMode:CreateEmergencyMonsterEachWave("Butcher", self, self.SurvivalProInfo)
end

function BP_SurvivalProComponent_C:GetMonsterSpawnIdPro()
    -- 根据循环规则LoopRule来决定使用哪条刷怪规则
    -- 例：LoopRule为132，则代表依次使用1、3、2号刷怪规则，并循环
    local RealIndex = self.MonsterSpawnIndex % #self.LoopRule
    if RealIndex == 0 then
        RealIndex = #self.LoopRule
    end
    return self:TableToTArray(self.MonsterSpawnIds[self.LoopRule[RealIndex]])
end

function BP_SurvivalProComponent_C:TriggerMonsterFirstSpawn()
    -- 此逻辑仅在第一次接触到维生装置，并且第一轮结束前触发
    if self.bIsFirstRound then
        self.GameMode:TriggerCreateMonsterSpawn(self:TableToTArray(self.MonsterFirstSpawnId))
    end
end

-- 特殊怪刷怪规则相关
function BP_SurvivalProComponent_C:TriggerSpecialMonsterSpawn()
    local SpMonsterId = self:GetSpMonsterId()
    local SpMonsterSpawnRule = self.SpMonsterSpawnRules[SpMonsterId]
    DebugPrint("ljl_TriggerSpecialMonsterSpawn", SpMonsterId, self.MonsterSpawnIndex)
    if SpMonsterSpawnRule then
        self:AddTimer(SpMonsterSpawnRule.SpMonsterSpawnTime, function() 
            if not self.GameMode.EMGameState:CheckGameModeStateEnable() then return end
            self.GameMode:TriggerGameModeEvent("OnSpMonsterTimerEnd", SpMonsterId)  -- 蓝图连特殊怪真正刷怪逻辑RealSpMonsterSpawn
        end)
    else
        GameState(self):ShowDungeonError("SurvivalProComponent:SurvivalPro表内没有对应特殊怪信息，Id："..SpMonsterId..", "..self.MonsterSpawnIndex, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    end
    self.GameMode:CreateEmergencyMonsterEachWave("Butcher", self, self.SurvivalProInfo)
end

function BP_SurvivalProComponent_C:GetSpMonsterId()
    local SpMonsterIndex = (self.MonsterSpawnIndex // 2) + 1  -- 怪物Index为0,2,4...时，特殊怪Index换算
    local RealIndex = SpMonsterIndex % #self.SpLoopRule
    if RealIndex == 0 then
        RealIndex = #self.SpLoopRule
    end
    return RealIndex
end

function BP_SurvivalProComponent_C:RealSpMonsterSpawn(SpMonsterId)  -- 被蓝图触发，若走不到这里记得检查蓝图
    DebugPrint("ljl_RealSpMonsterSpawn", SpMonsterId)
    local SpMonsterSpawnRule = self.SpMonsterSpawnRules[SpMonsterId]
    if SpMonsterSpawnRule then
        local SpMonsterSpawnId = SpMonsterSpawnRule.SpMonsterSpawnId
        self.GameMode:TriggerCreateMonsterSpawn(self:TableToTArray(SpMonsterSpawnId))  -- 填入特殊怪刷怪规则
    else
        GameState(self):ShowDungeonError("SurvivalProComponent:特殊怪Id错误，检查蓝图！Id："..SpMonsterId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    end
    self:ClearPreviousMonsterSpawnRule()
    self:AddTimer(self.MonsterSpawnDelay, self.UpdateNewMonsterSpawnRule, false, 0, "MonsterSpawnDelay")  -- 更新小怪刷怪规则
end

-- 给刷屠夫怪/盗宝怪拿刷怪轮次的统一接口	todo: 用到self.MonsterSpawnIndex的地方统一替换接口
function BP_SurvivalProComponent_C:GetWaveIndex()
	return self.MonsterSpawnIndex
end

--------------------------------------------------------

return BP_SurvivalProComponent_C
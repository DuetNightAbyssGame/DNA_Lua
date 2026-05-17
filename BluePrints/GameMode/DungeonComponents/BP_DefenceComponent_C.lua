require "UnLua"

local BP_DefenceComponent_C = Class({
	"BluePrints.Common.TimerMgr",
	"BluePrints.GameMode.DungeonComponents.BP_DungeonVoteComponent_C",
})

--------------------GameMode 流程&事件相关------------------------
function BP_DefenceComponent_C:InitDefenceComponent()
	self.GameMode = self:GetOwner()
	self:InitVoteComponent()
	self.GameMode.EMGameState:SetDefenceWaveInterval(DataMgr.GlobalConstant.DefenceWaveInterval.ConstantValue or 5)

	self.DefenceInfo = self:GetDataMgrInfo()
	if not self.DefenceInfo then
		GameState(self):ShowDungeonError("DefenceComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id："..self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end
	self.MonsterTotalBaseNum = self.DefenceInfo.MonsterTotalBaseNum or 15  -- 每一波刷怪数（基础）
	self.MonsterTotalNum = self.MonsterTotalBaseNum  -- 每一波刷怪数（浮动）
	self.MonsterSpawnIds = self.DefenceInfo.MonsterSpawnId

	self.bMissionSwitched = false  -- 每波只切换一次任务
	self.bMonRuleReseted = false  -- 每波只重置一次刷怪规则
	self.GameMode:InitCreateEmergencyMonsterProb("Butcher", self, self.DefenceInfo)

	local WavesPerStage = self.DefenceInfo.WavesPerStage or 3
	self.GameMode.EMGameState:SetDefenceWavesPerStage(WavesPerStage)

	self.EnsureGuideTime = self.DefenceInfo.EnsureGuideTime or -1
end

--region 子类重写
function BP_DefenceComponent_C:GetDataMgrInfo()
	return DataMgr.Defence[self.GameMode.DungeonId]
end
--endregion

function BP_DefenceComponent_C:RecordDungeonRoundData()
	local RoundData = {
		DungeonProgress = self.GameMode.EMGameState.DungeonProgress,
		GameModeLevel = self.GameMode:GetGameModeLevel(),
		DefenceWave = self.GameMode.EMGameState.DefenceWave
	}
	PrintTable(RoundData, 2)
	return RoundData
end

function BP_DefenceComponent_C:RecoverDungeonRoundData(Data)
	PrintTable(Data, 2)
	self.GameMode.EMGameState:SetDungeonProgress(Data.DungeonProgress)
	self.GameMode.EMGameState:SetGameModeLevel(Data.GameModeLevel)
	self.GameMode.EMGameState:SetDefenceWave(Data.DefenceWave)
end


function BP_DefenceComponent_C:WaveStart()
	if self.IsInWave then
		return
	end
	---@type boolean @用于去重 防止波次开始多次触发，波次结束后重置
	self.IsInWave = true	

	self.GameMode:CreateEmergencyMonsterEachWave("Butcher", self, self.DefenceInfo)
	self.MonsterTotalNum = self.MonsterTotalBaseNum 					-- 不浮动了
	self.GameMode:TriggerCreateMonsterSpawn(self:GetMonsterSpawnId())  -- 添加刷怪规则
	self.bMonRuleReseted = false

	self:InitEnsureGuideTimerEachWave()
end

function BP_DefenceComponent_C:GetMonsterSpawnId()
	local RealIndex = self:GetWaveIndex() % #self.MonsterSpawnIds
	if RealIndex == 0 then
		RealIndex = #self.MonsterSpawnIds
	end
	return self:TableToTArray(self.MonsterSpawnIds[RealIndex])
end

function BP_DefenceComponent_C:TriggerMonsterDead(Monster)
	if Monster.CreatorType and Monster.CreatorId and Monster:GetCamp() == ECampName.Monster then
        self.MonsterTotalNum = self.MonsterTotalNum - 1
		if self.MonsterTotalNum <= 0 then
			-- 显示指引图标
			if self:GetMonsterNum() <= 6 and self:GetMonsterNum() > 0 then  -- 场面上怪物(0,6]则显示击杀图标并改变任务提示
				for _, Monster in pairs(self.GameMode.EMGameState.MonsterMap) do
					if IsValid(Monster) and not Monster:IsDead() and Monster.UnitType == "Monster" 
								and self.GameMode:CheckCanGuide(Monster.UnitId, Monster.UnitType) then
						self.GameMode.EMGameState:AddGuideEid(Monster.Eid)
					end
				end

				if not self.bMissionSwitched then
					self.bMissionSwitched = true
					self.GameMode:TriggerGameModeEvent("OnShowRemainMonster")  -- 提示击杀剩余怪物
				end
			elseif self:GetMonsterNum() == 0 then  -- 场上怪物数为0，重置self.bMissionSwitched
				self.bMissionSwitched = false
			end

			-- 摧毁当前刷怪规则，下一波开始时重置
			if not self.bMonRuleReseted then
				self.bMonRuleReseted = true
				self.GameMode:DestroyAllMonsterSpawn()
				self:AddTimer(3.5, function() 
					self:AddTimer(2, self.MonsterNumCheck, true, 0, "MonsterNumCheck")
					self:AddTimer(5, self.FallbackNumCheck, true, 0, "FallbackNumCheck")
				end, false, 0, "MonRuleReset")  -- 摧毁当前刷怪规则
			end
		end
    end
end

function BP_DefenceComponent_C:MonsterNumCheck()
	DebugPrint("DefenceComponent MonsterNumCheck, GetMonsterNum:", self:GetMonsterNum(), "MonsterTotalNum:", self.MonsterTotalNum)
	if self:GetMonsterNum() == 0 and self.MonsterTotalNum <= 0 then
		self:DoWaveEnd()
	end
end

function BP_DefenceComponent_C:FallbackNumCheck()
	DebugPrint("DefenceComponent FallbackNumCheck, GetMonsterNum:", self:GetMonsterNum())
	local ActivatedMonsterSpawnNum = self.GameMode.MonsterSpawnMap:Num()
	if ActivatedMonsterSpawnNum > 0 then
		DebugPrint("DefenceComponent FallbackNumCheck 仍存在MonsterSpawn")
		return
	end

	local IsMonsterExists = self:CheckMonsterExists()
	if IsMonsterExists then
		DebugPrint("DefenceComponent FallbackNumCheck 场上仍存在怪物ActorActor")
		return
	end

	DebugPrint("DefenceComponent FallbackNumCheck Fallback Triggered! MonsterNum:", self:GetMonsterNum())
	self.GameMode.EMGameState.MonsterNum = 0
	self:DoWaveEnd()
end

function BP_DefenceComponent_C:CheckMonsterExists()
	for _, Monster in pairs(self.GameMode.EMGameState.MonsterMap) do
		if IsValid(Monster) and Monster.IsRealMonster and Monster:IsRealMonster() then
			return true
		end
	end
	return false
end

-- 每波结束相关逻辑 封一下
-- 正常是MonsterNumCheck触发，也可能由保底触发
function BP_DefenceComponent_C:DoWaveEnd()
	self.IsInWave = false

	self:ClearEnsureGuideTimer()
	self.GameMode:PostCustomEvent("DefenceWaveEnd")
	self:RemoveTimer("MonsterNumCheck")
	self:RemoveTimer("FallbackNumCheck")
	self.GameMode:TriggerGameModeEvent("OnShowDefenceTarget")  -- 提示守卫目标
end

function BP_DefenceComponent_C:OnDefenceCoreActive()
	self.GameMode.EMGameState:SetDungeonUIState(Const.EDungeonUIState.OnTarget)
end

function BP_DefenceComponent_C:GetMonsterNum()
	return self.GameMode.EMGameState.MonsterNum
end

function BP_DefenceComponent_C:GetWaveIndex()
	return self.GameMode.EMGameState.DefenceWave
end

function BP_DefenceComponent_C:AddWaveIndex(Value)
	self.GameMode.EMGameState:SetDefenceWave(self.GameMode.EMGameState.DefenceWave + Value)
end

function BP_DefenceComponent_C:SetWaveIndex(Value)
	self.GameMode.EMGameState:SetDefenceWave(Value)
end

function BP_DefenceComponent_C:TableToTArray(table)
	local ResTArray = TArray(0)
    if table then
		for _, Item in ipairs(table) do
			ResTArray:Add(Item)
		end
    end
    return ResTArray
end

function BP_DefenceComponent_C:InitEnsureGuideTimerEachWave()
	if self.EnsureGuideTime < 0 then
		return
	end

	self:AddTimer(self.EnsureGuideTime, function()
		self:DoEnsureGuide()
		self:AddTimer(5, self.DoEnsureGuide, true, 0, "DoEnsureGuide")
	end, false, 0, "EnsureGuideDelayTimer")
end

function BP_DefenceComponent_C:DoEnsureGuide()
	for _, Monster in pairs(self.GameMode.EMGameState.MonsterMap) do
		if not IsValid(Monster) then
			goto continue
		end
		if Monster:IsDead() then
			goto continue
		end
		if Monster.UnitType ~= "Monster" then
			goto continue
		end
		if not self.GameMode:CheckCanGuide(Monster.UnitId, Monster.UnitType) then
			goto continue
		end
		self.GameMode.EMGameState:AddGuideEid(Monster.Eid)
		::continue::
	end
end

function BP_DefenceComponent_C:ClearEnsureGuideTimer()
	self:RemoveTimer("EnsureGuideDelayTimer")
	self:RemoveTimer("DoEnsureGuide")
end

-----------------------------------------------------------------
return BP_DefenceComponent_C


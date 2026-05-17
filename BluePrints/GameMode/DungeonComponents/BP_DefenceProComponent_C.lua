require "UnLua"

local BP_DefenceComponent_C = Class({
	"BluePrints.Common.TimerMgr",
	"BluePrints.GameMode.DungeonComponents.BP_DefenceComponent_C",
})

--------------------GameMode 流程&事件相关------------------------
function BP_DefenceComponent_C:InitDefenceProComponent()
	self.GameMode = self:GetOwner()
	self.GameMode.EMGameState:SetDefenceWaveInterval(DataMgr.GlobalConstant.DefenceWaveInterval.ConstantValue or 5)

	self.DefenceProInfo = DataMgr.DefencePro[self.GameMode.DungeonId]
	if not self.DefenceProInfo then
		GameState(self):ShowDungeonError("DefenceProComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id："..self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end

	self.MonsterWave1:Clear()
	for _, SpawnRule in pairs(self.DefenceProInfo.WaveSpawnRule or {}) do
		self.MonsterWave1:Add(SpawnRule)
	end
end

function BP_DefenceComponent_C:InitEliteMonsterSpawm()
	if not self.DefenceProInfo then
		return
	end
	if not self.DefenceProInfo.EliteSpawnTime then
		return
	end
	local FinalEliteSpawnTime = 0
	if #self.DefenceProInfo.EliteSpawnTime == 1 then
		FinalEliteSpawnTime = self.DefenceProInfo.EliteSpawnTime[1]
	else
		FinalEliteSpawnTime = math.random(self.DefenceProInfo.EliteSpawnTime[1], self.DefenceProInfo.EliteSpawnTime[2])
	end
	DebugPrint("DefenceProComponent: "..FinalEliteSpawnTime.."秒后刷新卓越者")
	self:AddTimer(FinalEliteSpawnTime, function()
		local SpawnRule = TArray(0)
		for _, EliteSpawnRule in pairs(self.DefenceProInfo.EliteSpawnRule or {}) do
			SpawnRule:Add(EliteSpawnRule)
		end
		DebugPrint("DefenceProComponent: 刷新卓越者!")
		self.GameMode:TriggerCreateMonsterSpawn(SpawnRule)
	end)
end

function BP_DefenceComponent_C:TryDefenceProEnd()
	-- 开始计时统计，等怪物死完结束
	DebugPrint("DefenceProComponent: 开启检测剩余怪计时!")
	self:AddTimer(2, self.CheckMonsterNum, true, 0, "DefenceProEnd")
end

function BP_DefenceComponent_C:CheckMonsterNum()
	DebugPrint("DefenceProComponent: 检测剩余怪计时，剩余数量："..self.GameMode.EMGameState.MonsterNum)
	if self.GameMode.EMGameState.MonsterNum > 0 then
		return
	end
	self:RemoveTimer("DefenceProEnd")
	self.GameMode:TriggerGameModeEvent("OnDefenceProEnd")
end

-----------------------------------------------------------------
return BP_DefenceComponent_C


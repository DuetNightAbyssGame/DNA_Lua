require "UnLua"

local BP_RegionDefenceComponent_C = Class({
	"BluePrints.Common.TimerMgr",
})
------ 这个暂时废弃 -------------------
--------------------GameMode 流程&事件相关------------------------
function BP_RegionDefenceComponent_C:InitRegionDefenceComponent()
	DebugPrint("RegionDefenceComponent: Init!")
	self.GameMode = self:GetOwner()

	-- self.GameMode.EMGameState.DefenceWaveInterval = DataMgr.GlobalConstant.DefenceWaveInterval.ConstantValue or 5

	-- -- 读表要改
	-- self.DefenceInfo = DataMgr.Defence[self.GameMode.DungeonId]
	-- if not self.DefenceInfo then
	-- 	DebugPrint("无法找到当前副本ID，读表失败。读入Id：", self.GameMode.DungeonId)
	-- 	return
	-- end
	-- self.MonsterTotalBaseNum = self.DefenceInfo.MonsterTotalBaseNum or 15  -- 每一波刷怪数（基础）
	-- self.MonsterTotalNum = self.MonsterTotalBaseNum  -- 每一波刷怪数（浮动）
	-- self.MonsterSpawnIds = self.DefenceInfo.MonsterSpawnId

	-- self.bMissionSwitched = false  -- 每波只切换一次任务
	-- self.bMonRuleReseted = false  -- 每波只重置一次刷怪规则
end

function BP_RegionDefenceComponent_C:WaveStart()
	self.MonsterTotalNum = self.MonsterTotalBaseNum + math.random(0, 2)  -- 浮动每一波刷怪数
	self.GameMode:TriggerCreateMonsterSpawn(self:GetMonsterSpawnId())  -- 添加刷怪规则
	self.bMonRuleReseted = false
end

function BP_RegionDefenceComponent_C:GetMonsterSpawnId()
	local RealIndex = self:GetWaveIndex() % #self.MonsterSpawnIds
	if RealIndex == 0 then
		RealIndex = #self.MonsterSpawnIds
	end
	return self:TableToTArray(self.MonsterSpawnIds[RealIndex])
end

function BP_RegionDefenceComponent_C:TriggerMonsterDead(Monster)
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
				end, false, 0, "MonRuleReset")  -- 摧毁当前刷怪规则
			end
		end
    end
end

function BP_RegionDefenceComponent_C:MonsterNumCheck()
	if self:GetMonsterNum() == 0 and self.MonsterTotalNum <= 0 then
		self.GameMode:PostCustomEvent("DefenceWaveEnd")
		self:RemoveTimer("MonsterNumCheck")
		self.GameMode:TriggerGameModeEvent("OnShowDefenceTarget")  -- 提示守卫目标
	end
end

function BP_RegionDefenceComponent_C:GetMonsterNum()
	return self.GameMode.EMGameState.MonsterNum
end

function BP_RegionDefenceComponent_C:GetWaveIndex()
	return self.GameMode.EMGameState.DefenceWave
end

function BP_RegionDefenceComponent_C:AddWaveIndex(Value)
	self.GameMode.EMGameState:SetDefenceWave(self.GameMode.EMGameState.DefenceWave + Value)
end

function BP_RegionDefenceComponent_C:SetWaveIndex(Value)
	self.GameMode.EMGameState:SetDefenceWave(Value)
end

function BP_RegionDefenceComponent_C:TableToTArray(table)
	local ResTArray = TArray(0)
    if table then
		for _, Item in ipairs(table) do
			ResTArray:Add(Item)
		end
    end
    return ResTArray
end

-----------------------------------------------------------------
return BP_RegionDefenceComponent_C


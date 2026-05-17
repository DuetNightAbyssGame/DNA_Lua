require "UnLua"

local BP_ExterminateBaseComponent_C = Class({
	"BluePrints.Common.TimerMgr",
	"BluePrints.Common.DelayFrameComponent",
})
--------------------GameMode 流程&事件相关------------------------
function BP_ExterminateBaseComponent_C:InitExterminateBaseComponent()
	self.GameMode = self:GetOwner()
	self.NowGuideEids = {}  -- {PlayerEid : GuideEid}
	self.HasGuideUpdateRequest = {}  -- {PlayerEid : HasGuideUpdateRequest}
	self.Success = false

	--self.ExterminateInfo = DataMgr.Exterminate[self.GameMode.DungeonId]
	self.ExterminateInfo = self:GetDataMgrInfo()
    if not self.ExterminateInfo then
		GameState(self):ShowDungeonError("ExterminateBaseComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id："..self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end

	self.TargetNum = self.ExterminateInfo.TargetNum or 80

	self.NormalRange = self.ExterminateInfo.NormalRange		-- 小怪刷怪范围
	self.NormalSpawnRule = self.ExterminateInfo.NormalSpawnRule		-- 小怪刷怪规则
	self.NormalSpawnOnlyRelation = self.ExterminateInfo.NormalSpawnOnlyRelation		-- 小怪刷怪OnlyRelation
	self.IsNormalNumActive = self:ResetNormalNum()

	self.EliteRange = self.ExterminateInfo.EliteRange	-- 卓越者刷怪范围
	self.EliteSpawnRule = self.ExterminateInfo.EliteSpawnRule	-- 卓越者刷怪规则
	self.EliteSpawnOnlyRelation = self.ExterminateInfo.EliteSpawnOnlyRelation		-- 卓越者刷怪OnlyRelation
	self.IsEliteNumActive = self:ResetEliteNum()

	self.PetSpawnRange = self.ExterminateInfo.PetSpawnRange
	if self.PetSpawnRange then
		if #self.PetSpawnRange == 1 then
			self.PetSpawnNum = self.PetSpawnRange[1]
		else
			self.PetSpawnNum = math.random(self.PetSpawnRange[1], self.PetSpawnRange[2])
		end
	end

	self.GameMode.EMGameState:SetExterminateTotalNum(self.TargetNum)
end

--region 子类重写
function BP_ExterminateBaseComponent_C:GetDataMgrInfo()
	return
end

function BP_ExterminateBaseComponent_C:OnEliteNumClear()

end

-- end

-- 检测读表合法性，并重置怪物击杀数
-- @return 是否激活对应刷怪规则
function BP_ExterminateBaseComponent_C:ResetNormalNum()
	if self.NormalRange == nil then
		return false
	end
	if self.NormalSpawnRule == nil then
		return false
	end
	if self.NormalSpawnOnlyRelation == nil then
		return false
	end

	if #self.NormalRange == 1 then
		self.NormalNum = self.NormalRange[1]
	else
		self.NormalNum = math.random(self.NormalRange[1], self.NormalRange[2])
	end
	DebugPrint("ExterminateBaseComponent: New NormalNum:", self.NormalNum)
	return true
end

function BP_ExterminateBaseComponent_C:ResetEliteNum()
	if self.EliteRange == nil then
		return false
	end
	if self.EliteSpawnRule == nil then
		return false
	end
	if self.EliteSpawnOnlyRelation == nil then
		return false
	end

	if #self.EliteRange == 1 then
		self.EliteNum = self.EliteRange[1]
	else
		self.EliteNum = math.random(self.EliteRange[1], self.EliteRange[2])
	end
	DebugPrint("ExterminateBaseComponent: New EliteNum:", self.EliteNum)
	return true
end

-- 干脆移到子类得了 以免引起歧义
-- function BP_ExterminateBaseComponent_C:InitExterminateBaseInfo()
-- 	self:InitGuideUpdateTimerLogic()
-- end

function BP_ExterminateBaseComponent_C:InitGuideUpdateTimerLogic()
	-- self.GuideTimerHandle_AutoUpdate = "Handle_AutoUpdate"		-- 指引点自动更新
	-- self.GuideTimerHandle_LimitCalls = "Handle_LimitCalls"		-- 限制指引点调用频率
	self.GuideTimerHandle_DetectFault = "Handle_DetectFault"	-- 自动检测指引点是否存在

	self.GuideTimerInterval_AutoUpdate = DataMgr.GlobalConstant.ExterminateGuideInterval.ConstantValue or 10

	self:AddGuideTimer_DetectFault()							-- 初始进关卡显示指引/自动检测指引是否存在

	for i = 0, self.GameMode:GetPlayerNum() - 1 do
		local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, i)
		if IsValid(Player) then
			self.HasGuideUpdateRequest[Player.Eid] = false
			self:AddGuideTimer_AutoUpdate(Player.Eid)
		end
	end
end

function BP_ExterminateBaseComponent_C:OnPlayerEnter(PlayerEid)
	DebugPrint("zwk  中途有玩家加入 Eid： ", PlayerEid)
	self:AddGuideTimer_AutoUpdate(PlayerEid)
end

function BP_ExterminateBaseComponent_C:AddGuideTimer_AutoUpdate(PlayerEid)
	self:AddTimer(self.GuideTimerInterval_AutoUpdate, self.OnTimerEnd_AutoUpdate, true, 0, "Handle_AutoUpdate_" .. PlayerEid, nil, PlayerEid)
end

function BP_ExterminateBaseComponent_C:OnTimerEnd_AutoUpdate(PlayerEid)
	DebugPrint("ExterminateBaseComponent: 自动更新RemoveGuideEid 被Remove的指引点Eid: "..tostring(self.NowGuideEids[PlayerEid]).."  Player Eid: "..tostring(PlayerEid))
	-- self.GameMode.EMGameState:RemoveGuideEid(self.NowGuideEids[PlayerEid], PlayerEid)
	self:TryUpdateGuidePoint(PlayerEid)
end

function BP_ExterminateBaseComponent_C:AddGuideTimer_LimitCalls(PlayerEid)
	self:AddTimer(1, self.OnTimerEnd_LimitCalls, false, 0, "Handle_LimitCalls_" .. PlayerEid, nil, PlayerEid)
end

function BP_ExterminateBaseComponent_C:OnTimerEnd_LimitCalls(PlayerEid)
	if self.HasGuideUpdateRequest[PlayerEid] then
		DebugPrint("ExterminateBaseComponent: 补充调用更新指引 PlayerEid: "..PlayerEid)
		self:UpdateNearestMonsterGuide(PlayerEid)
		self.HasGuideUpdateRequest[PlayerEid] = false
	end
end

function BP_ExterminateBaseComponent_C:AddGuideTimer_DetectFault()
	self:AddTimer(2, self.OnTimerEnd_DetectFault, true, 0, self.GuideTimerHandle_DetectFault)
end

function BP_ExterminateBaseComponent_C:OnTimerEnd_DetectFault()
	for i = 0, self.GameMode:GetPlayerNum() - 1 do
		local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, i)
		if IsValid(Player) then
			if self:CheckGuideLogicHasFault(Player) then
				DebugPrint("ExterminateBaseComponent: 检测到玩家Eid: " .. Player.Eid .. " 不存在指引点，准备添加")
				--self:UpdateNearestMonsterGuide(Player.Eid)
				self:TryUpdateGuidePoint(Player.Eid)
			end
		end
	end
end

function BP_ExterminateBaseComponent_C:CheckGuideLogicHasFault(Player)
	if not IsValid(Player) then
		return true
	end
	if self.NowGuideEids[Player.Eid] == nil then
		return true
	end
	if not self.GameMode.EMGameState:ContainsGuideEid(self.NowGuideEids[Player.Eid], Player.Eid) then
		return true
	end
	return false
end

function BP_ExterminateBaseComponent_C:TryUpdateGuidePoint(PlayerEid)
	if self:IsExistTimer("Handle_LimitCalls_" .. PlayerEid) then
		DebugPrint("ExterminateBaseComponent: 此次调用更新指引频率过高，已暂缓调用 PlayerEid: "..PlayerEid)
		self.HasGuideUpdateRequest[PlayerEid] = true
	else
		self:UpdateNearestMonsterGuide(PlayerEid)
		self:AddGuideTimer_LimitCalls(PlayerEid)
	end
end

function BP_ExterminateBaseComponent_C:OnUnitDeadEvent(MonsterC, KillMineRoleEid, KillMineSkillId, DeathReason)
	if self.Success then
		return
	end
	if not IsValid(MonsterC) then
		return
	end
	if not MonsterC:IsRealMonster() then
		return
	end
	self:AddExterminateKilledNum(1)
	self:CheckTargetNum()
	if MonsterC:IsEliteMonster() then
		return
	end
	for PlayerEid, GuideEid in pairs(self.NowGuideEids) do
		if MonsterC.Eid == GuideEid then
			DebugPrint("ExterminateBaseComponent: 怪物死亡RemoveGuideEid 被Remove的指引点Eid: "..GuideEid.."  Player Eid: "..PlayerEid)
			--self.GameMode.EMGameState:RemoveGuideEid(GuideEid, PlayerEid)
			self:TryUpdateGuidePoint(PlayerEid)
			self:AddGuideTimer_AutoUpdate(PlayerEid)  -- 直接刷新该角色自动间隔计时器
			DebugPrint("ExterminateBaseComponent: OnUnitDeadEvent", MonsterC:GetName(), MonsterC.Eid, PlayerEid)
		end
	end
end

function BP_ExterminateBaseComponent_C:AddExterminateKilledNum(Num)
	self.GameMode.EMGameState:SetExterminateKilledNum(self.GameMode.EMGameState.ExterminateKilledNum + Num)
	if IsStandAlone(self) then
		self.GameMode.EMGameState:OnRep_ExterminateKilledNum()
	end
end


-- function BP_ExterminateBaseComponent_C:GetNearestMonsterEid(Player)
-- 	-- 获取最近的非精英怪 临时方法
-- 	local ResEid = nil
-- 	local MinDis = 999999
-- 	for _, Monster in pairs(self.GameMode.EMGameState.MonsterMap) do
-- 		if IsValid(Monster) and not Monster:IsDead() and Monster:IsRealMonster() and not Monster:IsEliteMonster() then
-- 			local Dis = (Monster:K2_GetActorLocation() - Player:K2_GetActorLocation()):Size()
-- 			if MinDis > Dis then
-- 				ResEid = Monster.Eid
-- 				MinDis = Dis
-- 			end
-- 		end
-- 	end
-- 	if ResEid == nil then
-- 		ResEid = self.GameMode:GetGuideEidBySnapShotData(Player:K2_GetActorLocation())
-- 	end
-- 	return ResEid
-- end

-- 本次优化依赖一个前提：只要调用此函数，默认会清掉当前指引、添加一个新的指引，下面分两种情况讨论：
-- 1. 击杀怪物，立即尝试刷新指引，移除当前指引，并分帧添加一个新的指引。注意，此情形下删除指引和添加指引一定不会是同一只怪物
-- 2. 定期更新指引，判断当前指引怪物和最近怪物是否为同一只，若是则不更新；反之移除当前指引，并分帧添加一个新的指引
-- 因此可得出结论：每次调用此函数时，可以先判断待添加指引和当前指引是否为同一只怪物，若是则不进行任何操作，反之进行移除和添加操作
function BP_ExterminateBaseComponent_C:UpdateNearestMonsterGuide(PlayerEid)
	local Player = Battle(self):GetEntity(PlayerEid)
	if not IsValid(Player) then
		return
	end

	local NowGuideEid = self.NowGuideEids[PlayerEid]					-- 当前指引怪物
	local MonsterEid = self.GameMode:GetNearestMonsterEid(Player)		-- 待添加指引怪物
	if NowGuideEid == MonsterEid then
		DebugPrint("ExterminateBaseComponent: 指引点未发生变化，无需更新 指引点Eid: " .. MonsterEid .. "  Player Eid: " .. PlayerEid)
		return
	end

	if NowGuideEid ~= nil and NowGuideEid > 0 then
		DebugPrint("ExterminateBaseComponent: 更新指引点，移除旧指引 RemoveGuideEid 被Remove的指引点Eid: "..NowGuideEid.."  Player Eid: "..PlayerEid)
		self.GameMode.EMGameState:RemoveGuideEid(NowGuideEid, PlayerEid)
	end

	if MonsterEid ~= nil and MonsterEid > 0 then
		self.NowGuideEids[PlayerEid] = MonsterEid
		self:AddDelayFrameFunc(function()
			if self.NowGuideEids[PlayerEid] == MonsterEid then
				self.GameMode.EMGameState:AddGuideEid(MonsterEid, PlayerEid)
				DebugPrint("ExterminateBaseComponent: 已成功添加指引点 指引点Eid: " .. MonsterEid .. "  Player Eid: " .. PlayerEid)
			else
				DebugPrint("ExterminateBaseComponent: 延迟添加指引点时, self.NowGuideEids已发生变化. 原本准备添加的指引点Eid: " .. MonsterEid .. "  Player Eid: " .. PlayerEid)
			end
		end, 2)
	else
		DebugPrint("ExterminateBaseComponent: Error  歼灭玩法当前场上找不到怪物!")
	end
end

function BP_ExterminateBaseComponent_C:ClearGuideUpdateTimerLogic()
	for PlayerEid, GuideEid in ipairs(self.NowGuideEids) do
		DebugPrint("ExterminateBaseComponent: 结束清理RemoveGuideEid 被Remove的指引点Eid: "..GuideEid.."  Player Eid: "..PlayerEid)
		self.GameMode.EMGameState:RemoveGuideEid(GuideEid, PlayerEid)
	end
	self.NowGuideEids = {}
	self:RemoveTimer(self.GuideTimerHandle_DetectFault)
	for i = 0, self.GameMode:GetPlayerNum() - 1 do
		local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, i)
		if IsValid(Player) then
			self.GameMode.EMGameState:ClearGuideEid(Player.Eid)
			self:RemoveTimer("Handle_AutoUpdate_" .. Player.Eid)
			self:RemoveTimer("Handle_LimitCalls_" .. Player.Eid)
		end
	end
end

function BP_ExterminateBaseComponent_C:CheckTargetNum()
	self.TargetNum = self.TargetNum - 1
	if self.TargetNum <= 0 then
		self.Success = true
		self.GameMode:TriggerGameModeEvent("OnAchieveTarget")
		if self.GameMode:GetNeedCreateEmergencyMonster("Pet") then
			self.GameMode:TriggerSpawnPet()
		end
	end

	if self.IsNormalNumActive then
		self.NormalNum = self.NormalNum - 1
		if self.NormalNum == 0 then
			self.GameMode:TriggerCreateMonsterSpawn(self:RuleToTArray(self.NormalSpawnRule), self.NormalSpawnOnlyRelation)
			self:ResetNormalNum()
		end
	end

	if self.IsEliteNumActive then
		self.EliteNum = self.EliteNum - 1
		if self.EliteNum == 0 then
			self:OnEliteNumClear()
			self.GameMode:TriggerCreateMonsterSpawn(self:RuleToTArray(self.EliteSpawnRule), self.EliteSpawnOnlyRelation)
			self:ResetEliteNum()
		end
	end

	if self.PetSpawnNum then
		self.PetSpawnNum = self.PetSpawnNum - 1
		if self.PetSpawnNum == 0 then
			self.PetSpawnNum = nil
			if self.GameMode:GetNeedCreateEmergencyMonster("Pet") then
				self.GameMode:TriggerSpawnPet()
			end
		end
	end
end

function BP_ExterminateBaseComponent_C:RuleToTArray(Rule)
	local ResTArray = TArray(0)
    if Rule then
		ResTArray:Add(Rule)
    end
    return ResTArray
end

-----------------------------------------------------------------

return BP_ExterminateBaseComponent_C
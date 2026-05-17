
require "UnLua"
require "Const"

local Component = {}

function Component:ComponentReceiveBeginPlay()
end

function Component:InitComponent()
	self.AlertingEid = 0
end

function Component:TickComponent(DeltaSeconds)
	-- 副本的CD更新
	if self.RemainTriggerAlertCD > 0 then
		self.RemainTriggerAlertCD = math.max(0, self.RemainTriggerAlertCD - DeltaSeconds)
	end
	-- 群落的CD由群落自己更新
end

-----------------请求抢占报警位------------------------
function Component:RequestCommonAlertingEid(Monster)
	if not IsValid(Monster) then
		return false
	end
	if self:IsInDungeon() then
		return self:DungeonRequestCommonAlertingEid(Monster)
	end
	if self:IsInRegion() then
		return self:RegionRequestCommonAlertingEid(Monster)
	end
end

function Component:DungeonRequestCommonAlertingEid(Monster)
	if self.AlertingEid ~= 0 then
		return false
	end
	-- 副本条件检测是否可以进入报警状态
	if self:DungeonCheckCanEnterAlert() then
		self.AlertingEid = Monster.Eid
		self.CommonAlarmTarget = Battle(self):GetEntity(Monster.TargetAlerted[1])
		return true
	end
	return false
end

function Component:RegionRequestCommonAlertingEid(Monster)
	if self:RegionCheckCanEnterAlert(Monster) then
		local ClanMgr = self:GetClan(Monster.ClanId)
		ClanMgr.AlertingEid = Monster.Eid
		ClanMgr.CommonAlarmTarget = Battle(self):GetEntity(Monster.TargetAlerted[1])
		return true
	end
	return false
end

function Component:RegionCheckCanEnterAlert(Monster)
	if not Monster.ClanId or Monster.ClanId == 0 then
		return false
	end
	local ClanMgr = self:GetClan(Monster.ClanId)
	if not ClanMgr then 
		return false
	end
	if ClanMgr.AlertingEid ~= 0 then
		return false
	end
	if ClanMgr.InCommonAlert then 
		return false
	end
	if ClanMgr.RemainTriggerAlertCD > 0 then
		return false
	end
	return true
end

-------------------End----------------------------------


-----------------判断是否已经报警------------------------
function Component:CheckIsInCommonAlert(ClanId)
	if self:IsInDungeon() then 
		return self:DungeonCheckIsInCommonAlert()
	end
	if self:IsInRegion() then
		return self:RegionCheckIsInCommonAlert(ClanId)
	end
	return false
end

function Component:RegionCheckIsInCommonAlert(ClanId)
	local ClanMgr = self:GetClan(ClanId)
	if not ClanMgr then 
		return false
	end
	return ClanMgr.InCommonAlert
end

function Component:RegionCheckCanExitAlert(ClanId)
	return self:RegionCheckIsInCommonAlert(ClanId)
end

-------------------End----------------------------------


-----------------------怪物是否可以报警---------------------
-- function Component:LevelCommonAlertDisable(Monster) -- 挪C++了
-- 	if self:IsInDungeon() then 
-- 		return self.CommonAlertDisable
-- 	end
-- 	if self:IsInRegion() then
-- 		if not Monster.ClanId or Monster.ClanId == 0 then
-- 			return false
-- 		end
-- 		local ClanMgr = self:GetClan(Monster.ClanId)
-- 		if not ClanMgr then 
-- 			return false
-- 		end
-- 		return ClanMgr.CommonAlertDisable
-- 	end
-- end
-------------------End----------------------------------

-----------------------重置通用报警的数据---------------------
-- function Component:TryResetCommonAlertingInfo(Monster)
-- 	if self:IsInDungeon() then
-- 		self:DungeonTryResetCommonAlertingInfo(Monster)
-- 		return
-- 	end
-- 	if self:IsInRegion() then
-- 		self:RegionTryResetCommonAlertingInfo(Monster)
-- 		return
-- 	end
-- end

-- function Component:DungeonTryResetCommonAlertingInfo(Monster)
-- 	if Monster.Eid == 0 then
-- 		-- 预加载提前创建的召唤物，在副本结算时会销毁，但他的Eid为0
-- 		DebugPrint("TryResetCommonAlertingInfo 销毁一个Eid为0的Monster", Monster.Eid, Monster.UnitId, Monster:GetName())
-- 		return
-- 	end
-- 	if Monster.Eid == self.AlertingEid then
-- 		self.AlertingEid = 0
-- 		Monster:GetOwnBlackBoardComponent():SetValueAsBool("AlarmTrigger", false)
-- 	end
-- end

-- function Component:RegionTryResetCommonAlertingInfo(Monster)
-- 	if not Monster.ClanId or Monster.ClanId == 0 then
-- 		return
-- 	end
-- 	local ClanMgr = self:GetClan(Monster.ClanId)
-- 	if not ClanMgr then 
-- 		return
-- 	end
-- 	if Monster.Eid == ClanMgr.AlertingEid then
-- 		ClanMgr.AlertingEid = 0
-- 		Monster:GetOwnBlackBoardComponent():SetValueAsBool("AlarmTrigger", false)
-- 	end
-- end
--------------------------------End------------------------------------

function Component:RequestCommonAlarmTargetInfo(Monster)
	if self:IsInDungeon() then
		if self.CommonAlarmTarget ~= nil then
			return self.CommonAlarmTarget
		end
		local MinDistance, ResPlayer = nil, nil
		for _, Player in pairs(self:GetAllPlayer()) do
			local PlayerDistance = UE4.UKismetMathLibrary.Vector_Distance(Player:K2_GetActorLocation(), Monster:K2_GetActorLocation())
			if MinDistance == nil or PlayerDistance < MinDistance then
				MinDistance, ResPlayer = PlayerDistance, Player
			end
		end
		return ResPlayer
	end
	if self:IsInRegion() then
		if not Monster.ClanId or Monster.ClanId == 0 then
			return nil
		end
		local ClanMgr = self:GetClan(Monster.ClanId)
		if not ClanMgr then 
			return nil
		end
		return ClanMgr.CommonAlarmTarget
	end
	return nil
end

--------------------------获取报警机关的数据---------------------------------
function Component:GetAlertMechanismInfo(Monster)
	if self:IsInDungeon() then
		return self:DungeonGetAlertMechanismInfo(Monster)
	end
	if self:IsInRegion() then
		return self:RegionGetAlertMechanismInfo(Monster)
	end
	return nil
end

function Component:DungeonGetAlertMechanismInfo(Monster)
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	if not GameState.MechanismMap:FindRef("AlertMiniGame") then
		return nil
	end
	local AlertMiniGameArray = GameState.MechanismMap:FindRef("AlertMiniGame").Array
	local Res = nil
	local MinDis = 99999

	local MonsterLoc = Monster:K2_GetActorLocation()
	for i,MiniGame in pairs(AlertMiniGameArray) do
		if IsValid(MiniGame) then
			local Dis = (MiniGame:GetMonsterAnimTrans().Translation - MonsterLoc):Size()
			if Dis < MinDis then
				MinDis = Dis
				Res = MiniGame
			end
		end
	end
	return Res
end

function Component:RegionGetAlertMechanismInfo(Monster)
	local Clan = self:GetClan(Monster.ClanId)
	if not Clan then
		return nil
	end
	return Clan:GetAlertMechanism(Monster)
end

function Component:GetClan(ClanManagerId)
	return self.EMGameState.ClanManagerMap:Find(ClanManagerId)
end

----------------------------End-----------------------------------

return Component
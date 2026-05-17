require "UnLua"
require "Const"
local RewardComponent = {}

-- function RewardComponent:CheckRule(Key, RewardId, Table)
-- 	if not Table[Key] then
-- 		return false, 0
-- 	else
-- 		for i,v in pairs(Table[Key]) do
-- 			if v == RewardId then
-- 				return true, i
-- 			end
-- 		end
-- 	end
-- 	return false, 0
-- end
-- --原子操作，往Table添加一条规则
-- function RewardComponent:AtomicAdd(UnitId, RewardId, Table)
-- 	if not Table[UnitId] then
-- 		Table[UnitId] = {RewardId}
-- 	else
--         local Res,idx = self:CheckRule(UnitId, RewardId, Table)
--         if not Res then
-- 		    table.insert(Table[UnitId],RewardId)
--         end
-- 	end
-- end
-- --原子操作，从Table删除一条规则
-- function RewardComponent:AtomicRemove(UnitId, RewardId, Table)
--     local ResInDel, Idx = self:CheckRule(UnitId, RewardId, Table)
--     if ResInDel then
--         table.remove(Table[UnitId],Idx)
--     end
-- end
-- --添加一条掉落规则
-- function RewardComponent:AddSingleRule(UnitId, RewardId)
--     if RewardId == 0 then
--         return
--     end
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     self:AtomicAdd(UnitId, RewardId, GameMode.ExtraReward)
--     self:AtomicRemove(UnitId, RewardId, GameMode.DelReward)
-- end
-- --删除一条掉落规则
-- function RewardComponent:DelSingleRule(UnitId, RewardId)
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     if not (RewardId == 0) then
--         self:AtomicAdd(UnitId, RewardId, GameMode.DelReward)
--     else
--         GameMode.DelReward[UnitId] = {}
--         for i,v in pairs(GameMode.ExtraReward[UnitId]) do
--             table.insert(GameMode.DelReward[UnitId],v)
--         end
--     end
-- end

-- function RewardComponent:InitDropRule(UnitId, RewardId)
--     if RewardId == 0 then
--         return
--     end
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     self:AtomicAdd(UnitId, RewardId, GameMode.ExtraReward)
--     self:AtomicAdd(UnitId, nil, GameMode.DelReward)
-- end

-- function RewardComponent:AddDropRule(UnitId, RewardId)
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     if UnitId == 0 then
--         for i,v in pairs(GameMode.ExtraReward) do
--             self:AddSingleRule(i, RewardId)
--         end
--     else
--         self:AddSingleRule(UnitId, RewardId)
--     end
-- end

-- function RewardComponent:DelDropRule(UnitId, RewardId)
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     if UnitId == 0 then
--         for i,v in pairs(GameMode.ExtraReward) do
--             self:DelSingleRule(i, RewardId)
--         end
--     else
--         self:DelSingleRule(UnitId, RewardId)
--     end
-- end

-- function RewardComponent:GetDropRule(UnitId)
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
-- 	local Tmp = {}
--     local Result = {}
--     if not GameMode.ExtraReward[UnitId] then
--         return nil
--     end
--     --处理本体规则
--     if GameMode.ExtraReward[UnitId] then
--         for i,v in pairs(GameMode.ExtraReward[UnitId]) do
--             Tmp[v] = 1
--         end
--     end
--     --标记待删除规则
--     if GameMode.DelReward[UnitId] then
--         for i,v in pairs(GameMode.DelReward[UnitId]) do
--             if Tmp[v] ~= nil then
--                 Tmp[v] = Tmp[v] + 1
--             end
--         end
--     end
--     --创建结果
--     for i,v in pairs(Tmp) do
--         if v == 1 and i ~= 0 then
--             table.insert(Result,i)
--         end
--     end
--     return Result
-- end

--生成无需掉落表现的掉落物
-- function RewardComponent:TriggerReward(RewardId)
-- 	local Rewards = {
-- 		RewardId
-- 	}
-- 	self:TriggerGenerateReward(Rewards, CommonConst.RewardReason.GameMode)
-- end

--生成有掉落表现的掉落物，表现为随机弹射(用于怪物动画通知)
function RewardComponent:TriggerRewardWithTransform(RewardId, Transform, MonsterEid)
    local RewardData = DataMgr.Reward[RewardId]
    if not RewardData or not RewardData.IsCombatResource then
        return
    end
	local Rewards = {
		RewardId
	}
    -- local ExtraInfo = {UniqueSign = MonsterEid.."_"..UGameplayStatics.GetRealTimeSeconds(self)}
    -- @SnowMoon 只允许生成战斗奖励
	self:AddCacheBattleReward(Rewards, CommonConst.RewardReason.MonsterAnim, Transform)
end

return RewardComponent
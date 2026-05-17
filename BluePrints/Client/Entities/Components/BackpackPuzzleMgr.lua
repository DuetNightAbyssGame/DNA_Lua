local Component = {}
local BackpackPuzzleController = require "BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameController"
local BagGameModel = require "BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel"

function Component:EnterWorld()
	BackpackPuzzleController:Init()
    self:InitReddot()
end

function Component:LeaveWorld()
	BackpackPuzzleController:Destory()
end

--region 红点
function Component:InitReddot()
    ReddotManager.AddNodeEx("BagGameAward",nil,Const.ReddotCacheType.UserCache)
    ReddotManager.AddNodeEx("BagGameNew",nil,Const.ReddotCacheType.UserCache)
end
--- 服务端 BackpackPuzzles 属性变更回调
function Component:_OnPropChangeBackpackPuzzles(keys)
	self:_TryRefreshBagGameAwardReddot()
	self:_TryRefreshBagGameNewReddot()
end

--- 增量刷新 Award 红点：比对 CacheDetail 与实际可领取状态
function Component:_TryRefreshBagGameAwardReddot()
	local ReddotNode = ReddotManager.GetTreeNode("BagGameAward")
	if not ReddotNode then return end
	local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("BagGameAward")
	if not CacheDetail then return end

	local LevelsInfo = DataMgr.BackpackPuzzleLevel
	if not LevelsInfo then return end

	for LevelId, _ in pairs(LevelsInfo) do
		local bHasReward = BagGameModel:HasRewardToGet(LevelId)
		local bCached = CacheDetail[LevelId] == true

		if bHasReward and not bCached then
			ReddotManager.IncreaseLeafNodeCount("BagGameAward", 1, {LevelId = LevelId})
		elseif not bHasReward and bCached then
			ReddotManager.DecreaseLeafNodeCount("BagGameAward", 1, {LevelId = LevelId})
		end
	end
end

--- 增量刷新 New 红点：检测新解锁关卡
--- 规则：前一关≥1星已通过 + 当前关0星未首通 + 无 New 缓存 → 标记 New
function Component:_TryRefreshBagGameNewReddot()
	local ReddotNode = ReddotManager.GetTreeNode("BagGameNew")
	if not ReddotNode then return end
	local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("BagGameNew")
	if not CacheDetail then return end

	local LevelsInfo = BagGameModel:GetLevelsInfo()
	if not LevelsInfo or #LevelsInfo == 0 then return end

	for i, LevelInfo in ipairs(LevelsInfo) do
		local LevelId = LevelInfo.LevelId
		-- 跳过已有 New 标记的关卡
		if CacheDetail[LevelId] ~= nil then
			goto continue
		end
		-- 第1关永远解锁，无需 New
		if i == 1 then
			goto continue
		end
		-- 检查前一关是否至少1星通过
		local PrevLevelId = LevelsInfo[i - 1].LevelId
		local PrevStarCount = BagGameModel:GetPlayerStarCount(PrevLevelId)
		if PrevStarCount > 0 then
			-- 当前关已解锁，检查是否未首通
			local CurStarCount = BagGameModel:GetPlayerStarCount(LevelId)
			if CurStarCount == 0 then
				ReddotManager.IncreaseLeafNodeCount("BagGameNew", 1, {LevelId = LevelId})
			end
		end
		::continue::
	end
end
--endregion

-- 领取某个关卡某一积分段奖励
function Component:BackpackPuzzleGetScoreReward(BackpackPuzzleId, RewardKeyId, CallBack)
	self.logger.info("BackpackPuzzleGetScoreReward", BackpackPuzzleId, RewardKeyId)
    local function Cb(ErrCode, Ret)
        if CallBack then
            CallBack(ErrCode, Ret)
        end
        DebugPrint("BackpackPuzzleGetScoreReward",ErrorCode:Name(ErrCode))
    end
	self:CallServer("BackpackPuzzleGetScoreReward", Cb, BackpackPuzzleId, RewardKeyId) 
end

-- 领取某一关卡所有积分奖励
function Component:BackpackPuzzleGetAllScoreReward(BackpackPuzzleId, CallBack)
	self.logger.info("BackpackPuzzleGetAllScoreReward", BackpackPuzzleId)
    local function Cb(ErrCode, Ret)
        if CallBack then
            CallBack(ErrCode, Ret)
        end
        DebugPrint("BackpackPuzzleGetAllScoreReward",ErrorCode:Name(ErrCode))
    end
	self:CallServer("BackpackPuzzleGetAllScoreReward", Cb, BackpackPuzzleId) 
end

-- 完成一次背包整理关卡
function Component:BackpackPuzzleFinishGame(BackpackPuzzleId, Score, CallBack)
	self.logger.info("BackpackPuzzleFinishGame", BackpackPuzzleId, Score)
    local function Cb(ErrCode, Ret)
        if CallBack then
            CallBack(ErrCode, Ret)
        end
        DebugPrint("BackpackPuzzleFinishGame",ErrorCode:Name(ErrCode))
    end
	self:CallServer("BackpackPuzzleFinishGame", Cb, BackpackPuzzleId, Score) 
end

return Component
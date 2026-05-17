local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local NormalRewardReddotName = "JJGameTask_Normal_Reddot"
local ChallengeRewardReddotName = "JJGameTask_Challenge_Reddot"
local NormalTaskNewReddotName = "JJGameTask_Normal_New"
local ChallengeTaskNewReddotName = "JJGameTask_Challenge_New"
local ReddotTreeNode_JJGame = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_JJGame:_Judge(ActivityID)
    local Avatar = GWorld:GetAvatar()
	if not Avatar then return false end
	local MidTermGoals = Avatar.MidTermGoals[ActivityID]
	if not MidTermGoals then return false end
	local TaskFinishCounts = MidTermGoals.TaskFinishCount or {}
	local EventEndTime = DataMgr.EventMain[ActivityID].EventEndTime
    local RewardEndTime = DataMgr.EventMain[ActivityID].RewardEndTime

	if TimeUtils.NowTime() > RewardEndTime then
		self:ClearJJGameReddotWhenActivityEnd()
		return false
	end
	if TimeUtils.NowTime() > EventEndTime then
		if CommonUtils.Size(MidTermGoals.ScoresRewards) > 0 then
			return true
		else
			return false
		end
	end
	if CommonUtils.Size(MidTermGoals.ScoresRewards) > 0 then return true end
	
	-- 检查左侧奖励是否全部领取完毕
	local allRewardsClaimed = Avatar:CheckIsChallengeRewardAllClaimed()
	-- 遍历所有任务，区分常规任务和挑战任务
	for TaskId, Task in pairs(MidTermGoals.Tasks) do
		local TaskData = DataMgr.MidTermTask[TaskId]

		-- 常规任务：始终检查红点（TaskType = 1, 2, 3）
		-- 挑战任务：只有在左侧奖励未全部领完时才检查红点（TaskType = 4）
		local isAchievementTask = TaskData.TaskType == 4
		
		-- 如果是挑战任务且左侧奖励全部领完，跳过此任务
		if isAchievementTask and allRewardsClaimed then
			goto continue
		end
		
		if TaskFinishCounts[TaskId] and TaskFinishCounts[TaskId] > 0 then
			return true
		end
		if Task.Progress >= Task.Target and Task.RewardsGot == false and TaskData.EnableDay <= self:CalEventDay() then
			return true
		end
		
		::continue::
	end
	self:ClearJJGameReddot()
	return false
end

function ReddotTreeNode_JJGame:CalEventDay()
    local MidTermGoalEventId = DataMgr.MidTermGoalConstant["MidTermGoalEventId"].ConstantValue
	local EventStartTime = DataMgr.EventMain[MidTermGoalEventId].EventStartTime
	local currentTime = TimeUtils.NowTime()
	local intervalDays = TimeUtils.GetIntervalDay(EventStartTime, currentTime)
	local calculatedEventDay = intervalDays + 1
	return calculatedEventDay
end

function ReddotTreeNode_JJGame:OnInitNodeCache(NodeCache)
    ReddotTreeNode_JJGame.Super.OnInitNodeCache(self, NodeCache)
    ReddotManager.AddListenerEx("Acti_JJGame", self, self.OnJJGameReddotChange)
	--校验一遍红点，如果 "JJGameTask_Normal_Reddot" / "JJGameTask_Challenge_Reddot"红点计数都为0，则Acti_JJGame红点计数也要清0
	local NormalRewardNode = ReddotManager.GetTreeNode(NormalRewardReddotName)
	local ChallengeRewardNode = ReddotManager.GetTreeNode(ChallengeRewardReddotName)
	local NormalRewardCount = NormalRewardNode and NormalRewardNode.Count or 0
	local ChallengeRewardCount = ChallengeRewardNode and ChallengeRewardNode.Count or 0
	if NormalRewardCount == 0 and ChallengeRewardCount == 0 then
		-- 如果两个子节点计数都为0，触发重新判断，确保父节点计数也为0
		if self.Count and self.Count > 0 then
			self:ClearJJGameReddot()
		end
	end
end

function ReddotTreeNode_JJGame:OnDisposeNode()
    ReddotManager.RemoveListener("Acti_JJGame", self)
end

function ReddotTreeNode_JJGame:OnJJGameReddotChange(Count,RdType,RdName)
    if Count ~= 0 then return end
    self:ClearJJGameReddotWhenActivityEnd()
end

function ReddotTreeNode_JJGame:ClearJJGameReddotWhenActivityEnd()
    self.MidTermGoalEventId = DataMgr.MidTermGoalConstant["MidTermGoalEventId"].ConstantValue
    local EventEndTime = DataMgr.EventMain[self.MidTermGoalEventId].RewardEndTime
    if TimeUtils.NowTime() > EventEndTime then
        self:ClearChallengeTaskNewReddot()
        self:ClearChallengeRewardReddot()
        self:ClearNormalTaskNewReddot()
        self:ClearNormalRewardReddot()
    end
end

function ReddotTreeNode_JJGame:ClearChallengeTaskNewReddot()
	if not ReddotManager.GetTreeNode(ChallengeTaskNewReddotName) then
        ReddotManager.AddNodeEx(ChallengeTaskNewReddotName,nil,Const.ReddotCacheType.UserCache)
    end
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeTaskNewReddotName)
    if CacheData then
        for key, _ in pairs(CacheData) do
            CacheData[key] = nil
        end
		ReddotManager.ClearLeafNodeCount(ChallengeTaskNewReddotName)
    end
end

function ReddotTreeNode_JJGame:ClearChallengeRewardReddot()
	if not ReddotManager.GetTreeNode(ChallengeRewardReddotName) then
        ReddotManager.AddNodeEx(ChallengeRewardReddotName,nil,Const.ReddotCacheType.UserCache)
    end
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeRewardReddotName)
    if CacheData then
        for key, _ in pairs(CacheData) do
            CacheData[key] = nil
        end
		ReddotManager.ClearLeafNodeCount(ChallengeRewardReddotName)
    end
end

function ReddotTreeNode_JJGame:ClearNormalTaskNewReddot()
	if not ReddotManager.GetTreeNode(NormalTaskNewReddotName) then
        ReddotManager.AddNodeEx(NormalTaskNewReddotName,nil,Const.ReddotCacheType.UserCache)
    end
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalTaskNewReddotName)
    if CacheData then
        for key, _ in pairs(CacheData) do
            CacheData[key] = nil
        end
		ReddotManager.ClearLeafNodeCount(NormalTaskNewReddotName)
    end
end

function ReddotTreeNode_JJGame:ClearNormalRewardReddot()
	if not ReddotManager.GetTreeNode(NormalRewardReddotName) then
        ReddotManager.AddNodeEx(NormalRewardReddotName,nil,Const.ReddotCacheType.UserCache)
    end
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalRewardReddotName)
    if CacheData then
        for key, _ in pairs(CacheData) do
            CacheData[key] = nil
        end
		ReddotManager.ClearLeafNodeCount(NormalRewardReddotName)
    end
end

function ReddotTreeNode_JJGame:ClearJJGameReddot()
    if not ReddotManager.GetTreeNode("Acti_JJGame") then
        ReddotManager.AddNodeEx("Acti_JJGame",nil,Const.ReddotCacheType.UserCache)
    end
    local CacheData = ReddotManager.GetLeafNodeCacheDetail("Acti_JJGame")
    if CacheData then
        for key, _ in pairs(CacheData) do
            CacheData[key] = nil
        end
		ReddotManager.ClearLeafNodeCount("Acti_JJGame")
    end
end

return ReddotTreeNode_JJGame
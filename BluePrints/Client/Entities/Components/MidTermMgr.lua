local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

local Component = {}
local NormalRewardReddotName = "JJGameTask_Normal_Reddot"
local ChallengeRewardReddotName = "JJGameTask_Challenge_Reddot"
local MidTermGoalEventId = DataMgr.MidTermGoalConstant["MidTermGoalEventId"].ConstantValue

local TaskType = {
    Daily = {1,2},
    Cycle = 3,
    Achievement = 4,
}

function Component:MidTermGetScoresRewards(InCallBack)
	self.logger.info("MidTermGetScoresRewards")
    local function Cb(ErrCode,Ret)
        DebugPrint("MidTermGetScoresRewards",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode,Ret)
        end
    end
	self:CallServer("MidTermGetScoresRewards", Cb) 
end

function Component:MidTermGetAllAchvScores(InCallBack)
	self.logger.info("MidTermGetAllAchvScores")
    local function Cb(ErrCode,Ret)
        DebugPrint("MidTermGetAllAchvScores",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode,Ret)
        end
    end
	self:CallServer("MidTermGetAllAchvScores", Cb)
end

function Component:MidTermGetAllNormalScores(InCallBack)
	self.logger.info("MidTermGetAllNormalScores")
    local function Cb(ErrCode,Ret)
        DebugPrint("MidTermGetAllNormalScores",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode,Ret)
        end
    end
	self:CallServer("MidTermGetAllNormalScores", Cb)
end

function Component:MidTermGetProgressReward(InCallBack)
	self.logger.info("MidTermGetProgressReward")
    local function Cb(ErrCode,Ret)
        DebugPrint("MidTermGetProgressReward",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode,Ret)
        end
    end
	self:CallServer("MidTermGetProgressReward", Cb)
end

function Component:MidTermGetTaskReward(TaskId,InCallBack)
    self.logger.info("MidTermGetTaskReward", TaskId)
    local function Cb(ErrCode)
        DebugPrint("MidTermGetTaskReward",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode)
        end
    end
	self:CallServer("MidTermGetTaskReward", Cb, TaskId) 
end

function Component:NotifyMidTermTaskComplete(TaskId)
    self.logger.info("NotifyMidTermTaskComplete", TaskId)
    EventManager:FireEvent(EventID.OnMidTermTaskComplete, TaskId)
    -- 更新红点节点计数
    self:UpdateJJGameReddot(TaskId)
end

function Component:NotifyMidTermTaskProgressChange(TaskId, Progress)
    self.logger.info("NotifyMidTermTaskProgressChange", TaskId, Progress)
    EventManager:FireEvent(EventID.OnMidTermTaskProgressChange, TaskId, Progress)
end

function Component:UpdateJJGameReddot(TaskId)
    -- 检查任务类型并添加相应的奖励红点
    if not ActivityUtils.CheckEventIsOpen(MidTermGoalEventId,nil,true) then
        return
    end
    local Task = self.MidTermGoals[MidTermGoalEventId].Tasks[TaskId]
    if Task then
        local TaskData = DataMgr.MidTermTask[Task.UniqueID]
        if TaskData and TaskData.TaskType == TaskType.Achievement then
            -- 挑战任务完成，添加挑战任务奖励红点
            local MidTermGoalEventId = DataMgr.MidTermGoalConstant["MidTermGoalEventId"].ConstantValue
            local EventStartTime = DataMgr.EventMain[MidTermGoalEventId].EventStartTime
            local currentTime = TimeUtils.NowTime()
            local intervalDays = TimeUtils.GetIntervalDay(EventStartTime, currentTime)
            local calculatedEventDay = intervalDays + 1
            if TaskData.EnableDay <= calculatedEventDay then -- 已开放任务才添加红点
                self:TryIncreaceChallengeTaskRewardReddot(TaskId)
            end
        else
            -- 常规任务完成，添加常规任务奖励红点
            local EventEndTime = DataMgr.EventMain[MidTermGoalEventId].EventEndTime
            if TimeUtils.NowTime() < EventEndTime then
                self:TryIncreaceNormalRewardReddot(TaskId)
            end
        end
    end
end

function Component:TryIncreaceChallengeTaskRewardReddot(TaskId)
    -- 如果左侧奖励全部领完，不显示红点
    if self:CheckIsChallengeRewardAllClaimed() then
        return
    end
    
    local CacheKey = ChallengeRewardReddotName..TaskId
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeRewardReddotName)
    if CacheData and CacheData[CacheKey] == nil then
        CacheData[CacheKey] = true
        ReddotManager.IncreaseLeafNodeCount(ChallengeRewardReddotName)
    end
end

function Component:CheckIsChallengeRewardAllClaimed()  
    local AchievementPrize = DataMgr.AchievementPrize
    local MidTermGoals = self.MidTermGoals[MidTermGoalEventId] or {}
    local MidTermAchvScores = MidTermGoals.AchvScores or 0
    local MidTermAchvProgressRewarded = MidTermGoals.AchvProgressRewarded or {}
    
    local maxCount = 0
    for Count, _ in pairs(AchievementPrize) do
        if Count > maxCount then
            maxCount = Count
        end
    end
    if MidTermAchvScores < maxCount then
        return false
    end
    for Count, _ in pairs(AchievementPrize) do
        if MidTermAchvScores >= Count then
            if MidTermAchvProgressRewarded[Count] ~= 1 then
                return false
            end
        end
    end
    -- 所有奖励档位都已解锁且都已领取，返回 true（不再更新红点）
    return true
end

function Component:TryIncreaceNormalRewardReddot(TaskId)
    local CacheKey = NormalRewardReddotName..TaskId
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalRewardReddotName)
    if CacheData and CacheData[CacheKey] == nil then
        CacheData[CacheKey] = true
        ReddotManager.IncreaseLeafNodeCount(NormalRewardReddotName)
    end
end

return Component

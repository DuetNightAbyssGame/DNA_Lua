local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties

local MidTermGoal = Class("MidTermGoal", CustomTypes.CustomAttr)
    MidTermGoal.__Props__ = {
        -- 活动id
        EventId = prop.prop("Int", "client save"),
        -- 任务
        Tasks = prop.prop("TargetCounter.TargetCounterDict", "client save"),
        -- 任务完成数
        TaskFinishCount = prop.prop("Int2IntDict", "client save"),
        -- 奖池积分
        Scores = prop.prop("Int", "client save", 0),
        -- 积分奖励
        ScoresRewards = prop.prop("Int2IntDict", "client save"),
        -- 成就积分
        AchvScores = prop.prop("Int", "client save", 0),
	    -- 成就进度奖励领取{[pt] = 1}
	    AchvProgressRewarded = prop.prop("Int2IntDict", "client save"),

    }

    function MidTermGoal:Init(EventId)
        self.EventId = EventId
    end

    function MidTermGoal:GetMidTask(TaskId)
        return self.Tasks[TaskId]
    end

    function MidTermGoal:CreateMidTask(TaskId, TaskInfo)
        self.Tasks:NewTargetCounter(TaskId, TaskInfo)
    end

    function MidTermGoal:DeleteMidTask(TaskId)
        self.Tasks[TaskId] = nil
    end

    function MidTermGoal:SetMidTask(TaskId, Task)
        self.Tasks[TaskId] = Task
    end

    function MidTermGoal:AddFinishCount(TaskId, Count)
        self.TaskFinishCount[TaskId] = (self.TaskFinishCount[TaskId] or 0) + Count
    end

    function MidTermGoal:SetFinishCount(TaskId, Count)
        self.TaskFinishCount[TaskId] = Count
    end

    function MidTermGoal:GetFinishCount(TaskId)
        return self.TaskFinishCount[TaskId]
    end

    function MidTermGoal:HasSettleRewardToGet()
        return not self.ScoresRewards:IsEmpty()
    end

    function MidTermGoal:SetTaskRewardGot(TaskId)
        self.Tasks[TaskId].RewardsGot = true
    end

    FormatProperties(MidTermGoal)

local MidTermGoalDict = Class("MidTermGoalDict", CustomTypes.CustomDict)
    MidTermGoalDict.KeyType = BaseTypes.Int
    MidTermGoalDict.ValueType = MidTermGoal

    function MidTermGoalDict:GetMidTermGoal(EventId)
        return self[EventId]
    end

    function MidTermGoalDict:NewMidTermGoal(EventId)
        return MidTermGoal(EventId)
    end

    function MidTermGoalDict:GetNewMidTermGoal(EventId)
        if not self[EventId] then
            self[EventId] = self:NewMidTermGoal(EventId)
        end

        return self[EventId]
    end

return {
    MidTermGoal = MidTermGoal,
    MidTermGoalDict = MidTermGoalDict,
}
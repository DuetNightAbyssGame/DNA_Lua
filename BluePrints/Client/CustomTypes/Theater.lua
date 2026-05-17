local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties

local Theater = Class("Theater", CustomTypes.CustomAttr)
    Theater.__Props__ = {
        -- 剧场活动id
        EventId = prop.prop("Int", "client save"),
        -- 剧场任务
        Tasks = prop.prop("TargetCounter.TargetCounterDict", "client save"),
        -- 高级奖励领取次数
        RewardTimes = prop.prop("Int", "client save"),
        PerformRewardRecord = prop.prop("IntSet", ""),
        -- 奖励邮件领取
        DonatePrizeMailsGet = prop.prop("Int2IntDict", "client save"),
    }

    function Theater:Init(EventId)
        self.EventId = EventId
        self:InitTheaterTasks()
    end

    function Theater:InitTheaterTasks()
        for TaskId, TaskInfo in pairs(DataMgr.TheaterTask) do
            self.Tasks:NewTargetCounter(TaskId, TaskInfo)
        end
    end

    function Theater:ResetTask(TaskId)
        if not self.Tasks[TaskId] then
            return
        end
        self.Tasks[TaskId]:Reset()
    end

    function Theater:GetTask(TaskId)
        return self.Tasks[TaskId]
    end

    function Theater:RefreshProgress(TaskId, TargetId, UniqueAttr, Count)
        self.Tasks[TaskId]:TargetRefreshProgress(TargetId, UniqueAttr, Count)
    end

    function Theater:SetRewardsGot(TaskId)
        self.Tasks[TaskId].RewardsGot = true
    end

    function Theater:IsPerformRewardGot(StartTime)
        return self.PerformRewardRecord:HasElement(StartTime)
    end

    function Theater:SetPerformRewardGot(StartTime)
        self.PerformRewardRecord:AddElement(StartTime)
    end

    function Theater:IsMailRewarded(MailId)
        return self.DonatePrizeMailsGet[MailId] == 1
    end

    function Theater:SetMailRewarded(MailId)
        self.DonatePrizeMailsGet[MailId] = 1
    end

    FormatProperties(Theater)

local TheaterDict = Class("TheaterDict", CustomTypes.CustomDict)
    TheaterDict.KeyType = BaseTypes.Int
    TheaterDict.ValueType = Theater

    function TheaterDict:GetTheater(EventId)
        return self[EventId]
    end

    function TheaterDict:NewTheater(EventId)
        return Theater(EventId)
    end

    function TheaterDict:GetNewTheater(EventId)
        if not self[EventId] then
            self[EventId] = self:NewTheater(EventId)
        end

        return self[EventId]
    end

return {
    Theater = Theater,
    TheaterDict = TheaterDict,
}
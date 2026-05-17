local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local TargetCounter = require "BluePrints.Client.CustomTypes.TargetCounter"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties
local TimeUtils
if GWorld:IsSkynetServer() then
	TimeUtils = require "src.utils.TimeUtils"
else
	TimeUtils = require "Utils.TimeUtils"
end

---@class RegionReputation
local RegionReputation = Class("RegionReputation",CustomTypes.CustomAttr)
RegionReputation.__Props__ = {
    --声望Id
    ReputationId = prop.prop("Int","client save"),
    --当周的声望积分
    ReputationScore = prop.prop("Int","client save"),
    --循环副本类任务，单一和阶段，阶段自行计算
    RecurringQuestList = prop.prop("TargetCounter.TargetCounterDict", "client save"),
    --循环副本类任务状态,Id:State, State:0-待接取，1-已接取（进行中,进行中+目标已达成 = 待领取积分），2-已完成（已领取积分）
    RecurringQuestState = prop.prop("Int2IntDict","client save"),
    --循环副本类任务池
    RecurringQuestPool = prop.prop("Int2IntListDict", "save"),
    --循环副本类任务 id 和 开始时间
    RecurringQuestIdAndStartTime = prop.prop("IntList", "client save",{-1,0}),
    -- --历史循环副本类任务记录，未接取的不记录
    -- HistoryRecurringQuestList = prop.prop("Int2IntDict", "save"),
    --委托类任务,Id:State, State:0-待接取，1-已接取（进行中），2-已完成
    EntrustQuestState = prop.prop("Int2IntDict","client save"),
    --当前声望等级
    ReputationLevel = prop.prop("Int","client save",0),
    --当前声望经验
    ReputationExp = prop.prop("Int","client save",0),
    --已领取奖励的等级列表
    LevelRewardGotList = prop.prop("Int2IntDict","client save",{}),
    --上次刷新时间,循环副本
    LastRefreshTime1 = prop.prop("Int","client save",0),
    --上次刷新时间，委托任务
    LastRefreshTime2 = prop.prop("Int","client save",0),
    --委托任务,剩余刷新次数
    EntrustQuestRemainRefreshTimes = prop.prop("Int","client save",0),
    --周积分上限
    WeekLimit = prop.getter("Data","WeekLimit"),
}

function RegionReputation:Init(ReputationId)
    if not ReputationId then
        return
    end
    if not DataMgr.RegionReputation[ReputationId] then
        return
    end
    self.ReputationId = ReputationId
    self:SetRefreshTime(ReputationId)
    self:ResetEntrustQuestRemainRefreshTimes()
end

function RegionReputation:Data()
    return DataMgr.RegionReputation[self.ReputationId]
end

function RegionReputation:SetRefreshTime(ReputationId)
    local ReputationInfo = DataMgr.RegionReputation[ReputationId]
    local RefreshTime1 = ReputationInfo.RefreshTime1
    local RefreshTime2 = ReputationInfo.RefreshTime2
    local RefreshBeginTime = TimeUtils.EastEightToLocalTimestamp(ReputationInfo.RefreshBeginTime)
    local function GetRefreshStartTime(Type,StartTime)
        if Type == 'DAY' then
            local year, month, day, hour, min, sec = TimeUtils.TimestampToData(StartTime)
            local refresh_hms = CommonConst.GAME_REFRESH_HMS
            return TimeUtils.DataToTimestamp(year, month, day, table.unpack(refresh_hms))
        elseif Type == 'WEEK' then
            StartTime = StartTime - CommonConst.SECOND_IN_WEEKDAY
            local refresh_hms = CommonConst.GAME_REFRESH_HMS
            return TimeUtils.NextWeeklyRefreshTime(StartTime,refresh_hms)
        else
            return StartTime
        end
    end
    if RefreshTime1 then
        for key,value in pairs(RefreshTime1) do
            self.LastRefreshTime1 = GetRefreshStartTime(key,RefreshBeginTime)
        end
    end
    if RefreshTime2 then
        for key,value in pairs(RefreshTime2) do
            self.LastRefreshTime2 = GetRefreshStartTime(key,RefreshBeginTime)
        end
    end
end

function RegionReputation:ResetEntrustQuestRemainRefreshTimes()
    local Data = self:Data()
    if Data and Data.ManualRefreshNumber then
        self.EntrustQuestRemainRefreshTimes = Data.ManualRefreshNumber
    else
        self.EntrustQuestRemainRefreshTimes = 0
    end
end

function RegionReputation:SetRecurringQuestIdAndStartTime(QuestId,StartTime)
    self.RecurringQuestIdAndStartTime[1] = QuestId
    self.RecurringQuestIdAndStartTime[2] = StartTime
end

function RegionReputation:ClearRecurringQuestIdAndStartTime()
    self.RecurringQuestIdAndStartTime[1] = -1
    self.RecurringQuestIdAndStartTime[2] = 0
end
FormatProperties(RegionReputation)

---@class RegionReputationDict
local RegionReputationDict = Class("RegionReputationDict",CustomTypes.CustomDict)
    RegionReputationDict.KeyType = BaseTypes.Int
    RegionReputationDict.ValueType = RegionReputation

    function RegionReputationDict:NewRegionReputation(ReputationId)
        return RegionReputation(ReputationId)
    end

    ---@return RegionReputation
    function RegionReputationDict:GetRegionReputation(ReputationId)
        if self[ReputationId] == nil then
            self[ReputationId] = self:NewRegionReputation(ReputationId)
        end
        return self[ReputationId]
    end

return {
    RegionReputation = RegionReputation,
    RegionReputationDict = RegionReputationDict,
}

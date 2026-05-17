require "UnLua"


---@type EastSeasonQuestUtils
local M = {}

function M:GetQuestPhaseIdByTabId(EventId, TabId)
    for _, phaseConfig in pairs(DataMgr.CommonQuestPhase) do
        if phaseConfig.Index == TabId and phaseConfig.EventId == EventId then
            return phaseConfig.QuestPhaseId
        end
    end
    return nil
end

-- 判断当前这个阶段完成了多少个任务和总任务有多少个
function M:GetQuestPhaseInfo(EventId, QuestPhaseId)
    local Avatar = GWorld:GetAvatar()
    local TotalQuestCount = 0
    local CompletedQuestCount = 0
    if Avatar then
        local CommonQuestActivity = Avatar.CommonQuestActivity[EventId]
        if CommonQuestActivity == nil then
            return 0, 0
        end
        -- 遍历这个CommonQuestActivity,如果Progress >= Target，则完成任务,并且记录总任务数量，最后返回这两个值
        local QuestIds = DataMgr.QuestPhaseId2QuestId[QuestPhaseId]
        for _, QuestId in pairs(QuestIds) do
            if CommonQuestActivity[QuestId] then
                if CommonQuestActivity[QuestId].Progress >= CommonQuestActivity[QuestId].Target then
                    CompletedQuestCount = CompletedQuestCount + 1
                end
                TotalQuestCount = TotalQuestCount + 1
            end
        end
        return CompletedQuestCount, TotalQuestCount
    end
end

-- 判断这个阶段是否有可以领取的奖励（红点）
function M:IsQuestPhaseCanGetReward(EventId, QuestPhaseId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local CommonQuestActivity = Avatar.CommonQuestActivity[EventId]
        local QuestIds = DataMgr.QuestPhaseId2QuestId[QuestPhaseId]
        if CommonQuestActivity == nil or QuestIds == nil then
            return false
        end
        for _, QuestId in pairs(QuestIds) do
            if CommonQuestActivity[QuestId] then
                if CommonQuestActivity[QuestId].Progress >= CommonQuestActivity[QuestId].Target and CommonQuestActivity[QuestId].RewardsGot == false then
                    return true
                end
            end
        end
        return false
    end
end

-- 判断这个阶段一共领取了多少钻石
function M:GetQuestPhaseGetDiamond(EventId, QuestPhaseId)
    local Avatar = GWorld:GetAvatar()
    local GetDiamond = 0
    if Avatar then
        local CommonQuestActivity = Avatar.CommonQuestActivity[EventId]
        local QuestIds = DataMgr.QuestPhaseId2QuestId[QuestPhaseId]
        if CommonQuestActivity == nil or QuestIds == nil then
            return 0
        end
        for _, QuestId in pairs(QuestIds) do
            if CommonQuestActivity[QuestId] then
                if CommonQuestActivity[QuestId].RewardsGot then
                    local RewardId = DataMgr.CommonQuestDetail[QuestId].QuestReward
                    local RewardInfo = DataMgr.Reward[RewardId[1]]
                    if RewardInfo then
                        local Ids = RewardInfo.Id or {}
                        local RewardCount = RewardInfo.Count or {}
                        for i = 1, #Ids do
                            local ItemId = Ids[i]
                            if ItemId == CommonConst.Coins.Coin1 then
                                GetDiamond = GetDiamond + RewardUtils:GetCount(RewardCount[i])
                            end
                        end
                    end
                end
            end
        end
    end
    return GetDiamond
end

-- 判断这个阶段一共可以领取了多少钻石（不用管有无完成）
function M:GetQuestPhaseCanGetDiamond(EventId, QuestPhaseId)
    local Avatar = GWorld:GetAvatar()
    local GetDiamond = 0
    if Avatar then
        local CommonQuestActivity = Avatar.CommonQuestActivity[EventId]
        local QuestIds = DataMgr.QuestPhaseId2QuestId[QuestPhaseId]
        if CommonQuestActivity == nil or QuestIds == nil then
            return 0
        end
        for _, QuestId in pairs(QuestIds) do
            if CommonQuestActivity[QuestId] then
                local RewardId = DataMgr.CommonQuestDetail[QuestId].QuestReward
                local RewardInfo = DataMgr.Reward[RewardId[1]]
                if RewardInfo then
                    local Ids = RewardInfo.Id or {}
                    local RewardCount = RewardInfo.Count or {}
                    for i = 1, #Ids do
                        local ItemId = Ids[i]
                        if ItemId == CommonConst.Coins.Coin1 then
                            GetDiamond = GetDiamond + RewardUtils:GetCount(RewardCount[i])
                        end
                    end
                end
            end
        end
    end
    return GetDiamond
end

-- 判断这个阶段是不是已经全部领取完了
function M:IsQuestPhaseAllGetReward(EventId, QuestPhaseId)
    local allcount = self:GetQuestPhaseCanGetDiamond(EventId, QuestPhaseId)
    local getcount = self:GetQuestPhaseGetDiamond(EventId, QuestPhaseId)
    return allcount == getcount
end

return M
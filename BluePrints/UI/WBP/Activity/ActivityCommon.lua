require "UnLua"

local RewardBox = require "BluePrints.Client.CustomTypes.SimpleRewardBox"

local ActivityCommon = {}

-----------------------通用变量---------------------
ActivityCommon.MaxTryOutItemCount = 3

ActivityCommon.IsLoadAsync = true

ActivityCommon.DefaultPhaseId = 1001

ActivityCommon.MainUIName = "ActivityMain"

ActivityCommon.EventAllTypeId = {
    DailyLogin = 101,               -- 每日签到
    StarterQuests = 102,            -- 新手任务
    JumpToOtherPage = 103,          -- 跳转类型
    CharTrial = 105,                -- 角色试玩
    Zhiliu = 106,                   -- 止流活动
    ConditionReward = 107,          -- 条件奖励
    CommunityCheck = 109,           -- 社区关注
}

ActivityCommon.AllTitleName = {
    RougeTitle = "RougeTitle",
    TryOutTitle = "TryOutTitle",
    AbyssTitle = "AbyssTitle",
    ZhiliuTitle = "ZhiliuTitle",
    RechargeTitle = "RechargeTitle",
 }

ActivityCommon.AllUpdateTag = {
    ActivityTab = "ActivityTab",
    BackToPageWithJump = "BackToPageWithJump",
}


-- 活动通用事件
ActivityCommon.EventId = {
    OnRefreshInNextDay = "OnRefreshInNextDay",                  -- 隔天刷新事件
    OnRefreshWithActivityOpen = "OnRefreshWithActivityOpen",     -- 活动开启刷新事件
    OnRefreshWithActivityClose = "OnRefreshWithActivityClose",   -- 活动关闭刷新事件
}

-- 需要在跨天刷新的活动
ActivityCommon.NeedRefreshInNextDay = {
    DailyLoginFirst = 101001,                        -- 签到活动1
    DailyLoginSecond = 101003,                       -- 签到活动2
    MidTermGoal = 103006,                            -- 文明博弈
    WarmUp = 101004,                                 -- 预热活动
}

-----------------------特定活动私有变量---------------------
ActivityCommon.GlobalPakForbidTabId = {
	[105001] = 1, -- 充值返利
}

---------------------通用Function----------------------
function ActivityCommon.GenerateAllRewardIds(RewardIds)
    local RewardType, RewardList = DataMgr.RewardType, {}
    for ItemType, _ in pairs(RewardType) do
        local Rewards = RewardIds[ItemType.."s"]
        if Rewards then
            local RewardInfo = DataMgr[ItemType]
            for ItemId, ItemCount in pairs(Rewards) do
                local count = 0
                if type(ItemCount) == "table" then
                    count = RewardBox:GetCount(ItemCount)
                end
                if type(ItemCount) == "number" then
                    count = ItemCount
                end
                RewardList[ItemId] = { TableName = ItemType, ItemCount = count, Rarity = RewardInfo[ItemId].Rarity or RewardInfo[ItemId][ItemType.."Rarity"]}
            end
        end
    end

    local RewardInfoList = {}
    for key, Value in pairs(RewardList) do
        table.insert(RewardInfoList, {ItemId = key, ItemInfo = Value})
    end
    table.sort(RewardInfoList, function(A, B)
        local RarityA = A.ItemInfo.Rarity or 1
        local RarityB = B.ItemInfo.Rarity or 1
        if RarityA > RarityB then
            return true
        elseif RarityA == RarityB then
            return A.ItemId < B.ItemId
        else
            return false
        end
    end)
    return RewardInfoList
end


return ActivityCommon
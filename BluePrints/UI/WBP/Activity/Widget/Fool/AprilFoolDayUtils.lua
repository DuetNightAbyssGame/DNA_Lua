require "UnLua"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

local AprilFoolDayUtils = {}

AprilFoolDayUtils.ReddotNodeKey = "Acti_AprilFoolDay"
AprilFoolDayUtils.ReddotRewardKey = "AprilFoolDayReward"

function AprilFoolDayUtils.RefreshQuestReddot(ClearCache)
    if TimeUtils.ServerTimeZone == nil then
        return
    end
    if not ReddotManager.GetTreeNode(AprilFoolDayUtils.ReddotRewardKey) then
        ReddotManager.AddNodeEx(AprilFoolDayUtils.ReddotRewardKey)
    end
    if ClearCache then
        ReddotManager.ClearLeafNodeCount(AprilFoolDayUtils.ReddotRewardKey, true)
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(AprilFoolDayUtils.ReddotRewardKey)
    if not CacheDetail.QuestIds then
        CacheDetail.QuestIds = {}
    end
    local EventID = DataMgr.EventConstant.AFDayEvent2026ID.ConstantValue
    if not EventID then
        CacheDetail.QuestIds = {}
        return
    end
    local EventData = DataMgr.EventMain[EventID]
    if not EventData then
        CacheDetail.QuestIds = {}
        return
    end
    if ActivityUtils.CheckEventIsInActiveTime(EventID) then
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return
        end
        local CommonQuestActivity = Avatar.CommonQuestActivity[EventID]
        if not CommonQuestActivity then
            return
        end
        local Num = 0
        for _, Info in pairs(DataMgr.CommonQuestDetail) do
            if Info.EventId and Info.EventId == EventID and CommonQuestActivity[Info.QuestId] then
                local Progress = CommonQuestActivity[Info.QuestId].Progress
                local Target = CommonQuestActivity[Info.QuestId].Target
                local RewardsGot = CommonQuestActivity[Info.QuestId].RewardsGot
                if Progress >= Target and not RewardsGot then
                    if not CacheDetail.QuestIds[Info.QuestId] then
                        CacheDetail.QuestIds[Info.QuestId] = 1
                        Num = Num + 1
                    end
                else
                    if CacheDetail.QuestIds[Info.QuestId] then
                        CacheDetail.QuestIds[Info.QuestId] = nil
                        Num = Num - 1
                    end
                end
            end
        end
        if Num > 0 then
            ReddotManager.IncreaseLeafNodeCount(AprilFoolDayUtils.ReddotRewardKey, Num)
        elseif Num < 0 then
            ReddotManager.DecreaseLeafNodeCount(AprilFoolDayUtils.ReddotRewardKey, -Num)
        end
    else
        CacheDetail.QuestIds = {}
        return
    end
end

return AprilFoolDayUtils
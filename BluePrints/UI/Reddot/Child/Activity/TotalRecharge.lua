local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"

---@type ReddotTreeNode
local ReddotTreeNode_TotalRecharge = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_TotalRecharge:_Judge(ActivityID)
    if not ActivityUtils.CheckEventIsInActiveTime(ActivityID) then
        return false
    end

    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar or not PlayerAvatar.AccumulateRecharge then
        return false
    end

    local ActivityData = PlayerAvatar.AccumulateRecharge[ActivityID]
    if not ActivityData then
        return false
    end

    local CurrentTotalPoint = ActivityData.Score or 0
    local RewardGotList = ActivityData.RewardGot or {}
    local PageConfigData = DataMgr.CumulativeTopUpEvent[ActivityID]


    local NeedPoints = {}
    if PageConfigData and PageConfigData.ScoreRankReward then
        for k, _ in pairs(PageConfigData.ScoreRankReward) do
            table.insert(NeedPoints, k)
        end
        table.sort(NeedPoints)
        
        for i = 1, #NeedPoints do
            local scoreNeeded = NeedPoints[i]
            local index = i
            local hasGot = RewardGotList[index] == 1
            if (not hasGot) and (CurrentTotalPoint >= scoreNeeded) then
                return true
            end
        end
    end
    return false
end

-- function ReddotTreeNode_TotalRecharge:CheckActivityIsValid()
--     local CacheDetail = self.Cache.Detail
--     if (CacheDetail["bClose"]) then
--         return false
--     end
--     return true
-- end

return ReddotTreeNode_TotalRecharge
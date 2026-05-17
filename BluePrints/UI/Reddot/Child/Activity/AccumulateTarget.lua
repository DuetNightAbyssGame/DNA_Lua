local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"

---@type ReddotTreeNode
local ReddotTreeNode_AccumulateTarget = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_AccumulateTarget:_Judge(EventId)
    local Avatar = GWorld:GetAvatar()
    local ActivityData = Avatar.CommonQuestActivity[EventId]
    local CommonQuestDetail = DataMgr.CommonQuestDetail
    if not ActivityUtils.CheckEventIsInActiveTime(EventId) then
        return false
    end

    for QuestId, Detail in pairs(CommonQuestDetail) do
        if Detail.EventId == EventId then
            if ActivityData and ActivityData[QuestId] and not ActivityData[QuestId].RewardsGot then
                if ActivityData[QuestId].Progress and ActivityData[QuestId].Progress >= ActivityData[QuestId].Target then
                    return true
                end
            end
        end
    end

    return false
end

return ReddotTreeNode_AccumulateTarget
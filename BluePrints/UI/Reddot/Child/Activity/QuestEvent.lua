local EastSeasonQuestUtils = require "BluePrints.UI.WBP.Activity.Widget.EastSeason.EastSeasonQuestUtils"


local ReddotTreeNode_QuestEvent = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_QuestEvent:_Judge(EventId)
    local JumpUnlockCondition = DataMgr.EventPortal[EventId].JumpUnlockCondition
    local PlayerAvatar = GWorld:GetAvatar()
    if JumpUnlockCondition then
        if (not ConditionUtils.CheckCondition(PlayerAvatar, JumpUnlockCondition)) then
            return false
        end
    end
    for _, phaseConfig in pairs(DataMgr.CommonQuestPhase) do
        if phaseConfig.EventId == EventId then
            if EastSeasonQuestUtils:IsQuestPhaseCanGetReward(EventId, phaseConfig.QuestPhaseId) then
                return true
            end
        end
    end
    return false
end

return ReddotTreeNode_QuestEvent
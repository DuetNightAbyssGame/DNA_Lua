local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

local ReddotTreeNode_ChallengeLevel = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_ChallengeLevel:_Judge(activityId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    -- 获取玩家当前等级
    local currentLevel = Avatar.Level
    -- 获取历练活动数据
    local eventData = DataMgr.PlayerLvEvent[activityId]
    if not eventData then
        return false
    end
    -- 检查是否有可领取的奖励
    for level, _ in pairs(eventData) do
        -- 如果玩家等级已达到要求且奖励未领取，显示红点
        if level <= currentLevel and not Avatar.ActivityPlayerLvRewardsGot:HasElement(activityId, level) then
            return true
        end
    end
    return false
end

return ReddotTreeNode_ChallengeLevel
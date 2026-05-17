local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"
local ReturnUtils = require "Blueprints.UI.WBP.Activity.Widget.Return.ReturnUtils"
---@type ReddotTreeNode
local ReddotTreeNode_ComeBack = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_ComeBack:_Judge(ActivityID)
    self.ActivityID = ActivityID or self.ActivityID
    if self:_JudgeSevenDay() then
        return true
    elseif self:_JudgeTask() then
        return true
    elseif self:_JudgeInvite() then
        return true
    elseif self:_JudgeReward() then
        return true
    end

    return false
end

function ReddotTreeNode_ComeBack:_JudgeSevenDay()
    local SevenDayRewardValidIndex = ReturnUtils.GetSevenDayRewardValidIndex()
    if SevenDayRewardValidIndex and next(SevenDayRewardValidIndex) then
        return true
    end
    return false
end

function ReddotTreeNode_ComeBack:_JudgeTask()
    local Node = ReddotManager.GetTreeNode("ComeBackTask")
    return Node and Node.Count > 0
end

function ReddotTreeNode_ComeBack:_JudgeInvite()
    if not ReturnUtils.CanParticipateInvite() then
        return false
    end
    return false
end

function ReddotTreeNode_ComeBack:_JudgeReward()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return false end
    local BackRewardGot = Avatar.ComeBacks[self.ActivityID] and Avatar.ComeBacks[self.ActivityID].BackRewardGot or 0
    if BackRewardGot == 0 then
        return true
    end
    return false
end

return ReddotTreeNode_ComeBack
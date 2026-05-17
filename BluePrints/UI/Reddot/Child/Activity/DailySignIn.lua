local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"

---@type ReddotTreeNode
local ReddotTreeNode_DailySignIn = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_DailySignIn:_Judge(ActivityID)
    local PlayerAvatar = GWorld:GetAvatar()
    local AllSignServerData = PlayerAvatar.DailyLogin
    if (not self:CheckActivityIsValid(ActivityID)) then
        -- 活动已经失效了
        return false
    end
    for k, SignInfo in pairs(AllSignServerData) do
        if (ActivityID == SignInfo:GetEventID()) then
            local DailyLoginConfigData = DataMgr.DailyLogin[ActivityID]
            for idx = 1, DailyLoginConfigData.LoginDuration, 1 do
                local CurSignRewardState = ActivityUtils.GetCurSignRewardState(idx, SignInfo)
                if (CurSignRewardState == ActivityUtils.EnumPlayerSignRewardState.SignedNotRecv) then
                    return true
                end
            end
            break
        end
    end
    return false
end

function ReddotTreeNode_DailySignIn:CheckActivityIsValid(ActivityID)
    local CacheDetail = self.Cache.Detail
    if (CacheDetail["bClose"] and CacheDetail["CurrentEventId"] == ActivityID) then
        return false
    end
    return true
end

return ReddotTreeNode_DailySignIn
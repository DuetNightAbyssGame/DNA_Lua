
local GuildWarUtils = require "BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils"

local ReddotTreeNode_GuildWar = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")


function ReddotTreeNode_GuildWar:OnRefreshNodeData(EventId)
    self:_Judge(EventId)
end

function ReddotTreeNode_GuildWar:_Judge(EventId)
    -- 工会战活动缓存
    local Node = ReddotManager.GetTreeNode(GuildWarUtils.ReddotNodeKey)
    if not Node then
        ReddotManager.AddNodeEx(GuildWarUtils.ReddotNodeKey)
    end

    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(GuildWarUtils.ReddotNodeKey)
    if not CacheDetail then
        return false
    end

    if not CacheDetail[EventId] then
        CacheDetail[EventId] = {}
    end
    -- 刷新红点
    -- GuildWarUtils.RefreshShopReddot()  -- 商店红点不再穿透
    GuildWarUtils.RefreshQuestReddot()
    GuildWarUtils.RefreshEntranceReddot()
    GuildWarUtils.RefreshRewardGotReddot()

    -- 活动红点
    if not GuildWarUtils.IsEmptyTable(CacheDetail[EventId]) then
        return true
    end

    return false
end

function ReddotTreeNode_GuildWar:OnIncreaseJudge(AddValue, CacheDetailChangedParams)
    if not CacheDetailChangedParams then return true end
    local CacheKey = CacheDetailChangedParams.CacheKey
    local EventId = CacheDetailChangedParams.EventId
    if CacheKey and EventId and AddValue == 1 then
        if CacheKey == "Red" then
            return self:_Judge(EventId)
        end
    end
    return false
end

function ReddotTreeNode_GuildWar:OnDecreaseJudge(SubValue, CacheDetailChangedParams)
    if not CacheDetailChangedParams then return true end
    if (CacheDetailChangedParams.bClearAll) then
        self.Cache.Detail = {}
        return true
    end

    local CacheKey = CacheDetailChangedParams.CacheKey
    local EventId = CacheDetailChangedParams.EventId
    if SubValue == 1 and CacheKey and EventId then
        if CacheKey == "Red" then
            return not self:_Judge(EventId)
        end
    end
    return false
end

return ReddotTreeNode_GuildWar
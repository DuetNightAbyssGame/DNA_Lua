local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

local ReddotTreeNode_Wuyousheng= Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

local WuyoushengId = {110001}

function ReddotTreeNode_Wuyousheng:_Judge(EventId)
    local Node = ReddotManager.GetTreeNode("WuyoushengReward")
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("WuyoushengReward")
    if ActivityUtils.CheckIsPermanentEvent(EventId) then
        if CacheDetail and Node and Node.Count > 0 then
            ReddotManager.DecreaseLeafNodeCount("WuyoushengReward", Node.Count)
        end
        return false
    end
    
    -- 检查是否有可以领取的奖励
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    
    local WuyoushengData = Avatar.WuyoushengActivity and Avatar.WuyoushengActivity[EventId]
    if not WuyoushengData then
        return false
    end
    
    local WuyoushengTaskData = DataMgr["WuyoushengEventReward"]
    if not WuyoushengTaskData then
        return false
    end
    
    -- 遍历任务数据，检查是否有可以领取的奖励
    for RewardKeyId, TaskInfo in pairs(WuyoushengTaskData) do
        if TaskInfo.EventId == EventId then
            local CanReceive = WuyoushengData:IsCompleted(RewardKeyId, TaskInfo.RequiredStar) and not WuyoushengData:IsRewarded(RewardKeyId)
            if CanReceive then
                CacheDetail[RewardKeyId] = true
                return true
            else
                CacheDetail[RewardKeyId] = false
            end
        end
    end
    
    -- 如果都不能领奖，返回false
    return false
end

function ReddotTreeNode_Wuyousheng:OnInitNodeCache(NodeCache)
    ReddotTreeNode_Wuyousheng.Super.OnInitNodeCache(self, NodeCache)
    ReddotManager.AddListenerEx("WuyoushengReward", self, self.OnWuyoushengRewardChange)
end

function ReddotTreeNode_Wuyousheng:OnDisposeNode()
    ReddotManager.RemoveListener("WuyoushengReward", self)
end

function ReddotTreeNode_Wuyousheng:OnWuyoushengRewardChange(Count,RdType,RdName)
    if Count ~= 0 then return end
    for _, EventId in ipairs(WuyoushengId) do
        ActivityUtils.TrySubActivityReddotCommon("Red", EventId, self.Name)
    end
end


return ReddotTreeNode_Wuyousheng
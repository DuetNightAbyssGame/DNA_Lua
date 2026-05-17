local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")

function M:OnInitNodeCache(NodeCache)
    EventManager:AddEvent(EventID.OnActivityTimeOpen, self, self.OnRefreshWithActivityOpen)
    EventManager:AddEvent(EventID.OnActivityTimeOpenClose, self, self.OnRefreshWithActivityClose)
end

function M:OnDisposeNode()
    EventManager:RemoveEvent(EventID.OnActivityTimeOpen, self)
    EventManager:RemoveEvent(EventID.OnActivityTimeOpenClose, self)
end

function M:OnRefreshWithActivityOpen(ActivityID)
    if DataMgr.LimitedPrizePool[ActivityID] then
        if self.Name == "LimitedPrizeRewardSelect" then
            local Avatar = GWorld:GetAvatar()
            if Avatar then
                Avatar:RefreshLimitedPrizeRewardSelectReddot()
            end
        end
    end
end

function M:OnRefreshWithActivityClose(ActivityID)
    if DataMgr.LimitedPrizePool[ActivityID] then
        ReddotManager.ClearLeafNodeCount(self.Name, true)
    end
end

return M
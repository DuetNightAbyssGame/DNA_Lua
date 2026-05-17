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
    if ActivityID == DataMgr.EventConstant.AFDayEvent2026ID.ConstantValue then
        if self.Name == "AprilFoolDayTransformResource" then
            local Avatar = GWorld:GetAvatar()
            if self.Count == 0 and (not Avatar or not Avatar:CheckTransformResourceIsGot()) then
                ReddotManager.IncreaseLeafNodeCount(self.Name, 1)
            end
        elseif self.Name == "AprilFoolDayRewardNew" then
            local CacheDetail = self.Cache.Detail
            if self.Count == 0 and not CacheDetail.DoNotShowNew then
                ReddotManager.IncreaseLeafNodeCount(self.Name, 1)
            end
        end
    end
end

function M:OnRefreshWithActivityClose(ActivityID)
    if ActivityID == DataMgr.EventConstant.AFDayEvent2026ID.ConstantValue then
        ReddotManager.ClearLeafNodeCount(self.Name, true)
    end
end

return M
local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")

function M:OnInitNodeCache(NodeCache)
    EventManager:AddEvent(EventID.OnActivityTimeOpenClose, self, self.OnRefreshWithActivityClose)
end

function M:OnDisposeNode()
    EventManager:RemoveEvent(EventID.OnActivityTimeOpenClose, self)
end

function M:OnRefreshWithActivityClose(ActivityID)
    if ActivityID == CommonConst.SoloTreasureEventId then
        ReddotManager.ClearLeafNodeCount(self.Name, true)
    end
end

return M
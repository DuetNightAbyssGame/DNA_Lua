local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")

function M:OnInitNodeCache(NodeCache)
    NodeCache.Count = 0
    for key, value in pairs(NodeCache.Detail) do
        if(value == 1)then
            NodeCache.Count = NodeCache.Count + 1
        end
    end
end

function M:OnDecreaseCount(SubValue, CacheDetailChangedParams, OldCount)
    if(self.Count ~= 0)then
        ReddotManager.TryInvokeEvent(self, self.Count, true)
    end
    --TODO:先这样写着，后面再优化
end



return M
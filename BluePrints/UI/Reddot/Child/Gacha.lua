local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")
local GachaModel = require "BluePrints.UI.WBP.Gacha.GachaModel"


function M:OnInitNodeCache(NodeCache)
    NodeCache.Count = 0
    GachaModel:CheckReddot(self)
    if self.Name == DataMgr.ReddotNode.Gacha_New.Name then
        GachaModel:CheckNew(self)
    end
end

function M:OnDecreaseCount(SubValue, CacheDetailChangedParams, OldCount)
    self:RefreshInfo()
end

function M:OnIncreaseCount(AddValue, CacheDetailChangedParams, OldCount)
    self:RefreshInfo()
end

function M:RefreshInfo()
    self:UpdateRdType()
end

return M
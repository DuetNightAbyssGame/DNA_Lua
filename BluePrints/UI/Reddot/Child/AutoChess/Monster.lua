local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")

function M:OnInitNodeCache(NodeCache)
    DebugPrint("AutoChessMonster@ Init")
    local Avatar = GWorld:GetAvatar()
    local UnlockedMonsters = Avatar.AutoChess.UnlockedCards
    NodeCache.Detail = NodeCache.Detail or {}
    NodeCache.Count = 0
    for MonsterId, _ in pairs(UnlockedMonsters) do
        if NodeCache.Detail[MonsterId] == nil then
            NodeCache.Count = NodeCache.Count + 1
            DebugPrint("AutoChessMonster@ 存在新获得怪物: ", MonsterId)
        end
    end

    DebugPrint("AutoChessMonster@ Reddot OnInitNodeCache Count:", NodeCache.Count)
end

function M:OnDecreaseCount(SubValue, CacheDetailChangedParams, OldCount)
    self.Cache.Detail = self.Cache.Detail or {}
    for _, Id in pairs(CacheDetailChangedParams) do
        self.Cache.Detail[Id] = true
    end
end

return M
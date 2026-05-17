local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")

function M:OnInitNodeCache(NodeCache)
    DebugPrint("AutoChessEquip@ Init")
    local Avatar = GWorld:GetAvatar()
    local UnlockedEquips = Avatar.AutoChess.UnlockedEquips
    NodeCache.Detail = NodeCache.Detail or {}
    NodeCache.Count = 0
    for Index, EquipId in pairs(UnlockedEquips) do
        if NodeCache.Detail[EquipId] == nil then
            NodeCache.Count = NodeCache.Count + 1
            DebugPrint("AutoChessEquip@ 存在新获得装备: ", EquipId)
        end
    end

    DebugPrint("AutoChessEquip@ Reddot OnInitNodeCache Count:", NodeCache.Count)
end

function M:OnDecreaseCount(SubValue, CacheDetailChangedParams, OldCount)
    self.Cache.Detail = self.Cache.Detail or {}
    for _, Id in pairs(CacheDetailChangedParams) do
        self.Cache.Detail[Id] = true
    end
end

return M
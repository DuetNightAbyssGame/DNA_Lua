local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")

function M:OnInitNodeCache(NodeCache)
    M.Super.OnInitNodeCache(self, NodeCache)
    if self.Name == "ExperienceItem" then
		NodeCache.Count = 0
        NodeCache.Detail = {}
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            local Count = 0
            for _,Info in pairs(DataMgr.PlayerLevelUp) do
                if Info.PlayerLevel <= Avatar.Level and not Avatar.LevelRewardsGot[Info.PlayerLevel] then
                    NodeCache.Detail[Info.PlayerLevel] = 1
                    Count = Count + 1
                end
            end
            NodeCache.Count = Count
        end
    end
end

return M
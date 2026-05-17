
local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")

function M:OnCheckEscShowCondition(MainUIId)
    local MainUIConf = DataMgr.MainUI[MainUIId]
    local Avatar = GWorld:GetAvatar()
    if not ConditionUtils.CheckCondition(Avatar, MainUIConf.EscShowCondition) then
        for _,Node in pairs(self.LeafChildrens) do
            if Node.Count ~= 0 then
                local Count = Node.Count
                ReddotManager.ClearLeafNodeCount(Node.Name)
                Node.Cache.Count = Count
            end
        end
    else
        for _,Node in pairs(self.LeafChildrens) do
            if Node.Count == 0 and Node.Cache.Count ~= 0 then
                ReddotManager.IncreaseLeafNodeCount(Node.Name, Node.Cache.Count)
            end
        end
    end
end
return M

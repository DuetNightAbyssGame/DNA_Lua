local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

local ReddotTreeNode_Abyss = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

local AbyssEventIds = {103002, 1030022}

function ReddotTreeNode_Abyss:_Judge(EventId)
    local Node = ReddotManager.GetTreeNode("AbyssReward")
    if not Node then
        Node = ReddotManager.AddNodeEx("AbyssReward")
    end
    return Node.Count >0
end

function ReddotTreeNode_Abyss:OnInitNodeCache(NodeCache)
    ReddotTreeNode_Abyss.Super.OnInitNodeCache(self, NodeCache)
    ReddotManager.AddListenerEx("AbyssReward", self, self.OnAbyssRewardChange)
end

function ReddotTreeNode_Abyss:OnDisposeNode()
    ReddotManager.RemoveListener("AbyssReward", self)
end

function ReddotTreeNode_Abyss:OnAbyssRewardChange(Count,RdType,RdName)
    if Count ~= 0 then return end
    for _, EventId in ipairs(AbyssEventIds) do
        ActivityUtils.TrySubActivityReddotCommon("Red", EventId, self.Name)
    end
end

return ReddotTreeNode_Abyss
local ReddotTreeNode_WebJumpEvent = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_WebJumpEvent:_Judge(EventId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local WebJumpList = Avatar.WebJumpList
    if not WebJumpList then
        return false
    end
    return WebJumpList[EventId] == 1
end

function ReddotTreeNode_WebJumpEvent:OnInitNodeCache(NodeCache)
    ReddotTreeNode_WebJumpEvent.Super.OnInitNodeCache(self, NodeCache)
end

return ReddotTreeNode_WebJumpEvent
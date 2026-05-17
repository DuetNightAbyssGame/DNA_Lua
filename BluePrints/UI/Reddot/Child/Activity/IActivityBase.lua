local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

---@type ReddotTreeNode
local ReddotTreeNode_IActivityBase = Class("BluePrints.UI.Reddot.ReddotTreeNode")


function ReddotTreeNode_IActivityBase:OnRefreshNodeData(EventId)
end

function ReddotTreeNode_IActivityBase:OnDecreaseJudge(SubValue, CacheDetailChangedParams)
    if CacheDetailChangedParams then 
        DebugPrint(DebugTag, "IActivityBase 重写OnDecreaseJudge之后才允许传参")
        return false 
    end
    return true
end

function ReddotTreeNode_IActivityBase:OnIncreaseJudge(AddValue, CacheDetailChangedParams)
    if CacheDetailChangedParams then 
        DebugPrint(DebugTag, "IActivityBase 重写OnIncreaseJudge之后才允许传参")
        return false 
    end
    return true
end

return ReddotTreeNode_IActivityBase

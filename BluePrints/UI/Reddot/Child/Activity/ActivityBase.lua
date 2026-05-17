local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

---@type ReddotTreeNode
local ReddotTreeNode_ActivityBase = Class("BluePrints.UI.Reddot.Child.Activity.IActivityBase")

function ReddotTreeNode_ActivityBase:OverrideSelfRdType()
    if not self.Cache then return end
    self:_JudgeReddotType(self.Cache.Detail)
end

function ReddotTreeNode_ActivityBase:OnRefreshNodeData(EventId)
    ReddotManager.IncreaseLeafNodeCount(self.Name, 1, {CacheKey="New", EventId=EventId})
    if self:_Judge(EventId) then
        ReddotManager.IncreaseLeafNodeCount(self.Name, 1, {CacheKey="Red", EventId=EventId})
    else
        ReddotManager.DecreaseLeafNodeCount(self.Name, 1, {CacheKey="Red", EventId=EventId})
    end
end

function ReddotTreeNode_ActivityBase:OnIncreaseJudge(AddValue, CacheDetailChangedParams)
    if not CacheDetailChangedParams then return true end
    local CacheDetail = self.Cache.Detail
    local CacheKey = CacheDetailChangedParams.CacheKey
    local EventId = CacheDetailChangedParams.EventId
    if CacheKey and EventId and AddValue == 1 then
        if CacheKey == "New" and (not CacheDetail[CacheKey]) then
            return true
        elseif (CacheKey == "Red") and CacheDetail[CacheKey]~=1 then
            return self:_Judge(EventId)
        end
    end
    return false
end

function ReddotTreeNode_ActivityBase:OnDecreaseJudge(SubValue, CacheDetailChangedParams)
    if not CacheDetailChangedParams then return true end
    if (CacheDetailChangedParams.bClearAll) then
        return true
    end
    local CacheDetail = self.Cache.Detail
    local CacheKey = CacheDetailChangedParams.CacheKey
    local EventId = CacheDetailChangedParams.EventId
    if SubValue == 1 and CacheKey and EventId and CacheDetail[CacheKey]==1 then
        if CacheKey == "New" then
            return true
        elseif CacheKey == "Red" then
            return not self:_Judge(EventId)
        end
    end
    return false
end

function ReddotTreeNode_ActivityBase:_Judge(EventId)
    return false
end

function ReddotTreeNode_ActivityBase:OnIncreaseCount(AddValue, CacheDetailChangedParams)
    if not CacheDetailChangedParams then return end
    local CacheDetail = self.Cache.Detail
    local CacheKey = CacheDetailChangedParams.CacheKey
    CacheDetail[CacheKey] = 1
    self:JudgeReddotType(CacheDetail)
end

function ReddotTreeNode_ActivityBase:OnDecreaseCount(SubValue, CacheDetailChangedParams)
    if not CacheDetailChangedParams then return end
    local CacheDetail = self.Cache.Detail
    local bClearAll = CacheDetailChangedParams.bClearAll

    if (not bClearAll) then
        local CacheKey = CacheDetailChangedParams.CacheKey
        CacheDetail[CacheKey] = 0
    else
        if (self.Count == 0) then
            CacheDetail["New"] = 0
            CacheDetail["Red"] = 0
            CacheDetail["bClose"] = true
            CacheDetail["CurrentEventId"] = CacheDetailChangedParams.EventId
        end
    end
    self:JudgeReddotType(CacheDetail)
end

function ReddotTreeNode_ActivityBase:JudgeReddotType(CacheDetail)
    self:_JudgeReddotType(CacheDetail)
    self:UpdateRdType() 
end

function ReddotTreeNode_ActivityBase:_JudgeReddotType(CacheDetail)
    local NewRdType = self.ReddotType
    local bRed  = CacheDetail["Red"]and (CacheDetail["Red"] >= 1)
    local bNew =  CacheDetail["New"]and (CacheDetail["New"] >= 1)
    if bRed then
        NewRdType = EReddotType.Normal
    elseif bNew then
        NewRdType = EReddotType.New
    end
    self.ReddotType = NewRdType
end

function ReddotTreeNode_ActivityBase:OnInitNodeCache(NodeCache)
    self.bImplemented = true
    self.bInvokeEveryTime = true
    NodeCache.Count = 0
    local Avatar = GWorld:GetAvatar()
    if not Avatar:CheckUIUnlocked("GameEvent") then
        NodeCache.Detail = {}
    else
        for k,v in pairs(NodeCache.Detail) do
            if v == 1 then
                NodeCache.Count = NodeCache.Count + 1
            end
        end
        self:JudgeReddotType(NodeCache.Detail)
    end
end

return ReddotTreeNode_ActivityBase
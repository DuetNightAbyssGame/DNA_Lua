require "UnLua"

local CameraGameUtils = require "BluePrints.UI.WBP.Activity.PC.CameraGame.CameraGameUtils"
local ReddotTreeNode_CameraGame = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_CameraGame:OnRefreshNodeData(EventId)
    ReddotManager.IncreaseLeafNodeCount(self.Name, 1, {CacheKey="New", EventId=EventId})
    self:_Judge(EventId)
end

function ReddotTreeNode_CameraGame:_Judge(EventId)
    EventManager:AddEvent(EventID.OnCompleteQuestChain, self, self.OnQuestChainComplete)

    self.EventId = EventId
    CameraGameUtils.RefreshReddot(EventId)
end

function ReddotTreeNode_CameraGame:OnIncreaseCount(AddValue, CacheDetailChangedParams)
    local CacheDetail = self.Cache.Detail
    self:JudgeReddotType(CacheDetail)
    if not CacheDetailChangedParams then
        return
    end

    local CacheKey = CacheDetailChangedParams.CacheKey
    CacheDetail[CacheKey] = 1
end

function ReddotTreeNode_CameraGame:OnDecreaseCount(SubValue, CacheDetailChangedParams)
    local CacheDetail = self.Cache.Detail
    self:JudgeReddotType(CacheDetail)
    if not CacheDetailChangedParams then
        return
    end

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
end

function ReddotTreeNode_CameraGame:_JudgeReddotType(CacheDetail)
    local RedCount = self:GetReddotCount()
    local bRed  = (RedCount > 0)
    -- local bNew =  (NewCount > 0) or (CacheDetail["New"] and (CacheDetail["New"] >= 1))

    if bRed then
        self.ReddotType = EReddotType.Normal
    else
        self.ReddotType = EReddotType.New
    end
end

function ReddotTreeNode_CameraGame:GetReddotCount()
    self.EventId = self.EventId or CameraGameUtils.GetEventId()
    if not self.EventId then
        return  0
    end

    local CacheDetail = self.Cache.Detail
    if not CacheDetail then
        return 0
    end

    local RedCount = 0
    for _, QuestData in pairs(DataMgr.PhotoEvent[self.EventId] or {}) do
        local QuestState = CacheDetail[QuestData.QuestChain]
        if (QuestState == CameraGameUtils.ReddotType.RED) then
            RedCount = RedCount + 1
        end
    end

    return RedCount
end

-- 完成任务后增加红点计数
function ReddotTreeNode_CameraGame:OnQuestChainComplete(QuestChainId, QuestId)
    if not self.EventId then
        return
    end

    local STLExportInfo = DataMgr.STLExportQuestChain[QuestChainId]
    if (not STLExportInfo) or (QuestId ~= STLExportInfo.EndQuestId) then
        return
    end

    -- 初始化拍照活动任务链查询Map
    if not self.QuestChainIdMap then
        self.QuestChainIdMap = {}
        for _, QuestData in pairs(DataMgr.PhotoEvent[self.EventId] or {}) do
            self.QuestChainIdMap[QuestData.QuestChain] = 1
        end
    end

    local ReddotType = CameraGameUtils.ReddotType
    local ReddotNodeName = CameraGameUtils.ReddotNodeName
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotNodeName)
    if not CacheDetail then
        return
    end

    if self.QuestChainIdMap[QuestChainId] then
        if CacheDetail[QuestChainId] == ReddotType.NEW then -- 削减New计数
            ReddotManager.DecreaseLeafNodeCount(ReddotNodeName)
        end

        if CacheDetail[QuestChainId] ~= ReddotType.RED then
            CacheDetail[QuestChainId] = ReddotType.RED   -- 增加Red计数
            ReddotManager.IncreaseLeafNodeCount(ReddotNodeName)
        end
        return
    end
end

return ReddotTreeNode_CameraGame
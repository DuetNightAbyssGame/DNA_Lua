require "UnLua"

local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local CameraGameUtils = {}

CameraGameUtils.ReddotNodeName = "Acti_CameraGame"
CameraGameUtils.ReddotType = {
    NONE = 0,
    RED = 1,
    NEW = 2,
    SEEN = 3,  -- 已看过的New
}
-- 获取当前拍照活动ID
function CameraGameUtils.GetEventId()
    for EventId, _ in pairs(DataMgr.PhotoEvent) do
        if ActivityUtils.CheckEventIsInActiveTime(EventId) then
            return EventId
        end
    end
end

-- 拍照进度
function CameraGameUtils.GetPhotoProgress()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local EventId = CameraGameUtils.GetEventId()
    local PhotoEventData = DataMgr.PhotoEvent[EventId] or {}
    local TotalCount = #PhotoEventData
    local CurCount = 0

    for _, Data in pairs(PhotoEventData) do
        local QuestChain = Avatar.QuestChains[Data.QuestChain]
        if QuestChain and (QuestChain.State == CommonConst.QuestChainState.finish) then
            CurCount = CurCount + 1
        end
    end

    return CurCount, TotalCount
end

-- 刷新拍照活动红点
function CameraGameUtils.RefreshReddot(EventId)
    local FinalEventId  = EventId or CameraGameUtils.GetEventId()
    if not FinalEventId then return end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end

    local PhotoEventConfigs = DataMgr.PhotoEvent[FinalEventId]
    if not PhotoEventConfigs then return end

    local ReddotNodeName = CameraGameUtils.ReddotNodeName
    local Node = ReddotManager.GetTreeNode(ReddotNodeName)
    if not Node then
        ReddotManager.AddNodeEx(ReddotNodeName)
    end

    -- 初始化
    local ReddotType = CameraGameUtils.ReddotType
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotNodeName)
    if not CacheDetail then
        return
    end

    local QCS = CommonConst.QuestChainState
    -- 遍历所有任务，确定红点状态
    for _, QuestData in pairs(PhotoEventConfigs) do
        local QuestChainId = QuestData.QuestChain
        local IsRewardGot = Avatar.PhotoActRewardGot[QuestChainId]  -- 奖励是否已领取
        local QuestChain = Avatar.QuestChains[QuestChainId]
        local QuestState = QuestChain and QuestChain.State or QCS.lock  -- 任务状态

        if not CacheDetail[QuestChainId] then
            CacheDetail[QuestChainId] = ReddotType.NONE
        end

        if (IsRewardGot or QuestState == QCS.lock) then -- 奖励已领取 or 任务未解锁
            if (CacheDetail[QuestChainId] == ReddotType.RED)
                or (CacheDetail[QuestChainId] == ReddotType.NEW)  then -- 削减计数
                CacheDetail[QuestChainId] = ReddotType.NONE
                ReddotManager.DecreaseLeafNodeCount(ReddotNodeName)
            end

        else -- 奖励未领取
            if (QuestState == QCS.finish) then -- 已完成状态
                if CacheDetail[QuestChainId] == ReddotType.NEW then -- 削减New计数
                    ReddotManager.DecreaseLeafNodeCount(ReddotNodeName)
                end

                if CacheDetail[QuestChainId] ~= ReddotType.RED then
                    CacheDetail[QuestChainId] = ReddotType.RED   -- 增加Red计数
                    ReddotManager.IncreaseLeafNodeCount(ReddotNodeName)
                end
            elseif (QuestState == QCS.doing or QuestState == QCS.unlock) then  -- 待完成状态
                if CacheDetail[QuestChainId] == ReddotType.NONE then
                    CacheDetail[QuestChainId] = ReddotType.NEW  -- 增加New计数
                    ReddotManager.IncreaseLeafNodeCount(ReddotNodeName)
                end
            end
        end
    end
end

return CameraGameUtils
local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")
local TimeUtils = require "Utils.TimeUtils"

function M:OnIncreaseJudge(AddValue, CacheDetailChangedParams)
    local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end
    if not CacheDetailChangedParams then return true end
    local QuestId = CacheDetailChangedParams.QuestId
    local Data = Avatar.QuestChains[QuestId]
    local CacheDetail = self.Cache.Detail
    if self:CheckQuestIsShowByCheckState(QuestId, Data) and Data.State ~= 3 and Data.CanShow  then
        return true
    else
        return false
    end
end

-- function M:OnDecreaseJudge(SubValue, CacheDetailChangedParams)

-- end

function M:OnDecreaseCount(SubValue, CacheDetailChangedParams, OldCount)
    if not CacheDetailChangedParams then return end
    local CacheDetail = self.Cache.Detail
    local QuestChainId = CacheDetailChangedParams.QuestId
    CacheDetail[QuestChainId] = 0
end

function M:OnIncreaseCount(AddValue, CacheDetailChangedParams, OldCount)
    if not CacheDetailChangedParams then return end
    local CacheDetail = self.Cache.Detail
    local QuestChainId = CacheDetailChangedParams.QuestId
    CacheDetail[QuestChainId] = 1
end

function M:OnInitNodeCache(NodeCache)
    local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end
    local AllQuestData = Avatar.QuestChains or {}
    for QuestChainId, Data in pairs(AllQuestData) do
        if Data.State ~= 3 and Data.CanShow and self:CheckQuestIsShowByCheckState(QuestChainId, Data) then
            if NodeCache.Detail[QuestChainId] == nil then
                local Type = DataMgr.QuestChain[QuestChainId].QuestChainType
                local TypeName = CommonConst.QuestTypeName[Type]
                local NodeName = DataMgr.ReddotNode[TypeName].Name
                if self.Name == NodeName then
                    NodeCache.Count = NodeCache.Count + 1
                    NodeCache.Detail[QuestChainId] = 1               
                end
            end
        end
    end
end

function M:CheckQuestIsShowByCheckState(QuestChainId, QuestChainData)
    local QuestChainType = 0
    if DataMgr.QuestChain[QuestChainId] and DataMgr.QuestChain[QuestChainId].QuestChainType then
        QuestChainType = DataMgr.QuestChain[QuestChainId].QuestChainType
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end

    if QuestChainData.State == 3 then --已完成
        return false
    end
    
    local CurrentTime = TimeUtils.NowTime()
    local StartTime = DataMgr.QuestChain[QuestChainId].StartTime --开始时间
    local EndTime = DataMgr.QuestChain[QuestChainId].EndTime --结束时间
    local ShowTime = DataMgr.QuestChain[QuestChainId].ShowTime --显示时间
    local QuestStartTime = nil
    local QuestEndTime = nil
    if ShowTime then
        QuestStartTime = ShowTime:GetTime()
    elseif StartTime then
        QuestStartTime = StartTime:GetTime()
    end
    if EndTime then
        QuestEndTime = EndTime:GetTime()
    end
    if QuestStartTime and QuestEndTime and (QuestStartTime > CurrentTime or CurrentTime > QuestEndTime) and
    (QuestChainType == Const.LimTimeQuestChainType or QuestChainType == Const.MainActivityQuestChainType) then
        return false
    end
    if QuestStartTime and (QuestStartTime > CurrentTime) and 
    (QuestChainType == Const.LimTimeQuestChainType or QuestChainType == Const.MainActivityQuestChainType) then
        return false
    end
    if not QuestStartTime and QuestEndTime and (CurrentTime > QuestEndTime) and
    (QuestChainType == Const.LimTimeQuestChainType or QuestChainType == Const.MainActivityQuestChainType) then
       return false
    end
    if QuestChainData.CanShow == false and (QuestChainType == Const.LimTimeQuestChainType or QuestChainType == Const.MainActivityQuestChainType) then
        return false
    end

    if QuestChainData.State == 0 then --未解锁
        if (QuestChainType == Const.LimTimeQuestChainType or QuestChainType == Const.MainActivityQuestChainType) and QuestChainData.CanShow == false then
            return false
        elseif (QuestChainType == Const.LimTimeQuestChainType or QuestChainType == Const.MainActivityQuestChainType) and QuestChainData.CanShow == true then
            return true
        end

        return true
    end
    
    local STLExportInfo = DataMgr.STLExportQuestChain[QuestChainId]
    if STLExportInfo == nil or STLExportInfo.Quests == nil or STLExportInfo.Quests[QuestChainData.DoingQuestId] == nil then
        return false
    end

    if STLExportInfo.Quests[QuestChainData.DoingQuestId].IsPreQuest then
        return false
    else
        return true
    end


end

return M
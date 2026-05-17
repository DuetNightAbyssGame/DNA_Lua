require "UnLua"

local M = {}

--- 获取套装已满足等级
---@param GroupId number @套装Id
---@param Count number @套装已激活数量
---@return Level number @套装等级
function M:GetGroupLevel(GroupId, Count)
    local Level = 1
    if Count == 0 then
        return Level
    end

    local GroupData = DataMgr.BlessingGroup[GroupId]
    for _, v in pairs(GroupData.ActivateNeed) do
        if Count < v + GWorld.RougeLikeManager.BlessingGroupDiscount then
            break
        end
        Level = Level + 1
    end
    return Level
end

--- 判断当前套装数目是否处于恰好激活状态
---@param GroupId number @套装Id
---@param Count number @套装已激活数量
---@return IsActive boolean @是否处于恰好激活状态
function M:GetGroupIsActive(GroupId, Count)
    local GroupData = DataMgr.BlessingGroup[GroupId]
    assert(GroupData, "套装信息未找到："..GroupId)
    local IsActive = false
    for _, v in pairs(GroupData.ActivateNeed) do
        if Count == v + GWorld.RougeLikeManager.BlessingGroupDiscount then
            IsActive = true
            break
        end
    end
    return IsActive
end

--- 判断某个祝福组是否可以升级
---@param BlessingId number @套装Id
function M:GetIsCanLevelUp(BlessingId)
    local RougeLikeManager = GWorld.RougeLikeManager
    local BlessingsList = RougeLikeManager.Blessings
    for Id, _ in pairs(BlessingsList) do
        if Id == BlessingId then
            return true
        end
    end
    return false
end

--- rogue报错
function M:ShowRougeLikeError(Text)
	local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
    local bEnableShippingLog = UE4.URuntimeCommonFunctionLibrary.EnableLogInShipping()
    if bDistribution and not bEnableShippingLog then
        return
    end
    
	local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:SendToFeishuForRougeLike(Text, "肉鸽报错")
        return
    end
end

-- SuitId = 套装Id
-- CurrentLV = 第几层套装效果
-- IsPreAdd = bool,是否预加上
-- IsUnlockFeedback = bool,是否是解锁后的反馈,没有就不传
-- IsGuide = bool, 是否在图鉴界面打开
function M:GenSuitDetail(SuitId, CurrentLV, IsPreAdd, IsUnlockFeedback, IsGuide)
    if not self.ActiveNeedMap then
        self.ActiveNeedMap = {}
        for _, v in pairs(DataMgr.BlessingGroup) do
            for _, ActiveNeed in ipairs(v.ActivateNeed) do
                if self.ActiveNeedMap[v.GroupId] == nil then
                    self.ActiveNeedMap[v.GroupId] = {}
                end
                table.insert(self.ActiveNeedMap[v.GroupId], ActiveNeed)
            end
        end
    end
    local _TextUnlockNum
    local _TextCurrentNum
    if IsGuide then
        _TextUnlockNum = self.ActiveNeedMap[SuitId][CurrentLV]
        _TextCurrentNum = _TextUnlockNum
    else
        _TextUnlockNum = self.ActiveNeedMap[SuitId][CurrentLV] + GWorld.RougeLikeManager.BlessingGroupDiscount
        _TextCurrentNum = GWorld.RougeLikeManager.BlessingGroup:Find(SuitId) or 0
    end
    local _IsActive
    local _TextSuitDesc = DataMgr.BlessingGroup[SuitId].ActivateDesc[CurrentLV]
    local _ExplanationId
    if DataMgr.BlessingGroup[SuitId].ExplanationId then
        _ExplanationId = DataMgr.BlessingGroup[SuitId].ExplanationId[CurrentLV]
    end
    if IsPreAdd then
        _TextCurrentNum = _TextCurrentNum + 1
    else
        _TextCurrentNum = _TextCurrentNum
    end
    if _TextCurrentNum >= _TextUnlockNum then
        if IsPreAdd and _TextCurrentNum == _TextUnlockNum then
            _IsActive = 2
        else
           _IsActive = 1
        end
    else
        _IsActive = 0
    end
    return {TextGroupLevel = CurrentLV,TextCurrentNum = _TextCurrentNum, TextUnlockNum = _TextUnlockNum, IsActive = _IsActive, TextSuitDesc = _TextSuitDesc, IsUnlockFeedback = IsUnlockFeedback, ExplanationId = _ExplanationId}
end
return M
local EMCache = require "EMCache.EMCache"
local TimeUtils = require("Utils.TimeUtils")
--- 抽卡Model
local GachaCommon = require "BluePrints.UI.WBP.Gacha.GachaCommon"

--- @class GachaModel :Model
local M = Class("BluePrints.Common.MVC.Model")

function M:Init()
    self._Avatar = nil
    self.IsDestroied = nil
    self:GetAvatar()
end

function M:Destory()
    self._Avatar = nil
    self.IsDestroied = true
end

---@return AvatarAttr
function M:GetAvatar()
    if self._Avatar == nil then 
        self._Avatar = GWorld:GetAvatar()
    end
    if not self._Avatar then 
        DebugPrint(ErrorTag, LXYTag, "Model:GetAvatar() Avatar is nil")
    end
    return self._Avatar
end

--- 获取卡池的服务器信息
function M:GetGachaAvatarInfo(GachaId)
    assert(GachaId, "GetGachaAvatarInfo传入了空的GachaId")
    local Avatar = self:GetAvatar()
    local GachaLst = Avatar.SkinGachaPool
    if not GachaLst[GachaId] or not GachaLst[GachaId].Usable then
        return nil
    end
    return GachaLst[GachaId]
end

--- 获取当前各类型卡池对应的卡池信息
function M:GetEffectiveGachaInfo()
    local Avatar = self:GetAvatar()
    local GachaType2Gacha = {}
    local GachaLst = Avatar.SkinGachaPool
    for _, GachaData in pairs(GachaLst) do
        ---@todo ZDX 加一下conditionId判断
        if GachaData.Usable and self:CheckGachaEffective(GachaData.GachaId)  then
            local GachaId = GachaData.GachaId
            local GachaData = DataMgr.SkinGacha[GachaId]
            if not GachaType2Gacha[GachaData.TabId] then
                GachaType2Gacha[GachaData.TabId] = {}
            end
            table.insert(GachaType2Gacha[GachaData.TabId], GachaData.GachaId)
        end
    end
    for _, Data in pairs(GachaLst) do
        table.sort(Data, function(A, B)
            local SequenceA = A.Sequence
            local SequenceB = B.Sequence
            return SequenceA < SequenceB
        end)
    end
    return GachaType2Gacha
end

--- 获取当前所有卡池类型信息
function M:GetGachaTabInfo()
    local SkinGachaTabData = DataMgr.SkinGachaTab
    local Res = {}
    for _, Data in pairs(SkinGachaTabData) do
        local Content = {}
        Content.TabId = Data.TabId
        Content.TabName = Data.TabName
        Content.Icon = Data.Icon
        Content.Sequence = Data.Sequence
        Content.GachaIdLst = Data.GachaId
        table.insert(Res, Content)
    end
    table.sort(Res, function(A, B)
        local SequenceA = A.Sequence or 0
        local SequenceB = B.Sequence or 0
        return SequenceA < SequenceB
    end)
    return Res
end

--- 判断卡池是否处于有效期间
---@param GachaId number 抽卡ID
---@return boolean 
function M:CheckGachaEffective(GachaId)
    local GachaData = DataMgr.SkinGacha[GachaId]
    assert(GachaData, "抽卡信息不存在:"..GachaId)
    ---@todo ZDX 加一下conditionId判断
    if GachaData.GachaStartTime < TimeUtils.NowTime() and GachaData.GachaEndTime > TimeUtils.NowTime() then
        return true
    end
    return false
end

--- 获取对应SkinGachaItemId对应的奖励列表
function M:GetSkinGachaItemLst(SkinGachaItemId)
    local SkinGachaItemData = DataMgr.SkinGachaItem[SkinGachaItemId]
    local Res = {}
    assert(SkinGachaItemData, "抽卡奖励信息不存在:"..SkinGachaItemId)
    for i = 1, #SkinGachaItemData.Type do
        local Content = {}
        Content.Type = SkinGachaItemData.Type[i]
        Content.Id = SkinGachaItemData.Id[i]
        Content.Count = SkinGachaItemData.Count[i]
        Content.Probability = SkinGachaItemData.Probability[i]
        table.insert(Res, Content)
    end
    return Res
end

function M:GetSkinGachaUpInfo(GachaId)
    local GachaInfo = DataMgr.SkinGacha[GachaId]
    assert(GachaInfo, "抽卡信息不存在:"..GachaId)
    local UpItemId, UpItemType, Probaility
    if GachaInfo.RewardUpId then
        UpItemType = GachaCommon.GachaItemTypeMap[GachaInfo.RewardUpType]
        for Id, Data in pairs(GachaInfo.RewardUpId) do
            UpItemId = Id
            Probaility = Data
            break
        end
    end
    return UpItemId, UpItemType, Probaility
end

--- 获取卡池对应的累计抽取奖励信息
---@param GahcaId number 卡池ID
function M:GetSkinGachaCumulativeInfo(GahcaId)
    local GachaCumulativeData = DataMgr.SkinGachaCumulative[GahcaId]
    assert(GachaCumulativeData, "抽卡信息不存在:"..GahcaId)
    local Res = {}
    for i = 1, #GachaCumulativeData.RewardTarget do
        local Content = {}
        Content.RewardTarget = GachaCumulativeData.RewardTarget[i]
        Content.RewardId = GachaCumulativeData.RewardId[i]
        table.insert(Res, Content)
    end
    return Res
end

--- 获取卡池当前可领取累计奖励信息
function M:GetSkinGachaCurrentCumulativeInfo(GachaId)
    local GachaData = self:GetGachaAvatarInfo(GachaId)
    assert(GachaData, "GetSkinGachaCurrentCumulativeInfo当前卡池无效："..GachaId)
    local GachaCumulativeData = DataMgr.SkinGachaCumulative[GachaData.GachaId]
    local Res, NeedCount = nil, 0
    local LastReward
    if not GachaCumulativeData then
        return Res, NeedCount
    end
    for i = 1, #GachaCumulativeData.RewardTarget do
        if GachaData.DrawCounts >= GachaCumulativeData.RewardTarget[i] and not GachaData.CumulativeRewardGot:HasElement(i) then
            Res = GachaCumulativeData.RewardId[i]
            return Res, NeedCount
        end
        if GachaData.DrawCounts < GachaCumulativeData.RewardTarget[i] then
            Res = GachaCumulativeData.RewardId[i]
            NeedCount = GachaCumulativeData.RewardTarget[i] - GachaData.DrawCounts
            return Res, NeedCount
        end
        if i == #GachaCumulativeData.RewardTarget then
            LastReward = GachaCumulativeData.RewardId[i]
        end
    end
    return Res, NeedCount, LastReward
end

--- 获取当前是否有卡池存在可领的累抽奖励
function M:GetALlSkinGachaCurrentCumulativeInfo()
    local GachaTabInfo = self:GetGachaTabInfo()
    if GachaTabInfo then
        for _, GachaTabData in ipairs(GachaTabInfo) do
            for _, GachaId in ipairs(GachaTabData.GachaIdLst) do
                local RewardId, Count = self:GetSkinGachaCurrentCumulativeInfo(GachaId)
                if RewardId then
                    return true
                end
            end
        end
    end
    return false
end

--- 获取卡池对应离上次Up已抽次数
function M:GetSkinGachaAlreadyTimes(GachaType)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return 0
    end

    if not Avatar.GuaranteedDict.Guaranteed5StarDict then
        return 0
    end
    local GuaranteedCount = Avatar.GuaranteedDict.Guaranteed5StarDict[GachaType]

    return GuaranteedCount or 0
end

--- 检查是否能进行本次抽卡
---@param GachaId number 抽卡ID
---@param GachaCounts number 抽卡次数
---@return number 0:可抽卡 1：物品不足  2：卡池开启条件不满足
function M:CheckCanGacha(GachaId, GachaCounts, bShowError)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return -1
    end
    local GachaInfo = DataMgr.SkinGacha[GachaId]
    assert(GachaInfo, "CheckCanGacha传入了无效的GachaId："..GachaId)
    if not ConditionUtils.CheckCondition(Avatar, GachaInfo.ConditionId, false) then
        return 2
    end
    local ResourceCount = 0
    for _, ResourceId in ipairs(GachaInfo.GachaCostRes) do
        ResourceCount = ResourceCount + Avatar:GetResourceNum(ResourceId)
    end
    local res = ResourceCount >= GachaCounts
    if not res then
        if bShowError then
            UIManager(self):ShowUITip("CommonToastMain", GText("UI_SkinGacha_CostRes_Lack"), 1.5)
        end
        return 1
    end
    return 0
end

function M:CheckReddot(GachaReddotNode)
    local GachaTabInfoLst = self:GetGachaTabInfo()
    local GachaInfo = self:GetEffectiveGachaInfo()

    for _, GachaData in ipairs(GachaTabInfoLst) do
        local GacahTabData = DataMgr.SkinGachaTab[GachaData.TabId]
        if GacahTabData and GacahTabData.ReddotNode then
            local NodeName = GacahTabData.ReddotNode
            local Node = nil
            if GachaReddotNode and GachaReddotNode.Name == NodeName then
                Node = GachaReddotNode
            else
                Node = ReddotManager.GetTreeNode(NodeName)
            end

            if Node then
                if Node.Count > 0 then
                    Node:DecreaseCount(Node.Count)
                end
                if GachaInfo[GachaData.TabId] then
                    local RewardId, NeedCount = self:GetSkinGachaCurrentCumulativeInfo(GachaData.GachaIdLst[1])
                    if RewardId and NeedCount <= 0 then
                        Node:IncreaseCount(1)
                    end
                end
            end
        end
	end
end

--- 检查并刷新卡池的New状态
function M:CheckNew(GachaNewNode)
    local GachaNewNodeName = DataMgr.ReddotNode.Gacha_New.Name
    local Node = GachaNewNode or ReddotManager.GetTreeNode(GachaNewNodeName)
    if not Node then
        return
    end

    local GachaTabInfoLst = self:GetGachaTabInfo()
    local GachaInfo = self:GetEffectiveGachaInfo()
    local newCount = 0
    for _, GachaData in ipairs(GachaTabInfoLst) do
        if GachaInfo[GachaData.TabId] then
            for _, GachaId in ipairs(GachaInfo[GachaData.TabId]) do
                if self:IsGachaNew(GachaId) then
                    newCount = newCount + 1
                end
            end
        end
    end

    if Node.Count > 0 then
        Node:DecreaseCount(Node.Count)
    end
    if newCount > 0 then
        Node:IncreaseCount(newCount)
    end
end

--- 检查指定卡池是否为新
---@param GachaId number 卡池ID
---@return boolean true代表是新的
function M:IsGachaNew(GachaId)
    if not GachaId then return false end
    local GachaKey = string.format("Gacha%dOpened", GachaId)
    local GachaNewCache = EMCache:Get(GachaKey, true)
    return GachaNewCache == nil
end

--- 将指定卡池标记为已打开
---@param GachaId number 卡池ID
function M:MarkGachaAsOpened(GachaId)
    if not GachaId then return end
    local GachaKey = string.format("Gacha%dOpened", GachaId)
    EMCache:Set(GachaKey, true, true)
end

function M:UpdateGachaBtnComplex(Btn, CostNum, TimeLimitCount, ShowResourceCount, ShowResourceId, TimeLimitResourceId)
    Btn.HB_Combination:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local IconPath = ItemUtils.GetItemIconPath(ShowResourceId, "Resource")
    if IconPath then
        Btn.Icon_Currency.Icon = IconPath
        Btn.Icon_Currency:SetIcon()
    end

    if Btn.Text_Price then
        Btn.Text_Price:SetText(tostring(CostNum - TimeLimitCount))
    end

    local IconPath = ItemUtils.GetItemIconPath(TimeLimitResourceId, "Resource")
    if IconPath then
        Btn.Icon_Currency_Combination.Icon = IconPath
        Btn.Icon_Currency_Combination:SetIcon()
    end

    if Btn.Text_Price_Combination then
        Btn.Text_Price_Combination:SetText(tostring(TimeLimitCount))
    end
end

--- 更新抽卡按钮价格显示（主价格）
function M:UpdateGachaBtnPrice(Btn, CostNum, TimeLimitResourceCount, ShowResourceId, TimeLimitResourceId)
    if Btn.HB_Combination then
        Btn.HB_Combination:SetVisibility(ESlateVisibility.Collapsed)
    end
    local ResourceId = (TimeLimitResourceCount > 0) and TimeLimitResourceId or ShowResourceId
    
    if Btn.Icon_Currency then
        local IconPath = ItemUtils.GetItemIconPath(ResourceId, "Resource")
        if IconPath then
            Btn.Icon_Currency.Icon = IconPath
            Btn.Icon_Currency:SetIcon()
        end
    end
    
    -- 设置价格文本
    if Btn.Text_Price then
        Btn.Text_Price:SetText(tostring(CostNum))
    end
    
    -- 默认隐藏划线价格
    if Btn.Text_Undiscounted_Price then
        Btn.Text_Undiscounted_Price:SetVisibility(ESlateVisibility.Collapsed)
    end
end


return M

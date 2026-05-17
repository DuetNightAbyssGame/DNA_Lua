
local WalnutBagCommon = require "BluePrints.UI.WBP.Walnut.WalnutBag.WalnutBagCommon"
local TimeUtils = require "Utils.TimeUtils"

local M = Class("BluePrints.Common.MVC.Model")

function M:Init()
    M.Super.Init(self)
    self._WalnutList = nil
    self._Avatar = nil
    self:GetAvatar()
    self:InitWalnutBagReddotNode()
end

function M:Destory()
    M.Super.Destory(self)
end

function M:GetAllWalnutDict(TypeId, KeyWords, IsShowNotHave)
    self._WalnutList = {}
    -- 获取特定核桃内容
    local WalnutDataTable = DataMgr.Walnut
    local GlobalReleaseVersion = DataMgr.GlobalConstant["CurrentVersion"].ConstantValue
    for ItemId, WalnutConfigData in pairs(WalnutDataTable) do
        if (TypeId == 0 or TypeId == WalnutConfigData.WalnutType) then
            if WalnutConfigData.ReleaseVersion > GlobalReleaseVersion then
                -- 低于当前版本的不显示
                goto continue
            end
            local WalnutCount = self:GetWalnutCountById(ItemId)
            local IsSearchConditionMet = true
            if (KeyWords) then
                local SearchList = self:GetSearchConditionList(WalnutConfigData)
                IsSearchConditionMet = CommonUtils.CheckFuzzySearchWithSinglePhase(SearchList, KeyWords, false)
            end
            if (IsSearchConditionMet) then
                if (IsShowNotHave) then
                    if (WalnutCount <= 0) then
                        table.insert(self._WalnutList, {Id = ItemId, Rarity=WalnutConfigData.Rarity, Count = WalnutCount})
                    end
                else
                    table.insert(self._WalnutList, {Id = ItemId, Rarity=WalnutConfigData.Rarity, Count = WalnutCount})
                end
            end
            ::continue::
        end
    end
    return self._WalnutList
end

function M:GetSearchConditionList(WalnutConfigData)
    -- 名称添加
    local SearchList = {GText(WalnutConfigData.Name)}
    -- 奖励名称添加
    for i = 1, WalnutBagCommon.MaxRewardCount do
        local RewardId = WalnutConfigData["Id"][i]
        local RewardType = WalnutConfigData["Type"][i]
        local RewardDataTable = DataMgr[RewardType]
        if (RewardDataTable) then
            local RewardConfigData = RewardDataTable[RewardId]
            if (RewardConfigData) then
                local Name = nil
                if (RewardType == "Draft") then
                    local ProductType = RewardConfigData.ProductType
                    local ProductId = RewardConfigData.ProductId
                    local ProductData = DataMgr[ProductType][ProductId]
                    Name = ProductData.Name or ProductData[ProductType.."Name"]
                else
                    Name = RewardConfigData.Name or RewardConfigData[RewardType.."Name"]
                end
                if (Name) then
                    table.insert(SearchList, GText(Name))
                end
            else
                DebugPrint("WalnutBag GetSearchConditionList Error, not find item in DataTable, RewardId is", RewardId)
            end
        else
            DebugPrint("WalnutBag GetSearchConditionList Error, DataTable is nil, RewardInfo is", RewardType, RewardId)
        end
    end
    -- 途径匹配添加
    local AccessKey = WalnutConfigData.AccessKey or {}
    for index, value in ipairs(AccessKey) do
        local AccesssDataTable = DataMgr.Access[value]
        if (AccesssDataTable) then
            local AccesssName = GText(AccesssDataTable.AccessText)
            table.insert(SearchList, AccesssName)
        end
    end
    return SearchList
end

--region Avatar数据相关
---@return table<number,number>
function M:GetHaveWalnutDict()
    return self:GetAvatar().Walnuts.WalnutBag
end

function M:GetDungeonNextRefreshTime()
    local LastRefreshTime = self:GetAvatar().Walnuts.WalnutLastRefreshTime
    if (LastRefreshTime == nil) then
        LastRefreshTime = TimeUtils.NowTime()
    end
    return LastRefreshTime + DataMgr.GlobalConstant.WalnutRefreshCD.ConstantValue * 60 * 60
end

function M:GetWalnutCountById(ItemId)
    if (self:GetAvatar().Walnuts.WalnutBag == nil) then
        return 0
    end
    return self:GetAvatar().Walnuts.WalnutBag[ItemId] or 0
end

function M:CheckIsNeedShowNewDot(ItemId)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(WalnutBagCommon.ReddotName)
    if (CacheDetail[ItemId] ~= nil and CacheDetail[ItemId].IsRead == false) then
        return true
    end
    return false
end

function M:GetAllNewItemsId()
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(WalnutBagCommon.ReddotName)
    local ResultList = {}
    for ItemId, ItemInfo in pairs(CacheDetail) do
        if (ItemInfo.IsRead == false) then
            local WalnutConfigData = DataMgr.Walnut[ItemId]
            if (WalnutConfigData ~= nil) then
                if (ResultList[WalnutConfigData.WalnutType] == nil) then
                    ResultList[WalnutConfigData.WalnutType] = {ItemId}
                else
                    table.insert(ResultList[WalnutConfigData.WalnutType], ItemId)
                end
            end
        end
    end
    return ResultList
end

function M:GetWalnutConsumeRecordById(ItemId)
    if (self:GetAvatar().Walnuts.ConsumeRecord == nil) then
        return 0
    end
    return self:GetAvatar().Walnuts.ConsumeRecord[ItemId] or 0
end
---#endregion

--region 红点树相关
function M:InitWalnutBagReddotNode()
	local Node = ReddotManager.GetTreeNode(WalnutBagCommon.ReddotName)
    if not Node then
        Node = ReddotManager.AddNode(WalnutBagCommon.ReddotName,nil,1)
    end
    ReddotManager.ClearLeafNodeCount(WalnutBagCommon.ReddotName)
	local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(WalnutBagCommon.ReddotName)
	local PlayerAvatar = self:GetAvatar()
	if PlayerAvatar and PlayerAvatar.Walnuts.WalnutBag then
        local WalnutBagServerData = PlayerAvatar.Walnuts.WalnutBag
		for ItemId, Count in pairs(WalnutBagServerData) do
            if (Count > 0 and CacheDetail[ItemId] == nil) then
                -- 新获得
                CacheDetail[ItemId] = {IsRead=false}
                ReddotManager.IncreaseLeafNodeCount(WalnutBagCommon.ReddotName)
            end
		end
	end
end

function M:AddReddotCount(ItemId)
    if (ItemId == nil) then
        return
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(WalnutBagCommon.ReddotName)

    if (CacheDetail[ItemId] == nil) then
        CacheDetail[ItemId] = {IsRead=false}
        ReddotManager.IncreaseLeafNodeCount(WalnutBagCommon.ReddotName)
    end
end

function M:RemoveReddotCount(ItemId)
    if (ItemId == nil) then
        return
    end
    local ReddotNode = ReddotManager.GetTreeNode(WalnutBagCommon.ReddotName)

    -- if (ReddotNode.Count == 0) then return end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(WalnutBagCommon.ReddotName)

    if (CacheDetail[ItemId] ~= nil) then
        CacheDetail[ItemId].IsRead = true
        if (ReddotNode.Count > 0) then 
            ReddotManager.DecreaseLeafNodeCount(WalnutBagCommon.ReddotName)
        end
    end
end

function M:ClearReddotCount()
    --重置数量到1再减一是为了能够触发红点事件
    local ReddotNode = ReddotManager.GetTreeNode(WalnutBagCommon.ReddotName)
    if (ReddotNode.Count == 0) then return end
    if not ReddotNode then return end
    ReddotNode.Count = 1
    ReddotManager.DecreaseLeafNodeCount(WalnutBagCommon.ReddotName)
end
---#endregion

function M:GetWalnutStuffData(StuffServerData, ParentWidget, ClickCallback)
    local Avatar = self:GetAvatar()
    if (Avatar == nil) then return end
    local WalnutInfo = DataMgr.Walnut[StuffServerData.Id]
    if not WalnutInfo.ResourceToCoinType or not WalnutInfo.ResourceValue then
        return false
    end
    local StuffConfig = {}
    StuffConfig.Uuid = tostring(StuffServerData.Id)                               -- 唯一ID，Walnut应该不需要这个ID(就暂时设置成ResourceId)
    StuffConfig.StuffId = StuffServerData.Id
    StuffConfig.StuffCount = StuffServerData.Count
    StuffConfig.StuffType = "Walnut"
    StuffConfig.StuffName = WalnutInfo.Name
    StuffConfig.StuffIcon = WalnutInfo.Icon     
    StuffConfig.CoinId = WalnutInfo.ResourceToCoinType
    StuffConfig.Price = WalnutInfo.ResourceValue
    StuffConfig.ClickCallback = ClickCallback or "ClickStuffIcon"
    StuffConfig.NeedRedPoint = false
    StuffConfig.LockType = 0 -- 暂定
    StuffConfig.Rarity = DataMgr.Walnut[StuffServerData.Id].Rarity or 1
    -- StuffConfig.UseEffectType = ItemConfigData.UseEffectType
    -- StuffConfig.IsPhantom = ItemConfigData.ResourceSType == "PhantomItem"
    StuffConfig.ParentWidget = ParentWidget
    return StuffConfig
end

function M:CreateBagItemContent(Content)
     if(Content == nil)then
        return
    end
    local StuffObj = NewObject(UIUtils.GetCommonItemContentClass())
    StuffObj.Uuid = Content.Uuid
    StuffObj.Type = Content.StuffType
    StuffObj.GridIndex = Content.GridIndex
    StuffObj.StuffId = Content.StuffId
    StuffObj.UnitId = Content.StuffId
    StuffObj.ItemType = Content.StuffType
    StuffObj.StuffType = Content.StuffType
    StuffObj.Count = Content.StuffCount
    StuffObj.Icon = Content.StuffIcon
    StuffObj.StuffName = Content.StuffName
    StuffObj.ClickCallback = Content.ClickCallback
    StuffObj.NeedRedPoint = Content.NeedRedPoint
    StuffObj.IsSelect = Content.IsSelect
    StuffObj.LockType = Content.LockType
    -- StuffObj.Level = Content.Level
    StuffObj.Rarity = Content.Rarity
    StuffObj.Price = Content.Price
    StuffObj.CoinId = Content.CoinId
    -- StuffObj.bInGear = Content.IsEquipped
    StuffObj.StateTagInfo = Content.StateTagInfo
    StuffObj.bDisableCommonClick = Content.bDisableCommonClick
    -- StuffObj.AttrIcon = Content.AttrIcon
    -- StuffObj.IsPhantom = Content.IsPhantom
    -- StuffObj.AssisterId = Content.AssisterId
    -- StuffObj.LevelCardNum = Content.GradeLevel
    -- StuffObj.AnimNameWithCreate = Content.AnimNameWithCreate
    local StuffObjType = StuffObj.Type
    if (Content.ParentWidget) then
        StuffObj.ParentWidget = Content.ParentWidget
    end
    return StuffObj
end

return M

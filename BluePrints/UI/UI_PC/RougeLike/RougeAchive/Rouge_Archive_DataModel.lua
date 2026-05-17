---@class ManualData
---@field Type number 图鉴数据类型
---@field Name string 图鉴名称
---@field TotalNum number 图鉴内元素总数
---@field UnlockedNum number 已解锁元素数量
---@field HasNew boolean 是否有新元素
---@field Data table<number, table> 图鉴具体数据


require "UnLua"
local RougeConst = require "BluePrints.UI.UI_PC.RougeLike.RougeAchive.RougeConst"
local ForgeConst = require "Blueprints.UI.Forge.ForgeConst"
local EMCache = require "EMCache.EMCache"
local DataModel = {}

function DataModel:InitData(InAvatar)
    self.Avatar = InAvatar
    self.LocalUnlockedManuals = EMCache:Get("UnlockedManuals", true) or {}
    
    ---@type table<number, ManualData>
    self.Manuals = {}

    -- 初始化 Treasure
    local TotalNum = 0
    local UnlockedNum = 0
    local HasNew = false 
    self.Manuals[RougeConst.ArchiveType.Treasure] = {Data = {}}
    for _, TreasureData in pairs(DataMgr.RougeLikeTreasure) do 
        if not TreasureData.RLArchiveId then
            goto continue
        end
        local bIsUnlocked = self.Avatar.RougeLike:IsManualUnlocked(RougeConst.ArchiveType.Treasure, TreasureData.TreasureId)
        local bIsNew = bIsUnlocked and self:CheckArchiveItemIsNew(RougeConst.ArchiveType.Treasure, TreasureData.TreasureId)
        self.Manuals[RougeConst.ArchiveType.Treasure].Data[TreasureData.TreasureId] = {
            Data = TreasureData,
            IsUnlocked = bIsUnlocked,
            IsNew = bIsNew,
        }
        TotalNum = TotalNum + 1
        UnlockedNum = UnlockedNum + (self.Manuals[RougeConst.ArchiveType.Treasure].Data[TreasureData.TreasureId].IsUnlocked and 1 or 0)
        HasNew = HasNew or bIsNew

        ::continue::
    end
    self.Manuals[RougeConst.ArchiveType.Treasure].Type = RougeConst.ArchiveType.Treasure
    self.Manuals[RougeConst.ArchiveType.Treasure].Name = GText("UI_RLArchiveTitle_Treasure")
    self.Manuals[RougeConst.ArchiveType.Treasure].TotalNum = TotalNum
    self.Manuals[RougeConst.ArchiveType.Treasure].UnlockedNum = UnlockedNum
    self.Manuals[RougeConst.ArchiveType.Treasure].HasNew = HasNew
    if HasNew then
        self:IncreaseArchiveTypeReddot(RougeConst.ArchiveType.Treasure)
    end

    -- 初始化 Blessing 
    TotalNum = 0
    UnlockedNum = 0
    HasNew = false 
    self.Manuals[RougeConst.ArchiveType.Blessing] = {Data = {}}
    for _, BlessingData in pairs(DataMgr.RougeLikeBlessing) do 
        if not BlessingData.RLArchiveId then
            goto continue
        end
        local bIsUnlocked = self.Avatar.RougeLike:IsManualUnlocked(RougeConst.ArchiveType.Blessing, BlessingData.BlessingId)
        local bIsNew = bIsUnlocked and self:CheckArchiveItemIsNew(RougeConst.ArchiveType.Blessing, BlessingData.BlessingId)
        self.Manuals[RougeConst.ArchiveType.Blessing].Data[BlessingData.BlessingId] = {
            Data = BlessingData,
            IsUnlocked = bIsUnlocked,
            IsNew = bIsNew,
        }
        TotalNum = TotalNum + 1
        UnlockedNum = UnlockedNum + (self.Manuals[RougeConst.ArchiveType.Blessing].Data[BlessingData.BlessingId].IsUnlocked and 1 or 0)
        HasNew = HasNew or bIsNew

        ::continue::
    end
    self.Manuals[RougeConst.ArchiveType.Blessing].Type = RougeConst.ArchiveType.Blessing
    self.Manuals[RougeConst.ArchiveType.Blessing].Name = GText("UI_RLArchiveTitle_Blessing")
    self.Manuals[RougeConst.ArchiveType.Blessing].TotalNum = TotalNum
    self.Manuals[RougeConst.ArchiveType.Blessing].UnlockedNum = UnlockedNum
    self.Manuals[RougeConst.ArchiveType.Blessing].HasNew = HasNew
    if HasNew then
        self:IncreaseArchiveTypeReddot(RougeConst.ArchiveType.Blessing)
    end

    -- 初始化 Room
    TotalNum = 0
    UnlockedNum = 0
    HasNew = false 
    self.Manuals[RougeConst.ArchiveType.Event] = {Data = {}}
    for _, RoomData in pairs(DataMgr.RLRoomStorySeries) do
        if RoomData.RLArchiveType == RougeConst.RLArchiveType.Event then
            local bIsUnlocked = self.Avatar.RougeLike:IsManualUnlocked(RougeConst.ArchiveType.Event, RoomData.RLArchiveSubId)
            local bIsNew = bIsUnlocked and self:CheckArchiveItemIsNew(RougeConst.ArchiveType.Event, RoomData.RLArchiveSubId)
            self.Manuals[RougeConst.ArchiveType.Event].Data[RoomData.RLArchiveSubId] = {
                Data = RoomData,
                IsUnlocked = bIsUnlocked,
                IsNew = bIsNew,
            }
            TotalNum = TotalNum + 1
            UnlockedNum = UnlockedNum + (self.Manuals[RougeConst.ArchiveType.Event].Data[RoomData.RLArchiveSubId].IsUnlocked and 1 or 0)
            HasNew = HasNew or bIsNew
        end
    end
    self.Manuals[RougeConst.ArchiveType.Event].Type = RougeConst.ArchiveType.Event
    self.Manuals[RougeConst.ArchiveType.Event].Name = GText("UI_RLArchiveTitle_Event")
    self.Manuals[RougeConst.ArchiveType.Event].TotalNum = TotalNum
    self.Manuals[RougeConst.ArchiveType.Event].UnlockedNum = UnlockedNum
    self.Manuals[RougeConst.ArchiveType.Event].HasNew = HasNew
    if HasNew then
        self:IncreaseArchiveTypeReddot(RougeConst.ArchiveType.Event)
    end

    -- 初始化 Story 
    TotalNum = 0
    UnlockedNum = 0
    HasNew = false 
    self.Manuals[RougeConst.ArchiveType.Story] = {Data = {}}
    for _, StoryData in pairs(DataMgr.RLRoomStorySeries) do 
        if StoryData.RLArchiveType == RougeConst.RLArchiveType.Story then
            local bIsUnlocked = self.Avatar.RougeLike:IsManualUnlocked(RougeConst.ArchiveType.Story, StoryData.RLArchiveSubId)
            local bIsNew = bIsUnlocked and self:CheckArchiveItemIsNew(RougeConst.ArchiveType.Story, StoryData.RLArchiveSubId)
            self.Manuals[RougeConst.ArchiveType.Story].Data[StoryData.RLArchiveSubId] = {
                Data = StoryData,
                IsUnlocked = bIsUnlocked,
                IsNew = bIsNew,
            }
            TotalNum = TotalNum + 1
            UnlockedNum = UnlockedNum + (self.Manuals[RougeConst.ArchiveType.Story].Data[StoryData.RLArchiveSubId].IsUnlocked and 1 or 0)
            HasNew = HasNew or bIsNew
        end
    end
    self.Manuals[RougeConst.ArchiveType.Story].Type = RougeConst.ArchiveType.Story
    self.Manuals[RougeConst.ArchiveType.Story].Name = GText("UI_RLArchiveTitle_Story")
    self.Manuals[RougeConst.ArchiveType.Story].TotalNum = TotalNum
    self.Manuals[RougeConst.ArchiveType.Story].UnlockedNum = UnlockedNum
    self.Manuals[RougeConst.ArchiveType.Story].HasNew = HasNew
    if HasNew then
        self:IncreaseArchiveTypeReddot(RougeConst.ArchiveType.Story)
    end
end

function DataModel:GetArchiveDataByArchiveType(ArchiveType)
    return self.Manuals[ArchiveType]
end

-- 获取已解锁的图鉴数量
function DataModel:GetUnlockedItemNum(Type)
    local Avatar = GWorld:GetAvatar()
    local AvatarManuals = Avatar.RougeLike.Manual
    local UnlockedNum = 0
    if not Type then 
        for TypeName, TypeId in pairs(RougeConst.ArchiveType) do
            local Manual = AvatarManuals:Get(TypeId)
            if Manual then 
                UnlockedNum = UnlockedNum + Manual:Length()
            end
        end
    else
        local Manual = AvatarManuals:Get(Type)
        if Manual then 
            UnlockedNum = Manual:Length()
        end
    end
    return UnlockedNum
end

-- 获取全部图鉴数量
function DataModel:GetTotalItemNum(Type)
    local TotalNum = 0
    if not Type then 
        for _, ManualData in pairs(self.Manuals) do
            TotalNum = TotalNum + ManualData.TotalNum
        end
    else 
        TotalNum = self.Manuals[Type].TotalNum
    end
    return TotalNum
end


-- 检查某个图鉴物品是否是新的
function DataModel:CheckArchiveItemIsNew(ArchiveType, ArchiveId)
    local LocalUnlockedManuals = EMCache:Get("UnlockedManuals", true) or {}
    return not (LocalUnlockedManuals[ArchiveType] and LocalUnlockedManuals[ArchiveType][ArchiveId])
end

-- 标记某个图鉴物品已经看过了
-- @param ArchiveId 如果传，标记特定Id；若不传，标记所有已解锁的
function DataModel:MarkArchiveItemSeened(ArchiveType, ArchiveId)
    self.LocalUnlockedManuals[ArchiveType] = self.LocalUnlockedManuals[ArchiveType] or {}
    if ArchiveId then 
        self.LocalUnlockedManuals[ArchiveType][ArchiveId] = true
    else 
        for Id, ManualData in pairs(self.Manuals[ArchiveType].Data) do
            if ManualData.IsUnlocked then
                self.LocalUnlockedManuals[ArchiveType][Id] = true
            end 
        end
    end

    self.Manuals[ArchiveType].Data[ArchiveId].IsNew = false

    EMCache:Set("UnlockedManuals", self.LocalUnlockedManuals, true)
end

-- 设置红点树节点
function DataModel:IncreaseArchiveTypeReddot(ArchiveType)
    local TreeNodeName = RougeConst.RougeReddotTreeNode[ArchiveType]
    local TreeNode = ReddotManager.GetTreeNode(TreeNodeName)
    if not ReddotManager.GetTreeNode(TreeNodeName) then
        TreeNode = ReddotManager.AddNode(TreeNodeName)
    end
    if TreeNode and TreeNode.Count >= 1 then return end 
    ReddotManager.IncreaseLeafNodeCount(TreeNodeName, 1)
end

-- 获得某种图鉴类型的奖励数量
function DataModel:GetArchiveRewardNumByArchiveType(ArchiveType)
    local ArchiveStep = DataMgr.RLArchiveInfo[ArchiveType].RLArchiveStep
    local TotalNum = self:GetUnlockedItemNum(ArchiveType)
    return TotalNum // ArchiveStep
end

-- 获得某种图鉴类型，可领取的奖励数量
function DataModel:GetCanReceiveArchiveRewardNumByArchiveType(ArchiveType)
    local Num=0
    local Avatar = GWorld:GetAvatar()
    local ManualRewardGot = Avatar.RougeLike.ManualRewardGot:Get(ArchiveType)
    local TotalRewardNum = self:GetArchiveRewardNumByArchiveType(ArchiveType)
    for i = 1, TotalRewardNum do
        if ManualRewardGot then 
            if not ManualRewardGot:HasElement(i) then 
                Num=Num+1
            end
        else
            Num=Num+1
        end
    end
    return Num
end

-- 获得某种图鉴类型，可领取的奖励列表
function DataModel:GetArchiveRewardByArchiveType(ArchiveType)
    local Avatar = GWorld:GetAvatar()
    local ManualRewardGot = Avatar.RougeLike.ManualRewardGot:Get(ArchiveType)
    local TotalRewardNum = self:GetArchiveRewardNumByArchiveType(ArchiveType)
    local RewardList = {}

    for i = 1, TotalRewardNum do
        if ManualRewardGot then 
            if not ManualRewardGot:HasElement(i) then 
                table.insert(RewardList, i)
            end
        else
            table.insert(RewardList, i)
        end
    end

    return RewardList
end

-- 更新肉鸽奖励红点
function DataModel:UpdateArchiveRewardReddot()
    -- local TotalNum = 0
    -- for TypeName, TypeId in pairs(RougeConst.ArchiveType) do
    --     local ArchiveRewardCanGet = self:GetArchiveRewardByArchiveType(TypeId)
    --     TotalNum = TotalNum + #ArchiveRewardCanGet
    -- end

    -- UIUtils.SetReddotTreeLeafNodeCount("RougeArchiveReward", TotalNum)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local Node = ReddotManager.GetTreeNode("RougeArchiveReward")
    if not Node then
        ReddotManager.AddNode("RougeArchiveReward")
    end
    ReddotManager.ClearLeafNodeCount("RougeArchiveReward")
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("RougeArchiveReward")
    for _,Info in pairs(DataMgr.RLArchiveInfo) do
        local Count = self:GetUnlockedItemNum(Info.RLArchiveType)
        local HasRewardToGet = false
        for i=Info.RLArchiveStep,Count,Info.RLArchiveStep do
            local RewardIdx=i//Info.RLArchiveStep
            if not Avatar.RougeLike:IsManualRewardGot(Info.RLArchiveType,RewardIdx) then
                if not CacheDetail[Info.RLArchiveType] then
                    CacheDetail[Info.RLArchiveType] = {}
                end
                if not CacheDetail[Info.RLArchiveType][RewardIdx] then
                    CacheDetail[Info.RLArchiveType][RewardIdx] = 1
                end
                ReddotManager.IncreaseLeafNodeCount("RougeArchiveReward")
                HasRewardToGet = true
            else
                if CacheDetail and CacheDetail[Info.RLArchiveType] and CacheDetail[Info.RLArchiveType][RewardIdx] then
                    CacheDetail[Info.RLArchiveType][RewardIdx] = nil
                end
            end
        end
        if not HasRewardToGet then
            if CacheDetail and CacheDetail[Info.RLArchiveType] then
                CacheDetail[Info.RLArchiveType] = nil
            end
        end
    end
end

-- 更新肉鸽烛芯、遗物图鉴红点
function DataModel:UpdateArchiveReddot(ArchiveType)
    for Id, ManualData in pairs(self.Manuals[ArchiveType].Data) do
        local IsNew = self:CheckArchiveItemIsNew(ArchiveType, Id)
        if ManualData.IsUnlocked and IsNew then
            return
        end
    end
    ReddotManager.ClearLeafNodeCount(RougeConst.RougeReddotTreeNode[ArchiveType])
end

return DataModel
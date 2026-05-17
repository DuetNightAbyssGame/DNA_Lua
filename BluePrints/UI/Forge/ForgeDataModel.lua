require "UnLua"
local ForgeConst = require "Blueprints.UI.Forge.ForgeConst"
local TimeUtils = require "Utils.TimeUtils"
local CommonFilterUtils = require "Utils.CommonFilterUtils"
local EMCache = require "EMCache.EMCache"

--- @type ForgeModel
local ForgeDataModel = {}
local INF = 9999999999 

local ProductPriority = setmetatable({
    ["Weapon"] = 0,
    ["Mod"] = 1,
    ["Resource"] = 2,
    ["CharAccessory"] = 3,
}, {
    __index = function(ProductPriority, key)
        return #ProductPriority + 1
    end
})

function ForgeDataModel:Initialize()
    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar then return end
    
    -- 读取服务器记录的，已经见过的设计稿，更新到本地缓存
    local HoldDrafts = PlayerAvatar.HoldDrafts or {}
    local SeenDraftIds = EMCache:Get("SeenDraftIds", true) or {}
    for DraftId, _ in pairs(HoldDrafts) do
        SeenDraftIds[DraftId] = true
    end
    EMCache:Set("SeenDraftIds", SeenDraftIds, true)

    self.Drafts = {}
    self:UpdateData()
    self:InitReddotTree()
    EventManager:AddEvent(EventID.OnCompleteProduce, self, self.OnCompleteProduce)
    EventManager:AddEvent(EventID.OnCompleteBatchProduce, self, self.OnCompleteProduce)
    EventManager:AddEvent(EventID.OnBlueComplete, self, self.OnBlueComplete)
    EventManager:AddEvent(EventID.OnGetNewDraft, self, self.OnGetNewDraft)
    EventManager:AddEvent(EventID.OnAccerateProduce, self, self.OnAccerateProduce)
end

function ForgeDataModel:OnCompleteProduce(DraftIds, Ret)
    for DraftId, CompleteNum in pairs(DraftIds) do
        local DraftInfo = self:CheckState(DraftId)
        self:DecreaseReddotByDraftInfo(DraftId)

        -- 还需要单独更新【铸造中】Tab，因为此时该设计稿已经离开了铸造中状态，无法被Filter过滤到
        self:_DecreaseReddotNodeInner(DraftId, ForgeConst.ReddotNodeName[ForgeConst.TabType.Producing])
    end
end

function ForgeDataModel:OnAccerateProduce(DraftId, Ret)
    self:IncreaseReddotByDraftInfo(DraftId)
end

function ForgeDataModel:OnBlueComplete(DraftId)
    self:IncreaseReddotByDraftInfo(DraftId)
end

function ForgeDataModel:OnGetNewDraft(DraftIdTable)
    for _, DraftId in ipairs(DraftIdTable) do
        if self:IsDraftNotSeen(DraftId) then
            if not self.Drafts[DraftId] then 
                local Draft = self:ConstructDraftInfoByDraftId(DraftId)
                self.Drafts[DraftId] = Draft
            end
            self:IncreaseNewdotByDraftInfo(DraftId) 
        end
    end 
end

-- 根据设计稿ID获取设计稿信息
function ForgeDataModel:GetDraftInfoById(DraftId)
    if not self.Drafts[DraftId] then
        local Draft = self:ConstructDraftInfoByDraftId(DraftId)
        self.Drafts[DraftId] = Draft
    end
    return self.Drafts[DraftId]
end

-- 移除对应ID的设计稿
function ForgeDataModel:RemoveDraftInfoById(DraftId)
    self.Drafts[DraftId] = nil
end

function ForgeDataModel:OnDraftStartProduce(DraftId)
end

function ForgeDataModel:OnDraftCompleteProduce(DraftId)
end

function ForgeDataModel:OnDraftCompleteBatchProduce(DraftId)
end

function ForgeDataModel:OnDraftCancelProduce(DraftId)
end

function ForgeDataModel:ConstructDraftInfoByDraftId(DraftId)
    local PlayerAvatar = GWorld:GetAvatar() 
    if PlayerAvatar.Drafts and PlayerAvatar.Drafts[DraftId] then 
        return self:ConstructDraftInfoByServerDraftData(DraftId, PlayerAvatar.Drafts[DraftId])
    end

    return nil
end

function ForgeDataModel:ConstructDraftInfoByServerDraftData(DraftId, Data)
    local Draft = {}
    Draft.Id = DraftId                      -- 设计稿ID
    Draft.Count = Data.Count                -- 设计稿数量
    Draft.IsInfinity = Data.IsInfinity      -- 数量是否无限
    Draft.ProductName = Data.Name           -- 设计稿产物名称
    Draft.ProductId = Data.ProductId        -- 设计稿产物ID
    Draft.ProductNum = Data.ProductNum      -- 产物数量
    Draft.ProductType = Data.ProductType    -- 设计稿产物类型
    Draft.CostTime = Data.Time * 60         -- 锻造需要花费时间 (单位：秒)
    Draft.TotalTime = Draft.CostTime
    Draft.StartTime = Data.StartTime        -- 服务端开始锻造的时间戳
    Draft.State = Data.State                -- 设计稿目前状态: 0 代表未制作, 1 代表制作中, 2 代表制作完成
    if Draft.State ~= 0 then                -- 制作中的情况
        Draft.DraftDoingNum = Data.DraftDoingNum
        Draft.DraftCompleteNum = Data.DraftCompleteNum
        Draft.TotalTime = Draft.CostTime * (Draft.DraftDoingNum + Draft.DraftCompleteNum)
    end
    Draft.FoundryCost = Data.FoundryCost    -- 设计稿花费
    Draft.IsSetTarget = self:IsDraftSetTarget(DraftId)  -- 是否设为目标
    Draft.IsNotSeen = self:IsDraftNotSeen(DraftId)      -- 是否第一次见(显示New红点)
    Draft.TabType = DataMgr.DraftId2TabAndSubTab[DraftId].TabType  -- 设计稿所属Tab类型
    Draft.SubTabType = DataMgr.DraftId2TabAndSubTab[DraftId].SubTabType  -- 设计稿所属SubTab类型
    Draft.TypePriority = DataMgr.RewardType[Draft.ProductType].DungeonRewardSeq
    local DraftConfigData = DataMgr.Draft[Draft.Id]
    Draft.Rarity = ItemUtils.GetItemRarity(Draft.ProductId, Draft.ProductType)

    -- 需要的资源Id和数量
    Draft.Resources = {}
    if DraftConfigData.Resource then 
        for _, Res in ipairs(DraftConfigData.Resource) do 
            table.insert(Draft.Resources, {Id = Res.Id, Num = Res.Num, Type = Res.Type or "Resource"})
            if Res.Type == "Mod" then 
                Draft.ModAsMaterial = true
            end 
        end
    end

    -- 需要的货币Id和数量
    Draft.Foundries = {}
    if DraftConfigData.FoundryCost then 
        for FoundryId, FoundryCost in pairs(DraftConfigData.FoundryCost) do 
            Draft.Foundries[FoundryId] = FoundryCost
        end
    end

    return Draft
end

function ForgeDataModel:UpdateData()
    local PlayerAvatar = GWorld:GetAvatar()
    self.ServerData = PlayerAvatar.Drafts    -- 服务器返回的设计图数据
    self.Drafts = self.Drafts or {}          -- 客户端的设计图数据集合
    for DraftId, Data in pairs(self.ServerData) do
        if not self.Drafts[DraftId] then 
            local Draft = self:ConstructDraftInfoByServerDraftData(DraftId, Data)
            self.Drafts[DraftId] = Draft
            self:CheckState(DraftId)
        else
            self:CheckState(DraftId)
        end
    end
end

function ForgeDataModel:InitReddotTree()
    -- 首先把New红点树构造出来
    local NewdotTabNode = {}
    for _, TabType in pairs(ForgeConst.TabType) do
        -- 先构造SubTab叶子节点
        local ChildNodes = {}
        for _, SubTabType in ipairs(ForgeConst.TabType2SubTabType[TabType] or {}) do
            local SubTabNewdotNodeName = ForgeConst.NewdotNodeName[SubTabType]
            ReddotManager.AddNodeEx(SubTabNewdotNodeName, nil, 1, UE4.EReddotType.New)
            ReddotManager.ClearLeafNodeCount(SubTabNewdotNodeName, true)
            ChildNodes[SubTabNewdotNodeName] = {}
        end
        local IsLeaf = ForgeConst.TabType2SubTabType[TabType] == nil
        ReddotManager.AddNodeEx(ForgeConst.NewdotNodeName[TabType], not IsLeaf and ChildNodes or nil, 1, IsLeaf and UE4.EReddotType.New or nil)
        if not ForgeConst.TabType2SubTabType[TabType] then
            ReddotManager.ClearLeafNodeCount(ForgeConst.NewdotNodeName[TabType], true)
        end
        NewdotTabNode[ForgeConst.NewdotNodeName[TabType]] = {}
    end
    local NewdotRoot = ReddotManager.AddNodeEx(ForgeConst.NewdotNodeName["Root"], NewdotTabNode, 1)

    -- 开始构造普通红点
    local ReddotTabNode = {}
    for _, TabType in pairs(ForgeConst.TabType) do
        -- 先构造SubTab叶子节点
        local ChildNodes = {}
        for _, SubTabType in ipairs(ForgeConst.TabType2SubTabType[TabType] or {}) do
            local SubTabNodeName = ForgeConst.ReddotNodeName[SubTabType]
            ReddotManager.AddNodeEx(SubTabNodeName, nil, 1, UE4.EReddotType.Normal)
            ReddotManager.ClearLeafNodeCount(SubTabNodeName, true)
            ChildNodes[SubTabNodeName] = {}
        end
        local IsLeaf = ForgeConst.TabType2SubTabType[TabType] == nil
        ReddotManager.AddNodeEx(ForgeConst.ReddotNodeName[TabType], not IsLeaf and ChildNodes or nil, 1, IsLeaf and UE4.EReddotType.Normal or nil)
        if not ForgeConst.TabType2SubTabType[TabType] then
            ReddotManager.ClearLeafNodeCount(ForgeConst.ReddotNodeName[TabType], true)
        end
        ReddotTabNode[ForgeConst.ReddotNodeName[TabType]] = {}
    end
    local ReddotRoot = ReddotManager.AddNodeEx(ForgeConst.ReddotNodeName["Root"], ReddotTabNode, 1)

    -- 为普通红点树填充数据
    for DraftId, Data in pairs(self.ServerData) do
        local Draft = self:CheckState(DraftId)
        if Draft then
            if self:IsDraftNotSeen(DraftId) then
                self:IncreaseNewdotByDraftInfo(DraftId)
            end

            if Draft.State == ForgeConst.DraftState.Complete then
                self:IncreaseReddotByDraftInfo(DraftId)
            end
        end
    end

    ReddotManager.PrintNodeTree(ForgeConst.NewdotNodeName["Root"])
    ReddotManager.PrintNodeTree(ForgeConst.ReddotNodeName["Root"])

    -- 铸造转化功能的红点逻辑
    ReddotManager.AddNodeEx("ForgeConvert", nil, 1, UE4.EReddotType.New)
    local ForgeConvertReddotNode = ReddotManager.GetTreeNode("ForgeConvert")
    local ConvertReddotDetails = ForgeConvertReddotNode.Cache.Detail
    local ConvertData = DataMgr.Convert
    if ConvertData then
        for Id, _ in pairs(ConvertData) do
            local bIsNew = true
            for _, Details in pairs(ConvertReddotDetails) do
                if Id == Details.Id then
                    bIsNew = false
                    break
                end
            end
            -- 如果是新的就加入details并使count+1
            if bIsNew then
                table.insert(ConvertReddotDetails, {Id = Id, IsClicked = false})
                ReddotManager.IncreaseLeafNodeCount("ForgeConvert")
            end
        end
    end
    DebugPrint("Yihan@ 111111111111111111", #ConvertReddotDetails)
    -- 把两个红点树挂在ForgeEntry上
    ReddotManager.AddNodeEx("ForgeEntry", {
        [ForgeConst.NewdotNodeName["Root"]] = {},
        [ForgeConst.ReddotNodeName["Root"]] = {},
        ["ForgeConvert"] = {},
    }, 1)
    
    ReddotManager.PrintNodeTree("ForgeEntry")
end

-- ForeachFunc参数: 节点名称
function ForgeDataModel:ForeachNodeByDraftInfo(DraftInfo, ForeachFunc, NodeNameTable)
    local ProductTabType = DraftInfo.TabType
    local ProductSubTabType = DraftInfo.SubTabType

    for _, TabType in pairs(ForgeConst.TabType) do
        if ForgeConst.TabType2SubTabType[TabType] then
            for __, SubTabType in pairs(ForgeConst.TabType2SubTabType[TabType]) do 
                if self:CheckFilterResult(self:IsFilteredItem(DraftInfo, TabType, SubTabType)) then 
                    ForeachFunc(NodeNameTable[SubTabType])
                end
            end
        else
            if self:CheckFilterResult(self:IsFilteredItem(DraftInfo, TabType)) then 
                ForeachFunc(NodeNameTable[TabType])
            end
        end
    end
end

-- 红点树操控
function ForgeDataModel:_IncreaseReddotNodeInner(DraftId, NodeName)
    local Detail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
    if Detail and not Detail[DraftId] then
        Detail[DraftId] = true
        ReddotManager.IncreaseLeafNodeCount(NodeName)
    end
end

function ForgeDataModel:IncreaseNewdotByDraftInfo(DraftId)
    local DraftInfo = self:CheckState(DraftId)
    if not DraftInfo then
        DebugPrint("Tianyi@ IncreaseNewdotByDraftInfo: DraftInfo not found for DraftId = " .. DraftId)
        return
    end
    self:ForeachNodeByDraftInfo(DraftInfo, function(NodeName)
        if  NodeName == ForgeConst.NewdotNodeName[ForgeConst.TabType.ToBeProduced] or 
            NodeName == ForgeConst.NewdotNodeName[ForgeConst.TabType.Producing] then
        -- 制造中Tab不显示New红点
        return
    end
        
        self:_IncreaseReddotNodeInner(DraftId, NodeName)
    end, ForgeConst.NewdotNodeName)
end

function ForgeDataModel:IncreaseReddotByDraftInfo(DraftId)
    local DraftInfo = self:CheckState(DraftId)
    if not DraftInfo then
        DebugPrint("Tianyi@ IncreaseReddotByDraftInfo: DraftInfo not found for DraftId = " .. DraftId)
        return
    end
    self:ForeachNodeByDraftInfo(DraftInfo, function(NodeName)
        self:_IncreaseReddotNodeInner(DraftId, NodeName)
    end, ForgeConst.ReddotNodeName)
end

function ForgeDataModel:_DecreaseReddotNodeInner(DraftId, NodeName)
    local Detail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
    if Detail and Detail[DraftId] then
        Detail[DraftId] = nil
        ReddotManager.DecreaseLeafNodeCount(NodeName)
    end
end

function ForgeDataModel:DecreaseNewdotByDraftInfo(DraftId)
    local DraftInfo = self:CheckState(DraftId)
    if not DraftInfo then
        -- DebugPrint("Tianyi@ DecreaseNewdotByDraftInfo: DraftInfo not found for DraftId = " .. DraftId)
        -- 服务端已经没有这张设计稿了，强行清除
        self:ForceClearNodeByDraftId(DraftId)
        return
    end
    self:ForeachNodeByDraftInfo(DraftInfo, function(NodeName)
        if  NodeName == ForgeConst.NewdotNodeName[ForgeConst.TabType.ToBeProduced] or 
            NodeName == ForgeConst.NewdotNodeName[ForgeConst.TabType.Producing] then
            -- 制造中Tab不显示New红点
            return
        end
        self:_DecreaseReddotNodeInner(DraftId, NodeName)
    end, ForgeConst.NewdotNodeName)
end

function ForgeDataModel:DecreaseReddotByDraftInfo(DraftId)
    local DraftInfo = self:CheckState(DraftId)
    if not DraftInfo then
        -- DebugPrint("Tianyi@ DecreaseReddotByDraftInfo: DraftInfo not found for DraftId = " .. DraftId)
        -- 服务端已经没有这张设计稿了，强行清除
        self:ForceClearNodeByDraftId(DraftId)
        return
    end
    self:ForeachNodeByDraftInfo(DraftInfo, function(NodeName)
        self:_DecreaseReddotNodeInner(DraftId, NodeName)
    end, ForgeConst.ReddotNodeName)
end

function ForgeDataModel:ForceClearNodeByDraftId(DraftId)
    for _, NodeName in pairs(ForgeConst.NewdotNodeName) do
        self:_DecreaseReddotNodeInner(DraftId, NodeName)
    end

    for _, NodeName in pairs(ForgeConst.ReddotNodeName) do
        self:_DecreaseReddotNodeInner(DraftId, NodeName)
    end
end



-- 更新单个设计稿状态，并将更新后的结果返回
-- 如果设计稿不存在了，则返回nil
function ForgeDataModel:CheckState(DraftId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local ServerDraftInfo = Avatar.Drafts[DraftId]
    local DraftInfo = self:GetDraftInfoById(DraftId)
    
    if DraftInfo then
        if not ServerDraftInfo or ServerDraftInfo.Count <= 0 and ServerDraftInfo.State == 0 and not DraftInfo.IsInfinity then     
            -- 服务端已经没有该设计稿了，可能已经用完了  
            self:RemoveDraftInfoById(DraftInfo.Id)
            return nil            
        end

        DraftInfo.State = ServerDraftInfo.State
        DraftInfo.Count = ServerDraftInfo.Count 
        DraftInfo.DraftDoingNum = ServerDraftInfo.DraftDoingNum
        DraftInfo.DraftCompleteNum = ServerDraftInfo.DraftCompleteNum
        DraftInfo.StartTime = ServerDraftInfo.StartTime    
        DraftInfo.IsSetTarget = self:IsDraftSetTarget(DraftInfo.Id)
        DraftInfo.IsNotSeen = self:IsDraftNotSeen(DraftInfo.Id)

        if DraftInfo.State == ForgeConst.DraftState.InProgress then 
            DraftInfo.TotalTime = DraftInfo.CostTime * (DraftInfo.DraftDoingNum + DraftInfo.DraftCompleteNum)
        end

    else
        return nil
    end


    local CanProduce, IsResourceEnough, IsFoundryEnough = self:CanProduce(DraftInfo)
    DraftInfo.CanProduce = CanProduce > 0
    DraftInfo.MaxCanProduceNum = math.min(CanProduce, 999)
    DraftInfo.IsResourceEnough = IsResourceEnough
    DraftInfo.IsFoundryEnough = IsFoundryEnough

    return DraftInfo
end

-- 检查某个设计稿能否生产
-- 返回最大可生产数量，资源是否足够，货币是否足够
function ForgeDataModel:CanProduce(Draft) 
    local PlayerAvatar = GWorld:GetAvatar()
    local flag = true 
    local IsResourceEnough = true
    local IsFoundryEnough = true
    local MaxNum = 0

    flag = flag and Draft.State == ForgeConst.DraftState.NotStarted
    flag = flag and (Draft.Count > 0 or Draft.IsInfinity)

    if flag then 
        MaxNum = INF
        for _, Res in ipairs(Draft.Resources) do 
            local ResourceNeed = Res.Num 
            local ResourceHave = self:GetResourceNum(Res.Type, Res.Id) or 0
            MaxNum = math.min(MaxNum, ResourceHave // ResourceNeed)
            if ResourceHave < ResourceNeed then 
                IsResourceEnough = false 
            end
        end
    
        for Id, FoundryNeed in pairs(Draft.Foundries) do 
            local FoundryHave = 0
            if PlayerAvatar.Resources[Id] then 
                FoundryHave = PlayerAvatar.Resources[Id].Count 
            end
            MaxNum = math.min(MaxNum, FoundryHave // FoundryNeed)
            if FoundryHave < FoundryNeed then 
                IsFoundryEnough = false 
            end
        end
    end

    if not Draft.IsInfinity then
        MaxNum = math.min(MaxNum, Draft.Count)
    end
    
    return MaxNum, IsResourceEnough, IsFoundryEnough
end

-- 给外部使用的接口，计算设计稿最大可生产数量，忽略铜币影响
function ForgeDataModel:GetMaxProduceNumByDraftId(DraftId)
    local DraftData = DataMgr.Draft[DraftId]
    local Avatar = GWorld:GetAvatar()
    local AvatarDraftData = Avatar.Drafts[DraftId]

    if not DraftData then return nil end
    if not AvatarDraftData then return 0 end

    local MaxNum = INF
    for _, Res in ipairs(DraftData.Resource) do 
        local ResourceNeed = Res.Num 
        local ResourceHave = self:GetResourceNum(Res.Type, Res.Id) or 0
        MaxNum = math.min(MaxNum, ResourceHave // ResourceNeed)
        if ResourceHave < ResourceNeed then 
            return 0
        end
    end

    if not DraftData.IsInfinity then
        MaxNum = math.min(MaxNum, AvatarDraftData.Count)
    end

    return MaxNum
end

function ForgeDataModel:ConstructForgeItemContent(Obj, DraftInfo)
    local PlayerAvatar = GWorld:GetAvatar()
    local DraftData = DataMgr.Draft[DraftInfo.Id]

    Obj.Id = DraftInfo.Id
    Obj.Count = DraftInfo.Count 
    Obj.StartTime = DraftInfo.StartTime 
    Obj.CostTime = DraftInfo.CostTime 
    Obj.TotalTime = DraftInfo.TotalTime 
    Obj.State = DraftInfo.State
    Obj.ProductNum = DraftInfo.ProductNum
    Obj.DraftDoingNum = DraftInfo.DraftDoingNum
    Obj.DraftCompleteNum = DraftInfo.DraftCompleteNum
    Obj.IsSetTarget = DraftInfo.IsSetTarget
    Obj.ProductName = GText(self:GetProductNameByTypeAndId(DraftInfo.ProductType, DraftInfo.ProductId))

    if Obj.State ~= 0 then                -- 制作中的情况
        Obj.TotalTime = DraftInfo.CostTime * (DraftInfo.DraftDoingNum + DraftInfo.DraftCompleteNum)
    end


    -- TODO: 统一资源数量统计的接口
    if DraftInfo.ProductType == "Weapon" then 
        Obj.ProductCount = PlayerAvatar:GetWeaponCountById(DraftInfo.ProductId) or 0
    elseif DraftInfo.ProductType == "Mod" then 
        Obj.ProductCount = PlayerAvatar:GetModCountById(DraftInfo.ProductId) or 0
    elseif DraftInfo.ProductType == "Resource" then 
        Obj.ProductCount = PlayerAvatar:GetResourceNum(DraftInfo.ProductId)
    elseif DraftInfo.ProductType == "CharAccessory" then 
        Obj.ProductCount = self:HasAccessory(DraftInfo.ProductId) and 1 or 0
    else
        Obj.ProductCount = 0
    end
    
    Obj.ResourcesNeed = {}

    if DraftData.Resource then 
        for _, Res in ipairs(DraftData.Resource) do 
            local ResId = Res.Id  
            local ResRequiredNum = Res.Num   
            local ResHaveNum = self:GetResourceNum(Res.Type or "Resource", ResId)
            table.insert(Obj.ResourcesNeed, {ResId = ResId, Type = Res.Type, Required = ResRequiredNum, Have = ResHaveNum})
        end
    end

    Obj.CanProduce = DraftInfo.CanProduce
    Obj.MaxCanProduceNum = math.min(DraftInfo.MaxCanProduceNum, 999)
    Obj.IsResourceEnough = DraftInfo.IsResourceEnough 
    Obj.IsFoundryEnough = DraftInfo.IsFoundryEnough
    Obj.IsNotSeen = DraftInfo.IsNotSeen


    -- 留一个访问自己的接口
    Obj.GetDataModel = function() return self end
    return Obj
end


-- 获得图鉴的数据
function ForgeDataModel:ConstructForgeCompendiumItemContent(Obj, DraftInfo)
    local PlayerAvatar = GWorld:GetAvatar()
    local DraftData = DataMgr.Draft[DraftInfo.Id]
    Obj.Id = DraftData.DraftId
    Obj.Name = GText(self:GetProductNameByTypeAndId(DraftData.ProductType, DraftData.ProductId))
    Obj.IconPath = DraftData.Icon
    Obj.Rarity = DraftData.Rarity
    Obj.IsDraftType = true
    Obj.OwnedCount = DraftInfo.OwnedCount or 0
    Obj.IsInfinity = DraftInfo.IsInfinity or false
    Obj.IsNew = DraftInfo.IsNew or false
    Obj.GetDataModel = function() return self end
    return Obj
end

-- 将设计稿设为目标
function ForgeDataModel:AddDraftToTarget(DraftId)
    local TargetDraftIds = EMCache:Get("TargetDraftIds", true) or {}
    TargetDraftIds[DraftId] = true 
    EMCache:Set("TargetDraftIds", TargetDraftIds, true)
end

-- 将设计稿移除目标
function ForgeDataModel:RemoveDraftFromTarget(DraftId)
    local TargetDraftIds = EMCache:Get("TargetDraftIds", true) or {}
    TargetDraftIds[DraftId] = nil
    EMCache:Set("TargetDraftIds", TargetDraftIds, true)
end

-- 查询设计稿是否被设为目标
function ForgeDataModel:IsDraftSetTarget(DraftId)
    local TargetDraftIds = EMCache:Get("TargetDraftIds", true) or {}
    return TargetDraftIds[DraftId] or false
end

-- 查询当前设为目标的设计稿数量
function ForgeDataModel:GetTargetDraftCount()
    local Count = 0 
    local TargetDraftIds = EMCache:Get("TargetDraftIds", true) or {}
    for _,_ in pairs(TargetDraftIds) do Count = Count + 1 end 
    return Count
end

-- 查询当前设为目标且可以铸造的物品
function ForgeDataModel:GetCanProduceDraftIds()
    local CanProduceDraftIds = {}
    local TargetDraftIds = EMCache:Get("TargetDraftIds", true)
    if TargetDraftIds then 
        for DraftId, _ in pairs(TargetDraftIds) do
            local DraftInfo = self:ConstructDraftInfoByDraftId(DraftId) 
            if DraftInfo and self:CanProduce(DraftInfo) > 0 then 
                table.insert(CanProduceDraftIds, DraftId)
            end
        end
    end

    return CanProduceDraftIds
end

function ForgeDataModel:GetProductNameByTypeAndId(Type, Id)
    if Type == "Weapon" then 
        local WeaponData = DataMgr.Weapon[Id]
        return WeaponData and WeaponData.WeaponName or nil
    elseif Type == "Mod" then 
        local ModData = DataMgr.Mod[Id]
        return ModData and ModData.Name or nil
    elseif Type == "Resource" then 
        local ResData = DataMgr.Resource[Id]
        return ResData and ResData.ResourceName or nil
    elseif Type == "CharAccessory" then 
        local ResData = DataMgr.CharAccessory[Id] 
        return ResData and ResData.Name or nil
    else 
        return nil
    end
end

function ForgeDataModel:GetAccerateCost(DraftId)
    local Cost = nil
    local DraftInfo = self:GetDraftInfoById(DraftId)
    local AccelerateCostNum = DataMgr.GlobalConstant["AccelerateCostNum"].ConstantValue -- 每加速设计稿1分钟需要消耗的货币数量
    local AccelerateCostMax = DataMgr.GlobalConstant["AccelerateCostMax"].ConstantValue -- 加速单张设计稿至多消耗的货币数量

    if DraftInfo and DraftInfo.State == ForgeConst.DraftState.InProgress then 
        local CurTime = TimeUtils.NowTime()
        local DurationTime = math.max(CurTime - DraftInfo.StartTime, 0)
        local RemainingTime = DraftInfo.TotalTime - DurationTime -- 单位为秒
        local DraftStageRemainingTime = RemainingTime % DraftInfo.CostTime -- 单位为秒
        local DoingRemaningCost = math.ceil(DraftStageRemainingTime / 3600) * AccelerateCostNum
        local DoingRemaningRealCost = math.max(0, math.min(DoingRemaningCost, AccelerateCostMax))
        local DraftCost = math.max(math.ceil(DraftInfo.CostTime / 3600 * AccelerateCostNum), 0)
        local RemaningCost = math.max(math.min(DraftCost, AccelerateCostMax) * (RemainingTime // DraftInfo.CostTime), 0)
        Cost = RemaningCost + DoingRemaningRealCost
    end

    return Cost or 0
end

function ForgeDataModel:CheckResourceEnough(ResourceNeed, FoundriesNeed)
    local PlayerAvatar = GWorld:GetAvatar()
    local MaxNum = 9999999999
    for _, Res in ipairs(ResourceNeed) do 
        local ResourceNeed = Res.Num 
        local ResourceHave = self:GetResourceNum(Res.Type, Res.Id)
        if not ResourceHave then return 0 end
        MaxNum = math.min(MaxNum, ResourceHave / ResourceNeed)
    end

    for Id, FoundryNeed in pairs(FoundriesNeed) do 
        local FoundryHave = PlayerAvatar.Resources[Id]
        if not FoundryHave then return 0 end 
        MaxNum = math.min(MaxNum, FoundryHave / FoundryNeed)
    end

    return MaxNum
end

function ForgeDataModel:GetResourceNum(ResType, ResId)
    local PlayerAvatar = GWorld:GetAvatar()
    if ResType == "Mod" then 
        return PlayerAvatar:GetModCountById(ResId) or 0
    elseif ResType == "Resource" then  
        return PlayerAvatar:GetResourceNum(ResId)
    end  

    return 0
end

function ForgeDataModel:HasAccessory(Id)
    local PlayerAvatar = GWorld:GetAvatar()
    for _, AccessoryId in pairs(PlayerAvatar.CharAccessorys) do
        if AccessoryId == Id then
            return true
        end
    end
    return false
end

-- 根据过滤器返回排序好的设计稿集合
-- @param Filter number 过滤器类型
-- @param SubFilter 子过滤器类型
function ForgeDataModel:GetDatasByFilter(Filter, SubFilter, CommonFilter)
    self:UpdateData()
    
    -- 携带一些过滤信息
    local FilterResult = {
        HasFilterItem = false,
        HasSubFilterItem = false,
    }

    local GlobalReleaseVersion = DataMgr.GlobalConstant["CurrentVersion"].ConstantValue
    local FiltedDrafts = {}
    for _, Item in pairs(self.Drafts) do
        local ReleaseVersion = DataMgr.Draft[Item.Id].ReleaseVersion
        local IsValidItem = true 
        if ReleaseVersion and ReleaseVersion > GlobalReleaseVersion then
            IsValidItem = false
        end
        
        if IsValidItem then
            local FilterItemResult = self:IsFilteredItem(Item, Filter, SubFilter, CommonFilter)
            for k, v in pairs(FilterItemResult) do 
                IsValidItem = IsValidItem and v 
                FilterResult[k] = FilterResult[k] or v
            end
        end

        if IsValidItem then 
            table.insert(FiltedDrafts, Item)
        end
    end
    
    return FiltedDrafts, FilterResult
end

-- 根据过滤器获取图鉴的设计稿集合
function ForgeDataModel:GetCompendiumDatasByFilter(Filter)
    local Avatar = GWorld:GetAvatar()
    local FiltedDrafts = {}
    for Id, Data in pairs(DataMgr.Draft) do
        if not Data.ShowInDraftArchive then
            goto continue
        end
        local ReleaseVersion = Data.ReleaseVersion
        local GlobalReleaseVersion = DataMgr.GlobalConstant["CurrentVersion"].ConstantValue
        if ReleaseVersion and ReleaseVersion > GlobalReleaseVersion and Avatar.Drafts[Id] == nil then
            goto continue
        end

        if Filter and (Filter == ForgeConst.TabType.All or Filter == Data.ProductType) then
            local CompendiumInfo = {}
            CompendiumInfo.Id = Id
            if Avatar.Drafts[Id] then
                CompendiumInfo.OwnedCount = Avatar.Drafts[Id].Count or 0
                CompendiumInfo.IsInfinity = Avatar.Drafts[Id].IsInfinity or false
            else
                CompendiumInfo.OwnedCount = 0
                CompendiumInfo.IsInfinity = false
            end
            CompendiumInfo.TypePriority = DataMgr.RewardType[Data.ProductType].DungeonRewardSeq
            CompendiumInfo.Rarity = Data.Rarity
            CompendiumInfo.IsNew = (CompendiumInfo.OwnedCount > 0 or CompendiumInfo.IsInfinity) and self:IsDraftNotSeen(Id)  -- 是否第一次见(显示New红点)
            CompendiumInfo.SubTabType = DataMgr.DraftId2TabAndSubTab[Id].SubTabType  -- 设计稿所属SubTab类型
            table.insert(FiltedDrafts, CompendiumInfo)
        end

        ::continue::
    end

    return FiltedDrafts
end

-- 制作完成设计稿 > 设为目标的设计稿 > 制作中设计稿 > 待制作设计稿（材料足够）> 未制作设计稿（材料不足）
local function SortByState(Item_1, Item_2)
    local GetPriority = function(Item)
        if Item.State == ForgeConst.DraftState.NotStarted and not Item.IsSetTarget then
            if not Item.CanProduce then
                return 0 -- 未制作设计稿（材料不足）
            else
                return 1 -- 待制作设计稿（材料足够）
            end
        elseif Item.State == ForgeConst.DraftState.InProgress then
            return 2 -- 制作中设计稿
        elseif Item.State == ForgeConst.DraftState.NotStarted and Item.IsSetTarget then
            if not Item.CanProduce then
                return 3 -- 设为目标的设计稿（材料不足）
            else
                return 4 -- 设为目标的设计稿（材料足够）
            end
        elseif Item.State == ForgeConst.DraftState.Complete then
            return 5 -- 制作完成设计稿
        end
    end

    local Priority_1 = GetPriority(Item_1)
    local Priority_2 = GetPriority(Item_2)
    if Priority_1 ~= Priority_2 then
        return true, Priority_1 > Priority_2
    end

    return false 
end

-- 设为目标的优先
local function SortByIsSetTarget(Item_1, Item_2)
    if Item_1.IsSetTarget ~= Item_2.IsSetTarget then
        return true, Item_1.IsSetTarget
    end

    return false 
end

-- 没见过的优先
local function SortByIsNotSeen(Item_1, Item_2)
    if Item_1.IsNotSeen ~= Item_2.IsNotSeen then
        return true, Item_1.IsNotSeen
    end

    return false 
end

-- 稀有度由大到小（橙>紫>蓝>绿>白>无品质）
local function SortByRarity(Item_1, Item_2, IsIncrease)
    if Item_1.Rarity ~= Item_2.Rarity then 
        if IsIncrease then 
            return true, Item_1.Rarity < Item_2.Rarity
        else
            return true, Item_1.Rarity > Item_2.Rarity
        end
    end

    return false 
end

-- [奖励类型表|RewardType]中[结算界面排序优先级|DungeonRewardSeq]排序
local function SortByTypePriority(Item_1, Item_2, IsIncrease)
    if Item_1.TypePriority ~= Item_2.TypePriority then 
        if IsIncrease then 
            return true, Item_1.TypePriority < Item_2.TypePriority
        else
            return true, Item_1.TypePriority > Item_2.TypePriority
        end
    end

    return false 
end

-- DraftID从小到大
local function SortByDraftId(Item_1, Item_2)
    if Item_1.Id ~= Item_2.Id then 
        return true, Item_1.Id < Item_2.Id
    end

    return false 
end

-- 根据子标签优先级排序
local function SortBySubTabType(Item_1, Item_2, IsIncrease)
    local ForgeSTabData = DataMgr.ForgeSTab
    if Item_1.SubTabType ~= Item_2.SubTabType then 
        if IsIncrease then 
            return true, ForgeSTabData[Item_1.SubTabType].Sequence > ForgeSTabData[Item_2.SubTabType].Sequence
        else
            return true, ForgeSTabData[Item_1.SubTabType].Sequence < ForgeSTabData[Item_2.SubTabType].Sequence
        end
    end

    return false 
end

local SortMethods_MainTab_ByType = {SortByIsNotSeen, SortByState, SortByTypePriority, SortByRarity}
local SortMethods_MainTab_ByRarity = {SortByIsNotSeen, SortByState, SortByRarity, SortByTypePriority}
local SortMethods_SubTabAll_ByType = {SortByIsNotSeen, SortByState, SortBySubTabType, SortByRarity}
local SortMethods_SubTabAll_ByRarity = {SortByIsNotSeen, SortByState, SortByRarity, SortBySubTabType}
local SortMethods_SubTab_ByType = {SortByIsNotSeen, SortByState}
local SortMethods_SubTab_ByRarity = {SortByIsNotSeen, SortByState, SortByRarity}
local SortMethods_Compendium_All_ByType = {SortByTypePriority, SortByRarity}
local SortMethods_Compendium_All_ByRarity = {SortByRarity, SortByTypePriority}
local SortMethods_Compendium_ByType = {SortBySubTabType, SortByRarity}
local SortMethods_Compendium_ByRarity = {SortByRarity, SortBySubTabType}

function ForgeDataModel:SortDraftDatas(DraftInfos, TabType, SubTabType, SortType, IsIncrease)
    local SortTypeMap =  {"Type", "Rarity"}
    local IsIncreaseMap = {true, false}
    SortType = SortTypeMap[SortType or 1]
    IsIncrease = IsIncreaseMap[IsIncrease or 1]

    local SortMethod = nil
    if TabType == ForgeConst.TabType.All or TabType == ForgeConst.TabType.Producing or TabType == ForgeConst.TabType.ToBeProduced then 
        SortMethod = SortType == "Type" and SortMethods_MainTab_ByType or SortMethods_MainTab_ByRarity
    else 
        if  SubTabType == ForgeConst.SubTabType.Weapon_All or 
            SubTabType == ForgeConst.SubTabType.Mod_All or 
            SubTabType == ForgeConst.SubTabType.Accessory_All or 
            SubTabType == ForgeConst.SubTabType.Resource_All then 
                SortMethod = SortType == "Type" and SortMethods_SubTabAll_ByType or SortMethods_SubTabAll_ByRarity
        else
                SortMethod = SortType == "Type" and SortMethods_SubTab_ByType or SortMethods_SubTab_ByRarity
        end
    end

    return self:_SortDatas(DraftInfos, SortMethod, IsIncrease)
end

function ForgeDataModel:SortCompendiumDatas(CompendiumDatas, TabType, SortType, IsIncrease)
    local SortTypeMap =  {"Type", "Rarity"}
    local IsIncreaseMap = {true, false}
    SortType = SortTypeMap[SortType or 1]
    IsIncrease = IsIncreaseMap[IsIncrease or 1]

    local SortMethod = nil
    if TabType == ForgeConst.TabType.All then
        SortMethod = SortType == "Type" and SortMethods_Compendium_All_ByType or SortMethods_Compendium_All_ByRarity
    else
        SortMethod = SortType == "Type" and SortMethods_Compendium_ByType or SortMethods_Compendium_ByRarity
    end

    return self:_SortDatas(CompendiumDatas, SortMethod, IsIncrease)
end

function ForgeDataModel:_SortDatas(DraftInfos, SortMethod, IsIncrease)
    local Cmp = function(Item_1, Item_2)
        for _, SortMethod in ipairs(SortMethod) do 
            local IsBreak, Result = SortMethod(Item_1, Item_2, IsIncrease)
            if IsBreak then return Result end
        end

        if IsIncrease then 
            return Item_1.Id < Item_2.Id
        else 
            return Item_1.Id > Item_2.Id
        end
    end

    table.sort(DraftInfos, Cmp)
    return DraftInfos
end


-- 根据过滤器返回能够领取的设计稿
-- @param Filter number 过滤器类型
-- @param SubFilter 子过滤器类型
function ForgeDataModel:GetCompletedDraftIdsByFilter(Filter, SubFilter)
    self:UpdateData()

    local FiltedCompletedDrafts = {}
    for _, Item in pairs(self.Drafts) do
        if self:CheckFilterResult(self:IsFilteredItem(Item, Filter, SubFilter)) and Item.State == ForgeConst.DraftState.Complete then
            table.insert(FiltedCompletedDrafts, Item.Id)
        end
    end

    return FiltedCompletedDrafts
end

function ForgeDataModel:DoCommonFilter(Drafts, CommonFilter)
    if not CommonFilter then return end

end

-- Filter: 一级Tab
-- SubFilter: 二级Tab
-- CommonFilter: Mod通用过滤器
function ForgeDataModel:IsFilteredItem(Item, Filter, SubFilter, CommonFilter)
    if self["Filter_"..Filter] then 
        return self["Filter_"..Filter](self, Item, SubFilter, CommonFilter)
    end

    return false 
end

function ForgeDataModel:CheckFilterResult(FilterItemResult)
    if FilterItemResult == false then return false end
    local Result = true
    for k, v in pairs(FilterItemResult) do 
        Result = Result and v 
    end

    return Result
end

function ForgeDataModel:Filter_All(Item, SubFilter)
    return {
        HasFilterItem = true,
    }
end

function ForgeDataModel:Filter_Forging(Item, SubFilter)
    return {
        HasFilterItem = (Item.State == ForgeConst.DraftState.InProgress or Item.State == ForgeConst.DraftState.Complete),
    }
end

function ForgeDataModel:Filter_Ready(Item, SubFilter)
    local CanProduce, IsResourceEnough, IsFoundryEnough = self:CanProduce(Item)
    return {
        HasFilterItem = CanProduce > 0,
    }
end

function ForgeDataModel:Filter_Weapon(Item, SubFilter)
    if Item.ProductType ~= "Weapon" then
        return {
            HasFilterItem = false,
        }
    end

    if SubFilter then 
        local ItemSubTabType = DataMgr.DraftId2TabAndSubTab[Item.Id].SubTabType
        if SubFilter ~= ForgeConst.SubTabType.Weapon_All and SubFilter ~= ItemSubTabType then 
            return {
                HasFilterItem = true,
                HasSubFilterItem = false,
            }
        end
    end

    return {
        HasFilterItem = true,
        HasSubFilterItem = true,
    }
end

function ForgeDataModel:Filter_Mod(Item, SubFilter, CommonFilter)
    if Item.ProductType ~= "Mod" then
        return {
            HasFilterItem = false,
        }
    end

    if SubFilter then 
        local ItemSubTabType = DataMgr.DraftId2TabAndSubTab[Item.Id].SubTabType
        if SubFilter ~= ForgeConst.SubTabType.Mod_All and SubFilter ~= ItemSubTabType then 
            return {
                HasFilterItem = true,
                HasSubFilterItem = false,
            }
        end
    end

    if CommonFilter then 
        local SelectedItems = CommonFilter.FilterSelectedItems
        local ItemDatas = CommonFilter.FilterItemDatas
        local ModData = DataMgr.Mod[Item.ProductId]
        return {
            HasFilterItem = true,
            HasSubFilterItem = true,
            HasCommonFilterItem = CommonFilterUtils.FilterItemDataByFilterData(ModData, SelectedItems, ItemDatas)
        }
    end

    return {
        HasFilterItem = true,
        HasSubFilterItem = true,
    }
end

function ForgeDataModel:Filter_Resource(Item, SubFilter)
    if Item.ProductType ~= "Resource" then 
        return {
            HasFilterItem = false,
        }
    end

    if SubFilter then 
        local ItemSubTabType = DataMgr.DraftId2TabAndSubTab[Item.Id].SubTabType
        if SubFilter ~= ForgeConst.SubTabType.Resource_All and SubFilter ~= ItemSubTabType then 
            return {
                HasFilterItem = true,
                HasSubFilterItem = false,
            }
        end
    end

    return {
        HasFilterItem = true,
        HasSubFilterItem = true,
    }
    
end

function ForgeDataModel:Filter_CharAccessory(Item, SubFilter)
    if Item.ProductType ~= "CharAccessory" then 
        return {
            HasFilterItem =  false,
        }
    end

    if SubFilter then 
        local ItemSubTabType = DataMgr.DraftId2TabAndSubTab[Item.Id].SubTabType
        if SubFilter ~= ForgeConst.SubTabType.Accessory_All and SubFilter ~= ItemSubTabType then 
            return {
                HasFilterItem = true,
                HasSubFilterItem = false
            }
        end
    end

    return {
        HasFilterItem = true,
        HasSubFilterItem = true,
    }
end


-- 选择消耗的Mod，返回一个Mod列表
function ForgeDataModel:ChooseCostItems(DraftId, Count)
    Count = Count or 1
    local CostItemList = {}
    local DraftInfo = DataMgr.Draft[DraftId]
    local PlayerAvatar = GWorld:GetAvatar()
    if not DraftInfo then return nil end 
    for _, ResInfo in ipairs(DraftInfo.Resource) do 
        if ResInfo.Type == "Mod" then 
            local Mods = PlayerAvatar:GetModsByModId(ResInfo.Id)

            -- 优先选择未锁定，等级最低的mod
            table.sort(Mods, function(Mod_1, Mod_2) 
                if Mod_1.LockState ~= Mod_2.LockState then 
                    return Mod_1.LockState < Mod_2.LockState 
                end 
                if Mod_1.Level ~= Mod_2.Level then 
                    return Mod_1.Level < Mod_2.Level
                end

                return Mod_1.Count < Mod_2.Count
            end) 


            local TotalChoosedNum = 0
            for _, Mod in ipairs(Mods) do 
                local ChoosedNum = 0
                if Mod.Count >= ResInfo.Num * Count - TotalChoosedNum then 
                    ChoosedNum = ResInfo.Num * Count - TotalChoosedNum 
                else
                    ChoosedNum = Mod.Count  
                end
                table.insert(CostItemList, {
                    Type = "Mod",
                    Uuid = Mod.Uuid,
                    Id = Mod.ModId, 
                    Level = Mod.Level,
                    Count = ChoosedNum,
                    IsLock = Mod.LockState > 0, 
                    IsEquipped = Mod:IsEquipped() and ChoosedNum >= Mod.Count,
                    Instance = Mod,
                })
                TotalChoosedNum = TotalChoosedNum + ChoosedNum
                if TotalChoosedNum >= ResInfo.Num * Count then break end
            end
        end
    end

    return CostItemList
end

function ForgeDataModel:IsDraftNotSeen(DraftId)
    local SeenDraftIds = EMCache:Get("SeenDraftIds", true) or {}
    return not SeenDraftIds[DraftId]
end

function ForgeDataModel:MarkDraftAsSeen(DraftId)
    local SeenDraftIds = EMCache:Get("SeenDraftIds", true) or {}
    SeenDraftIds[DraftId] = true
    EMCache:Set("SeenDraftIds", SeenDraftIds, true)

    -- 更新New红点树
    self:DecreaseNewdotByDraftInfo(DraftId)
end

-- 将当前拥有的设计稿全部记为已见过的状态
function ForgeDataModel:ClearNewRedDots()
    local SeenDraftIds = {}
    for DraftId, Data in pairs(self.ServerData) do
        SeenDraftIds[DraftId] = true
    end

    EMCache:Set("SeenDraftIds", SeenDraftIds, true)

    -- 更新New红点树
    for _, NodeName in pairs(ForgeConst.NewdotNodeName) do
        local TreeNode = ReddotManager.GetTreeNode(NodeName)
        if TreeNode:IsLeaf() then
            ReddotManager.ClearLeafNodeCount(NodeName, true)
        end
    end
end

-- 将当前所有的全部的重铸产物记为已见过的状态
function ForgeDataModel:ClearConvertNewRedDots()
    local ForgeConvertReddotNode = ReddotManager.GetTreeNode("ForgeConvert")
    local ConvertReddotDetails = ForgeConvertReddotNode.Cache.Detail
    for _, Details in pairs(ConvertReddotDetails) do
        Details.IsClicked = true
    end
    if ForgeConvertReddotNode:IsLeaf() then
        ReddotManager.ClearLeafNodeCount("ForgeConvert", false)
    end
end

return ForgeDataModel
---@class BagCommon
local BagCommon = {}

BagCommon.NpcId = 900005

BagCommon.MainUIName = "BagMain"

BagCommon.BagSellPageZOrder = 56

BagCommon.StuffType = {
    Weapon = "Weapon",          -- 武器（近战 + 远程）
    Mod = "Mod",                -- Mod
    Resource = "Resource",      -- 资源类型（里面又有很多子类，通过MaterialClassify区分）
    Draft = "Draft",            -- 图纸
}

-- 内容 ： TabId(对应BagTab里面的TabId)
BagCommon.ItemTypeToTabId = {
    MeleeWeapon = 101,
    RangedWeapon = 102,
    Mod = 2,
    Resource = 3,
    TaskItem = 4,
    ReadItem = 5,
    FishItem = 6,
    ConsumableItem = 7,
    Draft = 9,
}

-- TabId对应的Stuff类型
BagCommon.TabIdToStuffType = {
    [BagCommon.ItemTypeToTabId.MeleeWeapon] = BagCommon.StuffType.Weapon,
    [BagCommon.ItemTypeToTabId.RangedWeapon] = BagCommon.StuffType.Weapon,
    [BagCommon.ItemTypeToTabId.Mod] = BagCommon.StuffType.Mod,
    [BagCommon.ItemTypeToTabId.Resource] = BagCommon.StuffType.Resource,
    [BagCommon.ItemTypeToTabId.TaskItem] = BagCommon.StuffType.Resource,
    [BagCommon.ItemTypeToTabId.ReadItem] = BagCommon.StuffType.Resource,
    [BagCommon.ItemTypeToTabId.FishItem] = BagCommon.StuffType.Resource,
    [BagCommon.ItemTypeToTabId.ConsumableItem] = BagCommon.StuffType.Resource,
    [BagCommon.ItemTypeToTabId.Draft] = BagCommon.StuffType.Draft,
}

-- 消耗品物品类型排序权重
BagCommon.ConsumableItemTypeSortWeight = {
    ResourcePack = 1,
    SelectResource = 2,
    SelectPet = 3,
    SelectWeapon = 4,
    SelectCharacter = 5,
    SelectWeaponAccessory = 6,
    SelectCharAccessory = 7,
    SelectWeaponSkin = 8,
    SelectGeneralSkin = 9,
    SelectSkin = 10,
}

-- 筛选框的ModelId
BagCommon.SiftModelIds = {
    [BagCommon.ItemTypeToTabId.MeleeWeapon] = 1003,
    [BagCommon.ItemTypeToTabId.RangedWeapon] = 1004,
    [BagCommon.ItemTypeToTabId.Mod] = 1002,
    [BagCommon.ItemTypeToTabId.Resource] = 1001,
    -- [BagCommon.ItemTypeToTabId.TaskItem] = 1005,
    -- [BagCommon.ItemTypeToTabId.ReadItem] = 1006,
    -- [BagCommon.ItemTypeToTabId.Draft] = 1007,
}

-- 可筛选内容
BagCommon.SortFilters = {
    [BagCommon.ItemTypeToTabId.MeleeWeapon] = {"UI_Select_Level"}, 
    [BagCommon.ItemTypeToTabId.RangedWeapon] = {"UI_Select_Level"}, 
    [BagCommon.ItemTypeToTabId.Mod] = {"UI_Select_Kind", "UI_Select_Unique", "UI_Select_Level", "UI_Select_Price",}, 
    [BagCommon.ItemTypeToTabId.Resource] = {"UI_Select_Unique", "UI_Select_Price"},
    [BagCommon.ItemTypeToTabId.TaskItem] = {"UI_Select_Unique"},
    [BagCommon.ItemTypeToTabId.ReadItem] = {"UI_Select_Unique"},
    [BagCommon.ItemTypeToTabId.FishItem] = {"UI_Select_Unique"},
    [BagCommon.ItemTypeToTabId.ConsumableItem] = {"UI_Select_Unique"},
    [BagCommon.ItemTypeToTabId.Draft] = {"UI_Select_Kind", "UI_Select_Unique"},
}

-- 默认选中的Tab
BagCommon.DefaultSelectTabId = BagCommon.ItemTypeToTabId.Resource

-- 背包出售物品种类数量的最小值和最大值
BagCommon.MinSellInputCount = 0
BagCommon.MaxSellInputCount = 999

-- 背包武器上限提示阈值
BagCommon.MaxWeaponCount = 1000

-- 背包的各种状态
BagCommon.AllBagState = {
    NormalState = "NormalState",
    ChooseSaleState = "ChooseSaleState",
    WeaponResolveState = "WeaponResolveState",
}

-- 背包道具选择出售/分解界面
BagCommon.BagStuffSelectUIName = "BagStuffSelectToList"

-- 背包选择操作类别
BagCommon.BagItemSelectOpMode = {
    ResolveMode = "ResolveMode",
    SellMode = "SellMode",
}

-- 坐骑相关的背包类型
BagCommon.MountTypeInResource = "MountItem"
-- 坐骑的跳转ID
BagCommon.MountJumpId = 78

-- 背包根据品质批量选择
BagCommon.RarityColorInfo = {
    Grey = 1,
    Green = 2,
    Blue = 3,
    Purple = 4,
    Yellow = 5,
}

-- 背包本地Cache数据名称
BagCommon.BagCacheDataName = "BagTabSelect"

-- 背包上次出售提醒本地时间戳
BagCommon.LastStuffSellTimeStamp = "LastStuffNoMorePromptsTimeStamp"

-- 背包上次分解提醒本地时间戳
BagCommon.LastWeaponResolveTimeStamp = "LastWeaponNoMorePromptsTimeStamp"

-- 背包上次武器数量过多提醒本地时间戳
BagCommon.LastWeaponTooMoreWarningTimeStamp = "LastWeaponNoMoreWarningTimeStamp"

-- 背包自选角色、武器、魔灵弹窗
BagCommon.OptionalItemType = {
    Avatar = "Avatar",
    Weapon = "Weapon",
    Pet = "Pet",
}

--- 判断资源是否为鱼类
-- @param ResourceId 字符串或数值类型的资源ID
-- @return boolean 当资源ID有效且存在于鱼类数据中时返回true
function BagCommon:IsFishResource(ResourceId)
    local numId = tonumber(ResourceId)
    return numId and (DataMgr.ResourceId2FishId[math.tointeger(numId)] ~= nil)
end

--- 检查指定鱼类资源ID和尺寸是否被锁定
-- @param FishResourceId string|number 鱼类资源ID（可接受字符串或数字）
-- @param FishSize string|number 鱼类尺寸（可接受字符串或数字）
-- @return boolean 锁定返回true，否则false（包括参数无效或数据不存在）
function BagCommon:IsFishResourceLocked(FishResourceId, FishSize)
    local FishId = tonumber(FishResourceId)
    local Size = tonumber(FishSize)
    if not FishId or not Size then
        return false
    end
    local Avatar = GWorld:GetAvatar()
    local BagFish = Avatar.FishSizes[FishId]
    return BagFish and BagFish:GetLockState(Size) or false
end

-- 获取指定鱼类资源ID的尺寸和数量数据
function BagCommon:GetFishSize2Count(FishResourceId)
    local FishId = tonumber(FishResourceId)
    if not FishId then
        return
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local StuffServerData = Avatar.Resources[FishId]
    if not StuffServerData then
        return
    end

    local TotalFishCount = StuffServerData.Count  -- 资源表获取该鱼总数
    if not TotalFishCount or TotalFishCount < 1 then
        return
    end

    local PlayerBagFish = Avatar.FishSizes[FishId]
    if not PlayerBagFish or not PlayerBagFish.FishSize2Count then
        return
    end

    local FishSize2Count = { }  -- 鱼表数量和资源表数量同步，不一致时取最小值
    for Size, Count in pairs(PlayerBagFish.FishSize2Count) do
        if TotalFishCount < 1 then
            break
        end
        if TotalFishCount - Count <= 0 then
            FishSize2Count[Size] = TotalFishCount
            return FishSize2Count
        else
            FishSize2Count[Size] = Count
            TotalFishCount = TotalFishCount - Count
        end
    end
    return FishSize2Count
end

return BagCommon
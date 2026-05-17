--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

-- 道具相关的数据类

require "UnLua"
local CommonUtils = require "Utils.CommonUtils"
local BagCommon = require "BluePrints.UI.WBP.Bag.BagCommon"
local ForgeConst = require "Blueprints.UI.Forge.ForgeConst"

local StuffIconObject = {}

-- 创建背包物品数据对象
function StuffIconObject:CreateBagItemContent(Content)
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
    StuffObj.Level = Content.Level
    StuffObj.Rarity = Content.Rarity
    StuffObj.Price = Content.Price
    StuffObj.CoinId = Content.CoinId
    StuffObj.bInGear = Content.IsEquipped
    StuffObj.StateTagInfo = Content.StateTagInfo
    StuffObj.AttrIcon = Content.AttrIcon
    StuffObj.IsPhantom = Content.IsPhantom
    StuffObj.AssisterId = Content.AssisterId
    StuffObj.LevelCardNum = Content.GradeLevel
    StuffObj.AnimNameWithCreate = Content.AnimNameWithCreate
    local StuffObjType = StuffObj.Type
    if StuffObjType == "Weapon" then
        StuffObjType = "BattleWeapon"
        StuffObj.SiftTag = DataMgr[StuffObjType][StuffObj.StuffId].WeaponTag
    elseif StuffObjType == "Mod" then
        StuffObj.FilterTag = DataMgr[StuffObjType][StuffObj.StuffId].FilterTag
    end
    if (Content.ParentWidget) then
        StuffObj.ParentWidget = Content.ParentWidget
    end
    if Content.FishInfo then
        StuffObj.FishInfo = Content.FishInfo
    end
    return StuffObj
end

-- 获取武器物品数据
function StuffIconObject:GetWeaponStuffData(StuffServerData, ParentWidget, ClickCallback)
    local StuffConfig = {}
    local WeaponConfigData = StuffServerData:Data()
    local WeaponBattleData = StuffServerData:BattleData()
    if (WeaponConfigData == nil or WeaponBattleData == nil) then
        return nil
    end
    StuffConfig.Uuid = StuffServerData.Uuid                           -- 每把武器的唯一ID
    StuffConfig.StuffId = WeaponConfigData.WeaponId
    StuffConfig.StuffType = CommonConst.DataType.Weapon
    StuffConfig.StuffCount = 1
    StuffConfig.StuffName = GText(WeaponConfigData.WeaponName)
    StuffConfig.ClickCallback = ClickCallback or "ClickStuffIcon"
    StuffConfig.NeedRedPoint = false
    StuffConfig.LockType = StuffServerData:IsLock() and 1 or 0
    StuffConfig.Level = StuffServerData.Level
    StuffConfig.Rarity = WeaponConfigData.WeaponRarity or 1
    StuffConfig.Price = WeaponConfigData.WeaponValue or 1
    StuffConfig.SortPriority = WeaponConfigData.SortPriority or 1
    StuffConfig.CoinId = WeaponConfigData.DecomposeReward
    StuffConfig.AssisterId = StuffServerData.AssisterId
    if (StuffServerData.GradeLevel > 0) then
        StuffConfig.GradeLevel = StuffServerData.GradeLevel
    end
    StuffConfig.ParentWidget = ParentWidget
    StuffConfig.StuffIcon = WeaponConfigData.Icon
    StuffConfig.SiftTag = StuffServerData.WeaponTags
    if (StuffConfig.StuffIcon == nil) then
        -- 用张默认的图(暂时先用PC的图片资源)
        DebugPrint("Error The Weapon Texture is missing, Weapon is ", StuffConfig.StuffId)
        StuffConfig.StuffIcon = '/Game/UI/UI_PNG/03Image/Weapon/Head_Baonu_WP.Head_Baonu_WP'
    end
    return StuffConfig
end

function StuffIconObject:IsAura(ModConfigData)
    if not ModConfigData.ApplySlot then
        return false
    end
    
    if type(ModConfigData.ApplySlot) == "table" then
        for _, slot in ipairs(ModConfigData.ApplySlot) do
            if slot == 9 then
                return true
            end
        end
    else
        return ModConfigData.ApplySlot == 9
    end
    
    return false 
end

-- 获取Mod物品数据
function StuffIconObject:GetModStuffData(StuffServerData, ParentWidget, ClickCallback)
    local StuffConfig = {}
    local ModConfigData = StuffServerData:Data()
    if (ModConfigData == nil) then
        return nil
    end
    StuffConfig.Uuid = StuffServerData.Uuid                            -- 每个Mod的唯一ID
    StuffConfig.StuffId = StuffServerData.ModId
    StuffConfig.StuffType = CommonConst.DataType.Mod
    StuffConfig.StuffCount = StuffServerData.Count
    StuffConfig.StuffName = GText(ModConfigData.Name)
    StuffConfig.ClickCallback = ClickCallback or "ClickStuffIcon"
    StuffConfig.NeedRedPoint = false
    StuffConfig.bAura = self:IsAura(ModConfigData)
    if (StuffServerData.IsLock and StuffServerData:IsLock()) then
        StuffConfig.LockType = 1
    else
        StuffConfig.LockType = 0
    end
    StuffConfig.Level = StuffServerData.Level
    StuffConfig.Rarity = StuffServerData.Rarity or 1
    StuffConfig.ApplicationType = StuffServerData.ApplicationType or 1
    if (ModConfigData.BreakDown ~= nil) then
        for k, v in pairs(ModConfigData.BreakDown) do
            StuffConfig.CoinId = k
            StuffConfig.Price = v
        end
        --计算每个等级需要返还多少
        local ModLevelConfig = StuffServerData:LevelData()
        for i = 1, StuffServerData.Level, 1 do
            local ModLevelInfo = ModLevelConfig[i]
            local ConsumeRarityInfo = ModLevelInfo.ConsumeRarity[StuffServerData.Rarity]
            for CoinTypeId, Value in pairs(ConsumeRarityInfo) do
                if (StuffConfig.CoinId == CoinTypeId) then
                    StuffConfig.Price = StuffConfig.Price + Value * DataMgr.GlobalConstant.ModSaleCutoff.ConstantValue
                end
            end
        end
    else
        -- 售价设置为-1，表示不可出售
        StuffConfig.CoinId = 101
        StuffConfig.Price = -1
    end
    local IconResourcePath = StuffServerData.Icon or ModConfigData.Icon
    -- local IconPathConfigDataArray = Split(IconResourcePath, "/")
    -- local IconPathConfigLength = #IconPathConfigDataArray
    -- local RealNameArray = Split(IconPathConfigDataArray[IconPathConfigLength], ".")
    -- local Start, End = string.find(RealNameArray[1], "_Sprite")
    -- local FinalIconPath = ""
    -- for i = 1, IconPathConfigLength - 1, 1 do
    --     FinalIconPath = FinalIconPath..IconPathConfigDataArray[i]
    --     FinalIconPath = FinalIconPath.."/"
    -- end
    -- FinalIconPath = FinalIconPath..string.sub(RealNameArray[1], 1, Start - 1)
    -- FinalIconPath = FinalIconPath.."."
    -- FinalIconPath = FinalIconPath..string.sub(RealNameArray[2], 1, Start - 1)
    StuffConfig.StuffIcon = IconResourcePath
    StuffConfig.ParentWidget = ParentWidget
    StuffConfig.FilterTag = DataMgr[StuffConfig.StuffType][StuffConfig.StuffId].FilterTag
    StuffConfig.TypeName = DataMgr[StuffConfig.StuffType][StuffConfig.StuffId].TypeName
    return StuffConfig
end

-- 获取道具Resource物品数据
function StuffIconObject:GetItemStuffData(StuffServerData, ParentWidget, ClickCallback)
    local StuffConfig = {}
    local ItemConfigData = StuffServerData:Data()
    if (ItemConfigData == nil) then
        return nil
    end
    if not StuffServerData.FishInfo then
        StuffConfig.Uuid = tostring(ItemConfigData.ResourceId)              -- 唯一ID，Items暂时不需要这个ID(就暂时设置成ResourceId)
        StuffConfig.Price = ItemConfigData.ResourceValue or -1
        StuffConfig.StuffCount = StuffServerData.Count
        StuffConfig.LockType = StuffServerData:IsLock() and 1 or 0
    else
        local FishInfo = StuffServerData.FishInfo
        StuffConfig.Uuid = tostring(ItemConfigData.ResourceId).."_"..tostring(FishInfo.Size)
        StuffConfig.Price = AvatarUtils:CalculateFishPrice(ItemConfigData.ResourceId, FishInfo.Size)
        StuffConfig.StuffCount = FishInfo.Count
        StuffConfig.LockType = BagCommon:IsFishResourceLocked(ItemConfigData.ResourceId, FishInfo.Size) and 1 or 0
        StuffConfig.FishInfo = FishInfo
    end
    StuffConfig.StuffId = ItemConfigData.ResourceId
    StuffConfig.StuffType = CommonConst.DataType.Resource
    StuffConfig.StuffName = GText(ItemConfigData.ResourceName)
    -- StuffConfig.StuffName = ItemConfigData.ResourceName
    StuffConfig.ClickCallback = ClickCallback or "ClickStuffIcon"
    StuffConfig.NeedRedPoint = false
    StuffConfig.Rarity = ItemConfigData.Rarity or 1
    StuffConfig.UseEffectType = ItemConfigData.UseEffectType
    StuffConfig.CoinId = ItemConfigData.ResourceToCoinType
    StuffConfig.StuffIcon = ItemConfigData.Icon
    StuffConfig.IsPhantom = ItemConfigData.ResourceSType == "PhantomItem"
    StuffConfig.ParentWidget = ParentWidget
    return StuffConfig
end

-- 获取图纸物品数据
function StuffIconObject:GetDraftsStuffData(StuffServerData, ParentWidget, ClickCallback)
    local StuffConfig = {}
    local DraftConfigData = StuffServerData:Data()
    if (DraftConfigData == nil) then
        return nil
    end

    StuffConfig.Uuid = tostring(DraftConfigData.DraftId)              -- 唯一ID，Draft暂时不需要这个ID(就暂时设置成DraftId)
    StuffConfig.Price = DraftConfigData.ResourceValue or -1
    StuffConfig.StuffCount = StuffServerData.Count
    StuffConfig.LockType = 0
    StuffConfig.StuffId = DraftConfigData.DraftId
    StuffConfig.StuffType = BagCommon.StuffType.Draft

    local ForgeTabConfig = DataMgr.ForgeTab[ForgeConst.ProductTypeToTabId[DraftConfigData.ProductType]]
    if (ForgeTabConfig) then
        StuffConfig.ApplicationType = ForgeTabConfig.Sequence
    else
        StuffConfig.ApplicationType = 0
    end
    DebugPrint("Tianyi@ GetDraftsStuffData ApplicationType:", StuffConfig.ApplicationType)
    StuffConfig.StuffName = GText(DraftConfigData.ResourceName)
    StuffConfig.ClickCallback = ClickCallback or "ClickStuffIcon"
    StuffConfig.NeedRedPoint = false
    StuffConfig.Rarity = DraftConfigData.Rarity or 1
    StuffConfig.CoinId = DraftConfigData.ResourceToCoinType
    StuffConfig.StuffIcon = DraftConfigData.Icon
    StuffConfig.ParentWidget = ParentWidget
    return StuffConfig
end

return StuffIconObject

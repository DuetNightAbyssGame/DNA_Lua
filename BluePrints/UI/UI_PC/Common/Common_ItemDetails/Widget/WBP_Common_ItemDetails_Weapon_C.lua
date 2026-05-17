--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local SkillUtils = require "Utils.SkillUtils"
local CommonUtils = require "Utils.CommonUtils"
local WeaponUtils = require "BluePrints.Client.CustomTypes.Weapon"
local ModModel = ModController:GetModel()
---@type Common_ItemDetails_Weapon_C
local M = Class()

function M:InitItemInfo(ItemType, ItemId, UnitId, Content)
    local WeaponData = DataMgr.Weapon[ItemId]
    local BattleWeaponData = DataMgr.BattleWeapon[ItemId]
    local Avatar = GWorld:GetAvatar()
    local WeaponServerData
    local Level = 1
    local EnhanceLevel, MaxEnhanceLevel = 0, 0
    if UnitId and type(UnitId) == "string" and not CommonUtils.IsObjId(UnitId)then
        UnitId = CommonUtils.Str2ObjId(UnitId)
    end
    WeaponServerData = Avatar.Weapons[UnitId]
    self.Text_Mod:SetText(GText("UI_Bag_MODSapacity"))
    local GradeLevel = 0
    if WeaponServerData then
        Level = WeaponServerData.Level
        EnhanceLevel = WeaponServerData.EnhanceLevel
        GradeLevel = WeaponServerData.GradeLevel
        -- Mod容量
        local Cost = WeaponServerData:GetModSuitCost()
        self.Text_Mod01:SetText(Cost)
        self.Text_Mod02:SetText(WeaponServerData:LevelUpData().ModVolume)
    else
        if Content and Content.Level then
            Level = Content.Level
        end
        self.Text_Mod01:SetText("0")
        self.Text_Mod02:SetText(DataMgr.WeaponLevelUp[Level].ModVolume)
    end
    -- 武器当前等级
    self.ParentWidget.Text_WeaponLevel02:SetText(Level)
    -- 武器最大等级
    self.ParentWidget.Text_WeaponLevel03:SetText(WeaponData.WeaponMaxLevel)

    -- 武器突破等级
    assert(DataMgr.WeaponBreak[ItemId], "请检查武器突破表, WeaponId:", ItemId)
    for _, v in pairs(DataMgr.WeaponBreak[ItemId]) do
        if v.WeaponBreakNum > MaxEnhanceLevel then
            MaxEnhanceLevel = v.WeaponBreakNum
        end
    end
    self:SetWeaponEnhanceLevel(EnhanceLevel, MaxEnhanceLevel)
    self.ParentWidget.Panel_CardLevel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.ParentWidget.Text_CardLevel:SetText(GradeLevel);
    if DataMgr.WeaponCardLevel[ItemId] and GradeLevel == DataMgr.WeaponCardLevel[ItemId].CardLevelMax then
        self.ParentWidget.Bg_CardLevel:SetColorAndOpacity(self.ParentWidget.BgMaxLevelColor)
        self.ParentWidget.Text_CardLevel:SetColorAndOpacity(self.ParentWidget.TextMaxLevelColor)
    else
        self.ParentWidget.Bg_CardLevel:SetColorAndOpacity(self.ParentWidget.BgNormalColor)
        self.ParentWidget.Text_CardLevel:SetColorAndOpacity(self.ParentWidget.TextNormalColor)
    end

    -- 武器类型
    local WeaponTypeName = self:GetWeaponTypeName(ItemId)
    self.Text_SubTitle:SetText(WeaponTypeName)

    --  武器属性
    self:UpdateAttrInfo(ItemId)

    -- 武器被动效果
    local PassiveSkillDesc = SkillUtils.CalcWeaponPassiveEffectsDesc(WeaponServerData or BattleWeaponData)
    if (PassiveSkillDesc ~= nil and PassiveSkillDesc ~= "") then
        self.Text_SkillEffect:SetVisibility(ESlateVisibility.Visible)
        self.Text_SkillEffect:SetText(PassiveSkillDesc)
    else
        self.Text_SkillEffect:SetVisibility(ESlateVisibility.Collapsed)
    end
end

-- 背包内初始化Weapon信息（为了支持铸造图纸进背包，传统接口里有很多操作ParentWidget的逻辑，背包里没法用）
function M:InitItemInfoInBag(ItemType, ItemId, UnitId)
    local WeaponData = DataMgr.Weapon[ItemId]
    local BattleWeaponData = DataMgr.BattleWeapon[ItemId]
    local Avatar = GWorld:GetAvatar()
    local WeaponServerData
    local Level = 1
    local EnhanceLevel, MaxEnhanceLevel = 0, 0
    if UnitId and type(UnitId) == "string" and not CommonUtils.IsObjId(UnitId)then
        UnitId = CommonUtils.Str2ObjId(UnitId)
    end
    WeaponServerData = Avatar.Weapons[UnitId]
    self.Text_Mod:SetText(GText("UI_Bag_MODSapacity"))
    local GradeLevel = 0
    if WeaponServerData then
        Level = WeaponServerData.Level
        EnhanceLevel = WeaponServerData.EnhanceLevel
        GradeLevel = WeaponServerData.GradeLevel
        -- Mod容量
        local Cost = WeaponServerData:GetModSuitCost()
        self.Text_Mod01:SetText(Cost)
        self.Text_Mod02:SetText(WeaponServerData:LevelUpData().ModVolume)
    else
        self.Text_Mod01:SetText("0")
        self.Text_Mod02:SetText(DataMgr.WeaponLevelUp[1].ModVolume)
    end

    -- 武器突破等级
    assert(DataMgr.WeaponBreak[ItemId], "请检查武器突破表, WeaponId:", ItemId)
    for _, v in pairs(DataMgr.WeaponBreak[ItemId]) do
        if v.WeaponBreakNum > MaxEnhanceLevel then
            MaxEnhanceLevel = v.WeaponBreakNum
        end
    end

    -- 武器类型
    local WeaponTypeName = self:GetWeaponTypeName(ItemId)
    self.Text_SubTitle:SetText(WeaponTypeName)

    --  武器属性
    self:UpdateAttrInfo(ItemId)

    -- 武器被动效果
    local PassiveSkillDesc = SkillUtils.CalcWeaponPassiveEffectsDesc(WeaponServerData or BattleWeaponData)
    if (PassiveSkillDesc ~= nil and PassiveSkillDesc ~= "") then
        self.Text_SkillEffect:SetVisibility(ESlateVisibility.Visible)
        self.Text_SkillEffect:SetText(PassiveSkillDesc)
    else
        self.Text_SkillEffect:SetVisibility(ESlateVisibility.Collapsed)
    end
end

-- 设置武器突破等级
function M:SetWeaponEnhanceLevel(EnhanceLevel, MaxEnhanceLevel)
    for i = 1, 6 do
        local str = "Switch_Star0"..i
        local StarWidget = self.ParentWidget[str]
        if StarWidget then
            if i <= EnhanceLevel then
                StarWidget:SetActiveWidgetIndex(0)
            elseif i <= MaxEnhanceLevel then
                StarWidget:SetActiveWidgetIndex(1)
            else
                StarWidget:SetVisibility(ESlateVisibility.Collapsed)
            end
        end
    end
end

-- 获取武器远程or近战
function M:GetWeaponType(WeaponId)
    local BattleWeaponData = DataMgr.BattleWeapon[WeaponId]
    for _, v in pairs(BattleWeaponData.WeaponTag) do
        local WeaponTagData = DataMgr.WeaponTag[v]
        if WeaponTagData and WeaponTagData.WeaponTagfilter then
            if WeaponTagData.WeaponTagfilter == "RangedType" then
                return false
            else
                return true
            end
        end
    end
    return false
end

-- 获取武器远程or近战
-- 规则：遍历BattleWeapon的WeaponTag，当 WeaponTagfilter 存在值的情况下生效(多个值生效取最后一个)
function M:GetWeaponTypeName(WeaponId)
    local WeaponType
    local WeaponName
    local BattleWeaponData = DataMgr.BattleWeapon[WeaponId]
    for _, v in pairs(BattleWeaponData.WeaponTag) do
        local WeaponTagData = DataMgr.WeaponTag[v]
        if WeaponTagData and WeaponTagData.WeaponTagfilter then
            if WeaponTagData.WeaponTagfilter == "RangedType" then
                WeaponType = GText("UI_BAG_Longrange")
            elseif WeaponTagData.WeaponTagfilter == "MeleeType" then
                WeaponType = GText("UI_BAG_Meleeweapon")
            end

            if v == "Bow" then
                --特殊处理，区分长短弓
                local BowTag = nil
                for _, tag in pairs(BattleWeaponData.WeaponTag) do
                    if tag == "Bow01" then
                        BowTag = tag
                    end
                end
                WeaponTagData = DataMgr.WeaponTag[BowTag or "Bow02"] or {}
            end

            if WeaponTagData.WeaponTagTextmap then
                WeaponName = GText(WeaponTagData.WeaponTagTextmap)
            end
        end
    end
    if not WeaponType then
        ScreenPrint("WeaponId"..WeaponId.."的WeaponType为空，请检查WeaponTag中是否配置对应的WeaponTagfilter")
        return ""
    end
    if not WeaponName then
        ScreenPrint("WeaponId"..WeaponId.."的WeaponName为空，请检查WeaponTag中是否配置对应的WeaponTagTextmap")
        return WeaponType
    end
    return WeaponType.."："..WeaponName
end

-- 获取武器属性
function M:UpdateAttrInfo(WeaponId)
    local SortIndexes = {["Melee"] = 2, ["Ranged"] = 3,}
    local StuffTypeTag = "Ranged"
    local StuffType = "Weapon"
    if self:GetWeaponType(WeaponId) then
        StuffTypeTag = "Melee"
    end

    local SortIndex = SortIndexes[StuffTypeTag]
    self.ItemAttrs = {}
    self.AttrCount = 0
    self.Index2AttrKey = {}

    local SortType ='SortIndex'..SortIndex
    self.ItemAttrs = self:GetWeaponAttrInfo(WeaponId)
    local DisplayAttrs = {}
    self.ItemAttrs = self.ItemAttrs or {}
    local WeaponAttrData = DataMgr.BattleWeaponAttr
    for id,Data in pairs(WeaponAttrData) do
        local value = self.ItemAttrs[id] or Data.DefaultValue
        if CommonUtils:ShouldDisplayAttr(id,value,StuffType,StuffTypeTag,WeaponId) then
            self.AttrCount = self.AttrCount + 1
            self.Index2AttrKey[self.AttrCount] = id
            DisplayAttrs[id] = value
        end
    end
    self.ItemAttrs = DisplayAttrs
    table.sort(self.Index2AttrKey,function(x,y)
        return DataMgr.AttrConfig[x][SortType] < DataMgr.AttrConfig[y][SortType]
    end)
    self:UpdataWeaponAttrListView() 
end

function M:UpdataWeaponAttrListView()
    self.VerticalBox_Property:ClearChildren()
    local PropertyDescribeData = {}
    for i, Key in ipairs(self.Index2AttrKey) do
        PropertyDescribeData.GridIndex = i
        local Data = DataMgr.AttrConfig[Key]
        local attr = self.ItemAttrs[Key] or 0
        PropertyDescribeData.AttrName = GText(Data.Name)
        PropertyDescribeData.AttrNum = CommonUtils.AttrValueToString(Data,attr)
        PropertyDescribeData.ParentWidget = self
        local PropertyDescribeObj = self:CreatePropertyDescribeItem(PropertyDescribeData)
        self.VerticalBox_Property:AddChildToVerticalBox(PropertyDescribeObj)
    end
end

function M:GetDefaultAttrValue(AttrName)
    if not self.BattleWeaponAttr then
        self.BattleWeaponAttr = DataMgr.BattleWeaponAttr
    end
    local AttrData = self.BattleWeaponAttr[AttrName]
    if not AttrData then
        return 0
    end

    return AttrData.DefaultValue or 0
end

function M:GetAttrLevelGrow(AttrName)
    local BattleInfo = DataMgr.BattleWeapon
    local LevelGrow = BattleInfo[AttrName .. "LevelGrow"]
    if not LevelGrow then
        return
    end
    local LevelUpInfo = self:LevelUpData()
    local GrowFactor = LevelUpInfo[LevelGrow]
    return GrowFactor
end


function M:FillCardValues(CardValues, CardLevelValues, AttrName, CardValue, LevelGrowAttrName)
    CardValue = CardValue or self:GetDefaultAttrValue(AttrName)
    if not CardValue then
        return
    end
    CardValues[AttrName] = CardValue
    CardLevelValues[AttrName] = self:GetAttrLevelGrow(LevelGrowAttrName)
end

function M:GetWeaponAttrInfo(WeaponId)
    local WeaponAttr = {}
    local WeaponAttrLevelValues = {}
    local BattleInfo = DataMgr.BattleWeapon[WeaponId]

    for _, AttrName in pairs(WeaponUtils.Weapon.Attrs) do
        self:FillCardValues(WeaponAttr, WeaponAttrLevelValues, AttrName, BattleInfo[AttrName], AttrName)
    end

    for _AttrName, _ in pairs(DataMgr.Attribute) do
        local AttrName = "ATK_" .. _AttrName
        self:FillCardValues(WeaponAttr, WeaponAttrLevelValues, AttrName, BattleInfo[AttrName], "ATK")
    end

    if BattleInfo.Attribute then
        self:FillCardValues(WeaponAttr, WeaponAttrLevelValues, "ATK_" .. BattleInfo.Attribute, BattleInfo["ATK"], "ATK")
    end

    return WeaponAttr
end

function M:CreatePropertyDescribeItem(Content)
    if(Content == nil)then
        return
    end
    local PropertyDescribeObj = UIManager(self):_CreateWidgetNew("WeaponItemDetailItems")
    PropertyDescribeObj.Text_Property:SetText(Content.AttrName)
    PropertyDescribeObj.Text_Num:SetText(Content.AttrNum)
    if (Content.GridIndex % 2 == 1) then
        PropertyDescribeObj.Bg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        PropertyDescribeObj.Bg:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    return PropertyDescribeObj
end

return M

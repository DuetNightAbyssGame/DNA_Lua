--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local SkillUtils = require "Utils.SkillUtils"
local UpgradeUtils = require "Utils.UpgradeUtils"
local Utils = require "Utils"
local CharCom = require"BluePrints.Client.CustomTypes.Character"
local CharacterCommon = require "BluePrints.Client.CustomTypes.CharacterCommon"
local WeaponCom = require"BluePrints.Client.CustomTypes.Weapon"
local ModCom = require "BluePrints.Client.CustomTypes.Mod"
local PetCom = require"BluePrints.Client.CustomTypes.Pet"

---@type ArmoryUtils
local M = {}

M.ArmoryMainTabNames = {
    Char = CommonConst.ArmoryTag.Char,
    Melee = CommonConst.ArmoryTag.Melee,
    Ranged = CommonConst.ArmoryTag.Ranged,
    UWeapon = CommonConst.ArmoryTag.UWeapon,
    Pet = CommonConst.ArmoryType.Pet,
    BattleWheel = "BattleWheel",
    Weapon = "Weapon",
}
M.ArmorySubTabNames = {
    Attribute = "Attribute",
    Skill = CommonConst.ArmoryTag.Skill,
    Grade = CommonConst.ArmoryTag.Grade,
    Appearance = "Appearance",
    Files = "Files",
    Entry = "Entry",
}

M.ArmorySubPageName = {
    Mod = "Mod",
    LevelUp = "LevelUp",
    SkillDetail = "SkillDetail",
    Skin = "Skin",
    Files = "Files",
    Grade = "Grade",
    PetMix = "PetMix",
    PetEnhance = "PetEnhance",
}

M.FilesTabType = {
    "CharVoice",
    "Record",
}

M.ModSuitName = { 
    "UI_MOD_PLAN1",
    "UI_MOD_PLAN2",
    "UI_MOD_PLAN3",
}

M.PreviewTargetStates = {Prime = 0, Max = 1, Custom = 2}

function M:NewCharOrWeaponItemContent(Target,Type,Tag, bNotReddot,ReddotFrom)
    --新建一个列表数据对象
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.Uuid = Target.Uuid
    Obj.Type = Type
    Obj.ItemType = Type
    Obj.Tag = Tag
    Obj.UnitId = Target[Type .. "Id"]
    Obj.UnitName = GText(Target[Type .. "Name"])
    Obj.Rarity = Target[Type .. "Rarity"]
    Obj.Icon = Target:Data().Icon
    Obj.Level = Target.Level
    Obj.GradeLevel = Target.GradeLevel
    local Element = DataMgr["Battle"..Type][Obj.UnitId].Attribute
    if(Element)then
        local IconName = "Armory_" .. Element
        Obj.AttrIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName
    end
    if not bNotReddot then
        local IsNew, Upgradeable,HasReward = M["TryAddNew"..Type.."Reddot"](M, Target)
        Obj.IsNew = IsNew
        Obj.Upgradeable = Upgradeable
        Obj.HasReward = HasReward
    end
    if(ReddotFrom == "Archive")then
        Obj.IsNew = M["TryAddArchiveNewReddot"](M, Obj,Tag)
    end
    if Obj.Upgradeable or Obj.HasReward then
        Obj.RedDotType = UIConst.RedDotType.CommonRedDot
    elseif Obj.IsNew then
        Obj.RedDotType = UIConst.RedDotType.NewRedDot
    end
    Obj.IsLocked = Target.IsLock and Target:IsLock()
    Obj.LockType = Obj.IsLocked and 1 or 0
    Obj.SortPriority = Target:Data().SortPriority or 0
    return Obj
end

function M:TryAddArchiveNewReddot(Content,Tag)
    if not ReddotManager.GetTreeNode("ArchiveNew" .. Tag) then
        return
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("ArchiveNew" .. Tag)
    return CacheDetail[Content.UnitId] == 1
end

function M:NewCommonItemContent(Target, Type)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.Uuid = Target.Uuid
    Obj.Id = Target[Type .. "Id"]
    Obj.ItemType = Type
    Obj.Rarity = Target[Type .. "Rarity"]
    Obj.Icon = Target:Data().Icon
    Obj.SortPriority = Target:Data().SortPriority or 0
    return Obj
end

function M:CopyCharOrWeaponItemContent(Content)
    local Obj = {}
    Obj.Uuid = Content.Uuid
    Obj.Type = Content.Type
    Obj.ItemType = Content.ItemType
    Obj.Tag = Content.Tag
    Obj.UnitId = Content.UnitId
    Obj.Rarity = Content.Rarity
    Obj.Icon = Content.Icon
    Obj.Level = Content.Level
    Obj.AttrIcon = Content.AttrIcon
    Obj.IsNew = Content.IsNew
    Obj.GradeLevel = Content.GradeLevel
    Obj.SortPriority = Content.SortPriority
    return Obj
end

function M:NewPetItemContent(Target)
    --新建一个列表数据对象
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.UniqueId = Target.UniqueId
    Obj.Uuid = Target.UniqueId
    Obj.BreakNum = Target.BreakNum
    Obj.Type = CommonConst.ArmoryType.Pet
    Obj.ItemType = CommonConst.ArmoryType.Pet
    Obj.Tag = CommonConst.ArmoryType.Pet
    Obj.UnitId = Target.PetId
    local Data = DataMgr.Pet[Obj.UnitId]
    if(Target.Name and Target.Name ~= "")then
        Obj.UnitName = Target.Name
    else
        Obj.UnitName = GText(Data.Name)
    end
    Obj.Rarity = Data.Rarity
    Obj.Icon = Data.Icon
    Obj.LockType = Target.IsLock and 1 or 0
    Obj.SortPriority = Data.SortPriority or 0
    Obj.IsResourcePet = Target:IsResourcePet()
    if(Obj.IsResourcePet)then
        Obj.PetEntry = {Target.Entry and Target.Entry[1]}
    else
        Obj.Level = Target.Level
    end
    Obj.IsPremium = Target:IsPremium()
    local IsNew, _ = M["TryAddNewPetReddot"](M, Target)
    Obj.IsNew = IsNew
    if Obj.IsNew then
        Obj.RedDotType = UIConst.RedDotType.NewRedDot
    end
    return Obj
end
--- NewPetItemContent的显示词条Icon版本，魔灵合成使用
---@param Target 宠物
function M:NewPetItemContentWithEntry(Target)
    local Obj = self:NewPetItemContent(Target)
    Obj.PetEntry={}
    for i,v in pairs(  Target.Entry) do
        if v ~= 0 then
            table.insert(  Obj.PetEntry, v)
        end
    end
    return Obj
end

function M:NewResourceItemContent(Target)
    local Data = Target:Data()
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.Count = GText("INFINITY_SYMBOL") --用于列表的显示数量
    Obj.Type = CommonConst.DataType.Resource
    Obj.ItemType = CommonConst.DataType.Resource
    Obj.UnitId = Target.ResourceId
    Obj.ResourceSType = Target.ResourceSType
    Obj.IsEquiped = false
    Obj.Rarity = Data.Rarity or 0
    Obj.Icon = Data.Icon
    Obj.CharId = Data.UseParam
    return Obj
end

---@param Target Mod
function M:NewModItemContent(Target,Type)
    if not Type then Type = CommonConst.ArmoryType.Mod end
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.Uuid = Target.Uuid
    Obj.Type = Type
    Obj.UnitId = Target[Type .. "Id"]
    Obj.UnitName = DataMgr[Obj.Type][Obj.UnitId].Name
    Obj.ItemName = Obj.UnitName
    Obj.Rarity = Target["Rarity"]  ---- 稀有度
    Obj.Polarity = Target["Polarity"]
    Obj.Icon = Target.Icon
    Obj.AddAttrs = Target.AddAttrs
    Obj.Level = Target.Level
    Obj.CardLevel = Target.CurrentModCardLevel or 0
    Obj.Cost = Target.Cost
    return Obj
end

function M:SortItemContents(InOutArr,OrderByAttrNames,SortType,CurrentContent,ExCmpFunc)
    local OrderBy = OrderByAttrNames
    ExCmpFunc = ExCmpFunc or function(a,b) end
    local CmpCopy
    local ExCmpRes = nil
    local Cmp = function(a,b,Idx)
        if(CurrentContent)then
            if(a == CurrentContent)then
                return true
            end
            if(b == CurrentContent)then
                return false
            end
        end
        ExCmpRes = ExCmpFunc(a,b)
        if(ExCmpRes ~= nil)then
            return ExCmpRes
        else
            if(a[OrderBy[Idx]] == b[OrderBy[Idx]])then
                if(OrderBy[Idx + 1])then
                    return CmpCopy(a,b,Idx + 1)
                end
            elseif(SortType == CommonConst.ASC)then
                return( a[OrderBy[Idx]]or 1) < (b[OrderBy[Idx]]or 1)
            else
                return (a[OrderBy[Idx]]or 1) > (b[OrderBy[Idx]] or 1)
            end
        end
    end
    CmpCopy = Cmp
    local SortFunc = function(a,b)
        return Cmp(a,b,1)
    end
    table.sort(InOutArr,SortFunc)
end

function M.IsOwnedCmpFunc(a,b)
    if a.IsOwned ~= b.IsOwned then
        if a.IsOwned then
            return true
        else
            return false
        end
    end
end
--- 魔灵训练图鉴用的宠物排序函数（修正版）以下是策划给的需求
-- 按类型排序（默认）

-- 1、按宠物类型排序
-- 素材＞主战

-- 2、素材魔灵下
-- ①按词条ID从小到大排序
-- ②相同词条ID下，按宠物ID从大到小排序

-- 3、主战魔灵下
-- ①按词条数量从多到少排序
-- ②相同词条数量下，按宠物ID从大到小排序
-- 按稀有度排序

-- 1、按宠物类型排序
-- 素材＞主战

-- 2、素材魔灵下
-- ①按词条稀有度从高到低排序
-- ②相同词条稀有度下，按词条ID从小到大排序
-- ③相同词条ID下，按宠物ID从大到小排序

-- 3、主战魔灵下
-- ①按词条数量从多到少排序
-- ②相同词条数量下，按宠物ID从大到小排序
---@param Pets table 宠物列表（索引从1开始）
---@param SortKind number 排序类型（1:按稀有度排序；2:按类型排序）
---@param IsASC boolean 是否升序（true=升序，false=降序）
---@return table 排序后的宠物列表
function M:SortEntryPets(Pets, SortKind, IsASC)
    -- 参数校验与默认值
    SortKind = SortKind == 2 and 2 or 1
    IsASC = IsASC == nil and true or IsASC

    local function getEntryId(pet)
        return (pet.PetEntry and pet.PetEntry[1]) or 0 -- 无词条返回0
    end

    -- 辅助函数：获取词条稀有度
    local function getEntryRarity(pet)
        local entryId = getEntryId(pet)
        local entryData = entryId > 0 and DataMgr.PetEntry[entryId]
        return entryData and entryData.Rarity or 0
    end

    -- 辅助函数：获取主战魔灵词条数量
    local function getEntryCount(pet)
        return pet.PetEntry and #pet.PetEntry or 0
    end

    -- 核心比较函数（满足严格弱序规则）
    local function compare(a, b)
        local aIsResource = not not a.IsResourcePet
        local bIsResource = not not b.IsResourcePet
        
        -- 规则1: 素材魔灵 > 主战魔灵
        if aIsResource ~= bIsResource then
           if IsASC then
                return aIsResource
           else
                return bIsResource
           end
        end

        -- 规则2: 同类型下子条件
        if aIsResource then
            if SortKind == 2 then  -- 按类型排序
                local aEntryId, bEntryId = getEntryId(a), getEntryId(b)
                if aEntryId ~= bEntryId then
                    if IsASC then--词条ID从小到大
                        return aEntryId < bEntryId
                    else
                        return aEntryId > bEntryId
                    end
                end
                -- 词条ID相同 → 按UnitId降序,从大到小
                if a.UnitId ~= b.UnitId then
                    if IsASC then
                        return a.UnitId > b.UnitId
                    else
                        return a.UnitId < b.UnitId
                    end
                    return a.UnitId > b.UnitId
                end
                return false  -- UnitId相等
            else  -- 按稀有度排序，从高到低
                local aRarity, bRarity = getEntryRarity(a), getEntryRarity(b)
                if aRarity ~= bRarity then
                    if IsASC then
                        return aRarity > bRarity
                    else
                        return aRarity < bRarity
                    end
                end
                -- 稀有度相同 → 按词条ID排序 ，从大小到大
                local aEntryId, bEntryId = getEntryId(a), getEntryId(b)
                if aEntryId ~= bEntryId then
                    if IsASC then
                        return aEntryId < bEntryId
                    else
                        return aEntryId > bEntryId
                    end
                end
                -- 词条ID相同 → 按UnitId降序，从大到小
                if a.UnitId ~= b.UnitId then
                    return a.UnitId > b.UnitId
                end
                return false  -- UnitId相等
            end
        else  -- 主战魔灵
            if SortKind == 1 then  -- 按稀有度排序
                -- 规则1: 魔灵稀有度从高到低
                local aRarity = a.Rarity or 0
                local bRarity = b.Rarity or 0
                if aRarity ~= bRarity then
                    if IsASC then
                        return aRarity > bRarity
                    else
                        return aRarity < bRarity
                    end
                end
                
                -- 规则2: 相同稀有度下，携带词条数量从多到少
                local aCount, bCount = getEntryCount(a), getEntryCount(b)
                if aCount ~= bCount then
                    if IsASC then
                        return aCount > bCount
                    else
                        return aCount < bCount
                    end
                end
                
                -- 规则3: 相同携带词条数量下，按SortPriority从大到小排序
                local aPriority = a.SortPriority or 0
                local bPriority = b.SortPriority or 0
                if aPriority ~= bPriority then
                    if IsASC then
                        return aPriority > bPriority
                    else
                        return aPriority < bPriority
                    end
                end
                
                -- 所有条件都相同，返回false
                return false
            else  -- 按类型排序（保持原有逻辑）
                local aCount, bCount = getEntryCount(a), getEntryCount(b)
                if aCount ~= bCount then
                    if IsASC then
                        return aCount < bCount
                    else
                        return aCount > bCount
                    end
                end
                -- 词条数量相同 → 按UnitId降序
                if a.UnitId ~= b.UnitId then
                    if IsASC then
                        return a.UnitId > b.UnitId
                    else
                        return a.UnitId < b.UnitId
                    end
                end
                return false  -- UnitId相等
            end
        end
    end

    table.sort(Pets, compare)
    return Pets
end

-- 复刻的可调试排序函数（插入排序实现）
-- @param arr 需要排序的数组
-- @param cmp 比较函数（a, b）返回true表示a应排在b前面
function M:CustomDebugSort(arr, cmp)
    -- 校验参数
    if type(arr) ~= "table" then error("Invalid array") end
    if type(cmp) ~= "function" then error("Invalid compare function") end

    -- 插入排序核心逻辑（步骤清晰，便于调试）
    for i = 2, #arr do
        local current = arr[i]
        local j = i - 1

        -- 输出当前比较步骤（调试关键）
        print(string.format("[DebugSort] 第%d轮比较：当前元素索引=%d，值=%s", i, i, tostring(current)))

        -- 向前比较并移动元素
        while j >= 1 and cmp(current, arr[j]) do
            -- 输出具体比较过程
            print(string.format("  比较 current=%s vs arr[%d]=%s → 结果=%s", 
                tostring(current), j, tostring(arr[j]), tostring(cmp(current, arr[j]))))

            arr[j + 1] = arr[j]
            j = j - 1
        end

        -- 插入到正确位置
        arr[j + 1] = current
        print(string.format("  插入完成，最终位置=%d\n", j + 1))
    end

    return arr
end
function M:SetContentIsSelected(Content,IsSelected)
    if(Content)then
        Content.IsSelected = IsSelected
        if(Content.Widget)then
            Content.Widget:SetIsSelected(IsSelected)
        end
        if(Content.UI)then
            Content.UI:SetIsSelected(IsSelected)
        end
    end
end

---新版道具框框选中（原SetIsSelected，边框高光）
function M:SetItemIsSelected(Content,IsSelect)
    if(Content)then
        Content.IsSelect = IsSelect
        Content.IsSelected = IsSelect
        if(Content.Widget)then
            Content.Widget:SetSelected(IsSelect)
        end
        if(Content.SelfWidget)then
            Content.SelfWidget:SetSelected(IsSelect)
        end
    end
end

---新版道具框装备态
function M:SetItemInGear(Content,bInGear)
    if(Content)then
        Content.bInGear = bInGear
        if(Content.Widget)then
            Content.Widget:SetInGear(bInGear)
        end
        if(Content.SelfWidget)then
            Content.SelfWidget:SetInGear(bInGear)
        end
    end
end

function M:SetItemSelectTag(Content,bSelectTag)
    if(Content)then
        Content.bSelectTag = bSelectTag
        if(Content.Widget)then
            Content.Widget:SetItemSelect(bSelectTag)
        end
        if(Content.SelfWidget)then
            Content.SelfWidget:SetItemSelect(bSelectTag)
            if(bSelectTag)then
                Content.SelfWidget:SetWeaponPhantomIcon(nil)
            else
                Content.SelfWidget:SetWeaponPhantomIcon(Content.Uuid)
            end
        end
    end
end

function M:SetItemLevel(Content,Level)
    if(Content)then
        Content.Level = Level
        if(Content.Widget)then
            Content.Widget:SetLevel(Level)
        end
        if(Content.SelfWidget)then
            Content.SelfWidget:SetLevel(Level)
        end
    end
end

---更新素材宠物的词条图标，目前军械库宠物列表用
function M:ResetResourcePetEntryIcons(Content,EntryId)
    if(Content)then 
        Content.PetEntry = {EntryId}
        if(Content.Widget)then
            Content.Widget:SetPetEntryId(EntryId)
        end
        if(Content.SelfWidget)then
            Content.SelfWidget:SetPetEntryId(EntryId)
        end
    end
end

function M:SetContentPhantomIcon(Content)
    if(Content)then
        if(Content.Widget and Content.Widget.SetWeaponPhantomIcon)then
            Content.Widget:SetWeaponPhantomIcon(Content.Uuid)
        end
        if(Content.SelfWidget and Content.SelfWidget.SetWeaponPhantomIcon)then
            Content.SelfWidget:SetWeaponPhantomIcon(Content.Uuid)
        end
    end
end

--region 宠物相关接口
function M:GenPetPassiveEffectDesc(PetBattleData, BaseLevel, ExpectLevel)
    local Desc = PetBattleData.PassiveEffectDesc and GText(PetBattleData.PassiveEffectDesc) or ""
    if not PetBattleData.PassiveEffectDescParameter then return Desc end
    ExpectLevel = ExpectLevel == nil and BaseLevel or ExpectLevel
    for i,DescValue in pairs(PetBattleData.PassiveEffectDescParameter) do
        local Percent = string.match(DescValue, "%%") or ""
        local ValStr = ""
        --local IsPetAttr = string.match(DescValue, "GetPetValue")
        --ValStr = IsPetAttr and self:_PetAttrGrowDesc(DescValue, BaseLevel, ExpectLevel,Percent) or ValStr
        ValStr = ValStr=="" and self:_SkillGrowDesc(DescValue, BaseLevel, ExpectLevel,Percent) or ValStr
        Desc = string.gsub(Desc, "#"..i, ValStr)
    end
    return Desc
end

function M:GetPetSkillLevel(BreakLevel)
    return BreakLevel+1
end

function M:GetPet(UniqueId)
    local Avatar = GWorld:GetAvatar()
    return Avatar.Pets[UniqueId]
end
--endregion

--region Mod相关接口
---获取Avatar的Mod数据
---@param ModUuid string
---@return CustomTypes.Mod
function M:GetMod(ModUuid) 
    -- print(_G.LogTag,"ZJT_ 通过ModUuid获取MOd 发生在Item ", ModUuid)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    if not ModUuid then return end
    ModUuid = CommonUtils.Str2ObjId(ModUuid)
    return Avatar.Mods[ModUuid]
end

--- 拼装后缀为_B的黑色图片路径
function M:GetBlackPath(Path)
    local Strs = Split(Path, ".")
    for i, _ in pairs(Strs) do
        Strs[i] = Strs[i].."_B"
    end
    return table.concat(Strs, ".")
end

--- 生成mod的被动效果文本
---@param ModConf table Mod表配置数据
---@param BaseLevel number 原始等级
---@param ExpectLevel number 期望等级(可选)
---@return string 被动效果文本
function M:GenModPassiveEffectDesc(ModConf, BaseLevel, ExpectLevel)
    local Desc = ModConf.PassiveEffectsDesc and GText(ModConf.PassiveEffectsDesc) or ""
    if not ModConf.DescValues then return Desc end

    ExpectLevel = ExpectLevel == nil and BaseLevel or ExpectLevel
    local CastTo
    for i, DescValue in pairs(ModConf.DescValues) do 
        Desc,CastTo = SkillUtils.ReplaceAndChekDescValueCast(Desc,i)
        if(string.find(DescValue, "math.floor") ~= nil)then
            CastTo = {"int"}
        end
        local Percent = string.match(DescValue, "%%") or ""
        -- local IsModAttr = string.match(DescValue, '#Mod')
        -- ValStr = IsModAttr and self:_ModAttrGrowDesc(DescValue, BaseLevel, ExpectLevel,Percent) or ValStr
        local ValStr = self:_ModAttrGrowDesc2(DescValue, BaseLevel, ExpectLevel,Percent,CastTo)
        ValStr = ValStr=="" and self:_SkillGrowDesc(DescValue, BaseLevel, ExpectLevel,Percent,CastTo) or ValStr
        Desc = string.gsub(Desc, "#"..i, ValStr)
    end
    return Desc
end

local _GetModAttrConf = function(DescValue, ModId, AttrIdx, ValueType)
    local ModConf = DataMgr.Mod[ModId]
    if not ModConf.AddAttrs then
        error("被动效果数值的ModId填错了!!!".."策划检查一下"..DescValue,0) 
        return nil
    end
    local ModAttrConf = ModConf.AddAttrs[AttrIdx]
    if not ModAttrConf then 
        error("被动效果数值的AddAttrs[索引]索引填错了!!!".."策划检查一下"..DescValue,0) 
        return nil
    end
    return ModAttrConf
end

function M:_ModAttrGrowDesc2(DescValue, BaseLevel, ExpectLevel,Percent,CastTo,ForbidFormat)
    if string.match(DescValue, "GetModValue") then
        local _GetModValue = function(GetModValue_Level)
            return function(ModId, AttrIdx, ValueType)
                local ModAttrConf = _GetModAttrConf(DescValue, ModId, AttrIdx, ValueType)
                if not ModAttrConf then
                    return 0
                end
                local Res = M:CalcModAttrByLevel(ModAttrConf, (GetModValue_Level or 0),ValueType, ModId)
                return Res
            end
        end
        local OldValStr = SkillUtils.SplitEval(DescValue, "$",{GetModValue=_GetModValue(BaseLevel)})..Percent
        local NewValStr = SkillUtils.SplitEval(DescValue, "$",{GetModValue=_GetModValue(ExpectLevel)})..Percent
        if not ForbidFormat then
            OldValStr = SkillUtils.FormatDescValue1(OldValStr,CastTo)
            NewValStr = SkillUtils.FormatDescValue1(NewValStr,CastTo)
        end
        return OldValStr~=NewValStr and OldValStr .." -> "..string.format("<H>%s</>",NewValStr)  or NewValStr
    end
    if string.match(DescValue, "GetModPolarity") then
        local _GetModPolarity = function()
            return function(ModId, AttrIdx, ValueType)
                if not  DataMgr.Mod[ModId] then
                    return DataMgr.ModPolarity[CommonConst.NonePolarity].Char
                end
                local Polarity = DataMgr.Mod[ModId].Polarity
                return DataMgr.ModPolarity[Polarity].Char
            end
        end
        local ValStr = SkillUtils.SplitEval(DescValue, "$",{GetModPolarity=_GetModPolarity()})
        return ValStr
    end
    return ""
end

--- 走SkillGrow表解析
---@param DescValue string 被动效果数值代码
---@param BaseLevel number 原始等级
---@param ExpectLevel number 期望等级(可选)
---@param Percent string|nil 是否百分制
---@return string 解析出来的数值结果字符串
function M:_SkillGrowDesc(DescValue,BaseLevel, ExpectLevel,Percent,CastTo,ForbidFormat)
    local OldValStr = SkillUtils.CalcSkillDesc(DescValue,BaseLevel, nil, true)..Percent
    local NewValStr = SkillUtils.CalcSkillDesc(DescValue,ExpectLevel, nil, true)..Percent
    local bRepeatModLevel = string.find(DescValue, "RepeatModLevel")
    if not ForbidFormat and not bRepeatModLevel then
        OldValStr = SkillUtils.FormatDescValue1(OldValStr,CastTo)
        NewValStr = SkillUtils.FormatDescValue1(NewValStr,CastTo)
    end
    return (OldValStr ~= NewValStr) and OldValStr.." -> "..string.format("<H>%s</>",NewValStr) or NewValStr
end

--- 计算Mod当前属性的接口
---@param ModAttrConf table Mod表数据的AddAttr字段
---@param ModLevel number Mod等级值，用来动态计算属性值
---@param AttrConf table AttrConfig表数据
---@param ModId number ModId
---@return number 属性数值
---@return string 值的字符串
function M:GenModAttrData(ModAttrConf, ModLevel, AttrConf, ModId)
    local IsRate = ModAttrConf.Rate~=nil
    local Value = M:CalcModAttrByLevel(ModAttrConf, ModLevel, nil,ModId)
    local ValueStr = CommonUtils.AttrValueToString(AttrConf, Value,IsRate)
    ValueStr = (Value>0 and "+" or "")..ValueStr
    return Value,ValueStr
end

---@note 根据等级计算Mod属性值
---@param ModAttrConf table Mod表数据的AddAttr字段
---@param ModLevel number Mod等级
---@param ValueType "Rate"|"Value"
---@param ModId number ModId
---@return number 属性值
function M:CalcModAttrByLevel(ModAttrConf, ModLevel, ValueType, ModId)
    local IsRate = (ModAttrConf.Rate~=nil)
    local Base = IsRate and ModAttrConf.Rate or ModAttrConf.Value
    if (ValueType) then
		if string.lower(ValueType) == "rate" then
			Base = ModAttrConf.Rate
            IsRate = true
		elseif string.lower(ValueType) == "value" then
			Base = ModAttrConf.Value
            IsRate = false
		end
	end
	if type(Base) ~= "number" then
		local AttrData = SkillUtils.GrowProxy("Mod", ModId, {
            GetSkillLevelInfo=function(self)
                return {SkillLevel = ModLevel}
            end
        }, ModAttrConf)
        local Value = tonumber(IsRate and AttrData.Rate or AttrData.Value)
        if not Value then
            DebugPrint(ErrorTag,string.format("ModId: %s 的SkillGrow配置有问题，缺少等级%s的成长数值，请检查SkillGrow表",ModId,ModLevel))
            return 0
        end
        return Value
	end
    return Base + (ModAttrConf.LevelGrow or 0) * ModLevel
end
--endregion


local DefaultCharAccessoryIds = {
    [CommonConst.CharAccessoryTypes.FX_Dead] = DataMgr.GlobalConstant.DefautFXDead.ConstantValue,
    [CommonConst.CharAccessoryTypes.FX_Teleport] = DataMgr.GlobalConstant.DefautFXTeleport.ConstantValue,
    [CommonConst.CharAccessoryTypes.FX_PlungingATK] = DataMgr.GlobalConstant.DefaultFXPlungingATK.ConstantValue,
    [CommonConst.CharAccessoryTypes.FX_HelixLeap] = DataMgr.GlobalConstant.DefaultFXHelixLeap.ConstantValue,
}

function M:GetDefaultCharAccessoryIds()
    return DefaultCharAccessoryIds
end

--region 军械库红点

local ReddotCreateFunctions = {}
---角色红点
ReddotCreateFunctions.CreateCharReddotInfos = function(M)
    local Avatar = GWorld:GetAvatar()
    local AllChars = Avatar.Chars
    for Uuid, Char in pairs(AllChars) do
        M:TryAddNewCharReddot(Char, CommonUtils.ObjId2Str(Uuid))
        -- 7命New红点
        M:TryAddNewUltraGradeCharReddot(Char)
    end
    --移除已删除角色红点缓存
    local RemoveUnknownChars = function(CacheDetail)
        if(CacheDetail)then
            local Uuid
            for key, _ in pairs(CacheDetail) do
                Uuid = CommonUtils.Str2ObjId(key)
                if(AllChars[Uuid] == nil)then
                    M:SetItemReddotRead({ItemType = CommonConst.DataType.Char,Uuid = Uuid},true,true,true)
                end
            end
        end
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(DataMgr.ReddotNode.NewChar.Name)
    RemoveUnknownChars(CacheDetail)

    for CharId, value in pairs(DataMgr.Char) do
        M:TryAddUnlockableCharReddot(CharId)
        M:TryAddNewReleasedCharReddot(CharId)
        --旧版本发布角色设为已读
        if(not CommonUtils.IsCurrentVersionNewRealease(CommonConst.DataType.Char,CharId))then
            M:_SetReddotReadCommon(CharId, DataMgr.ReddotNode.NewReleasedChar.Name,false)
        end
    end 

end
---角色技能红点
ReddotCreateFunctions.CreateCharSkillReddotInfos = function(M)
    local Avatar = GWorld:GetAvatar()
    for Uuid, Char in pairs(Avatar.Chars) do
        for _, CharSkill in pairs(Char.Skills) do
            local Ret = SkillUtils.CalcSkillCanLvup(CharSkill.SkillId, CharSkill.Level, CharSkill.Level + 1, Uuid)
            M:TryAddNewCharSkillReddot(CharSkill, CharSkill.SkillId, Uuid, Ret.CanLevelUp)
        end
    end
end
---武器
ReddotCreateFunctions.CreateWeaponReddotInfos = function(M)
    local Avatar = GWorld:GetAvatar()
    local AllWeapons = Avatar.Weapons
    for Uuid, Weapon in pairs(AllWeapons) do
        M:TryAddNewWeaponReddot(Weapon,  CommonUtils.ObjId2Str(Uuid))
    end
    --移除已删除武器红点
    local RemoveUnknownWeapons = function(CacheDetail,WeaponTag)
        if(CacheDetail)then
            local Uuid
            for key, _ in pairs(CacheDetail) do
                Uuid = CommonUtils.Str2ObjId(key)
                if(AllWeapons[Uuid] == nil)then
                    M:SetItemReddotRead({ItemType = CommonConst.DataType.Weapon,Tag = WeaponTag, Uuid = Uuid},
                    true,true,true)
                end
            end
        end
    end
    local MeleeCacheDetail = ReddotManager.GetLeafNodeCacheDetail(CommonConst.WeaponType.MeleeWeapon)
    RemoveUnknownWeapons(MeleeCacheDetail,CommonConst.WeaponType.MeleeWeapon)
    local RangedCacheDetail = ReddotManager.GetLeafNodeCacheDetail(CommonConst.WeaponType.RangedWeapon)
    RemoveUnknownWeapons(RangedCacheDetail,CommonConst.WeaponType.RangedWeapon)
end
---战斗轮盘资源
ReddotCreateFunctions.CreateResourceReddotInfos = function()
    local Avatar = GWorld:GetAvatar()
    local WheelItems = {}
    for _, Wheel in pairs(Avatar.Wheels) do
        for _, Slot in ipairs(Wheel) do
            if(Slot.ResourceId ~= nil and Slot.ResourceId ~= 0)then
                WheelItems[Slot.ResourceId] = 1
            end
        end
    end
    local AllResources = Avatar.Resources
    for RId, Resource in pairs(AllResources) do
        M:TryAddNewResourceReddot(Resource, RId)
        if(Resource.Count <= 0 or WheelItems[RId])then
            --设置数量为0的以及轮盘上的资源已读
            M:SetItemReddotRead({ItemType = CommonConst.DataType.Resource, UnitId = RId},true,true)
        end
    end
    --移除已删除轮盘资源红点缓存
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(DataMgr.ReddotNode.ArmoryBattleItem.Name)
    if(CacheDetail)then
        for key, _ in pairs(CacheDetail) do
            if(AllResources[tonumber(key)] == nil)then
                M:SetItemReddotRead({ItemType = CommonConst.DataType.Resource, UnitId = tonumber(key)},
                true,true,true)
            end
        end
    end
end
---Mod
ReddotCreateFunctions.CreateModReddotInfos = function(M)
    local Avatar = GWorld:GetAvatar()
    local AllModIds = {}
    for Uuid, Mod in pairs(Avatar.Mods) do
        if Mod.Count > 0 and Mod.Level == 0 then
            M:TryAddNewModReddot(Mod, Mod.ModId)
            AllModIds[Mod.ModId]  = CommonUtils.ObjId2Str(Uuid)
        end
    end
    if not next(AllModIds) then return end
    for ApplicationType,_ in pairs(DataMgr.ModTag) do
        local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(CommonConst.DataType.Mod..ApplicationType)
        for key, _ in pairs(CacheDetail or {}) do
            if not AllModIds[key] or DataMgr.Mod[key].ApplicationType ~= ApplicationType then
                M:SetItemReddotRead({UnitId = key, ApplicationType=ApplicationType, ItemType = CommonConst.DataType.Mod},
                true, false, true)
            end
        end
    end
end
---档案
ReddotCreateFunctions.CreateRecordReddotInfos = function(M)
    pcall (M.InitAllCharRecordReddot(),M)
end
---角色语音
ReddotCreateFunctions.CreateCharVoiceReddotInfos = function(M)
    -- local Avatar = GWorld:GetAvatar()
    -- local CharId = Avatar.CurrentChar and Avatar.Chars[Avatar.CurrentChar].CharId
    -- if not CharId then return end
    -- local CharVoiceData = DataMgr.CharVoice[CharId]
    -- if not CharVoiceData then 
    --     print(_G.LogTag, "红点添加失败，CharVoice的表数据无效，无效Id: "..CharId)
    --     return 
    -- end
    -- for VoiceId, Data in pairs(CharVoiceData) do
    --     M:TryAddNewCharVoiceReddot(Data, table.concat({CharId,VoiceId}, "_"))
    -- end
end

local CreateOneCharAppearanceReddotInfos = function(CharId)
    local Avatar = GWorld:GetAvatar()
    local CommonChar = Avatar.CommonChars[CharId]
    local AllAccessorys = Avatar.CharAccessorys
    local CharAllSkin = CommonChar.OwnedSkins
    for _, Skin in pairs(CharAllSkin) do
        if(Skin.SkinId ~= CommonChar.CharId)then
            M:TryAddNewCharSkinReddot(Skin.SkinId,CommonChar.CharId)
        end
        --移除已删除角色皮肤特有配饰红点缓存
        for AccessoryType, value in pairs(CommonConst.NewCharAccessoryTypes) do
            local LeafNodeName = CommonConst.DataType.CharAccessory .. AccessoryType .. Skin.SkinId
            local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(LeafNodeName)
            if(CacheDetail)then
                for key, _ in pairs(CacheDetail) do
                    key = tonumber(key)
                    if(AllAccessorys[key] == nil or not CommonUtils.IsCurrentTimeRealease(CommonConst.DataType.CharAccessory,key))then
                        M:SetItemReddotRead({ItemType = CommonConst.DataType.CharAccessory, AccessoryId = key},
                        true,true,true)
                    end
                end
            end
        end
    end
    --移除已删除角色皮肤红点缓存
    local LeafNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Skin .. CommonChar.CharId
    if not ReddotManager.GetTreeNode(LeafNodeName) then
        ReddotManager.AddNode(LeafNodeName, nil, 1)
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(LeafNodeName)
    if(CacheDetail)then
        for key, _ in pairs(CacheDetail) do
            key = tonumber(key)
            if(CharAllSkin[key] == nil or not CommonUtils.IsCurrentTimeRealease(CommonConst.DataType.Skin,key))then
                M:SetItemReddotRead({ItemType = CommonConst.DataType.Skin, SkinId = key},
                true,true,true)
            end
        end
    end
    local CharAllHair = CommonChar.OwnedHairs
    for HairId, Hair in pairs(CharAllHair) do
        if(HairId ~= CommonChar.CharId)then
            M:TryAddNewCharHairReddot(HairId,CommonChar.CharId)
        end
    end
    --移除已删除角色发型红点缓存
    local LeafNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Hair .. CommonChar.CharId
    if not ReddotManager.GetTreeNode(LeafNodeName) then
        ReddotManager.AddNode(LeafNodeName, nil, 1)
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(LeafNodeName)
    if(CacheDetail)then
        for key, _ in pairs(CacheDetail) do
            key = tonumber(key)
            if(CharAllSkin[key] == nil or not CommonUtils.IsCurrentTimeRealease(CommonConst.DataType.Hair,key))then
                M:SetItemReddotRead({ItemType = CommonConst.DataType.Hair, HairId = key},
                true,true,true)
            end
        end
    end
end

---角色外观
ReddotCreateFunctions.CreateCharAppearanceReddotInfos = function(M)
    local Avatar = GWorld:GetAvatar()
    local AllAccessorys = Avatar.CharAccessorys
    local AccessoryIds = {}
    local DefaultAcceesories = {
        [CommonConst.CharAccessoryTypes.FX_Dead] = DataMgr.GlobalConstant.DefautFXDead.ConstantValue,
        [CommonConst.CharAccessoryTypes.FX_Teleport] = DataMgr.GlobalConstant.DefautFXTeleport.ConstantValue,
        [CommonConst.CharAccessoryTypes.FX_PlungingATK] = DataMgr.GlobalConstant.DefaultFXPlungingATK.ConstantValue,
        [CommonConst.CharAccessoryTypes.FX_HelixLeap] = DataMgr.GlobalConstant.DefaultFXHelixLeap.ConstantValue,
    }
    for _, AccessoryId in pairs(AllAccessorys) do
        AccessoryIds[AccessoryId] = true
        local CharAccessoryData = DataMgr.CharAccessory[AccessoryId]
        if(CharAccessoryData and CharAccessoryData.AccessoryType
            and (not DefaultAcceesories[CharAccessoryData.AccessoryType]
                or (AccessoryId ~= DefaultAcceesories[CharAccessoryData.AccessoryType]
                     and CommonUtils.IsCurrentTimeRealease(CommonConst.DataType.CharAccessory,AccessoryId)))
            )then
            for _, SkinId in ipairs(CharAccessoryData.Skin or {""}) do
                M:TryAddNewCharAccessoryReddot(AccessoryId,SkinId)
            end
        end
    end

    --移除已删除角色配饰红点缓存
    for AccessoryType, value in pairs(CommonConst.NewCharAccessoryTypes) do
        local LeafNodeName = CommonConst.DataType.CharAccessory .. AccessoryType
        if not ReddotManager.GetTreeNode(LeafNodeName) then
            -- 先创建节点，防止新账号监听不到红点事件
            ReddotManager.AddNode(LeafNodeName, nil, 1)
        end
        local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(LeafNodeName)
        if(CacheDetail)then
            for key, _ in pairs(CacheDetail) do
                key = tonumber(key)
                if(AccessoryIds[key] == nil
                or key == DefaultAcceesories[AccessoryType]
                or not CommonUtils.IsCurrentTimeRealease(CommonConst.DataType.CharAccessory,key))then
                    M:SetItemReddotRead({ItemType = CommonConst.DataType.CharAccessory, AccessoryId = key},
                    true,true,true)
                end
            end
        end
    end

    for _, CommonChar in pairs(Avatar.CommonChars) do
        CreateOneCharAppearanceReddotInfos(CommonChar.CharId)
    end
end

---武器外观
ReddotCreateFunctions.CreateWeaponAppearanceReddotInfos = function(M)
    local Avatar = GWorld:GetAvatar()
    if not ReddotManager.GetTreeNode(CommonConst.DataType.WeaponAccessory) then
        -- 如果叶子节点不存在则创建
        ReddotManager.AddNode(CommonConst.DataType.WeaponAccessory, nil, 1)
    end
    local AllAccessorys = Avatar.WeaponAccessorys
    local AccessoryIds = {}
    for _, AccessoryId in pairs(AllAccessorys) do
        AccessoryIds[AccessoryId] = true
        local AccessoryData = DataMgr.WeaponAccessory[AccessoryId]
        if(AccessoryData and CommonUtils.IsCurrentTimeRealease(CommonConst.DataType.WeaponAccessory,AccessoryId))then
            M:TryAddNewWeaponAccessoryReddot(AccessoryId)
        end
    end
    ----移除已删除武器配饰红点缓存
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(CommonConst.DataType.WeaponAccessory)
    if(CacheDetail)then
        for key, _ in pairs(CacheDetail) do
            key = tonumber(key)
            if(AccessoryIds[key] == nil or not CommonUtils.IsCurrentTimeRealease(CommonConst.DataType.WeaponAccessory,key))then
                M:SetItemReddotRead({ItemType = CommonConst.DataType.WeaponAccessory, AccessoryId = key},
                true,true,true)
            end
        end
    end

    local AllWeaponSkins = Avatar.OwnedWeaponSkins
    for SkinId, _ in pairs(AllWeaponSkins) do
        local SkinData = DataMgr.WeaponSkin[SkinId]
        if(SkinData and CommonUtils.IsCurrentTimeRealease(CommonConst.DataType.WeaponSkin,SkinId))then
            M:TryAddNewWeaponSkinReddot(SkinId)
        end
    end
    
    ----移除已删除武器皮肤红点缓存
    local AllWeaponSkinApplicationType = {}
    for WeaponId, value in pairs(DataMgr.Weapon) do
        if(value.SkinApplicationType)then
            for _, ApplicationType in ipairs(value.SkinApplicationType) do
                AllWeaponSkinApplicationType[ApplicationType] = true
            end
        end
    end
    for key, value in pairs(AllWeaponSkinApplicationType) do
        local LeftNodeName = CommonConst.DataType.WeaponSkin .. key
        if not ReddotManager.GetTreeNode(LeftNodeName) then
            -- 如果叶子节点不存在则创建
            ReddotManager.AddNode(LeftNodeName, nil, 1)
        end
        local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(LeftNodeName)
        if(CacheDetail)then
            for key, _ in pairs(CacheDetail) do
                key = tonumber(key)
                if(AllWeaponSkins[key] == nil or not CommonUtils.IsCurrentTimeRealease(CommonConst.DataType.WeaponSkin,key))then
                    M:SetItemReddotRead({ItemType = CommonConst.DataType.WeaponSkin, SkinId = key},
                    true,true,true)
                end
            end
        end
    end
end
---宠物
ReddotCreateFunctions.CreatePetReddotInfos = function(M)
    local Avatar = GWorld:GetAvatar()
    local AllPets = Avatar.Pets
    for UniqueId, Pet in pairs(AllPets) do
        M:TryAddNewPetReddot(Pet,UniqueId)
    end
    local PetCacheDetail = ReddotManager.GetLeafNodeCacheDetail(CommonConst.DataType.Pet) or {}
    local ResourcePetCacheDetail = ReddotManager.GetLeafNodeCacheDetail("Resource" .. CommonConst.DataType.Pet) or {}
    for key, _ in pairs(ResourcePetCacheDetail) do
        if(AllPets[tonumber(key)] == nil)then
            M:SetItemReddotRead({ItemType = CommonConst.DataType.Pet, UniqueId = key},
            true,true,true)
        end
    end
    for key, _ in pairs(PetCacheDetail) do
        if(AllPets[tonumber(key)] == nil)then
            M:SetItemReddotRead({ItemType = CommonConst.DataType.Pet, UniqueId = key},
            true,true,true)
        end
    end
end

---创建红点信息
---@param Type string 类型：Char|Weapon|Resource|Mod|Record|Accessory|CharVoice
function M:CreateReddotInfos(ItemType)
    if(not ItemType or ItemType == "")then
        return
    end  
    local FunctionName = "Create" .. ItemType .. "ReddotInfos"
    if(ReddotCreateFunctions[FunctionName])then
        return ReddotCreateFunctions[FunctionName](M)
    end
end

---@deprecated (请使用SetItemReddotRead, 注意Content.Type改名为Content.ItemType)
---设置红点已读
---@param Content table 参数表
---@param Content.Type string 红点所属道具类型 Char|Weapon|Resource|Mod|Record|Accessory|CharVoice
---@param ReadNew bool 已读“新”
---@param ReadUpgradeable bool 已读“可升级”
---@param bDeleteCache bool 删除对应红点缓存
function M:SetReddotRead(Content,ReadNew,ReadUpgradeable,bDeleteCache)
    if(self.IsPreviewMode)then
        return
    end
    if not Content then return end
    local functions = {}
    ---角色红点已读
    functions.SetCharReddotRead = function()
        local UuidStr = CommonUtils.ObjId2Str(Content.Uuid)
        if(ReadNew)then
            M:_SetReddotReadCommon(UuidStr, DataMgr.ReddotNode.NewChar.Name,bDeleteCache)
        end
        if(ReadUpgradeable)then
            M:_SetReddotReadCommon(UuidStr, DataMgr.ReddotNode.PromoteChar.Name,bDeleteCache)
        end
    end
    ---角色技能红点已读
    functions.SetCharSkillReddotRead = function()
        local NodeName = Content.Type..CommonUtils.ObjId2Str(Content.CharUuid)  
        local CacheKey = Content.SkillId
        M:_SetReddotReadCommon(CacheKey,NodeName)
    end
    ---武器红点已读
    functions.SetWeaponReddotRead = function()
        local UuidStr = CommonUtils.ObjId2Str(Content.Uuid)
        M:_SetReddotReadCommon(UuidStr,  Content.Tag,bDeleteCache)
    end
    ---资源红点已读
    functions.SetResourceReddotRead = function()
        local ResData = DataMgr.Resource[Content.UnitId]
        if not ResData then
            local Avatar = GWorld:GetAvatar()
            if not Avatar then return end
            ResData = Avatar.Resources[Content.UnitId]
        end
        if not ResData then return end
        local bBattleItem = string.match(ResData.Type, "BattleItem")
        if not bBattleItem then return end
        M:_SetReddotReadCommon(Content.UnitId,  DataMgr.ReddotNode.ArmoryBattleItem.Name,bDeleteCache)
    end
    ---Mod红点已读
    functions.SetModReddotRead = function()
        local ApplicationType = Content.ApplicationType
        local ModId = Content.UnitId
        if not ApplicationType then
            ApplicationType = DataMgr.Mod[ModId].ApplicationType
        end
        local NodeName = CommonConst.DataType.Mod..ApplicationType
        M:_SetReddotReadCommon(ModId, NodeName, bDeleteCache)
    end
    ---档案红点已读
    functions.SetRecordReddotRead = function()
        local NodeName = table.concat({M.FilesTabType[2],Content.CharId,Content.ReddotType}, "_")
        local CacheKey = table.concat({Content.CharId,Content.CharDataTarget}, "_")
        M:_SetReddotReadCommon(CacheKey, NodeName)
    end
    ---角色语音已读
    functions.SetCharVoiceReddotRead = function()
        local NodeName = table.concat({M.FilesTabType[1],Content.CharId,Content.ReddotType}, "_")
        local CacheKey = table.concat({Content.CharId,Content.VoiceId}, "_")
        M:_SetReddotReadCommon(CacheKey, NodeName)
    end
    ---配饰红点已读
    functions.SetCharAccessoryReddotRead = function()
        local AccessoryId = Content.AccessoryId
        local Data = DataMgr.CharAccessory[AccessoryId]
        if not Data then return end
        local NodeNamePre = CommonConst.DataType.CharAccessory..Data.AccessoryType
        for _,CharId in ipairs(Data.Char or {"",}) do
            local NodeName = NodeNamePre..CharId
            M:_SetReddotReadCommon(AccessoryId, NodeName)
        end    
    end
    ---宠物红点已读
    functions.SetPetReddotRead = function()
        local UniqueIdStr = Content.UniqueId
        M:_SetReddotReadCommon(UniqueIdStr,  Content.Type,bDeleteCache)
    end
    if(functions["Set"..Content.Type .. "ReddotRead"])then
        functions["Set"..Content.Type .. "ReddotRead"]()
        if(ReadNew)then
            Content.IsNew = false
        end
        if (ReadUpgradeable) then
            Content.Upgradeable = false
        end
        if(Content.UI and Content.UI.SetReddot)then
            Content.UI:SetReddot(Content.IsNew,Content.Upgradeable)
        end
        if(Content.Widget and Content.Widget.SetReddot)then
            Content.Widget:SetReddot(Content.IsNew,Content.Upgradeable)
        end
    end
end

local SetReddotReadFunctions = {
    ---角色红点已读
    SetCharReddotRead = function(self,Content,ReadNew,ReadUpgradeable,bDeleteCache)
        if(tonumber(Content.Uuid) == nil and CommonUtils.IsObjId(Content.Uuid))then
            local UuidStr = CommonUtils.ObjId2Str(Content.Uuid)
            if(ReadNew)then
                M:_SetReddotReadCommon(UuidStr, DataMgr.ReddotNode.NewChar.Name,bDeleteCache)
            end
            if(ReadUpgradeable)then
                M:_SetReddotReadCommon(UuidStr, DataMgr.ReddotNode.PromoteChar.Name,bDeleteCache)
            end
        end
        if(ReadNew and Content.UnitId)then
            M:_SetReddotReadCommon(Content.UnitId, DataMgr.ReddotNode.NewReleasedChar.Name,bDeleteCache)
        end
    end,
    ---角色技能红点已读
    SetCharSkillReddotRead = function(self,Content,ReadNew,ReadUpgradeable,bDeleteCache)
        local NodeName = Content.Type..CommonUtils.ObjId2Str(Content.CharUuid)
        local CacheKey = Content.SkillId
        M:_SetReddotReadCommon(CacheKey,NodeName)
    end,
    ---武器红点已读
    SetWeaponReddotRead = function(self,Content,ReadNew,ReadUpgradeable,bDeleteCache)
        local UuidStr = CommonUtils.ObjId2Str(Content.Uuid)
        M:_SetReddotReadCommon(UuidStr,  Content.Tag,bDeleteCache)
    end,
    ---资源红点已读
    SetResourceReddotRead = function(self,Content,ReadNew,ReadUpgradeable,bDeleteCache)
        local ResData = DataMgr.Resource[Content.UnitId]
        if not ResData then
            local Avatar = GWorld:GetAvatar()
            if not Avatar then return end
            ResData = Avatar.Resources[Content.UnitId]
        end
        if not ResData then return end
        local bBattleItem = string.match(ResData.Type, "BattleItem")
        if not bBattleItem then return end
        M:_SetReddotReadCommon(Content.UnitId,  DataMgr.ReddotNode.ArmoryBattleItem.Name,bDeleteCache)
    end,
    ---Mod红点已读
    SetModReddotRead = function(self,Content,ReadNew,ReadUpgradeable,bDeleteCache)
        local ApplicationType = Content.ApplicationType
        local ModId = Content.UnitId
        if not ApplicationType then
            ApplicationType = DataMgr.Mod[ModId].ApplicationType
        end
        local NodeName = CommonConst.DataType.Mod..ApplicationType
        M:_SetReddotReadCommon(ModId, NodeName, bDeleteCache)
    end,
    ---档案红点已读
    SetRecordReddotRead = function(self,Content,ReadNew,ReadUpgradeable,bDeleteCache)
        local NodeName = table.concat({M.FilesTabType[2],Content.CharId,Content.ReddotType}, "_")
        local CacheKey = table.concat({Content.CharId,Content.CharDataTarget}, "_")
        M:_SetReddotReadCommon(CacheKey, NodeName)
    end,
    ---角色语音已读
    SetCharVoiceReddotRead = function(self,Content,ReadNew,ReadUpgradeable,bDeleteCache)
        local NodeName = table.concat({M.FilesTabType[1],Content.CharId,Content.ReddotType}, "_")
        local CacheKey = table.concat({Content.CharId,Content.VoiceId}, "_")
        M:_SetReddotReadCommon(CacheKey, NodeName)
    end,
    ---角色配饰红点已读
    SetCharAccessoryReddotRead = function(self,Content,ReadNew,ReadUpgradeable,bDeleteCache)
        local AccessoryId = Content.AccessoryId
        local Data = DataMgr.CharAccessory[AccessoryId]
        if not Data then return end
        local NodeNamePre = CommonConst.DataType.CharAccessory..Data.AccessoryType
        for _,SkinId in ipairs(Data.Skin or {""}) do
            local NodeName = NodeNamePre..SkinId
            M:_SetReddotReadCommon(AccessoryId, NodeName)
        end
    end,
    ---角色皮肤已读
    SetSkinReddotRead = function(self,Content,ReadNew,ReadUpgradeable,bDeleteCache)
        if(not Content.CharId)then return end
        local NodeName = CommonConst.DataType.Char .. CommonConst.DataType.Skin .. Content.CharId
        M:_SetReddotReadCommon(Content.SkinId, NodeName)
    end,
    ---角色发型已读
    SetHairReddotRead = function(self,Content,ReadNew,ReadUpgradeable,bDeleteCache)
        if(not Content.CharId)then return end
        local NodeName = CommonConst.DataType.Char .. CommonConst.DataType.Hair .. Content.CharId
        M:_SetReddotReadCommon(Content.HairId, NodeName)
    end,
    ---武器皮肤已读
    SetWeaponSkinReddotRead = function(self,Content,ReadNew,ReadUpgradeable,bDeleteCache)
        local SkinId = Content.SkinId
        local Data = DataMgr.WeaponSkin[SkinId]
        if not Data then return end
        local NodeName = CommonConst.DataType.WeaponSkin .. (Data.ApplicationType or "")
        M:_SetReddotReadCommon(SkinId, NodeName)
    end,
    ---武器配饰已读
    SetWeaponAccessoryReddotRead = function(self,Content,ReadNew,ReadUpgradeable,bDeleteCache)
        local AccessoryId = Content.AccessoryId
        local Data = DataMgr.WeaponAccessory[AccessoryId]
        if not Data then return end
        local NodeName = CommonConst.DataType.WeaponAccessory
        M:_SetReddotReadCommon(AccessoryId, NodeName)
    end,
    ---宠物红点已读
    SetPetReddotRead = function(self,Content,ReadNew,ReadUpgradeable,bDeleteCache)
        local UniqueIdStr = Content.UniqueId
        local NodeName = CommonConst.DataType.Pet
        --素材宠物先设置已读
        M:_SetReddotReadCommon(UniqueIdStr, "Resource"..NodeName, bDeleteCache)
        M:_SetReddotReadCommon(UniqueIdStr, NodeName, bDeleteCache)
        EventManager:FireEvent(EventID.OnPetReddotRead, UniqueIdStr,Content)
    end,
}

---设置红点已读
---@param Content table 参数表
---@param Content.Type string 红点所属道具类型 Char|Weapon|Resource|Mod|Record|Accessory|CharVoice
---@param ReadNew bool 已读“新”
---@param ReadUpgradeable bool 已读“可升级”
---@param bDeleteCache bool 删除对应红点缓存
function M:SetItemReddotRead(Content,ReadNew,ReadUpgradeable,bDeleteCache)
    if(self.IsPreviewMode)then
        return
    end
    if not Content then return end
    if(SetReddotReadFunctions["Set"..(Content.ItemType or Content.Type) .. "ReddotRead"])then
        SetReddotReadFunctions["Set"..(Content.ItemType or Content.Type) .. "ReddotRead"](self,Content,ReadNew,ReadUpgradeable,bDeleteCache)
        if(ReadNew)then
            Content.IsNew = false
        end
        if (ReadUpgradeable) then
            Content.Upgradeable = false
        end
        M:UpdateContentRetDotType(Content)
    end
end

function M:UpdateContentRetDotType(Content)
    if Content.IsNew then
        Content.RedDotType = UIConst.RedDotType.NewRedDot
    elseif Content.Upgradeable or Content.HasReward or Content.Unlockable then
        Content.RedDotType = UIConst.RedDotType.CommonRedDot
    else
        Content.RedDotType = nil
    end
    if(Content.SelfWidget and Content.SelfWidget.SetRedDot)then
        Content.SelfWidget:SetRedDot(Content.RedDotType)
    end
    if(Content.Widget and Content.Widget.SetReddot)then
        Content.Widget:SetReddot(Content.RedDotType)
    end
end

--- 当角色新获得7命资格时添加红点
---@param Char table 角色
function M:TryAddNewUltraGradeCharReddot(Char)
    if Char:HasUltraGradeLevel() and not Char:IsExtraGradeLevelUnlocked() then
        return M:_TryAddNewReddotCommon(Char.CharId, DataMgr.ReddotNode.NewUltraGradeChar.Name)
    end
    return false
end

--- 标记7命New已读
---@param CharId number 角色Id
function M:SetUltraGradeCharReddotRead(CharId)
    M:_SetReddotReadCommon(CharId, DataMgr.ReddotNode.NewUltraGradeChar.Name)
end

---设置陈列室红点已读
---@param Content table 参数表
function M:SetArchiveReddotRead(Content)
    if(not Content.IsNew)then
        return
    end
    Content.IsNew = false
    if Content.Upgradeable then
        Content.RedDotType = UIConst.RedDotType.CommonRedDot
    else
        Content.RedDotType = nil
    end
    if(Content.SelfWidget and Content.SelfWidget.SetRedDot)then
        Content.SelfWidget:SetRedDot(Content.RedDotType)
    end
    if(Content.Widget and Content.Widget.SetReddot)then
        Content.Widget:SetReddot(Content.RedDotType)
    end
    local NodeName = nil
    if(Content.Type == "Char")then
        NodeName = DataMgr.ReddotNode.ArchiveNewChar.Name
    elseif(Content.Tag == "Melee")then
        NodeName = DataMgr.ReddotNode.ArchiveNewMelee.Name
    elseif(Content.Tag == "Ranged")then
        NodeName = DataMgr.ReddotNode.ArchiveNewRanged.Name
    end
    if(NodeName)then
        if(not ReddotManager.GetTreeNode(NodeName))then
            ReddotManager.AddNode(NodeName)
        end
        local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
        if(CacheDetail[Content.UnitId] == 1)then
            CacheDetail[Content.UnitId] = 0
            ReddotManager.DecreaseLeafNodeCount(NodeName)
        end
    end
end

---批量设置红点已读
---@param Contents table 参数表
---@param Content.Type string 红点所属道具类型 Char|Weapon|Resource|Mod|Record|Accessory|CharVoice
---@param ReadNew bool 已读“新”
---@param ReadUpgradeable bool 已读“可升级”
function M:SetReddotsRead(Contents,ReadNew,ReadUpgradeable)
    for _, Content in pairs(Contents) do
        self:SetItemReddotRead(Content,ReadNew,ReadUpgradeable)
    end
end

---@note 当获得新Mod尝试添加红点计数
---@param Mod Mod Avatar的Mod数据
---@param ModId string  Mod的字符串Uuid
function M:TryAddNewModReddot(Mod, ModId)
    if Mod.Level >0 then return end
    if Mod.Count == 0 then return end
    if(self.IsPreviewMode)then
        return
    end
    if not Mod:Data() then
        print(_G.LogTag, "红点添加失败，Mod的表数据无效，无效Id: "..Mod.ModId)
        return false
    end
    if ModId == nil then ModId = Mod.ModId end
    self:TryAddNewModBookReddot(Mod, ModId)
    local NodeName = CommonConst.DataType.Mod..Mod.ApplicationType
    return M:_TryAddNewReddotCommon(ModId, NodeName)
end

---@note 当获得新Mod尝试添加Mod手册计数
---@param Mod Mod Avatar的Mod数据
---@param ModId string  Mod的字符串Uuid
function M:TryAddNewModBookReddot(Mod, ModId)
    local Avatar = GWorld:GetAvatar()
    if Avatar.HoldMods and Avatar.HoldMods[ModId] then
        -- 已获得过跳过
        return
    end
    local ArchiveId = DataMgr.ModId2ArchiveId[ModId]
    if not ArchiveId then return end
    if Avatar.HoldModRewards and Avatar.HoldModRewards[ArchiveId] then
        -- 已领取过该图鉴组的奖励，跳过
        return
    end
    local ModList = DataMgr.ModGuideBookArchive[ArchiveId].ModList
    for i = 1, #ModList do
        if ModId ~= ModList[i] and not Avatar.HoldMods[ModList[i]] then
            -- 除当前获得的这个以外的列表中有Mod没有获得过，说明收集未完成，不添加红点
            return
        end
    end
    local ReddotNode = DataMgr.ModGuideBookArchiveTab[DataMgr.ModGuideBookArchive[ArchiveId].TabId].ReddotNode
    if not ReddotManager.GetTreeNode("ModArchive") then
        ReddotManager.AddNodeEx("ModArchive")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotNode)
    if not CacheDetail then
        CacheDetail = {}
    end
    if not CacheDetail.RedNum then
        CacheDetail.RedNum = 0
    end
    CacheDetail.RedNum = CacheDetail.RedNum + 1
    ReddotManager.IncreaseLeafNodeCount(ReddotNode, 1, CacheDetail)
end

---@note 当获得新武器尝试添加红点计数
---@param Weapon Weapon Avatar的武器数据
---@param UuidStr string  武器的字符串Uuid
function M:TryAddNewWeaponReddot(Weapon, UuidStr)
    if(self.IsPreviewMode)then
        return
    end
    if not Weapon:BattleData() or not Weapon:Data() then
        print(_G.LogTag, "红点添加失败，Weapon的表数据无效，无效Id: "..Weapon.WeaponId)
        return false
    end
    if(Weapon:HasTag(CommonConst.WeaponType.UltraWeapon))then return false end
    if UuidStr == nil then UuidStr = CommonUtils.ObjId2Str(Weapon.Uuid) end
    local _TryAddNewWeaponReddot = function(WeaponType)
        return M:_TryAddNewReddotCommon(UuidStr, WeaponType)
    end
    local IsNew = false
    if(Weapon:HasTag(CommonConst.WeaponType.MeleeWeapon)) then
        IsNew = _TryAddNewWeaponReddot(CommonConst.WeaponType.MeleeWeapon) or IsNew
    end
    if(Weapon:HasTag(CommonConst.WeaponType.RangedWeapon)) then
        IsNew = _TryAddNewWeaponReddot(CommonConst.WeaponType.RangedWeapon) or IsNew
    end
    local HasReward = M:TryAddWeaponRewardReddot(Weapon.WeaponId)
    return IsNew,false,HasReward
end

---@note 当获得新战斗轮盘道具尝试添加红点计数
---@param Resource Resource Avatar的道具数据
---@param Id number  道具的Id
function M:TryAddNewResourceReddot(Resource, Id)
    if(self.IsPreviewMode)then
        return
    end
    if not Resource:Data() then
        print(_G.LogTag, "红点添加失败，Resource的表格数据无效，无效Id: "..Resource.ResourceId)
        return false
    end
    local ResData = Resource:Data()
    if not ResData then return end
    if Id == nil then Id = Resource.ResourceId end
    local bBattleItem = string.match(ResData.Type, "BattleItem")
    if not bBattleItem then return end
    return M:_TryAddNewReddotCommon(Id, DataMgr.ReddotNode.ArmoryBattleItem.Name)
end

---@note 当获得新的角色尝试添加红点计数
---@param Char Char Avatar角色数据
---@param UuidStr string 角色Uuid
function M:TryAddNewCharReddot(Char, UuidStr)
    if(self.IsPreviewMode)then
        return
    end
    if not Char:Data() or not Char:BattleData() then
        print(_G.LogTag, "红点添加失败，Char的表数据无效，无效CharId: "..Char.CharId.."无效RoleId: "..Char.RoleId)
        return false
    end
    if UuidStr == nil then UuidStr = CommonUtils.ObjId2Str(Char.Uuid) end
    local CardUpgradeable = UpgradeUtils.CheckCharCanUpgradeCardLevel(Char)
    local UltraUpgradeable = UpgradeUtils.CheckCharCanUpgradeUltraCardLevel(Char)
    local Upgradeable = CardUpgradeable or UltraUpgradeable
    local PromoteRes = M:_TryAddNewReddotCommon(UuidStr, DataMgr.ReddotNode.PromoteChar.Name, true, not Upgradeable)
    if not Upgradeable then
        self:_SetReddotReadCommon(UuidStr, DataMgr.ReddotNode.PromoteChar.Name)
    end
    CreateOneCharAppearanceReddotInfos(Char.CharId)
    local HasReward = M:TryAddCharRewardReddot(Char.CharId)
    return M:_TryAddNewReddotCommon(UuidStr, DataMgr.ReddotNode.NewChar.Name), PromoteRes, HasReward
end

function M:TryAddCharRewardReddot(CharId)
    if(self.IsPreviewMode)then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if(Avatar:IsCharHasReward(CharId))then
        return M:_TryAddNewReddotCommon(CharId, DataMgr.ReddotNode.CharReward.Name)
    end
end

function M:TryAddWeaponRewardReddot(WeaponId)
    local Avatar = GWorld:GetAvatar()
    if(Avatar:IsWeaponHasReward(WeaponId))then
        local WeaponType = CommonUtils.GetWeaponTypeById(WeaponId) or ""
        if(WeaponType == CommonConst.WeaponType.MeleeWeapon)then
            return M:_TryAddNewReddotCommon(WeaponId, DataMgr.ReddotNode.MeleeReward.Name)
        elseif(WeaponType == CommonConst.WeaponType.RangedWeapon)then
            return M:_TryAddNewReddotCommon(WeaponId, DataMgr.ReddotNode.RangedReward.Name)
        end
    end
end

function M:TryAddUnlockableCharReddot(CharId)
    if(self.IsPreviewMode)then
        return
    end
    local Avatar = GWorld:GetAvatar()
    local Data = DataMgr.Char[CharId]
    if(not Data or Data.IsNotOpen or Avatar:GetCharUuidByCharId(CharId))then
        return
    end
    local Rid = Data.CharPieceId
    local Resource = Avatar.Resources[Rid] or {Count = 0}
    if(Resource.Count <= 0)then
        return
    end
    if(Data.CharUnlockRequiredPiece and Data.CharUnlockRequiredPiece <= Resource.Count)then
        return M:_TryAddNewReddotCommon(CharId, DataMgr.ReddotNode.UnlockableChar.Name)
    end
end

function M:TryAddNewReleasedCharReddot(CharId)
    if(self.IsPreviewMode)then
        return
    end
    local Data = DataMgr.Char[CharId]
    if(not Data or Data.IsNotOpen or not CommonUtils.IsCurrentVersionNewRealease(CommonConst.DataType.Char,CharId))then
        return
    end
    return M:_TryAddNewReddotCommon(CharId, DataMgr.ReddotNode.NewReleasedChar.Name)
end

---@note 当技能可升级时尝试添加红点计数
---@param CharSkill Skill Avatar的技能数据
---@param Id number 技能Id
---@param CharUuid ObjectId 角色Uuid
function M:TryAddNewCharSkillReddot(CharSkill, Id, CharUuid, bCanLevelUp)
    if(self.IsPreviewMode)then
        return
    end
    if not CharSkill:Data() then
        print(_G.LogTag, "红点添加失败，CharSkill的表数据无效，无效Id: "..CharSkill.SkillId)
        return false
    end
    if Id == nil then Id = CharSkill.SkillId end
    local UuidStr = CommonUtils.ObjId2Str(CharUuid)
    local NodeName = CommonConst.DataType.Char..Const.Skill
    local SkillData=DataMgr.Skill[CharSkill.SkillId]
    if SkillData and SkillData[1] and SkillData[1][0] then
        if bCanLevelUp == nil then bCanLevelUp = true end
        return M:_TryAddNewReddotCommon(Id, NodeName..UuidStr, true, not bCanLevelUp)
    end
    return false
end

---@note 当获得新配饰尝试添加红点计数
---@param AccessoryId number 配饰Id
---@param SkinId number 皮肤Id，因为有些配饰是皮肤独占的
function M:TryAddNewCharAccessoryReddot(AccessoryId, SkinId)
    if(self.IsPreviewMode)then
        return
    end
    local CharAccessoryData = DataMgr.CharAccessory[AccessoryId]
    if not CharAccessoryData then
        print(_G.LogTag, "红点添加失败，CharAccessory的表数据无效，无效Id: "..AccessoryId)
        return false
    end
    local ReddotName = CommonConst.DataType.CharAccessory..CharAccessoryData.AccessoryType
    SkinId = SkinId or ""
    return M:_TryAddNewReddotCommon(AccessoryId,ReddotName..SkinId)
end

function M:TryAddNewCharSkinReddot(SkinId,CharId)
    if(self.IsPreviewMode)then
        return
    end
    local CharSkinData = DataMgr.Skin[SkinId]
    if not CharSkinData then
        return false
    end
    local ReddotName = CommonConst.DataType.Char .. CommonConst.DataType.Skin .. CharId
    --获得新皮肤时创建该皮肤对应的配饰红点节点
    for AccessoryType, value in pairs(CommonConst.NewCharAccessoryTypes) do
        local LeafNodeName = CommonConst.DataType.CharAccessory .. AccessoryType .. SkinId
        if not ReddotManager.GetTreeNode(LeafNodeName) then
            ReddotManager.AddNode(LeafNodeName, nil, 1)
        end
    end
    return M:_TryAddNewReddotCommon(SkinId,ReddotName)
end

function M:TryAddNewCharHairReddot(HairId,CharId)
    if(self.IsPreviewMode)then
        return
    end
    local CharHairData = DataMgr.Hair[HairId]
    if not CharHairData then
        return false
    end
    local ReddotName = CommonConst.DataType.Char .. CommonConst.DataType.Hair .. CharId
    return M:_TryAddNewReddotCommon(HairId,ReddotName)
end

function M:TryAddNewWeaponAccessoryReddot(AccessoryId)
    if(self.IsPreviewMode)then
        return
    end
    local AccessoryData = DataMgr.WeaponAccessory[AccessoryId]
    if not AccessoryData then
        return false
    end
    local ReddotName = CommonConst.DataType.WeaponAccessory
    return M:_TryAddNewReddotCommon(AccessoryId,ReddotName)
end

function M:TryAddNewWeaponSkinReddot(SkinId)
    if(self.IsPreviewMode)then
        return
    end
    local WeaponSkinData = DataMgr.WeaponSkin[SkinId]
    if not WeaponSkinData then
        return false
    end
    local ReddotName = CommonConst.DataType.WeaponSkin .. (WeaponSkinData.ApplicationType or "")
    return M:_TryAddNewReddotCommon(SkinId,ReddotName)
end

---@note 当获得新的角色语音尝试添加红点计数
---@param VoiceData table<any> 角色语音数据
---@param CacheKey string “角色Id_语音Id”拼凑的字符串，用来做缓存的key
function M:TryAddNewCharVoiceReddot(VoiceData, CacheKey)
    if(self.IsPreviewMode)then
        return
    end
    if not CacheKey then CacheKey = table.concat({VoiceData.CharId,VoiceData.VoiceId}, "_") end
    local ReddotName = table.concat({M.FilesTabType[1],VoiceData.CharId,VoiceData.VoiceType}, "_")
    return M:_TryAddNewReddotCommon(CacheKey,ReddotName)  
end

---@note 当获得新的角色档案尝试添加红点计数
---@param RecordData table<any> 角色档案数据
---@param CacheKey string “角色Id_档案Id”拼凑的字符串，用来做缓存的key
function M:TryAddNewRecordReddot(RecordData, CacheKey)
    if(self.IsPreviewMode)then
        return
    end
    if not CacheKey then CacheKey = table.concat({RecordData.CharId,RecordData.CharDataTarget}, "_") end
    local ReddotName = table.concat({M.FilesTabType[2],RecordData.CharId,RecordData.CharDataType}, "_")
    return M:_TryAddNewReddotCommon(CacheKey,ReddotName)
end

---@note 当获得新的宠物尝试添加红点计数
---@param Pet Pet Avatar宠物数据
---@param UniqueId string 宠物UniqueId
function M:TryAddNewPetReddot(Pet, UniqueId)
    if(self.IsPreviewMode)then
        return
    end
    if not Pet:Data() or not Pet:BattleData()then
        print(_G.LogTag, "红点添加失败，宠物的表数据无效，无效Id: "..Pet.PetId)
        return false
    end
    if UniqueId == nil then UniqueId = Pet.UniqueId end

    local NodeName = CommonConst.DataType.Pet
    if(Pet:IsResourcePet())then
        --这里要注意顺序，素材宠物红点要先更新
        M:_TryAddNewReddotCommon(UniqueId, "Resource" .. NodeName)
    end
    local Res = M:_TryAddNewReddotCommon(UniqueId, NodeName,false,false,NodeName)
    return Res
end

function M:_TryAddNewReddotCommon(CacheKey, NodeName, Recyclable, bDontIncrease,ModelName)
    if not ReddotManager.GetTreeNode(NodeName) then
        ReddotManager.AddNode(NodeName, nil, 1,nil,ModelName)
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
    if not CacheDetail then
        DebugPrint(Traceback(ErrorTag, "CacheDetail为空: "..NodeName))
        return
    end
    if not CacheDetail[CacheKey] or (Recyclable and CacheDetail[CacheKey]==0) then
        if not bDontIncrease then
            CacheDetail[CacheKey] = 1
            ReddotManager.IncreaseLeafNodeCount(NodeName)
        else 
            CacheDetail[CacheKey] = 0
        end
    end
    return CacheDetail[CacheKey]==1
end

function M:_SetReddotReadCommon(CacheKey, NodeName, bDeleteCache)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
    if not CacheDetail then
        DebugPrint(WarningTag,LXYTag, "军械库红点没有这个缓存 "..(NodeName or ""))
        return
    end
    if not CacheDetail[CacheKey] then
        DebugPrint(WarningTag,LXYTag, NodeName.."军械库红点缓存没有这个key "..(CacheKey or ""))
        return
    end
    if(CacheDetail[CacheKey]==1) then
        CacheDetail[CacheKey] = 0
        ReddotManager.DecreaseLeafNodeCount(NodeName)
    end
    if(bDeleteCache)then
        CacheDetail[CacheKey] = nil
    end
end
--endregion 军械库红点

--region 军械库预览模式
function M:SetIsPreviewMode(IsPreviewMode)
    self.IsPreviewMode = IsPreviewMode
end

function M:GetIsPreviewMode()
    return self.IsPreviewMode
end

function M:SwitchPreviewTargetState(PreviewTargetState)
    if(not self:HasAvatar(PreviewTargetState))then
        return
    end
    self.CurPreviewTargetState = PreviewTargetState
    EventManager:FireEvent(EventID.OnArmoryPreviewModeStateChanged, self.CurPreviewTargetState)
end

function M:GetPreviewTargetState()
    return self.CurPreviewTargetState
end

function M:GetDummyAvatar(State)
    State = State or  self.CurPreviewTargetState
    if(State == self.PreviewTargetStates.Prime)then
        return self.DummyAvatar_Prime
    elseif(State == self.PreviewTargetStates.Max)then
        return self.DummyAvatar_Max
    elseif(State == self.PreviewTargetStates.Custom)then
        return self.DummyAvatar_Custom
    end
end

function M:DestroyDummyAvatar(State)
    if(State)then
        if(State == self.PreviewTargetStates.Prime)then
            self.DummyAvatar_Prime = nil
        elseif(State == self.PreviewTargetStates.Max)then
            self.DummyAvatar_Max = nil
        elseif(State == self.PreviewTargetStates.Custom)then
            self.DummyAvatar_Custom = nil
        end
    else
        self.DummyAvatar_Max = nil
        self.DummyAvatar_Prime = nil
        self.DummyAvatar_Custom = nil
        self.CurPreviewTargetState = nil
    end
end

local _NeedResetUuid = true
function M:DontResetUuid(bDontReset)
    _NeedResetUuid = not bDontReset
end

local _Uuid = 1
local _ResetUuid = function()
    if(_NeedResetUuid)then
        _Uuid = 1
    end
end

local _NextUuid = function()
    local uuid = _Uuid
    _Uuid = _Uuid + 1
    return uuid
end

local _CreateDummyAvatarBase = function(DummyAvatar,_Params)
    DummyAvatar.Chars = {}
    DummyAvatar.CommonChars = {}
    DummyAvatar.Weapons = {}
    DummyAvatar.UWeapons = {}
    DummyAvatar.Pets = {}
    DummyAvatar.Mods = {}
    DummyAvatar.CharAccessorys = {}
    DummyAvatar.WeaponId2UWeapon = {}
    DummyAvatar.CurrentPet = DummyAvatar.CurrentPet or 0
    DummyAvatar.CheckUIUnlocked = function() return true end
    DummyAvatar.CreateInfo2Uuids = {Chars = {},Weapons = {},Pets ={}}
    DummyAvatar.Sex = _Params.Sex or GWorld:GetAvatar().Sex
end

--封装是为了到时候服务端修改mod结构的时候，客户端能更好的重构，NoRepeat!!
local _UnlockModSlot = function(Target, TargetInfo)
	if TargetInfo and TargetInfo.ModSlotUnlock then
		for i = 1, #TargetInfo.ModSlotUnlock do
			if TargetInfo.ModSlotUnlock[i] < Target.EnhanceLevel then
				Target.ModSuits[Target.ModSuitIndex][i]:UnLock()
                Target.ModSlotStatus[i] = CommonConst.CommonStatus.UnLock
			end
		end
	end
end

local _DummyAvatarCreateMod = function(FakeUuid, ModId, Level, CardLevel)
    local Mod = ModCom.ModDict:NewMod(FakeUuid, ModId, Level)
    Mod.CurrentModCardLevel = CardLevel
    Mod.IsOriginal = Level>0
    Mod.LockState = 1
    return Mod
end

local _DummyAvatarCreateWeapon = function(Uuid, WeaponId, Level, NeedEnhance, ModSuitIndex)
    local weapon = WeaponCom.WeaponDict:NewWeapon(Uuid, WeaponId, Level)
    weapon:InitAppearance()
    NeedEnhance = NeedEnhance or true
	if DataMgr.WeaponBreak[WeaponId] ~= nil then
		local WeaponBreak = DataMgr.WeaponBreak[WeaponId]
		for i = 1, #WeaponBreak do
			if NeedEnhance then
				if Level >= WeaponBreak[i].WeaponBreakLevel then
					weapon.EnhanceLevel = WeaponBreak[i].WeaponBreakNum
				end
			else
				if Level > WeaponBreak[i].WeaponBreakLevel then
					weapon.EnhanceLevel = WeaponBreak[i].WeaponBreakNum
				end
			end
		end
	end
    if ModSuitIndex then
        weapon.ModSuitIndex = ModSuitIndex
    end
    local WeaponInfo = DataMgr.Weapon[weapon.WeaponId]
	_UnlockModSlot(weapon, WeaponInfo)
    return weapon
end

local _AddWeaponToDummyAvatar = function(DummyAvatar, Weapon, WeaponInfo)
    DummyAvatar.Weapons[Weapon.Uuid] = Weapon
    DummyAvatar.CreateInfo2Uuids.Weapons[WeaponInfo] = Weapon.Uuid
end

local _DummyAvatarCreateUWeapon = function(WeaponId, Level, EnhanceLevel, ModSuitIndex)
	local info = DataMgr.UWeapon[WeaponId]
	if not info or not DataMgr.WeaponLevelUp[Level] then
		return
	end
	local weapon = WeaponCom.UWeaponDict:NewWeapon(_NextUuid(), WeaponId, Level)
	weapon.EnhanceLevel = EnhanceLevel
    if ModSuitIndex then
        weapon.ModSuitIndex = ModSuitIndex
    end
	-- 根据突破等级解锁mod槽
    local WeaponInfo = DataMgr.UWeapon[weapon.WeaponId]
	_UnlockModSlot(weapon, WeaponInfo)
	return weapon
end

local _CharInitUltraWeapon = function(DummyAvatar,Char, Level)
	if not Char or not Char.UWeapon then return end
    for i, v in ipairs(Char.UWeapon) do
        -- 根据角色的突破等级赋值UWeapon的EnhanceLevel
        local NewUWeapon = _DummyAvatarCreateUWeapon(v, Level, Char.EnhanceLevel)
        if(NewUWeapon)then
		    Char.UWeaponEids:Append(NewUWeapon.Uuid)
            --Char.UWeaponEids[i] = NewUWeapon.Uuid
            --table.insert(Char.UWeaponEids,NewUWeapon.Uuid)
            DummyAvatar.UWeapons[NewUWeapon.Uuid] = NewUWeapon
            DummyAvatar.WeaponId2UWeapon[NewUWeapon.WeaponId] = NewUWeapon
        end
	end
end

local _InitCharSetCharAppearanceAccessory = function(DummyAvatar,Char)
    if not Char then return end
    local DefaultAccessory = Char.DefaultAccessory
    if not DefaultAccessory then return end
    for AccessoryType, AccessoryId in pairs(DefaultAccessory) do
        table.insert(DummyAvatar.CharAccessorys,AccessoryId)
        local CharAccessoryTypeIndex = CommonConst.NewCharAccessoryTypes[AccessoryType]
        for AppearanceIndex, AppearanceSuit in pairs(Char.AppearanceSuits) do
            AppearanceSuit.Accessory[CharAccessoryTypeIndex] = AccessoryId
        end
    end
end

local _DummyAvatarCreateChar = function(DummyAvatar,Uuid, CharId,Level,NeedEnhance, ModSuitIndex)
    -- 增加新角色
	local char = CharCom.CharDict:NewChar(Uuid, CharId, Level)
	-- 根据等级计算突破等级
    NeedEnhance = NeedEnhance or true
	if DataMgr.CharBreak[CharId] ~= nil then
		local CharBreak = DataMgr.CharBreak[CharId]
		for i=1,#CharBreak do
			if NeedEnhance then
				if Level >= CharBreak[i].CharBreakLevel then
					char.EnhanceLevel = CharBreak[i].CharBreakNum
				end
			else
				if Level > CharBreak[i].CharBreakLevel then
					char.EnhanceLevel = CharBreak[i].CharBreakNum
				end
			end
		end
	end
    if ModSuitIndex then
        char.ModSuitIndex = ModSuitIndex
    end
	-- 根据突破等级解锁mod槽
    local CharInfo = DataMgr.Char[char.CharId]
    _UnlockModSlot(char, CharInfo)
	char:UpdateSkill()
	-- 增加显赫武器
	_CharInitUltraWeapon(DummyAvatar,char, Level)
    _InitCharSetCharAppearanceAccessory(DummyAvatar,char)
    DummyAvatar.CommonChars[CharId] = CharacterCommon.CommonCharDict:NewCommonChar(CharId)
    return char
end

local _AddCharToDummyAvatar = function(DummyAvatar, Char, CharInfo)
    DummyAvatar.Chars[Char.Uuid] = Char
    DummyAvatar.CreateInfo2Uuids.Chars[CharInfo] = Char.Uuid
end

local _DummyAvatarCreatePet = function(PetId,UniqueId)
    local Pet = PetCom.Pet(PetId,UniqueId)
    local PetType = DataMgr.Pet[Pet.PetId] and DataMgr.Pet[Pet.PetId].PetType
	local PetBreak = DataMgr.PetBreak[Pet.PetId] and DataMgr.PetBreak[Pet.PetId][Pet.BreakNum]
	if PetType == CommonConst.PetType.Consumable then
	else
		--非素材宠物 突破解锁槽位
		for i = Pet.Entry:Length() + 1, PetBreak.EntryNum do
			Pet.Entry:Append(0)
		end
	end
	Pet.Entry = Pet.Entry
    return Pet
end

local _AddPetToDummyAvatar = function(DummyAvatar, Pet, PetInfo)
    DummyAvatar.Pets[Pet.UniqueId] = Pet
    DummyAvatar.CreateInfo2Uuids.Pets[Pet.UniqueId] = PetInfo
end

--创建1级的假Avatar
local _CreateDummyAvatarPrime = function(DummyAvatar,_Params)
    _CreateDummyAvatarBase(DummyAvatar,_Params)
    local Level = 1
    _ResetUuid()
    if(_Params.CharIds)then
        for i, CharId in ipairs(_Params.CharIds) do
            local Char = _DummyAvatarCreateChar(DummyAvatar,_NextUuid(),CharId,Level,1)
            if(_Params.CurrentChar == CharId)then
                DummyAvatar.CurrentChar = Char.Uuid
            end
            for _, value in ipairs(Char.Skills) do
                value:Lock()
            end
            _AddCharToDummyAvatar(DummyAvatar,Char,CharId)
        end
    end

    if(_Params.WeaponIds)then
        for i, WeaponId in ipairs(_Params.WeaponIds) do
            local Weapon = _DummyAvatarCreateWeapon(_NextUuid(), WeaponId,Level,1)
            if(_Params.MeleeWeapon == WeaponId)then
                DummyAvatar.MeleeWeapon = Weapon.Uuid
            end
            if(_Params.RangedWeapon == WeaponId)then
                DummyAvatar.RangedWeapon = Weapon.Uuid
            end
            _AddWeaponToDummyAvatar(DummyAvatar,Weapon,WeaponId)
        end
    end

    if(_Params.PetIds)then
        for i, PetId in ipairs(_Params.PetIds) do
            local Pet = _DummyAvatarCreatePet(PetId,_NextUuid())
            if(_Params.CurrentPet == PetId)then
                DummyAvatar.CurrentPet = Pet.UniqueId or DummyAvatar.CurrentPet
            end
            _AddPetToDummyAvatar(DummyAvatar,Pet,PetId)
        end
    end
end

--创建满级的假Avatar
local _CreateDummyAvatarMax = function(DummyAvatar,_Params)
    _CreateDummyAvatarBase(DummyAvatar,_Params)
    local Level = 1
    _ResetUuid()
    if(_Params.CharIds)then
        for i, CharId in ipairs(_Params.CharIds) do
            Level = DataMgr.Char[CharId].CharMaxLevel
            local Char = _DummyAvatarCreateChar(DummyAvatar,_NextUuid(),CharId,Level,1)
            if(_Params.CurrentChar == CharId)then
                DummyAvatar.CurrentChar = Char.Uuid
            end
            Char:SetGradeLevel(DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue)
            for _, Skill in pairs(Char.Skills) do
                Skill:UnLock()
                if(DataMgr.SkillLevelUp[Skill.SkillId])then
                    while(Skill:LevelUp())do
                    end
                end
            end
            for _, SkillNodes in ipairs(Char.SkillTree) do
                for _, SkillNode in ipairs(SkillNodes) do
                    SkillNode:UnLock()
                end
            end
            _AddCharToDummyAvatar(DummyAvatar,Char,CharId)
        end
    end

    if(_Params.WeaponIds)then
        for i, WeaponId in ipairs(_Params.WeaponIds) do
            Level = DataMgr.Weapon[WeaponId].WeaponMaxLevel
            local Weapon = _DummyAvatarCreateWeapon(_NextUuid(), WeaponId,Level,1)
            if(_Params.MeleeWeapon == WeaponId)then
                DummyAvatar.MeleeWeapon = Weapon.Uuid
            end
            if(_Params.RangedWeapon == WeaponId)then
                DummyAvatar.RangedWeapon = Weapon.Uuid
            end
            local WeaponCardLevelData = DataMgr.WeaponCardLevel[WeaponId]
            local CardLevelMax = WeaponCardLevelData and WeaponCardLevelData.CardLevelMax
            if(CardLevelMax)then
                Weapon:SetGradeLevel(false,CardLevelMax)
            end
            _AddWeaponToDummyAvatar(DummyAvatar,Weapon,WeaponId)
        end
    end

    if(_Params.PetIds)then
        for i, PetId in ipairs(_Params.PetIds) do
            local Pet = _DummyAvatarCreatePet(PetId,_NextUuid())
            if(_Params.CurrentPet == PetId)then
                DummyAvatar.CurrentPet = Pet.UniqueId or DummyAvatar.CurrentPet
            end
            local BreakConf = Pet:BreakData()
            Pet.BreakNum = BreakConf and #BreakConf or 0
            Pet.Level = Pet:GetMaxLevel()
            _AddPetToDummyAvatar(DummyAvatar,Pet,PetId)
        end
    end
end

---@param Target Char|Weapon|UWeapon
local _SetUpModForTarget = function(DummyAvatar, Target, TargetInfo)
    if TargetInfo.SlotData and TargetInfo.ModSuitIndex and Target.ModSuits then
        ---@param Slot ModSlot
        for SlotId, Slot in pairs(Target.ModSuits[TargetInfo.ModSuitIndex]) do
            local SlotData = TargetInfo.SlotData[SlotId] or {SlotId = SlotId,Polarity = -1,ModEid = -1}
            local SlotStatus = Target.ModSlotStatus[SlotId]
            Slot:Init(SlotData.SlotId, SlotData.Polarity,SlotStatus, SlotData.ModEid)
            Target["ModSuit_"..TargetInfo.ModSuitIndex][SlotId] = SlotData.ModEid or -1
            Target.ModSlotPolarity[SlotId] = SlotData.Polarity
        end
    end
    for _, ModData in ipairs(TargetInfo.ModData or {}) do
        local Mod = _DummyAvatarCreateMod(ModData.Uuid, ModData.ModId, ModData.Level, ModData.CurrentModCardLevel)
        if Target.SetExtralModVolume then
            Target:SetExtralModVolume(Mod:CalcExtralCharVolume(), TargetInfo.ModSuitIndex)
        end
        if Target:GetTypeName() == "Char" then
            table.insert(Mod.CharUuids, Target.Uuid)
        else
            table.insert(Mod.WeaponUuids, Target.Uuid)
        end
        DummyAvatar.Mods[Mod.Uuid] = Mod
    end
end

--创建自定义属性的假Avatar
M._CreateDummyAvatarCustom = function(DummyAvatar,_Params)
    _CreateDummyAvatarBase(DummyAvatar,_Params)
    _ResetUuid()
    for i, CharInfo in ipairs(_Params.CharInfos or {}) do
        local Char = _DummyAvatarCreateChar(DummyAvatar,_NextUuid(),CharInfo.RoleId,CharInfo.Level,1,CharInfo.ModSuitIndex)
        if(_Params.CurrentChar == CharInfo)then
            DummyAvatar.CurrentChar = Char.Uuid
        end
        Char.Exp = CharInfo.Exp
        Char.GradeLevel = CharInfo.GradeLevel
        if CharInfo.EnhanceLevel then
            Char.EnhanceLevel = CharInfo.EnhanceLevel
        end
        --外观
        local AppearanceSuit = Char.AppearanceSuits[Char.CurrentAppearanceIndex]
        AppearanceSuit.SkinId = CharInfo.SkinId or AppearanceSuit.SkinId
        AppearanceSuit.HairId = CharInfo.HairId or AppearanceSuit.HairId
        if(CharInfo.AppearanceSuit)then
            AppearanceSuit.SkinId = CharInfo.AppearanceSuit.SkinId or AppearanceSuit.SkinId
            AppearanceSuit.HairId = CharInfo.AppearanceSuit.HairId or AppearanceSuit.HairId
            local AccessorySuit = CharInfo.AppearanceSuit.AccessorySuit
            if(AccessorySuit)then
                for key, value in pairs(AccessorySuit) do
                    AppearanceSuit.Accessory[key] = value
                end
            end
            AppearanceSuit.AccessoryCustomParams = CharInfo.AppearanceSuit.AccessoryCustomParams
        end

        --技能
        local SkilMap = {}
        if CharInfo.SkillInfos then
            for _, value in ipairs(Char.Skills) do
                SkilMap[value.SkillId] = value
                for _, InfoValue in ipairs(CharInfo.SkillInfos) do
                    if InfoValue.SkillId == value.SkillId then
                        break
                    end
                end
                value.LockState = 1 -- SkillInfo里没有就说明这个技能/节点还没解锁
            end
            for _, value in ipairs(CharInfo.SkillInfos) do
                local Skill = SkilMap[value.SkillId]
                if(Skill)then
                    local SkillData = DataMgr.SkillLevelUp[Skill.SkillId]
                    local SkinInfo = SkillData and value.SkillInfo
                    if(SkinInfo and SkinInfo.Level)then
                        Skill.ExtraLevel = SkinInfo.ExtraLevel or 0
                        while(SkillData[Skill.Level] and Skill.Level < SkinInfo.Level)do
                            Skill:LevelUp()
                        end
                    end
                end
            end
        end
        -- 技能节点
        if CharInfo.SkillTreeInfos then
            for BranchIdx, SkillNodes in ipairs(Char.SkillTree) do
                local BranchInfo = CharInfo.SkillTreeInfos[BranchIdx]
                if(BranchInfo)then
                    for NodeIdx, SkillNode in ipairs(SkillNodes) do
                        if BranchInfo[NodeIdx] then
                            SkillNode.LockState = BranchInfo[NodeIdx].LockState
                        end
                    end
                end
            end
        end
        _SetUpModForTarget(DummyAvatar, Char, CharInfo)
        _AddCharToDummyAvatar(DummyAvatar,Char, CharInfo)

        local CommonChar = DummyAvatar.CommonChars[Char.CharId]
        local AppearanceSuit = CharInfo.AppearanceSuit
        if(AppearanceSuit and CommonChar)then
            if(AppearanceSuit.SkinId)then
                CommonChar:AddSkin(AppearanceSuit.SkinId)
                local Skin = CommonChar:GetSkin(AppearanceSuit.SkinId)
                if(Skin)then
                    local CurrentPlanIndex = Skin.CurrentPlanIndex or 1
                    for i, value in pairs(AppearanceSuit.Colors or {}) do
                        if(Skin.Colors[CurrentPlanIndex])then
                            Skin.Colors[CurrentPlanIndex][i] = value
                        end
                    end
                end
            end
            CommonChar:AddHair(AppearanceSuit.HairId or Char.CharId)
            local Hair = CommonChar:GetHair(AppearanceSuit.HairId or Char.CharId)
            if(Hair and type(AppearanceSuit.HairColors) == "table")then
                for PlanIdx, PlanColors in pairs(AppearanceSuit.HairColors) do
                    if(Hair.Colors[PlanIdx] and type(PlanColors) == "table")then
                        for PartIdx, ColorId in pairs(PlanColors) do
                            Hair.Colors[PlanIdx][PartIdx] = ColorId
                        end
                    end
                end
            end
        end
    end

    for i, WeaponInfo in ipairs(_Params.WeaponInfos or {}) do
        local Weapon = _DummyAvatarCreateWeapon(_NextUuid(),WeaponInfo.WeaponId,WeaponInfo.Level,1,WeaponInfo.ModSuitIndex)
        if(_Params.MeleeWeapon == WeaponInfo)then
            DummyAvatar.MeleeWeapon = Weapon.Uuid
        end
        if(_Params.RangedWeapon == WeaponInfo)then
            DummyAvatar.RangedWeapon = Weapon.Uuid
        end
        Weapon.Exp = WeaponInfo.Exp
        Weapon.GradeLevel = WeaponInfo.GradeLevel
        Weapon.EnhanceLevel = WeaponInfo.EnhanceLevel
        local AppearanceInfo = WeaponInfo.AppearanceInfo or {Colors = {},AccessoryId = -1}
        local Appearance = Weapon:GetAppearance()
        if(Appearance)then
            Appearance.Accessory = Appearance.Accessory or {}
            Appearance.Accessory[1] = AppearanceInfo.AccessoryId
            if(AppearanceInfo.SkinId)then
                Appearance.SkinId = AppearanceInfo.SkinId
                if(Appearance.SkinId > 0)then
                    Weapon:AddSkin(Appearance.SkinId)
                end
            end
        end
        local Skin = Weapon:GetCurrentSkin()
        if(Skin)then
            -- 自己武器详情界面数据
            for key, value in pairs(Skin.SpecialColor) do
                Skin.SpecialColor[key] = AppearanceInfo.Colors.SpecialColor or Skin.SpecialColor[key]	
            end
            local Colors = AppearanceInfo.Colors.Colors
            if(Colors)then
                for key, value in pairs(Colors) do
                    for PlanIdx, _ in pairs(Skin.Colors) do
                        Skin.Colors[PlanIdx][key] = value	
                    end
                end
            end
        end
        _SetUpModForTarget(DummyAvatar, Weapon, WeaponInfo)
        _AddWeaponToDummyAvatar(DummyAvatar,Weapon,WeaponInfo)
    end

    for i, UWeaponInfo in ipairs(_Params.UWeaponInfos or {}) do
        local UWeapon
        if(DummyAvatar.WeaponId2UWeapon[UWeaponInfo.WeaponId])then
            UWeapon = DummyAvatar.WeaponId2UWeapon[UWeaponInfo.WeaponId]
            UWeapon.ModSuitIndex = UWeaponInfo.ModSuitIndex
            UWeapon.Level = UWeaponInfo.Level
        else
            UWeapon = _DummyAvatarCreateUWeapon(UWeaponInfo.WeaponId, UWeaponInfo.Level, UWeaponInfo.EnhanceLevel,UWeaponInfo.ModSuitIndex)
        end
        UWeapon.Exp = UWeaponInfo.Exp
        UWeapon.GradeLevel = UWeaponInfo.GradeLevel
        UWeapon.EnhanceLevel = UWeaponInfo.EnhanceLevel
        _SetUpModForTarget(DummyAvatar, UWeapon, UWeaponInfo)
        DummyAvatar.UWeapons[UWeapon.Uuid] = UWeapon
    end

    for i, PetInfo in ipairs(_Params.PetInfos or {}) do
        local Pet = _DummyAvatarCreatePet(PetInfo.PetId,_NextUuid())
        if(_Params.CurrentPet == PetInfo)then
            DummyAvatar.CurrentPet = Pet.UniqueId or DummyAvatar.CurrentPet
        end
        Pet.Level = PetInfo.Level or 1
        Pet.Exp = PetInfo.Exp or 0
        Pet.BreakNum = PetInfo.BreakNum or 0
        Pet.Name = PetInfo.Name or ""
        if(PetInfo.EntryIds)then
            for index, value in ipairs(PetInfo.EntryIds) do
                Pet.Entry[index] = value
            end
        end
        _AddPetToDummyAvatar(DummyAvatar,Pet,PetInfo)
    end
end

---创建假Avatar
---@alias ParamType {CharIds:table, WeaponIds:table, CurrentChar:number, CurrentPet:number}
---@param Params ParamType
function M:CreateDummyAvatar(Params)
    if(Params.CharIds or Params.WeaponIds or Params.PetIds)then
        self.DummyAvatar_Prime = {}
        self.DummyAvatar_Max = {}
        _CreateDummyAvatarPrime(self.DummyAvatar_Prime,Params)
        _CreateDummyAvatarMax(self.DummyAvatar_Max,Params)
    end
    self:CreateDummyAvatarByDumpInfo(Params)
end

function M:CreateNewDummyAvatar(State,Params)
    local DummyAvatar = {}
    if(State == self.PreviewTargetStates.Prime)then
        _CreateDummyAvatarPrime(DummyAvatar,Params)
    elseif(State == self.PreviewTargetStates.Max)then
        _CreateDummyAvatarMax(DummyAvatar,Params)
    elseif(State == self.PreviewTargetStates.Custom)then
        self._CreateDummyAvatarCustom(DummyAvatar,Params)
    end
    return DummyAvatar
end

---根据BattleDump创建假Avatar
---@alias ParamType1 {CharInfos:table, WeaponInfos:table, CurrentChar:CharId}
---@param Params ParamType1
function M:CreateDummyAvatarByDumpInfo(Params)
    if(Params.CharInfos or Params.WeaponInfos or Params.PetInfos)then
        self.DummyAvatar_Custom = {}
        self._CreateDummyAvatarCustom(self.DummyAvatar_Custom,Params)
    end
end

function M:SetTemporaryAvatar(Avatar)
    self.TemporaryAvatar = Avatar
end

function M:GetAvatar()
    return self.TemporaryAvatar or self:GetDummyAvatar() or GWorld:GetAvatar()
end

function M:HasAvatar(PreviewTargetState)
    if(PreviewTargetState == self.PreviewTargetStates.Prime)then
        return not not self.DummyAvatar_Prime
    elseif(PreviewTargetState == self.PreviewTargetStates.Max)then
        return not not self.DummyAvatar_Max
    elseif(PreviewTargetState == self.PreviewTargetStates.Custom)then
        return not not self.DummyAvatar_Custom
    end
end

--endregion 军械库预览模式

function M:GetPhantomWeaponUuid(PhantomResourceId)
    local Avatar = self:GetAvatar()
    local PhantomResource = Avatar.Resources[PhantomResourceId]
    return PhantomResource and PhantomResource.WeaponUuid
end

function M:GetCharByUuid(Uuid)
    local Avatar = self:GetAvatar()
    return Avatar.Chars[Uuid]
end

function M:GetWeaponByUuid(Uuid)
    local Avatar = self:GetAvatar()
    return Avatar.Weapons[Uuid] or Avatar.UWeapons[Uuid]
end

function M:GetCharNoneAccessoryIconPaths()
    local AccessoryIconPaths = {}
    for _, value in pairs(CommonConst.CharAccessoryTypes) do
        AccessoryIconPaths[value] = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_"..value..".T_Tab_Fashion_"..value
    end
    return AccessoryIconPaths
end

function M:InsertWeaponTypeImpl(WeaponId,AttrTable)
    local WeaponTypeKey = "WeaponType"
    local AttrConfigData = DataMgr.AttrConfig[WeaponTypeKey]
    if(not AttrConfigData or not AttrConfigData.ShowInInspector)then
        return
    end
    local BattleWeaponData = DataMgr.BattleWeapon[WeaponId]
    if(not BattleWeaponData or not BattleWeaponData.WeaponTag)then
        return
    end
    for _, v in pairs(BattleWeaponData.WeaponTag) do
        local WeaponTagData = DataMgr.WeaponTag[v]
        if WeaponTagData and WeaponTagData.WeaponTagfilter then
            if WeaponTagData.WeaponTagfilter == "RangedType"  or WeaponTagData.WeaponTagfilter == "MeleeType" then
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
                    AttrTable[WeaponTypeKey] = GText(WeaponTagData.WeaponTagTextmap)
                    break
                end
            end
        end
    end
end
---初始化角色档案红点本地缓存，如果是该设备第一次则已解锁的全部设置为已读
--由于解锁条件无法用通用条件做，因而无法用监听实现，缓存所有的角色档案红点数据，切换角色时更新查询
--利用GetLeafNodeCacheDetail来区分是否已读，
--GetLeafNodeCacheDetail为空表，未曾解锁过，发现满足解锁条件时需要增加红点
--GetLeafNodeCacheDetail.IsRead = true，已读 ，不需要增加红点
--GetLeafNodeCacheDetail.IsRead = false，未读，不需要增加红点
function M:InitAllCharRecordReddot()
    local EMCache = require "EMCache.EMCache"
    if not EMCache then
        return false
    end
    local Avatar = GWorld:GetAvatar()
    local IsInit = EMCache:Get("IsInitCharRecord", true)
    local CharModel = require "BluePrints.Common.MVC.Model.CharModel"
    for ID, Char in pairs(Avatar.Chars) do
        
            local CharId = Char.CharId
            if DataMgr.CharacterDataTarget[CharId] == nil then
                --该角色没有档案数据，不做处理
                 goto continue
            end
            local CharNodeName = table.concat({M.FilesTabType[2], CharId}, "_")
            -- Record_1101
            local CharNode = ReddotManager.GetTreeNode(CharNodeName)
            local LeafNodes = {}
            local SubTabNodes = {}
            for RecordType, _ in pairs(DataMgr.CharRecordType) do
                local SubTabNodeName = table.concat({CharNodeName, RecordType}, "_")
                LeafNodes[RecordType] = {}
                SubTabNodes[SubTabNodeName] = {1, nil, nil}
            end
            --ScreenPrint("Yklua" .. CharId)
            for RecordId, Value in pairs(DataMgr.CharacterDataTarget[CharId]) do
                local RecordNodeName = table.concat({M.FilesTabType[2], CharId,Value.CharDataType, RecordId}, "_")
                --ScreenPrint("YkluaNoode".. RecordNodeName)
                local RecordNode = ReddotManager.AddNodeEx(RecordNodeName, nil, 1, nil)
                local RecordTpe = Value.CharDataType
                if LeafNodes[RecordTpe] then
                    LeafNodes[RecordTpe][RecordNodeName]= {1, nil, nil}
                else
                    ScreenPrint("CharacterDataTarget表里填的CharDataType没有在CharRecordType表里找到，请策划检查")
                end
                if  not IsInit and M.CheckCharRecoedUnlock(self,CharId, RecordId, CharModel) then
                    local RecordNodeCache = ReddotManager.GetLeafNodeCacheDetail(RecordNodeName)
                    if RecordNodeCache then
                        RecordNodeCache.IsRead = true
                    end
                end
            end
            for RecordType, DataNodes in pairs(LeafNodes) do
                local SubTabNodeName = table.concat({CharNodeName, RecordType}, "_")
                --ScreenPrint("YkluaNoode".. SubTabNodeName)
                ReddotManager.AddNodeEx(SubTabNodeName, DataNodes)
            end
            --ScreenPrint("YkluaNoode".. CharNodeName)
            ReddotManager.AddNodeEx(CharNodeName, SubTabNodes)

            ::continue::
        
    end
    if not IsInit then
        EMCache:Set("IsInitCharRecord", true, true)
    end
end
function M:CreatCharRecordReddotNode(CharId)
    if DataMgr.CharacterDataTarget[CharId] == nil then
        -- 该角色没有档案数据，不做处理
        return
    end
    local CharNodeName = table.concat({M.FilesTabType[2], CharId}, "_")
    -- Record_1101
    local CharNode = ReddotManager.GetTreeNode(CharNodeName)
    local LeafNodes = {}
    local SubTabNodes = {}
    for RecordType, _ in pairs(DataMgr.CharRecordType) do
        local SubTabNodeName = table.concat({CharNodeName, RecordType}, "_")
        LeafNodes[RecordType] = {}
        SubTabNodes[SubTabNodeName] = {1, nil, nil}
    end
    -- ScreenPrint("Yklua" .. CharId)
    for RecordId, Value in pairs(DataMgr.CharacterDataTarget[CharId]) do
        local RecordNodeName = table.concat({M.FilesTabType[2], CharId, Value.CharDataType, RecordId}, "_")
        -- ScreenPrint("YkluaNoode".. RecordNodeName)
        local RecordNode = ReddotManager.AddNodeEx(RecordNodeName, nil, 1, nil)
        local RecordTpe = Value.CharDataType
        if LeafNodes[RecordTpe] then
            LeafNodes[RecordTpe][RecordNodeName] = {1, nil, nil}
        else
            ScreenPrint("CharacterDataTarget表里填的CharDataType没有在CharRecordType表里找到，请策划检查")
        end
    end
    for RecordType, DataNodes in pairs(LeafNodes) do
        local SubTabNodeName = table.concat({CharNodeName, RecordType}, "_")
        ReddotManager.AddNodeEx(SubTabNodeName, DataNodes)
    end
    ReddotManager.AddNodeEx(CharNodeName, SubTabNodes)
end

---初始化角色档案红点
function M:InitCharRecoedReddotNode(CharId)
    local HeadNodeName = table.concat({M.FilesTabType[2],CharId},"_")
    local HeadNode= ReddotManager.GetTreeNode(HeadNodeName)
    if not DataMgr.CharacterDataTarget[CharId] then
        --没填档案数据，不做处理
        return 
    end
    DebugPrint("yklua ..InitCharRecoedReddotNode"..CharId)
    if not HeadNode then
        --没创建档案节点，创建档案节点
        DebugPrint("yklua..InitCharRecoedReddotNode"..CharId.."创建档案节点")
        self:CreatCharRecordReddotNode(CharId)
    end
    local bHavaTryCreateNode = false
    for RecordId, Value in pairs(DataMgr.CharacterDataTarget[CharId]) do
        local LeafNodeName = table.concat({M.FilesTabType[2], CharId,Value.CharDataType, RecordId}, "_")
        local LeafNode= ReddotManager.GetTreeNode(LeafNodeName)
        if not LeafNode and not bHavaTryCreateNode then
            --没创建档案节点，创建档案节点
            DebugPrint("yklua..InitCharRecoedReddotNode"..CharId.."创建档案节点"..LeafNodeName)
            self:CreatCharRecordReddotNode(CharId)
            bHavaTryCreateNode=true
        end
        LeafNode= ReddotManager.GetTreeNode(LeafNodeName)
        if  not LeafNode then
            ScreenPrint("创建红点信息失败"..CharId)
            goto continue
        end
        local LeftNodeCache=ReddotManager.GetLeafNodeCacheDetail(LeafNodeName)
        if LeftNodeCache and (LeftNodeCache.IsRead==true or LeftNodeCache.IsRead==false) then
            --说明加过红点了，不需要重复加
            goto continue
        end
        local IsNotLock =self:CheckCharRecoedUnlock(CharId,RecordId)
        if  IsNotLock then
            --ScreenPrint("YkluaNode".."Addreddot" )
            ReddotManager.ClearLeafNodeCount(LeafNodeName)
            LeftNodeCache.IsRead=false
            ReddotManager.IncreaseLeafNodeCount(LeafNodeName,1)
        else
            ReddotManager.ClearLeafNodeCount(LeafNodeName)
            LeftNodeCache.IsRead=nil
        end

        ::continue::
    end
end

--return true 已解锁，false 未解锁
function M:CheckCharRecoedUnlock(CharId,DataId, CharModel)

    local UnlockLevel = DataMgr.CharacterDataTarget[CharId][DataId].CharDataUnlockLevel
    --PrintTable(DataMgr.CharacterDataTarget)
    local ConditionId = DataMgr.CharacterDataTarget[CharId][DataId].CharDataUnlockCondition
    local Avatar = GWorld:GetAvatar()

    local bIsLevelEnough
    if UnlockLevel then
        if not CharModel then
            CharModel = require "BluePrints.Common.MVC.Model.CharModel"
        end
        local CharLevel
        local  Uuid =CharModel:GetUuidByCharId(CharId)
        if Uuid  then
             CharLevel = Avatar.Chars[Uuid].Level
        else
            CharLevel = 0
        end
        bIsLevelEnough = CharLevel >= UnlockLevel
    else
        bIsLevelEnough = true
    end
    if not bIsLevelEnough then
        return false
    end

    local bConditionEnough
    if ConditionId then
         bConditionEnough = ConditionUtils.CheckCondition(Avatar, ConditionId)
    else
        bConditionEnough = true
    end
    if bIsLevelEnough and bConditionEnough then
        return true
    end
    return false
end

function M:OnUnlockCharUsePiece(Ret,CharId,EscapeArmoryCharID,BeforeCheckErroCode,OnCheckErroCodeSuccess,OnPageClosed)
    if(BeforeCheckErroCode)then
        BeforeCheckErroCode(Ret)
    end
    if not ErrorCode:Check(Ret) then return end
    if(OnCheckErroCodeSuccess)then
        OnCheckErroCodeSuccess()
    end
    local ArmoryMain = UIManager(self):GetUIObj("ArmoryMain")
    local CallbackFunc
    CallbackFunc = function()
        if(OnPageClosed)then
            OnPageClosed()
        end
        if EscapeArmoryCharID and ArmoryMain then
            if CharId == EscapeArmoryCharID then
                ArmoryMain:OnBackBtnClicked()
            end
        end
    end
    if(ArmoryMain and ArmoryMain.ActorController)then
        ArmoryMain.ActorController:StopPlayerSound()
    end
    UIUtils.ShowGetCharWeaponPage({["Chars"] = {[CharId] = 1}}, CallbackFunc, self, nil)
end

function M:IsSkinSupportAccessory(SkinId,AccessoryId)
    local Data = DataMgr.CharAccessory[AccessoryId] or DataMgr.CharPartMesh[AccessoryId]
    if(not Data or not Data.Skin)then
        return true
    end
    for key, value in pairs(Data.Skin) do
        if(value == SkinId)then
            return true
        end
    end
    return false
end

-- 初始化皮肤升级红点
function M:InitSkinLevelUpReddot(CharId, Obj, Callback)
    if self.IsPreviewMode then
        return
    end

    if not CharId then
        return
    end

    local NodeName = CommonConst.DataType.Char .. CommonConst.DataType.Skin.. "LevelUp" .. CharId
    if not ReddotManager.GetTreeNode(NodeName) then
        ReddotManager.AddNodeEx(NodeName)
    end

    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
    if not CacheDetail then
        return
    end

    if not next(CacheDetail) then
        local SkinData = DataMgr.Skin[CharId]
        for SkinId, Data in pairs(DataMgr.Skin) do
            if (Data.CharId == CharId)  then
                local SkinData = self:GetOwnedSkinData(SkinId)
                CacheDetail[SkinId] = SkinData and SkinData.Level or 1
            end
        end
    end

    if Obj and Callback then
        ReddotManager.AddListener(NodeName, Obj, Callback)
    end
end

-- 获取拥有的皮肤数据
function M:GetOwnedSkinData(SkinId)
    local Avatar = GWorld:GetAvatar()
    if(not Avatar or not Avatar.CommonChars)then
        return
    end
    local CharId = DataMgr.Skin[SkinId] and DataMgr.Skin[SkinId].CharId
    if not CharId then
        return
    end
    local CommonChar = Avatar.CommonChars[CharId]
    local Skin = CommonChar and CommonChar.OwnedSkins[SkinId]
    return Skin
end

-- 皮肤是否可以升级。TargetLevel可选，指定升级到某个等级
function M:CanSkinUpgrade(SkinId, TargetLevel)
    local SkinUpData = DataMgr.SkinUpgrade[SkinId]
    if not SkinUpData then
        return false
    end

    -- 预览模式
    if self.IsPreviewMode then
        return false
    end

    -- 已拥有皮肤
    local SkinData = self:GetOwnedSkinData(SkinId)
    if not SkinData then
        return false
    end

    local NextLevel = SkinData.Level + 1
    local NextSkinUp = SkinUpData[NextLevel]
    if not NextSkinUp then
        return false
    end

    local Condition1 = true
    if TargetLevel then
        Condition1 = (NextLevel == TargetLevel)
    end

    local Avatar = GWorld:GetAvatar()
    local OwnedAmount = Avatar:GetResourceNum(NextSkinUp.UnlockCurrency)
    local Condition2 = (OwnedAmount >= NextSkinUp.UnlockAmount)

    return Condition1 and Condition2
end

return M

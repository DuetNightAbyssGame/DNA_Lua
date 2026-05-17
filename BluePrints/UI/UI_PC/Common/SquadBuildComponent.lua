require "UnLua"

---@class SquadBuildComponent
-- 阵容预设Component，用于管理角色、武器、宠物等槽位的选择和配置
-- 和TeamSelect的区别是，这个选择之前要弹出mod方案，然后再装上去，TeamSelect是直接装上去
-- 功能：左边选择8个槽位，弹出右边的ListView，然后可以选择物品
local Component = {}

local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local UIUtils = require "Utils.UIUtils"

-- 槽位名称枚举
Component.ESlotName = {
    Char = 1,
    MeleeWeapon = 2,
    RangedWeapon = 3,
    Phantom1 = 4,
    PhantomWeapon1 = 5,
    Phantom2 = 6,
    PhantomWeapon2 = 7,
    Pet = 8,
    Null = 0,
}

-- 按照 ESlotName 的值顺序（1-8）排列的槽位名称数组
Component.SlotNameOrder = {
    "Char",           -- 1
    "MeleeWeapon",    -- 2
    "RangedWeapon",   -- 3
    "Phantom1",       -- 4
    "PhantomWeapon1", -- 5
    "Phantom2",       -- 6
    "PhantomWeapon2", -- 7
    "Pet",            -- 8
}

-- 槽位名称到类型的映射
Component.SlotName2Type = {
    [Component.ESlotName.Char] = "Char",
    [Component.ESlotName.Pet] = "Pet",
    [Component.ESlotName.RangedWeapon] = "Ranged",
    [Component.ESlotName.MeleeWeapon] = "Melee",
    [Component.ESlotName.Phantom1] = "Char",
    [Component.ESlotName.PhantomWeapon1] = "Weapon",
    [Component.ESlotName.Phantom2] = "Char",
    [Component.ESlotName.PhantomWeapon2] = "Weapon",
}

-- 槽位类型到数据类型的映射
Component.SlotType2DataType = {
    ["Char"] = "Char",
    ["Pet"] = "Pet",
    ["Weapon"] = "Weapon",
    ["Ranged"] = "Weapon",
    ["Melee"] = "Weapon",
}

-- 空值常量
local NullUUid = CommonConst.AbyssTeamNoChar
local NullUnitId = CommonConst.AbyssTeamNoPet

-- 初始化Component
-- @param Slots 槽位Widget映射表，格式：{ [ESlotName.Char] = CharacterWidget, [ESlotName.MeleeWeapon] = Weapon_MeleeWidget, ... }
-- @param List_Select 列表视图（EMListView类型），用于显示可选择的物品列表
-- @param Sort 排序组件，用于列表排序功能
-- @param EMListView_Filter 筛选列表视图，用于筛选物品
-- @param Pos_Tip 物品详情Widget的父容器（可选，用于AttachTipsWidget）
-- @param Tab_Primary 武器类型切换Tab（可选），用于魅影武器槽位时显示近战/远程切换Tab
-- @param Empty 空列表显示的Widget（可选），当列表为空时显示此Widget
-- @param Text_Empty 空状态提示文本Widget（可选），用于显示不同槽位类型的空状态提示文本
-- @param Type_Range 远程武器类型Tab按钮（可选），用于切换显示远程武器
-- @param Type_Melee 近战武器类型Tab按钮（可选），用于切换显示近战武器
-- @param Owner 拥有者Widget（可选），用于访问ActorController等外部资源
-- @note TrialData（试用数据）需要通过 InitSquadBuildData 函数单独初始化
-- @param Panel_FilterTab 筛选Tab容器（可选），用于显示筛选Tab
function Component:InitSquadBuildWidget(Slots, List_Select, Sort, EMListView_Filter, Pos_Tip, Tab_Primary, Empty, Text_Empty, Type_Range, Type_Melee, Owner, Panel_FilterTab)
    -- 槽位Widget映射
    self.Slots = Slots or {}
    
    -- 列表组件
    self.List_Select = List_Select
    self.Sort = Sort
    self.EMListView_Filter = EMListView_Filter
    self.Panel_FilterTab = Panel_FilterTab
    
    -- 物品详情
    self.Pos_Tip = Pos_Tip
    self.Tab_Primary = Tab_Primary
    self.Text_Empty = Text_Empty
    self.Empty = Empty
    
    -- 当前选中的槽位
    self.CurSlotName = Component.ESlotName.Null
    self.CurSlotType = ""
    self.CurWeaponType = "Melee"

    -- 武器类型Tab
    self.Type_Range = Type_Range
    self.Type_Melee = Type_Melee
    -- 初始化武器类型Tab
    self.TypeTabs = {
        [self.SlotName2Type[self.ESlotName.RangedWeapon]] = self.Type_Range,
        [self.SlotName2Type[self.ESlotName.MeleeWeapon]] = self.Type_Melee
    }
    self.Type_Range:Init(self.SlotName2Type[self.ESlotName.RangedWeapon], self)
    self.Type_Melee:Init(self.SlotName2Type[self.ESlotName.MeleeWeapon], self)
    
    -- 记录物品目前装备的槽位
    self.Uuid2SlotMap = {}
    
    -- 列表是否为空
    self.bListEmpty = false
    
    -- 当前选中的内容
    self.SelectedContent = nil
    
    -- 关卡索引
    self.DungeonIndex = 1
    
    -- 初始化列表相关
    self:InitSelectiveList()
    
    -- 绑定槽位点击事件
    self:BindSlotEvents()
    
    -- 绑定列表事件
    self:BindListEvents()
    
    -- 保存Owner引用（用于访问ActorController）
    self.Owner = Owner
end

-- 初始化试用数据
-- @param TrialData 试用数据表（可选），格式：
--   {
--     TrialChars = {RuleId1, RuleId2, ...},  -- 试用角色RuleId列表
--     TrialMeleeWeapons = {...},  -- 试用近战武器RuleId列表
--     TrialRangedWeapons = {...},  -- 试用远程武器RuleId列表
--     TrialPets = {PetId1, PetId2, ...},  -- 试用宠物PetId列表
--     ShowOwned = {  -- 是否显示玩家拥有的物品（默认true，向后兼容）
--       Chars = true,  -- 是否显示玩家拥有的角色
--       Weapons = true,  -- 是否显示玩家拥有的武器
--       Pets = true,  -- 是否显示玩家拥有的宠物
--     }
--   }
function Component:InitSquadBuildData(TrialData)
    -- 试用数据（设置默认值，确保向后兼容）
    self.TrialData = TrialData or {}
    if not self.TrialData.ShowOwned then
        self.TrialData.ShowOwned = {
            Chars = true,
            Weapons = true,
            Pets = true,
        }
    else
        -- 确保每个字段都有默认值
        self.TrialData.ShowOwned.Chars = self.TrialData.ShowOwned.Chars ~= false
        self.TrialData.ShowOwned.Weapons = self.TrialData.ShowOwned.Weapons ~= false
        self.TrialData.ShowOwned.Pets = self.TrialData.ShowOwned.Pets ~= false
    end
end

-- 绑定槽位点击事件
function Component:BindSlotEvents()
    for SlotName, SlotWidget in pairs(self.Slots) do
        if SlotWidget then
            -- 初始化槽位Widget
            SlotWidget:Init(SlotName, self)
            
            -- 建立魅影角色和武器槽位的关联关系
            if SlotName == Component.ESlotName.Phantom1 then
                SlotWidget.WeaponSlot = self.Slots[Component.ESlotName.PhantomWeapon1]
            elseif SlotName == Component.ESlotName.Phantom2 then
                SlotWidget.WeaponSlot = self.Slots[Component.ESlotName.PhantomWeapon2]
            elseif SlotName == Component.ESlotName.PhantomWeapon1 or SlotName == Component.ESlotName.PhantomWeapon2 then
                -- 初始化时，如果对应的魅影角色槽位为空，则设置武器槽位为 forbidden
                local PhantomSlotName = (SlotName == Component.ESlotName.PhantomWeapon1) and Component.ESlotName.Phantom1 or Component.ESlotName.Phantom2
                local PhantomSlot = self.Slots[PhantomSlotName]
                if PhantomSlot and PhantomSlot.IsEmpty then
                    SlotWidget:SetForbidden(true)
                end
            end
        end
    end
end

-- 绑定列表事件
function Component:BindListEvents()
    if self.List_Select then
        -- 绑定列表项点击	
        if self.List_Select.BP_OnItemClicked then	
            self.List_Select.BP_OnItemClicked:Clear()	
            self.List_Select.BP_OnItemClicked:Add(self, self.OnListItemClicked)	
        end

        -- 绑定列表项悬停
        if self.List_Select.BP_OnItemIsHoveredChanged then
            self.List_Select.BP_OnItemIsHoveredChanged:Add(self, self.OnItemIsHoverChanged)
        end
    end
    
    if self.Sort then
        -- 绑定排序事件
        if self.Sort.BindEventOnSelectionsChanged then
            self.Sort:BindEventOnSelectionsChanged(self, self.OnSortListSelectionsChanged)
        end
        if self.Sort.BindEventOnSortTypeChanged then
            self.Sort:BindEventOnSortTypeChanged(self, self.OnSortTypeChanged)
        end
    end
    
    if self.EMListView_Filter then
        -- 绑定筛选事件
        if self.EMListView_Filter.BP_OnItemClicked then
            self.EMListView_Filter.BP_OnItemClicked:Clear()
            self.EMListView_Filter.BP_OnItemClicked:Add(self, self.OnFilterListItemClicked)
        end
        
        -- 绑定筛选列表项初始化事件（用于设置Content.UI）
        if self.EMListView_Filter.BP_OnEntryInitialized then
            self.EMListView_Filter.BP_OnEntryInitialized:Add(self, self.OnFilterListItemInited)
        end
    end
end

-- 槽位被点击
function Component:OnSlotClicked(SlotName, bIsInit)
    if not self:IsListAllowRefresh() then
        return
    end
    
    local PreSlotName = self.CurSlotName
    self.CurSlotName = SlotName
    local CurSlotType = Component.SlotName2Type[SlotName]
    
    -- 若与之前选中的配置槽不同，则重新初始化数据
    if self.CurSlotName ~= PreSlotName then
        -- 取消之前槽位的选中状态
        if PreSlotName ~= Component.ESlotName.Null and self.Slots[PreSlotName] then
            if self.Slots[PreSlotName].SetIsChecked then
                self.Slots[PreSlotName]:SetIsChecked(false)
            end
        end
        
        -- 选中新槽位
        if self.Slots[self.CurSlotName] then
            if self.Slots[self.CurSlotName].SetIsChecked then
                self.Slots[self.CurSlotName]:SetIsChecked(true)
            end
        end
        self:ChangeEmptyTextBySlotType(CurSlotType)
        -- 若是魅影武器，则显示武器类型Tab栏
        if CurSlotType == "Weapon" then
            -- 显示武器类型切换Tab（如果有）
            self.Tab_Primary:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.IsTabPrimaryVisible = true
            local WeaponType = "Melee"
            if self.Slots[self.CurSlotName] and self.Slots[self.CurSlotName].WeaponType then
                WeaponType = self.Slots[self.CurSlotName].WeaponType
            end
            self:PhantomWeaponTypeChanged(WeaponType, false, true)
            -- 这个需要写在挂载的ui上面，是一个要自己实现的函数，用于Buton点击
            if self.UpdateListSelect then
                self:UpdateListSelect(self.CurSlotName)
            end
            return
        else
            self.Tab_Primary:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.IsTabPrimaryVisible = false
        end
        
        self.CurSlotType = CurSlotType
        self:ReInitListItems()
    end
    -- 这个需要写在挂载的ui上面，是一个要自己实现的函数，用于Buton点击
    if self.UpdateListSelect and not bIsInit then
        self:UpdateListSelect(self.CurSlotName)
    end
end

function Component:ChangeEmptyTextBySlotType(SlotType)
    if SlotType == "Char" then
        self.Text_Empty:SetText(GText("UI_Armory_Char_Empty"))
    elseif SlotType == "Pet" then
        self.Text_Empty:SetText(GText("UI_Armory_Pet_Empty"))
    elseif SlotType == "Weapon" or SlotType == "Melee" or SlotType == "Ranged" then
        self.Text_Empty:SetText(GText("UI_Armory_Weapon_Empty"))
    end
end

-- 初始化筛选列表相关配置
function Component:InitSelectiveList()
    self.OrderByDisplayNames = {"UI_LEVEL_SELECT"}
    self.OrderByAttrNames = {"Level","Rarity","SortPriority","UnitId"}
    self.PetOrderByAttrNames = {"BreakNum","Level","Rarity","SortPriority","UnitId"}
    
    -- 角色筛选
    self.CharFilterTags, self.CharFilterNames = UIUtils.GetAllElementTypes()
    self.CharFilterIcons = {}
    for key, Tag in pairs(self.CharFilterTags) do
        local IconName = "Armory_" .. Tag
        table.insert(self.CharFilterIcons, "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName)
    end
    
    -- 武器筛选
    self.MeleeFilterTags, self.MeleeFilterNames, self.RangedFilterTags, self.RangedFilterNames = UIUtils.GetAllWeaponTags()
    self.MeleeFilterIcons = {}
    for _, Tag in ipairs(self.MeleeFilterTags) do
        local Data = DataMgr.WeaponTag[Tag]
        table.insert(self.MeleeFilterIcons, Data and Data.Icon)
    end
    self.RangedFilterIcons = {}
    for _, Tag in ipairs(self.RangedFilterTags) do
        local Data = DataMgr.WeaponTag[Tag]
        table.insert(self.RangedFilterIcons, Data and Data.Icon)
    end
end

-- 初始化Widget
function Component:InitWidget()
    -- 记录物品目前装备的槽位
    self.Uuid2SlotMap = {}
    
    self.CurSlotType = ""
    self.CurSlotName = Component.ESlotName.Null
    self.CurWeaponType = self.CurWeaponType or "Melee"
    
    self.bListEmpty = false
    self.SelectedContent = nil
    
    -- 初始化各个MainComponent的Widget
    self:CharMain_InitWidget()
    self:PetMain_InitWidget()
    self:WeaponMain_InitWidget()
end


-- 重新初始化列表项
function Component:ReInitListItems()
    if not self.Slots[self.CurSlotName] then
        return
    end
    
    -- 获取当前槽位的Uuid
    local SlotWidget = self.Slots[self.CurSlotName]
    local Uuid = nil
    if SlotWidget.Uuid then
        Uuid = SlotWidget.Uuid
    end
    
    -- 设置CurrentUuid
    if self.CurSlotType == "Weapon" then
        self["Current"..self.CurWeaponType.."Uuid"] = Uuid
    else
        self["Current"..self.CurSlotType.."Uuid"] = Uuid
    end
    
    -- 调用对应的Main_Init方法（由Component内部提供）
    local FuncName = nil
    if self.CurSlotType == "Weapon" then
        -- 武器类型需要根据CurWeaponType来调用
        FuncName = self.CurWeaponType.."Main_Init"
    else
        FuncName = self.CurSlotType.."Main_Init"
    end
    self:CallFunctionByName(FuncName)
    
    -- 初始化物品详情Widget
    if self.ItemDetailWidget then
        self:InitItemDetailWidget()
    end
    
    -- 填充列表
    self:FillSelectiveList()
end

-- ==================== CharMainComponent 逻辑 ====================
function Component:CharMain_Init(NeedInit)
    if NeedInit then
        self:CharMain_CreateItemContents()
    end
    self:CharMain_InitListView()
end

function Component:CharMain_InitWidget()
    self.CharItemContentsMap = nil
    self.CharItemContentsArray = nil
    self.CurrentCharUuid = nil
    self.BP_CharItemContents:Clear()
    self.CharMain_CurContent = nil
end

function Component:CharMain_CreateItemContents()
    local Avatar = GWorld:GetAvatar()
    self.CharItemContentsMap = {}
    self.CharItemContentsArray = {}
    self.BP_CharItemContents:Clear()
    local Obj = nil
    
    -- 添加玩家拥有的角色（如果配置允许）
    if self.TrialData.ShowOwned.Chars then
        for Uuid, Char in pairs(Avatar.Chars) do
            local CharId = Char.CharId
            -- 检查是否在限制列表中
            if self:CheckInLimitList(CharId, self.LimitData and self.LimitData.LimitCharacters) then
                Obj = self:NewItemContent(Char, CommonConst.ArmoryType.Char, CommonConst.ArmoryTag.Char)
                self.CharItemContentsMap[Uuid] = Obj
                self.BP_CharItemContents:Add(Obj)
                table.insert(self.CharItemContentsArray, Obj)
            end
        end
    end
    
    -- 添加试用角色（如果有）
    if self.TrialData and self.TrialData.TrialChars then
        for _, RuleId in ipairs(self.TrialData.TrialChars) do
            if RuleId and DataMgr.CharTemplate[RuleId] then
                Obj = self:NewTrialCharContent(RuleId)
                if Obj then
                    self.CharItemContentsMap[RuleId] = Obj
                    self.BP_CharItemContents:Add(Obj)
                    table.insert(self.CharItemContentsArray, Obj)
                end
            end
        end
    end
end

function Component:CharMain_InitListView()
    self:CharMain_InitContentState()
    self:CharMain_SortItemContents()
    -- 初始化时检查冲突状态
    self:UpdateCharConflict()
end

function Component:CharMain_InitContentState()
    -- 通过CurrentUuid获取CurContent，用于设置IsSelected状态
    if self.CurrentCharUuid and self.CharItemContentsMap then
        local CurContent = self.CharItemContentsMap[self.CurrentCharUuid]
        if CurContent then
            CurContent.IsSelected = true
        end
    end
end

function Component:CharMain_SortItemContents()
    -- 通过CurrentUuid获取CurContent用于排序
    local CurContent = nil
    if self.CurrentCharUuid and self.CharItemContentsMap then
        CurContent = self.CharItemContentsMap[self.CurrentCharUuid]
    end
    ArmoryUtils:SortItemContents(self.CharItemContentsArray, {"Level", "Rarity", "SortPriority", "UnitId"}, CommonConst.DESC, CurContent, Component.IsTryoutCmpFunc)
end

function Component:CharMain_OnListItemClicked(Content)
    if self.CurSlotType == "Char" then
        self.CurrentCharUuid = Content.Uuid
    end
end

-- ==================== PetMainComponent 逻辑 ====================
function Component:PetMain_Init(NeedInit)
    if NeedInit then
        self:PetMain_CreateItemContents()
    end
    self:PetMain_InitListView()
end

function Component:PetMain_InitWidget()
    self.PetItemContentsMap = nil
    self.PetItemContentsArray = nil
    self.CurrentPetUuid = nil
    self.BP_PetItemContents:Clear()
    self.PetMain_CurContent = nil
end

function Component:PetMain_CreateItemContents()
    local Avatar = GWorld:GetAvatar()
    self.PetItemContentsMap = {}
    self.PetItemContentsArray = {}
    self.BP_PetItemContents:Clear()
    local Obj = nil
    
    -- 添加玩家拥有的宠物（如果配置允许）
    if self.TrialData.ShowOwned.Pets then
        for UniqueId, Pet in pairs(Avatar.Pets) do
            if self:CheckPetType(Pet.PetId) then
                -- 检查是否在限制列表中
                if self:CheckInLimitList(Pet.PetId, self.LimitData and self.LimitData.LimitPets) then
                    Obj = self:NewPetItemContent(Pet)
                    self.PetItemContentsMap[UniqueId] = Obj
                    self.BP_PetItemContents:Add(Obj)
                    table.insert(self.PetItemContentsArray, Obj)
                end
            end
        end
    end
    
    -- 添加试用宠物（如果有）
    if self.TrialData and self.TrialData.TrialPets then
        for _, PetId in ipairs(self.TrialData.TrialPets) do
            if PetId and DataMgr.Pet[PetId] then
                Obj = self:NewTrialPetContent(PetId)
                if Obj then
                    -- 使用PetId作为唯一标识（试用宠物没有UniqueId）
                    self.PetItemContentsMap[PetId] = Obj
                    self.BP_PetItemContents:Add(Obj)
                    table.insert(self.PetItemContentsArray, Obj)
                end
            end
        end
    end
end

function Component:CheckPetType(PetId)
    return DataMgr.Pet[PetId].PetType == 1
end

function Component:PetMain_InitListView()
    -- 通过CurrentPetUuid获取CurContent，用于设置IsSelected状态和排序
    local CurContent = nil
    if self.CurrentPetUuid and self.PetItemContentsMap then
        CurContent = self.PetItemContentsMap[self.CurrentPetUuid]
        if CurContent then
            CurContent.IsSelected = true
        end
    end
    ArmoryUtils:SortItemContents(self.PetItemContentsArray, {"BreakNum", "Level", "Rarity", "SortPriority", "UnitId"}, CommonConst.DESC, CurContent, Component.IsTryoutCmpFunc)
end

function Component:PetMain_OnListItemClicked(Content)
    if self.CurSlotType == "Pet" then
        self.CurrentPetUuid = Content.Uuid
    end
end

-- ==================== WeaponMainComponent 逻辑 ====================
function Component:WeaponMain_InitWidget()
    self.WeaponItemContentsMap = nil
    self.WeaponItemContentsArray = nil
    self.CurrentWeaponUuidName = nil
    self.CurContentName = nil
    
    local WeaponTags = {CommonConst.ArmoryTag.Melee, CommonConst.ArmoryTag.Ranged}
    for _, Tag in pairs(WeaponTags) do
        self["BP_"..Tag.."ItemContents"]:Clear()
        self[Tag.."ItemContentsMap"] = nil
        self[Tag.."ItemContentsArray"] = nil
        self[Tag .. "Main_CurContent"] = nil
        self["Current" .. Tag .. "Uuid"] = nil
    end
end

function Component:MeleeMain_Init(NeedInit)
    self.WeaponTag = CommonConst.ArmoryTag.Melee
    self:WeaponMain_Init(NeedInit)
end

function Component:RangedMain_Init(NeedInit)
    self.WeaponTag = CommonConst.ArmoryTag.Ranged
    self:WeaponMain_Init(NeedInit)
end

function Component:WeaponMain_Init(NeedInit)
    self.CurrentWeaponUuidName = "Current" .. self.WeaponTag .. "Uuid"
    if NeedInit then
        self:WeaponMain_CreateItemContents()
    end
    self:SwitchContentsArray()
    self:WeaponMain_InitListView()
end

function Component:WeaponMain_CreateItemContents()
    local Avatar = GWorld:GetAvatar()
    self[self.WeaponTag.."ItemContentsMap"] = {}
    self[self.WeaponTag.."ItemContentsArray"] = {}
    local ItemContentsMap = self[self.WeaponTag.."ItemContentsMap"]
    local ItemContentsArray = self[self.WeaponTag.."ItemContentsArray"]
    self["BP_"..self.WeaponTag.."ItemContents"]:Clear()
    local Obj = nil
    
    -- 添加玩家拥有的武器（如果配置允许）
    if self.TrialData.ShowOwned.Weapons then
        for Uuid, Weapon in pairs(Avatar.Weapons) do
            if Weapon:HasTag(self.WeaponTag) then
                local WeaponId = Weapon.WeaponId
                -- 根据武器类型选择对应的限制列表
                local LimitList = nil
                if self.WeaponTag == CommonConst.ArmoryTag.Melee then
                    LimitList = self.LimitData and self.LimitData.LimitMeleeWeapons
                elseif self.WeaponTag == CommonConst.ArmoryTag.Ranged then
                    LimitList = self.LimitData and self.LimitData.LimitRangedWeapons
                end
                -- 检查是否在限制列表中
                if self:CheckInLimitList(WeaponId, LimitList) then
                    Obj = self:NewItemContent(Weapon, CommonConst.ArmoryType.Weapon, self.WeaponTag)
                    self["BP_"..self.WeaponTag.."ItemContents"]:Add(Obj)
                    table.insert(ItemContentsArray, Obj)
                    ItemContentsMap[Uuid] = Obj
                end
            end
        end
    end
    
    -- 添加试用武器（如果有）
    local TrialWeaponsKey = nil
    if self.WeaponTag == CommonConst.ArmoryTag.Melee then
        TrialWeaponsKey = "TrialMeleeWeapons"
    elseif self.WeaponTag == CommonConst.ArmoryTag.Ranged then
        TrialWeaponsKey = "TrialRangedWeapons"
    end
    
    if TrialWeaponsKey and self.TrialData and self.TrialData[TrialWeaponsKey] then
        for _, RuleId in ipairs(self.TrialData[TrialWeaponsKey]) do
            if RuleId and DataMgr.WeaponTemplate[RuleId] then
                Obj = self:NewTrialWeaponContent(RuleId, self.WeaponTag)
                if Obj then
                    self["BP_"..self.WeaponTag.."ItemContents"]:Add(Obj)
                    table.insert(ItemContentsArray, Obj)
                    ItemContentsMap[RuleId] = Obj
                end
            end
        end
    end
end

function Component:SwitchContentsArray()
    self.WeaponItemContentsMap = self[self.WeaponTag.."ItemContentsMap"]
    self.WeaponItemContentsArray = self[self.WeaponTag.."ItemContentsArray"]
end

function Component:WeaponMain_InitListView()
    self:WeaponMain_InitContentState()
    -- 通过CurrentUuid获取CurContent用于排序
    local CurContent = nil
    if self[self.CurrentWeaponUuidName] and self.WeaponItemContentsMap then
        CurContent = self.WeaponItemContentsMap[self[self.CurrentWeaponUuidName]]
    end
    ArmoryUtils:SortItemContents(self.WeaponItemContentsArray, {"Level", "Rarity", "SortPriority", "UnitId"}, CommonConst.DESC, CurContent, Component.IsTryoutCmpFunc)
end

function Component:WeaponMain_InitContentState()
    self.CurContentName = self.WeaponTag .. "Main_CurContent"
    -- 通过CurrentUuid获取CurContent，用于设置IsSelected状态
    if self[self.CurrentWeaponUuidName] and self.WeaponItemContentsMap then
        local CurContent = self.WeaponItemContentsMap[self[self.CurrentWeaponUuidName]]
        if CurContent then
            CurContent.IsSelected = true
        end
    end
end

function Component:WeaponMain_OnListItemClicked(Content)
    if self.CurSlotType == self.WeaponTag then
        self[self.CurrentWeaponUuidName] = Content.Uuid
    end
end

-- 填充筛选列表
function Component:FillSelectiveList()
    if not self.List_Select then
        return
    end
    
    -- 创建筛选器
    local Filters = nil
    local FilterTags, FilterNames, FilterIcons = nil, nil, nil
    
    if self.CurSlotType == "Weapon" then
        -- 武器类型需要根据CurWeaponType来获取
        FilterTags = self[self.CurWeaponType .. "FilterTags"]
        FilterNames = self[self.CurWeaponType .. "FilterNames"]
        FilterIcons = self[self.CurWeaponType .. "FilterIcons"]
    else
        FilterTags = self[self.CurSlotType .. "FilterTags"]
        FilterNames = self[self.CurSlotType .. "FilterNames"]
        FilterIcons = self[self.CurSlotType .. "FilterIcons"]
    end
    
    if FilterTags then
        Filters = self:CreateFilters(FilterTags, FilterNames, FilterIcons)
    end
    
    -- 初始化筛选列表
    if self.EMListView_Filter then
        self.EMListView_Filter:ClearListItems()
        
        -- 添加"全部"选项
        if Filters and #Filters > 0 then
            local FilterContentObj_All = NewObject(UIUtils.GetCommonItemContentClass())
            FilterContentObj_All.IsSelected = true
            FilterContentObj_All.Index = 0
            FilterContentObj_All.Icon = '/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Wuyousheng_All.T_Tab_Wuyousheng_All'
            FilterContentObj_All.Owner = self
            self.EMListView_Filter:AddItem(FilterContentObj_All)
            self.FilterContentObj_All = FilterContentObj_All
            
            -- 添加筛选选项
            for Index, FilterTag in ipairs(Filters) do
                local Obj = NewObject(UIUtils.GetCommonItemContentClass())
                for key, value in pairs(FilterTag) do
                    Obj[key] = value
                end
                Obj.Index = Index
                Obj.Owner = self
                self.EMListView_Filter:AddItem(Obj)
            end
            self.Panel_FilterTab:SetVisibility(UIConst.VisibilityOp.Visible)
        else
            self.Panel_FilterTab:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
    
    -- 初始化排序组件
    if self.Sort then
        self.Sort:Init(self, self.OrderByDisplayNames, CommonConst.DESC)
    end
    
    -- 初始化筛选后的内容
    self.FilteredContents = {}
    self.SelectedFilterContents = {}  -- 记录选中的筛选标签
    local ItemContentsArray = nil
    
    -- 根据当前槽位类型获取对应的ItemContentsArray
    if self.CurSlotType == "Weapon" then
        -- 武器类型需要根据CurWeaponType来获取
        ItemContentsArray = self[self.CurWeaponType .. "ItemContentsArray"]
    else
        ItemContentsArray = self[self.CurSlotType .. "ItemContentsArray"]
    end
    
    if ItemContentsArray then
        for index, value in ipairs(ItemContentsArray) do
            table.insert(self.FilteredContents, value)
        end
    end
    
    -- 填充列表
    self:FillListView()
end

-- 填充列表视图
function Component:FillListView()
    if not self.List_Select then
        return
    end
    -- 清空列表
    self.List_Select:ClearListItems()    
    -- 添加列表项
    for _, Content in ipairs(self.FilteredContents) do
        self.List_Select:AddItem(Content)
    end

    self.List_Select:RequestFillEmptyContent()
    
    -- 检查列表是否为空
    local bListEmpty = (#self.FilteredContents <= 0)
    self.bListEmpty = bListEmpty
    
    -- 设置空列表显示（如果有Empty Widget）
    if self.Empty then
        if bListEmpty then
            self.List_Select:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.Empty:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        else
            self.Empty:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.List_Select:SetVisibility(UIConst.VisibilityOp.Visible)
        end
    end
    
    -- 通知列表初始化完成
    self:OnListInited(bListEmpty)
end

-- 创建筛选器
function Component:CreateFilters(InTags, InTexts, InIcons)
    local Filters = {}
    for i, _ in ipairs(InTags) do
        table.insert(Filters, {
            Tag = InTags[i],
            Text = InTexts[i],
            Icon = InIcons[i],
        })
    end
    return Filters
end

-- 魅影武器类型改变
function Component:PhantomWeaponTypeChanged(Type, IsPlaySound, bSlotChanged)
    if Type ~= "Ranged" and Type ~= "Melee" then
        DebugPrint("SquadBuildComponent:PhantomWeaponTypeChanged:传入武器类型无效,", Type)
        return
    end
    
    if not bSlotChanged and not self:IsListAllowRefresh() then
        return
    end
    
    if self.CurWeaponType then
        if not bSlotChanged and Type == self.CurWeaponType then
            return
        end
        -- 取消之前的Tab选中
        if self.TypeTabs and self.TypeTabs[self.CurWeaponType] then
            self.TypeTabs[self.CurWeaponType]:SetIsChecked(false)
        end
    end
    
    -- 选中新的Tab
    if self.TypeTabs and self.TypeTabs[Type] then
        self.TypeTabs[Type]:SetIsChecked(true, IsPlaySound)
    end
    
    self.CurWeaponType = Type
    self.CurSlotType = self.CurWeaponType
    self:ReInitListItems()
end

-- 装备物品到槽位的核心逻辑（提取出来供试用道具和普通道具复用）
function Component:EquipItemToSlot(Content, ModIndex, NeedShowModIndexInfo)
    if not Content or not Content.Uuid then
        return
    end
    
    -- 获取当前槽位Widget
    local CurSlotWidget = self.Slots[self.CurSlotName]
    if not CurSlotWidget then
        return
    end

    if Content.bConflict then
        UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_Wuyousheng_Toast_OnlyOneChar"))
        return
    end
    
    -- 如果传入了 ModIndex，存储到 Content 上
    if ModIndex then
        Content.ModSuitIndex = ModIndex
    end
    
    -- 设置是否需要显示 ModIndex 信息（默认 true，如果明确传入 false 则设为 false）
    if NeedShowModIndexInfo ~= nil then
        Content.NeedShowModIndexInfo = NeedShowModIndexInfo
    else
        -- 如果没有明确指定，默认根据是否有 ModIndex 来决定
        Content.NeedShowModIndexInfo = ModIndex ~= nil
    end
    
    -- 获取当前槽位的类型和已装备的Content
    local Type = Component.SlotName2Type[self.CurSlotName]
    local CurContent = CurSlotWidget.Content  -- 直接从SlotWidget获取Content
    
    -- 确定Type（用于后续的UpdateCurrentUuid）
    if Type == "Weapon" then
        -- 如果有Content，根据Content.Tag确定Type；否则使用CurSlotWidget.WeaponType
        if CurContent and CurContent.Tag then
            Type = CurContent.Tag  -- Content.Tag 是 "Melee" 或 "Ranged"
        else
            Type = CurSlotWidget.WeaponType or "Melee"
        end
    end
    
    -- 如果点击的是其他槽位已装备的物品，则交换槽位
    if Content.IsChosen then
        local OtherSlotInfo = self.Uuid2SlotMap[Content.Uuid]
        if OtherSlotInfo and self.Slots[OtherSlotInfo.SlotName] then
            -- 如果装的是同一个Content就直接返回
            if CurContent == Content then
                return
            end
            local OtherSlotWidget = self.Slots[OtherSlotInfo.SlotName]
            -- 先取消当前槽位的装备
            if CurContent then
                self:SetContentIsChosen(CurContent, false)
            end
            -- 将当前槽位的物品装备到其他槽位
            if CurContent then
                self:UpdateSlot(OtherSlotInfo.SlotName, CurContent)
                self:SetContentIsChosen(CurContent, true)
            else
                self:ClearSlot(OtherSlotInfo.SlotName)
            end
            -- 装备新物品到当前槽位
            self:UpdateSlot(self.CurSlotName, Content)
            self:SetContentIsChosen(Content, true)
            -- 更新对应的CurrentUuid
            self:UpdateCurrentUuid(Type, Content.Uuid)
            
            -- 如果装备的是角色，检查并更新冲突状态
            if Type == "Char" then
                self:UpdateCharConflict()
            end
            
            -- 显示交换提示
            self:PopChangeRoleToastByType(Content, self.CurSlotName)
            
            if self.OnLeftItemContentChanged then
                self:OnLeftItemContentChanged()
            end
            return
        end
    end
    
    -- 否则，装备到当前槽位
    -- 先取消当前槽位的装备
    if CurContent then
        self:SetContentIsChosen(CurContent, false)
    end
    -- 装备新物品
    self:UpdateSlot(self.CurSlotName, Content)
    self:SetContentIsChosen(Content, true)
    -- 更新对应的CurrentUuid
    self:UpdateCurrentUuid(Type, Content.Uuid)
    
    -- 如果装备的是角色，检查并更新冲突状态
    if Type == "Char" then
        self:UpdateCharConflict()
    end
    
    if self.OnLeftItemContentChanged then
        self:OnLeftItemContentChanged()
    end
end

-- 列表项点击（核心选择逻辑）
function Component:OnListItemClicked(Content)
    if not Content or not Content.Uuid then
        return
    end

    if Content.UI then
        Content.UI:OnItemClick()
    end
    
    -- 显示物品详情（非手柄模式）
    if not self.IsUseGamePad and self.ItemDetailWidget then
        self:ShowItemDetails(not self:IsChar(), Content)
    end
    
    -- 判断是否是魅影相关槽位
    local IsPhantomSlot = (self.CurSlotName == Component.ESlotName.Phantom1) or
                          (self.CurSlotName == Component.ESlotName.PhantomWeapon1) or
                          (self.CurSlotName == Component.ESlotName.Phantom2) or
                          (self.CurSlotName == Component.ESlotName.PhantomWeapon2)
    
    -- 如果是试用道具，直接装备，不走弹窗
    if Content.IsTryout then
        self:EquipItemToSlot(Content, nil)
        self:CloseTips()
        return
    end
    
    -- 如果是魅影相关槽位，直接装备，ModIndex 设为 1，但不显示 ModIndex 信息
    if IsPhantomSlot then
        self:EquipItemToSlot(Content, 1, false)
        return
    end
    
    -- 非试用道具且非魅影槽位，打开弹窗选择 ModIndex
    self:OpenTips(Content)
end

-- 检查并更新角色冲突状态
function Component:UpdateCharConflict()
    if not self.CharItemContentsArray then
        return
    end
    
    -- 收集所有已装备角色的信息：UnitId、Uuid、SlotName
    -- 格式：{ [UnitId] = { [Uuid] = SlotName, ... } }
    local EquippedCharInfo = {}
    for SlotName, SlotWidget in pairs(self.Slots) do
        if SlotWidget and SlotWidget.Content then
            local SlotType = Component.SlotName2Type[SlotName]
            -- 只检查角色槽位（Char、Phantom1、Phantom2）
            if SlotType == "Char" then
                local Content = SlotWidget.Content
                if Content and Content.CharId then
                    -- 记录这个 CharId 装备在哪个槽位
                    EquippedCharInfo[Content.CharId] = SlotName
                end
            end
        end
    end
    
    -- 获取当前选中的槽位
    local CurSlotName = self.CurSlotName or Component.ESlotName.Null
    
    -- 遍历所有角色 Content，检查冲突并更新状态
    for _, Content in ipairs(self.CharItemContentsArray) do
        if Content and Content.CharId then
            local IsConflict = false
            -- 检查是否有相同 CharId 的角色已装备
            local EquippedSlotName = EquippedCharInfo[Content.CharId]
            if EquippedSlotName and EquippedSlotName ~= CurSlotName then
                IsConflict = true
            end
            
            if Content.IsChosen then
                IsConflict = false
            end
            Content.bConflict = IsConflict
            
            -- 如果 Content 有 UI，更新 UI 状态
            if Content.SelfWidget then
                Content.SelfWidget:SetItemConflict(IsConflict)
            end
        end
    end
end

-- 更新对应的CurrentUuid（用于排序和初始化）
function Component:UpdateCurrentUuid(Type, Uuid)
    if Type == "Char" then
        self.CurrentCharUuid = Uuid
    elseif Type == "Pet" then
        self.CurrentPetUuid = Uuid
    elseif Type == "Melee" or Type == "Ranged" then
        self["Current"..Type.."Uuid"] = Uuid
    end
end

-- 设置内容是否被选中（装备状态）
function Component:SetContentIsChosen(Content, IsChosen)
    if not Content then
        return
    end
    
    Content.IsChosen = IsChosen
    if not IsChosen then
        Content.WeaponMiniPhantomIconCharId = nil
        Content.bInGear = false
    else
        if not Content.WeaponMiniPhantomIconCharId then
            Content.bInGear = true
        end
    end
    if Content.SelfWidget then
        Content.SelfWidget:SetInGear(Content.bInGear)
        Content.SelfWidget:SetWeaponMiniPhantomIcon(Content.WeaponMiniPhantomIconCharId)
        self:PlaySelectSound(Content.bInGear, Content.Type)
    end
end

-- 播放选择音效
local SelectSoundPaths = {
    Char = "event:/ui/armory/click_select_role",
    Weapon = "event:/ui/armory/click_select_weapon",
    Pet = "event:/ui/common/click_select_pet",
    Default = "event:/ui/common/click_mid",
}

local EquipSoundPaths = {
    Char = "event:/ui/common/role_replace",
    Weapon = "event:/ui/common/weapon_replace",
    Pet = "event:/ui/common/role_replace",
}

function Component:PlaySelectSound(IsSelected, Type)
    if not IsSelected then
        AudioManager(self):PlayUISound(self, SelectSoundPaths.Default, nil, nil)
    else
        AudioManager(self):PlayUISound(self, SelectSoundPaths[Type] or SelectSoundPaths.Default, nil, nil)
        AudioManager(self):PlayUISound(self, EquipSoundPaths[Type] or EquipSoundPaths.Default, nil, nil)
    end
end

-- IsTryout 优先比较函数（试用物品排在前面）
function Component.IsTryoutCmpFunc(a, b)
    if a.IsTryout ~= b.IsTryout then
        -- IsTryout 为 true 的排在前面
        if a.IsTryout then
            return true
        else
            return false
        end
    end
    -- 如果 IsTryout 相同，返回 nil，继续使用其他排序规则
    return nil
end

-- 排序列表内容
function Component:SortItemContents(InOutContentArray, SortByIdx, SortType)
    -- 通过CurrentUuid获取FirstContent用于排序
    local FirstContent = self:GetCurrentContentForSort()
    local OrderByAttrNames
    if self.CurSlotType == "Pet" then
        OrderByAttrNames = self.PetOrderByAttrNames
        if SortByIdx == 2 then SortByIdx = 3 end
    else
        OrderByAttrNames = self.OrderByAttrNames
    end
    local SortByAttrNames = {OrderByAttrNames[SortByIdx]}
    for index, value in ipairs(OrderByAttrNames) do
        if index ~= SortByIdx then
            table.insert(SortByAttrNames, value)
        end
    end
    ArmoryUtils:SortItemContents(InOutContentArray, SortByAttrNames, SortType, FirstContent, Component.IsTryoutCmpFunc)
end

-- 获取当前Content用于排序（通过CurrentUuid查找）
function Component:GetCurrentContentForSort()
    if self.CurSlotType == "Char" then
        if self.CurrentCharUuid and self.CharItemContentsMap then
            return self.CharItemContentsMap[self.CurrentCharUuid]
        end
    elseif self.CurSlotType == "Pet" then
        if self.CurrentPetUuid and self.PetItemContentsMap then
            return self.PetItemContentsMap[self.CurrentPetUuid]
        end
    elseif self.CurSlotType == "Melee" or self.CurSlotType == "Ranged" then
        local CurrentUuidName = "Current" .. self.CurSlotType .. "Uuid"
        if self[CurrentUuidName] and self[self.CurSlotType.."ItemContentsMap"] then
            return self[self.CurSlotType.."ItemContentsMap"][self[CurrentUuidName]]
        end
    end
    return nil
end

-- 筛选列表内容
function Component:FilterItemContents(InContentArray, FilterIdxes)
    local SlotType = self.CurSlotType
    local DataType = Component.SlotType2DataType[SlotType]
    local FilteredItems = {}
    local FilterFunc
    local FilterTags = nil
    
    -- 获取对应的FilterTags
    if SlotType == "Weapon" then
        FilterTags = self[self.CurWeaponType .. "FilterTags"]
    else
        FilterTags = self[SlotType .. "FilterTags"]
    end
    
    if DataType == "Char" then
        FilterFunc = function(FilterTag, Content)
            return FilterTag == Content.Attribute
        end
    elseif DataType == "Weapon" then
        local Avatar = GWorld:GetAvatar()
        FilterFunc = function(FilterTag, Content)
            if Content.IsTryout then
                local WeaponInfo = DataMgr.BattleWeapon[Content.WeaponId]
                if WeaponInfo then
                    for _, Tag in ipairs(WeaponInfo.WeaponTag) do
                        if Tag == FilterTag then
                            return true
                        end
                    end
                end
                return false
            else
                local Weapon = Avatar.Weapons[Content.Uuid]
                return Weapon and Weapon:HasTag(FilterTag)
            end
        end
    elseif DataType == "Pet" then
        FilterFunc = function()
            return true
        end
    end
    
    if FilterFunc and FilterTags then
        for _, Content in ipairs(InContentArray) do
            -- 检查Content是否为nil，防止空内容导致错误
            if Content then
                -- 检查是否已经添加过这个Content（通过Uuid判断）
                local ContentKey = Content.Uuid or tostring(Content)
                for _, Idx in ipairs(FilterIdxes) do
                    if FilterTags[Idx] and FilterFunc(FilterTags[Idx], Content) then
                        table.insert(FilteredItems, Content)
                        break
                    end
                end
            end
        end
    end
    
    return FilteredItems
end

-- 列表项悬停改变
function Component:OnItemIsHoverChanged(ItemContent, bHovered)
    if not ItemContent or not ItemContent.Uuid then
        return
    end
    
    -- 手柄模式下显示/隐藏物品详情
    if self.IsUseGamePad then
        self:ShowItemDetails(bHovered and ItemContent.Type ~= "Char", ItemContent)
    end
end

-- 排序依据选项选中时
function Component:OnSortListSelectionsChanged()
    if not self.Sort then
        return
    end
    local SortByIdx, SortType = self.Sort:GetSortInfos()
    if self.SortItemContents then
        self:SortItemContents(self.FilteredContents, SortByIdx, SortType)
        self:FillListView()
    end
end

-- 升序降序改变时
function Component:OnSortTypeChanged()
    if not self.Sort then
        return
    end
    local SortByIdx, SortType = self.Sort:GetSortInfos()
    if self.SortItemContents then
        self:SortItemContents(self.FilteredContents, SortByIdx, SortType)
        self:FillListView()
    end
end

-- 筛选列表项点击
function Component:OnFilterListItemClicked(Content)
    if not Content then
        return
    end
    
    -- 处理筛选逻辑
    if Content.IsSelected then
        return
    end

    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
    
    -- 清除之前选中的筛选标签
    if self.SelectedFilterContents then
        for Tag, Value in pairs(self.SelectedFilterContents) do
            if Value ~= Content then
                self:SetFilterContentIsSelected(Value, false)
                self.SelectedFilterContents[Tag] = nil
            end
        end
    end
    
    -- 如果点击的不是"全部"，则取消"全部"的选中状态
    if self.FilterContentObj_All and self.FilterContentObj_All ~= Content then
        self:SetFilterContentIsSelected(self.FilterContentObj_All, false)
    end
    
    -- 设置当前选中的筛选标签
    self:SetFilterContentIsSelected(Content, true)
    
    -- 更新筛选索引
    self.FilterIdxes = {}
    local FilterTags = nil
    if self.CurSlotType == "Weapon" then
        FilterTags = self[self.CurWeaponType .. "FilterTags"]
    else
        FilterTags = self[self.CurSlotType .. "FilterTags"]
    end
    
    if Content.Index == 0 then
        -- 全部选中
        if FilterTags then
            for i = 1, #FilterTags do
                table.insert(self.FilterIdxes, i)
            end
        end
    else
        table.insert(self.FilterIdxes, Content.Index)
    end
    
    -- 筛选内容
    if self.FilterItemContents then
        local ItemContentsArray = nil
        if self.CurSlotType == "Weapon" then
            ItemContentsArray = self[self.CurWeaponType .. "ItemContentsArray"]
        else
            ItemContentsArray = self[self.CurSlotType .. "ItemContentsArray"]
        end
        if ItemContentsArray then
            self.FilteredContents = self:FilterItemContents(ItemContentsArray, self.FilterIdxes) or {}
        end
    end
    
    -- 排序
    if self.SortItemContents then
        local SortByIdx, SortType = self.Sort:GetSortInfos()
        self:SortItemContents(self.FilteredContents, SortByIdx, SortType)
    end
    
    -- 填充列表
    self:FillListView()
end

-- 设置筛选标签的选中状态
function Component:SetFilterContentIsSelected(Content, IsSelected)
    if not Content then
        return
    end
    
    Content.IsSelected = IsSelected
    
    -- 更新UI显示状态（如果有SelfWidget或UI）
    if Content.SelfWidget and Content.SelfWidget.SetIsSelected then
        Content.SelfWidget:SetIsSelected(IsSelected)
    elseif Content.UI and Content.UI.SetIsSelected then
        Content.UI:SetIsSelected(IsSelected)
    end
    
    -- 更新SelectedFilterContents表
    -- 注意：使用Tag来索引，如果没有Tag则使用Index
    local Key = Content.Tag or Content.Index
    if Key then
        self.SelectedFilterContents = self.SelectedFilterContents or {}
        if IsSelected then
            self.SelectedFilterContents[Key] = Content
        else
            self.SelectedFilterContents[Key] = nil
        end
    end
end

-- 筛选列表项初始化
function Component:OnFilterListItemInited(Content, EntryUI)
    if Content and EntryUI then
        Content.UI = EntryUI
        -- 如果Content已经选中，更新UI状态
        if Content.IsSelected then
            EntryUI:SetIsSelected(true)
        end
    end
end

-- 列表初始化完成回调
function Component:OnListInited(bListEmpty)
    self.bListEmpty = bListEmpty
    if self.bItemDetailsShowed then
        self:ShowItemDetails(false)
    end
    self:UpdateTeamIcons()
    if self.InitNavigation then
        self:InitNavigation()
    end
end

-- 显示/隐藏物品详情
function Component:ShowItemDetails(bShow, Content)
    if not self.ItemDetailWidget then
        return
    end
    
    if bShow then
        if self.bListEmpty then
            return
        end
        if Content and Content.Type == "Char" then
            return
        end
        if self.ItemDetailsContent ~= Content then
            self.ItemDetailWidget:RefreshItemInfo(Content, true)
        end
        self.ItemDetailWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.ItemDetailWidget:StopAnimation(self.ItemDetailWidget.Out)
        self.ItemDetailWidget:PlayAnimation(self.ItemDetailWidget.In)
        self.bItemDetailsShowed = true
    else
        self.bItemDetailsShowed = false
        self.ItemDetailWidget:StopAnimation(self.ItemDetailWidget.In)
        self.ItemDetailWidget:PlayAnimation(self.ItemDetailWidget.Out)
    end
    self.ItemDetailsContent = Content
end

-- 附加Tips Widget（用于物品详情）
function Component:AttachTipsWidget(Widget)
    if self.Pos_Tip then
        self.Pos_Tip:AddChild(Widget)
    end
end

-- 创建新的物品Content
-- 检查是否在限制列表中
function Component:CheckInLimitList(Id, LimitList)
    if not self.LimitData or not LimitList or #LimitList == 0 then
        return true  -- 如果没有限制数据或限制列表为空，则允许显示
    end
    for _, LimitId in ipairs(LimitList) do
        if LimitId == Id then
            return true
        end
    end
    return false
end

function Component:NewItemContent(Target, Type, Tag)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.Uuid = Target.Uuid
    Obj.Type = Type
    Obj.Tag = Tag
    Obj.UnitId = Target[Type .. "Id"]
    Obj.CharId = Obj.UnitId
    Obj.UnitName = Target[Type .. "Name"]
    Obj.Rarity = Target[Type .. "Rarity"]
    Obj.Icon = Target:Data().Icon
    Obj.GachaIcon = Target:Data().GachaIcon
    Obj.Level = Target.Level
    Obj.GradeLevel = Target.GradeLevel
    Obj.IsTryout = false  -- 玩家拥有的物品不是试用
    Obj.bIsHoverState = true
    Obj.ConfirmDesc = "UI_CTL_Add/Remove"
    Obj.Attribute = DataMgr["Battle"..Type][Obj.UnitId].Attribute
    local Element = DataMgr["Battle"..Type][Obj.UnitId].Attribute
    if Element then
        local IconName = "Armory_" .. Element
        Obj.AttrIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName
    end
    Obj.SortPriority = Target:Data().SortPriority or 0
    return Obj
end

-- 创建新的宠物Content
function Component:NewPetItemContent(Target)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.Uuid = Target.UniqueId
    Obj.Type = CommonConst.ArmoryType.Pet
    Obj.Tag = CommonConst.ArmoryType.Pet
    Obj.UnitId = Target.PetId
    local Data = DataMgr.Pet[Obj.UnitId]
    Obj.UnitName = Data.Name
    Obj.Rarity = Data.Rarity
    Obj.Icon = Data.Icon
    Obj.Level = Target.Level
    Obj.BreakNum = Target.BreakNum
    Obj.IsTryout = false  -- 玩家拥有的宠物不是试用
    Obj.bIsHoverState = true
    Obj.ConfirmDesc = "UI_CTL_Add/Remove"
    Obj.SortPriority = Data.SortPriority or 0
    return Obj
end

-- 从模板创建试用角色Content
function Component:NewTrialCharContent(RuleId)
    if not RuleId or not DataMgr.CharTemplate[RuleId] then
        return nil
    end
    
    local Template = DataMgr.CharTemplate[RuleId]
    local CharId = Template.CharId
    if not CharId then
        return nil
    end
    
    -- 从 DataMgr.Char 获取角色数据（包含 Icon 和 GachaIcon）
    local CharData = DataMgr.Char[CharId]
    if not CharData then
        return nil
    end
    
    -- 从 DataMgr.BattleChar 获取战斗相关数据（包含 Attribute）
    local BattleCharData = DataMgr.BattleChar[CharId]
    if not BattleCharData then
        return nil
    end
    
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    -- 使用RuleId作为Uuid（试用角色没有真实的Uuid）
    Obj.Uuid = RuleId
    Obj.Type = CommonConst.ArmoryType.Char
    Obj.Tag = CommonConst.ArmoryTag.Char
    Obj.UnitId = RuleId
    Obj.CharId = CharId
    Obj.UnitName = CharData.CharName or BattleCharData.CharName
    Obj.Rarity = CharData.CharRarity or BattleCharData.Rarity
    Obj.Icon = CharData.Icon  -- 从 DataMgr.Char 获取
    Obj.GachaIcon = CharData.GachaIcon  -- 从 DataMgr.Char 获取
    Obj.Level = Template.CharLevel or 1
    Obj.GradeLevel = 0  -- 试用角色没有GradeLevel
    Obj.IsTryout = true  -- 标记为试用（用于UI显示）
    Obj.SquadBuildTryOutText = GText("UI_Wuyousheng_ArmoryTrial")
    Obj.bIsHoverState = true
    Obj.ConfirmDesc = "UI_CTL_Add/Remove"
    Obj.Attribute = BattleCharData.Attribute
    
    local Element = BattleCharData.Attribute
    if Element then
        local IconName = "Armory_" .. Element
        Obj.AttrIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName
    end
    Obj.SortPriority = CharData.SortPriority or 0
    return Obj
end

-- 从模板创建试用武器Content
function Component:NewTrialWeaponContent(RuleId, WeaponTag)
    if not RuleId or not DataMgr.WeaponTemplate[RuleId] then
        return nil
    end
    
    local Template = DataMgr.WeaponTemplate[RuleId]
    local WeaponId = Template.WeaponId
    if not WeaponId then
        return nil
    end
    
    -- 从 DataMgr.Weapon 获取武器数据（包含 Icon 和 GachaIcon）
    local WeaponData = DataMgr.Weapon[WeaponId]
    if not WeaponData then
        return nil
    end
    
    -- 从 DataMgr.BattleWeapon 获取战斗相关数据（包含 Attribute）
    local BattleWeaponData = DataMgr.BattleWeapon[WeaponId]
    if not BattleWeaponData then
        return nil
    end
    
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    -- 使用RuleId作为Uuid（试用武器没有真实的Uuid）
    Obj.Uuid = RuleId
    Obj.Type = CommonConst.ArmoryType.Weapon
    Obj.Tag = WeaponTag
    Obj.UnitId = RuleId
    Obj.UnitName = WeaponData.WeaponName or BattleWeaponData.Name
    Obj.Rarity = WeaponData.WeaponRarity or BattleWeaponData.Rarity
    Obj.Icon = WeaponData.Icon  -- 从 DataMgr.Weapon 获取
    Obj.GachaIcon = WeaponData.GachaIcon  -- 从 DataMgr.Weapon 获取
    Obj.Level = Template.WeaponLevel or 1
    Obj.GradeLevel = 0  -- 试用武器没有GradeLevel
    Obj.WeaponId = WeaponId
    Obj.IsTryout = true  -- 标记为试用（用于UI显示）
    Obj.SquadBuildTryOutText = GText("UI_Wuyousheng_ArmoryTrial")
    Obj.bIsHoverState = true
    Obj.ConfirmDesc = "UI_CTL_Add/Remove"
    Obj.ItemId = WeaponId
    
    local Element = BattleWeaponData.Attribute
    if Element then
        local IconName = "Armory_" .. Element
        Obj.AttrIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName
    end
    Obj.SortPriority = WeaponData.SortPriority or 0
    return Obj
end

-- 从模板创建试用宠物Content
function Component:NewTrialPetContent(PetId)
    if not PetId or not DataMgr.Pet[PetId] then
        return nil
    end
    
    local PetData = DataMgr.Pet[PetId]
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    -- 使用PetId作为Uuid（试用宠物没有真实的UniqueId）
    Obj.Uuid = PetId
    Obj.Type = CommonConst.ArmoryType.Pet
    Obj.Tag = CommonConst.ArmoryType.Pet
    Obj.UnitId = PetId
    Obj.UnitName = PetData.Name
    Obj.Rarity = PetData.Rarity
    Obj.Icon = PetData.Icon
    Obj.Level = 1  -- 试用宠物默认等级为1
    Obj.BreakNum = 0  -- 试用宠物没有BreakNum
    Obj.IsTryout = true  -- 标记为试用（用于UI显示）
    Obj.SquadBuildTryOutText = GText("UI_Wuyousheng_ArmoryTrial")
    Obj.bIsHoverState = true
    Obj.ConfirmDesc = "UI_CTL_Add/Remove"
    Obj.SortPriority = PetData.SortPriority or 0
    return Obj
end

-- 调用函数名（用于调用MainComponent的方法）
function Component:CallFunctionByName(FunctionName, ...)
    if self[FunctionName] then
        return self[FunctionName](self, ...)
    end
end

-- 获取当前内容（通过CurrentUuid查找）
function Component:GetCurrentContent()
    return self:GetCurrentContentForSort()
end

-- 判断是否是角色类型
function Component:IsChar()
    return self.CurSlotType == CommonConst.ArmoryType.Char
end

-- 判断列表是否允许刷新
function Component:IsListAllowRefresh()
    if self.bAllowRefreshList ~= nil then
        return self.bAllowRefreshList
    end
    return true
end

-- 设置列表是否允许刷新
function Component:SetListAllowRefresh(bAllow)
    self.bAllowRefreshList = bAllow
end

-- 获取当前阵容数据
-- @return table 阵容数据表
function Component:GetTeamTable()
    local TeamTable = {
        Char = NullUUid,
        MeleeWeapon = NullUUid,
        RangedWeapon = NullUUid,
        Phantom1 = NullUUid,
        PhantomWeapon1 = NullUUid,
        Phantom2 = NullUUid,
        PhantomWeapon2 = NullUUid,
        Pet = NullUnitId,
    }
    
    for SlotName, SlotWidget in pairs(self.Slots) do
        if SlotName ~= Component.ESlotName.Null and SlotWidget then
            local Uuid = SlotWidget.Uuid
            if Uuid then
                TeamTable[SlotName] = Uuid
            end
        end
    end
    
    return TeamTable
end

-- 更新团队图标（参考WBP_Abyss_Lineup_C的逻辑）
function Component:UpdateTeamIcons()
    for SlotName, SlotWidget in pairs(self.Slots) do
        if SlotWidget and SlotWidget.Uuid and not SlotWidget.IsEmpty then
            local Type = Component.SlotName2Type[SlotName]
            local IsPhantomWeapon = false
            if Type == "Weapon" then
                Type = SlotWidget.WeaponType or "Melee"
                if Type ~= self.CurSlotType then
                    goto continue
                end
                IsPhantomWeapon = true
            elseif Type ~= self.CurSlotType then
                goto continue
            end
            
            if self[Type.."ItemContentsMap"] then
                local Content = self[Type.."ItemContentsMap"][SlotWidget.Uuid]
                if Content then
                    if IsPhantomWeapon then
                        -- 获取对应的魅影槽位
                        local PhantomSlotName = SlotName - 1
                        local PhantomSlotWidget = self.Slots[PhantomSlotName]
                    end
                end
            end
            ::continue::
        end
    end
end

-- 清空所有槽位
function Component:ClearAllSlots()
    if not self.Slots then
        return
    end
    
    -- 先取消所有已装备Content的选中状态
    for SlotName, SlotWidget in pairs(self.Slots) do
        if SlotWidget and SlotWidget.Content then
            self:SetContentIsChosen(SlotWidget.Content, false)
        end
    end
    
    -- 然后清空所有槽位
    for SlotName, SlotWidget in pairs(self.Slots) do
        if SlotWidget and SlotWidget.Clear then
            SlotWidget:Clear()
        end
    end
    
    -- 清除各个MainComponent的CurrentUuid（CurContent不再需要维护）
    self.CurrentCharUuid = nil
    self.CurrentPetUuid = nil
    local WeaponTags = {CommonConst.ArmoryTag.Melee, CommonConst.ArmoryTag.Ranged}
    for _, Tag in pairs(WeaponTags) do
        self["Current"..Tag.."Uuid"] = nil
    end
    
    -- 清空槽位后，更新角色冲突状态（应该没有冲突了）
    self:UpdateCharConflict()
    
    -- 更新角色模型显示（清空后应该隐藏所有角色）
    self:UpdateSquadModels()
end

-- 背景点击
function Component:OnBackgroundClicked()
    if self.bItemDetailsShowed then
        self:ShowItemDetails(false)
    end
end

-- 更新槽位
function Component:UpdateSlot(SlotName, Content)
    local SlotWidget = self.Slots[SlotName]
    if SlotWidget and SlotWidget.Update then
        SlotWidget:Update(Content)
        SlotWidget.Content = Content  -- 将Content存储到SlotWidget上
    end
    Content.IsChosen = true
    
    -- 如果是魅影武器槽位，设置对应的魅影角色图标
    if SlotName == Component.ESlotName.PhantomWeapon1 or SlotName == Component.ESlotName.PhantomWeapon2 then
        local PhantomSlotName = (SlotName == Component.ESlotName.PhantomWeapon1) and Component.ESlotName.Phantom1 or Component.ESlotName.Phantom2
        local PhantomSlotWidget = self.Slots[PhantomSlotName]
        local PhantomCharId = nil
        
        -- 获取对应魅影角色槽位的 CharId
        if PhantomSlotWidget and PhantomSlotWidget.Content and not PhantomSlotWidget.IsEmpty then
            PhantomCharId = PhantomSlotWidget.Content.UnitId
        end
        
        -- 设置 Content 的 WeaponMiniPhantomIconCharId
        if Content then
            Content.WeaponMiniPhantomIconCharId = PhantomCharId
            Content.bInGear = false
        end
    else
        if Content then
            Content.WeaponMiniPhantomIconCharId = nil
            Content.bInGear = true
        end
    end
    
    -- 如果更新的是角色相关槽位，更新角色模型显示
    local SlotType = Component.SlotName2Type[SlotName]
    if SlotType == "Char" then
        self:UpdateSquadModels()
    end
end

-- 获取当前槽位的Uuid
function Component:GetCurrentUuid(SlotName)
    local SlotWidget = self.Slots[SlotName]
    if SlotWidget then
        return SlotWidget.Uuid
    end
    return nil
end

-- 获取槽位的武器类型
function Component:GetWeaponType(SlotName)
    local SlotWidget = self.Slots[SlotName]
    if SlotWidget then
        return SlotWidget.WeaponType or "Melee"
    end
    return "Melee"
end

-- 清空槽位
function Component:ClearSlot(SlotName)
    local SlotWidget = self.Slots[SlotName]
    if SlotWidget and SlotWidget.Clear then
        local SlotType = Component.SlotName2Type[SlotName]
        SlotWidget:Clear()
        
        -- 如果清空的是角色槽位，更新冲突状态和角色模型显示
        if SlotType == "Char" then
            self:UpdateCharConflict()
            self:UpdateSquadModels()
        end
    end
end

-- 打开确认弹窗的一系列逻辑
function Component:OpenTips(Content)
    self.CurClickItemInfo = Content
    self.Pos_Tips:ClearChildren()

    self.SquadItemTip = self:CreateWidgetNew("ComSquadItemTips")
    self.Pos_Tips:AddChild(self.SquadItemTip)
    self.IsTipsOpen = true
    self.Panel_Tips:SetVisibility(ESlateVisibility.Visible)
    self:PlayAnimation(self.Tips_In)
    -- todo InitBottomTab
    -- if self.CurClickItemInfo.Type ~= "Pet" then
    --     self:InitBottomTab(true, 2, GText("PROLOGUE_SELECTGUN_TIP_4"))
    -- else
    --     self:InitBottomTab(true, 1)
    -- end

    self.SquadItemTip:SetVisibility(ESlateVisibility.Visible)
    local Params = {
        ItemInfo = self.CurClickItemInfo,
        Owner = self,
        MakeSureCallback = self.MakeSureCallback,
        GoToArmory = self.GoToArmory
    }
    --初始化物品窗
    self.SquadItemTip:InitWidget(Params)

    self:SetCurFocusArea("Tip")
    self:ChangeFocusMode(7)
end

function Component:CloseTips()
    if self.Pos_Tips:GetChildAt(0) then
        self.IsTipsOpen = false
        -- todo InitBottomTab
        -- self:InitBottomTab(false, 2)
        -- todo 之后要接动效，现在直接隐藏
        -- self:UnbindFromAnimationFinished(self.Tips_Out, {self, function()
        --     self.Panel_Tips:SetVisibility(ESlateVisibility.Collapsed)
        -- end})
        -- self:BindToAnimationFinished(self.Tips_Out, {self, function()
        --     self.Panel_Tips:SetVisibility(ESlateVisibility.Collapsed)
        -- end})
        self.Panel_Tips:SetVisibility(ESlateVisibility.Collapsed)
        self:PlayAnimation(self.Tips_Out)
        self.SquadItemTip:CloseWidget()
        self.Pos_Tips:ClearChildren()
    end
end

--设置当前手柄聚焦的区域，不允许直接调用 区域目前分为 SquadList SquadListInSort SlotInEdit SlotInView ListItem Tip
function Component:SetCurFocusArea(CurFocusArea)
    self.CurGamepadArea = CurFocusArea
    DebugPrint("jly   SetCurFocusArea", self.CurGamepadArea)
end

--物品栏弹窗点击确定回调
function Component:MakeSureCallback(ModIndex)
    if not self.CurClickItemInfo then
        self:CloseTips(true)
        return
    end
    
    -- 装备物品，带上 ModIndex，需要显示 ModIndex 信息
    self:EquipItemToSlot(self.CurClickItemInfo, ModIndex, true)
    
    self:CloseTips(true)
end

--前往军械库对应类型界面
function Component:GoToArmory()
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_confirm", nil, nil)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    local bInSkillAndSafeToCancel = Player:CharacterInTag('Skill') and Player:IsSafeToCancelSkill()
    if Player:CanEnterInteractive()
        and (Player:CharacterInTag('Interactive') or Player:CharacterInTag('Idle') or bInSkillAndSafeToCancel)
        and Player.PlayerAnimInstance
        and ((Player.PlayerAnimInstance.IdletagName == "0" or Player.PlayerAnimInstance.IdletagName == "EmoIdle")) 
        and (not (self.IsFromDungeonPage and UIManager(self):GetArmoryUIObj())) then
        if bInSkillAndSafeToCancel then 
            Player:StopSkill(UE.ESkillStopReason.ArmoryCancel) 
        end 
    else
        UIManager(self):ShowUITip("CommonToastMain", GText("UI_Toast_Armory_Forbid"))
        return
    end

    local Params = {}
    if self.CurClickItemInfo then
        Params = {bNoEndCamera = true,
                    bHideSquadBuildBtn = true,
                    bHideBoxBtn = true,
                    bHideDeployBtn = true,
                    OnCloseDelegate = {self,function()
                        -- 从军械库返回时，更新角色模型显示状态
                        -- 如果角色槽位有角色则显示模型，否则隐藏模型
                        self:UpdateSquadModels()
                    end}}
    else
        Params = {bNoEndCamera = true,
                    bHideSquadBuildBtn = true,
                    bHideBoxBtn = true,
                    bHideDeployBtn = true,
                    MainTabName = ArmoryUtils.ArmoryMainTabNames.BattleWheel,
                    BattleWheelIndex  = self.Roulette.Id
                }
    end

    --1角色 2近战 3远程 4同律武器 5宠物 6轮盘
    if self.CurSlotType == "Char" then--角色
        Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.Char
        Params.CharUuids = {self.CurClickItemInfo.Uuid,}
        Params.bHideMeleeTab = true
        Params.bHideRangedTab = true
        Params.bHideWeaponTab = true
        Params.bHidePetTab = true
        Params.bHideBattleWheel = true
        Params.bHideUltraTab = true
    elseif self.CurSlotType == "Melee" then--近战武器
        Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.Melee
        Params.WeaponUuids = {self.CurClickItemInfo.Uuid,}
        Params.bHideCharTab = true
        Params.bHideRangedTab = true
        Params.bHideWeaponTab = true
        Params.bHidePetTab = true
        Params.bHideBattleWheel = true
        Params.bHideUltraTab = true
    elseif self.CurSlotType == "Ranged" then--远程武器
        Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.Ranged
        Params.WeaponUuids = {self.CurClickItemInfo.Uuid,}
        Params.bHideMeleeTab = true
        Params.bHideCharTab = true
        Params.bHideWeaponTab = true
        Params.bHidePetTab = true
        Params.bHideBattleWheel = true
        Params.bHideUltraTab = true
    elseif self.CurSlotType == "Pet" then--宠物
        Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.Pet
        Params.PetUniqueIds = {self.CurClickItemInfo.Uuid,}
        Params.bHideCharTab = true
        Params.bHideMeleeTab = true
        Params.bHideRangedTab = true
        Params.bHideWeaponTab = true
        Params.bHideBattleWheel = true
        Params.bHideUltraTab = true
    else--轮盘
        Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.BattleWheel
        Params.bHideCharTab = true
        Params.bHideMeleeTab = true
        Params.bHideRangedTab = true
        Params.bHideWeaponTab = true
        Params.bHidePetTab = true
        Params.bHideUltraTab = true
    end
    --关闭物品信息弹窗
    self:CloseTips()
    --打开军械库面板
    UIManager(self):LoadUINew("ArmoryDetail",Params)
end

-- 检查表中是否包含指定值
local function TableContains(Table, Value)
    if type(Table) ~= "table" then
        return Table == Value
    end
    for _, V in pairs(Table) do
        if V == Value then
            return true
        end
    end
    return false
end

-- 输入WeaponId的表，返回一个近战武器和远程武器的两个表,处理了试用武器的情况
function Component:GetWeaponTypeList(WeaponIdList)
    local MeleeWeaponList = {}
    local RangedWeaponList = {}
    for _, WeaponId in pairs(WeaponIdList) do
        local WeaponData = DataMgr.BattleWeapon[WeaponId]
        local TemplateWeaponData = DataMgr.WeaponTemplate[WeaponId]
        local WeaponType = nil
        if WeaponData then
            WeaponType = WeaponData.WeaponTag
        elseif TemplateWeaponData then
            WeaponData = DataMgr.BattleWeapon[TemplateWeaponData.WeaponId]
            if WeaponData then
                WeaponType = WeaponData.WeaponTag
            end
        end
        if WeaponType then
            if TableContains(WeaponType, "Melee") then
                MeleeWeaponList[#MeleeWeaponList + 1] = WeaponId
            end
            if TableContains(WeaponType, "Ranged") then
                RangedWeaponList[#RangedWeaponList + 1] = WeaponId
            end
        end
    end
    return MeleeWeaponList, RangedWeaponList
end

-- 更新阵容角色模型显示（只显示主角）
function Component:UpdateSquadModels()
    -- 检查是否有Owner和ActorController
    if not self.Owner or not self.Owner.ActorController then
        return
    end
    
    local ActorController = self.Owner.ActorController
    if not ActorController.ChangeCharModel then
        return
    end
    
    -- 获取主角信息（Char槽位）
    local CharSlotWidget = self.Slots[Component.ESlotName.Char]
    if CharSlotWidget and CharSlotWidget.Content and CharSlotWidget.Content.Uuid then
        local Content = CharSlotWidget.Content
        local Avatar = GWorld:GetAvatar()
        local Char = Avatar and Avatar.Chars[Content.Uuid]
        
        local CharId = Char and Char.CharId or Content.CharId
        if CharId then
            local ProtagonistInfo = {
                CharId = CharId,
                Uuid = Content.Uuid
            }
            -- 调用ActorController的ChangeCharModel方法显示主角
            ActorController:ChangeCharModel(ProtagonistInfo, false, false, false, true)
            self.Owner.ActorController:HidePlayerActor("SuqadRole", false)

            -- 切换主角时，播放一次军械库默认待机动作和镜头
            self.Owner.ActorController:FixedCameraTransTimeOnce(0)
            self.Owner.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char, nil, nil)
        end
    else
        self.Owner.ActorController:HidePlayerActor("SuqadRole", true)
    end
end


-- 阵容相关的工具函数
--[[
获取当前阵容数据（按照服务器格式）

Squad 顶层结构：
- 类型：table，key 为槽位名字符串，value 为该槽位的 SlotInfo（仅非空槽位会有 key）
- 可能的 key（槽位名）："Char" | "MeleeWeapon" | "RangedWeapon" | "Phantom1" | "PhantomWeapon1" | "Phantom2" | "PhantomWeapon2" | "Pet"

SlotInfo（每个槽位的数据）字段：
- Id      (number|string) 必填  试用时为 UnitId(number)，非试用时为 Uuid(string)
- bTrial  (boolean)       必填  是否试用
- ModIndex(number)        可选  非试用且 Content 有 ModSuitIndex 时存在

示例：
  {
      ["Char"]           = { Id = "uuid-xxx", bTrial = false, ModIndex = 1 },
      ["MeleeWeapon"]    = { Id = "uuid-yyy", bTrial = false },
      ["RangedWeapon"]   = { Id = 12345,     bTrial = true },
      ["Phantom1"]       = { Id = "uuid-zzz", bTrial = false, ModIndex = 2 },
      ["PhantomWeapon1"] = { Id = "uuid-www", bTrial = false },
      ["Phantom2"]       = { Id = 67890,     bTrial = true },
      ["PhantomWeapon2"] = { Id = "uuid-vvv", bTrial = false },
      ["Pet"]            = { Id = "uuid-pet", bTrial = false },
  }
]]
function Component:GetCurrentSquad()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return nil
    end
    
    -- 按照服务器格式构建阵容数据
    local Squad = {}
    
    -- ESlotName枚举值到SlotName字符串的映射
    local ENameToSlotName = {}
    for SlotName, EName in pairs(self.ESlotName) do
        if type(EName) == "number" then
            ENameToSlotName[EName] = SlotName
        end
    end
    
    -- 遍历所有槽位
    if self.Slots then
        for EName, Slot in pairs(self.Slots) do
            -- 跳过空槽位
            if not Slot or Slot.IsEmpty then
                goto continue
            end
            
            local SlotName = ENameToSlotName[EName]
            if not SlotName then
                goto continue
            end
            
            local SlotInfo = {}
            local IsTryout = Slot.IsTryout or false
            
            if IsTryout then
                -- 试用物品，使用UnitId
                SlotInfo.Id = Slot.UnitId
                SlotInfo.bTrial = true
            else
                -- 玩家自己的物品，使用Uuid
                if not Slot.Uuid then
                    goto continue
                end
                SlotInfo.Id = Slot.Uuid
                SlotInfo.bTrial = false
                
                -- 从Slot选择的Content中获取ModIndex
                if Slot.Content and Slot.Content.ModSuitIndex then
                    SlotInfo.ModIndex = Slot.Content.ModSuitIndex
                end
            end
            
            Squad[SlotName] = SlotInfo
            
            ::continue::
        end
    end
    
    return Squad
end

-- 深度比较两个table是否相等（忽略键的顺序）
function Component:DeepEqualTable(t1, t2, visited)
    visited = visited or {}
    
    -- 如果两个引用相同，直接返回true
    if t1 == t2 then
        return true
    end
    
    -- 检查基本类型
    local type1 = type(t1)
    local type2 = type(t2)
    if type1 ~= type2 then
        return false
    end
    
    if type1 ~= "table" then
        return t1 == t2
    end
    
    -- 防止循环引用：使用组合键来标记已访问的table对
    local key1 = tostring(t1)
    local key2 = tostring(t2)
    local visitKey = key1 .. "|" .. key2
    if visited[visitKey] then
        return true
    end
    visited[visitKey] = true
    
    -- 统计两个table的键数量
    local count1 = 0
    local count2 = 0
    for _ in pairs(t1) do
        count1 = count1 + 1
    end
    for _ in pairs(t2) do
        count2 = count2 + 1
    end
    
    -- 键数量不同，肯定不相等
    if count1 ~= count2 then
        return false
    end
    
    -- 遍历t1的所有键值对，检查t2中是否有对应的值
    for k, v1 in pairs(t1) do
        local v2 = t2[k]
        if v2 == nil then
            return false
        end
        
        -- 递归比较值
        if type(v1) == "table" and type(v2) == "table" then
            if not self:DeepEqualTable(v1, v2, visited) then
                return false
            end
        else
            if v1 ~= v2 then
                return false
            end
        end
    end
    
    return true
end

-- 检查Squad是否为空（所有成员都是空的）
function Component:IsSquadEmpty(Squad)
    if not Squad then
        return true
    end
    
    -- 新格式：直接检查Squad表是否为空
    for _ in pairs(Squad) do
        return false
    end
    
    return true
end

-- 比较两个Squad是否相等（忽略键的顺序）
function Component:IsSquadEqual(Squad1, Squad2)
    -- 如果两个都是 nil，相等
    if not Squad1 and not Squad2 then
        return true
    end
    
    -- 如果一个是 nil，另一个是空 Squad，也认为相等
    if not Squad1 then
        return self:IsSquadEmpty(Squad2)
    end
    
    if not Squad2 then
        return self:IsSquadEmpty(Squad1)
    end
    
    -- 使用深度比较
    return self:DeepEqualTable(Squad1, Squad2)
end

-- 获取角色名称
function Component:GetCharName(CharId)
    return DataMgr.Char[CharId] and DataMgr.Char[CharId].CharName
end

-- 获取武器名称
function Component:GetWeaponName(WeaponId)
    return DataMgr.Weapon[WeaponId] and DataMgr.Weapon[WeaponId].WeaponName
end

-- 根据槽位类型和Content显示交换提示
function Component:PopChangeRoleToastByType(Content, SlotName)
    if not Content or not SlotName then
        return
    end
    
    local SlotType = self.SlotName2Type[SlotName]
    if not SlotType then
        return
    end
    
    -- 判断是否是魅影角色槽位
    local IsPhantom = (SlotName == self.ESlotName.Phantom1) or (SlotName == self.ESlotName.Phantom2)
    local PhantomNum = nil
    if SlotName == self.ESlotName.Phantom1 then
        PhantomNum = 1
    elseif SlotName == self.ESlotName.Phantom2 then
        PhantomNum = 2
    end
    
    -- 判断是否是魅影武器槽位
    local IsPhantomWeapon = (SlotName == self.ESlotName.PhantomWeapon1) or (SlotName == self.ESlotName.PhantomWeapon2)
    local PhantomWeaponNum = nil
    if SlotName == self.ESlotName.PhantomWeapon1 then
        PhantomWeaponNum = 1
    elseif SlotName == self.ESlotName.PhantomWeapon2 then
        PhantomWeaponNum = 2
    end
    
    -- 根据槽位类型显示不同的提示
    if SlotName == self.ESlotName.Char then
        -- 主角色槽位
        local CharName = self:GetCharName(Content.UnitId)
        if CharName then
            UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Squad_SwitchChar_Toast"), GText(CharName)))
        end
    elseif IsPhantom then
        -- 魅影角色槽位
        local CharName = self:GetCharName(Content.UnitId)
        if CharName and PhantomNum then
            UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Squad_SwitchSigil_Toast"), GText(CharName), GText("UI_Squad_Sigil"..PhantomNum)))
        end
    elseif IsPhantomWeapon then
        -- 魅影武器槽位
        local WeaponName = self:GetWeaponName(Content.UnitId)
        if WeaponName and PhantomWeaponNum then
            UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Squad_SwitchSigil_Toast"), GText(WeaponName), GText("UI_Squad_Sigil"..PhantomWeaponNum)))
        end
    elseif SlotName == self.ESlotName.MeleeWeapon or SlotName == self.ESlotName.RangedWeapon then
        -- 主武器槽位
        local WeaponName = self:GetWeaponName(Content.UnitId)
        if WeaponName then
            UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Squad_SwitchChar_Toast"), GText(WeaponName)))
        end
    end
end


return Component


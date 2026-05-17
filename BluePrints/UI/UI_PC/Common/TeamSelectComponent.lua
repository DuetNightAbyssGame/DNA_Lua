require "UnLua"

---@class TeamSelectComponent
-- 阵容选择Component，用于管理角色、武器、宠物等槽位的选择和配置
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
-- @param List_Select 列表视图（EMListView类型）
-- @param Sort 排序组件
-- @param EMListView_Filter 筛选列表视图
-- @param ItemDetailWidget 物品详情Widget（可选）
-- @param Pos_Tip 物品详情Widget的父容器（可选，用于AttachTipsWidget）
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
function Component:InitTeamSelect(Slots, List_Select, Sort, EMListView_Filter, ItemDetailWidget, Pos_Tip, TrialData)
    -- 槽位Widget映射
    self.Slots = Slots or {}
    
    -- 列表组件
    self.List_Select = List_Select
    self.Sort = Sort
    self.EMListView_Filter = EMListView_Filter
    
    -- 物品详情
    self.ItemDetailWidget = ItemDetailWidget
    self.Pos_Tip = Pos_Tip
    
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
    
    -- 当前选中的槽位
    self.CurSlotName = Component.ESlotName.Null
    self.CurSlotType = ""
    self.CurWeaponType = "Melee"
    
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
function Component:OnSlotClicked(SlotName)
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
    if self.UpdateListSelect then
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
function Component:CharMain_Init()
    if not self.CharItemContentsMap then
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
            Obj = self:NewItemContent(Char, CommonConst.ArmoryType.Char, CommonConst.ArmoryTag.Char)
            self.CharItemContentsMap[Uuid] = Obj
            self.BP_CharItemContents:Add(Obj)
            table.insert(self.CharItemContentsArray, Obj)
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
function Component:PetMain_Init()
    if not self.PetItemContentsArray then
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
                Obj = self:NewPetItemContent(Pet)
                self.PetItemContentsMap[UniqueId] = Obj
                self.BP_PetItemContents:Add(Obj)
                table.insert(self.PetItemContentsArray, Obj)
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

function Component:MeleeMain_Init()
    self.WeaponTag = CommonConst.ArmoryTag.Melee
    self:WeaponMain_Init()
end

function Component:RangedMain_Init()
    self.WeaponTag = CommonConst.ArmoryTag.Ranged
    self:WeaponMain_Init()
end

function Component:WeaponMain_Init()
    self.CurrentWeaponUuidName = "Current" .. self.WeaponTag .. "Uuid"
    if not self[self.WeaponTag.."ItemContentsMap"] then
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
                Obj = self:NewItemContent(Weapon, CommonConst.ArmoryType.Weapon, self.WeaponTag)
                self["BP_"..self.WeaponTag.."ItemContents"]:Add(Obj)
                table.insert(ItemContentsArray, Obj)
                ItemContentsMap[Uuid] = Obj
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
            self.EMListView_Filter:AddItem(FilterContentObj_All)
            self.FilterContentObj_All = FilterContentObj_All
            
            -- 添加筛选选项
            for Index, FilterTag in ipairs(Filters) do
                local Obj = NewObject(UIUtils.GetCommonItemContentClass())
                for key, value in pairs(FilterTag) do
                    Obj[key] = value
                end
                Obj.Index = Index
                self.EMListView_Filter:AddItem(Obj)
            end
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
        DebugPrint("TeamSelectComponent:PhantomWeaponTypeChanged:传入武器类型无效,", Type)
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
    
    -- 获取当前槽位Widget
    local CurSlotWidget = self.Slots[self.CurSlotName]
    if not CurSlotWidget then
        return
    end

    if Content.IsConflict then
        UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_Wuyousheng_Toast_OnlyOneChar"))
        return
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
    
    -- 如果点击的是当前槽位已装备的物品，则取消装备
    if Content.bSelectTag and CurContent and Content.Uuid == CurContent.Uuid then
        self:ClearSlot(self.CurSlotName)
        self:SetContentIsChosen(Content, false)
        -- 更新对应的CurrentUuid
        self:UpdateCurrentUuid(Type, nil)
        
        -- 如果取消装备的是角色，检查并更新冲突状态
        if Type == "Char" then
            self:UpdateCharConflict()
        end
        
        if self.OnLeftItemContentChanged then
            self:OnLeftItemContentChanged()
        end
        return
    end
    
    -- 如果点击的是其他槽位已装备的物品，则交换槽位
    if Content.bSelectTag then
        local OtherSlotInfo = self.Uuid2SlotMap[Content.Uuid]
        if OtherSlotInfo and self.Slots[OtherSlotInfo.SlotName] then
            local OtherSlotWidget = self.Slots[OtherSlotInfo.SlotName]
            -- 先手动清除两个槽位（交换场景）
            if CurContent then
                self:SetContentIsChosen(CurContent, false)
            end
            if OtherSlotWidget then
                self:SetContentIsChosen(Content, false)
            end
            -- 将当前槽位的物品装备到其他槽位
            if CurContent then
                self:UpdateSlot(OtherSlotInfo.SlotName, CurContent)
                self:SetContentIsChosen(CurContent, true)
            -- 如果当前槽位没有物品，则清空其他槽位
            else
                self:ClearSlot(OtherSlotInfo.SlotName)
                -- 如果取消装备的是角色，检查并更新冲突状态
                local OtherSlotType = Component.SlotName2Type[OtherSlotInfo.SlotName]
                self:UpdateCurrentUuid(OtherSlotType, nil)
                if OtherSlotType == "Char" then
                    self:UpdateCharConflict()
                end
                
                if self.OnLeftItemContentChanged then
                    self:OnLeftItemContentChanged()
                end
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
            
            if Content.bSelectTag then
                IsConflict = false
            end
            Content.IsConflict = IsConflict
            
            -- 如果 Content 有 UI，更新 UI 状态
            if Content.UI and Content.UI.SetConflict then
                Content.UI:SetConflict()
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
    
    Content.bSelectTag = IsChosen
    if Content.SelfWidget then
        Content.SelfWidget:SetItemSelect(IsChosen)
        self:PlaySelectSound(IsChosen, Content.Type)
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
        Content.bSelectTag = true
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
        
        -- 如果清空的是角色槽位，更新冲突状态
        if SlotType == "Char" then
            self:UpdateCharConflict()
        end
    end
end

---显隐详情
function Component:ShowItemDetails(bShow, Content)
    if(bShow)then
        if self.bListEmpty then
            return
        end
        if Content.Type == "Char" then
            return
        end
        if(self.ItemDetailsContent ~= Content)then
            self.ItemDetailsWidget:RefreshItemInfo(Content, true)
        end
        self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.ItemDetailsWidget:StopAnimation(self.ItemDetailsWidget.Out)
        self.ItemDetailsWidget:PlayAnimation(self.ItemDetailsWidget.In)
        self.bItemDetailsShowed = true
    elseif self.ItemDetailsWidget then
        self.bItemDetailsShowed = false
        self.ItemDetailsWidget:StopAnimation(self.ItemDetailsWidget.In)
        self.ItemDetailsWidget:PlayAnimation(self.ItemDetailsWidget.Out)
        -- self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.ItemDetailsContent = Content
end

function Component:InitItemDetailWidget()
    if self.ItemDetailsWidget then
        self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.ItemDetailsWidget:DestroyObject()
    end
    self.ItemDetailsWidget = UIManager(self):_CreateWidgetNew("ItemDetailsMain")
    self:AttachTipsWidget(self.ItemDetailsWidget)
    self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.ItemDetailsWidget.Key_Confirm:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "A",
            }
        },
        Desc = GText("UI_CTL_Add/Remove")
    })
    self.ItemDetailsWidget.Key_Confirm:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.ItemDetailsWidget.Key_Back:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.ItemDetailsWidget.bIsFocusable = false
    self.bItemDetailsShowed = false
    self.ItemDetailsContent = nil
end

return Component


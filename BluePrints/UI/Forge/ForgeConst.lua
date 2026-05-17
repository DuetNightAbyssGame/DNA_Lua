--- @class ForgeConst
local ForgeConst = {}
local ForgeSTabData = DataMgr.ForgeSTab

ForgeConst.DefaultForgeTargetMaxNum = 5

--- @param TabType table
ForgeConst.TabType = {
    All = 'All',
    Producing = 'Forging',
    ToBeProduced = 'Ready',
    Weapon = 'Weapon',
    Mod = 'Mod',
    Resource = 'Resource',
    CharAccessory = 'CharAccessory',
}

ForgeConst.SubTabType = {}
for Index, STabData in pairs(ForgeSTabData) do
    ForgeConst.SubTabType[STabData.ProductType] = STabData.Id
end

ForgeConst.TabType2SubTabType = {}
for Index, STabData in pairs(ForgeSTabData) do
    local TabData = DataMgr.ForgeTab[STabData.TabId]
    if TabData then 
        local TabType = TabData.ProductType
        if TabType then 
            ForgeConst.TabType2SubTabType[TabType] = ForgeConst.TabType2SubTabType[TabType] or {}
            table.insert(ForgeConst.TabType2SubTabType[TabType], STabData.Id)
        end
    end
end

for _, Data in pairs(ForgeConst.TabType2SubTabType) do 
    table.sort(Data, function(a, b) return ForgeSTabData[a].Sequence > ForgeSTabData[b].Sequence end)
end

ForgeConst.SubTabTitleName = {}
for Index, STabData in pairs(ForgeSTabData) do 
    ForgeConst.SubTabTitleName[STabData.Id] = STabData.TabName
end

--- @param ProductType table
ForgeConst.ProductType = {
    Weapon = 0,
    Mod = 1,
    Other = 2
}

--- @param DraftState table 
ForgeConst.DraftState = {
    NotStarted = 0,
    InProgress = 1,
    Complete = 2,
}

--- @param PathItemDraftState table 
ForgeConst.PathItemDraftState = {
    CanProduce = 0,
    Producing = 1,
    ConditionsNotMet = 2,
    CantProduce = 3,
}

ForgeConst.BottomKeyTypes = {
    BottomKey_Back = 0,             -- 返回
    BottomKey_Confirm = 1,          -- 确定
    BottomKey_SetTarget = 2,        -- 设置目标
    BottomKey_UnSetTarget = 3,      -- 取消设为目标
    BottomKey_ShowItem = 4,         -- 显示物品
    BottomKey_ShowDetails = 5,      -- 显示详情 
    BottomKey_Keyboard_Esc = 6,     -- 键盘退出
    BottomKey_Keyboard_Space = 7,   -- 键盘全部领取
}

ForgeConst.ControllerFSMStates = {
    NormalPage_NoFocus = 0,         -- 页面中无条目可聚焦
    NormalPage_FocusItem = 1,       -- 聚焦一个页面中的铸造条目
    NormalPage_ShowItem = 2,        -- 显示一个铸造条目的物品
    NormalPage_FocusSort = 3,       -- 聚焦通用排序控件
    PathPage_Normal = 4,            -- 铸造合成树主页面
    NormalPage_FocusCompendium = 5, -- 聚焦铸造图鉴入口
}

-- 铸造图鉴的Tab类型，对应ForgeTab.lua表中的Id
ForgeConst.CompendiumTabType = {
    1,  -- 全部
    4,  -- 武器
    5,  -- Mod
    6,  -- 资源
    7   -- 饰品
}

-- 产物类型与TabId的映射关系，对应ForgeTab.lua表中的Id
ForgeConst.ProductTypeToTabId = {
    ["All"] = 1,
    ["Weapon"] = 4,
    ["Mod"] = 5,
    ["Resource"] = 6,
    ["CharAccessory"] = 7,
}

ForgeConst.NewdotNodeName = {
    ["Root"] = "ForgeNewdotRoot",
    [ForgeConst.TabType.All] = "ForgeNewdot_All",
    [ForgeConst.TabType.Producing] = "ForgeNewdot_Producing",
    [ForgeConst.TabType.ToBeProduced] = "ForgeNewdot_ToBeProduced",
    [ForgeConst.TabType.Weapon] = "ForgeNewdot_Weapon",
    [ForgeConst.TabType.Mod] = "ForgeNewdot_Mod",
    [ForgeConst.TabType.Resource] = "ForgeNewdot_Resource",
    [ForgeConst.TabType.CharAccessory] = "ForgeNewdot_CharAccessory",
}

for _, STabData in pairs(ForgeSTabData) do
    ForgeConst.NewdotNodeName[STabData.Id] = "ForgeNewdot_" .. STabData.ProductType
end

ForgeConst.ReddotNodeName = {
    ["Root"] = "ForgeReddotRoot",
    [ForgeConst.TabType.All] = "ForgeReddot_All",
    [ForgeConst.TabType.Producing] = "ForgeReddot_Producing",
    [ForgeConst.TabType.ToBeProduced] = "ForgeReddot_ToBeProduced",
    [ForgeConst.TabType.Weapon] = "ForgeReddot_Weapon",
    [ForgeConst.TabType.Mod] = "ForgeReddot_Mod",
    [ForgeConst.TabType.Resource] = "ForgeReddot_Resource",
    [ForgeConst.TabType.CharAccessory] = "ForgeReddot_CharAccessory",
}

for _, STabData in pairs(ForgeSTabData) do
    ForgeConst.ReddotNodeName[STabData.Id] = "ForgeReddot_" .. STabData.ProductType
end



return ForgeConst
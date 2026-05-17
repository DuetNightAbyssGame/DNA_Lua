local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
---@type WBP_Abyss_Lineup_C
local Component = {}

function Component:Construct()
    --注册各种武器的同名函数
    self.WeaponMainFuncName = {
        "Main_OnListItemClicked",
        "Main_SelectListItem",
        "Main_Close",
    }
    self.WeaponTags = {CommonConst.ArmoryTag.Melee,CommonConst.ArmoryTag.Ranged}
    for _, Tag in pairs(self.WeaponTags) do
        for _, FuncName in pairs(self.WeaponMainFuncName) do
            self[Tag .. FuncName] = self["Weapon" .. FuncName]
        end
    end
end

function Component:WeaponMain_InitWidget()
    self.WeaponItemContentsMap = nil
    self.WeaponItemContentsArray = nil
    if self.BP_WeaponItemContents then
        self.BP_WeaponItemContents:Clear()
    end
    self.CurrentWeaponUuidName = nil
    self.CurContentName = nil
    if self.WeaponTags then
        for _, Tag in pairs(self.WeaponTags) do
            for _, FuncName in pairs(self.WeaponMainFuncName) do
                self[Tag.."ItemContentsMap"] = nil
                self[Tag.."ItemContentsArray"] = nil
                self["BP_"..Tag .."ItemContents"]:Clear()
                self[Tag .. "Main_CurContent"] = nil
                self["Current" .. Tag .. "Uuid"] = nil
            end
        end
    end
end

--近战武器初始化
function Component:MeleeMain_Init()
    self.WeaponTag = CommonConst.ArmoryTag.Melee
    self:WeaponMain_Init()
end

--远程武器初始化
function Component:RangedMain_Init()
    self.WeaponTag = CommonConst.ArmoryTag.Ranged
    self:WeaponMain_Init()
end

function Component:WeaponMain_Init()
    self.CurrentWeaponUuidName = "Current" .. self.WeaponTag .. "Uuid"
    if(not self[self.WeaponTag.."ItemContentsMap"])then
        self:WeaponMain_CreateItemContents()
    end
    if self.CurContentName then
    	self:SetContentIsChosen(self[self.CurContentName], false)
    end
    self:SwitchContentsArray()
    self:WeaponMain_InitListView()
end

---创建武器数据对象
function Component:WeaponMain_CreateItemContents()
    local Avatar = GWorld:GetAvatar()
    self[self.WeaponTag.."ItemContentsMap"] = {}
    self[self.WeaponTag.."ItemContentsArray"] = {}
    self["BP_"..self.WeaponTag .."ItemContents"]:Clear()
    local ItemContentsMap = self[self.WeaponTag.."ItemContentsMap"]
    local ItemContentsArray = self[self.WeaponTag.."ItemContentsArray"]
    local BP_ItemContents = self["BP_"..self.WeaponTag .."ItemContents"]
    local Obj = nil
    for Uuid,Weapon in pairs(Avatar.Weapons) do
        if(Weapon:HasTag(self.WeaponTag))then
            Obj = self:NewItemContent(Weapon,CommonConst.ArmoryType.Weapon,self.WeaponTag)
            BP_ItemContents:Add(Obj)
            table.insert(ItemContentsArray ,Obj)
            ItemContentsMap[Uuid] = Obj
        end
    end
end

function Component:SwitchContentsArray()
    self.WeaponItemContentsMap = self[self.WeaponTag.."ItemContentsMap"]
    self.WeaponItemContentsArray = self[self.WeaponTag.."ItemContentsArray"]
    self.BP_WeaponItemContents = self["BP_"..self.WeaponTag .."ItemContents"]
end

function Component:WeaponMain_InitListView()
    self:WeaponMain_InitContentState()
    ArmoryUtils:SortItemContents(self.WeaponItemContentsArray,{"Level","Rarity","SortPriority","UnitId"},CommonConst.DESC,self[self.CurContentName])
end

function Component:WeaponMain_InitContentState()
    self.CurContentName = self.WeaponTag .. "Main_CurContent"
    if(self[self.CurContentName])then
        self[self.CurContentName] = nil
    end
    if(self[self.CurrentWeaponUuidName])then
        self[self.CurContentName] = self.WeaponItemContentsMap[self[self.CurrentWeaponUuidName]]
        if self[self.CurContentName] then
            self[self.CurContentName].IsSelected = true
        end
    end
end

---武器列表点击时
function Component:WeaponMain_OnListItemClicked(Content)
    if(self[self.CurContentName] == Content)then
    	self[self.CurContentName] = nil
        return
    end
    self[self.CurrentWeaponUuidName] = Content.Uuid
    if(self.CurSlotType == self.WeaponTag)then
    	self:WeaponMain_SelectListItem(Content)
    end
end

---选中武器
function Component:WeaponMain_SelectListItem(Content)
	if Content then
        Content.TeamIdx = self.CurDungeonPanel.DungeonIndex
        if self.CurSlotName == self.ESlotName.PhantomWeapon1 or self.CurSlotName == self.ESlotName.PhantomWeapon2 then
            --设置魅影图标(self.CurSlotName-1对应的即是装备当前武器的魅影的槽位)
            local PhantomUuid = self.CurDungeonPanel:GetCurrentUuid(self.CurSlotName-1)
            Content.TeamCharId = self.CharItemContentsMap[PhantomUuid].UnitId
        else
            Content.TeamCharId = nil
        end
    end
    self:SetContentIsChosen(self[self.CurContentName], false)
    self:SetContentIsChosen(Content,true)
    self[self.CurContentName] = Content
    if self.CurDungeonPanel then
        --第一个参数传入nil, 更新配置面板当前被选中的槽位
        self.CurDungeonPanel:UpdateSlot(self.CurSlotName, Content)
    else
        DebugPrint("lhr@CharMain_SelectListItem：阵容面板失效或初始化失败")
    end
end

return Component
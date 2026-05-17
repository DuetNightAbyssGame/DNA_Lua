local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
---@type WBP_Abyss_Lineup_C
local Component = {}

function Component:PetMain_Init()
    if(not self.PetItemContentsArray)then
        self:PetMain_CreateItemContents()
    end
    self:SetContentIsChosen(self.PetMain_CurContent,false)

    self:PetMain_InitListView()
end

function Component:PetMain_InitWidget()
    self.PetItemContentsMap = nil
    self.PetItemContentsArray = nil
    self.BP_PetItemContents:Clear()
    self.CurrentPetUuid = nil
    self.PetMain_CurContent = nil
end

function Component:PetMain_InitListView()
    if(self.PetMain_CurContent)then
        self.PetMain_CurContent = nil
    end
    if(self.CurrentPetUuid) then
        self.PetMain_CurContent = self.PetItemContentsMap[self.CurrentPetUuid]
        self.PetMain_CurContent.IsSelected = true
    end
    ArmoryUtils:SortItemContents(self.PetItemContentsArray,{"Level","Rarity","SortPriority","UnitId"},CommonConst.DESC,self.PetMain_CurContent)
end

---创建宠物数据对象
function Component:PetMain_CreateItemContents()
    local Avatar = GWorld:GetAvatar()
    self.PetItemContentsMap = {}
    self.PetItemContentsArray = {}
    self.BP_PetItemContents:Clear()
    local Obj = nil
    for UniqueId,Pet in pairs(Avatar.Pets) do
        if self:CheckPetType(Pet.PetId) then
            Obj = self:NewPetItemContent(Pet)
            self.BP_PetItemContents:Add(Obj)
            self.PetItemContentsMap[UniqueId] = Obj
            table.insert(self.PetItemContentsArray ,Obj)
        end
    end
end

function Component:CheckPetType(PetId)
    return DataMgr.Pet[PetId].PetType == 1
end

---宠物列表点击时
function Component:PetMain_OnListItemClicked(Content)
    if(self.PetMain_CurContent == Content)then
        self.PetMain_CurContent = nil
        return
    end

    self.CurrentPetUuid = Content.Uuid
    if(self.CurSlotType == "Pet")then
        self:PetMain_SelectListItem(Content)
    end
end

---选中宠物
function Component:PetMain_SelectListItem(Content)
    if Content then
        Content.TeamIdx = self.CurDungeonPanel.DungeonIndex
    end
    self:SetContentIsChosen(self.PetMain_CurContent,false)
    self:SetContentIsChosen(Content,true)
    self.PetMain_CurContent = Content
    if self.CurDungeonPanel then
        --第一个参数传入nil, 更新配置面板当前被选中的槽位
        self.CurDungeonPanel:UpdateSlot(self.CurSlotName, Content)
    else
        DebugPrint("lhr@CharMain_SelectListItem：阵容面板失效或初始化失败")
    end
end

return Component

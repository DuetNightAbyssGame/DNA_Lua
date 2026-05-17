local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
---@type WBP_Abyss_Lineup_C
local Component = {}

function Component:CharMain_Init()
    if(not self.CharItemContentsMap)then
        self:CharMain_CreateItemContents()
    end
    self:SetContentIsChosen(self.CharMain_CurContent, false)
    self:CharMain_InitListView()
end

function Component:CharMain_InitWidget()
    self.CharItemContentsMap = nil
    self.CharItemContentsArray = nil
    self.BP_CharItemContents:Clear()
    self.CurrentCharUuid = nil
    self.CharMain_CurContent = nil
end

---创建角色数据对象
function Component:CharMain_CreateItemContents()
    local Avatar = GWorld:GetAvatar()
    self.CharItemContentsMap = {}
    self.CharItemContentsArray = {}
    self.BP_CharItemContents:Clear()
    local Obj = nil
    for Uuid,Char in pairs(Avatar.Chars) do
        Obj = self:NewItemContent(Char,CommonConst.ArmoryType.Char,CommonConst.ArmoryTag.Char)
        self.CharItemContentsMap[Uuid] = Obj
        self.BP_CharItemContents:Add(Obj)
        table.insert(self.CharItemContentsArray,Obj)
    end
end

function Component:CharMain_InitListView()
    self:CharMain_InitContentState()
    self:CharMain_SortItemContents()
end

function Component:CharMain_InitContentState()
    if(self.CharMain_CurContent)then
        self.CharMain_CurContent = nil
    end
    if(self.CurrentCharUuid)then
        self.CharMain_CurContent = self.CharItemContentsMap[self.CurrentCharUuid]
        self.CharMain_CurContent.IsSelected = true
    end
end

function Component:CharMain_SortItemContents()
    ArmoryUtils:SortItemContents(self.CharItemContentsArray,{"Level","Rarity","SortPriority","UnitId"},CommonConst.DESC,self.CharMain_CurContent)
end

function Component:CharMain_OnListItemClicked(Content)
    if(self.CharMain_CurContent == Content)then
        self.CharMain_CurContent = nil
        return
    end

    self.CurrentCharUuid = Content.Uuid
    if(self.CurSlotType == "Char")then
        self:CharMain_SelectListItem(Content)
    end
    --self:CharMain_SelectListItem(Content)
end

function Component:CharMain_SelectListItem(Content)
    if Content then
        Content.TeamIdx = self.CurDungeonPanel.DungeonIndex
    end
    self:SetContentIsChosen(self.CharMain_CurContent, false)
    self:SetContentIsChosen(Content, true)
    self.CharMain_CurContent = Content
    if self.CurDungeonPanel then
        --更新配置面板当前被选中的槽位
        self.CurDungeonPanel:UpdateSlot(self.CurSlotName, Content)
    else
        DebugPrint("lhr@CharMain_SelectListItem：阵容面板失效或初始化失败")
    end
end

return Component
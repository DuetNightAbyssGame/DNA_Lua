--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
require "DataMgr"

local WBP_PrologueMapItem_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_PrologueMapItem_C:Construct(...)
    ---@type Prologue_Map_Btn_Level_Main_2[]
    self.BtnMainLevelList = {
        self.Level_1,
        self.Level_2,
        self.Level_3,
        self.Level,
        self.Level_4,
        self.Level_5,
        self.Level_6,
        self.Level_7
    }
    -- 临时
    self.LevelNames = {
        "生机",
        "失落的遗迹",
        "归来者",
        nil,
        "命悬一线",
        "雾海",
    }
    self.LevelIndex = {
        1,3,5,7,
        2,4,6,8,
    }

    self:InitMainLevel(1001)

    self:AddDispatcher(EventID.OnMatchStateChanged, self, self.OnMatchStateChanged)
    self:OnMatchStateChanged()
end

function WBP_PrologueMapItem_C:SetItemContent(Content)
    self.Content = Content
    Content.MainWidget = self
    self.Parent = Content.Parent
end

function WBP_PrologueMapItem_C:InitMainLevel(ChapterID)
    local ChapterData = DataMgr.Chapter[ChapterID]
    local DungeonListData = ChapterData.DungeonList
    local LastOpenIndex = -1
    for i=1, #self.BtnMainLevelList do
        if i<= #DungeonListData then
            self.BtnMainLevelList[i]:SetVisibility(UIConst.VisibilityOp["Visible"])
            local DungeonID = DungeonListData[i]
            local DungeonName = ''
            if DungeonID>=10000 then
                DungeonName = DataMgr.Dungeon[DungeonID].DungeonName
            else
                DungeonName = DataMgr.Region[DungeonID].RegionName
            end
            self.BtnMainLevelList[i].Text_Level_Name:SetText(GText(DungeonName))
            self.BtnMainLevelList[i].Parent = self
            self.BtnMainLevelList[i].DungeonID = DungeonID
            LastOpenIndex = i
        else
            self.BtnMainLevelList[i].Parent = self
            self.BtnMainLevelList[i].Panel_Lock:SetVisibility(UIConst.VisibilityOp["Visible"])
            if self.LevelNames[i] then
                self.BtnMainLevelList[i].Text_Level_Name:SetText(self.LevelNames[i])
            end
        end
        self.BtnMainLevelList[i].bg_slc:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.BtnMainLevelList[i].Text_Lv_num:SetText(self.LevelIndex[i])
    end
    self.BtnMainLevelList[LastOpenIndex].bg_slc:SetVisibility(UIConst.VisibilityOp["Visible"])
    -- todo
    self.LastOffset = 0
end

function WBP_PrologueMapItem_C:EnterLevel(DungeonID)
    if self.Content.Parent == nil then
        return
    end
    self.Content.Parent:ClickToSelectLevel(DungeonID)
end

function WBP_PrologueMapItem_C:OnMatchStateChanged()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    ---@type BP_UIManagerComponent_C
    local UIManger = GameInstance:GetGameUIManager()
    if UIManger and UIManger:GetUI("DungeonMatchingFloat") then
        for i = 1, #self.BtnMainLevelList do
            self.BtnMainLevelList[i].Btn_Click:SetIsEnabled(false)
        end
    else
        for i = 1, #self.BtnMainLevelList do
            self.BtnMainLevelList[i].Btn_Click:SetIsEnabled(true)
        end
    end 
end


return WBP_PrologueMapItem_C

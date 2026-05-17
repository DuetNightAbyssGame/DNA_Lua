


require "UnLua"

local M = {}
local DataModel=require "BluePrints.UI.WBP.PersonInfo.Data.PersonInfoDataModel"
local PersonInfoController = require "BluePrints.UI.WBP.PersonInfo.PersonInfoController"

M._components = {}

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end
function M:InitBaseView()
    
    --self:InitTab()

    ---隐私选项列表
    local DaVisibleTabs={
        "UI_PersonalPage_Open",
        "UI_PersonalPage_Friend",
        "UI_PersonalPage_Self"
    }
    self.Com_SortDown:Init(DaVisibleTabs,"LS",self)


    --静态数据
    self.Text_DetailTitleTotal:SetText(GText("UI_Bag_Sell_Total"))
    self.Text_PlayTimeDataTitle:SetText(GText("UI_PersonalPage_Recount_TotalTime"))
    self.Text_DetailTitleAchievement:SetText(GText("MAIN_UI_ACHIEVEMENT"))
    self.Title:SetText(GText("UI_Achievement_Title"))
    self.Text_DataTitle:SetText(GText("UI_PersonalPage_Recount_Name"))
    self.Btn_PersonalInfo.Text_Button:SetText(GText("Event_Raid_Title"))
    self.Btn_PersonalInfo.Button_Area.OnClicked:Add(self,self.OnClickHistoryRank)
    -- self.Btn_PersonalInfo.TryOverrideSoundFunc(function()
    --     AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
    -- end)

    --动态数据
    self:InitDetaildView()

    --动画
    self:PlayAnimationForward(self.In)

    self.IsCloseing=false
    
    self:SetFocus()
end
---此处放置依赖Model的初始化信息表现
function M:InitDetaildView()
    --DataModel:Init()
    if not DataModel:GetIsSelf() then
        self.Com_SortDown:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        local VisibleType=DataModel:GetPersonalInfoVisible()
        self.Com_SortDown:SelectItem(VisibleType)
        self.Com_SortDown:BindEventOnSelectionsChanged(self,self.OnSortListSelectionsChanged)
    end
    --基本信息
    self.Text_PlayerName:SetText(DataModel:GetPlayerName())
    self.Num_UID:SetText(DataModel:GetPlayerUid())
    self.Text_PlayerCreateTime:SetText( string.format(GText("UI_PersonalPage_Recount_Create"),DataModel:GetAccoutCreateTime()))
    self.Text_PlayTimeData:SetText(DataModel:GetPlayTime().."h")
    
   --可配置的小方块信息
    local CountItemData=DataModel:GetUniqueDatailedDatas()
    for i=1,#CountItemData do
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.Count=CountItemData[i].Count
        Obj.Name=CountItemData[i].Name
        self.List_PlayerData:AddItem(Obj)
    end
    
    --成就数据
    self.Count_Total:SetText(DataModel:GetAchievementCount())
    local AchievementArray=DataModel:GetAchievementArray()
    self.Count_Gold:SetText(AchievementArray[1])
    self.Count_Silver:SetText(AchievementArray[2])
    self.Count_Bronze:SetText(AchievementArray[3])

    --可配置的Tab信息
    DataModel:SortDetailedTabInfo()
    local TabsDatas=DataModel:GetMoreDetailedTabs()
    for i,v in pairs(TabsDatas) do
        local SingleTabInfo=NewObject(UIUtils.GetCommonItemContentClass())
        for index, value in pairs(v) do
            SingleTabInfo[index]=value
        end
       self.List_Data:AddItem(SingleTabInfo)
    end

    if self.ScrollBox:GetScrollOffsetOfEnd() >1 then
      DebugPrint("ScrollBox:GetScrollOffsetOfEnd() >1")
    else
      DebugPrint("ScrollBox:GetScrollOffsetOfEnd() <1")
    end
    -- self.Data_1.Text_DataNum:SetText(DataModel:GetHaveCharCount())
    -- self.Data_2.Text_DataNum:SetText(DataModel:GetHaveCharCount())
    -- self.Data_3.Text_DataNum:SetText(DataModel:GetHaveCharCount())
end

function M:InitMoreDetailedTabs()
    local TabInfos=DataModel:GetMoreDetailedTabs()
    for i=1,#TabInfos do
        local TabInfo=TabInfos[i]
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.Text_DataTitle:SetText(TabInfo.Title)
    end
end

-- function M:Construct()

-- end
function M:BP_GetDesiredFocusTarget()
    return self
end
--[[
    PersonalInfoVisibleType = {
		All = 1, -- 全部可见
		FriendOnly = 2, -- 仅好友可见
		Self = 3, -- 仅自己可见
	},
]]
---交互相关
function M:OnSortListSelectionsChanged(Index)
    DebugPrint("sortingchange"..Index)
    DataModel:SetInfoVisibility(Index)
end
--function M:Tick(MyGeometry, InDeltaTime)
--end
function M:IsCanReturn()
    if self.IsCloseing==true then return false end
    return true
end

function M:OnReturnKeyDown()
    if self:IsCanReturn()==false then return  end
    PersonInfoController:OnCloseDateView()
    self:UnbindAllFromAnimationFinished(self.Out)
    self:BindToAnimationFinished(self.Out, function()PersonInfoController:ReallyCloseDateView(self) end)
    -- self:BindToAnimationFinished(self.Out, {self, self.Close})
    self:PlayAnimationForward(self.Out)
    self.IsCloseing=true
    --PersonInfoController:CloseDateView()
end

function M:OnClickHistoryRank()
    --AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
    PersonInfoController:OpenGuildWarHistoryRank()
end
---交互相关End
--function M:Destruct()
--end
--AssembleComponents(M)
return M
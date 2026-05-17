--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR shilei
-- @DATE ${date} ${time}
require "UnLua"
local CommonUtils = require "Utils.CommonUtils"
local MonsterUtils = require "Utils.MonsterUtils"
local WalnutBagController = require "BluePrints.UI.WBP.Walnut.WalnutBag.WalnutBagController"
local WalnutBagModel = WalnutBagController:GetModel()
local TimeUtils = require "Utils.TimeUtils"
local EMCache = require "EMCache.EMCache"
local GuildWarUtils = require "BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils"
---@type WBP_Activity_GuildWar_LevelSelect_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
M._components = {
    "BluePrints.UI.WBP.Play.Widget.GuildWar.GuildWarView",
}
local TypeSort = {
    Char = 1,
    Weapon = 2,
    Mod = 3,
    Draft = 4,
    Reward = 5,
    Resource = 6,
}

function M:Construct()
    M.Super.Construct(self)
    M.bOpened = true

    -- 红点监听
    if not ReddotManager.GetTreeNode(GuildWarUtils.ReddotNodeKey) then
        ReddotManager.AddNodeEx(GuildWarUtils.ReddotNodeKey)
    end
    if not self.AddListenerFinish then
        self.AddListenerFinish = true
        ReddotManager.AddListenerEx(GuildWarUtils.ReddotNodeKey, self, self.RefreshEntranceReddot)
    end

    self.Btn_Start:SetText(GText("DUNGEONSINGLE"))
    self.Btn_Start:BindEventOnClicked(self, self.OnClickSolo)
    self.Btn_Ranking:BindEventOnClicked(self, self.OpenGuildWarRank)
    self.Btn_Shop.Btn_Click.OnClicked:Add(self, self.OnShopBtnClicked)
    self.Com_Btn_Details:BindEventOnClicked(self, self.OpenRewardDetails)--(self, self.OpenRewardDetails) self.OpenGuildWarRewardPop  --OpenGuildWarGroupConfirm
    self.Com_Btn_Details_Buff:BindEventOnClicked(self, self.OpenBuffDetails)
    self.ScrollBox_List.OnUserScrolled:Add(self, self.OnUserScrolled)

    self:AddDispatcher(EventID.OnPreRaidRankInfo, self, self.OnPreRaidRankInfo)
    self:AddDispatcher(EventID.OnRaidRankInfo, self, self.OnRaidRankInfo)
     EventManager:AddEvent(EventID.OnRaidRankInfoTopN, self, self.OnRaidRankInfoTopN)  -- 正式赛排行榜

    self:AddDispatcher(EventID.OnRefreshDeputeBtn, self, self.RefreshBtnState)
    self:AddDispatcher(EventID.CurrentSquadChange, self, self.OnCurrentSquadChange)
    -- self:AddDispatcher(EventID.FoucsDungeonSelectLevel,  self, self.OnSelectCellFocus)
    self:AddDispatcher(EventID.OnDisableEscOnDungeonLoading, self, self.DisableEscOnDungeonLoading)
    self:AddDispatcher(EventID.OnRaidRankStart, self, self.Init) --正式赛开启刷新页面

    self:AddDispatcher(EventID.TeamMatchCancel, self, self.OnTeamMatchCancel)
    
    self.List_Prop.OnCreateEmptyContent:Bind(self, self.CreateAndAddEmptyItem)

    ---------------------------------多余结束
    self:AddInputMethodChangedListen()

    self.List_Prop:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self.List_Prop:SetNavigationRuleBase(EUINavigation.Up,EUINavigationRule.Stop)
    --self.List_Prop:SetNavigationRuleExplicit(EUINavigation.Up, self.WB_Event:GetChildAt(0))
    self.List_Prop:SetNavigationRuleBase(EUINavigation.Left,EUINavigationRule.Stop)
    self.List_Prop:SetNavigationRuleBase(EUINavigation.Right,EUINavigationRule.Stop)

    self.List_Monster:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self.List_Monster:SetNavigationRuleBase(EUINavigation.Up,EUINavigationRule.Stop)
    self.List_Monster:SetNavigationRuleBase(EUINavigation.Left,EUINavigationRule.Stop)
    self.List_Monster:SetNavigationRuleBase(EUINavigation.Right,EUINavigationRule.Stop)
    
    self.IsFocusProp = false;
    self.IsFocus_Monster = false;
    self.IsFocusEliteProp = false;

    self.SquadId = 1
    self.MaxMonNum = 2
    self.WalnutId = nil
    self.Mobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
    self.Gamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad

    self.FocusTypeName = nil

    --self.PressedKeys = {}

    self.Panel_Details_Buff:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_Title_Score:SetText(GText("RaidDungeon_Base_Point"))
    self.Text_Consume:SetText(GText("UI_Armory_Trace_Cost"))
    self.Text_Details_Buff:SetText(GText("UI_Dungeon_More"))
end


function M:OnLoaded(...)
    M.Super.OnLoaded(self, ...)
    self:Init()
end

function M:Init()
    self.DungeonList = self:GetCurrentRaidDungeonList()
    if self.DungeonList then
        self:InitLevelList(self.DungeonList)
    end
end

function M:Destruct()
    M.Super.Destruct(self)
    M.bOpened = false
    M.SelectedDungeonId = nil
    self.Btn_Start:UnBindEventOnClickedByObj(self)
    self.Btn_Ranking:UnBindEventOnClickedByObj(self)
    
end

function M:GetCurrentRaidDungeonList()
    self.RaidSeasons = self:GetRaidSeasons()
    if not self.RaidSeasons then -- 
        DebugPrint("self.RaidSeasons 不存在")
        return nil
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.EventId = self.RaidSeasons.EventId
    local targetType = 0  -- 1=预选赛, 2=正式赛
    if  self.RaidSeasons:IsPreRaidTime() then
        targetType = 1
    elseif self.RaidSeasons:IsRaidTime() then
        targetType = 2
    end
    local resultList = {}

    -- 过滤当前类型的副本
    for _, v in pairs(DataMgr.RaidDungeon) do
        if v.RaidDungeonType == targetType and v.RaidSeason == Avatar.CurrentRaidSeasonId then--and v.RaidSeason == Avatar.CurrentRaidSeasonId
            table.insert(resultList, v.DungeonId)
        end
    end

    -- 按 DungeonId 从小到大排序
    table.sort(resultList, function(a, b)
        return (a or 0) < (b or 0)
    end)

    return resultList
end

--- 初始化拼接关信息
---@param ChapterId number @拼接关章节Id
---@param DungeonId number @拼接关关卡Id
function M:InitLevelList(DungeonList)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "Play_DeputeDetail", nil)
    self:SetFocus()
    self.MonsterIdToItem = {}
    self.TypeTable = {}
    self.TypeTableKeys = {}
    --Tabd当前所处页签：用于切换关卡时候处在号令者页签时候判断
    self.CurrentTabIdx = 1
    ---@type Prologue_Map_Level_ListCell_PC_C
    self.SelectCell = nil
    self.FirstEnter = true

    ---@type number[] @关卡Id列表
    --local DungeonList = DataMgr.SelectDungeon[ChapterId].DungeonList
    if not DungeonList then
        return
    end
    self.ActionPointId = DataMgr.ResourceSType2Resource["ActionPoint"][1]

    local SubTabList = {
        { Text = GText("UI_DUNGEON_ObtainType"), Id =  1 },
        { Text = GText("UI_DUNGEON_MonsterType"), Id = 2 }
    }
    self.ObtainTabId =  1
    self.MonsterTabId =  2

    self.Tab_Info:Init(
        {
            LeftKey = "A",
            RightKey = "D",
            Tabs = SubTabList,
            ChildWidgetBPPath =
            "WidgetBlueprint'/Game/UI/WBP/Common/Tab/Widget/WBP_Com_TabSubItem01.WBP_Com_TabSubItem01'",
            SoundFunc = self.PlayTabSound,
            SoundFuncReceiver = self
        }
    )
    self.Tab_Info:BindEventOnTabSelected(self, self.OnSubTabChanged)
    self.Tab_Info:SelectTab(1)
    -- 初始化关卡列表
    self.ScrollBox_List:ClearChildren()
    self.ScrollBox_List:ScrollToStart()
    self.ScrollBox_List:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Wrap)

    self.ScrollBox_List:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.ScrollBox_List:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self.ScrollBox_List:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.ScrollBox_List:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    self.CurrentRaidSeasonId = Avatar.CurrentRaidSeasonId
    self.RaidSeasons = Avatar.RaidSeasons[self.CurrentRaidSeasonId]
    self.RaidSeasonData = DataMgr.RaidSeason[self.RaidSeasons.RaidSeasonId]

    local LastUnlockedItem = nil
    local FirstItem = nil

    self:InitOtherPageTab() --初始化页签

    for i, DungeonId in ipairs(DungeonList) do
        ---@type Prologue_Map_Level_ListCell_PC_C
        local Item = self:CreateWidgetNew("GuildWarLevelItem")
        Item:BindEventOnClicked(self, self.OnClickedLevelCell, Item)
        Item:InitDungeonInfo(DungeonId, i, false, self)

        if i == 1 then
            FirstItem = Item
        end

        -- 记录最后一个已解锁关卡
        if self:CheckDungeonCondition(DungeonId) then
            LastUnlockedItem = Item
        end

        -- 加入列表
        self.ScrollBox_List:AddChild(Item)
    end

    -- 优先选择：最新解锁 > 第一个关卡
    local TargetItem = LastUnlockedItem or FirstItem
    if TargetItem then
        TargetItem.IsSelect = true
        if DataMgr.RaidDungeon[TargetItem.DungeonId].DifficultyLevel <= 1 then
            TargetItem:PlayAnimationForward(TargetItem.Click_Normal)
        else
            TargetItem:PlayAnimationForward(TargetItem.Click)
        end
        --TargetItem:PlayAnimation(TargetItem.Click)
        -- if self:CheckDungeonCondition(TargetItem.DungeonId) then
        --     TargetItem:IsShowBottom() 
        -- end

        self.SelectCell = TargetItem
        self.CurCellDungeonId = TargetItem.DungeonId
        self:InitListCellInfo(TargetItem.DungeonId)
    else
        self.Panel_Detail:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self.SelectCell then
        self:SelectCellFocus() --.Bg_List.Button_Area
        self.ScrollBox_List:ScrollWidgetIntoView(self.SelectCell, true, EDescendantScrollDestination.Center)
    end


    local ChildCount = self.ScrollBox_List:GetChildrenCount()

    -- 没有子项就直接退出
    if not ChildCount or ChildCount == 0 then
        return
    end
    self.ScrollBox_List:GetChildAt(0):SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.ScrollBox_List:GetChildAt(self.ScrollBox_List:GetChildrenCount() - 1):SetNavigationRuleBase(EUINavigation.Down,
        EUINavigationRule.Stop)

    self:PlayAnimation(self.In)

    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:UpdateUIStyleInPlatform(false)
    end
    self.Board:Init()

    --self.RaidSeasons = self:GetRaidSeasons()

    --未进行预选赛战斗时，每天首次进入该界面强弹一次奖励预览弹窗
    if self.RaidSeasons:IsPreRaidTime() and self.RaidSeasons.MaxRaidScore == 0 then
        if self:IsFirstEnterToday() then
            self:OpenGuildWarRewardPop()
        end
    end

    if self.RaidSeasons:IsRaidTime() then
        self.Btn_Shop:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Shop.Text_Name:SetText(GText("RaidDungeon_Shop_Name"))
        self.Consume:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Ranking:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if self.RaidSeasons.MaxPreRaidScore == 0 or self.RaidSeasons.BanState == 1 then  --没参加预算赛排行榜按钮置灰或者被封号
            self.Btn_Ranking:ForbidBtn(true)
            self.Btn_Ranking:BindForbidStateExecuteEvent(self, function()
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("RaidDungeon_PreRaid_Abandon_Toast"))
            end)
        end
        local IsNotFirstRaidTime = EMCache:Get("FirstRaidTime", true)
        DebugPrint("判断是是否是首次进入正式赛  IsNotFirstRaidTime : ",IsNotFirstRaidTime)
        ---判断是是否是首次进入正式赛
        if  not IsNotFirstRaidTime and self.RaidSeasons.MaxPreRaidScore ~= 0 then
            EMCache:Set("FirstRaidTime", true, true)
            ---弹正式赛奖励
            self:OpenGuildWarGroupConfirm()
        end
    else
        self.Btn_Shop:SetVisibility(ESlateVisibility.Collapsed)
        self.Consume:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_Ranking:SetVisibility(ESlateVisibility.Collapsed)
    end
    -- self.Consume:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

--更新单人工会门票数量
function M:UpdateTicketNum()
    if not self.RaidSeasons:IsRaidTime() then return end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local TicketNumData = DataMgr.RaidDungeon[self.SelectCell.DungeonId].TicketNum
    self.ResId = 0
    self.ConsumeTicketCount = 0
    for key, value in pairs(TicketNumData) do
        self.ResId = key
        self.ConsumeTicketCount = value
    end
    local TicketCount = Avatar.Resources[self.ResId] and Avatar.Resources[self.ResId].Count or 0
    if TicketCount >= self.ConsumeTicketCount then
        self.Switcher_Owned:SetActiveWidgetIndex(0)
        self.Num_Over:SetText(self.ConsumeTicketCount)
    else
        self.Switcher_Owned:SetActiveWidgetIndex(1)
        self.Num_Short:SetText(self.ConsumeTicketCount)
    end
    local Resource = DataMgr.Resource[self.ResId]
    local Icon = LoadObject(Resource.Icon)
    -- self.Common_Item_Icon:Init({
    --     Id = self.ResId,
    --     Icon = Icon,
    --     ItemType = "Resource",
    --     NotInteractive = true
    -- })
    self.Common_Item_Icon:Init({
        Id = self.ResId,
        Icon = Icon,
        ItemType = "Resource",
        IsShowDetails = true,
        IsCantItemSelection = true,
        MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
    })
end

function M:IsFirstEnterToday()
    -- 获取今天的日期
    local today = os.date("%Y-%m-%d")

    -- 读取缓存的上次弹窗日期
    local lastDate = EMCache:Get("GuildWarRewardPopDate",true)  --GuildWarRewardPopDate

    -- 判断是否首次进入
    local isFirstEnter = (lastDate == nil or lastDate ~= today)

    -- 如果是新的更新缓存
    if isFirstEnter then
        EMCache:Set("GuildWarRewardPopDate", today,true)
    end

    return isFirstEnter
end

function M:InitOtherPageTab()
    local TabConfigData = {
        DynamicNode = { "Back", "ResourceBar", "BottomKey" },
        BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback = self.OnReturnKeyDown, Owner = self } },
                GamePadInfoList = { { Type = "Img", ImgShortPath = "B", Owner = self } },
                Desc = GText("UI_BACK")
            }
        },

        OwnerPanel = self,
        BackCallback = self.OnReturnKeyDown,
        StyleName = "Text",
        TitleName = GText("Event_Raid_Title"),
        PopupInfoHotKey = "SpecialLeft",
        GetReplyOnBack = function()
            if self.SelectCell then
                return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.SelectCell)
            else
                return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.ScrollBox_List)
            end
        end
    }

    --if self.RaidSeasons:IsPreRaidTime() then
        -- table.insert(TabConfigData.BottomKeyInfo, {
        --     GamePadInfoList = {
        --         { Type = "Add" },
        --         GamePadSubKeyInfoList = {
        --             { Type = "Img", ImgShortPath = "Right", Owner = self },
        --             { Type = "Img", ImgShortPath = "Y",  Owner = self }
        --         }
        --     },
        --     Desc = GText("UI_CTL_DeputeInfo"),
        --     bLongPress = false,
        -- })
    --end

    if (TabConfigData) then
        TabConfigData.OverridenTopResouces = DataMgr.SystemUI["GuildWarLevel"].TabCoin
    end
    self.Tab:Init(TabConfigData, true)
    --self.Tab:BindEventOnTabSelected(Object, Callback)
end


--设置详情面板
function M:SetPanelDetails(Idx)
    if Idx == self.ObtainTabId then
        self.Text_Details:SetText(GText("UI_CTL_Details"))
        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            self.Key_MonsterInfo:SetVisibility(ESlateVisibility.Collapsed)
            self.Switch_Details_Icon:SetActiveWidgetIndex(2)
            self.Switch_Details_Icon_Buff:SetActiveWidgetIndex(2)
            self.Key_Details_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Key_Details_GamePad:CreateCommonKey({
                KeyInfoList = {
                    {
                        Type = "Img",
                        ImgShortPath = "Down",
                    },
                },
            })

            self.Key_Details_GamePad_1:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Key_Details_GamePad_1:CreateCommonKey({
                KeyInfoList = {
                    {
                        Type = "Img",
                        ImgShortPath = "Up",
                    },
                },
            })

        else
            self.Switch_Details_Icon:SetActiveWidgetIndex(1)
            self.Switch_Details_Icon_Buff:SetActiveWidgetIndex(1)
            if not self.Mobile then
                self.Key_Details_GamePad:SetVisibility(ESlateVisibility.Collapsed)
                self.Key_Details_GamePad_1:SetVisibility(ESlateVisibility.Collapsed)
            end
            
        end
    else

        self.Text_Details:SetText(GText("UI_Dungeon_More"))
        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            self.Switch_Details_Icon:SetActiveWidgetIndex(2)
            self.Switch_Details_Icon_Buff:SetActiveWidgetIndex(2)
            self.Key_Details_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Key_Details_GamePad:CreateCommonKey({
                KeyInfoList = {
                    {
                        Type = "Img",
                        ImgShortPath = "Down",
                    },
                },
            })

            self.Key_Details_GamePad_1:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Key_Details_GamePad_1:CreateCommonKey({
                KeyInfoList = {
                    {
                        Type = "Img",
                        ImgShortPath = "Up",
                    },
                },
            })

            if self.FocusTypeName ~="RewardWidget" then
                self.Key_MonsterInfo:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                self.Key_MonsterInfo:CreateCommonKey({
                    KeyInfoList={
                        {
                            Type = "Img",
                            ImgShortPath = "LS"
                        },
                    },
                    Desc = GText("UI_Controller_Check")
                })
            end

        else
            self.Switch_Details_Icon:SetActiveWidgetIndex(0)
            self.Switch_Details_Icon_Buff:SetActiveWidgetIndex(1)
            if not self.Mobile then
                self.Key_Details_GamePad:SetVisibility(ESlateVisibility.Collapsed)
                self.Key_Details_GamePad_1:SetVisibility(ESlateVisibility.Collapsed)
                self.Key_MonsterInfo:SetVisibility(ESlateVisibility.Collapsed)
            end
        end
    end
end
---@param TabWidget Common_Tab_Item_PC_C
function M:OnSubTabChanged(TabWidget)
    self.CurrentTabIdx = TabWidget.Idx
    self:PlayAnimation(self.Switch_Tab)
    if TabWidget.Idx == self.ObtainTabId then
        self.Panel_Info:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Panel_MonsterInfo:SetVisibility(ESlateVisibility.Collapsed)
        -- self.List_Prop:SetVisibility(ESlateVisibility.Visible)
        -- self.List_Monster:SetVisibility(ESlateVisibility.Collapsed)
        self:SetPanelDetailsVis(ESlateVisibility.SelfHitTestInvisible)
        if self.CurrentFocusType == "List" then
            self.List_Prop:SetFocus()
            self:UpdatKeyDisplay("RewardWidget")
        end
        -- self.Btn_Area.OnClicked:Add(self, self.OpenIntro)
    elseif TabWidget.Idx == self.MonsterTabId then
        self.Panel_Info:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_MonsterInfo:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        -- self.List_Prop:SetVisibility(ESlateVisibility.Collapsed)
        -- self.List_Monster:SetVisibility(ESlateVisibility.Visible)
        self:SetPanelDetailsVis(ESlateVisibility.Collapsed)

        if self.CurrentFocusType == "List" then
            self.List_Monster:SetFocus()
            self:UpdatKeyDisplay("RewardWidget")
        end
    end
    self:SetPanelDetails(TabWidget.Idx)
end



function M:ItemMenuAnchorChanged(bIsOpen)
    if (UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad) then
        return
    end
    if (bIsOpen) then
        self:UpdatKeyDisplay("")
    else
        self:UpdatKeyDisplay("SelfWidget")
        self:SelectCellFocus() 
    end
end

--- LevelCell点击响应方法
---@param LevelCell Prologue_Map_Level_ListCell_PC_C @关卡Cell
function M:OnClickedLevelCell(LevelCell)
    if self.SelectCell ~= nil then
        if self:CheckDungeonCondition(self.SelectCell.DungeonId) then
            -- if DataMgr.RaidDungeon[self.SelectCell.DungeonId].DifficultyLevel <= 1 then
            --     self.SelectCell:PlayAnimationReverse(self.Click_Normal)
            -- else
            --     self.SelectCell:PlayAnimationReverse(self.Click)
            -- end
            self.SelectCell:PlayAnimationReverse(self.SelectCell.Click)
        else
            self.SelectCell:ShowTips(false)
        end
        self.SelectCell.IsSelect = false
    end

    self.SelectCell = LevelCell
    self.SelectCell.IsSelect = true
    -- self:UpdateTicketNum()
    --difficulty level
    if not self:CheckDungeonCondition(self.SelectCell.DungeonId) then
        self.SelectCell:SetTimeShow()
    end 
    --- 清空属性选择Item列表
    self.TypeTable = {}
    self.TypeTableKeys = {}
    --- 初始化关卡详情内容
    self.LastMarkType = nil
    self.CurCellDungeonId = LevelCell.DungeonId
    self:InitListCellInfo(LevelCell.DungeonId)
end


--- 初始化初始化关卡详情内容
--- 判断是父级Cell还是普通Cell来初始化Cell的内容
function M:InitListCellInfo(DungeonId)
    if self.SelectCell then
        self:SelectCellFocus()
        local RaidDungeon = DataMgr.RaidDungeon[self.CurCellDungeonId]
        local BaseRaidPoint = RaidDungeon.BaseRaidPoint or 0 
        self.Text_Score:SetText(BaseRaidPoint) 
        self.Text_Floor:SetText(RaidDungeon.DifficultyLevel)
        self:UpdateTicketNum()
    end
    self.CurSelectedDungeonId = DungeonId
    M.SelectedDungeonId = DungeonId
    self.HasTypeSelect = false

    self.Tab_Info:SelectTab(1)

    self:RefreshLevelCellContent(self.CurSelectedDungeonId)
    --根据是否启用阵容预设来判断是否显示阵容预设
    local bSquad = true--DataMgr.Dungeon[self.CurSelectedDungeonId].Squad
    if bSquad then
        self.DefaultList:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        local DungeonType = DataMgr.Dungeon[self.CurSelectedDungeonId].DungeonType
        local bDisablePhantom = DungeonType == "Rouge" or false

        local Avatar = GWorld:GetAvatar()
        if Avatar then
            local SquadId = Avatar.DungeonSquad[DungeonType] and Avatar.DungeonSquad[DungeonType] or 0
            self.DefaultList:Init(self, bDisablePhantom, SquadId,self.CurSelectedDungeonId,true)
            --self.DefaultList:UpdateCurrentDungeonSquad(SquadId)
        end
    else
        self.DefaultList:SetVisibility(ESlateVisibility.Collapsed)
    end

    -- -- 没有配置直接收起
    -- local EventId = ActivityController:GetDoubleModDropEventID()
    -- local CfgDrop = DataMgr.DoubleModDrop and DataMgr.DoubleModDrop[EventId]
    -- if not CfgDrop then
    --     self.Group_TimeTips:SetVisibility(ESlateVisibility.Collapsed)
    --     return
    -- end
    
end

-- 更新关卡介绍内容
function M:RefreshLevelCellContent(DungeonId)
    if not DungeonId then
        DebugPrint("ZDX DungeonId is nil")
        return
    end

    local DungeonData = DataMgr.Dungeon[DungeonId]
    -- 重置关卡详情页面信息
    self.List_Prop:ClearListItems()
    self.List_Monster:ClearListItems()
    self.List_Buff:ClearListItems()

    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end

    --self:PlayAnimation(self.Switch_Type)
    -- 刷新怪物信息列表和奖励信息列表
    self:RefreshMonsterInfoList(DungeonId)
    self:RefreshRewardInfoList(DungeonId)
    self:RefreshBuffInfoList()
    self:RefreshBtnState()

    --self.Btn_Qa.Btn_Click.OnClicked:Add(self, self.OpenIntro)
end



--打开奖励详情
function M:OpenRewardDetails()
    -- local isNightFlight = self.DeputeType == Const.DeputeType.NightFlightManualDepute
    -- if isNightFlight then return end
    AudioManager(self):PlayUISound(self, "event:/ui/common/tip_show_click", nil, nil)
    local Params = {}
    Params.RewardList = self.RewardList
    Params.CloseBtnCallbackFunction = function()
        self:SelectCellFocus()
    end
    Params.AutoFocus = true
    local UI = UIManager(self):ShowCommonPopupUI(100156, Params)
    --UI:ShowGamepadScrollBtn(true)
end

--打开Buff详情
function M:OpenBuffDetails()
    local GuildWarEnvironment = UIManager(self):LoadUINew("GuildWarEnvironment")
    GuildWarEnvironment:Init(self.RaidBuffIDArry)
end

-- 尝试打开排行榜（数据准备好）
function M:TryOpenRankTopN()
    if self.RankInfo and self.TopNInfo and self.OpenRankTag then
        self.OpenRankTag = nil
        UIManager():LoadUINew("GuildWarRank", self.RankInfo, self.TopNInfo)
    end
end

--打开排行榜
function M:OpenGuildWarRank()
    AudioManager(self):PlayUISound(self, "event:/ui/activity/shop_small_btn_click", nil, nil)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    self.OpenRankTag = true
    -- 玩家个人排名数据
    self:BlockAllUIInput(true, "RaidSeasonGetRaidRankinfo")
    Avatar:RaidSeasonGetRaidRankInfo(function(ErrCode)
        self:BlockAllUIInput(false, "RaidSeasonGetRaidRankinfo")
        if (not ErrorCode:Check(ErrCode)) and self then
            self.RankInfo = {}
            self:TryOpenRankTopN()
        end
    end)
    -- 排行榜TopN数据
    self:BlockAllUIInput(true, "RaidSeasonGetRaidRankTopN")
    Avatar:RaidSeasonGetRaidRankTopN(function(ErrCode)
        self:BlockAllUIInput(false, "RaidSeasonGetRaidRankTopN")
        if (not ErrorCode:Check(ErrCode)) and self then
            self.TopNInfo = {}
            self:TryOpenRankTopN()
        end
    end)
end

-- 更新Buff信息列表
---@param DungeonId number[] @副本Id
function M:RefreshBuffInfoList()
    local RaidDungeon = DataMgr.RaidDungeon[self.CurCellDungeonId]
    self.RaidBuffIDArry = RaidDungeon.RaidBuffID
    -- if #self.RaidBuffIDArry < 3 then
    --     self.Panel_Details_Buff:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- else
    --     self.Panel_Details_Buff:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- end

    if self.RaidBuffIDArry then
        self.WS_Buff:SetActiveWidgetIndex(0)
        -- 逐个实例buff信息列表
        for _, RaidBuffID in ipairs(self.RaidBuffIDArry) do
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.RaidDungeonBuffData = DataMgr.RaidBuff[RaidBuffID]
            self.List_Buff:AddItem(Content)
        end
    else
        self.Panel_Details_Buff:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.WS_Buff:SetActiveWidgetIndex(1)
        self.Text_Buff_Empty:SetText(GText())
    end

    if self:IsExistTimer(self.NextFrameListEmpty) then
        self:RemoveTimer(self.NextFrameListEmpty)
    end
    -- --- 用空Item补全ListView, 加定时器是因为隔一帧才能拿到已生成的Entry
    -- self.NextFrameListEmpty = self:AddTimer(0.01, function()

    --     self.List_Prop:RequestFillEmptyContent()
    -- end, false, 0, "GuildWar_LevelSelectListView")
end

-- 更新奖励信息列表
---@param DungeonId number[] @副本Id
function M:RefreshRewardInfoList(DungeonId)
    assert(DataMgr.Dungeon[DungeonId], "副本信息不存在:" .. DungeonId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local FirstRewardList
    if not Avatar.Dungeons[DungeonId] or not Avatar.Dungeons[DungeonId].IsPass then
        -- 获取首次通关奖励
        local RewardInfo = DataMgr.Reward[DataMgr.Dungeon[DungeonId].FirstCompleteReward]
        if RewardInfo then
            FirstRewardList = {}
            local RewardIds = RewardInfo.Id or {}
            local RewardCounts = RewardInfo.Count or {}
            local RewardTypes = RewardInfo.Type or {}
            for i = 1, #RewardIds do
                local ItemId = RewardIds[i]
                local Count = RewardUtils:GetCount(RewardCounts[i])
                local Icon = ItemUtils.GetItemIcon(ItemId, RewardTypes[i])
                local Rarity = ItemUtils.GetItemRarity(ItemId, RewardTypes[i])
                local ItemType = RewardTypes[i]
                local RewardContent = {
                    Id = ItemId,
                    Type = ItemType,
                    ItemCount = Count,
                    Icon = Icon,
                    Rarity = Rarity,
                    bFirst = true,
                    DropType = "FirstReward"
                }
                table.insert(FirstRewardList, RewardContent)
            end
        end
    end
    
    -- 获取常规通关奖励
    local RewardList = RewardUtils:GetRewardViewInfoById(DataMgr.Dungeon[DungeonId].DungeonRewardView)
    local SortFunc = function(A, B)
        if A.Rarity == B.Rarity then
            if TypeSort[A.Type] and TypeSort[B.Type] then
                if TypeSort[A.Type] == TypeSort[B.Type] then
                    return A.Id < B.Id
                end
                return TypeSort[A.Type] < TypeSort[B.Type]
            end
            return A.Id < B.Id
        end
        return A.Rarity > B.Rarity
    end

    -- 先显示首次通关奖励
    if FirstRewardList then
        table.sort(FirstRewardList, SortFunc)
    end
    table.sort(RewardList, SortFunc)
    self.RewardList = {}
    if FirstRewardList then
        for _, v in ipairs(FirstRewardList) do
            table.insert(self.RewardList, v)
        end
    end
    for _, v in ipairs(RewardList) do
        table.insert(self.RewardList, v)
    end


    --额外副本奖励 |活动委托额外奖励表|EventDungeonReward
    local IsInTimeRange, RewardConfig = self:IsInTimeRange(DungeonId)
    if IsInTimeRange and RewardConfig then
        local EventDungeonRewardList = RewardUtils:GetRewardViewInfoById(RewardConfig.RewardView)
        table.sort(EventDungeonRewardList, SortFunc)
        for _, v in ipairs(EventDungeonRewardList) do
            table.insert(self.RewardList, v)
        end
    end

    -- 逐个实例化奖励列表
    for _, ItemData in ipairs(self.RewardList) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())

        Content.Id = ItemData.Id
        Content.Icon = ItemUtils.GetItemIconPath(ItemData.Id, ItemData.Type)
        Content.ParentWidget = self
        Content.ItemType = ItemData.Type
        Content.Rarity = ItemData.Rarity or 1
        Content.IsShowDetails = true
        Content.UIName = "DeputeDetail"

        if ItemData.bFirst then
            Content.BonusType = 2
        end

        local BaseCount = ItemData.ItemCount or nil

        -- 优先使用 Quantity
        if ItemData.Quantity then
            if #ItemData.Quantity > 1 then
                Content.MaxCount = ItemData.Quantity[2]
            end
            BaseCount = ItemData.Quantity[1] or nil
        end
        Content.Count = BaseCount

        self.List_Prop:AddItem(Content)
    end

    if self:IsExistTimer(self.NextFrameListEmpty) then
        self:RemoveTimer(self.NextFrameListEmpty)
    end
    --- 用空Item补全ListView, 加定时器是因为隔一帧才能拿到已生成的Entry
    self.NextFrameListEmpty = self:AddTimer(0.01, function()
        --这里设置一下奖励的导航
        local len = self.List_Prop:GetNumItems()
        for i = 1, len do
            local entryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Prop, i - 1)
            if entryWidget then                
                entryWidget:BindEvents(self, {
                    OnMenuOpenChanged = self.OnStuffMenuOpenChanged,
                })
            end
        end

        self.List_Prop:RequestFillEmptyContent()
    end, false, 0, "GuildWar_LevelSelectListView")
end

--根据当前时间判断 活动委托额外奖励表|EventDungeonReward
function M:IsInTimeRange(dungeonId)
    local nowTimestamp = TimeUtils.NowTime()
    local dungeonConfig = DataMgr.EventDungeonReward[dungeonId]
    if not dungeonConfig then return false end

    for _, config in pairs(dungeonConfig) do
        -- 排除异常
        if type(config) == "table" then
            if nowTimestamp >= config.StartDate and nowTimestamp <= config.EndDate then
                return true, config  -- 找到匹配的时间段
            end
            -- for _, config in pairs(endTable) do
            --     if nowTimestamp >= config.StartDate and nowTimestamp <= config.EndDate then
            --         return true, config  -- 找到匹配的时间段
            --     end
            -- end
        end
    end

    return false
end

function M:CreateAndAddEmptyItem()
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    -- Content.IsEmpty = true
    Content.Id = 0
    return Content
    --self.List_Prop:AddItem(Content)
end

function M:OnStuffMenuOpenChanged(bIsOpen)
    if (UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad) then
        return
    end
    self.MenuOpen = bIsOpen
    if (bIsOpen) then
        self.Btn_Start:SetPCVisibility(true)
        self.Btn_Ranking.Key_Shop:SetVisibility(ESlateVisibility.Collapsed)
        self:UpdatKeyDisplay("")
        self.Switch_Details_Icon:SetActiveWidgetIndex(self.CurrentTabIdx == self.ObtainTabId and 0 or 1)
        self.Switch_Details_Icon_Buff:SetActiveWidgetIndex(self.CurrentTabIdx == self.ObtainTabId and 0 or 1)
    else
        self.Btn_Start:SetPCVisibility(false)
        self.Btn_Ranking.Key_Shop:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:UpdatKeyDisplay("RewardWidget")
        self.List_Prop:SetFocus()
        self.Switch_Details_Icon:SetActiveWidgetIndex(2)
        self.Switch_Details_Icon_Buff:SetActiveWidgetIndex(2)
    end
end


function M:OnClickedCell(LvCell)
    if self.SelectLvTabCell ~= nil then
        self.SelectLvTabCell:OnCellUnSelect()
    end

    self.SelectLvTabCell = LvCell
    LvCell:SelectCell()
end


-- 更新关卡怪物信息列表
function M:RefreshMonsterInfoList(DungeonId)
    -- 检查关卡是否有怪物信息
    local DungeonInfo = DataMgr.Dungeon[DungeonId]
    if not DungeonInfo or not DungeonInfo.DungeonMonsters or #DungeonInfo.DungeonMonsters == 0 then
        DebugPrint("ZDX DungeonMonster is nil")
        return
    end

    -- 复制怪物列表并进行排序
    local DisplayMonsters = CommonUtils.DeepCopy(DungeonInfo.DungeonMonsters)
    table.sort(DisplayMonsters, MonsterUtils.CompareMonsters)

    self.MonsterWeaknessIcon = {}
    self:InitMonsterWeakness(DungeonId)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    for _, MonsterId in ipairs(DisplayMonsters) do
        -- 逐个实例化怪物列表
        local MonsterData = DataMgr.Monster[MonsterId]
        if MonsterData then  -- and GameState:IsUnitRelease(MonsterId)
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.ParentWidget = self
            Content.MonsterId = MonsterId
            Content.DisableSelect = true
            Content.SoundEvent = "event:/ui/common/click_mid"
            -- 怪物图标
            Content.WeaknessIcon = self.MonsterWeaknessIcon[MonsterId]
            self.List_Monster:AddItem(Content)
        end
    end
end

-- 初始化怪物弱点信息
function M:InitMonsterWeakness(DungeonId)
    assert(DungeonId, "dungeon id is nil")
    local DungeonInfo = DataMgr.Dungeon[DungeonId]

    assert(DungeonInfo, string.format("dungeon id [%d] is wrong, cant find dungeonInfo", DungeonId))
    local MonsterBuff = DungeonInfo.MonsterBuff
    local Monsters = DungeonInfo.DungeonMonsters
    if MonsterBuff then
        for _, MonsterId in ipairs(Monsters) do
            if type(MonsterId) == "number" then
                local AllBuffs = MonsterUtils.GetRealMonsterBuffs(DungeonId, MonsterId)
                for _, BuffId in ipairs(AllBuffs) do
                    local BuffInfo = DataMgr.Buff[BuffId]
                    if BuffInfo then
                        if BuffInfo.WeaknessType then
                            local HasWeakness = not not BuffInfo.WeaknessType

                            if HasWeakness then
                                local WeaknessIcon = DataMgr.DamageType[BuffInfo.WeaknessType].WeaknessIcon
                                if WeaknessIcon then
                                    self.MonsterWeaknessIcon[MonsterId] = self.MonsterWeaknessIcon[MonsterId] or {}
                                    self.MonsterWeaknessIcon[MonsterId][WeaknessIcon] = true
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


-- 分包下载，无资产时弹出下载UI
function M:EnsureOptionalPatchDownloaded(DungeonId)
    local PatchCond = DataMgr.DungeonPatchCondition and DataMgr.DungeonPatchCondition[DungeonId]
    local NecessaryPatch = PatchCond and PatchCond.NecessaryPatch

    -- 没配置，返回 true
    if not NecessaryPatch or #NecessaryPatch == 0 then
        return true
    end

    local HotUpdateSubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UE4.UHotUpdateSubsystem)
	if not HotUpdateSubsystem then
		return true
	end
    if NecessaryPatch and not HotUpdateSubsystem:IsAllPatchOptionalSignsDownloaded(NecessaryPatch) then
        UIManager(self):LoadUINew("OptionalPatch", NecessaryPatch)
        return false
    end
    return true
end

-- 单人挑战
function M:OnClickSolo()
    if not self.CurSelectedDungeonId then
        DebugPrint("SL CurSelectedDungeonId is nil")
        return
    end

    if not self:EnsureOptionalPatchDownloaded(self.CurSelectedDungeonId) then
        return
    end

    if not self:CheckDungeonCondition(self.CurSelectedDungeonId) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("RaidDungeon_DungeonLocked_Toast"))
        return
    end

    self:EnterStandalone()
end


function M:EnterStandalone()

    local ExitDungeonInfo = {
        Type = "GuildWar",
        JumpId = 69,
        SquadId = self.SquadId or nil     
    }
    GWorld.GameInstance:SetExitDungeonData(ExitDungeonInfo)
    AudioManager(self):PlayUISound(self, "event:/ui/common/map_click_enter_level", nil, nil)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        self:TryEnterDungeon(Avatar, self.CurSelectedDungeonId,
            function(RetCode, ...)
                local bRetCode = self.HandleEnterDungeonRetCode(RetCode, ...)
                if not bRetCode then
                    self:PlayAnimation(self.In)
                end
            end, nil)
    else
        WorldTravelSubsystem(self):ChangeDungeonByDungeonId(self.CurSelectedDungeonId,
            CommonConst.DungeonNetMode.Standalone)
    end
end



function M:OnUserScrolled()
    if CommonUtils.GetDeviceTypeByPlatformName()=="Mobile" then return end
    UIUtils.UpdateScrollBoxArrow(self.ScrollBox_List,self.List_ArrowTop,self.List_ArrowBottom)
end


--- 默认返回按钮响应方法
function M:OnReturnKeyDown()
    AudioManager(self):SetEventSoundParam(self, "Play_DeputeDetail", {ToEnd = 1})
    if not self:IsAnimationPlaying(self.Out) and not self:IsAnimationPlaying(self.In) then
        self:SetVisibility(ESlateVisibility.HitTestInvisible)
        self:PlayAnimation(self.Out) 
        EventManager:FireEvent(EventID.OnActivityEntryShowVisible)
    end
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Out then
        self.Super.Close(self)
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
    if not IsUseKeyAndMouse and (self:HasFocusedDescendants() or self:HasAnyUserFocus()) then
        local isInvisible = self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible
        local isNotShown = not self.DefaultList.IsShow

        if (isInvisible and isNotShown) or not isInvisible then
            self:SelectCellFocus()
            --self:UpdatKeyDisplay("SelfWidget")
        end
    else
        -- if self.Image_Select and self.Image_Select:GetRenderOpacity() > 0 then
        --     self:PlayAnimation(self.UnHover)
        -- end
    end
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)

    --self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

function M:UpdatKeyDisplay(FocusTypeName)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then return end
        
    -- local StyleOfPlay = UIManager(self):GetUIObj("StyleOfPlay")
    -- if not StyleOfPlay then
    --     return
    -- end
    if self.DefaultList:GetVisibility() ==  ESlateVisibility.SelfHitTestInvisible and self.DefaultList.IsShow then
        return
    end

    self.FocusTypeName = FocusTypeName
    if FocusTypeName == "RewardWidget" then
        -- if self.RaidSeasons:IsPreRaidTime() then
        --     table.insert(BottomKeyInfo, {
        --         GamePadInfoList = {
        --             { Type = "Add" },
        --             GamePadSubKeyInfoList = {
        --                 { Type = "Img", ImgShortPath = "Right", Owner = self },
        --                 { Type = "Img", ImgShortPath = "Y",     Owner = self }
        --             }
        --         },
        --         Desc = GText("UI_CTL_DeputeInfo"),
        --         bLongPress = false,
        --     })
        -- end
        local BottomKeyInfo = {
            {
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "A", Owner = self }
                },
                Desc = GText("UI_Controller_CheckDetails"),
                bLongPress = false,
            },
            {
                KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback = self.OnReturnKeyDown, Owner = self } },
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "B", Owner = self }
                },
                Desc = GText("UI_BACK"),
            }
        }


        -- 更新界面按键提示
        self.Tab:UpdateBottomKeyInfo(BottomKeyInfo)
        --StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
        self:UpdateUIStyleInPlatform(true)
        self.Tab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Tab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        --self.Cost.Key:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Tab_Info:UpdateUIStyleInPlatform(true)
        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            self.Btn_Ranking.Key_Shop:SetVisibility(ESlateVisibility.Collapsed)
            self.Key_MonsterInfo:SetVisibility(ESlateVisibility.Collapsed)
            self.Btn_Start:SetPCVisibility(true)
        end
        self.DefaultList:ApplyPcUiLayout()

        -- if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        --     --self.Btn_More:SetVisibility(ESlateVisibility.Collapsed)
        --     self:SetPanelDetailsVis(ESlateVisibility.Collapsed)
        -- end

    elseif FocusTypeName == "SelfWidget" then
        local BottomKeyInfo = {}

        -- if self.RaidSeasons:IsPreRaidTime() then
        --     table.insert(BottomKeyInfo, {
        --         GamePadInfoList = {
        --             { Type = "Add" },
        --             GamePadSubKeyInfoList = {
        --                 { Type = "Img", ImgShortPath = "Right", Owner = self },
        --                 { Type = "Img", ImgShortPath = "Y",     Owner = self }
        --             }
        --         },
        --         Desc = GText("UI_CTL_DeputeInfo"),
        --         bLongPress = false,
        --     })
        -- end

        table.insert(BottomKeyInfo, {
            KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback = self.OnReturnKeyDown, Owner = self } },
            GamePadInfoList = { { Type = "Img", ImgShortPath = "B", Owner = self } },
            Desc = GText("UI_BACK"),
        })


        -- 更新界面按键提示
        self.Tab:UpdateBottomKeyInfo(BottomKeyInfo)

        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            self:UpdateUIStyleInPlatform(false)
            self.Tab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Tab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            --self.Cost.Key:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Tab_Info:UpdateUIStyleInPlatform(true)
            self.Btn_Start:SetPCVisibility(false)

            self.IsFocusProp = false;
            self.IsFocus_Monster = false;
            self.IsFocusEliteProp = false;
            self.DefaultList:InitWidgetInfoInGamePad()
        end
        
    elseif FocusTypeName == "MenuAnchor" then
        local BottomKeyInfo = {
            {
                GamePadInfoList = { {
                    Type = "Img",
                    ImgShortPath = "B",
                    Owner = self
                } },
                Desc = GText("UI_CTL_CloseTips"),
                bLongPress = false,
            },
        }
        self.Tab:UpdateBottomKeyInfo(BottomKeyInfo)
        self:UpdateUIStyleInPlatform(true)
        self.Tab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Tab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        local BottomKeyInfo = {}
        -- 更新界面按键提示
        self.Tab:UpdateBottomKeyInfo(BottomKeyInfo)
        self:UpdateUIStyleInPlatform(true)
        self.Tab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Tab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        --self.Cost.Key:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Tab_Info:UpdateUIStyleInPlatform(false)
    end
end

function M:SetPanelDetailsVis(SlateVisibility)
    self.Panel_Details:SetVisibility(SlateVisibility)
end


function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then return end
    --如果是pc或者特殊原因需要显示为pc时
    if (IsUseKeyAndMouse) then
        self.Com_Key_More:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Ranking.Key_Shop:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Shop.Key_Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Board.WS_Controller:SetActiveWidgetIndex(0)
        self.Key_MonsterInfo:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else

        --self:SetPanelDetailsVis(self:IsShowKeyMore() and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed) 
        self.Board.WS_Controller:SetActiveWidgetIndex(1)
        self.Board.Key_Reward:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "RB",
                }
            },
        })
        self.Com_Key_More:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Com_Key_More:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "LS",
                }
            },
            bLongPress = false,
            Desc = GText("UI_Controller_Check")
        })

        self.Btn_Ranking.Key_Shop:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Ranking.Key_Shop:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "X",
                }
            },
        })

        self.Btn_Shop.Key_Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Shop.Key_Controller:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "LB",
                }
            },
        })
    end
    self:SetPanelDetails(self.CurrentTabIdx)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        if (InKeyName == "Escape") then
            IsEventHandled = true
            if self.DisableEsc and self.DisableEsc == true then
                return UWidgetBlueprintLibrary.Handled()
            end
            if self.DefaultList:GetVisibility() ==  ESlateVisibility.SelfHitTestInvisible and self.DefaultList.IsShow then
                --EventManager:FireEvent(EventID.CloseSquadGamepad)
                self.DefaultList:OnCloseSquadGamepad()
            else
                self:OnReturnKeyDown()
            end                    
        elseif InKeyName == "A" then
            if self.Tab_Info then
                self.Tab_Info:TabToLeft()
                IsEventHandled = true
            end
        elseif InKeyName == "D" then
            if self.Tab_Info then
                self.Tab_Info:TabToRight()
                IsEventHandled = true
            end
        end
    end

    if IsEventHandled then
        return UWidgetBlueprintLibrary.Handled()
    else
        return UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnGamePadDown(InKeyName)
    DebugPrint("SL OnGamePadDown is InKeyName Detail", InKeyName)
    local IsEventHandled = false
    -- 记录按下状态
    --self.PressedKeys[InKeyName] = true
    -- 组合键检测：方向键右是否按下
    --local IsDpadUp = self.PressedKeys[Const.GamepadDPadRight] == true
    if InKeyName == "Gamepad_FaceButton_Right" then
        -- 先处理 DefaultList 关闭
        if self.DefaultList
            and self.DefaultList.IsShow
            and self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
            self.DefaultList:OnCloseSquadGamepad()
            self:UpdatKeyDisplay("SelfWidget")
            IsEventHandled = true
        else
            -- 单键 B：在处理 SelectCell 焦点
            if self.SelectCell then
                local btnArea = self.SelectCell and self.SelectCell.Btn_Click
                if btnArea and not btnArea:HasAnyUserFocus() then
                    self:SelectCellFocus()
                    IsEventHandled = true
                else
                    self:OnReturnKeyDown()
                    IsEventHandled = true
                end
            end
        end

    elseif InKeyName ~= UIConst.GamePadKey.SpecialRight then
        --货币栏Tab监听按键
        IsEventHandled = self.Tab:Handle_KeyEventOnGamePad(InKeyName)
    end

    if self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible and self.DefaultList.IsShow then
        return IsEventHandled --UWidgetBlueprintLibrary.UnHandled()
    end

    if InKeyName == "Gamepad_LeftTrigger" or InKeyName == "Gamepad_RightTrigger" then
        if self.Tab_Info then
            self.Tab_Info:Handle_KeyEventOnGamePad(InKeyName)
            IsEventHandled = true
        end
        ---右边菜单键
    elseif InKeyName == "Gamepad_Special_Right" then
        if self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
            self.DefaultList:OnSpecialRightUp()
            IsEventHandled = true
        end
        ---X按键
    elseif InKeyName == "Gamepad_FaceButton_Left" then  
        if self.RaidSeasons:IsRaidTime() and self.RaidSeasons.MaxPreRaidScore > 0 then
            --打开排行榜
            self:OpenGuildWarRank()
        end
        ---Y按键
    elseif InKeyName == "Gamepad_FaceButton_Top" then
        self:OnClickSolo()
        -- self.PressedKeys["Gamepad_DPad_Up"] = nil
        -- self.PressedKeys["Gamepad_FaceButton_Top"] = nil
        -- if self.RaidSeasons:IsPreRaidTime() and IsDpadUp then
        --     --打开奖励预览
        --     self:OpenGuildWarRewardPop()
        -- else
        --     self:OnClickSolo()
        -- end
    -- 左肩按键打开商城 
    elseif InKeyName == "Gamepad_LeftShoulder" then
        if self.RaidSeasons:IsRaidTime() then
            self:OnShopBtnClicked()
        end
    -- 右肩按键打开奖励预览  
    elseif InKeyName == "Gamepad_RightShoulder" then
        if self.RaidSeasons:IsPreRaidTime() then
            --打开奖励预览
            self:OpenGuildWarRewardPop()
        end
    elseif InKeyName == "Gamepad_LeftThumbstick" then
        if  self.CurrentFocusType ~= "SelectCell" then
            return IsEventHandled
        elseif self.CurrentFocusType == "SelectCell" then
            if self.CurrentTabIdx == self.ObtainTabId then
                self.List_Prop:SetFocus()
                self:UpdatKeyDisplay("RewardWidget")
            elseif self.CurrentTabIdx == self.MonsterTabId then
                self.List_Monster:SetFocus()
                self:UpdatKeyDisplay("RewardWidget")
            end
            self:PlayAnimation(self.Hover)
            self.CurrentFocusType = "List"         
            IsEventHandled = true    
        end 
    end
    return IsEventHandled
end

-- function M:OnKeyUp(MyGeometry, InKeyEvent)
--     local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
--     local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

--     local IsEventHandled = false
--     if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
--         IsEventHandled = self:OnGamePadUp(InKeyName)
--     end

--     if (IsEventHandled) then
--         return UE4.UWidgetBlueprintLibrary.Handled()
--     else
--         return UE4.UWidgetBlueprintLibrary.UnHandled()
--     end
-- end

-- function M:OnGamePadUp(InKeyName)
--     local IsEventHandled = false
--     self.PressedKeys[InKeyName] = false
--     return IsEventHandled
-- end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    if self.DefaultList:GetVisibility() ==  ESlateVisibility.SelfHitTestInvisible and self.DefaultList.IsShow then
        return UWidgetBlueprintLibrary.UnHandled()
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    --self.PressedKeys[InKeyName] = true
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == "Gamepad_DPad_Up" then
            if self.CurrentTabIdx ==  self.ObtainTabId and not self.MenuOpen then --and self.Panel_Details_Buff:GetVisibility() == ESlateVisibility.SelfHitTestInvisible 
                self:OpenBuffDetails()
                IsEventHandled = true
            end  
        elseif InKeyName == "Gamepad_DPad_Down" then
            if self.CurrentTabIdx ==  self.ObtainTabId and not self.MenuOpen then
                self:OpenRewardDetails()
                IsEventHandled = true
            end           
        elseif InKeyName == "Gamepad_DPad_Right" and not self:IsFocusList() then
            if self.DefaultList:GetVisibility() ~= ESlateVisibility.SelfHitTestInvisible then return IsEventHandled end
            if not self.DefaultList.IsShow then
                local IsChecked = not self.DefaultList.Preview.Switch_Summon:GetChecked()
                self.DefaultList.Preview.Switch_Summon:SetChecked(IsChecked)
                local Avatar = GWorld:GetAvatar()
                if not Avatar then IsEventHandled = true return  end
                Avatar:SwitchSquadAutoPhantom(IsChecked)
                IsEventHandled = true
            end
        elseif InKeyName == "Gamepad_DPad_Left" and not self:IsFocusList() then
            if self.DefaultList:GetVisibility() ~=  ESlateVisibility.SelfHitTestInvisible then  return IsEventHandled end
                if not self.DefaultList.IsShow then
                    self.DefaultList.Preview:OpenDefaultMenuAnchor()
                    self:UpdatKeyDisplay("MenuAnchor")
                    IsEventHandled = true
                end     
        end
    end
    if (IsEventHandled) then
        return UWidgetBlueprintLibrary.Handled()
    else
        return UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnShopBtnClicked()
    local PageConfigData = DataMgr.EventPortal[self.RaidSeasonData.EventId]
    if not PageConfigData then
        return
    end
    PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.EventShop, self.OnShopClose, self)
end

function M:OnShopClose()
end


function M:SelectCellFocus()
    if not self.SelectCell then return end
    self:UpdatKeyDisplay("SelfWidget")
    if not self.SelectCell.Btn_Click:HasAnyUserFocus() then
        self.CurrentFocusType = "SelectCell"
        self.SelectCell.Btn_Click:SetFocus()
    end
end

function  M:IsFocusList()
    return  self.CurrentFocusType == "List"
end


function M:OnForbiddenRightBtnClicked()
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "UI_REGISTER_COMINGSOON")
end

function M:OnForbiddenLeftBtnClicked()
    if self.IsComMissing and self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
        --self.DefaultList.Preview:PlayFlashRed()
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "UI_Squad_Miss_Challenge")
    end
end

function M:OnForbiddenDoubleModBtnClicked()
    if self.IsDoubleMod and self.ContinuousCombat then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "UI_Event_ModDrop_Exhausted")
    end
end


function M:OpenGuildWarRewardPop()
    local GuildWarRewardPop = UIManager(self):LoadUINew("GuildWarRewardPop")
    GuildWarRewardPop:Init()
end

--切换正式赛弹窗
function M:OpenGuildWarGroupConfirm()
    local GuildWarGroupConfirm = UIManager(self):LoadUINew("GuildWarGroupConfirm")
    GuildWarGroupConfirm:Init()
end


function M:OnCurrentSquadChange(SquadId, IsComMissing)
    self.SquadId = SquadId
    self.IsComMissing = IsComMissing
    self:RefreshBtnState()
    -- if self.DefaultList.CurrentCharLevel <= DataMgr.Dungeon[self.CurSelectedDungeonId].DungeonLevel - DataMgr.GlobalConstant.TaskWarningLevel.ConstantValue then
    --     self.Panel_WarningHint:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- else
    --     self.Panel_WarningHint:SetVisibility(ESlateVisibility.Collapsed)
    -- end
    -- 阵容组件缺失处理
end

function M:RefreshBtnState()

    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    self.Btn_Start:UnBindEventOnClickedByObj(self)
    self.Btn_Start:ForbidBtn(false)
    self.Btn_Start:SetDefaultGamePadImg("Y")

    local DungeonId = self.SelectCell.DungeonId

    -- 未解锁直接 return
    if not self:CheckDungeonCondition(DungeonId) then
        self.Btn_Start:ForbidBtn(true)
        self.Btn_Start:BindForbidStateExecuteEvent(self, function()
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("RaidDungeon_DungeonLocked_Toast"))
        end)
        return
    end

    -- 正式赛检查门票
    if self.RaidSeasons:IsRaidTime() then
        if Avatar then
            local TicketCount = Avatar.Resources[self.ResId] and Avatar.Resources[self.ResId].Count or 0
            if TicketCount < self.ConsumeTicketCount then
                self.Btn_Start:ForbidBtn(true)
                local Resource = DataMgr.Resource[self.ResId]
                self.Btn_Start:BindForbidStateExecuteEvent(self, function()
                    UIManager(self):ShowUITip(UIConst.Tip_CommonToast,
                        string.format(GText("RaidDungeon_NoTicket_Toast"), GText(Resource.ResourceName)))
                end)
                return
            end
        end
    end

    -- 阵容预设缺失
    if self.IsComMissing then
        self.Btn_Start:ForbidBtn(true)
        self.Btn_Start:BindForbidStateExecuteEvent(self, self.OnForbiddenLeftBtnClicked)
        return
    end

    --赛事未开始按钮置灰
    if not GuildWarUtils.IsRaidTime() then
        self.Btn_Start:ForbidBtn(true)
        return
    end

    --组队按钮置灰
    local bIsInTeam = Avatar:IsInTeam()
    if bIsInTeam then
        self.Btn_Start:ForbidBtn(true)
        self.Btn_Start:BindForbidStateExecuteEvent(self,
            function() UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "UI_TRAINING_FAIL_GUIDWAR") end)
        return
    end

    -- 都正常则绑定进入副本
    self.Btn_Start:BindEventOnClicked(self, self.OnClickSolo)
end



function M:PlayTabSound()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_03", nil, nil)
end

function M:TryEnterDungeon(Avatar, DungeonId, OtherCallback)
    DebugPrint("SL@M:TryEnterDungeon ", Avatar, DungeonId, self.RaidSeasonData.EventId, OtherCallback)
    if self.DefaultList:GetVisibility() == ESlateVisibility.Collapsed then
        --Avatar:EnterDungeon(DungeonId, DungeonNetMode, OtherCallback, TicketId)
        Avatar:EnterEventDungeon(OtherCallback, DungeonId, nil, self.RaidSeasonData.EventId)
    else
        Avatar:EnterEventDungeon(OtherCallback, DungeonId, self.SquadId, self.RaidSeasonData.EventId)
    end
    self.Btn_Start:ForbidBtn(true)
end

--点击怪物信息
function M:SelectMonsterInfoItem(MonsterId)
    UIManager(self):LoadUINew("MonsterDetailInfo", self.CurSelectedDungeonId, self, MonsterId)
end

function M.HandleEnterDungeonRetCode(RetCode, ...)
    DebugPrint("SL@M.EnterDungeonCallback RetCode", RetCode)

    ErrorCode:Check(RetCode)
    if RetCode == ErrorCode.RET_SUCCESS then
        return true
    else
        return false
    end
end

function M:OnTeamMatchCancel(Ret)
    self.Btn_Start:ForbidBtn(false)
end


function M:ReceiveEnterState(StackAction)
    self.Super.ReceiveEnterState(self, StackAction)
    EventManager:FireEvent(EventID.GuilfWarLevelSelectReceiveEnterState,StackAction)
    -- self:SelectCellFocus()
end

function M:OnPreRaidRankInfo(arg)

end

function M:OnRaidRankInfo(RankInfo)
    self.RankInfo = RankInfo or {}
    if self.OpenRankTag then
        self:TryOpenRankTopN()
    end
end

function M:OnRaidRankInfoTopN(TopNInfo)
    self.TopNInfo = TopNInfo or {}
    if self.OpenRankTag then
        self:TryOpenRankTopN()
    end
end

function M:DisableEscOnDungeonLoading()
    self.DisableEsc = true
end

-- 刷新入口红点
function M:RefreshEntranceReddot()
    if not GuildWarUtils.IsRaidTime() then -- 赛事期间
        return
    end

    if not self.EventId then
        local RaidSeasons = self:GetRaidSeasons()
        if not RaidSeasons then
            DebugPrint("self.RaidSeasons 不存在")
            return 
        end
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return
        end
        self.EventId = RaidSeasons.EventId
    end

    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(GuildWarUtils.ReddotNodeKey)
    if not CacheDetail or not CacheDetail[self.EventId] then
        self.Btn_Start:SetReddotVisibility(UIConst.VisibilityOp.Collapsed)
        return
    end

    -- 显示 & 隐藏
    if CacheDetail[self.EventId][GuildWarUtils.EntranceCacheKey] then
        self.Btn_Start:SetReddotVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Btn_Start:SetReddotVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

AssembleComponents(M)
return M

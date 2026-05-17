--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR zhangdongxu
-- @DATE ${date} ${time}
--控件名为 WBP_Play_Depute_P
require "UnLua"
local CommonUtils = require "Utils.CommonUtils"
local MonsterUtils = require "Utils.MonsterUtils"
local WalnutBagController = require "BluePrints.UI.WBP.Walnut.WalnutBag.WalnutBagController"
local WalnutBagModel = WalnutBagController:GetModel()
local TimeUtils = require "Utils.TimeUtils"
local EMCache = require "EMCache.EMCache"
local ActivityController = require "BluePrints.UI.WBP.Activity.ActivityController"
---@type WBP_Play_DeputeDetail_C
local M = Class({ "BluePrints.UI.BP_UIState_C" })
M._components = {
    "BluePrints.UI.WBP.Play.Widget.Depute.DoubleModDropView",
}
local TypeSort = {
    Char = 1,
    Weapon = 2,
    Mod = 3,
    Draft = 4,
    Reward = 5,
    Resource = 6,
}


local DungeonSelectCache = {}
function M:Construct()
    M.bOpened = true
    M.Super.Construct(self)
    self.Button_Solo:SetText(GText("DUNGEONSINGLE"))
    self.Button_Multi:SetText(GText("DUNGEONMATCH"))
    self.Text_TypeSelect:SetText(GText("UI_Dungeon_Type_List"))
    self.Text_TypeSelect02:SetText(GText("UI_Armory_ShowAttribute"))
    self.Text_Warning:SetText(GText("UI_Warning_CharLevel_Low"))
    self.Button_Multi:BindEventOnClicked(self, self.OnClickMulti)
    self.Button_Solo:BindEventOnClicked(self, self.ShowDialogChar)
    self.Button_DoubleMod:BindEventOnClicked(self, self.ShowDialogChar)
    --self.Button_Multi:BindForbidStateExecuteEvent(self,self.OnForbiddenLeftBtnClicked)
    self.Stats_ListView.BP_OnEntryInitialized:Add(self, self.OnElementEntryInitialized)
    self.ScrollBox_List.OnUserScrolled:Add(self, self.OnUserScrolled)
    self.Button_Type.OnHovered:Add(self, self.OnButtonAttibuteHovered)
    self.Button_Type.OnUnhovered:Add(self, self.OnButtonAttibuteUnhovered)
    self:AddDispatcher(EventID.OnChangeActionPoint, self, self.UpdateActionPoint)
    self:AddDispatcher(EventID.TeamMatchTimingStart, self, self.TeamMatchTimingStart)
    self:AddDispatcher(EventID.TeamMatchTimingEnd, self, self.TeamMatchTimingEnd)
    self:AddDispatcher(EventID.SelectedWalnut, self, self.EnterWalnutDungeon)
    self:AddDispatcher(EventID.TeamMatchOneRefused, self, function() self:BlockAllUIInput(false) end)
    self:AddDispatcher(EventID.OnRefreshDeputeBtn, self, self.RefreshBtnState)

    self:AddDispatcher(EventID.OnDungeonsUpdate, self, self.OnDungeonsUpdate)
    self:AddDispatcher(EventID.CurrentSquadChange, self, self.OnCurrentSquadChange)
    self:AddDispatcher(EventID.FoucsDungeonSelectLevel,  self, self.OnSelectCellFocus)
    self:AddDispatcher(EventID.OnDisableEscOnDungeonLoading, self, self.DisableEscOnDungeonLoading)

    TeamController:RegisterEvent(self, function(self, EventId, ...)
        if EventId == TeamCommon.EventId.TeamOnInit or EventId == TeamCommon.EventId.TeamLeave then
            self:RefreshBtnState()
        end
    end)

    self.List_Prop.OnCreateEmptyContent:Bind(self, self.CreateAndAddEmptyItem)
    self.List_Prop.BP_OnEntryInitialized:Add(self, function(self, Content, Widget)
        if Content.Id~=0 then
            Widget:BindEvents(self, {
                OnMenuOpenChanged = self.OnStuffMenuOpenChanged,
            })
        end
    end)
    self.List_Event.OnCreateEmptyContent:Bind(self, self.CreateEventAndAddEmptyItem)

    self.HB_Cost:SetVisibility(UE4.ESlateVisibility.Collapsed)
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

    self.List_Event:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self.List_Event:SetNavigationRuleBase(EUINavigation.Up,EUINavigationRule.Stop)
    self.List_Event:SetNavigationRuleBase(EUINavigation.Left,EUINavigationRule.Stop)
    self.List_Event:SetNavigationRuleBase(EUINavigation.Right,EUINavigationRule.Stop)

    self.WB_EliteProp:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self.WB_EliteProp:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    self.WB_EliteProp:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.WB_EliteProp:SetNavigationRuleBase(EUINavigation.Up,EUINavigationRule.Stop)
    

    --self.Cost.Common_Item_Icon.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Remove(self,self.ItemMenuAnchorChanged)
    --self.Cost.Common_Item_Icon.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self,self.ItemMenuAnchorChanged)
    --多余
    --self.Cost:SwitchToPC()
    ---------------------------------多余结束
    self.IsFocusProp = false;
    self.IsFocus_Monster = false;
    self.IsFocusEliteProp = false;

    self.SquadId = 1
    self.MaxMonNum = 2
    self.WalnutId = nil
    self.Mobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
    self.Gamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
    -- if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    --     self:OnSelectCellFocus()
    -- end
    self.FocusTypeName = nil

    self.PressedKeys = {}

    ----多余
    --self.Com_CheckBox_LeftText:BindEventOnClicked({ Inst = self, Func = self.OnDungeonDoubleCost})
    self.Cost:SetVisibility(ESlateVisibility.Collapsed)
    self.Group_Double:SetVisibility(ESlateVisibility.Collapsed)
    self.HB_Counsume:SetVisibility(ESlateVisibility.Collapsed)
    ---------------------------------多余结束

    if self.Arrow_Up then 
        self.Arrow_Up:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Arrow_Down then 
        self.Arrow_Down:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.Btn_Qa:Init({ 
        OwnerWidget = self,
        PopupID = 100241,
        ClickCallback = function()
            UIManager(self):ShowCommonPopupUI(100241)
        end
    })

    self.StyleOfPlay = UIManager(self):GetUIObj("StyleOfPlay")
end


function M:Destruct()
    M.Super.Destruct(self)
    M.bOpened = false
    M.SelectedDungeonId = nil
    self.Button_Multi:UnBindEventOnClickedByObj(self)
    self.Button_Solo:UnBindEventOnClickedByObj(self)
    self.Button_DoubleMod:UnBindEventOnClickedByObj(self)
    TeamController:UnRegisterEvent(self)
    
end

--- 初始化拼接关信息
---@param ChapterId number @拼接关章节Id
---@param DungeonId number @拼接关关卡Id
function M:InitLevelList(DungeonList, SelectDungeonId, DeputeType, WalnutId)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "Play_DeputeDetail", nil)
    local PlayEntry = UIManager(self):GetUIObj("StyleOfPlay")
    if PlayEntry then
        self.CurTabId = PlayEntry.CurTabId
    end
    self:SetFocus()
    self.MonsterIdToItem = {}
    self.TypeTable = {}
    self.TypeTableKeys = {}
    self.HB_Type:ClearChildren()
    --Tabd当前所处页签：用于切换关卡时候处在号令者页签时候判断
    self.CurrentTabIdx = 1
    ---@type Prologue_Map_Level_ListCell_PC_C
    self.SelectCell = nil
    --self.FirstEnter = true
    if not DeputeType then
        self.DeputeType = Const.DeputeType.RegularDepute
    else
        self.DeputeType = DeputeType
    end
   

    if WalnutId then
        self.WalnutId = WalnutId
    end

    ---@type number[] @关卡Id列表
    --local DungeonList = DataMgr.SelectDungeon[ChapterId].DungeonList
    if SelectDungeonId then
        DungeonSelectCache = {}
    end
    if not DungeonList then
        return
    end
    self.ActionPointId = DataMgr.ResourceSType2Resource["ActionPoint"][1]

    local IsNightFlight = (self.DeputeType == Const.DeputeType.NightFlightManualDepute)
    local SubTabList = {
        { Text = GText("UI_DUNGEON_ObtainType"), Id = IsNightFlight and 1 or 2 },
        { Text = GText("UI_DUNGEON_MonsterType"), Id = IsNightFlight and 2 or 3 }
    }
    self.ObtainTabId = IsNightFlight and 2 or 1
    self.MonsterTabId = IsNightFlight and 3 or 2
    if  IsNightFlight then 
        table.insert(SubTabList, 1, { Text = GText("UI_Dungeon_SpecialMonster"), Id = 1 })
        self.SpecialMonsterTabId = 1
    end

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

    self.WB_EliteProp:ClearChildren()
    self.WB_EliteProp:SetVisibility(ESlateVisibility.Collapsed)

    self.Bg_Consume:SetVisibility(ESlateVisibility.Collapsed)

    if self.DeputeType == Const.DeputeType.WalnutDepute then
        if not self.WalnutTypeData then return end
        self.Panel_Walnut:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.HB_WalnutCost:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

        self.Button_Solo:SetText(GText("UI_Walnut_Choice"))
        if self.WalnutTypeTextColor then
            local Text_WalnutMat = self.Text_Walnut:GetDynamicFontMaterial()
            Text_WalnutMat:SetVectorParameterValue("MainColor",self.WalnutTypeTextColor)
        end


        -- 设置核桃头像和名称
        local Icon = LoadObject(self.WalnutTypeData.TypeIcon)
        self.Icon_Walnut:SetBrushResourceObject(Icon)
        self.Text_Walnut:SetText(GText(self.WalnutTypeData.Name))
        self.Text_WalnutCost:SetText(GText("UI_Walnut_Dungeon_Available"))

        self.Panel_WalnutTime:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_WalnutTime:SetText(GText("UI_Walnut_Dungeon_Refresh"))
        self.LeftTimeDict = WalnutBagModel:GetDungeonNextRefreshTime()

        if (self:IsExistTimer("UpdateTimeContent")) then
            self:RemoveTimer("UpdateTimeContent")
        end
        self:UpdateTimeCountDown()
        self:AddTimer(1.0, self.UpdateTimeCountDown, true, 0, "UpdateTimeContent", true)
    else
        self.Panel_Walnut:SetVisibility(ESlateVisibility.Collapsed)
        self.HB_WalnutCost:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_WalnutTime:SetVisibility(ESlateVisibility.Collapsed)
    end



    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    if self.DeputeType == Const.DeputeType.DeputeWeekly then
        self.HB_Weekly:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Bg_Consume:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.WeeklyDungeonRewardLeft = Avatar.WeeklyDungeonRewardLeft
        self.Text_WeeklyDescNumNow:SetText(self.WeeklyDungeonRewardLeft)
        self.Text_WeeklyDescNumTotal:SetText(DataMgr.GlobalConstant.DungeonRewardRefresh.ConstantValue)
        if self.WeeklyDungeonRewardLeft > 0 then
            if self.ColorNowNormal then
                self.Text_WeeklyDescNumNow:SetColorAndOpacity(self.ColorNowNormal)
            else
                self.Text_WeeklyDescNumNow:SetColorAndOpacity(self.ColorNowEmpty)
            end
        end
        self.Text_WeeklyDescNumTitle:SetText(GText("UI_WeeklyDungeon_ChancesRemain"))
    else
        self.HB_Weekly:SetVisibility(ESlateVisibility.Collapsed)
    end

    -- 查找最新解锁的关卡Id
    local LatestUnlockedDungeonId = nil
    for _, DungeonId in pairs(DungeonList) do
        if PageJumpUtils:CheckDungeonCondition(DataMgr.Dungeon[DungeonId].Condition) then
            LatestUnlockedDungeonId = DungeonId
        end
    end

    for i, DungeonId in pairs(DungeonList) do
        ---@type Prologue_Map_Level_ListCell_PC_C
        local Item = self:CreateWidgetNew("DungeonSelectLevel")
        Item:BindEventOnClicked(self, self.OnClickedLevelCell, Item)
        if self.DeputeType == Const.DeputeType.RegularDepute or self.DeputeType == Const.DeputeType.DeputeWeekly then
            Item:InitDungeonInfo(DungeonId, i, false, self)
        else
            Item:InitDungeonInfo(DungeonId, i, true, self)
        end

        -- 如果未指定关卡Id，则默认选中第一个关卡
        -- 如果指定了关卡Id：
        -- 如果SelectDungeonId是正常关卡，用DungeonId == SelectDungeonId 判断
        -- 如果SelectDungeonId是子级关卡，用DungeonId  == Dungeon2SubDungeon[SelectDungeonId] 判断

        -- 判断是否为最新解锁的关卡
        local ShouldSelect =
            (not SelectDungeonId and DungeonId == LatestUnlockedDungeonId) or
            (SelectDungeonId == DungeonId) or (DataMgr.Dungeon2SubDungeon[SelectDungeonId] == DungeonId)

        if ShouldSelect then
            -- 如果关卡未解锁，则不选中
            if PageJumpUtils:CheckDungeonCondition(DataMgr.Dungeon[DungeonId].Condition) then
                self.SelectCell = Item
                --Item.Bg_List.Button_Area:SetFocus() self.ScrollBox_List:GetChildAt(0).
                Item.Bg_List.IsSelect = true
                Item.Bg_List:PlayAnimation(Item.Bg_List.Select)
                Item:PlayAnimation(Item.Select)
                -- 记录父级Cell的Id，以便缓存父级Cell上次选择的属性关卡Id
                self.CurCellDungeonId = SelectDungeonId and DataMgr.Dungeon2SubDungeon[SelectDungeonId] or DungeonId
                self:InitListCellInfo(SelectDungeonId or DungeonId)
            else
                self.Panel_Detail:SetVisibility(ESlateVisibility.Collapsed)
            end
        end
        self.ScrollBox_List:AddChild(Item)
    end
    if self.SelectCell then
        self:SelectCellFocus() --.Bg_List.Button_Area
        self.ScrollBox_List:ScrollWidgetIntoView(self.SelectCell, true, EDescendantScrollDestination.Center)
    end


    self.ScrollBox_List:GetChildAt(0):SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.ScrollBox_List:GetChildAt(self.ScrollBox_List:GetChildrenCount() - 1):SetNavigationRuleBase(EUINavigation.Down,
        EUINavigationRule.Stop)

    self:PlayAnimation(self.In)

    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:UpdateUIStyleInPlatform(false)
    end
end

--设置核桃字体颜色
function M:SetWalnutTitleMatColor(WalnutType)
    if WalnutType == 1 then
        self.WalnutTypeTextColor = self.Sx_Text_WalnutTypeTitleMatColor
    elseif WalnutType == 2 then
        self.WalnutTypeTextColor =  self.Zl_Text_WalnutTypeTitleMatColor
    else
        self.WalnutTypeTextColor = self.Hl_Text_WalnutTypeTitleMatColor
    end
end

function M:UpdateTimeCountDown()
    local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(self.LeftTimeDict)
    self.Time_Refresh:SetTimeText("UI_Walnut_Dungeon_Refresh", RemainTimeDict)
end


--设置详情面板
function M:SetPanelDetails(Idx)
    self.Com_Btn_Details:UnBindEventOnClickedByObj(self)
    if Idx == self.ObtainTabId then
        self.Com_Btn_Details:BindEventOnClicked(self, self.OpenRewardDetails)
        self.Text_Details:SetText(GText("UI_CTL_Details"))
        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            self.Switch_Details_Icon:SetActiveWidgetIndex(2)
            self.Key_Details_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Key_Details_GamePad:CreateCommonKey({
                KeyInfoList = {
                    {
                        Type = "Img",
                        ImgShortPath = "Down",
                    },
                },
            })
        else
            self.Switch_Details_Icon:SetActiveWidgetIndex(1)
            if not self.Mobile then
                self.Key_Details_GamePad:SetVisibility(ESlateVisibility.Collapsed)
            end
            
        end
    else
        --self.Btn_Details.OnClicked:Add(self, self.OpenCommanderDetails)
        self.Com_Btn_Details:BindEventOnClicked(self, self.OpenCommanderDetails)
        self.Text_Details:SetText(GText("UI_Dungeon_More"))
        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            self.Switch_Details_Icon:SetActiveWidgetIndex(2)
            self.Key_Details_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Key_Details_GamePad:CreateCommonKey({
                KeyInfoList = {
                    {
                        Type = "Img",
                        ImgShortPath = "Down",
                    },
                },
            })
        else
            self.Switch_Details_Icon:SetActiveWidgetIndex(0)
            if not self.Mobile then
                self.Key_Details_GamePad:SetVisibility(ESlateVisibility.Collapsed)
            end
        end
    end
end
---@param TabWidget Common_Tab_Item_PC_C
function M:OnSubTabChanged(TabWidget)
    self.CurrentTabIdx = TabWidget.Idx
    self:PlayAnimation(self.Switch_Tab)
    if TabWidget.Idx == self.ObtainTabId then
        self.List_Prop:SetVisibility(ESlateVisibility.Visible)
        self.List_Monster:SetVisibility(ESlateVisibility.Collapsed)
        self.List_Event:SetVisibility(ESlateVisibility.Collapsed)
        self:SetPanelDetailsVis(ESlateVisibility.SelfHitTestInvisible)
        self.WB_EliteProp:SetVisibility(ESlateVisibility.Collapsed)

        if self.CurrentFocusType == "List" then
            self.List_Prop:SetFocus()
            self:UpdatKeyDisplay("RewardWidget")
        end
        self.Btn_Area.OnClicked:Add(self, self.OpenIntro)
        self:SetPanelDetails(TabWidget.Idx)
    elseif TabWidget.Idx == self.MonsterTabId then
        self.List_Prop:SetVisibility(ESlateVisibility.Collapsed)
        self.List_Monster:SetVisibility(ESlateVisibility.Visible)
        self.List_Event:SetVisibility(ESlateVisibility.Collapsed)
        self:SetPanelDetailsVis(ESlateVisibility.Collapsed)
        self.WB_EliteProp:SetVisibility(ESlateVisibility.Collapsed)

        if self.CurrentFocusType == "List" then
            self.List_Monster:SetFocus()
            self:UpdatKeyDisplay("RewardWidget")
        end
    elseif self.TitleEventTabId and TabWidget.Idx == self.TitleEventTabId then
        self.List_Event:SetVisibility(ESlateVisibility.Visible)
        self.List_Prop:SetVisibility(ESlateVisibility.Collapsed)
        self.List_Monster:SetVisibility(ESlateVisibility.Collapsed)
        self:SetPanelDetailsVis(ESlateVisibility.Collapsed)
        self.WB_EliteProp:SetVisibility(ESlateVisibility.Collapsed)
        if self.CurrentFocusType == "List" then
            self.List_Event:SetFocus()
            self:UpdatKeyDisplay("EventWidget")
        end
    end
    self:SetNightFlightManualText_MoreHide(TabWidget.Idx)
end

function M:IsShowKeyMore()
    if self.CurrentTabIdx == self.SpecialMonsterTabId then
        return self.MonNum and self.MonNum > self.MaxMonNum
    end
    return self.CurrentTabIdx == self.ObtainTabId
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

--设置夜航手册更多按钮的显隐
function M:SetNightFlightManualText_MoreHide(Idx)
    if self.DeputeType == Const.DeputeType.NightFlightManualDepute then 
        if Idx == self.SpecialMonsterTabId then
            --这里调一次显示号令者是因为必须在显示情况下 item填充才有效
            self:SetNightFlightManualEliteProp(self.CurSelectedDungeonId)
            if self.MonNum and self.MonNum > self.MaxMonNum then
                self:SetPanelDetails(Idx)
                self:SetPanelDetailsVis(ESlateVisibility.SelfHitTestInvisible)
                self.List_Prop:SetVisibility(ESlateVisibility.Collapsed)
                self.List_Monster:SetVisibility(ESlateVisibility.Collapsed)
            else
                self:SetPanelDetailsVis(ESlateVisibility.Collapsed)
                --self.Btn_More:SetVisibility(ESlateVisibility.Collapsed)
                self.List_Prop:SetVisibility(ESlateVisibility.Collapsed)
                self.List_Monster:SetVisibility(ESlateVisibility.Collapsed)
                --self.Text_More:SetVisibility(ESlateVisibility.Collapsed)
            end
            self.WB_EliteProp:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

            if self.CurrentFocusType == "List" and self.WB_EliteProp:GetChildAt(0) then
                self.WB_EliteProp:GetChildAt(0):SetFocus()
            end
        end

    end
end

function M:SetNightFlightManualRewardView(DungeonRewardView)
    self.DungeonRewardView = DungeonRewardView
end
---设置夜航手册怪物显示
function M:SetNightFlightManualEliteProp(DungeonId)
    self.WB_EliteProp:ClearChildren()
    self.MonsterWeaknessIconCache = {}
    -- 获取怪物数据
    local MonIds = DataMgr.ModDungeon2Monster[DungeonId]
    if not MonIds or #MonIds == 0 then
        DebugPrint("SL No monsters found for DungeonId:", DungeonId)
        return
    end
    self.MonNum = CommonUtils.TableLength(MonIds)
    -- 获取怪物数量，最多处理 2 个怪物
    local Num = math.min(self.MonNum, 2)

    for i = 1, Num do
        local Id = MonIds[i]
        local Item = self:CreateWidgetNew("DeputeEliteInfo")
        local WeaknessIcon = self:GetMonsterWeaknessIcon(Id)
        Item:InitItemContent(Id, WeaknessIcon, self,self.DungeonRewardView)        
        self.WB_EliteProp:AddChild(Item)
    end 

    if self.WB_EliteProp:GetChildrenCount() <= 1 then
        local Item = self:CreateWidgetNew("DeputeEliteInfo")
        Item:InitItemContent()
        self.WB_EliteProp:AddChild(Item)
    end

    -- 最多处理 2 个怪物多了也放不下 先这么写导航
    if self.WB_EliteProp:GetChildrenCount() == 1 then
        self.WB_EliteProp:GetChildAt(0):SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
        self.WB_EliteProp:GetChildAt(0):SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
        self.WB_EliteProp:GetChildAt(0):SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
        -- if self.WB_Event:GetChildAt(0) then
        --     self.WB_EliteProp:GetChildAt(0):SetNavigationRuleCustom(EUINavigation.Up, { self, function()
        --         self:UpdatKeyDisplay("EventWidget")
        --         self.CurrentFocusType = "WB_Event";
        --         return self.WB_Event:GetChildAt(0)
        --     end })
        -- else
        --     self.WB_EliteProp:GetChildAt(0):SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
        -- end

    elseif self.WB_EliteProp:GetChildrenCount() == 2 and self.WB_EliteProp:GetChildAt(1).Id then
        self.WB_EliteProp:GetChildAt(0):SetNavigationRuleExplicit(EUINavigation.Right, self.WB_EliteProp:GetChildAt(1))
        self.WB_EliteProp:GetChildAt(0):SetNavigationRuleExplicit(EUINavigation.Left, self.WB_EliteProp:GetChildAt(1))
        self.WB_EliteProp:GetChildAt(1):SetNavigationRuleExplicit(EUINavigation.Left, self.WB_EliteProp:GetChildAt(0))
        self.WB_EliteProp:GetChildAt(1):SetNavigationRuleExplicit(EUINavigation.Right, self.WB_EliteProp:GetChildAt(0))
    
        self.WB_EliteProp:GetChildAt(0):SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
        self.WB_EliteProp:GetChildAt(1):SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)

        -- if self.WB_Event:GetChildAt(0) then
        --     self.WB_EliteProp:GetChildAt(0):SetNavigationRuleCustom(EUINavigation.Up, { self, function()
        --         self:UpdatKeyDisplay("EventWidget")
        --         self.CurrentFocusType = "WB_Event";
        --         return self.WB_Event:GetChildAt(0)
        --     end })

        --     self.WB_EliteProp:GetChildAt(1):SetNavigationRuleCustom(EUINavigation.Up, { self, function()
        --         self:UpdatKeyDisplay("EventWidget")
        --         self.CurrentFocusType = "WB_Event";
        --         return self.WB_Event:GetChildAt(0)
        --     end })
        -- else
        --     self.WB_EliteProp:GetChildAt(0):SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
        --     self.WB_EliteProp:GetChildAt(1):SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
        -- end
    end  
end

-- function M:SetEventFocus(Index)
--     if self.WB_Event:GetChildrenCount() < 1 then return end
--     if self.WB_Event:GetChildAt(Index) then
--         self.WB_Event:GetChildAt(Index).Btn:SetFocus()
--         self.CurrentFocusType = "WB_Event";
--         self:UpdatKeyDisplay("EventWidget")
--     end
-- end

--设置夜航号令者的弱点属性
function M:GetMonsterWeaknessIcon(MonsterId)
    local MonsterWeaknessIcon = self.MonsterWeaknessIconCache or {}

    self.MonsterWeaknessIconCache = MonsterWeaknessIcon

    if MonsterWeaknessIcon[MonsterId] then
        return MonsterWeaknessIcon[MonsterId]
    end

    local AllBuffs = MonsterUtils.GetRealMonsterBuffs(self.CurSelectedDungeonId, MonsterId)

    -- 遍历怪物的所有Buff，查找弱点图标
    for _, BuffId in ipairs(AllBuffs) do
        local BuffInfo = DataMgr.Buff[BuffId]
        if BuffInfo and BuffInfo.WeaknessType then
            local WeaknessIcon = DataMgr.DamageType[BuffInfo.WeaknessType] and
                DataMgr.DamageType[BuffInfo.WeaknessType].WeaknessIcon
            if WeaknessIcon then
                MonsterWeaknessIcon[MonsterId] = MonsterWeaknessIcon[MonsterId] or {}

                MonsterWeaknessIcon[MonsterId][WeaknessIcon] = true
            end
        end
    end

    return MonsterWeaknessIcon[MonsterId]
end

--设置核桃类型显示
function M:SetWalnutType(WalnutTypeData)
    self.WalnutTypeData = WalnutTypeData
end

--- LevelCell点击响应方法
---@param LevelCell Prologue_Map_Level_ListCell_PC_C @关卡Cell
function M:OnClickedLevelCell(LevelCell)
    if self.SelectCell ~= nil then
        self.SelectCell:PlayAnimationReverse(self.SelectCell.Select)
        local SubCell = self.SelectCell.Bg_List
        SubCell:StopAllAnimations()
        SubCell:PlayAnimation(SubCell.Normal)
        SubCell.IsSelect = false
    end
    self.SelectCell = LevelCell
    --- 清空属性选择Item列表
    self.TypeTable = {}
    self.TypeTableKeys = {}
    self.HB_Type:ClearChildren()
    --- 初始化关卡详情内容
    self.LastMarkType = nil
    self.CurCellDungeonId = LevelCell.DungeonId
    self:InitListCellInfo(LevelCell.DungeonId)
end

--- 属性选择按钮点击响应方法
---@param TypeId number @属性Id[DungeonId]
function M:OnTypeClicked(TypeId, bDefault)
    DungeonSelectCache[self.CurCellDungeonId] = TypeId
    local DungeonAttribute = DataMgr.Dungeon[TypeId].AttributeType
    self.DungeonAttribute = DungeonAttribute
    self:SetElementIcon(DungeonAttribute)
    self:IsShowAttributeTips()

    self.TypeTable[TypeId]:OnClicked(bDefault)
    if self.LastMarkType and self.LastMarkType ~= self.TypeTable[TypeId] then
        self.LastMarkType.IsSelect = false
        self.LastMarkType:PlayAnimation(self.LastMarkType.Normal)
    end
    self.LastMarkType = self.TypeTable[TypeId]
    self.CurSelectedDungeonId = TypeId
    M.SelectedDungeonId = TypeId
    self:RefreshLevelCellContent(TypeId)
end

function M:IsShowAttributeTips()
    if not self.DungeonAttribute then
        return
    end
    local CurrentCharId = self.DefaultList.CurrentCharId  --拿到当前选择的阵容角色
    if CurrentCharId then
        local CharAttributeType = DataMgr.BattleChar[CurrentCharId].Attribute
        if DataMgr.Attribute[CharAttributeType].CounterType ~= self.DungeonAttribute then
            for ID, Config in pairs(DataMgr.Attribute) do
                if Config.CounterType == self.DungeonAttribute then
                    local TipsText = string.format(GText("UI_Squad_Elemental_Weakness"),
                        GText("UI_Attr_" .. Config.ID .. "_Name"))
                    self.Text_Warning_Attribute:SetText(TipsText)
                    break
                end
            end
            self.Panel_WarningHint_Attribute:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            self.Panel_WarningHint_Attribute:SetVisibility(ESlateVisibility.Collapsed)
        end
    else
        self.Panel_WarningHint_Attribute:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

--- 初始化初始化关卡详情内容
--- 判断是父级Cell还是普通Cell来初始化Cell的内容
function M:InitListCellInfo(DungeonId)
     local DungeonData = DataMgr.Dungeon[DungeonId]
     if not DungeonData then return end
     self.DungeonData = DungeonData
    --自动轮次初始化
     self:AutoNextRoundInit()
    if self.SelectCell then
        self:SelectCellFocus()
    end
    local Dungeon2SubDungeon = DataMgr.Dungeon2SubDungeon
    self.CurSelectedDungeonId = DungeonId
    M.SelectedDungeonId = DungeonId
    self.HasTypeSelect = false
    self.Stats:SetRenderOpacity(0)


    self:RefreshDeputeEvent(DungeonId)
    if not self.TitleEventTabId and self.List_Event:GetNumItems() > 0 then
        local SubTabList = self.Tab_Info.Tabs
        local Id = #self.Tab_Info.Tabs + 1
        table.insert(SubTabList, Id, { Text = GText("UI_Dungeon_Title_Event"), Id = Id})
        self.TitleEventTabId = Id
        self.Tab_Info:UpdateTabs(SubTabList)
    end
    self.Tab_Info:SelectTab(1)
    --根据是否启用阵容预设来判断是否显示阵容预设
    local bSquad = DataMgr.Dungeon[self.CurSelectedDungeonId].Squad
    if bSquad then
        self.DefaultList:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        local DungeonType = DataMgr.Dungeon[self.CurSelectedDungeonId].DungeonType
        local bDisablePhantom = DungeonType == "Rouge" or false

        local Avatar = GWorld:GetAvatar()
        if Avatar then
            local SquadId = Avatar.DungeonSquad[DungeonType] and Avatar.DungeonSquad[DungeonType] or 0
            self.DefaultList:Init(self, bDisablePhantom, SquadId,self.CurSelectedDungeonId)
            --self.DefaultList:UpdateCurrentDungeonSquad(SquadId)
        end
    else
        self.DefaultList:SetVisibility(ESlateVisibility.Collapsed)
    end

    --- 如果DungeonId是父级 or 子级，加载Dungeon[Dungeon2SubDungeon[DungeonId]]所有SubDungeonList的选择信息
    if Dungeon2SubDungeon[DungeonId] then
        self.List_Type:SetVisibility(ESlateVisibility.Visible)
        self.Panel_Type:SetVisibility(ESlateVisibility.Visible)
        if not self.Mobile then
            if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
                self.Key_Qa_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            else
                self.Key_Qa_GamePad:SetVisibility(ESlateVisibility.Collapsed)
            end
        end
        --- 对属性进行排序
        local SubDungeonList = DataMgr.Dungeon[Dungeon2SubDungeon[DungeonId]].SubDungeonId
        local SubDungeonData = {}
        table.insert(SubDungeonData, Dungeon2SubDungeon[DungeonId])
        if not SubDungeonList then
            DebugPrint("ZDX SubDungeonList is nil")
            return
        end
        for k, v in pairs(SubDungeonList) do
            table.insert(SubDungeonData, v)
            if not DataMgr.Dungeon[v].AttributeType then
                DebugPrint("ZDX Dungeon AttributeType is nil")
            end
        end
        table.sort(SubDungeonData, function(A, B)
            local PriorityA = DataMgr.Attribute[DataMgr.Dungeon[A].AttributeType].DisplayPriority
            local PriorityB = DataMgr.Attribute[DataMgr.Dungeon[B].AttributeType].DisplayPriority
            return PriorityA < PriorityB
        end)
        --- 加载属性选择按钮Item
        for k, v in pairs(SubDungeonData) do
            local Item = self:CreateWidgetNew("DeputeTypeIcon")
            Item:InitContent(DataMgr.Dungeon[v].AttributeType)
            Item.Button_Area.OnClicked:Add(self, function()
                self:OnTypeClicked(v)
            end)
            Item.Select = true
            self.HB_Type:AddChild(Item)
            self.TypeTable[v] = Item
            table.insert(self.TypeTableKeys, v)
        end
        self:OnTypeClicked(DungeonSelectCache[self.CurSelectedDungeonId] or self.CurSelectedDungeonId, true)
        --- 标记当前Cell是一个父级Cell
        self.HasTypeSelect = true
    else
        self.List_Type:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_Type:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_WarningHint_Attribute:SetVisibility(ESlateVisibility.Collapsed)
        --- 刷新关卡介绍内容
        self:RefreshLevelCellContent(self.CurSelectedDungeonId)
    end

    -- 不是夜航，直接收起并返回
    local IsNightFlight = (self.DeputeType == Const.DeputeType.NightFlightManualDepute)
    if not IsNightFlight then
        self.Group_TimeTips:SetVisibility(ESlateVisibility.Collapsed)
        return
    end
    
    -- 没有配置直接收起
    local EventId = ActivityController:GetDoubleModDropEventID()
    local CfgDrop = DataMgr.DoubleModDrop and DataMgr.DoubleModDrop[EventId]
    if not CfgDrop then
        self.Group_TimeTips:SetVisibility(ESlateVisibility.Collapsed)
        return
    end
    
    local IsDoubleModDungeon, IsEliteRushDungeon = self:CheckDungeonType(DungeonId)
    if not (IsDoubleModDungeon or IsEliteRushDungeon) then
        self.Group_TimeTips:SetVisibility(ESlateVisibility.Collapsed)
        return
    end

    -- 是否开启活动
    self.IsDoubleModOpen = self:IsDoubleMod()
    if not self.IsDoubleModOpen then
        self.Group_TimeTips:SetVisibility(ESlateVisibility.Collapsed)
        return
    end
    self.Text_ModUpNum:SetVisibility(UE4.ESlateVisibility.Collapsed)
    local _, IsEliteRushDungeon = self:CheckDungeonType(self.CurSelectedDungeonId)
    self.Group_TimeTips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Bg_Consume:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    
    local DropInfo = self:GetDoubleModDropData() or {}
    local IsElite = IsEliteRushDungeon--EMCache:Get("Is_DoubleMod_SwitchTab", true) or false
    local TitleKey = IsElite and "UI_Event_ModDrop_ChallengeRemain" or "UI_Event_ModDrop_DropRemain"
    self.Text_TimeTipsTitle:SetText(GText(TitleKey))
    
    -- 读取次数配置
    local MdConst   = DataMgr.ModDropConstant or {}
    local DailyFree = (MdConst.DailyFreeTicketAmount and MdConst.DailyFreeTicketAmount.ConstantValue) or 0
    local DailyMod  = (MdConst.DailyModDungeonAmount   and MdConst.DailyModDungeonAmount.ConstantValue) or 0
    local CfgValue  = IsElite and DailyFree or DailyMod
    
    -- 已用/剩余
    local UsedTimes = IsElite and (DropInfo.EliteRushTimes or 0) or (DropInfo.DropTimes or 0)
    local Remaining = math.max(0, math.floor(CfgValue - UsedTimes))
    local TextValue = (Remaining <= 0) and ("<Warning>0</>/" .. CfgValue) or (Remaining .. "/" .. CfgValue)
    self.Text_Times:SetText(TextValue)
    
    -- 百分比仅在普通模式显示
    if not IsElite then
        local BonusConst = (MdConst.EventBonus and MdConst.EventBonus.ConstantValue) or 0
        local BonusPct   = math.floor(BonusConst / 100)
        self.Text_ModUpNum:SetText("+" .. BonusPct .. "%")
        self.Text_ModUpNum:SetVisibility(Remaining <= 0 and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    
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

    -- 设置关卡名、等级、描述、类型等
    self.Title_Level:SetText(GText(DungeonData.DungeonName))
    self.Text_Summary:SetText(GText(DungeonData.DungeonDes))
    self.Text_Description:SetText(GText(DungeonData.DungeonContent))

    self.Btn_Check.Btn_Click.OnClicked:Add(self, self.OpenDetails)
    self.Btn_Detail:SetVisibility(ESlateVisibility.Collapsed)

    if DungeonData.AttributeType then
        self.Type:SetVisibility(ESlateVisibility.Visible)
        self.Icon_Type:SetBrushResourceObject(LoadObject(DataMgr.Attribute[DungeonData.AttributeType].Icon))
    else
        self.Type:SetVisibility(ESlateVisibility.Collapsed)
    end
    -- 获取玩家体力信息
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end

    self:PlayAnimation(self.Switch_Type)
    -- 刷新怪物信息列表和奖励信息列表
    self:RefreshMonsterInfoList(DungeonId)
    self:RefreshRewardInfoList(DungeonId)
    self:RefreshBtnState()

    if self.DeputeType == Const.DeputeType.NightFlightManualDepute and self.CurrentTabIdx == self.SpecialMonsterTabId then
        self:SetNightFlightManualEliteProp(DungeonId)
    end
    self:SetNightFlightManualText_MoreHide(self.CurrentTabIdx)

    self.Btn_Qa.Btn_Click.OnClicked:Add(self, self.OpenIntro)

    self.Panel_WarningHint:SetVisibility(ESlateVisibility.Collapsed)
    --Avatar.Chars[Avatar.CurrentChar].Level
    if  self.DefaultList.CurrentCharLevel <= DataMgr.Dungeon[self.CurSelectedDungeonId].DungeonLevel - DataMgr.GlobalConstant.TaskWarningLevel.ConstantValue then
        self.Panel_WarningHint:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end

    --加载关卡背景
    local DungeonUIBG = DungeonData and DungeonData.DungeonUIBG or Const.DungeonBgBluePrint
    if self.DungeonUIBG then
        if self.DungeonUIBG == DungeonUIBG then
            return
        end
    end
    self.DungeonUIBG = DungeonUIBG
    local Item = UIManager(self):CreateWidget(DungeonUIBG)
    --if self.DeputeType == Const.DeputeType.RegularDepute then
    --self.Panel_Bg:ClearChildren()
    --else
    --self.Panel_Bg:ClearChildren()
    local ChildrenCount = self.Panel_Bg:GetChildrenCount()

    -- 确保最多 2 个背景避免累积
    if ChildrenCount >= 2 then
        self.Panel_Bg:RemoveChildAt(0)
    end

    -- 延迟删除旧背景防止穿帮
    local OldItem = (ChildrenCount > 0) and self.Panel_Bg:GetChildAt(0) or nil
    if OldItem then
        self:AddDelayFrameFunc(function()
            if OldItem and OldItem:IsValid() then
                self.Panel_Bg:RemoveChild(OldItem)
            end
        end, 8, "RemoveOldDungeonBG")
    end
    --end

    if Item then
        self.Panel_Bg:AddChild(Item)

        -- 播放动画
        if Item.Loop then
            Item:PlayAnimation(Item.Loop, 0, 0)
        end

        Item.Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
        Item.Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
        if Item.In then
            Item:PlayAnimation(Item.In)
            -- if self.DeputeType == Const.DeputeType.RegularDepute and self.FirstEnter then
            --     Item:PlayAnimation(Item.In)
            -- elseif self.DeputeType ~= Const.DeputeType.RegularDepute then
            --     Item:PlayAnimation(Item.In)
            -- end
        end

        -- if self.DeputeType == Const.DeputeType.RegularDepute then
        --     self.FirstEnter = false
        -- end
       -- Item:PlayAnimation(Item.In)
    else
        DebugPrint("SL DungeonUIBG Create Failed")
    end
end

---自动轮次功能初始化
function M:AutoNextRoundInit()
    if  self.DungeonData.DungeonWinMode ~= 1 or not self.DungeonData.AutoNextRound then
        self.AutoNextRound:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end
    self.AutoNextRound:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.AutoNextRound:Init(self.DungeonData)
end

function M:CheckDungeonType(DungeonId)
    local EventId = ActivityController:GetDoubleModDropEventID()
    local CfgDrop = DataMgr.DoubleModDrop and DataMgr.DoubleModDrop[EventId]
    if not DungeonId or not CfgDrop then
        return false, false
    end

    local DungeonIds          = CfgDrop.ModDungeonId or {}
    local EliteRushDungeonIds = CfgDrop.EliteRushDungeonId or {}

    local IsDoubleModDungeon = false
    for _, V in pairs(DungeonIds) do
        if DungeonId == V then
            IsDoubleModDungeon = true
            break
        end
    end

    local IsEliteRushDungeon = false
    if not IsDoubleModDungeon then
        for _, V in pairs(EliteRushDungeonIds) do
            if DungeonId == V then
                IsEliteRushDungeon = true
                break
            end
        end
    end

    return IsDoubleModDungeon, IsEliteRushDungeon
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
    Params.Checked = self.Com_CheckBox_LeftText:IsChecked()
    local UI = UIManager(self):ShowCommonPopupUI(100156, Params)
    --UI:ShowGamepadScrollBtn(true)
end

--打开号令者详情
function M:OpenCommanderDetails()
    local Params = {}
    Params.DungeonId = self.CurSelectedDungeonId
    Params.Parent = self
    Params.AutoFocus = true
    local UI = UIManager(self):ShowCommonPopupUI(100155, Params)
    --UI:ShowGamepadScrollBtn(true)
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
    local IsInTimeRange,RewardConfig  = self:IsInTimeRange(DungeonId)
    if IsInTimeRange and RewardConfig then
        local EventDungeonRewardList = RewardUtils:GetRewardViewInfoById(RewardConfig.RewardView)
        table.sort(EventDungeonRewardList, SortFunc)
        for _, v in ipairs(EventDungeonRewardList) do
            table.insert(self.RewardList, v)
        end
    end

    local CheckBoxIsChecked = self.Com_CheckBox_LeftText:IsChecked()

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

        -- 状态判断是否翻倍
        if  BaseCount then
            if CheckBoxIsChecked and not ItemData.bFirst then
                Content.Count = BaseCount * 2
            else
                Content.Count = BaseCount
            end
        end

        -- 处理置灰状态
        Content.bShadow = false
        if Content.ItemType == "Mod" then
            local ModModel = ModController:GetModel()
            Content.bShadow = ModModel:GetModCountById(Content.Id) <= 0
        elseif Content.ItemType == "Walnut" then
            local WalnutsInBag = Avatar.Walnuts.WalnutBag
            Content.bShadow = (WalnutsInBag[Content.Id] or 0) <= 0
        end


        self.List_Prop:AddItem(Content)
    end

    if self.List_Prop:GetNumItems()==0 then
        self.List_Prop:AddItem(self:CreateAndAddEmptyItem())
    end
    self.List_Prop:RequestFillEmptyContent()
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

function M:CreateEventAndAddEmptyItem()
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.IsEmpty = true
    return Content
end

function M:CreateAndAddEmptyItem()
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = 0
    return Content
end

function M:OnStuffMenuOpenChanged(bIsOpen)
    if (UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad) then
        return
    end
    self.MenuOpen = bIsOpen
    if (bIsOpen) then
        self.Button_Multi:SetPCVisibility(true)
        self.Button_Solo:SetPCVisibility(true)
        self.Button_DoubleMod:SetPCVisibility(true)
        self:UpdatKeyDisplay("")
        self.Switch_Details_Icon:SetActiveWidgetIndex(self.CurrentTabIdx == self.ObtainTabId and 0 or 1)
    else
        self.Button_Multi:SetPCVisibility(false)
        self.Button_Solo:SetPCVisibility(false)
        self.Button_DoubleMod:SetPCVisibility(true)
        self:UpdatKeyDisplay("RewardWidget")
        self.List_Prop:SetFocus()
        self.Switch_Details_Icon:SetActiveWidgetIndex(2)
    end
end


---刷新委托中可能出现的动态事件信息
function M:RefreshDeputeEvent(DungeonId)
    local uniqueEventTypeSet = {}
    for _, EventData in pairs(DataMgr.DungeonRandomEvent) do
        for _, Id in ipairs(EventData.Dungeons) do
            if Id == DungeonId then
                -- 如果包含，将事件类型存入集合
                uniqueEventTypeSet[EventData.EventType] = true
                break
            end
        end
    end

    -- 提取唯一的事件类型
    local UniqueEventTypeList = {}
    for EventType, _ in pairs(uniqueEventTypeSet) do
        table.insert(UniqueEventTypeList, EventType)
    end


    self.List_Event:ClearListItems()
    for Index = 1, #UniqueEventTypeList do
        local eventType = UniqueEventTypeList[Index]
        local Icon = DataMgr.DungeonRandomEventType[eventType] and DataMgr.DungeonRandomEventType[eventType].Icon
        local Des = DataMgr.DungeonRandomEventType[eventType] and DataMgr.DungeonRandomEventType[eventType].Des
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Id =  Index
        Content.Icon = Icon
        Content.Des = Des
        self.List_Event:AddItem(Content)
    end
    -- if self.List_Event:GetNumItems()==0 then
    --     self.List_Event:AddItem(self:CreateEventAndAddEmptyItem())
    -- end
    if #UniqueEventTypeList > 0 then
        self.List_Event:RequestFillEmptyContent()
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
        if MonsterData and GameState.IsUnitRelease(MonsterId) then
            local Content = NewObject(self.MonsterItemContentClass)
            Content.ParentWidget = self
            Content.MonsterId = MonsterId
            Content.DisableSelect = true
            Content.SoundEvent = "event:/ui/common/click_mid"
            -- 怪物图标
            Content.WeaknessIcon = self.MonsterWeaknessIcon[MonsterId]
            self.List_Monster:AddItem(Content)
        end
    end
    -- self:AddTimer(0.01, function()
    --     --这里设置一下怪物的导航
    --     local len = self.List_Monster:GetNumItems()
    --     for i = 1, len do
    --         local entryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Monster,
    --             i - 1)
    --         if entryWidget and self.WB_Event:GetChildAt(0) then
               
    --             entryWidget:SetNavigationRuleExplicit(EUINavigation.Up, self.WB_Event:GetChildAt(0))
    --         end
    --     end
    -- end, false, 0, "DeputeDetailListView_List_Monster")
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

-- 判断是否是海尔法推车
function M:ShowDialogChar()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local bIsInTeam = Avatar:IsInTeam()

    if not bIsInTeam and Avatar.Chars[Avatar.CurrentChar] and Avatar.Chars[Avatar.CurrentChar].CharId == 3201 and DataMgr.Dungeon[self.CurSelectedDungeonId].DungeonType == "Hijack" then
        local Param = {
            RightCallbackObj = self,
            RightCallbackFunction = self.OnClickSolo
        }
        UIManager(self):ShowCommonPopupUI(100106, Param, self)
    elseif self.DeputeType == Const.DeputeType.DeputeWeekly and self.WeeklyDungeonRewardLeft <= 0 then
        local IsDeputeWeeklyNum = EMCache:Get("Is_DeputeWeeklyNum", true) or false
        local IsNoMorePrompts = self:CheckNeedShowWindow()
        if IsDeputeWeeklyNum and IsNoMorePrompts then
            self:OnClickSolo()
        else
            self:ShowConfirmWindow(true)
        end
    else
        if self.DeputeType == Const.DeputeType.DeputeWeekly then
            local Dungeon = Avatar.Dungeons[self.CurSelectedDungeonId]
            local bPassCount = Dungeon and Dungeon.PassCount == 1 or false --周本首次是否胜利过
            if not bPassCount then
                self:ShowFirstDeputeWeeklyConfirmWindow(true)
            else
                self:OnClickSolo()
            end
            return
        end
        self:OnClickSolo()
    end
end


function M:ShowFirstDeputeWeeklyConfirmWindow(bIsSolo)
    local CommonDialogParams = {}
    CommonDialogParams.RightCallbackFunction = function(_, Data) 
        if bIsSolo then
            self:OnClickSolo()
        else
            self:TryEnterMultiDungeon()
        end
        --EMCache:Set("Is_FirstDeputeWeekly", true, true)
    end
    --CommonDialogParams.LeftCallbackFunction = function(_, Data)  EMCache:Set("Is_FirstDeputeWeekly", true, true) end

    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    UIManager:ShowCommonPopupUI(100238, CommonDialogParams, self)
end

function M:ShowConfirmWindow(bIsSolo)
    local CommonDialogParams = {}
    CommonDialogParams.RightCallbackFunction = function(_, Data) 
        if bIsSolo then
            self:OnClickSolo()
        else
            self:TryEnterMultiDungeon()
        end
        self:UpdateSelectedInfo(Data)
    end
    CommonDialogParams.LeftCallbackFunction = function(_, Data) self:UpdateSelectedInfo(Data) end

    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    UIManager:ShowCommonPopupUI(100211, CommonDialogParams, self)
end

function M:UpdateSelectedInfo(Data)
    local IsSelected = Data.SelectHint.IsSelected
    local CurTimestamp = TimeUtils.NowTime()
    EMCache:Set("Is_DeputeWeeklyNum", IsSelected, true)
    EMCache:Set("IsWeeklyDungeonTimestamp", CurTimestamp, true)
end

--是否需要弹窗周本奖励次数不够时
function M:CheckNeedShowWindow()
    local IsNoMorePrompts = false
    if TimeUtils  then
        local CachedTimestamp = EMCache:Get("IsWeeklyDungeonTimestamp", true)
        IsNoMorePrompts = TimeUtils.IsTimestampInCurrentWeek(CachedTimestamp)
    end
    return IsNoMorePrompts
end

-- 分包下载，无资产时弹出下载UI
function M:EnsureOptionalPatchDownloaded()
    local PatchCond = DataMgr.DungeonPatchCondition and DataMgr.DungeonPatchCondition[self.CurSelectedDungeonId]
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

--region 匹配逻辑
--- 单人->开始挑战->选择核桃(可选) or 选择门票(可选)->EnterDungeon->进入副本
--- 单人->匹配->选择核桃(可选)->TryEnterDungeon->开始匹配->进入副本
--- 组队->开始挑战->TryEnterDungeon等待队友同意->选择核桃(可选)->开始匹配->进入副本
--- 组队->匹配->TryEnterDungeon等待队友同意->选择核桃(可选)->开始匹配->进入副本
-- 单人挑战
function M:OnClickSolo()
    ---用来区分是否是单人，如果是单人，核桃选择页面动画结束应该直接进本，否则倒计时
    self.IsSoloStart = true
    ---用来区分是否是单人进入匹配，如果是单人开始匹配，则需要先选完核桃再TryEnterDungeon
    self.MultiWalnut = false
    self.MultiTicket = false
    if not self.CurSelectedDungeonId then
        DebugPrint("ZDX CurSelectedDungeonId is nil")
        return
    end
    if not PageJumpUtils:CheckDungeonCondition(DataMgr.Dungeon[self.CurSelectedDungeonId].Condition) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Tosat_Level_Locked"))
        return
    end
    if self:IsAnimationPlaying(self.Out_Loading) then
        return
    end

    if not self:EnsureOptionalPatchDownloaded() then
        return
    end

    local DungeonData = DataMgr.Dungeon[self.CurSelectedDungeonId]

    -- 如果是门票本，打开门票选择页面
    if (DungeonData.TicketId and #DungeonData.TicketId ~= 0) or DungeonData.NoTicketEnter then
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return
        end
        local bIsInTeam = Avatar:IsInTeam()
        if self.DeputeType == Const.DeputeType.NightFlightManualDepute then
           -- local _, IsEliteRushDungeon = self:CheckDungeonType(self.CurSelectedDungeonId)
            local ShowDouble = self.IsDoubleModOpen  and self.ContinuousCombat --and IsEliteRushDungeon
            if not bIsInTeam  then
                if ShowDouble then
                    local Param = {
                        RightCallbackObj = self,
                        RightCallbackFunction = self.OpenTicketDialog
                    }
                    UIManager(self):ShowCommonPopupUI(100284, Param, self)
                else
                    self:OpenTicketDialog()
                end
                return
            end
        else
            if not bIsInTeam then
                self:OpenTicketDialog()
                return
            end
        end
    end
    -- 如果体力不够则弹出体力恢复弹窗
    if  self.DungeonCost and self.MyActionPoint < self.DungeonCost then
        UIUtils.ShowActionRecover(self)
        return
    end

    local Avatar = GWorld:GetAvatar()
    -- 组队中不播放对话直接走进入同意流程
    local bIsInTeam = Avatar:IsInTeam()
    if bIsInTeam then
        self.IsSoloStart = false
        TeamController:GetModel().bPressedSolo = true
        if self.WalnutId then
            TeamController:GetModel().WalnutId = self.WalnutId
        end
        self:TryEnterDungeon(Avatar, self.CurSelectedDungeonId, CommonConst.DungeonNetMode.Standalone,
            function(RetCode, ...)
                self:BlockAllUIInput(false)
                local bCanEnter = self.HandleEnterDungeonRetCode(RetCode, ...)

                if bCanEnter then
                    UIManager(self):LoadUINew("DungeonMatchTimingBar",
                        self.CurSelectedDungeonId, Const.DUNGEON_MATCH_BAR_STATE.SPONSOR_WAITING_CONFIRM, false)
                end
            end)
        self:RefreshBtnState()
    else
        -- 如果是核桃本，打开核桃选择页面
        if DungeonData.IsWalnutDungeon then
            local WalnutChoiceUI = UIManager(self):LoadUINew("WalnutChoice", CommonConst.WalnutUser.Depute, self.CurSelectedDungeonId)
            if self.WalnutId then
                WalnutChoiceUI:SelectWalnutById(self.WalnutId)
            else
                local WalnutUtils = require "BluePrints.UI.WBP.Walnut.WalnutChoice.WalnutUtils"
                local WalnutId = WalnutUtils:GetWalnutCacheIdByDungeonId(self.CurSelectedDungeonId)
                WalnutChoiceUI:SelectWalnutById(WalnutId)
            end
            return
        end
        self:EnterStandalone()
    end
end

-- 多人挑战按钮响应方法
function M:OnClickMulti()
    self.IsSoloStart = false
    self.MultiWalnut = false
    self.MultiTicket = false
    if not self.CurSelectedDungeonId then
        DebugPrint("ZDX CurSelectedDungeonId is nil")
        return
    end
    local Avatar = GWorld:GetAvatar()
    assert(Avatar, "NO AVATAR")

    if not self:EnsureOptionalPatchDownloaded() then
        return
    end

    if self.DeputeType == Const.DeputeType.DeputeWeekly and self.WeeklyDungeonRewardLeft <= 0 then
        local IsDeputeWeeklyNum = EMCache:Get("Is_DeputeWeeklyNum", true) or false
        local IsNoMorePrompts = self:CheckNeedShowWindow()
        if IsDeputeWeeklyNum and IsNoMorePrompts then
            self:TryEnterMultiDungeon()         
            return
        else
            self:ShowConfirmWindow(false)
            return
        end
    else
        if self.DeputeType == Const.DeputeType.DeputeWeekly then
            local Dungeon = Avatar.Dungeons[self.CurSelectedDungeonId]
            local bPassCount = Dungeon and Dungeon.PassCount == 1 or false  --周本首次是否胜利过
            if not bPassCount then
                self:ShowFirstDeputeWeeklyConfirmWindow(false)
            else
                self:TryEnterMultiDungeon()
            end
            return
        end
    end


    local DungeonData = DataMgr.Dungeon[self.CurSelectedDungeonId]
    -- 如果是门票本，打开门票选择页面
    if (DungeonData.TicketId and #DungeonData.TicketId ~= 0) or DungeonData.NoTicketEnter then
        local bIsInTeam = Avatar:IsInTeam()
        if not bIsInTeam then
            --单人非组队匹配
            self.MultiTicket = true
            self:OpenTicketDialog()
            return
        end       
    end

    if not Avatar:CheckUIUnlocked("Match") then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(DataMgr.UIUnlockRule.Match.UIUnlockDesc))
        return
    end
    if not PageJumpUtils:CheckDungeonCondition(DataMgr.Dungeon[self.CurSelectedDungeonId].Condition) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Tosat_Level_Locked"))
        return
    end
    if self:IsAnimationPlaying(self.Out_Loading) then
        return
    end
    if self.DungeonCost and self.MyActionPoint < self.DungeonCost then
        UIUtils.ShowActionRecover(self)
        -- UIManager(self):ShowUITip("CommonToastMain", "UI_Toast_Insufficient_Content")
        return
    end
    local DungeonData = DataMgr.Dungeon[self.CurSelectedDungeonId]

    --- 如果在队伍中，则需要TryEnterMultiDungeon等待所有队友同意后打开核桃页面
    --- 如果是单人匹配，则先加载核桃选择，再进行TryEnterMultiDungeon进行匹配
    local bIsInTeam = Avatar:IsInTeam()
    if not bIsInTeam then
        if DungeonData.IsWalnutDungeon then
            self.MultiWalnut = true
            local WalnutChoiceUI = UIManager(self):LoadUINew("WalnutChoice", CommonConst.WalnutUser.Depute, self.CurSelectedDungeonId)
            if self.WalnutId then
                WalnutChoiceUI:SelectWalnutById(self.WalnutId)
            else
                local WalnutUtils = require "BluePrints.UI.WBP.Walnut.WalnutChoice.WalnutUtils"
                local WalnutId = WalnutUtils:GetWalnutCacheIdByDungeonId(self.CurSelectedDungeonId)
                WalnutChoiceUI:SelectWalnutById(WalnutId)
            end
            return
        end
    end
    self:TryEnterMultiDungeon()
end

function M:TryEnterMultiDungeon()
    -- 请求进入副本
    TeamController:GetModel().bPressedMulti = true
    local Avatar = GWorld:GetAvatar()
    assert(Avatar, "NO AVATAR")
    self:TryEnterDungeon(Avatar, self.CurSelectedDungeonId, CommonConst.DungeonNetMode.DedicatedServer,
        function(RetCode, ...)
            local bCanEnter = self.HandleEnterDungeonRetCode(RetCode, ...)
            DebugPrint("gmy@WBP_Play_DeputeDetail_C M:OnClickMulti", bCanEnter)
            self:BlockAllUIInput(false)
            if bCanEnter then
                local bIsInTeam = Avatar:IsInTeam()
                if bIsInTeam then
                    UIManager(self):LoadUINew("DungeonMatchTimingBar",
                        self.CurSelectedDungeonId, Const.DUNGEON_MATCH_BAR_STATE.SPONSOR_WAITING_CONFIRM, true)
                else
                    -- local DungeonData = DataMgr.Dungeon[self.CurSelectedDungeonId]

                    -- if DungeonData.IsWalnutDungeon then
                    --     UIManager(self):LoadUINew("WalnutChoice", CommonConst.WalnutUser.Depute, self.CurSelectedDungeonId)
                    --     return
                    -- end
                    UIManager(self):LoadUINew("DungeonMatchTimingBar",
                        self.CurSelectedDungeonId, Const.DUNGEON_MATCH_BAR_STATE.WAITING_MATCHING_WITH_CANCEL, true)
                end
            end
        end,self.TicketId)
    self:RefreshBtnState()
end

--- 进入核桃副本
--- IsSoloStart：选完直接进入
--- MultiWalnut：单人点击选完核桃后要开始进入倒计时阶段
function M:EnterWalnutDungeon()
    if self.IsSoloStart then
        self:EnterStandalone()
    end
    if self.MultiWalnut then
        self:TryEnterMultiDungeon()
    end
end

--进入门票副本
function M:EnterTicketDungeon(TicketId)
    if self.IsSoloStart then
        self:EnterStandalone(TicketId)
    end
    if self.MultiTicket then
        if TicketId ~= -1 then
            self.TicketId = TicketId
        end
        self:TryEnterMultiDungeon()
    end
end

function M:EnterStandalone(TicketId)
    if self.DungeonCost and self.MyActionPoint < self.DungeonCost then
        UIUtils.ShowActionRecover(self)
        -- UIManager(self):ShowUITip("CommonToastMain", "UI_Toast_Insufficient_Content")
        return
    end
    self.TicketId = TicketId
    GWorld.GameInstance:SetTicketId(self.TicketId)
    --local StyleOfPlay = UIManager(self):GetUI("StyleOfPlay")
    --StyleOfPlay:PlayAnimation(StyleOfPlay.Out)
    --self:PlayAnimation(self.Out_Loading)
    AudioManager(self):PlayUISound(self, "event:/ui/common/map_click_enter_level", nil, nil)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        --设置轮次数量
        if self:IsAutoNextRound() then
            Avatar:SetDungeonAutoProgress(self.CurSelectedDungeonId, self.AutoNextRound:GetSelectCount())       
        end
        self:TryEnterDungeon(Avatar, self.CurSelectedDungeonId, CommonConst.DungeonNetMode.Standalone,
            function(RetCode, ...)
                self:BlockAllUIInput(false)
                local bRetCode = self.HandleEnterDungeonRetCode(RetCode, ...)
                if not bRetCode then
                    local StyleOfPlay = UIManager(self):GetUIObj("StyleOfPlay")
                    if StyleOfPlay then
                        StyleOfPlay:PlayAnimation(StyleOfPlay.In)
                    end
                    self:PlayAnimation(self.In)
                end
            end, self.TicketId)
        self:BlockAllUIInput(true)
        self:AddTimer(10, function()
            if self and self:IsAllUIInputBlocked() then
                self:BlockAllUIInput(false)
            end
        end)
    else
        WorldTravelSubsystem(self):ChangeDungeonByDungeonId(self.CurSelectedDungeonId,
            CommonConst.DungeonNetMode.Standalone)
    end
end

-- 查看怪物信息按钮响应事件
function M:OnBtnCheckClicked()
    if not self:IsAnimationPlaying(self.Out) then
        UIManager(self):LoadUINew("MonsterDetailInfo", self.CurSelectedDungeonId, self)
    end
end

--点击怪物信息
function M:SelectMonsterInfoItem(MonsterId)
    UIManager(self):LoadUINew("MonsterDetailInfo", self.CurSelectedDungeonId, self, MonsterId)
end

--- 属性图标悬浮相关
---@param ElementType string @属性类型
function M:SetElementIcon(ElementType)
    if (ElementType) then
        self.Type:SetVisibility(ESlateVisibility.Visible)
    else
        self.Type:SetVisibility(ESlateVisibility.Collapsed)
        return
    end
    local IconPath = DataMgr.Attribute[ElementType].Icon
    local Icon = LoadObject(IconPath)
    self.Icon_Type:SetBrushResourceObject(Icon)
    self.Stats_ListView:ClearListItems()
    local ElmtTypes, ElmtNames = UIUtils.GetAllElementTypes()
    for idx, Type in ipairs(ElmtTypes) do
        self.Stats_ListView:AddItem(self:NewElmtIconContent(Type, ElmtNames[idx], Type == ElementType))
    end
end

function M:NewElmtIconContent(ElmtType, ElmtName, IsSelected)
    local Obj = NewObject(self.AttributeContentClass)
    local IconPath = DataMgr.Attribute[ElmtType].Icon
    Obj.Icon = LoadObject(IconPath)
    Obj.Text = GText(ElmtName)
    Obj.IsSelected = IsSelected
    return Obj
end

function M:OnElementEntryInitialized(Content, Widget)
    if (Content.IsSelected) then
        Widget.Bg_On:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        Widget.Bg_On:SetVisibility(ESlateVisibility.Collapsed)
    end
    Widget.Image_Attribute:SetBrushResourceObject(Content.Icon)
    Widget.Stats_Name:SetText(Content.Text)
end

function M:OnButtonAttibuteHovered()
    self.IsOpenAttibute = true
    self:StopAnimation(self.Tips_In)
    self:PlayAnimation(self.Tips_In)
    -- self.Stats:SetRenderOpacity(1)
end

function M:OnButtonAttibuteUnhovered()
    self.IsOpenAttibute = false
    self:StopAnimation(self.Tips_In)
    self:PlayAnimationReverse(self.Tips_In)
    -- self.Stats:SetRenderOpacity(0)
end

function M:OnUserScrolled()
    if CommonUtils.GetDeviceTypeByPlatformName()=="Mobile" then return end
    UIUtils.UpdateScrollBoxArrow(self.ScrollBox_List,self.List_ArrowTop,self.List_ArrowBottom)
end

function M:OpenDetails()
    UIManager(self):LoadUINew("ItemInformation",
        {
            Name = DataMgr.Dungeon[self.CurSelectedDungeonId].DungeonName,
            Desc = DataMgr.Dungeon
                [self.CurSelectedDungeonId].DungeonContent
        },
        "LevelDatail")
end

--- 默认返回按钮响应方法
function M:OnReturnKeyDown()
    local PlayEntry = UIManager(self):GetUIObj("StyleOfPlay")
    if not PlayEntry then
        return
    end

    if self:IsAnimationPlaying(self.In) then
        return
    end

    AudioManager(self):SetEventSoundParam(self, "Play_DeputeDetail", {ToEnd = 1})
    if not self:IsAnimationPlaying(self.Out) then
        self:SetVisibility(ESlateVisibility.HitTestInvisible)
        self:PlayAnimation(self.Out) 
    end
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Out then
        self:RemoveFromParent()
        local PlayEntry = UIManager(self):GetUIObj("StyleOfPlay")
        PlayEntry.SubUI[self.CurTabId] = nil
        -- 如果当前拼接关是由其他页面跳转，则关闭当前页面时，玩法入口页面直接关闭
        -- 如果当前拼接关是通过玩法页面打开，则关闭当前页面时，返回到玩法入口页面
        if self.IsFromJump then
            if PlayEntry.IsHome then
                PlayEntry:SwitchCamera()
                PlayEntry:PlayNPCAnim(21000502)
            else
                UIManager(self):SwitchUINpcCamera(false,"StyleOfPlay", PlayEntry.NpcId, {bDestroyNpc=true, IsHaveInOutAnim=PlayEntry.IsNeedPlayNpcAnim})
            end
            PlayEntry:OnReturnKeyDown()
        else
            PlayEntry:OpenSubUI("NewDeputeRoot")
        end
    -- elseif InAnimation == self.Out_Loading then
    --     AudioManager(self):PlayUISound(self, "event:/ui/common/map_click_enter_level", nil, nil)
    --     local Avatar = GWorld:GetAvatar()
    --     if Avatar then
    --         self:TryEnterDungeon(Avatar, self.CurSelectedDungeonId, CommonConst.DungeonNetMode.Standalone,
    --             function(RetCode, ...)
    --                 local bRetCode = self.HandleEnterDungeonRetCode(RetCode, ...)
    --                 if not bRetCode then
    --                     local StyleOfPlay = UIManager(self):GetUIObj("StyleOfPlay")
    --                     if StyleOfPlay then
    --                         StyleOfPlay:PlayAnimation(StyleOfPlay.In)
    --                     end
    --                     self:PlayAnimation(self.In)
    --                 end
    --             end, self.TicketId)
    --         --local bIsInTeam = Avatar:IsInTeam()
    --         --if bIsInTeam then
    --         --	UIManager(self):LoadUINew("DungeonMatchTimingBar",
    --         --			self.CurSelectedDungeonId, Const.DUNGEON_MATCH_BAR_STATE.SPONSOR_WAITING_CONFIRM)
    --         --end
    --     else
    --         WorldTravelSubsystem(self):ChangeDungeonByDungeonId(self.CurSelectedDungeonId,
    --             CommonConst.DungeonNetMode.Standalone)
    --     end
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
        if self.Image_Select and self.Image_Select:GetRenderOpacity() > 0 then
            self:PlayAnimation(self.UnHover)
        end
    end
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)

    self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

function M:UpdatKeyDisplay(FocusTypeName)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then return end
        
    local StyleOfPlay = UIManager(self):GetUIObj("StyleOfPlay")
    if not StyleOfPlay then
        return
    end

    if self.DefaultList:GetVisibility() ==  ESlateVisibility.SelfHitTestInvisible and self.DefaultList.IsShow then
        return
    end
    self.Tab_Info.Key_Left:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Tab_Info.Key_Right:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.FocusTypeName = FocusTypeName
    if FocusTypeName == "RewardWidget" then
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
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
        self:UpdateUIStyleInPlatform(true)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        --self.Cost.Key:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Tab_Info:UpdateUIStyleInPlatform(true)
        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            self.Button_Multi:SetPCVisibility(true)
            self.Button_Solo:SetPCVisibility(true)
            self.Button_DoubleMod:SetPCVisibility(true)
        end
        self.DefaultList:ApplyPcUiLayout()

        -- if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        --     --self.Btn_More:SetVisibility(ESlateVisibility.Collapsed)
        --     self:SetPanelDetailsVis(ESlateVisibility.Collapsed)
        -- end

    elseif FocusTypeName == "SelfWidget" then
        local BottomKeyInfo = {}
        if self.Panel_Type:GetVisibility() == ESlateVisibility.Visible then
            BottomKeyInfo = {
                {
                    GamePadInfoList = {
                        { Type = "Add" },
                        GamePadSubKeyInfoList = {
                            { Type = "Img", ImgShortPath = "Up", Owner = self },
                            { Type = "Img", ImgShortPath = "X", Owner = self }
                        }
                    },
                    Desc = GText("UI_CTL_CheckProperty"),
                    bLongPress = false,
                },
                {
                    GamePadInfoList = {
                        { Type = "Add" },
                        GamePadSubKeyInfoList = {
                            { Type = "Img", ImgShortPath = "Up", Owner = self },
                            { Type = "Img", ImgShortPath = "Y", Owner = self }
                        }
                    },
                    Desc = GText("UI_CTL_DeputeInfo"),
                    bLongPress = false,
                }
            }
        else
            BottomKeyInfo = {
                {
                    GamePadInfoList = {
                        { Type = "Add" },
                        GamePadSubKeyInfoList = {
                            { Type = "Img", ImgShortPath = "Up", Owner = self },
                            { Type = "Img", ImgShortPath = "Y", Owner = self }
                        }
                    },
                    Desc = GText("UI_CTL_DeputeInfo"),
                    bLongPress = false,
                }
            }
        end

        table.insert(BottomKeyInfo, {
            KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback = self.OnReturnKeyDown, Owner = self } },
            GamePadInfoList = { { Type = "Img", ImgShortPath = "B", Owner = self } },
            Desc = GText("UI_BACK"),
        })

        -- 更新界面按键提示
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)

        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            self:UpdateUIStyleInPlatform(false)
            StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            --self.Cost.Key:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Tab_Info:UpdateUIStyleInPlatform(true)
            self.Button_Multi:SetPCVisibility(false)
            self.Button_Solo:SetPCVisibility(false)
            self.Button_DoubleMod:SetPCVisibility(false)
            self.IsFocusProp = false;
            self.IsFocus_Monster = false;
            self.IsFocusEliteProp = false;
            self.DefaultList:InitWidgetInfoInGamePad()
        end

        -- self.Parent.DeputeTab:UpdateUIStyleInPlatform(true)
        -- StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
    elseif FocusTypeName == "EventWidget" then
        local BottomKeyInfo = {
            {
                GamePadInfoList = { {
                    Type = "Img",
                    ImgShortPath = "B",
                    Owner = self
                } },
                Desc = GText("UI_BACK"),
                bLongPress = false,
            },
        }
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
        self:UpdateUIStyleInPlatform(true)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        --self.Cost.Key:SetVisibility(UE4.ESlateVisibility.Collapsed)
        --self.Tab_Info:UpdateUIStyleInPlatform(false)

    elseif FocusTypeName == "EliteProp" then
        local BottomKeyInfo = {
            {
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "LS", Owner = self }
                },
                Desc = GText("UI_Controller_CheckReward"),
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
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
        self:UpdateUIStyleInPlatform(true)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        --self.Cost.Key:SetVisibility(UE4.ESlateVisibility.Collapsed)
        --self.Tab_Info:UpdateUIStyleInPlatform(false)
        
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
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
        self:UpdateUIStyleInPlatform(true)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        
    elseif FocusTypeName == "AutoNextRound" then
        local BottomKeyInfo = {
            {
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "A", Owner = self }
                },
                Desc = GText("UI_SQUAD_SELECT_CONFIRM"),
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
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
        self:UpdateUIStyleInPlatform(true)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        --self.Cost.Key:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Tab_Info:UpdateUIStyleInPlatform(true)
        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            self.Button_Multi:SetPCVisibility(true)
            self.Button_Solo:SetPCVisibility(true)
            self.Button_DoubleMod:SetPCVisibility(true)
            self.Key_Details_GamePad:SetVisibility(ESlateVisibility.Collapsed)
            self.Tab_Info.Key_Left:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Tab_Info.Key_Right:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        self.DefaultList:ApplyPcUiLayout()
    else
        local BottomKeyInfo = {}
        -- 更新界面按键提示
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
        self:UpdateUIStyleInPlatform(true)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        --self.Cost.Key:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Tab_Info:UpdateUIStyleInPlatform(false)
    end
end

function M:SetPanelDetailsVis(SlateVisibility)
    self.Panel_Details:SetVisibility(SlateVisibility)
end

function M:IsAutoNextRound()
    return self.AutoNextRound:GetVisibility() == ESlateVisibility.SelfHitTestInvisible 
    --self.AutoNextRound:GetVisibility() == ESlateVisibility.SelfHitTestInvisible 
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then return end
    if self:IsAutoNextRound() then 
        self.AutoNextRound:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    end
    --如果是pc或者特殊原因需要显示为pc时
    if (IsUseKeyAndMouse) then
        self.Key_Check_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        self.Com_Key_More:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Key_Qa_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        self.Com_CheckBox_LeftText.Com_KeyImg:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_LT:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_LR:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_Qa:SetVisibility(ESlateVisibility.Visible)
        self:SetPanelDetailsVis(self:IsShowKeyMore() and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed) 

        if  self.List_Type:GetVisibility() == ESlateVisibility.Visible then
            self.Key_Qa_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        end

        -- if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        --     self:UpdatKeyDisplay()
        -- end
    else
        if  self.List_Type:GetVisibility() == ESlateVisibility.Visible then
            self.Btn_Qa:SetVisibility(ESlateVisibility.Collapsed)
            self.Key_Qa_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible) 

            self.Key_Qa_GamePad:CreateCommonKey({
                KeyInfoList = {
                    {
                        Type = "Img",
                        ImgShortPath = "Up",
                    },
                    {
                        Type = "Img",
                        ImgShortPath = "B",
                    },
                },
                Type = "Add"
            })
        end

        self:SetPanelDetailsVis(self:IsShowKeyMore() and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed) 


        self.Key_LT:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_LT:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "LB",
                },
            },
        })

        self.Key_LR:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_LR:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "RB",
                },
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
    end
    self:SetPanelDetails(self.CurrentTabIdx)
end

function M:HandleKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        if (InKeyName == "Escape") then
            IsEventHandled = true
            if self.DisableEsc and self.DisableEsc == true then
                return IsEventHandled
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
    return IsEventHandled
end

function M:OnGamePadDown(InKeyName)
    DebugPrint("SL OnGamePadDown is InKeyName Detail", InKeyName)
    local IsEventHandled = false
    -- 记录按下状态
    self.PressedKeys[InKeyName] = true

    -- 组合键检测：方向键上是否按下
    local IsDpadUp = self.PressedKeys[Const.GamepadDPadUp] == true
    if InKeyName == "Gamepad_FaceButton_Right" then
        -- 清按键状态
        self.PressedKeys["Gamepad_DPad_Up"] = nil
        self.PressedKeys["Gamepad_FaceButton_Right"] = nil
        self.Image_Select:SetRenderOpacity(0)
        if  self.Image_Select:GetRenderOpacity() > 0 then
            self:PlayAnimation(self.UnHover)
        end
        -- 组合键：Up + B
        if IsDpadUp then
            UIManager(self):ShowCommonPopupUI(100241)
            return true
        end

        -- 单键 B：先处理 SelectCell 焦点
        if self.SelectCell then
            local btnArea = self.SelectCell.Bg_List and self.SelectCell.Bg_List.Button_Area
            if btnArea and not btnArea:HasAnyUserFocus() then
                self:SelectCellFocus()
                IsEventHandled = true
            else
                if self.IsOpenAttibute then
                    self:OnButtonAttibuteUnhovered()
                else
                    self:OnReturnKeyDown()
                end                
                IsEventHandled = true
            end
        end

        -- 再处理 DefaultList 关闭
        if self.DefaultList
            and self.DefaultList.IsShow
            and self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
            self.DefaultList:OnCloseSquadGamepad()
            self:UpdatKeyDisplay("SelfWidget")
            IsEventHandled = true
        end

        if self:IsAutoNextRound() then
            self.AutoNextRound:SetAutoNextRoundFocus(false)
        end
    end

    if self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible and self.DefaultList.IsShow then
        return IsEventHandled --UWidgetBlueprintLibrary.UnHandled()
    end

    if InKeyName == "Gamepad_LeftTrigger" or InKeyName == "Gamepad_RightTrigger" then
        if self.Tab_Info then
            self.Tab_Info:Handle_KeyEventOnGamePad(InKeyName)
            IsEventHandled = true
        end
    elseif InKeyName == "Gamepad_RightShoulder" then
        if self.Key_LR:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
            self:OnTypeItemPadRight()
            IsEventHandled = true
        end

        -- self:OnTypeClicked(DungeonSelectCache[self.CurSelectedDungeonId] or self.CurSelectedDungeonId)
        -- self.HB_Type:GetChildAt(1):SetFocus()
    elseif InKeyName == "Gamepad_LeftShoulder" then
        if self.Key_LT:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
            self:OnTypeItemPadLeft()
            IsEventHandled = true
        end
        -- self:OpenDetails()
        --IsEventHandled = self.Common_Tab:Handle_KeyEventOnGamePad(InKeyName)
        ---X按键
    elseif InKeyName == "Gamepad_FaceButton_Left" then
        if self.FocusTypeName ~= "RewardWidget" then
            -- self.PressedKeys["Gamepad_DPad_Up"] = nil
            -- self.PressedKeys["Gamepad_FaceButton_Left"] = nil
            if IsDpadUp then
                if not self.IsOpenAttibute then
                    self:OnButtonAttibuteHovered()
                end
            else
                if self.Button_Multi:GetVisibility() == ESlateVisibility.Visible then
                    self:OnClickMulti()
                end
            end
            IsEventHandled = true
        end
        ---Y按键
    elseif InKeyName == "Gamepad_FaceButton_Top" then
        if self.FocusTypeName ~= "RewardWidget" then
            self.PressedKeys["Gamepad_DPad_Up"]      = nil
            self.PressedKeys["Gamepad_FaceButton_Top"] = nil
            if IsDpadUp then
                self:OpenDetails()
            else
                if self.Button_DoubleMod:GetVisibility() == ESlateVisibility.Visible and self.Button_DoubleMod:IsBtnForbidden() then
                    self:OnForbiddenDoubleModBtnClicked()
                else
                    self:ShowDialogChar()
                end
            end
            IsEventHandled = true
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
            elseif self.CurrentTabIdx == self.SpecialMonsterTabId then
                self.WB_EliteProp:GetChildAt(0):SetFocus()
                self:UpdatKeyDisplay("EliteProp")
            elseif self.CurrentTabIdx == self.TitleEventTabId then
                self.List_Event:SetFocus()
                self:UpdatKeyDisplay("EventWidget")
            end
            self:PlayAnimation(self.Hover)
            self.CurrentFocusType = "List";
            if  self.StyleOfPlay then
                self.StyleOfPlay.IsKeyEventOnGamePad = false
            end            
            IsEventHandled = true    
        end 
    --Up + RS聚焦到无尽轮次
    elseif InKeyName == "Gamepad_RightThumbstick" then
        -- 清按键状态
        self.PressedKeys["Gamepad_DPad_Up"] = nil
        self.PressedKeys["Gamepad_RightThumbstick"] = nil
        if self:IsAutoNextRound() then
            -- 组合键：Up + RS
            if IsDpadUp then
                self.AutoNextRound:SetAutoNextRoundFocus(true)
                self.CurrentFocusType = "AutoNextRound"
                if  self.StyleOfPlay then
                    self:UpdatKeyDisplay("AutoNextRound")
                    self.StyleOfPlay.IsKeyEventOnGamePad = false                
                end 
                return true
            end
        end
    end
    return IsEventHandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadUp(InKeyName)
    end

    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnGamePadUp(InKeyName)
    local IsEventHandled = false
    self.PressedKeys[InKeyName] = false
    -- ---X按键
    if InKeyName == "Gamepad_FaceButton_Left" then
        if self.IsOpenAttibute then
            self:OnButtonAttibuteUnhovered()
        end
        --     ---Y按键
        -- elseif InKeyName == "Gamepad_FaceButton_Top" then
        --     if self.FocusTypeName ~= "RewardWidget" then
        --         self:ShowDialogChar()
        --         IsEventHandled = true
        --     end
    end
    return IsEventHandled
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    if self.DefaultList:GetVisibility() ==  ESlateVisibility.SelfHitTestInvisible and self.DefaultList.IsShow then
        return UWidgetBlueprintLibrary.UnHandled()
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    self.PressedKeys[InKeyName] = true
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == "Gamepad_DPad_Up" then
            IsEventHandled = true
        elseif InKeyName == "Gamepad_DPad_Down" then
            if self.CurrentTabIdx == self.SpecialMonsterTabId and not self.MenuOpen and self.CurrentFocusType ~= "AutoNextRound" then
                if  self.MonNum and self.MonNum > self.MaxMonNum then
                    self:OpenCommanderDetails()
                    IsEventHandled = true
                end
            else
                if self.CurrentTabIdx ==  self.ObtainTabId and not self.MenuOpen and self.CurrentFocusType ~= "AutoNextRound" then
                    self:OpenRewardDetails()
                    IsEventHandled = true
                end
            end
            IsEventHandled = true              
        elseif InKeyName == "Gamepad_DPad_Right" and not self:IsFocusList() and not self:IsFocusAutoNextRound()  then
            if self.DefaultList:GetVisibility() ~= ESlateVisibility.SelfHitTestInvisible then return IsEventHandled end
            if not self.DefaultList.IsShow then
                local IsChecked = not self.DefaultList.Preview.Switch_Summon:GetChecked()
                self.DefaultList.Preview.Switch_Summon:SetChecked(IsChecked)
                local Avatar = GWorld:GetAvatar()
                if not Avatar then IsEventHandled = true return  end
                Avatar:SwitchSquadAutoPhantom(IsChecked)
                IsEventHandled = true
            end
        elseif InKeyName == "Gamepad_DPad_Left" and not self:IsFocusList() and not self:IsFocusAutoNextRound() then
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

--- 按 LB 属性切换，向左切换选中
function M:OnTypeItemPadLeft()
    if not self.LastMarkType then return end

    local CurrentIndex = self:GetItemIndex()
    if CurrentIndex and CurrentIndex > 1 then
        self:SelectTypeItemByIndex(CurrentIndex - 1)
    end
end

--- 按 RB 属性切换，向左切换选中
function M:OnTypeItemPadRight()
    if not self.LastMarkType then return end

    local CurrentIndex = self:GetItemIndex()
    if CurrentIndex and CurrentIndex < #self.TypeTableKeys then
        self:SelectTypeItemByIndex(CurrentIndex + 1)
    end
end

--- 根据索引切换选中的属性
function M:SelectTypeItemByIndex(Index)
    local TargetKey = self.TypeTableKeys[Index]
    if TargetKey then
        self:OnTypeClicked(TargetKey)
    end
end

--- 获取当前选中属性的索引
function M:GetItemIndex()
    for Index, Key in ipairs(self.TypeTableKeys) do
        if self.TypeTable[Key] == self.LastMarkType then
            return Index
        end
    end
    return nil
end

function M:SelectCellFocus()
    self:UpdatKeyDisplay("SelfWidget")
    if not self.SelectCell.Bg_List.Button_Area:HasAnyUserFocus() then
        self.SelectCell.Bg_List.Button_Area:SetFocus()
        if self.StyleOfPlay then
            self.StyleOfPlay.IsKeyEventOnGamePad = true
        end
    end
end

function M:OnSelectCellFocus()
    if self.Image_Select then
        self.Image_Select:SetRenderOpacity(0)
    end

    --self:PlayAnimation(self.UnHover)
    self.CurrentFocusType = "SelectCell"
    if self.CurrentFocusType ~= "SelectCell" and self.Gamepad then
        self:UpdatKeyDisplay("SelfWidget")
    end
end

function  M:IsFocusList()
    return  self.CurrentFocusType == "List"
end

function  M:IsFocusAutoNextRound()
    return  self.CurrentFocusType == "AutoNextRound"
end

-- function M:OnFocusReceived(MyGeometry, InFocusEvent)
--     DebugPrint("CurrentChild   ---",self.ScrollBox_List.bIsFocusable)
--     --当聚焦到item的时候 设置聚焦到第一个关卡按钮
--     --self.ScrollBox_List:GetChildAt(5).Bg_List.Button_Area:SetFocus()

--     return UE4.UWidgetBlueprintLibrary.Unhandled()
-- end

function M:OnForbiddenRightBtnClicked()
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_REGISTER_COMINGSOON"))
end

function M:OnForbiddenLeftBtnClicked()
    if self.IsComMissing and self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
        --self.DefaultList.Preview:PlayFlashRed()
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast,  GText("UI_Squad_Miss_Challenge"))
    end
end

function M:OnForbiddenDoubleModBtnClicked()
    if self.IsDoubleModOpen and self.ContinuousCombat then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast,  GText("UI_Event_ModDrop_Exhausted"))
    end
end

function M:ShowIntro()
    --UIManager(self):LoadUINew("CommonDialogTip", GText("UI_Dungeon_Detail"), GText("UI_Toast_Dungeon_Detail"))
end

function M:OpenIntro()
    -- AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    -- UIManager(self):ShowCommonPopupUI(100124)
end

function M:UpdateActionPoint(ActionPointID)
    -- -- 获取玩家体力信息
    -- local Avatar = GWorld:GetAvatar()
    -- self.MyActionPoint = Avatar.ActionPoint
    -- if not self.MyActionPoint then return DebugPrint("self.MyActionPoint is null") end
    -- -- 更新关卡体力消耗信息
    -- self.Num_Over:SetText(self.MyActionPoint)
    -- self.Num_Short:SetText(self.MyActionPoint)
    -- -- 根据当前体力是否足够跳转，设置不同文本类型
    -- local Index = (self.MyActionPoint >= (self.DungeonCost or 0)) and 0 or 1
    -- self.Switcher_Owned:SetActiveWidgetIndex(Index)
end

function M:OnDungeonsUpdate()
    if self.DeputeType == Const.DeputeType.WalnutDepute then
        local Params = {}
        Params.RightCallbackFunction = function()
            if self then
                self:OnReturnKeyDown()
            end 
        end
        UIManager(self):ShowCommonPopupUI(100157, Params)

        local WalnutChoice = UIManager(self):GetUI("WalnutChoice")
        if WalnutChoice then
            WalnutChoice:Close()
        end
    end
end

function M:OnCurrentSquadChange(SquadId, IsComMissing)
    self.SquadId = SquadId
    self.IsComMissing = IsComMissing
    --self:RefreshBtnState()
    self:IsShowAttributeTips()
    if self.DefaultList.CurrentCharLevel <= DataMgr.Dungeon[self.CurSelectedDungeonId].DungeonLevel - DataMgr.GlobalConstant.TaskWarningLevel.ConstantValue then
        self.Panel_WarningHint:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Panel_WarningHint:SetVisibility(ESlateVisibility.Collapsed)
    end
    -- 阵容组件缺失处理
end

--刷新按钮状态
function M:RefreshBtnState(bInIsMatching)
    DebugPrint("gmy@WBP_Play_DeputeDetail_C M:RefreshBtnState",bInIsMatching)
    if not self.CurSelectedDungeonId then return end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end

    local UIUnlockRuleId = DataMgr.UIUnlockRule.Match.UIUnlockRuleId
    local bIsUnlock      = Avatar:CheckUIUnlocked(UIUnlockRuleId) or false

    local DungeonData = DataMgr.Dungeon[self.CurSelectedDungeonId]
    if not DungeonData then return end

    local IsComMissing = self.IsComMissing or false

    -- 统一先算多人/匹配状态
    local IsMultiDungeon = DungeonData.IsMultiDungeon and true or false
    local found = false
    if Avatar.CdnHideData and Avatar.CdnHideData.dungeon then
        for _, Data in pairs(Avatar.CdnHideData.dungeon) do
            for __, ConfigName in pairs(Data.gameCtrlDungeon or {}) do
                if ConfigName == "multidungeon" then
                    IsMultiDungeon = Data.config and true or false
                    found = true
                    break
                end
            end
            if found then break end
        end
    end

    local IsMatching = bInIsMatching
    if IsMatching == nil then
        IsMatching = self:IsMatching()
    end

    local bIsInTeam = Avatar:IsInTeam()

    -- DoubleMod门票
    local _, IsEliteRushDungeon = self:CheckDungeonType(self.CurSelectedDungeonId)
    self.ContinuousCombat = IsEliteRushDungeon
    local ShowDouble = self:IsDoubleMod() --and IsEliteRushDungeon
    local RemainOK = true
    if ShowDouble and IsEliteRushDungeon then
        local DoubleModDropInfo = self:GetDoubleModDropData() or {}
        -- local ConfigValue = (DataMgr.ModDropConstant.DailyFreeTicketAmount
        --                     and DataMgr.ModDropConstant.DailyFreeTicketAmount.ConstantValue) or 0
        local MdConst           = DataMgr.ModDropConstant or {}
        local DailyFree         = (MdConst.DailyFreeTicketAmount and MdConst.DailyFreeTicketAmount.ConstantValue) or 0
        local ConfigValue       = DailyFree 
        local UsedTimes         = DoubleModDropInfo.EliteRushTimes
        local Remaining         = math.floor(ConfigValue - UsedTimes)
        RemainOK                = Remaining > 0
    end

    -- 状态签名：相同直接 return 
    local Sig = table.concat({
        tostring(self.CurSelectedDungeonId),
        tostring(IsMatching),
        tostring(bIsUnlock),
        tostring(IsMultiDungeon),
        tostring(self.DeputeType),
        tostring(IsComMissing),
        tostring(ShowDouble or false),
        tostring(RemainOK),
        tostring(bIsInTeam),
        tostring(self.ContinuousCombat)
    }, "|")

    if self._Btn_sig == Sig then
        return
    end
    self._Btn_sig = Sig

    DebugPrint("SL@WBP_Play_DeputeDetail_C M:RefreshBtnState")

    -- 设置单人按钮显示文本
    if self.DeputeType == Const.DeputeType.WalnutDepute then
        self.Button_Solo:SetText(GText("UI_Walnut_Choice"))
    else
        self.Button_Solo:SetText(GText("DUNGEONSINGLE"))
    end

    if IsMatching then
        -- 匹配中，禁用按钮并解绑事件
        self.Button_Multi:ForbidBtn(true)
        self.Button_Solo:ForbidBtn(true)

        self.Button_Multi:UnBindEventOnClickedByObj(self)
        self.Button_Solo:UnBindEventOnClickedByObj(self)

        self.Button_Multi:BindForbidStateExecuteEvent(self, function() end)
        self.Button_Solo:BindForbidStateExecuteEvent(self, function() end)
    else
        -- 匹配未开始，配置按钮状态
        if not IsMultiDungeon then
            self.Button_Multi:SetVisibility(ESlateVisibility.Collapsed)
        else
            -- 多人副本：多人按钮按解锁显示
            self.Button_Multi:SetVisibility(bIsUnlock and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
        end
 
        -- 设置多人按钮启用状态
        self.Button_Multi:ForbidBtn(not IsMultiDungeon)

        --如果是不能联机副本 但是是组队中的话 则置灰        
        self.Button_Solo:ForbidBtn(not IsMultiDungeon and bIsInTeam)

        -- 重绑定事件
        self.Button_Multi:UnBindEventOnClickedByObj(self)
        self.Button_Solo:UnBindEventOnClickedByObj(self)


        self.Button_Multi:SetDefaultGamePadImg("X")
        self.Button_Solo:SetDefaultGamePadImg("Y")
        self.Button_DoubleMod:SetDefaultGamePadImg("Y")

        self.Button_Multi:BindEventOnClicked(self, self.OnClickMulti)
        self.Button_Solo:BindEventOnClicked(self, self.ShowDialogChar)

        self.Button_Multi:BindForbidStateExecuteEvent(self, self.OnForbiddenRightBtnClicked)
        self.Button_DoubleMod:BindForbidStateExecuteEvent(self, self.OnForbiddenDoubleModBtnClicked)
        self.Button_Solo:BindForbidStateExecuteEvent(self, function()
            if not IsMultiDungeon and bIsInTeam then
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Team_CanNotEnterDungeon"))
            end
         end)
    end

    -- 阵容预设缺失
    if IsComMissing then
        self.Button_Multi:ForbidBtn(true)
        self.Button_Solo:ForbidBtn(true)
        self.Button_Multi:UnBindEventOnClickedByObj(self)
        self.Button_Solo:UnBindEventOnClickedByObj(self)
        self.Button_Solo:BindForbidStateExecuteEvent(self, self.OnForbiddenLeftBtnClicked)
        self.Button_Multi:BindForbidStateExecuteEvent(self, self.OnForbiddenLeftBtnClicked)
    end

    -- Dungeon表新增 bDisableMatch ,表示是否屏蔽匹配按钮
    if self.CurSelectedDungeonId then
        local CurSelectedDungeonData = DataMgr.Dungeon[self.CurSelectedDungeonId]
        if CurSelectedDungeonData and CurSelectedDungeonData.bDisableMatch then
            self.Button_Multi:SetVisibility(ESlateVisibility.Collapsed)
        end
    end

    if self.DeputeType == Const.DeputeType.NightFlightManualDepute then
        if ShowDouble and self.ContinuousCombat then
            self.Button_Solo:SetVisibility(ESlateVisibility.Collapsed)
            self.Button_DoubleMod:SetVisibility(ESlateVisibility.Visible)
            self.Button_DoubleMod:SetText(GText("UI_Event_ModDrop_ChallengeStart"))
            self.Button_DoubleMod:ForbidBtn(not RemainOK and self.ContinuousCombat or false)
        else
            self.Button_DoubleMod:SetVisibility(ESlateVisibility.Collapsed)
            self.Button_Solo:SetText(GText("UI_Ticket_Choose"))
            self.Button_Solo:SetVisibility(ESlateVisibility.Visible)
        end

        -- 活动的挑战次数耗尽
        if not RemainOK then
            self.Button_Multi:ForbidBtn(true)
            self.Button_Solo:ForbidBtn(true)
            self.Button_DoubleMod:ForbidBtn(true)
            self.Button_Multi:UnBindEventOnClickedByObj(self)
            self.Button_Solo:UnBindEventOnClickedByObj(self)
            self.Button_DoubleMod:UnBindEventOnClickedByObj(self)
            self.Button_Multi:BindForbidStateExecuteEvent(self, function()
                UIManager(self):ShowUITip("CommonToastMain", GText("UI_Event_ModDrop_Exhausted"))
            end)
            self.Button_Solo:BindForbidStateExecuteEvent(self, function()
                UIManager(self):ShowUITip("CommonToastMain", GText("UI_Event_ModDrop_Exhausted"))
            end)
            self.Button_DoubleMod:BindForbidStateExecuteEvent(self, function()
                UIManager(self):ShowUITip("CommonToastMain", GText("UI_Event_ModDrop_Exhausted"))
            end)
        end
    end
end

function M:IsMatching()
    return TeamController:GetModel():IsMatching()
end

function M:OpenTicketDialog()
    local CommonDialog = UIManager(self):ShowCommonPopupUI(100123, {
        DungeonId = self.CurSelectedDungeonId,
        RightCallbackObj = self,
        RightCallbackFunction = function(Obj, PackageData)
            self:EnterTicketDungeon(PackageData.Content_1.TicketId)
        end,
        ForbiddenRightCallbackObj = self,
        AutoFocus = true
    }, self)
end

function M:PlayTabSound()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_03", nil, nil)
end

function M:TryEnterDungeon(Avatar, DungeonId, DungeonNetMode, OtherCallback, TicketId)
    if self:DoCheckCanEnterDungeon(Avatar, DungeonId) then
        self:BlockAllUIInput(true)
        DebugPrint("gmy@M:TryEnterDungeon ", Avatar, DungeonId, DungeonNetMode, OtherCallback, TicketId)
        if self.DefaultList:GetVisibility() == ESlateVisibility.Collapsed then
            Avatar:EnterDungeon(DungeonId, DungeonNetMode, OtherCallback, TicketId)
        else
            Avatar:EnterDungeon(DungeonId, DungeonNetMode, OtherCallback, TicketId, self.SquadId)
        end
    else
        TeamController:GetModel().bPressedSolo = false
        TeamController:GetModel().bPressedMulti = false
    end
end

function M.HandleEnterDungeonRetCode(RetCode, ...)
    DebugPrint("gmy@M.EnterDungeonCallback RetCode", RetCode)

    if RetCode == ErrorCode.RET_SUCCESS then
        return true
    else
        local FailedMember = ...
        if FailedMember then
            TeamController:DoWhenEnterDungeonCheckFailed(RetCode, FailedMember)
        else
            ErrorCode:Check(RetCode)
        end
        EventManager:FireEvent(EventID.TeamMatchTimingEnd)
        return false
    end
end

function M:DoCheckCanEnterDungeon(Avatar, DungeonId)
    if not TeamController:DoCheckCanEnterDungeon(DungeonId) then
        DebugPrint("gmy@M:DoCheckCanEnterDungeon bTeammateNotReady")
        return false
    end

    return true
end

function M:TeamMatchTimingStart(arg)
    TeamController:GetModel().bPressedSolo = true
    TeamController:GetModel().bPressedMulti = true
    self:RefreshBtnState(arg)
end

function M:TeamMatchTimingEnd(arg)
    TeamController:GetModel().bPressedSolo = false
    TeamController:GetModel().bPressedMulti = false
    self:RefreshBtnState(arg)
end


function M:DisableEscOnDungeonLoading(State)
    self.DisableEsc = State
end

AssembleComponents(M)
return M

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local UIUtils = require "Utils.UIUtils"

---@type GuideBook_Main_PC_C
local M = Class({"BluePrints.UI.BP_UIState_C","BluePrints.Common.DelayFrameComponent"})

M._components = {
    "BluePrints.UI.WidgetComponent.ChangeTextToKeyInfoComponent"    
}

function M:Construct() 
     self.Categories = {
         {
             CategoryName = GText("UI_All_Tutorial")
         },
         {
             CategoryName = GText("UI_Monster_Tutorial")
         },
         {
             CategoryName = GText("UI_Mechanism_Tutorial")
         },
         {
             CategoryName = GText("UI_Combat_Tutorial")
         },
         {
             CategoryName = GText("UI_System_Tutorial")
         },
         {
             CategoryName = GText("UI_Dungeon_Tutorial")
         },
     }
    self.CurrentListIndex = -1
    self.IsOpenDetail = false
    self.GuideNotes = {}
    self.TargetList = {}
    self.CurrentSearchContent = ""
    self.KeyText = CommonUtils:GetKeyText(CommonUtils:GetActionMappingKeyName("OpenGuideBook"))
    self:InitGuideNoteData()
    local SearchInputConfig = {
        Owner = self,
        Events = {
            OnTextChanged = self.OnContentChanged,
        },
        HintText = GText("UI_Search"),
        
    }
    self.Com_Input_Light:Init(SearchInputConfig)
    self.Com_Input_Light:SetGamePadKey("X","LS")
    self:AddDispatcher(EventID.OnGetGuideBookReward,self, self.OnGetGuideBookReward)
    self.CurrentInputDevice = {"KeyboardKey","MouseButton"}
    self.isPC = CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" and true or false
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.CurInputType = UIUtils.UtilsGetCurrentInputType()
end

function M:InitGuideNoteData()
    self.Categories[1].GuideNotes = {}
    local GuideBookData = DataMgr.GuideBook
    local Avatar = GWorld:GetAvatar()
    self.UnlockedGuideNotes = nil
    if Avatar then -- 如果有Avatar 做一遍对于是否已解锁的筛选
        self.UnlockedGuideNotes = Avatar.GuideBook
    end
    for GuideNoteId, Content in pairs(GuideBookData) do
        local ContentTemp = setmetatable({}, {__index = Content})
        local IsExist = true
        if self.UnlockedGuideNotes then
            IsExist = self.UnlockedGuideNotes[GuideNoteId]
            if IsExist then
                ContentTemp.Reward = self.UnlockedGuideNotes[GuideNoteId].Reward
            end
        end
        if IsExist then
            local GuideNoteTab = ContentTemp.GuideNoteTab
            if self.Categories[GuideNoteTab].GuideNotes == nil then
                self.Categories[GuideNoteTab].GuideNotes = {}
            end
            self.Categories[GuideNoteTab].GuideNotes[GuideNoteId] = ContentTemp
            self.Categories[1].GuideNotes[GuideNoteId] = ContentTemp -- 默认往”全部教学“里加一份
            
        end
    end 
end

-- 第一个参传Tab页签 第二个参传应该打开的GuideId（该条Guide置顶）
function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    self:SetFocus()
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "SwitchGuideBook", nil)
    local MainTabIdx
    MainTabIdx, self.InitGuideNoteId = ...
    DebugPrint("@zyhInitUIInfo", MainTabIdx, self.InitGuideNoteId)
    -- 在副本里打开默认为该副本的教学
    if not self.InitGuideNoteId then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        if GameState and GameState.GameModeType and DataMgr.DungeonTypeToId[GameState.GameModeType] then
            self.InitGuideNoteId = DataMgr.DungeonTypeToId[GameState.GameModeType].GuideNoteId
            MainTabIdx = DataMgr.GuideBook[self.InitGuideNoteId].GuideNoteTab
        end
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:InitGuideBookReddotNode()
    end
    self:InitGuideBookUI(MainTabIdx)
    -- 一些文本的初始化 后续找个位置放
    self.HudRewardTitle = GText("UI_GUIDEBOOK_REWARDS")
    self.Text_ContentEmpty:SetText(GText("UI_Tutorial_Not_Selected"))
    -------------- 手柄端 --------------------
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:AddDelayFrameFunc(function()
            self:InitGamepadView()
        end, 2)
    end
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
end


function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self:BindButtonLogics()
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:InitGuideBookUI(MainTabIdx)
    self:InitMainTab(MainTabIdx)
    
end

function M:InitMainTab(MainTabIdx)
    local TabList = {
        {
            Text = GText("UI_All_Tutorial"),
            TabId = 1,
            IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_All.T_Tab_All'",
        },
        {
            Text = GText("UI_Monster_Tutorial"),
            TabId = 2,
            IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Monster.T_Tab_Monster'",
        },
        {
            Text = GText("UI_Mechanism_Tutorial"),
            TabId = 3,
            IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Machine.T_Tab_Machine'",
        },
        {
            Text = GText("UI_Combat_Tutorial"),
            TabId = 4,
            IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Battle.T_Tab_Battle'",
        },
        {
            Text = GText("UI_System_Tutorial"),
            TabId = 5,
            IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_System.T_Tab_System'",
        },
        {
            Text = GText("UI_Dungeon_Tutorial"),
            TabId = 6,
            IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Level.T_Tab_Level'",
        },
    }
    if self.isPC then
        self.Com_Tab:Init({
            PlatformName = "PC",
            Tabs = TabList,
            DynamicNode={"Back" ,"BottomKey"},
            BottomKeyInfo = {
                {
                    GamePadInfoList =  {{ Type="Img", ImgShortPath="RV", Owner=self }},
                    Desc = GText("UI_Controller_Slide"),
                    bLongPress = false,
                },
                {
                    KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}}, 
                    GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnReturnKeyDown, Owner=self}},
                    Desc = GText("UI_BACK"),
                    bLongPress = false,
                },
            },
            OwnerPanel = self,
            BackCallback = self.CloseSelf,
            StyleName = "Icon",
            TitleName = GText("UI_Tutorial"),
        })
    else
        self.Com_Tab:Init({
            PlatformName = "Mobile",
            Tabs = TabList,
            DynamicNode={"Back" ,"BottomKey"},
            BottomKeyInfo = { { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}}, Desc = GText("UI_BACK"), bLongPress = false}},
            OwnerPanel = self,
            BackCallback = self.CloseSelf,
            StyleName = "Icon",
            TitleName = GText("UI_Tutorial"),
        })
    end
    self:UpdateTabsRedDot()
    self.Com_Tab:BindEventOnTabSelected(self, self.OnTabChanged)
    if MainTabIdx then
        self.CurrentTabIndex = MainTabIdx
    else
        self.CurrentTabIndex = 1
    end
    self.Com_Tab:SelectTab(self.CurrentTabIndex)
end

function M:OnTabChanged(TabWidget)
    self.CurrentTabIndex = TabWidget.Idx
    self:ChangeListContent()
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:AddDelayFrameFunc(function()
            self.List:SetFocus()
        end, 2)
    end
end

-- 更换Tab时调用的函数
function M:ChangeListContent()
    self.CurrentPageIndex = nil -- 切tab时清空PageIdx
    self.CurrentTabsNum = 0 --清空Tabs数量
    local Category = self.Categories[self.CurrentTabIndex]
    self.Text_ListTabTitle:SetText(Category.CategoryName)
    self.GuideNotes = self.Categories[self.CurrentTabIndex].GuideNotes
    
    local TargetList = {}
    if self.GuideNotes then
        for GuideNoteId, Content in pairs(self.GuideNotes) do
            local GuideId = Content.GuideId
            assert(DataMgr.UIGuide[GuideId], "不存在".. GuideId .. "号UIGuide") 
            local MainGuideTitle = DataMgr.UIGuide[GuideId].MainGuideTitle
            TargetList[GuideNoteId] = GText(MainGuideTitle)
        end
    end
    
    --- 刷新搜索栏里的数据 如果搜索栏里有文本 需要对GuideNotes过一遍筛选
    self:RefreshTargetList(TargetList, true)
end

--  刷新TargetList 可选是否同时进行一次筛选
function M:RefreshTargetList(NewTargetList, NeedFilter)
    -- TargetList结构 { id = Content,}
    self.TargetList = NewTargetList
    if NeedFilter then
        self:OnContentChanged(self.CurrentSearchContent)
    end
end

function M:OnContentChanged(NewText)
    self.CurrentSearchContent = NewText
    local SearchResult = self.TargetList
    if NewText ~= "" then -- 如果NewText里有内容才筛选
        SearchResult = CommonUtils.FuzzySearch(self.TargetList, NewText, true)
    end
    self:OnFilteredBySearch(SearchResult)
end

-- 传GuideNotes进来
function M:UpdateListView(GuideNotes)
    
    local TempTable = {} -- 把哈希表转为有序表进行table.sort
    for Id, Content in pairs(GuideNotes) do
        table.insert(TempTable, {Id, Content})
    end
    
    ---这里如果有Avatar 接一段关于新旧排序的
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        table.sort(TempTable, function(A, B)
            local Id_A, Id_B = A[1], B[1]
            if Id_A == self.InitGuideNoteId then
                return true
            elseif Id_B == self.InitGuideNoteId then
                return false
            end
            if self.UnlockedGuideNotes[Id_A].Reward ~= self.UnlockedGuideNotes[Id_B].Reward then
                return self.UnlockedGuideNotes[Id_A].Reward > self.UnlockedGuideNotes[Id_B].Reward
            else
                return self.UnlockedGuideNotes[Id_A].Sort > self.UnlockedGuideNotes[Id_B].Sort
            end
        end)
        for _,Content in ipairs(TempTable) do
            Content[2].Reward = self.UnlockedGuideNotes[Content[1]].Reward
        end
    end
    
    DebugPrint("ClearListItems")
    if self.SelectedItem then -- 由GuideBook_ListCell传过来的
        self.SelectedItem:_OnCellUnSelect()
        --self.SelectedItem.Text_GuideName:SetDefaultColorAndOpacity(self.Text_NormalColor)
        DebugPrint("清空选择项")
        self.SelectedItem = nil
    end
    self.List:ClearListItems() -- 清空当前有的内容
    self.CurrentListIndex = -1
    
    -- 清空Content画面
    self.IsOpenDetail = false
    self.Group_Title:SetVisibility(ESlateVisibility.Collapsed)
    self.Content:SetVisibility(ESlateVisibility.Collapsed)
    self.Group_ContentEmpty:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_DescTitle:SetVisibility(ESlateVisibility.Collapsed)
    self.WS_Bottom:SetActiveWidgetIndex(0)
    
    if CommonUtils.Size(GuideNotes) <= 0 then
        self.GameInputModeSubsystem:SetNavigateWidgetVisibility(false)
        self.Group_ListEmpty:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Group_ListNormal:SetVisibility(ESlateVisibility.Collapsed)
        if self.Com_Input_Light:GetText() ~= "" then
            self.Text_Empty:SetText(GText("UI_Matches_Not_Found"))
        else
            self.Text_Empty:SetText(GText("UI_Tutorial_Not_Unlocked"))
        end
        return
    end
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and not self.Com_Input_Light:HasFocusedDescendants() then
        self.GameInputModeSubsystem:SetNavigateWidgetVisibility(true)
    end
    
    -- 往List里塞新的东西
    self.Group_ListEmpty:SetVisibility(ESlateVisibility.Collapsed)
    self.Group_ListNormal:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.CurrentTabsNum = CommonUtils.Size(GuideNotes)
    local Index = 0
    for _, Content in ipairs(TempTable) do
        local Obj = NewObject(self.ListContentClass)
        local GuideId = Content[2].GuideId
        Obj.Title = Content[2].MainGuideTitle
        Obj.Parent = self
        Obj.GuideId = GuideId 
        Obj.Index = Index
        Obj.GuideNoteId = Content[1]
        Obj.Reward = Content[2].Reward
        Obj.IsEmpty = false
        if (Index == 0 and self.Com_Input_Light:GetText() == "") then
            self.InitGuideNoteId = Content[1]  -- 小功能 自动选中第一条
        end
        Index = Index + 1
        self.List:AddItem(Obj)
    end
    if (CommonUtils.Size(TempTable) > 0 and self.Com_Input_Light:GetText() == "") then
        self:AddTimer(0.01, function()
            local ListItemUIs = self.List:GetDisplayedEntryWidgets()
            local RestCount = UIUtils.GetListViewContentMaxCount(self.List, ListItemUIs) - ListItemUIs:Length()
            DebugPrint(RestCount, "需要生成的空格")
            for i = 1, RestCount do
                self.List:AddItem(self:CreateEmptyContent())
            end
            self.List:ScrollToTop()
        end)
    end
end

function M:CreateEmptyContent()
    local Obj = NewObject(self.ListContentClass)
    Obj.IsEmpty = true
    return Obj
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "Escape" or InKeyName == Const.GamepadFaceButtonRight then
        self:CloseSelf()
    elseif InKeyName == "Q" or InKeyName == Const.GamepadLeftShoulder then
        self.Com_Tab:TabToLeft()
    elseif InKeyName == "E" or InKeyName == Const.GamepadRightShoulder then
        self.Com_Tab:TabToRight()
    elseif InKeyName == "W" then
        DebugPrint("执行一次上移")
        if self.CurrentListIndex > 0 then
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
            local GuideId = self.List:GetItemAt(self.CurrentListIndex-1).GuideId
            self:OpenDetail(GuideId, self.CurrentListIndex-1)
        end
    elseif InKeyName == "S" then
        if self.CurrentListIndex < self.CurrentTabsNum - 1 then -- 写个变量存当前有多少条目
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
            local GuideId = self.List:GetItemAt(self.CurrentListIndex+1).GuideId
            self:OpenDetail(GuideId, self.CurrentListIndex+1)
        end
    elseif InKeyName == "Right" or InKeyName == "D" or InKeyName == Const.GamepadRightTrigger then
        if self:PureCheckCanChangePage(1) then
            self.Button_Next:SoundFunc()
        end
        self:SwitchToRight()
    elseif InKeyName == "Left" or InKeyName == "A" or InKeyName == Const.GamepadLeftTrigger then
        if self:PureCheckCanChangePage(-1) then
            self.Button_Previous:SoundFunc()
        end
        self:SwitchToLeft()
    elseif InKeyName == self.KeyText then
        if self.CanCloseByHotKey then
            self:CloseSelf()
        end
    elseif InKeyName == Const.GamepadFaceButtonLeft then
        self.Com_Input_Light:SetFocus()
    elseif InKeyName == Const.GamepadLeftThumbstick then
        self.Com_Input_Light:OnDeleteBtnClicked()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == self.KeyText then
        self.CanCloseByHotKey = true
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local AddOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
    if InKeyName == "Gamepad_RightY" then
        local CurScrollOffset = self.EMScrollBox_Desc:GetScrollOffset()
        local ScrollOffset = math.clamp(CurScrollOffset - AddOffset,0, self.EMScrollBox_Desc:GetScrollOffsetOfEnd())
        self.EMScrollBox_Desc:SetScrollOffset(ScrollOffset)
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

-- 打开详情 由GuideBook_ListCell调用 传参
function M:OpenDetail(GuideId, Index)
    if(not self.IsOpenDetail) then
        self.Group_Title:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Content:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Group_ContentEmpty:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.IsOpenDetail = true
    self.CurrentGuideId = GuideId
    self.CurrentListIndex = Index
    self.List:SetSelectedIndex(Index)
    self.List:ScrollIndexIntoView(Index)
    self.EMScrollBox_Desc:ScrollToStart()
    self:InitInfo(GuideId)
    local Avatar = GWorld:GetAvatar()
    if Avatar:IsInDungeon() then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("Quest_Tips_GuideBookInDungeon"))
        return
    end
    local GuideNoteId = self.List:GetItemAt(Index).GuideNoteId
    local HasReward =  self.UnlockedGuideNotes[GuideNoteId].Reward
    local IsGettingReward = self.UnlockedGuideNotes[GuideNoteId].IsGettingReward
    if HasReward == 1 and (IsGettingReward == nil or IsGettingReward == 0) then
        self.UnlockedGuideNotes[GuideNoteId].IsGettingReward = 1
        self:GetReward(GuideNoteId)
    end
end

function M:OnFilteredBySearch(SearchResult)
    DebugPrint("OnFilteredBySearch")
    local FilteredGuideNotes = {}
    for Id,Content in pairs(SearchResult) do
        FilteredGuideNotes[Id] = self.GuideNotes[Id]
        FilteredGuideNotes[Id].MainGuideTitle = Content
    end
    self:UpdateListView(FilteredGuideNotes)
end

function M:GetReward(GuideNoteId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:GuideBookGetReward(GuideNoteId)
    end
end

function M:OnGetGuideBookReward(GuideNoteId)
    self:UpdateTabsRedDot()
    
    local RewardId = DataMgr.GuideBook[GuideNoteId].RewardId
    local RewardInfo = DataMgr.Reward[RewardId]
    if self.RewardList == nil then
        self.RewardList = {}
    end
    if RewardInfo then
        local RewardIds = RewardInfo.Id or {}
        local RewardCounts = RewardInfo.Count or {}
        local RewardTypes = RewardInfo.Type or {}
        for i = 1, #RewardIds do
            local ItemId = RewardIds[i]
            local Count = RewardUtils:GetCount(RewardCounts[i])
            local Rarity = ItemUtils.GetItemRarity(ItemId, RewardTypes[i])
            local ItemType = RewardTypes[i]
            local RewardContent = {
                ItemId = ItemId,
                ItemType = ItemType,
                Count = Count,
                Rarity = Rarity,
            }
            table.insert(self.RewardList, RewardContent)
        end
    end
end

function M:UpdateTabsRedDot()
    DebugPrint("UpdateTabsRedDot Called!")
    for GuideNoteTab, Category in pairs(self.Categories) do
        self.Com_Tab:ShowTabRedDot(GuideNoteTab, false)
        if Category.GuideNotes then
            for GuideNoteId,_ in pairs(Category.GuideNotes) do
                if self.UnlockedGuideNotes[GuideNoteId].Reward == 1 then
                    self.Com_Tab:ShowTabRedDot(GuideNoteTab, true)
                    break
                end
            end
        end
    end
end

--------------------UIGuide的主体内容，大体上和Guide_Image_Main保持一致------------------------------------------
function M:BindButtonLogics()
    self.Button_Previous:BindEventOnClicked(self, self.SwitchToLeft)
    self.Button_Next:BindEventOnClicked(self, self.SwitchToRight)
end

function M:InitInfo(GuideId)
    self.Button_Previous:SetText(GText("UI_UIGUIDE_PREV"))
    self.Button_Next:SetText(GText("UI_UIGUIDE_NEXT"))
    if self.isPC then
        self.Key_Previous:CreateCommonKey({ KeyInfoList = {{Type = "Img", ImgShortPath = "LT"}} })
        self.Key_Next:CreateCommonKey({ KeyInfoList = {{Type = "Img", ImgShortPath = "RT"}} })
    end
    self.HasReachEnd = false
    self.GuideMessageArray = DataMgr.UIGuide[GuideId].ChildGuideId
    self.StartPageIndex = 1
    self.CurrentPageIndex = 1
    self.EndPageIndex = #self.GuideMessageArray
    self:AddDelayFrameFunc(function()
        self.PageTurner:InitPageTurner(self.EndPageIndex, self, self.UpdateGuideInfo)
    end, 3, "DelayInit")

    if self.StartPageIndex == self.EndPageIndex then
        self.WS_Bottom:SetActiveWidgetIndex(0)
        -- self.HasReachEnd = true
    else
        self.WS_Bottom:SetActiveWidgetIndex(1)
        self.Button_Previous:ForbidBtn(true)
        
    end
    self:UpdateNumStep()
    self:UpdateUIVisibility()
    self:UpdateTextInfo(self.GuideMessageArray[self.CurrentPageIndex])
end

function M:UpdateGuideInfo(NewPageIndex)
    if self.CurrentPageIndex == NewPageIndex then
        DebugPrint("@zyh 111", NewPageIndex, self.CurrentPageIndex)
        return
    end
    if not self:CheckCanSwitchPage(NewPageIndex-self.CurrentPageIndex) then
        DebugPrint("@zyh 222", NewPageIndex, self.CurrentPageIndex)

        return
    end
    DebugPrint("@zyh 333")
    self.CurrentPageIndex = NewPageIndex
    self:UpdateUIVisibility()
    self:UpdateTextInfo(self.GuideMessageArray[self.CurrentPageIndex])
end

function M:UpdateNumStep()
    for i = 1,4 do
        self["Guide_"..i]:SetNumStep(i)
    end
end

function M:UpdateTextInfo(ChildGuideId)
    if not ChildGuideId then
        return
    end
    -- 更新主标题
    local TitleTextMapId = DataMgr.UIChildGuide[ChildGuideId].GuideTitle
    self.Text_DescTitle:SetText(GText(TitleTextMapId))
    if(self.Text_DescTitle:GetVisibility() == ESlateVisibility.Collapsed) then
        self.Text_DescTitle:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    self.DescText = ""
    local ChildGuideType = DataMgr.UIChildGuide[ChildGuideId].GuideType
    
    -- 判断子页面数量 更新可见性
    for i = 1,4 do
        if DataMgr.UIChildGuide[ChildGuideId]["GuideInfo"..i] then
            self["Guide_"..i]:SetGuideType(ChildGuideType)
            self["Guide_"..i]:UpdateContent(ChildGuideId, i, self.isPC)
            self:GatherAllCellText(ChildGuideId, i, self.isPC, ChildGuideType)
            self["Guide_"..i]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            self["Guide_"..i]:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
    ---吐血了，差点被换行符搞死...
    self.Guide_Desc_Text:SetText(string.trim(GText(self.DescText)))
    self.Guide_Desc_Text:SetVisibility(UIConst.VisibilityOp.Hidden)
    self:StopAnimation(self.Change)
    self:PlayAnimation(self.Change)
    self:AddTimer(0.05, function()
        UIUtils.SetTextJustificationByLineCount(self.Guide_Desc_Text)
        self.Guide_Desc_Text:SetVisibility(UIConst.VisibilityOp.Visible)
    end)
    -- 手机端跳过下面 -- 
    if not self.isPC then
        return
    end
    self:AddTimer(self.Change:GetEndTime(), function()
        if UIUtils.CheckScrollBoxCanScroll(self.EMScrollBox_Desc) then
            self.Com_Tab:UpdateBottomKeyInfo({
                {
                    GamePadInfoList =  {{ Type="Img", ImgShortPath="RV", Owner=self }},
                    Desc = GText("UI_Controller_Slide"),
                    bLongPress = false,
                },
                {
                    KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
                    GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnReturnKeyDown, Owner=self}},
                    Desc = GText("UI_BACK"),
                    bLongPress = false,
                },
            })
        else
            self.Com_Tab:UpdateBottomKeyInfo({
                {
                    KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
                    GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnReturnKeyDown, Owner=self}},
                    Desc = GText("UI_BACK"),
                    bLongPress = false,
                },
            })
        end
    end)
end

function M:GatherAllCellText(ChildGuideId, i, isPC, ChildGuideType)
    self.ChildInfo = DataMgr.UIChildGuide[ChildGuideId]["GuideInfo"..i]
    local ContentText = nil
    if isPC then
        ContentText = GText(self.ChildInfo.GuideContent.PC)
        if self.ChildInfo.GuideContent.GamePad and self.CurInputType == ECommonInputType.Gamepad then
            ContentText = GText(self.ChildInfo.GuideContent.GamePad)
        end
    else
        ContentText = GText(self.ChildInfo.GuideContent.Phone)
    end
    
    local ChildGuideDescValues = self.ChildInfo.GuideDescValues
    ContentText = self:AnalyzeGuideDesc(ContentText, ChildGuideDescValues)
    ContentText = self:GetFinalContentText(ContentText)
    if ChildGuideType == "ProcessNode" then
        ContentText = Const.IndexNum[i] .. ContentText
    end
    self.DescText = self.DescText .. ContentText .. "\r\n"
end

-- 向左切页
function M:SwitchToLeft()
    if not self:CheckCanSwitchPage(-1) then
        return
    end
    self.PageTurner:PageLeft()
end

-- 向右切页
function M:SwitchToRight()
    if not self:CheckCanSwitchPage(1) then
        return
    end
    self.PageTurner:PageRight()
end

-- 判断能否切页
-- Adjective 是切的页数, 1 向右, -1 向左
function M:CheckCanSwitchPage(Adjective)
    if not self.CurrentPageIndex then
        return false
    end
    if self.CurrentPageIndex + Adjective < self.StartPageIndex or self.CurrentPageIndex + Adjective > self.EndPageIndex then
        return false
    end
    return true
end

function M:PureCheckCanChangePage(Adjective)
    if not self.CurrentPageIndex then
        return false
    end
    local TargetPageIndex = self.CurrentPageIndex + Adjective
    if TargetPageIndex < self.StartPageIndex or TargetPageIndex > self.EndPageIndex then
        return false
    end
    return true
end

-- 更新 Button 的显隐
function M:UpdateUIVisibility()
    if self.CurrentPageIndex == self.EndPageIndex and not self.HasReachEnd then
        self.HasReachEnd = true
    end
    if self.CurrentPageIndex == self.StartPageIndex then
        self.Button_Previous:ForbidBtn(true)
    else
        self.Button_Previous:ForbidBtn(false)
    end
    if self.CurrentPageIndex == self.EndPageIndex then
        self.Button_Next:ForbidBtn(true)
    else
        self.Button_Next:ForbidBtn(false)
    end
end

---------------------手柄端部分----------------------
function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    self.Super.OnUpdateUIStyleByInputTypeChange(self, CurInputType, CurGamepadName)
    if self.CurInputType ~= CurInputType then
        if CurInputType == ECommonInputType.Gamepad then
            self:InitGamepadView()
        else
            self:InitKeyboardView()
        end
        for i=1,4 do
            self["Guide_"..i]:UpdateTextOnInputDeviceChanged(self.CurInputType)
        end
        if self.GuideMessageArray then
            self:UpdateTextInfo(self.GuideMessageArray[self.CurrentPageIndex])
        end
    end
    self.CurInputType = CurInputType
end

function M:InitGamepadView()
    self.CurrentInputDevice = {"GamepadKey"}
    self.Button_Previous:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Button_Next:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Key_Previous:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Key_Next:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.List:SetFocus()
end

function M:InitKeyboardView()
    self.CurrentInputDevice = {"KeyboardKey","MouseButton"}
    self.Button_Previous:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Button_Next:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if self.isPC then
        self.Key_Previous:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Key_Next:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:CloseSelf()
    if self:IsAnimationPlaying(self.Auto_In) then
        return -- 【【动效规则】部分系统打开的时候动效规则需要调整——客户端】
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar then -- 关闭
        Avatar:ClearGuideBookReddotCount()
    end
    AudioManager(self):SetEventSoundParam(self, "SwitchGuideBook", { ToEnd = 1 })
    self:Close()
    if self.RewardList and #self.RewardList > 0 then
        local MenuWorld=UIManager(self):GetUIObj("MenuWorld")
        if MenuWorld then
            MenuWorld:ShowHudRewardAfterClose(self.HudRewardTitle, self.RewardList)
        else
            UIUtils.ShowHudReward(self.HudRewardTitle, self.RewardList)
        end
        
    end
end


AssembleComponents(M)
return M

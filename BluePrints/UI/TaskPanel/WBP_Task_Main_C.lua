--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Task_Main_PC_C
local WBP_Task_Main = Class("BluePrints.UI.BP_UIState_C")
local UIUtils = require "Utils.UIUtils"
local EMCache = require "EMCache.EMCache"
local TimeUtils = require "Utils.TimeUtils"

local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"

local ReasoningUtils = require "BluePrints.UI.WBP.DetectiveMinigame.ReasoningUtils"
local GuidePointLocData = require ("BluePrints.UI.TaskPanel/QuestGuidePointLocData")

local TABALL_ID = 99  -- 用于标记面板的第一个选项
local QuestRealStateEnum = {
    Lock = 0, -- 0 锁定
    Doing = 1, -- 1 进行中限时
    Finished = 2, -- 2 已完成
    InProgress = -1 -- -1 进行中不限时 (@lhq 2024.1.15暂时废弃)
}

local ConstQuestTabData = {}

function WBP_Task_Main:Initialize(Initializer)
    self.Super.Initialize(self)
    self.AllTabInfo = {}
    self.CurTabId = nil
    self.SaveTabId = nil
    self.CurSelectQuest = nil    ---@type Task_SubItem 当前选中的任务
    self.CurTrackingQuest = nil  ---@type Task_SubItem 当前所追踪的任务
    self.TrackingQuestId = nil   ---@type number 当前所追踪的任务链Id
    self.IsTracking = false
    self.IsFristOpen = true
    self.CurPlayerCharacterLevel = 0
    self.JumpQuestChainId = nil
    self.PlatformName = nil
    self.CurFocusWidget = nil  --当前聚焦的widget
    self.IsCanCloseByHotKey = false
end

function WBP_Task_Main:Construct()
    self:InitListenEvent()

    ReddotManager.AddListener("DetectiveQuestion",self,self.UpdateReasoningRedDot)
    ReddotManager.AddListener("DetectiveAnswer",self,self.UpdateReasoningRedDot)
    EventManager:AddEvent(EventID.CheckShowMap,self, self.CheckNeedShowLevelMap)
end 

function WBP_Task_Main:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    local JumpQuestId = ...
    if ... ~= nil then
        self.JumpQuestChainId = tonumber(JumpQuestId)
    end
    self.IsCanReceive = true
    self:RenameWidget()
    self:InitDetailInfo()
    self:InitTrackingButton()
    self:InitTabInfo()
    self:UpdateListViewScrollMultiplier(self.RootWidget.List_Task, 10)
    if self.RootWidget.List_Task.ListItems:Num() ~= 0 then
        self.RootWidget.List_Task:SetScrollbarVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.RootWidget.List_Task:SetScrollbarVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.RootWidget.Btn_Jump:BindEventOnClicked(self, self.OnClickJumpBtn)
    self.RootWidget.Btn_Giveup:BindEventOnClicked(self, self.OnClickGiveUpBtn)
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    self.CurPlayerCharacterLevel = PlayerCharacter:GetAttr("Level")
    if self:IsAnimationPlaying(self.In) then
        return
    end
    self:PlayAnimation(self.In)
    
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "OpenTaskMain", nil)
    self.RootWidget.List_Task:SetNavigationRuleCustom(EUINavigation.Right, {self, self.OnNavigationRight})

    self.RootWidget.Group_TaskDetail:SetNavigationRuleCustom(UE4.EUINavigation.Left, {self, function()
        if self.CurFocusWidget then
            self.CurFocusWidget.Task_SubItem:SetFocus()
        end
    end})

end


-- 初始化Tab，包括绑定切换Tab的回调函数，设置按键文本等
function WBP_Task_Main:InitTabInfo()
    local TryGetTabData = function(InQuestType)
        for _, Data in pairs(DataMgr.QuestTab) do
            if Data and Data.QuestType == InQuestType then
                return Data
            end
        end

        return nil
    end

    self.TempQuestTabData = 
    {
        [1] = TryGetTabData(Const.AllQuestChainType),
        [2] = TryGetTabData(Const.MainQuestChainType),
        [3] = TryGetTabData(Const.MainActivityQuestChainType),
        [4] = TryGetTabData(Const.LimTimeQuestChainType),
        [5] = TryGetTabData(Const.SpecialSideQuestChainType),
        [6] = TryGetTabData(Const.SideQuestChainType),
        [7] = TryGetTabData(Const.DailyQuestChainType),
    }
    local Index = 1
    for Index, Data in pairs(self.TempQuestTabData) do
        if Data then
            ConstQuestTabData[Index] = Data
            Index = Index + 1
        end
    end


    for k, v in pairs(ConstQuestTabData) do
        local Info = v
        if Info then 
            table.insert(self.AllTabInfo, {Text = GText(Info.TabName), TabId = k, IconPath = Info.Icon})
        end
    end

    self.CommonTabWidget:Init(
        {
            TitleName = GText("MAIN_UI_QUEST"),
            LeftKey = "Q",
            RightKey = "E",
            Tabs = self.AllTabInfo,
            DynamicNode = {"Back", "BottomKey"},
            BottomKeyInfo = { {KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.OnReturnKeyDown, Owner=self}}, Desc=GText("UI_BACK")} },
            StyleName = "Text",
            OwnerPanel = self,
            BackCallback = self.OnReturnKeyDown  -- 绑定返回按键执行的函数
        }
    )

    for _, Data in pairs(self.TempQuestTabData) do
        if Data then
            local RedDotName = Data.TabName
            local TabId = Data.TabId
            ReddotManager.AddListenerEx(RedDotName, self, function(self, Count, RdType, RdName)
                if Count > 0 then
                    self.CommonTabWidget:ShowTabRedDotByTabId(TabId, true, false, false)             
                else
                    self.CommonTabWidget:ShowTabRedDotByTabId(TabId, false, false, false)
                end
            end)
        end
    end

    --self:UpdateTabWidgetReddot()

    self.CommonTabWidget:BindEventOnTabSelected(self, self.OnTabChange)
    local CurTabId = EMCache:Get("QuestPantlTab", true)
    if CurTabId ~= nil and false then -- and false 是因为规则修改成默认打开第一个Tab，暂时保留
        self.CommonTabWidget:SelectTab(CurTabId)
    else
        self.CommonTabWidget:SelectTab(1)
    end
    
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local UnlockedQuestions = Avatar.DetectiveGameUnlockedQuestions
    if UnlockedQuestions ~= nil then
        local Count = 0
        for _, _ in pairs(UnlockedQuestions) do
            Count = Count + 1
        end
        if Count > 0 then
            self.CommonTabWidget.Pos_Reasoning:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.CommonTabWidget.ReasoningEntrance = UIManager(self):CreateWidget("WidgetBlueprint'/Game/UI/WBP/Reasoning/Widget/WBP_Reasoning_Entrance.WBP_Reasoning_Entrance'", true)
            self.CommonTabWidget.ReasoningEntrance.Text:SetText(GText("Minigame_Textmap_100304"))
            self.CommonTabWidget.Pos_Reasoning:ClearChildren()
            self.CommonTabWidget.Pos_Reasoning:AddChildToOverlay(self.CommonTabWidget.ReasoningEntrance)
            self.CommonTabWidget.ReasoningEntrance.Btn_Click.OnClicked:Add(self, self.OnClickReasoningEntrance)
            self.CommonTabWidget.ReasoningEntrance.Key_GamePad:CreateCommonKey({
                KeyInfoList={
                    {
                        Type = "Img",
                        ImgShortPath = "Menu"
                    }
                }
            })
            if self.UsingGamepad then
                self.CommonTabWidget.ReasoningEntrance.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            end
        end
    end
    self:UpdateReasoningRedDot()
end

function WBP_Task_Main:UpdateTabWidgetReddot()
    -- local AllQuestChainReddotCache = EMCache:Get("AllQuestChainReddotSet", true) or {}
    -- local IsAllQuestCheck = true
    -- local Avatar = GWorld:GetAvatar()
    -- if not Avatar then
    --     return
    -- end
	-- for Type, Caches in pairs(AllQuestChainReddotCache) do
	-- 	for ChainId, _ in pairs(Caches) do
	-- 		if Avatar.QuestChains[ChainId] and Avatar.QuestChains[ChainId].State == 3 then
	-- 			AllQuestChainReddotCache[Type][ChainId] = true
	-- 		end
	-- 	end
	-- end
	-- EMCache:Set("AllQuestChainReddotSet", AllQuestChainReddotCache, true)

    -- if not IsEmptyTable(AllQuestChainReddotCache) then
    --     for _, QuestChainTypeTabData in pairs(AllQuestChainReddotCache) do
    --         for _, IsCheck in pairs(QuestChainTypeTabData) do
    --             if not IsCheck then
    --                 IsAllQuestCheck = false
    --                 break
    --             end
    --         end
    --     end
    -- end

    -- local TabNewTable = {}
    -- if not IsEmptyTable(AllQuestChainReddotCache) then
    --     for Type, QuestChainTypeTabData in pairs(AllQuestChainReddotCache) do
    --         local IsAllCheck = false
    --         for _, IsCheck in pairs(QuestChainTypeTabData) do
    --             if not IsCheck then
    --                 TabNewTable[Type] = IsAllCheck
    --                 goto continue
    --             end
    --         end
    --         IsAllCheck = true
    --         TabNewTable[Type] = IsAllCheck
    --         ::continue::
    --     end
    -- end

    -- for k, v in pairs(ConstQuestTabData) do
    --     if v.QuestType == Const.AllQuestChainType then
    --         self.CommonTabWidget:ShowTabRedDot(1, not IsAllQuestCheck, false)
    --     else
    --         if TabNewTable[v.QuestType] ~= nil then
    --             self.CommonTabWidget:ShowTabRedDot(k, not TabNewTable[v.QuestType], false)
    --         else
    --             self.CommonTabWidget:ShowTabRedDot(k, false, false)
    --         end
    --     end
    -- end

     -- local Index= 1
            -- for k, v in pairs(ConstQuestTabData) do
            --     if v.QuestType == Type then
            --         Index = k
            --         break
            --     end
            -- end

            -- if IsAllCheck then
            --     self.CommonTabWidget:ShowTabRedDot(Index, false, false)
            -- else
            --     self.CommonTabWidget:ShowTabRedDot(Index, true, false)
            -- end
end

function WBP_Task_Main:TriggerLevelHardWarningUIShow(QuestChainId, QuestId)
    local TaskInfo = TaskUtils:GetQuestDetail(QuestChainId, QuestId)
    local ConfigRecommandLevel = nil
    if TaskInfo ~= nil then
        ConfigRecommandLevel = TaskUtils:GetQuestDetail(QuestChainId, QuestId).RecommendLevel
    end
    if ConfigRecommandLevel ~= nil and ConfigRecommandLevel > self.CurPlayerCharacterLevel then
        self.RootWidget.Text_HardWarning:SetText(GText("UI_QUEST_TOOHARD"))
        self.RootWidget.HB_HardWarning:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.RootWidget.HB_HardWarning:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_Task_Main:OnTabChange(TabWidget)
    EventManager:FireEvent(EventID.OnSelectQuestSubItem, nil) -- 强制刷新
    local TabId = TabWidget.Idx
    self.CurTabId = TabId
    local QuestData = self:GetQuestData(TabId) or {} --- { QuestType = { [1] = {SOMEDATA},[2] = {SOMEDATA} } }
    self.RootWidget.List_Task:ClearListItems()
    self.CurSelectQuest = nil
    -- self.ScrollBox_TaskList:ScrollToStart()

    -- 获取切换Tab后要显示的任务链Id，当前Tab有追踪任务显示追踪任务，否则显示第一个
    local CurTabFirstQuestChainId = self:GetCurTabFirstQuestId(QuestData, TabId)
    self.CurSelectId = 0
    if self.TrackingQuestId and self:IsInTab(self.TrackingQuestId, TabId) then
        self.CurSelectId = self.TrackingQuestId
    else
        local LastSelectId = TaskUtils.TaskMainLastSelectId
        if LastSelectId == 0 or LastSelectId == nil then
            self.CurSelectId = CurTabFirstQuestChainId
        else
            self.CurSelectId = LastSelectId
        end
    end
    if self.JumpQuestChainId ~= nil then
        self.CurSelectId = self.JumpQuestChainId
        self.JumpQuestChainId = nil 
    end
    --
    local Count = 0
    local IsExistSelectId = false
    for _, QuestChains in pairs(QuestData) do
        for index = 1, #QuestChains do
            local IsShowType = false
            local Data = QuestChains[index]
            if index == 1 then
                IsShowType = true -- 一个Tab中只有第一个任务需要显示类型
            end
            local ListItemContent = nil
            if QuestChains[1] and QuestChains[1].QuestChainId == -1 then
                ListItemContent =
                TaskUtils:CreateListItemContent(
                {
                    DoingQuestId = -1,
                    QuestChainId = -1,
                    CompletedQuestId = -1,
                    OwnerWidget = self,
                    State = 1,
                    IsShowType = IsShowType,
                    IsTracking = false,
                    IsSelectDoingQuest = Data.QuestChainId == self.CurSelectId,
                    UI = nil
                }

            )
            else
                ListItemContent =
                TaskUtils:CreateListItemContent(
                {
                    DoingQuestId = Data.DoingQuestId,
                    QuestChainId = Data.QuestChainId,
                    CompletedQuestId = Data.CompleteQuestId,
                    OwnerWidget = self,
                    State = Data.State,
                    IsShowType = IsShowType,
                    IsTracking = self.TrackingQuestId and self.TrackingQuestId == Data.QuestChainId,
                    IsSelectDoingQuest = Data.QuestChainId == self.CurSelectId,
                    UI = nil
                }
            )
            end

            if ListItemContent.IsSelectDoingQuest then
                IsExistSelectId = true
            end
            self.RootWidget.List_Task:AddItem(ListItemContent)
            -- TODO CE8暂时处理  后续有不同的蓝图的时候需要改
            Count = Count + 2
        end
    end

    local Pre = nil
    for key, value in ipairs(self.RootWidget.List_Task:GetListItems():ToTable()) do
        value.PreItem = Pre
        Pre = value
        local Next = self.RootWidget.List_Task:GetItemAt(key)
        if Next then
            value.NextItem = Next
        else
            value.NextItem = nil
        end
    end
    -- local TrackItem = nil
    -- for key, value in ipairs(self.RootWidget.List_Task:GetListItems():ToTable()) do
    --     if value.IsTracking then
    --         TrackItem = value
    --         return
    --     end
    -- end

    -- self.RootWidget.List_Task:BP_CancelScrollIntoView()
    -- self.RootWidget.List_Task:BP_SetSelectedItem(TrackItem)
    -- self.RootWidget.List_Task:BP_NavigateToItem(Item)
    if not IsExistSelectId then
        self.CurSelectId = CurTabFirstQuestChainId
    end

    -- TabId = TabId == 1 and TABALL_ID or TabId - 1 -- TabId == 1代表当前的Tab类型为所有任务，否则是某个类型的任务，此时需要-1，以访问到表里正确的数据
    -- local EmptyNeed = math.max((DataMgr.QuestTab[TabId].FillUpTo or 0) - Count, 0)
    if self.PlatformName == "PC" then
        self.RootWidget.Group_TaskList:SetWidthOverride(self.RootWidget.Size_Group_TaskList_P)
    elseif self.PlatformName == "Mobile" then
        self.RootWidget.Group_TaskList:SetWidthOverride(self.RootWidget.Size_Group_TaskList_M)
    end
    if Count > 0 then
        self.IsTaskEmpty = false
        self.RootWidget.Group_TaskDetail_Empty:SetVisibility(UE4.ESlateVisibility.Collapsed)
        -- self.ScrollBox_TaskList:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.RootWidget.Group_TaskDetail:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.RootWidget.Group_TaskList:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        -- for i = 1, EmptyNeed do
        --     local EmptyItem = TaskUtils:CreateListItemContent({IsEmpty = true})
        --     self.RootWidget.List_Task:AddItem(EmptyItem)
        -- end
        self.RootWidget.List_Task:SetScrollbarVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    else -- 空页面
        self.IsTaskEmpty = true
        self.RootWidget.Group_TaskDetail_Empty:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        -- self.ScrollBox_TaskList:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.RootWidget.Group_TaskDetail:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.RootWidget.Group_TaskList:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.RootWidget.Text_MailDetail_Empry:SetText(GText("UI_QUEST_CLEAR"))
        self.RootWidget.List_Task:SetScrollbarVisibility(UE4.ESlateVisibility.Collapsed)
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)  
        if self.UsingGamepad then
            self:InitTabPadKeyInfoForBack()
        end
    end

    self:InitDetailInfo()  -- 针对详情页面，先折叠一些内容
    self.RootWidget:BindToAnimationFinished(self.RootWidget.Tab_Change,{self,function ()
        self:ScrollToSelectedWidget(self.CurSelectId)  -- 滑动到被选中的任务(追踪/第一个)（一些操作需要等控件被渲染出来，所以绑定到动画结束后）
        self.RootWidget:UnbindAllFromAnimationFinished(self.RootWidget.Tab_Change)
    end})
    self.RootWidget:PlayAnimation(self.RootWidget.Tab_Change)
    self.CurTrackWidget = nil
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

---@param QuestType number 任务类型，QuestChains表第二列
---@return Result table
function WBP_Task_Main:GetQuestData(TabId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local AllQuestData = Avatar.QuestChains or {}
    local Result = {}
    self.HasToBeContinued = true
    local ChoiceQuestType = ConstQuestTabData[TabId].QuestType
    if ChoiceQuestType == -1 or ChoiceQuestType == 1 then
        for QuestChainId, Data in pairs(AllQuestData) do
            if DataMgr.QuestChain[QuestChainId] then
                local QuestChainType = DataMgr.QuestChain[QuestChainId].QuestChainType
                local IsShowByCheck = self:CheckQuestIsShowByCheckState(QuestChainId, Data)
                if Data.State ~= 3 and Data.CanShow and IsShowByCheck then
                    local Type = DataMgr.QuestChain[QuestChainId].QuestChainType
                    if Type == 1 or Type == 6 then
                        self.HasToBeContinued = false
                        break
                    end
                end
            end
        end
    else
        self.HasToBeContinued = false   
    end
    if self.HasToBeContinued then
        Result[1] = Result[1] or {}
        table.insert(Result[1], {QuestChainId = -1})
    end
    
    local MaxQuestType = 0
    if ChoiceQuestType == -1 then
        for QuestChainId, Data in pairs(AllQuestData) do
            if DataMgr.QuestChain[QuestChainId] then
                local QuestChainType = DataMgr.QuestChain[QuestChainId].QuestChainType
                local IsShowByCheck = self:CheckQuestIsShowByCheckState(QuestChainId, Data)
                if Data.State ~= 3 and Data.CanShow and IsShowByCheck then
                    Result[QuestChainType] = Result[QuestChainType] or {}
                    table.insert(Result[QuestChainType], Data)
                end
            else
                local Message = string.format("任务面板不显示任务： %s", QuestChainId)
                UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "账号已有任务服务器数据，但任务表内数据已不存在", Message)
            end
        end
    else
        for QuestChainId, Data in pairs(AllQuestData) do
            if DataMgr.QuestChain[QuestChainId] then
                local QuestChainType = DataMgr.QuestChain[QuestChainId].QuestChainType
                local IsShowByCheck = self:CheckQuestIsShowByCheckState(QuestChainId, Data)
                if Data.State ~= 3 and Data.CanShow and QuestChainType == ChoiceQuestType and IsShowByCheck then
                    Result[QuestChainType] = Result[QuestChainType] or {}
                    table.insert(Result[QuestChainType], Data)
                end
            else
                local Message = string.format("任务面板不显示任务: %s", QuestChainId)
                UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "账号已有任务服务器数据，但任务表内数据已不存在", Message)
            end
        end
    end


    for k, v in pairs(Result) do
        table.sort(Result[k],function(a,b) return a.QuestChainId<b.QuestChainId end)
    end

    if TabId ~= 1 then --tab不为1直接返回
        return Result
    end
    local RetTable = {}
    for Index, Data in pairs(ConstQuestTabData) do
        if Data and Data.QuestType and Data.QuestType ~= Const.AllQuestChainType and Result[Data.QuestType] then
            table.insert(RetTable, Result[Data.QuestType])
        end
    end
   
    return RetTable
end

function WBP_Task_Main:CheckQuestIsShowByCheckState(QuestChainId, QuestChainData)
    local QuestChainType = 0
    if DataMgr.QuestChain[QuestChainId] and DataMgr.QuestChain[QuestChainId].QuestChainType then
        QuestChainType = DataMgr.QuestChain[QuestChainId].QuestChainType
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end

    if QuestChainData.State == 3 then --已完成
        return false
    end

    local CurrentTime = TimeUtils.NowTime()
    local StartTime = DataMgr.QuestChain[QuestChainId].StartTime --开始时间
    local EndTime = DataMgr.QuestChain[QuestChainId].EndTime --结束时间
    local ShowTime = DataMgr.QuestChain[QuestChainId].ShowTime --显示时间
    local QuestStartTime = nil
    local QuestEndTime = nil
    if ShowTime then
        QuestStartTime = ShowTime:GetTime()
    elseif StartTime then
        QuestStartTime = StartTime:GetTime()
    end
    if EndTime then
        QuestEndTime = EndTime:GetTime()
    end
    if QuestStartTime and QuestEndTime and (QuestStartTime > CurrentTime or CurrentTime > QuestEndTime) and
    (QuestChainType == Const.LimTimeQuestChainType or QuestChainType == Const.MainActivityQuestChainType) then
        return false
    end
    if QuestStartTime and (QuestStartTime > CurrentTime) and 
    (QuestChainType == Const.LimTimeQuestChainType or QuestChainType == Const.MainActivityQuestChainType) then
        return false
    end
    if not QuestStartTime and QuestEndTime and (CurrentTime > QuestEndTime) and
    (QuestChainType == Const.LimTimeQuestChainType or QuestChainType == Const.MainActivityQuestChainType) then
        return false
    end
    if QuestChainData.CanShow == false and (QuestChainType == Const.LimTimeQuestChainType or QuestChainType == Const.MainActivityQuestChainType) then
        return false
    end

    if QuestChainData.State == 0 then --未解锁
        if (QuestChainType == Const.LimTimeQuestChainType or QuestChainType == Const.MainActivityQuestChainType) and QuestChainData.CanShow == false then
            return false
        elseif (QuestChainType == Const.LimTimeQuestChainType or QuestChainType == Const.MainActivityQuestChainType) and QuestChainData.CanShow == true then
            return true
        end

        return true
    end
    
    local STLExportInfo = DataMgr.STLExportQuestChain[QuestChainId]
    if STLExportInfo == nil or STLExportInfo.Quests == nil or STLExportInfo.Quests[QuestChainData.DoingQuestId] == nil then
        return false
    end

    if STLExportInfo.Quests[QuestChainData.DoingQuestId].IsPreQuest then
        return false
    else
        return true
    end

    -- local IsAutoStart = DataMgr.QuestChain[QuestChainId].IfAutoStart
    -- local IsDoing = Avatar.QuestChains[QuestChainId]:IsDoing()
    -- if IsAutoStart then
    --     return true
    -- end
    -- if not IsAutoStart and not IsDoing then
    --     return false
    -- end
    -- return true
end

function WBP_Task_Main:InitDetailInfo()
    self.RootWidget.VB_TaskDetails:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.RootWidget.Group_TaskTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.RootWidget.HB_Reward:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.RootWidget.Common_Button_Text_PC:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

-- 展示任务具体信息，包括奖励、解锁条件等，作为回调注册到具体的SubItem里
--- @param QuestWidget WBP_TaskSubItem_C
function WBP_Task_Main:ShowQuestDetailInfo(QuestWidget)
    if not QuestWidget then
        return
    end
    if QuestWidget.OwnerWidget.QuestChainId == -1 then
        self.CurSelectQuest = QuestWidget
        -- local QuestId = QuestWidget.QuestID  -- 任务Id 如10010101
        -- local QuestChainId = QuestWidget.OwnerWidget.QuestChainId  -- 任务链id 如 100101
        self.RootWidget.VB_TaskDetails:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.RootWidget.Group_TaskTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.RootWidget.Common_Button_Text_PC:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.RootWidget.Text_TaskTitle:SetText(GText("Quest_ToBeContinued"))
        self.RootWidget.Text_TaskTitle:SetRenderOpacity(0)
        self:AddTimer(0.01, function()
            local TextBlockWidth = UIManager(self):GetWidgetRenderSize(self.RootWidget.Text_TaskTitle)
            --self.RootWidget.Text_TaskTitle:SetTextByPixelWidth(GText("Quest_ToBeContinued"), TextBlockWidth.X)
            self.RootWidget.Text_TaskTitle:SetRenderOpacity(1)
        end, false, 0, "DelayToShowText")
        self.RootWidget.HB_Position:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.RootWidget.Group_Title_UnlockTask:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.RootWidget.VB_UnlockCondition:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.RootWidget.Text_TaskDetail:SetText(GText("AllQuest_Over_Description"))
        self.RootWidget.Text_TaskObject:SetText(GText("UI_QUEST_CONTENT"))
        self.RootWidget.Text_TaskRewards:SetText(GText("UI_QUEST_REWARDS"))
        self.RootWidget.ListView_Rewards:ClearListItems()
        self.RootWidget.ListView_Rewards:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.RootWidget.VB_TaskReward:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.RootWidget.WS_Bottom:SetActiveWidgetIndex(1)
        self:SetTrackButtonText(false)
        self.RootWidget.Group_TimeRemaining:SetVisibility(UE4.ESlateVisibility.Collapsed)
        -- 隐藏放弃按钮
        
        return
    end
    self.RootWidget.VB_TaskReward:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.RootWidget.WS_Bottom:SetActiveWidgetIndex(0)
    self.RootWidget.HB_Position:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- if self.CurSelectQuest then
    --     self.CurSelectQuest:OnQuestUnSelect()
    -- end
    self.CurSelectQuest = QuestWidget
    local QuestId = QuestWidget.QuestID  -- 任务Id 如10010101
    local QuestChainId = QuestWidget.OwnerWidget.QuestChainId  -- 任务链id 如 100101
    local RewardList = DataMgr.QuestChain[QuestChainId].QuestChainReward
    local UnlockConditionId = DataMgr.QuestChain[QuestChainId].UnlockCondition
    local UnlockTitle = DataMgr.QuestChain[QuestChainId].UnlockTitle
    local UnlockContent = DataMgr.QuestChain[QuestChainId].UnlockContent
    local UnlockCondition = nil
    if UnlockConditionId then
        UnlockCondition = DataMgr.Condition[UnlockConditionId].ConditionMap
    end

    if QuestWidget.OwnerWidget.bAdvance then
        local DefaultConfigData = {
            OwnerWidget = self,
            MenuPlacement = EMenuPlacement.MenuPlacement_AboveAnchor,
            TextContent = GText("UI_FAKEQUEST_TIPS"),
        }
        self.RootWidget.Btn_Qa:Init(DefaultConfigData)
        self.RootWidget.Group_IsDoneSign:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.RootWidget.Text_IsDone:SetText(GText("UI_FAKEQUEST_TEXT"))
        self.RootWidget.Btn_QaClick.OnClicked:Add(self, self.OpenTips)
    else
        self.RootWidget.Group_IsDoneSign:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    self.RootWidget.VB_TaskDetails:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.RootWidget.Group_TaskTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.RootWidget.Common_Button_Text_PC:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local Info = TaskUtils:GetQuestDetail(QuestChainId, QuestId)
    if not Info then
        return
    end

    if QuestWidget.State == QuestRealStateEnum.Lock and UnlockTitle and UnlockContent then
        self.RootWidget.Text_TaskTitle:SetText(GText(UnlockTitle))
        self.RootWidget.Text_TaskDetail:SetText(GText(UnlockContent))

    else
        self.RootWidget.Text_TaskTitle:SetText(QuestWidget.QuestName)
        self.RootWidget.Text_TaskTitle:SetRenderOpacity(0)

        self:AddTimer(0.01, function()
            local TextBlockWidth = UIManager(self):GetWidgetRenderSize(self.RootWidget.Text_TaskTitle)
            --self.RootWidget.Text_TaskTitle:SetTextByPixelWidth(QuestWidget.QuestName, TextBlockWidth.X)
            self.RootWidget.Text_TaskTitle:SetRenderOpacity(1)
        end, false, 0, "DelayToShowText")

        self.RootWidget.Text_TaskDetail:SetText(QuestWidget.QuestDeatil)
    end
    self.RootWidget.Text_TaskObject:SetText(GText("UI_QUEST_CONTENT"))

    if QuestWidget.State == QuestRealStateEnum.Doing then -- 是否为限时任务
        -- self.Text_Time:SetText(111111)
        self.RootWidget.Group_TimeRemaining:SetVisibility(UE4.ESlateVisibility.Collapsed) --@lhq 2024.1.15:限时任务先不管，有需求时再迭代
    else
        self.RootWidget.Group_TimeRemaining:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    if QuestWidget.QuestPosition ~= "" then
        self.RootWidget.HB_Position:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.RootWidget.Text_Position:SetText(QuestWidget.QuestPosition)
    else
        self.RootWidget.HB_Position:SetVisibility(UE4.ESlateVisibility.Collapsed)
        --self.RootWidget.Group_TaskPosition:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    -- 任务奖励
    if not RewardList then
        self.RootWidget.Group_Title_Rewards:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.RootWidget.ListView_Rewards:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.RootWidget.HB_Reward:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.RootWidget.Group_Title_Rewards:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.RootWidget.Text_TaskRewards:SetText(GText("UI_QUEST_REWARDS"))
        self.RootWidget.ListView_Rewards:ClearListItems()
        self.RootWidget.ListView_Rewards:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:SortReward(RewardList, QuestWidget.OwnerWidget.bAdvance)
    end

    -- 任务解锁条件
    local IsUnLocking = Avatar and Avatar:CheckCondition(UnlockConditionId)
    if not UnlockConditionId then
        IsUnLocking = false
    end
    if self:CheckShowTime(QuestChainId) then
        IsUnLocking = false
    end
    self.RootWidget.VB_UnlockCondition:ClearChildren()
    if QuestWidget.State == QuestRealStateEnum.Doing and UnlockCondition and not IsUnLocking then
        self.RootWidget.Group_Title_UnlockTask:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.RootWidget.VB_UnlockCondition:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.RootWidget.Text_UnlockTask:SetText(GText("UI_QUEST_CONDITIONREQUEST"))
        for Type, Param in pairs(UnlockCondition) do
            for i = 1, #Param do
                local p = Param[i]
                local IsUnLock = ConditionUtils["Judge" .. Type](Avatar, p)
                local ConditionWidget = self:CreateWidgetNew("TaskUnlockCondition")
                self.RootWidget.VB_UnlockCondition:AddChildToVerticalBox(ConditionWidget)
                ConditionWidget.bIsFocusable = true
                ConditionWidget:Init(IsUnLock, self)
                ConditionWidget:SetConditionText(Type, IsUnLock, p)
                if Type == "TrueQuestChain" or Type == "QuestChain" then
                    local NewType = "QuestChain"
                    if self["ConditionJump" .. NewType] and not IsUnLock then
                        ConditionWidget.CanClick = true
                        ConditionWidget:BindEventOnClicked(self, self["ConditionJump" .. NewType], p)
                    end
                end
                ConditionWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            end
        end
        local CurrentTime = TimeUtils.NowTime()
        local StartTime = DataMgr.QuestChain[QuestChainId].StartTime --开始时间
        local ShowTime = DataMgr.QuestChain[QuestChainId].ShowTime --显示时间
        if not ShowTime and StartTime then
            ShowTime = StartTime
        end
        if ShowTime and StartTime then
            if ShowTime:GetTime() <= StartTime:GetTime() and CurrentTime < StartTime:GetTime() then
                local ConditionWidget = self:CreateWidgetNew("TaskUnlockCondition")
                ConditionWidget:Init(false, self)
                ConditionWidget:SetConditionText("ShowTime", false, StartTime:GetTime())
                self.RootWidget.VB_UnlockCondition:AddChildToVerticalBox(ConditionWidget)
                ConditionWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            else
                local ConditionWidget = self:CreateWidgetNew("TaskUnlockCondition")
                ConditionWidget:Init(true, self)
                ConditionWidget:SetConditionText("ShowTime", true, StartTime:GetTime())
                self.RootWidget.VB_UnlockCondition:AddChildToVerticalBox(ConditionWidget)
                ConditionWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            end
        end
    elseif QuestWidget.State == QuestRealStateEnum.Lock and UnlockCondition and not IsUnLocking then
        self.RootWidget.Group_Title_UnlockTask:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.RootWidget.VB_UnlockCondition:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.RootWidget.Text_UnlockTask:SetText(GText("UI_QUEST_CONDITIONREQUEST"))
        for Type, Param in pairs(UnlockCondition) do
            for i = 1, #Param do
                local p = Param[i]
                local IsUnLock = ConditionUtils["Judge" .. Type](Avatar, p)
                local ConditionWidget = self:CreateWidgetNew("TaskUnlockCondition")
                ConditionWidget:Init(IsUnLock, self)
                ConditionWidget:SetConditionText(Type, IsUnLock, p)
                if Type == "TrueQuestChain" or Type == "QuestChain" then
                    local NewType = "QuestChain"
                    if self["ConditionJump" .. NewType] and not IsUnLock then
                        ConditionWidget.CanClick = true
                        ConditionWidget:BindEventOnClicked(self, self["ConditionJump" .. NewType], p)
                    end
                end             
                self.RootWidget.VB_UnlockCondition:AddChildToVerticalBox(ConditionWidget)
                ConditionWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            end
        end
        local CurrentTime = TimeUtils.NowTime()
        local StartTime = DataMgr.QuestChain[QuestChainId].StartTime --开始时间
        local ShowTime = DataMgr.QuestChain[QuestChainId].ShowTime --显示时间
        if not ShowTime and StartTime then
            ShowTime = StartTime
        end
        if ShowTime and StartTime then
            if ShowTime:GetTime() <= StartTime:GetTime() and CurrentTime < StartTime:GetTime() then
                local ConditionWidget = self:CreateWidgetNew("TaskUnlockCondition")
                ConditionWidget:Init(false, self)
                ConditionWidget:SetConditionText("ShowTime", false, StartTime:GetTime())
                self.RootWidget.VB_UnlockCondition:AddChildToVerticalBox(ConditionWidget)
                ConditionWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            else
                local ConditionWidget = self:CreateWidgetNew("TaskUnlockCondition")
                ConditionWidget:Init(true, self)
                ConditionWidget:SetConditionText("ShowTime", true, StartTime:GetTime())
                self.RootWidget.VB_UnlockCondition:AddChildToVerticalBox(ConditionWidget)
                ConditionWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            end
        end
    else
        self.RootWidget.Group_Title_UnlockTask:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.RootWidget.VB_UnlockCondition:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if self.RootWidget.VB_UnlockCondition:GetAllChildren():Length() > 0 then
        local MaxCount = self.RootWidget.VB_UnlockCondition:GetAllChildren():Length()
        for key, value in pairs(self.RootWidget.VB_UnlockCondition:GetAllChildren()) do
            value:SetNavigationRuleCustom(EUINavigation.Left, {self, function()
                self.CurFocusWidget.Task_SubItem:SetFocus()
             end})
            if key == 1 then
                value:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
                value:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
                --value:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
                local NextItem = self.RootWidget.VB_UnlockCondition:GetChildAt(key)
                if NextItem then
                    value:SetNavigationRuleExplicit(EUINavigation.Down, NextItem)
                else
                    value:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
                end
            elseif key == MaxCount then
                value:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
                value:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
                --value:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
                local PreItem = self.RootWidget.VB_UnlockCondition:GetChildAt(key - 2)
                if PreItem then
                    value:SetNavigationRuleExplicit(EUINavigation.Up, PreItem)
                else
                    value:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
                end
            else
                --value:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
                local PreItem = self.RootWidget.VB_UnlockCondition:GetChildAt(key - 2)
                if PreItem then
                    value:SetNavigationRuleExplicit(EUINavigation.Up, PreItem)
                end
                local NextItem = self.RootWidget.VB_UnlockCondition:GetChildAt(key)
                if NextItem then
                    value:SetNavigationRuleExplicit(EUINavigation.Down, NextItem)
                else
                    value:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
                end
            end

        end
    end

    -- 设置追踪按钮状态
    if not IsUnLocking then
       
        self.RootWidget.Common_Button_Text_PC:ForbidBtn(true)
        if not self.IsForbiddenButton then
            self.RootWidget.Common_Button_Text_PC:PlayAnimation(self.RootWidget.Common_Button_Text_PC.Btn_Forbidden)
        end
        self.IsForbiddenButton = true
        self:SetTrackButtonText(false)
    else
        self.RootWidget.Common_Button_Text_PC:ForbidBtn(false)
        if self.IsForbiddenButton then
            self.RootWidget.Common_Button_Text_PC:PlayAnimation(self.RootWidget.Common_Button_Text_PC.Btn_Normal)
        end
        self.IsForbiddenButton = false
        self:SetTrackButtonText(self.TrackingQuestId == QuestChainId)
    end
    -- 这个函数当
    if self.TrackingQuestId == QuestChainId and not self.CurTrackingQuest then
        self.CurTrackingQuest = self.CurSelectQuest
    end
    
    -- 设置放弃按钮状态 如果能放弃，就显示按钮
    local bCanGiveUp = DataMgr.QuestChain[QuestChainId].bCanGiveUp
    self:SetGiveUpButton(bCanGiveUp)
    

    -- 线索集
    -- local IsOpenReasoning = DataMgr.QuestChain[QuestChainId].IsOpenReasoning
    -- if IsOpenReasoning then
    --     self.RootWidget.Group_Reasoning:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    --     if self.UsingGamepad then
    --         self.RootWidget.Key_Reasoning:SetVisibility(UE4.ESlateVisibility.Visible)
    --     else
    --         self.RootWidget.Key_Reasoning:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --     end
    --     self.RootWidget.Btn_Reasoning.OnClicked:Add(self,function()
    --         UIManager(self):LoadUINew("DetectiveMinigame")
    --     end)
    -- else
    --     self.RootWidget.Group_Reasoning:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- end

    --又上角时间
    if DataMgr.QuestChain[QuestChainId] and DataMgr.QuestChain[QuestChainId].QuestChainType == Const.LimTimeQuestChainType then
        self.RootWidget.Group_TimeRemaining:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.RootWidget.Com_Time:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:UpdateComTime(QuestChainId)
        -- if QuestWidget.ComTimeUpdateTimer == nil then
        --     QuestWidget.ComTimeUpdateTimer = self:AddTimer(1, function()
        --         self:UpdateComTime(QuestChainId)
        --     end, true)
        -- end
    else
        -- if QuestWidget.ComTimeUpdateTimer ~= nil then
        --     self:RemoveTimer(QuestWidget.ComTimeUpdateTimer)
        -- end
        self.RootWidget.Group_TimeRemaining:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_Task_Main:CheckShowTime(QuestChainId)
    local CurrentTime = TimeUtils.NowTime()
    local StartTime = DataMgr.QuestChain[QuestChainId].StartTime --开始时间
    local ShowTime = DataMgr.QuestChain[QuestChainId].ShowTime --显示时间
    if ShowTime == nil then
        ShowTime = StartTime
    end
    if ShowTime and StartTime and ShowTime:GetTime() <= StartTime:GetTime() and CurrentTime < StartTime:GetTime() then
        return true
    end
    return false
end

function WBP_Task_Main:OpenTips()
    self.RootWidget.Btn_Qa:PlayAnimation(self.RootWidget.Btn_Qa.Click)
    self.RootWidget.Btn_Qa.Btn_Click:SetChecked(true)
    self.RootWidget.Btn_Qa.TipsDetail:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.RootWidget.Btn_Qa.TipsDetail:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.RootWidget.Btn_Qa.TipsDetail:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    self.RootWidget.Btn_Qa.TipsDetail:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self.RootWidget.Btn_Qa.TipsDetail:SetNavigationRuleBase(EUINavigation.Next, EUINavigationRule.Stop)
    self.RootWidget.Btn_Qa.TipsDetail:SetNavigationRuleBase(EUINavigation.Previous, EUINavigationRule.Stop)
end


function WBP_Task_Main:UpdateComTime(InQuestChainId)
    if DataMgr.QuestChain[InQuestChainId] and DataMgr.QuestChain[InQuestChainId].StartTime and DataMgr.QuestChain[InQuestChainId].EndTime then
        local EndTime = DataMgr.QuestChain[InQuestChainId].EndTime - TimeUtils.NowTime()
        if EndTime > 0 then
            local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(DataMgr.QuestChain[InQuestChainId].EndTime, TimeUtils.NowTime())
            self.RootWidget.Com_Time:SetTimeText(GText(""), RemainTimeDict)
        end
    end
end

function WBP_Task_Main:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
       
    else
        if (InKeyName == CommonUtils:GetActionMappingKeyName("OpenTask")) then
            self.IsCanCloseByHotKey = true
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function WBP_Task_Main:OnKeyDown(MyGeometry, InKeyEvent)
    if CommonUtils:IfExistSystemGuideUI(self) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if KeyName == "Q" then
        self.CommonTabWidget:TabToLeft()
    elseif KeyName == "E" then
        self.CommonTabWidget:TabToRight()
    elseif KeyName == "Escape" then
        self:OnReturnKeyDown()
    elseif KeyName == CommonUtils:GetActionMappingKeyName("OpenTask") and self.IsCanCloseByHotKey then
        self:PlayOutAnim()
    elseif (KeyName == "Gamepad_LeftThumbstick") then
        if self.IsTaskEmpty == true then
            return
        end
        self.RootWidget.ListView_Rewards:NavigateToIndex(0)
        self:IsShowGamePad(false)
        self:InitTabPadKeyInfoForReward()
    elseif (KeyName == "Gamepad_RightThumbstick") then
        if self.RootWidget.Group_IsDoneSign:GetVisibility() == ESlateVisibility.Collapsed then
            return
        end
        self:OpenTips()
        self:IsShowGamePad(false)
        self:InitTabPadKeyInfoForTips()
    elseif (KeyName == "Gamepad_Special_Right") then
        if self.CommonTabWidget.ReasoningEntrance then
            self:OnClickReasoningEntrance()
        end
    elseif (KeyName == "Gamepad_FaceButton_Top") then
        if self.IsTaskEmpty == true then
            return
        end
        if self.RootWidget.ListView_Rewards:HasFocusedDescendants() then
            return
        elseif  self.RootWidget.VB_UnlockCondition:HasFocusedDescendants() then
            return
        elseif self.RootWidget.Btn_Qa:HasFocusedDescendants() then
            return
        end
        if self.RootWidget.Group_Jump:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
            self:OnClickJumpBtn()
        end
    elseif (KeyName == "Gamepad_FaceButton_Left") then
        if self.IsTaskEmpty == true then
            return
        end
        if self.RootWidget.ListView_Rewards:HasFocusedDescendants() then
            return
        elseif  self.RootWidget.VB_UnlockCondition:HasFocusedDescendants() then
            return
        elseif self.RootWidget.Btn_Qa:HasFocusedDescendants() then
            return
        end
        if self.RootWidget.Common_Button_Text_PC.IsForbidden then
            UIManager(self):ShowUITip("CommonToastMain", GText("UI_QUEST_TRACK_LOCK"), 1.5)
            return
        end
        self:OnTrackButtonClicked()
    elseif (KeyName == "Gamepad_FaceButton_Right") then
        if self.IsTaskEmpty == true then
            self:OnReturnKeyDown()
        elseif self.RootWidget.List_Task:HasFocusedDescendants() then
            self:OnReturnKeyDown()
        elseif self.RootWidget.ListView_Rewards:HasFocusedDescendants() or self.RootWidget.ListView_Rewards:HasAnyUserFocus() then
            self.CurFocusWidget.Task_SubItem:SetFocus()
        elseif self.RootWidget.VB_UnlockCondition:HasFocusedDescendants() then
            self.CurFocusWidget.Task_SubItem:SetFocus()
        elseif self.RootWidget.Btn_Qa:HasFocusedDescendants() then
            self.CurFocusWidget.Task_SubItem:SetFocus()
        elseif self.RootWidget:HasAnyUserFocus() then
            self:OnReturnKeyDown()
        end
    elseif (KeyName == "Gamepad_LeftShoulder") or (KeyName == "Gamepad_RightShoulder") then 
        if  self.RootWidget.ListView_Rewards:HasFocusedDescendants() or self.RootWidget.ListView_Rewards:HasAnyUserFocus() then
            return
        elseif self.RootWidget.VB_UnlockCondition:HasFocusedDescendants() then
            return
        elseif self.RootWidget.Btn_Qa:HasFocusedDescendants() then
            return
        end
        IsEventHandled = self.CommonTabWidget:Handle_KeyEventOnGamePad(KeyName)
    elseif KeyName == "Gamepad_Special_Left" then
        -- 手柄端放弃任务按钮，弹出放弃任务框
        if self.RootWidget.Key_Giveup:GetVisibility() == ESlateVisibility.Visible then
            self:OnClickGiveUpBtn()
        end
    end


    if IsEventHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function WBP_Task_Main:OnReturnKeyDown(bClose)
    if not self:IsAnimationPlaying(self.In) then
        self:PlayOutAnim(bClose)
    end
end

function WBP_Task_Main:PlayOutAnim(bClose)
    if self:IsAnimationPlaying(self.Out) then
        return
    end

    if self:IsAnimationPlaying(self.In) then
        return
    end

    self:UnbindAllFromAnimationFinished(self.Out)
    if bClose == nil or bClose == true then
        self:BindToAnimationFinished(self.Out, {self, self.Close})
    else
        self:BindToAnimationFinished(self.Out, {self, self.SetTrackingQuestInfoToServer})
    end

    self:PlayAnimation(self.Out)

end

function WBP_Task_Main:Close()
	-- local HomeBaseRegionId = Const.HomeBaseSubRegionId
	-- local CheckIsNeedShowLevelMap = function (AvatarRegionId, TaskSubRegionId)
	-- 	if TaskSubRegionId == 0 then
	-- 		return false
	-- 	end
	-- 	if AvatarRegionId == TaskSubRegionId and TaskSubRegionId == HomeBaseRegionId then
	-- 		return false
	-- 	end
	-- 	if AvatarRegionId ~= TaskSubRegionId and TaskSubRegionId == HomeBaseRegionId then
	-- 		return true
	-- 	end

	-- 	return true
	-- end

    EMCache:Set("QuestPantlTab", self.SaveTabId or self.CurTabId, true) -- 上一次关闭时选中的Tab (目前按规则直接显示第一个，暂时用不到)
    -- EMCache:Set("TrackingQuestRegionId", self.CurTrackingQuest and self.CurTrackingQuest.SubRegionId or 0, true) -- 用于旧版地图显示指引，目前弃用
    -- local NewQuestReddotSetCache = EMCache:Get("NewQuestReddotSet", true) or {}
    -- if not IsEmptyTable(NewQuestReddotSetCache) then
    --     for k, _ in pairs(NewQuestReddotSetCache) do
    --         NewQuestReddotSetCache[k] = false
    --     end
    -- end
    -- EMCache:Set("NewQuestReddotSet", NewQuestReddotSetCache, true)
    self.Super.Close(self)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if self.CurSelectQuest then
        TaskUtils.TaskMainLastSelectId = self.CurSelectQuest.QuestChainId
    else
        TaskUtils.TaskMainLastSelectId = nil
    end
    EventManager:FireEvent(EventID.OnReceiveNewQuest) -- 打开面板后再关闭时清除红点
    self.RootWidget.List_Task:ClearListItems()
    local ServerTrackId = Avatar.TrackingQuestChainId
    local ClientTrackId = self.TrackingQuestId
    if ServerTrackId ~= ClientTrackId then
        if Avatar.QuestChains[self.TrackingQuestId] then
            TaskUtils:ResumQuestTaskBarOnTrack(ServerTrackId, ClientTrackId, Avatar.QuestChains[self.TrackingQuestId].DoingQuestId)
        else
            TaskUtils:ResumQuestTaskBarOnTrack(ServerTrackId, nil, nil)
        end
    end
    if ServerTrackId and not ClientTrackId then
        Avatar:CancelQuestTracking(ServerTrackId)
    end
    if  self.CurTrackingQuest and self.CurTrackingQuest.SubRegionId <= 0 then
        self:SetTrackingQuestInfoToServer()
    end

    -- -- -- 根据任务追踪情况以及玩家自身的区域，判断是否需要弹出地图
    -- local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    -- local UIManager = GameInstance:GetGameUIManager()
    -- local TrackingQuestData = TaskUtils:GetTrackingQuestDetailInfo()
    -- local IsFairyLand = false
    -- if TrackingQuestData and TrackingQuestData.IsFairyLand then
    --     IsFairyLand = TrackingQuestData.IsFairyLand
    -- end

    -- local TargetSubRegionId = 0
    -- if self.CurTrackingQuest then
    --     TargetSubRegionId = MissionIndicatorManager:GetTargetTaskSubRegionId(self.CurTrackingQuest.QuestChainId, Avatar.QuestChains[self.CurTrackingQuest.QuestChainId].DoingQuestId)
    -- end

    -- if self.IsTrackingButtonClicked and self.CurTrackingQuest and IsSendRpc == false and IsFairyLand == false and
    --  CheckIsNeedShowLevelMap(Avatar.CurrentRegionId, TargetSubRegionId) then
    --     ShowLevelMap = true
    --     local _, RegionMapId = TaskUtils:GetQuestMapInfo(self.CurTrackingQuest.QuestChainId)
    --     if not RegionMapId then
    --         return
    --     end
    --     if not RegionMapId or not DataMgr.RegionMap[RegionMapId] or not DataMgr.RegionMap[RegionMapId].RegionId then
    --         return
	-- 	end
    --     local RegionId =  DataMgr.RegionMap[RegionMapId].RegionId 

    --     local HasTeleport = false
    --     for _, Data in pairs(DataMgr.TeleportPoint) do
    --         if Avatar.CurrentRegionId ~= TargetSubRegionId and TargetSubRegionId == HomeBaseRegionId then
	-- 			HasTeleport = true
    --             break
	-- 		elseif Data and Data.TeleportPointSubRegion and Data.TeleportPointSubRegion == TargetSubRegionId then
    --             HasTeleport =  true
    --         end
    --     end

    --     local IsInRegion = Avatar.CurrentRegionId and Avatar.CurrentRegionId == TargetSubRegionId
    --     if IsInRegion == false and HasTeleport == true then --取消追踪之后，未关闭任务面板又追踪
    --         local MainMap = UIManager:LoadUINew("LevelMapMain")
    --         if MainMap then
    --             -- MainMap.RealWildMap:ChangeRegion(RegionId)
    --             MainMap.RealWildMap:ChangeRegionForSmartIndicator(TargetSubRegionId)
    --             MainMap.RealWildMap:MoveMapToQuestTarget(Avatar.TrackingQuestChainId)
    --         end
    --     else
    --         EventManager:FireEvent(EventID.OnSetQuestTracking, self.CurSelectQuest.QuestChainId)
    --         EventManager:FireEvent(EventID.PlayLoopAnimAfterBarAnim)
    --     end
    -- elseif self.CurTrackingQuest and IsSendRpc == false and self.CurSelectQuest then
    --     EventManager:FireEvent(EventID.OnSetQuestTracking, self.CurSelectQuest.QuestChainId)
    -- end

end

function WBP_Task_Main:CheckNeedShowLevelMap()
    if TaskUtils:GetQuestInterfaceJump(self.CurSelectQuest.QuestID) then
        return
    end
    local bShowLevelMap = false
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local HomeBaseRegionId = Const.HomeBaseSubRegionId
	local CheckIsNeedShowLevelMap = function (AvatarRegionId, TaskSubRegionId)
		if TaskSubRegionId == 0 then
			return false
		end
		if AvatarRegionId == TaskSubRegionId and TaskSubRegionId == HomeBaseRegionId then
			return false
		end
		if AvatarRegionId ~= TaskSubRegionId and TaskSubRegionId == HomeBaseRegionId then
			return true
		end

		return true
	end

    -- 根据任务追踪情况以及玩家自身的区域，判断是否需要弹出地图
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    local TrackingQuestData = TaskUtils:GetTrackingQuestDetailInfo()
    local IsFairyLand = false
    if TrackingQuestData and TrackingQuestData.IsFairyLand then
        IsFairyLand = TrackingQuestData.IsFairyLand
    end

    local TargetSubRegionId = 0
    if self.CurTrackingQuest then
        TargetSubRegionId = MissionIndicatorManager:GetTargetTaskSubRegionId(self.CurTrackingQuest.QuestChainId, Avatar.QuestChains[self.CurTrackingQuest.QuestChainId].DoingQuestId)
    end
    local IsInRegion = not TaskUtils:CheckIsNeedLoadLevelMap(TargetSubRegionId, Avatar.CurrentRegionId)

    if self.IsTrackingButtonClicked and self.CurTrackingQuest and IsFairyLand == false and
     self:CheckIsInSameRegion(Avatar.CurrentRegionId, TargetSubRegionId) then
        local _, RegionMapId = TaskUtils:GetQuestMapInfo(self.CurTrackingQuest.QuestChainId)
        if not RegionMapId then
            return
        end
        if not RegionMapId or not DataMgr.RegionMap[RegionMapId] or not DataMgr.RegionMap[RegionMapId].RegionId then
            return
		end
        local RegionId =  DataMgr.RegionMap[RegionMapId].RegionId 
        -- local HasTeleport = false
        -- for _, Data in pairs(DataMgr.TeleportPoint) do
        --     if Avatar.CurrentRegionId ~= TargetSubRegionId and TargetSubRegionId == HomeBaseRegionId then
        --         HasTeleport = true
        --         break
        --     elseif Data and Data.TeleportPointSubRegion and Data.TeleportPointSubRegion == TargetSubRegionId then
        --         HasTeleport =  true
        --     end
        -- end
     
        if IsInRegion == false then --取消追踪之后，未关闭任务面板又追踪
            bShowLevelMap = true
            local MainMap = UIManager:LoadUINew("LevelMapMain", true)
            if MainMap then
                -- MainMap.RealWildMap:ChangeRegion(RegionId)
                MainMap.RealWildMap:ChangeRegionForSmartIndicator(TargetSubRegionId, self.CurTrackingQuest.QuestChainId)
                -- MainMap.RealWildMap:MoveMapToQuestTarget(self.CurTrackingQuest.QuestChainId)
            end
        else
            EventManager:FireEvent(EventID.OnSetQuestTracking, self.CurSelectQuest.QuestChainId)
            EventManager:FireEvent(EventID.PlayLoopAnimAfterBarAnim)
            --self:Close()
        end
    elseif self.CurTrackingQuest and self.CurSelectQuest then
        EventManager:FireEvent(EventID.OnSetQuestTracking, self.CurSelectQuest.QuestChainId)
    --     self:Close()
    -- elseif self.IsTrackingButtonClicked and self.CurTrackingQuest and CheckIsNeedShowLevelMap(Avatar.CurrentRegionId, TargetSubRegionId) and IsInRegion == false and IsFairyLand == false and self.HasTeleport == true then
    --     return
    -- elseif self.IsTrackingButtonClicked and self.CurTrackingQuest and TaskUtils.bShowLevelMap == false and IsSendRpc == false then
    --     self:Close()
    -- elseif self.IsTrackingButtonClicked and self.CurTrackingQuest and TaskUtils.bShowLevelMap == false and IsSendRpc == true then
    --     self:Close()
    end
    if bShowLevelMap == false then
        self:Close()
    end
end

function WBP_Task_Main:CheckIsInSameRegion(AvatarRegionId, TaskSubRegionId)
    local HomeBaseRegionId = Const.HomeBaseSubRegionId
    if TaskSubRegionId == 0 then
        return false
    end
    if AvatarRegionId == TaskSubRegionId and TaskSubRegionId == HomeBaseRegionId then
        return false
    end
    if AvatarRegionId ~= TaskSubRegionId and TaskSubRegionId == HomeBaseRegionId then
        return true
    end

    return true

end


function WBP_Task_Main:ShowDeliverPopupUI(InFairyLandRegionId, InQuestChainId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self:SetTrackingQuestInfoToServer()
	if Avatar.CurrentRegionId ~= InFairyLandRegionId then
		local UIManager = GWorld.GameInstance:GetGameUIManager()
		if not DataMgr.QuestChain[InQuestChainId] then
			return
		end
		local TaskName = DataMgr.QuestChain[InQuestChainId].QuestChainName
		local Params =
        {
        	ShortText = string.format("%s <H>%s</>", GText("UI_Prompt_QuestTrans"), GText(TaskName)),
			LeftCallbackObj = self,
			LeftCallbackFunction = self.CancelDeliverTo,
			RightCallbackObj = self,
			RightCallbackFunction = self.DoDeliverTo,
			CloseBtnCallbackObj = self,
			CloseBtnCallbackFunction = self.CancelDeliverTo
        }
        UIManager:ShowCommonPopupUI(100160, Params)
	end
end

function WBP_Task_Main:CancelDeliverTo()
	
end

function WBP_Task_Main:DoDeliverTo()
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if self.CurTrackingQuest and self.CurTrackingQuest.QuestChainId and self.CurTrackingQuest.QuestID then
        local TrackingQuestData = TaskUtils:GetQuestDetail(self.CurTrackingQuest.QuestChainId, self.CurTrackingQuest.QuestID)
        if IsValid(GameMode) and TrackingQuestData and TrackingQuestData.SubRegionId > 0 then
            GameMode:HandleLevelDeliver(UE4.EModeType.ModeRegion, TrackingQuestData.SubRegionId, TrackingQuestData.FairyLandDeliverIndex, true)
        end
    end
end

function WBP_Task_Main:CheckAvatarIsInQuestSubRegion()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
    local _, RegionMapId = TaskUtils:GetTrackingQuestMapInfo()
    if not RegionMapId then
        return false
    end
    if not RegionMapId or not DataMgr.RegionMap[RegionMapId] or not DataMgr.RegionMap[RegionMapId].RegionId then
        -- ErrorCode:Check(ErrorCode.RET_QUESTMAP_NOT_EXIST)
        return false
    end
    local RegionId =  DataMgr.RegionMap[RegionMapId].RegionId
    local IsInRegion = Avatar.CurrentRegionId and RegionId == DataMgr.SubRegion[Avatar.CurrentRegionId].RegionId
    return IsInRegion
end

function WBP_Task_Main:Destruct()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self,self.RefreshOpInfoByInputDevice) 
    end
    EventManager:RemoveEvent(EventID.CheckShowMap, self)
    AudioManager(self):SetEventSoundParam(self, "OpenTaskMain", {ToEnd = 1})
--    self.RootWidget.Btn_Reasoning.OnClicked:Clear()
    for _, Data in pairs(self.TempQuestTabData) do
        if Data then
            local RedDotName = Data.TabName
            ReddotManager.RemoveListener(RedDotName, self)
        end
    end
    ReddotManager.RemoveListener("DetectiveQuestion",self)
    ReddotManager.RemoveListener("DetectiveAnswer",self)
    -- 放弃按钮回调解绑
    self.RootWidget.Btn_Giveup:UnBindEventOnClicked(self, self.OnClickGiveUpBtn)
    WBP_Task_Main.Super.Destruct(self)
end
-- 之前预留的方法，目前没地方用上
function WBP_Task_Main:GetListItemById(QuestChainId)
    local AllListItems = self.RootWidget.List_Task:GetListItems() or {}
    local TargetItem = nil
    local Index = nil
    for Idx, Item in pairs(AllListItems) do
        if Item.QuestChainId == QuestChainId then
            TargetItem = Item
            Index = Idx
            break
        end
    end

    if TargetItem then
        return Index, TargetItem
    end
end
-- 初始化追踪按钮，以及获取服务端记录的追踪任务id
function WBP_Task_Main:InitTrackingButton()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.TrackingQuestId = Avatar.TrackingQuestChainId
    self:ReSwitchTaskBarTrackingQuest(self.TrackingQuestId)
    self.SaveTabId = self.TrackingQuestId and EMCache:Get("QuestPantlTab", true) or nil
    self:SetTrackButtonText(self.TrackingQuestId ~= nil)
    self.RootWidget.Common_Button_Text_PC:BindEventOnClicked(self, self.OnTrackButtonClicked)
    self.RootWidget.Common_Button_Text_PC:BindForbidStateExecuteEvent(self, function() 
            UIManager(self):ShowUITip("CommonToastMain", GText("UI_QUEST_TRACK_LOCK"), 1.5)
        return end)
    self.RootWidget.Common_Button_Text_PC:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function WBP_Task_Main:ReSwitchTaskBarTrackingQuest(InNewTrackingQuestChainId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if Avatar.QuestChains[InNewTrackingQuestChainId] then
        local DoingQuestId = Avatar.QuestChains[InNewTrackingQuestChainId].DoingQuestId
        local QuestExtraInfo = TaskUtils:GetQuestExtraInfo(InNewTrackingQuestChainId, DoingQuestId)
        if QuestExtraInfo  then
            if not IsEmptyTable(QuestExtraInfo) then
                for _, Data in pairs(QuestExtraInfo) do
                    if Data.Node then
                        Data.Node:OnCancelTrack()
                    end
                end
            end
        end
    end

    local TaskBar = TaskUtils:GetTaskBarWidget()
    if TaskBar and InNewTrackingQuestChainId > 0 then
        TaskBar:SwitchTaskBarContentByTracking(true, false)
    end
end

-- 追踪按钮回调
function WBP_Task_Main:OnTrackButtonClicked()
    if not TaskUtils:JudgeCanTrack() then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("Quest_Tips_QuestTrackLock"))
        return
    end
    self.CurSelectId = self.CurSelectQuest.QuestChainId
    if self.CurSelectId == -1 then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("AllQuest_OverTips"))
        return
    end
    if self.TrackingQuestId == nil or self.TrackingQuestId ~= self.CurSelectId then
        if self.CurTrackingQuest then
            self.CurTrackingQuest:CancelTracking()
        end
        self.TrackingQuestId = self.CurSelectId
        self.SaveTabId = self.CurTabId
        self.CurTrackingQuest = self.CurSelectQuest
        self.CurTrackingQuest:OnTracking(self.TrackingQuestId)
        self.IsTrackingButtonClicked = true
        local TrackingQuestData = TaskUtils:GetQuestDetail(self.CurTrackingQuest.QuestChainId, self.CurTrackingQuest.QuestID)
        if TrackingQuestData and TrackingQuestData.IsFairyLand and TrackingQuestData.SubRegionId > 0 then
            self:SetTrackButtonText(self.TrackingQuestId ~= nil)
            self:ShowDeliverPopupUI(TrackingQuestData.SubRegionId, self.CurSelectQuest.QuestChainId)
            return
        end
        if TaskUtils:GetQuestInterfaceJump(self.CurSelectQuest.QuestID) then
            self:SetTrackingQuestInfoToServer()
            PageJumpUtils:JumpToTargetPageByJumpId(TaskUtils:GetQuestInterfaceJumpId(self.CurSelectQuest.QuestID))
        else
            if self.CurTrackingQuest.SubRegionId > 0 then
                self:SetTrackingQuestInfoToServer()
            end
        end
    elseif self.TrackingQuestId == self.CurSelectId then
        self.CurSelectQuest:CancelTracking()
        self.TrackingQuestId = nil
        self.SaveTabId = nil
        self.CurTrackingQuest = nil    
    else
        self.CurTrackingQuest:CancelTracking()
        self.TrackingQuestId = nil
        self.SaveTabId = nil
        self.CurTrackingQuest = nil
    end
    self:SetTrackButtonText(self.TrackingQuestId ~= nil)
end

function WBP_Task_Main:OnClickJumpBtn()
    if not TaskUtils:JudgeCanTrack() then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("Quest_Tips_QuestTrackLock"))
        return
    end
    self.CurSelectId = self.CurSelectQuest.QuestChainId
    if self.TrackingQuestId ~= nil and self.TrackingQuestId == self.CurSelectId then
        self.TrackingQuestId = self.CurSelectId
        self.CurTrackingQuest = self.CurSelectQuest
        self.IsTrackingButtonClicked = true
        local TrackingQuestData = TaskUtils:GetQuestDetail(self.CurTrackingQuest.QuestChainId, self.CurTrackingQuest.QuestID)
        if TrackingQuestData and TrackingQuestData.IsFairyLand and TrackingQuestData.SubRegionId > 0 then
            self:SetTrackButtonText(self.TrackingQuestId ~= nil)
            self:ShowDeliverPopupUI(TrackingQuestData.SubRegionId, self.CurSelectQuest.QuestChainId)
            return
        end
        if TaskUtils:GetQuestInterfaceJump(self.CurSelectQuest.QuestID) then
            self:SetTrackingQuestInfoToServer()
            PageJumpUtils:JumpToTargetPageByJumpId(TaskUtils:GetQuestInterfaceJumpId(self.CurSelectQuest.QuestID))
        else
            if self.CurTrackingQuest.SubRegionId > 0 then
                self:SetTrackingQuestInfoToServer()
            end
        end
    end
end

function WBP_Task_Main:SetTrackButtonText(IsTracking)
    if IsTracking then
        self.RootWidget.Common_Button_Text_PC:SetText(GText("UI_QUEST_STOPTRACK"))
        self.RootWidget.Group_Jump:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        if self.UsingGamepad then
            self.RootWidget.Key_Map:SetVisibility(UE4.ESlateVisibility.Visible)
            self.RootWidget.Function_Jump:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            self.RootWidget.Key_Map:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.RootWidget.Function_Jump:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        self.RootWidget.Common_Button_Text_PC:SetText(GText("UI_QUEST_TRACK"))
        self.RootWidget.Group_Jump:SetVisibility(UE4.ESlateVisibility.Collapsed)
        if self.UsingGamepad then
            self.RootWidget.Key_Map:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.RootWidget.Function_Jump:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
end

function WBP_Task_Main:SetGiveUpButton(bCanGiveUp)
    if bCanGiveUp then
        self.RootWidget.Group_Giveup:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        if self.UsingGamepad then
            self.RootWidget.Key_Giveup:SetVisibility(UE4.ESlateVisibility.Visible)
            self.RootWidget.Function_Giveup:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            self.RootWidget.Key_Giveup:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.RootWidget.Function_Giveup:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        self.RootWidget.Group_Giveup:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.RootWidget.Key_Giveup:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.RootWidget.Function_Giveup:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_Task_Main:ScrollToSelectedWidget(CurSelectId)
    local TaskItemUIs = self.RootWidget.List_Task:GetDisplayedEntryWidgets()
    if TaskItemUIs == nil or TaskItemUIs:Num() == 0 then
        return
    end
    local TaskMaxCount = UIUtils.GetListViewContentMaxCount(self.RootWidget.List_Task,TaskItemUIs)
    local AllChainList = self.RootWidget.List_Task.ListItems:ToTable()
    if #AllChainList >= TaskMaxCount then
        self.RootWidget.List_Task:SetScrollbarVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.RootWidget.List_Task:SetScrollbarVisibility(UE4.ESlateVisibility.Collapsed)
    end
    for _, ListItem in pairs(AllChainList) do
        local Index = self.RootWidget.List_Task:GetIndexForItem(ListItem) + 1
        if ListItem.QuestChainId == CurSelectId and Index > TaskMaxCount then
            self.RootWidget.List_Task:NavigateToIndex(Index - 1)
            --self.RootWidget:SetFocus()
            return
        end
    end
end

function WBP_Task_Main:RenameWidget()
    self.PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)
    if self.PlatformName == "PC" then
        self.CommonTabWidget = self.Common_Tab
    elseif self.PlatformName == "Mobile" then
        self.CommonTabWidget = self.WBP_Com_Tab_M
    end
    self.RootWidget = self.WBP_Task_Root
end

----------- 不同任务点击跳转
function WBP_Task_Main:ConditionJumpQuestChain(QuestChainId)
    local Data = DataMgr.QuestChain[QuestChainId]
    if not QuestChainId or not Data then
        return
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local QuestChainType

    local AllQuestData = Avatar.QuestChains or {}
    if Avatar.QuestChains[QuestChainId] == nil then
        return
    end
    --local AllChainList = self.RootWidget.List_Task.ListItems:ToTable()
    local IsExisted = false
    local IsExistedInMap = false
        -- for _, ListItem in pairs(AllChainList) do
        --     if ListItem.QuestChainId == QuestChainId then
        --         IsExisted = true
        --         break
        --     end
        -- end
        -- if IsExisted == false then
        --     return
        -- end
    for DataQuestChainId, Data in pairs(AllQuestData) do
        if DataQuestChainId == QuestChainId then
            QuestChainType = DataMgr.QuestChain[DataQuestChainId].QuestChainType
            local IsShowByCheck = self:CheckQuestIsShowByCheckState(DataQuestChainId, Data)
            if Data.State ~= 3 and Data.CanShow and IsShowByCheck then 
                IsExisted = true
                break
            end
        end
    end

    if not IsExisted then
        for QuestChainId, QuestChainData in pairs(DataMgr.QuestChain) do
            if QuestChainData == nil or QuestChainData.SpecialQuestDisplayName == nil or
            QuestChainData.QuestNpcId == nil or QuestChainData.QuestChainType ~= Const.SpecialSideQuestChainType then
                goto continue
            end
    
            if Avatar.QuestChains[QuestChainId] and Avatar.QuestChains[QuestChainId].State == 1 and GuidePointLocData[QuestChainData.SpecialQuestDisplayName] 
            and GuidePointLocData[QuestChainData.SpecialQuestDisplayName].SubRegionId > 0 then
                IsExistedInMap = true
                break
            end
            ::continue::
        end
    end

    if not IsExisted and not IsExistedInMap then
        DebugPrint("ERROR::","任务:"..QuestChainId.."在任务面板和地图中都不存在")
    elseif IsExisted then
        local AfterDisplayQuestWidget = function()
            local AllDisplayWidget = self.RootWidget.List_Task:GetDisplayedEntryWidgets():ToTable() or {}
            for _, Widget in pairs(AllDisplayWidget) do
                if Widget.QuestChainId == QuestChainId then
                    Widget.Task_SubItem:SelectQuestProactively()
                    break
                end
            end
        end
        local TabId = 1
        for k, v in pairs(ConstQuestTabData) do
            if v.QuestType == QuestChainType then
                TabId = k
                break
            end
        end
        if TabId ~= self.CurTabId then
            self.JumpQuestChainId = QuestChainId
            self.CommonTabWidget:SelectTab(TabId)
        else
            AfterDisplayQuestWidget()
        end
    elseif not IsExisted and IsExistedInMap then
        local TargetSubRegionId = MissionIndicatorManager:GetTargetTaskSubRegionId(QuestChainId, Avatar.QuestChains[QuestChainId].DoingQuestId)
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local UIManager = GameInstance:GetGameUIManager()
        local MainMap = UIManager:LoadUINew("LevelMapMain")
        if MainMap then
            MainMap.RealWildMap:ChangeRegionForSmartIndicator(TargetSubRegionId, QuestChainId)
            --MainMap.RealWildMap:MoveMapToQuestTarget(QuestChainId)
        end
    end

end
-- 判断某任务是否属于当前Tab
function WBP_Task_Main:IsInTab(QuestChainId, TabId)
    local Data = DataMgr.QuestChain[QuestChainId]
    if not Data then
        return false
    end
    local TabQuestType = 1
    for k, v in pairs(ConstQuestTabData) do
        if k == TabId then
            TabQuestType = v.QuestType
            break
        end
    end
    return Data.QuestChainType == TabQuestType or TabId == 1
end

function WBP_Task_Main:GetCurTabFirstQuestId(QuestData, TabId)
    local CurTabQuestType = -1 -- -1为全部类型
    if ConstQuestTabData[TabId] and ConstQuestTabData[TabId].QuestType then
        CurTabQuestType = ConstQuestTabData[TabId].QuestType
    end
    if CurTabQuestType ~= -1 then
        if QuestData[CurTabQuestType] then
            for _, Data in ipairs(QuestData[CurTabQuestType]) do
                return Data.QuestChainId or 0
            end
        end
    else
        for Type, Datas in pairs(QuestData) do
            if Datas and #Datas > 0 then
                for _, Data in ipairs(Datas) do
                    return Data.QuestChainId or 0
                end
            end
        end
    end

    return 0
end

function WBP_Task_Main:GetQuestInfoString(StringInfo)
    --return DataMgr.TextMap[StringInfo].TextMapContent
    return GText(StringInfo)
end
-- 同步追踪状态到服务端，只会在面板关闭的时候调用
function WBP_Task_Main:SetTrackingQuestInfoToServer()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return 
    end
    local ServerTrackId = Avatar.TrackingQuestChainId
    local ClientTrackId = self.TrackingQuestId
    if ServerTrackId ~= ClientTrackId then
        if Avatar.QuestChains[self.TrackingQuestId] then
            TaskUtils:ResumQuestTaskBarOnTrack(ServerTrackId, ClientTrackId, Avatar.QuestChains[self.TrackingQuestId].DoingQuestId)
        else
            TaskUtils:ResumQuestTaskBarOnTrack(ServerTrackId, nil, nil)
        end
    end
    if ServerTrackId and not ClientTrackId then
        Avatar:CancelQuestTracking(ServerTrackId)
    elseif ServerTrackId ~= ClientTrackId then
        Avatar:SetQuestTracking(ClientTrackId, self.CurTrackingQuest.SubRegionId)
    else
        Avatar:SetQuestTracking(ClientTrackId, self.CurTrackingQuest.SubRegionId)
    end
end


function WBP_Task_Main:SortReward(RewardList, bAdvance)
    local Res = {}
    local Rewards = {}
    for _, RewardId in pairs(RewardList) do
        local RewardInfo = DataMgr.Reward[RewardId]       
        if RewardInfo then
            local Ids = RewardInfo.Id or {}
            local RewardCount = RewardInfo.Count or {}
            local TableName = RewardInfo.Type or {}
            for i = 1, #Ids do
                table.insert(Rewards, Ids[i])
                Res[Ids[i]] = {
                    ItemId = Ids[i],
                    Count = RewardUtils:GetCount(RewardCount[i]),
                    Icon = ItemUtils.GetItemIconPath(Ids[i], TableName[i]),
                    Rarity = ItemUtils.GetItemRarity(Ids[i], TableName[i]),
                    ItemType = TableName[i]
                }
            end
        end
    end
    table.sort(Rewards, function(A, B)
        local TypeA = Res[A].ItemType
        local TypeB = Res[B].ItemType
        
        -- 如果A是"re"类型而B不是，A应该排在后面
        if TypeA == "Reward" and TypeB ~= "Reward" then
            return false
        end
        
        -- 如果B是"re"类型而A不是，B应该排在后面
        if TypeB == "Reward" and TypeA ~= "Reward" then
            return true
        end
        
        -- 获取物品属性
        local RarityA = Res[A].Rarity
        local RarityB = Res[B].Rarity
        local IdA = Res[A].ItemId
        local IdB = Res[B].ItemId
        
        -- 如果两者都是"re"类型，只按照rarity和id排序
        if TypeA == "Reward" and TypeB == "Reward" then
            if RarityA == RarityB then
                return IdA < IdB
            else
                return RarityA > RarityB
            end
        end
        
        -- 原有的排序逻辑（两者都不是"re"类型）
        local WeightA = DataMgr.RewardType[TypeA].DungeonRewardSeq
        local WeightB = DataMgr.RewardType[TypeB].DungeonRewardSeq
        
        if RarityA == RarityB then
            if WeightA == WeightB then
                return IdA < IdB
            else
                if WeightA == nil and WeightB then return WeightB
                elseif WeightB == nil and WeightA then return WeightA
                else return WeightA > WeightB end
            end
        else
            return RarityA > RarityB
        end
    end)

    for _, Id in pairs(Rewards) do
        local ItemId = Res[Id].ItemId
        local Count = Res[Id].Count
        local Icon = Res[Id].Icon
        local Rarity = Res[Id].Rarity
        local ItemType = Res[Id].ItemType
        local RewardContent = TaskUtils:CreateRewardContent(
            {Id = ItemId, Count = Count, OwnerWidget = self, Icon = Icon, Rarity = Rarity, IsShowDetails = true,ItemType = ItemType}
        )
        RewardContent.bHasGot = bAdvance
        RewardContent.AfterInitCallback = function(Widget)
            Widget:BindEvents(self,{OnMenuOpenChanged = self.OnRewardMenuOpenChanged})
        end
        self.RootWidget.ListView_Rewards:AddItem(RewardContent)
    end
    self.RootWidget.ListView_Rewards:RequestPlayEntriesAnim()
end

function WBP_Task_Main:OnRewardMenuOpenChanged(bIsOpen)
    if bIsOpen and self.UsingGamepad then
        self.CommonTabWidget:UpdateBottomKeyInfo({})
    elseif not bIsOpen and self.UsingGamepad then
        self:InitTabPadKeyInfoForReward()
    end
end

-------------------手柄相关---------------------------

function WBP_Task_Main:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice) 
    end
end

function WBP_Task_Main:RefreshBaseInfo()
    -- 刷新一些基础信息
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function WBP_Task_Main:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 切换手柄端相关图标显隐
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self.UsingGamepad = false
        self.RootWidget:SetFocus()
        self.RootWidget.Key_Map:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.RootWidget.Key_Title_Rewards:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self:IsShowGamePad(false)
        if self.CommonTabWidget.SizeBox_Left then
            self.CommonTabWidget.SizeBox_Left:SetVisibility(UE4.ESlateVisibility.Visible)
            self.CommonTabWidget.SizeBox_Right:SetVisibility(UE4.ESlateVisibility.Visible)
        end
    else
        self.UsingGamepad = true
        self:InitPadKeyInfo()
        self:SetFocusOnTrackWidget(self.CurSelectId)
        self:IsShowGamePad(true)
    end
end

function WBP_Task_Main:InitPadKeyInfo()
    self.RootWidget.Key_Giveup:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "View"
            }
        }
    })
    self.RootWidget.Key_Map:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Y"
            }
        }
    })
    self.RootWidget.Key_Title_Rewards:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "LS"
            }
        }
    })
    if self.CommonTabWidget.ReasoningEntrance then
        self.CommonTabWidget.ReasoningEntrance.Key_GamePad:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "Menu"
                }
            }
        })
        self.CommonTabWidget.ReasoningEntrance.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Visible)
    end
    self.RootWidget.Key_Qa:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "RS"
            }
        }
    })
    self.RootWidget.GroupKey:SetVisibility(UE4.ESlateVisibility.Visible)
    self.RootWidget.Key_Title_Rewards:SetVisibility(UE4.ESlateVisibility.Visible)
    self.RootWidget.Key_Map:SetVisibility(UE4.ESlateVisibility.Visible)
    self.RootWidget.Common_Button_Text_PC:SetGamePadImg("X")

end

function WBP_Task_Main:InitTabPadKeyInfo()
    if self.PlatformName == "Mobile" then
        return
    end
    self.CommonTabWidget:UpdateBottomKeyInfo({{ 
        GamePadInfoList =  {{
            Type="Img", 
            ImgShortPath="A", 
        }},
        Desc = GText("UI_CTL_Squad_Expand"), 
        bLongPress = false,
        },
        { 
            GamePadInfoList =  {{
                Type="Img", 
                ImgShortPath="B", 
            }},
            Desc = GText("UI_BACK"), 
        }
    })
end


function WBP_Task_Main:InitTabPadKeyInfoForReward()
    if self.PlatformName == "Mobile" then
        return
    end
    self.CommonTabWidget:UpdateBottomKeyInfo({{ 
        GamePadInfoList =  {{
            Type="Img", 
            ImgShortPath="A", 
        }},
        Desc = GText("UI_Controller_CheckDetails"), 
        bLongPress = false,
        },
        { 
            GamePadInfoList =  {{
                Type="Img", 
                ImgShortPath="B", 
            }},
            Desc = GText("UI_BACK"), 
        }
    })
end



function WBP_Task_Main:InitTabPadKeyInfoForBack()
    if self.PlatformName == "Mobile" then
        return
    end
    self.CommonTabWidget:UpdateBottomKeyInfo({
        { 
            GamePadInfoList =  {{
                Type="Img", 
                ImgShortPath="B", 
            }},
            Desc = GText("UI_BACK"), 
        }
    })
end

function WBP_Task_Main:InitTabPadKeyInfoForTips()
    if self.PlatformName == "Mobile" then
        return
    end
    self.CommonTabWidget:UpdateBottomKeyInfo({
        { 
            GamePadInfoList =  {{
                Type="Img", 
                ImgShortPath="B", 
            }},
            Desc = GText("UI_FAKEQUEST_TIPS_CLOSE"), 
        }
    })
end

function WBP_Task_Main:InitTabPadKeyInfoForCondition()
    if self.PlatformName == "Mobile" then
        return
    end
    self.CommonTabWidget:UpdateBottomKeyInfo({{ 
        GamePadInfoList =  {{
            Type="Img", 
            ImgShortPath="A", 
        }},
        Desc = GText("UI_LOGIN_ENSURE"), 
        bLongPress = false,
        },
        { 
            GamePadInfoList =  {{
                Type="Img", 
                ImgShortPath="B", 
            }},
            Desc = GText("UI_BACK"), 
        }
    })
end



function WBP_Task_Main:GetCurTrackWidget(TrackingQuestId)
    if TrackingQuestId == nil then
        return
    end

    for _, ListItem in pairs(self.RootWidget.List_Task:GetListItems():ToTable()) do
        local Index = self.RootWidget.List_Task:GetIndexForItem(ListItem) + 1
        if ListItem.QuestChainId == TrackingQuestId then
            return ListItem
        end
    end
    return nil
end

function WBP_Task_Main:SetFocusOnTrackWidget(TrackingQuestId)
    local CurTrackWidget = self:GetCurTrackWidget(TrackingQuestId)
    if CurTrackWidget == nil then
        local CurSelect = self:GetCurTrackWidget(self.CurSelectQuest)
        if CurSelect then
            local Index = self.RootWidget.List_Task:GetIndexForItem(CurSelect)
            self.RootWidget.List_Task:NavigateToIndex(Index)
        else
            self.RootWidget.List_Task:NavigateToIndex(0)
        end
        
    else
        local Index = self.RootWidget.List_Task:GetIndexForItem(CurTrackWidget)
        self.RootWidget.List_Task:NavigateToIndex(Index)
    end
end



function WBP_Task_Main:OnLeftStickUp()


end

function WBP_Task_Main:OnNavigationRight()
    if self.RootWidget.VB_UnlockCondition:GetChildrenCount() <= 0 then
        return
    else
        --local Item = self.RootWidget.VB_UnlockCondition:GetChildAt(0)
        for key, value in pairs(self.RootWidget.VB_UnlockCondition:GetAllChildren()) do
            if not value.Finish  then
                return value
            end
        end
    end
end

function WBP_Task_Main:IsShowGamePad(IsShow)
    if self.PlatformName == "Mobile" then
        return
    end
    if IsShow then
        self.CommonTabWidget.SizeBox_Left:SetVisibility(UE4.ESlateVisibility.Visible)
        self.CommonTabWidget.SizeBox_Right:SetVisibility(UE4.ESlateVisibility.Visible)
        self.RootWidget.Key_Title_Rewards:SetVisibility(UE4.ESlateVisibility.Visible)
        --self.RootWidget.Group_Giveup:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        --self.RootWidget.Function_Giveup:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        --self.RootWidget.Key_Giveup:SetVisibility(UE4.ESlateVisibility.Visible)
        --self.RootWidget.Key_Map:SetVisibility(UE4.ESlateVisibility.Visible)
        self.RootWidget.Common_Button_Text_PC:SetGamePadVisibility(UE4.ESlateVisibility.Visible)
        self.RootWidget.GroupKey:SetVisibility(UE4.ESlateVisibility.Visible)
        if self.CommonTabWidget.ReasoningEntrance then
            self.CommonTabWidget.ReasoningEntrance.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Visible)
        end
    else
        self.CommonTabWidget.SizeBox_Left:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.CommonTabWidget.SizeBox_Right:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.RootWidget.Key_Title_Rewards:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.RootWidget.Common_Button_Text_PC:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
        --self.RootWidget.Group_Giveup:SetVisibility(ESlateVisibility.Collapsed)
        --self.RootWidget.Function_Giveup:SetVisibility(ESlateVisibility.Collapsed)
        --self.RootWidget.Key_Giveup:SetVisibility(UE4.ESlateVisibility.Collapsed)
        --self.RootWidget.Key_Map:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.RootWidget.GroupKey:SetVisibility(UE4.ESlateVisibility.Collapsed)
        if self.CommonTabWidget.ReasoningEntrance then
            self.CommonTabWidget.ReasoningEntrance.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
    self:SetTrackButtonText(self.TrackingQuestId == self.CurSelectId)
    local SelectedQuestChain = DataMgr.QuestChain[self.CurSelectId]
    if not SelectedQuestChain then
        return
    end
    local bCanGiveUp = SelectedQuestChain.bCanGiveUp
    self:SetGiveUpButton(bCanGiveUp)
end


function WBP_Task_Main:ReceiveEnterState(StackAction)
    WBP_Task_Main.Super.ReceiveEnterState(self, StackAction)
    if self.IsCanReceive == true then
        if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
            self:InitPadKeyInfo()
        end
        if self.CurFocusWidget and self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
            self.CurFocusWidget.Task_SubItem:SetFocus()
        end
    end
    if self.AutoClose and StackAction == 1 then
        self.AutoClose = false
        self:Close()
    end
end

function WBP_Task_Main:OnClickReasoningEntrance()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
    local UIManager = self:GetGameInstance():GetGameUIManager()
    UIManager:LoadUINew("DetectiveMinigame")
end

function WBP_Task_Main:UpdateReasoningRedDot()
    local IsNewClue = ReasoningUtils:IsAllClueHasNewClue()
    local IsNewQuestion = ReasoningUtils:IsAllQuestionHasNewQuestion()
    if self.CommonTabWidget and self.CommonTabWidget.ReasoningEntrance then
        -- 新线索
        if IsNewClue then
            self.CommonTabWidget.ReasoningEntrance.Bubble:ShowInfo()
            self.CommonTabWidget.ReasoningEntrance.Panel_Clue:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.CommonTabWidget.ReasoningEntrance.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
        -- 新问题
        elseif IsNewQuestion then
            self.CommonTabWidget.ReasoningEntrance.Panel_Clue:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.CommonTabWidget.ReasoningEntrance.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            self.CommonTabWidget.ReasoningEntrance.Panel_Clue:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.CommonTabWidget.ReasoningEntrance.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
end

function WBP_Task_Main:ShouldShowReasoningEntrance()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local UnlockedQuestions = Avatar.DetectiveGameUnlockedQuestions or {}
    local UnlockedResults = Avatar.DetectiveGameUnlockedResult or {}
    
    return false
end

---点击放弃任务按钮的回调函数
function WBP_Task_Main:OnClickGiveUpBtn() 
    local UIManager = UIManager(self)
    if not UIManager then
        return
    end
    -- 应该弹出一个弹窗
    local Params = {
        LeftCallbackObj = self,
        LeftCallbackFunction = self.HandleCancelGiveUpTask,
        RightCallbackObj = self,
        RightCallbackFunction = self.HandleConfirmGiveUpTask,
        CloseBtnCallbackObj = self,
        CloseBtnCallbackFunction = self.HandleCancelGiveUpTask
    }
    -- 放弃任务的弹窗编号100320
    UIManager:ShowCommonPopupUI(100320, Params)
    
end

---关闭放弃任务的弹窗
function WBP_Task_Main:HandleCancelGiveUpTask()
    
end

---处理放弃任务
function WBP_Task_Main:HandleConfirmGiveUpTask()
    local UIManagerInstance = nil
    UIManagerInstance = UIManager(self)
    if not UIManagerInstance then
        return
    end
    
    -- 查询不到CurSelectQuest的QuestChainId 任务不存在
    local QuestChainInfo = DataMgr.QuestChain[self.CurSelectQuest.QuestChainId]
    if not QuestChainInfo then
        UIManagerInstance:ShowError(6001)
        return
    end
    
    -- 该任务配置为不能放弃，却点击了放弃按钮 无法放弃
    if not QuestChainInfo.bCanGiveUp then
        UIManagerInstance:ShowError(27037)
        return 
    end
    
    -- 如果该任务是追踪的任务，变成不追踪
    if self.CurSelectQuest.QuestChainId == self.TrackingQuestId then
        self.CurSelectQuest:CancelTracking()
        self.TrackingQuestId = nil
        self.CurTrackingQuest = nil
    end
    
    -- 放弃任务后，停止stl
    if not GWorld then
        return
    end
    
    local StoryPath = QuestChainInfo.StoryPath
    if not StoryPath then
        return
    end
    if GWorld.StoryMgr:IsRunningStoryline(QuestChainInfo.StoryPath) then
        GWorld.StoryMgr:StopStoryline(StoryPath, false)
    end

    local OldQuestChainId = self.CurSelectQuest.QuestChainId
    -- 从任务面板中移除 
    local ListItemToRemove = nil    
    for _, ListItem in pairs(self.RootWidget.List_Task:GetListItems():ToTable()) do
        if ListItem.QuestChainId == OldQuestChainId then
            ListItemToRemove = ListItem
            break
        end
    end

    -- 测试 如果找到了，TODO: 本地删除，应该重新获取状态，刷新整个面板
    if ListItemToRemove then
        self.RootWidget.List_Task:RemoveItem(ListItemToRemove)
    end

    -- 如果存在追踪的，选择追踪的
    if self.TrackingQuestId and self:IsInTab(self.TrackingQuestId, self.CurTabId) then
        self.CurSelectId = self.TrackingQuestId
        -- 否则选择第一个
    elseif self.RootWidget.List_Task.ListItems:Num() >= 1 then
        for _, ListItem in pairs(self.RootWidget.List_Task:GetListItems():ToTable()) do
            self.CurSelectId = ListItem.QuestChainId
        end
    end
    
    for _, ListItem in pairs(self.RootWidget.List_Task:GetListItems():ToTable()) do
        if ListItem.QuestChainId == self.CurSelectId then
            self.CurSelectQuest = ListItem
        end
    end

    self:ScrollToSelectedWidget(self.CurSelectId)  -- 滑动到被选中的任务(追踪/第一个)
    
end

return WBP_Task_Main

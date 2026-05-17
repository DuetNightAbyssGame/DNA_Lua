--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
local TimeUtils = require "Utils.TimeUtils"
local EMCache = require "EMCache.EMCache"
---@type WBP_TaskListItem_C
local WBP_TaskListItem_C = Class("BluePrints.UI.BP_UIState_C")

local QuestStateEnum = {
    DOING = 1,
    COMPLETED = 2,
    LOCK = 3,
}

local QuestChainTypeEnum = {
    Main = 1,
    Normal = 2,
    Side = 3,
}

function WBP_TaskListItem_C:Initialize(Initializer)
    self.Super.Initialize(self)

    self.QuestChainType = nil   --任务类型（主线/支线/。。。）
    self.ChapterName = nil  -- 章节名
    self.ChapterDescription = nil -- 章节描述
    self.QuestChainId = nil  -- 任务链ID
    self.DoingQuestId = nil  -- 当前正在进行的任务ID
    self.OwnerWidget = nil   --
    self.CompletedQuestInfo = {} --已完成的任务的信息
    self.State = nil   -- 任务链状态
    self.ShowCompleteCount = 0
    self.bAdvance = false
end

function WBP_TaskListItem_C:Construct()
    self.Super.Construct(self)
    self.IsDestroied = false

end
function WBP_TaskListItem_C:Destruct()
    self.Super.Destruct(self)
    self.IsDestroied = true
end

function WBP_TaskListItem_C:RefreshListItemInfo(Content)
    -- 初始化状态

    if not Content then
        print(_G.LogTag,"WBP_TaskListItem_C.RefreshListItemInfo: Content Is Nil!")
        return
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.List_MainTask:ClearListItems()
    self.List_MainTask:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Task_SubItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Group_TaskType:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Group_Head:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Common_List_Cell_PC:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Common_List_Cell_PC.Button_Area.OnClicked:Add(self,self.OnClicked)
    -- self.Common_List_Cell_PC.Image_Unfold:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- self.Common_List_Cell_PC.VXImage_Unfold_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Common_List_Cell_PC:Init(self, self.UpdateTabInfo)
    self.Group_RecommendedLevel:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- self.Common_List_Cell_PC.Image_Unfold:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- self.Common_List_Cell_PC.VXImage_Unfold_1:SetVisibility(UE4.ESlateVisibility.Collapsed)

    self.OwnerWidget = Content.OwnerWidget  -- @type WBP_TaskMain_PC
    self.QuestChainId = Content.QuestChainId
    self.DoingQuestId = Content.DoingQuestId or 0
    self.IsEmpty = Content.IsEmpty
    self.IsShowType = Content.IsShowType
    self.IsTracking = self.OwnerWidget.TrackingQuestId == self.QuestChainId
    self.IsSelectDoingQuest = Content.IsSelectDoingQuest
    self.IsExpansion = true
    self.Content = Content
    Content.UI = self

    if self.OwnerWidget.PlatformName == "PC" then
        self.Group_Item.WidthOverride = self.Size_Group_Item_P
    elseif self.OwnerWidget.PlatformName == "Mobile" then
        self.Group_Item.WidthOverride = self.Size_Group_Item_M
    end

    local QuestConfig = DataMgr.QuestChain[self.QuestChainId]

    local QuestInfo = Avatar.QuestChains[self.QuestChainId]
    if QuestInfo and QuestInfo:GetAssumeFinish() then
        self.WS_Detail:SetActiveWidgetIndex(1)
        self.bAdvance = true
    else
        self.WS_Detail:SetActiveWidgetIndex(0)
        self.bAdvance = false
    end
    

    if not QuestConfig and not self.IsEmpty and self.QuestChainId ~= -1 then
        print(_G.LogTag,"Quest Conifg Not Exist! Check QuestChain.xlsx Id:",self.QuestChainId)
        return
    end
    if self.QuestChainId ~= -1 then
        self.Group_RecommendedLevel:SetVisibility(UE4.ESlateVisibility.Collapsed)
        if self.DoingQuestId ~= 0 then
            self:TriggerRecommendedLevelUIShow(TaskUtils:GetQuestDetail(self.QuestChainId, self.DoingQuestId))
        else
            local UnlockConditionId = DataMgr.QuestChain[self.QuestChainId].UnlockCondition
            local IsUnlock = Avatar:CheckCondition(UnlockConditionId)
            if not IsUnlock then
                local FirstQuestId = tostring(self.QuestChainId).."01"
                self:TriggerRecommendedLevelUIShow(TaskUtils:GetQuestDetail(self.QuestChainId, tonumber(FirstQuestId)))
            end
        end
    
        if self.DoingQuestId == 0 then
            print(_G.LogTag,"Doing Quest Id == 0 ",self.QuestChainId)
            self.DoingQuestId = DataMgr.STLExportQuestChain[self.QuestChainId].StartQuestId 
        end
        if self.IsEmpty then
            self.Switcher_Chapter:SetActiveWidgetIndex(1)
            self.Common_List_Cell_PC:SetRenderOpacity(0.5)
            self.Common_List_Cell_PC:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
            return
        else
            self.Switcher_Chapter:SetActiveWidgetIndex(0)
        end
    else
        self.Group_RecommendedLevel:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Switcher_Chapter:SetActiveWidgetIndex(0)
    end


    if self.IsShowType then
        self.Group_TaskType:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        local Type = nil
        if self.QuestChainId == -1 then
            Type = 1
        else
            Type = DataMgr.QuestChain[self.QuestChainId].QuestChainType
        end
        local QuestTabData = nil
        for _, v in pairs(DataMgr.QuestTab) do
            if v.QuestType == Type then
                QuestTabData = v
                break
            end
        end
        if QuestTabData ~= nil then
            self.Text_TaskType:SetText(GText(QuestTabData.TabName))
            self.Image_TaskTypeIcon:SetBrushResourceObject(LoadObject(QuestTabData.Icon))
            -- 子标题栏增加对应任务类型的颜色显示
            local QuestChainType = nil
            if self.QuestChainId == -1 then
                QuestChainType = 1
            else
                QuestChainType = DataMgr.QuestChain[self.QuestChainId].QuestChainType
            end
            if QuestChainType == Const.MainQuestChainType or QuestChainType == Const.MainActivityQuestChainType then
                self:PlayAnimation(self.Text_MainColor)
            elseif QuestChainType == 2 then
                self:PlayAnimation(self.Text_DailyColor)
            elseif QuestChainType == Const.SideQuestChainType then
                self:PlayAnimation(self.Text_SideColor)
            elseif QuestChainType == Const.LimTimeQuestChainType or QuestChainType == Const.SpecialSideQuestChainType then
                self:PlayAnimation(self.Text_SpecialColor)
            end
        end
    else
        self.Group_TaskType:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    -- 已完成任务列表
    -- local STLExportQuestChainData = nil 
    -- if DataMgr.STLExportQuestChain[self.QuestChainId] and DataMgr.STLExportQuestChain[self.QuestChainId].Quests then
    --     STLExportQuestChainData = DataMgr.STLExportQuestChain[self.QuestChainId].Quests
    -- end
    -- if not STLExportQuestChainData then
    --     self.CompletedQuetsId = Content.CompletedQuetsId:ToTable() or {}
    --     table.sort(self.CompletedQuetsId,function(a,b) return a > b end)
    -- else
    --     self.CompletedQuetsId = {}
    --     local QuestsTable = {}
    --     for k, v in pairs(STLExportQuestChainData) do
    --         local Data = {}
    --         Data.Key = k
    --         Data.Value = v
    --         table.insert(QuestsTable, Data)
    --     end
    --     local GetData = function (table, key)
    --         for _, v in pairs(table) do
    --             if v.Key == key then
    --                 return v
    --             end
    --         end
    --         return nil
    --     end
    --     table.sort(QuestsTable,function(a,b) return a.Key < b.Key end)
    --     local QuestIndexTable = {}
    --     local IterIndex = QuestsTable[1].Key
    --     for i = 1, #QuestsTable, 1 do
    --         local IterData = GetData(QuestsTable, IterIndex)
    --         if IterData then
    --             table.insert(QuestIndexTable, IterIndex)
    --             IterIndex = IterData.Value.nextQuestId
    --         else
    --             break
    --         end
    --     end
      
    --     local GetContainIndex = function (table, key)
    --         for _, v in pairs(table) do
    --             if v == key then
    --                 return v
    --             end
    --         end
    --         return nil
    --     end
        -- local CurCompletedIds = Content.CompletedQuetsId:ToTable() or {}
        -- local PreSortTable = {}
        -- if not IsEmptyTable(CurCompletedIds) then
        --     for k, v in pairs(QuestIndexTable) do
        --         local CurCompletedId = GetContainIndex(CurCompletedIds, v)
        --         if CurCompletedId then
        --             table.insert(PreSortTable, CurCompletedId)
        --         else
        --             break
        --         end
        --     end
        -- end
        -- for i = #PreSortTable, 1, -1 do
        --     table.insert(self.CompletedQuetsId, PreSortTable[i])
        -- end

    --end

    -- for _, QuestId in ipairs(self.CompletedQuetsId) do
    --     local TaskDetail = TaskUtils:GetQuestDetail(self.QuestChainId, QuestId)
    --     if TaskDetail then
    --         local Info = self:PreCreateSubItemContent(QuestStateEnum.COMPLETED, self.QuestChainId, QuestId)
    --         local IsShow = TaskDetail.bIsShowOnComplete
    --         self.CompletedQuestInfo[QuestId] = Info
    --         if IsShow then
    --             self.List_MainTask:AddItem(Info)
    --             self.ShowCompleteCount = self.ShowCompleteCount + 1
    --         end
    --     end
    -- end
    -- 进行中任务
    local DoingQuestInfo = nil
    if self.QuestChainId ~= -1 then
        local UnlockConditionId = QuestConfig.UnlockCondition
        local QuestState = (Avatar and Avatar:CheckCondition(UnlockConditionId)) and QuestStateEnum.DOING or QuestStateEnum.LOCK
        if not UnlockConditionId then 
            QuestState = QuestStateEnum.DOING
        end  -- 条件不存在时显示为不上锁
        local CurrentTime = TimeUtils.NowTime()
        local StartTime = DataMgr.QuestChain[self.QuestChainId].StartTime --开始时间
        local ShowTime = DataMgr.QuestChain[self.QuestChainId].ShowTime --显示时间
        if ShowTime == nil then
            ShowTime = StartTime
        end
        if ShowTime and StartTime and ShowTime:GetTime() <= StartTime:GetTime() and CurrentTime < StartTime:GetTime() then
            QuestState = QuestStateEnum.LOCK
        end
         DoingQuestInfo = self:PreCreateSubItemContent(QuestState,self.QuestChainId,self.DoingQuestId)
    else
        DoingQuestInfo = self:PreCreateSubItemContent(-1 ,self.QuestChainId,self.DoingQuestId)
    end

    self.Task_SubItem:RefreshTaskSubItemInfo(DoingQuestInfo)
    self.Task_SubItem:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    --self:PlayImageTaskTypeAnimation()
    -- if self.IsTracking then
    --     self.Task_SubItem:OnTracking()
    -- end
    -- if self.OwnerWidget.CurSelectId == self.QuestChainId and self.OwnerWidget.TrackingQuestId == nil then
    --     self.Task_SubItem:SelectQuestProactively()
    -- else
    --     self.Task_SubItem:OnQuestUnSelect()
    -- end
   
    -- if self.OwnerWidget.TrackingQuestId == self.QuestChainId and self.OwnerWidget.CurSelectQuest == nil then
    --     self.Task_SubItem:SelectQuestProactively()
    -- else
    --     if self.OwnerWidget.CurSelectQuest and self.OwnerWidget.CurSelectQuest.QuestChainId ~= self.QuestChainId then
    --         self.Task_SubItem:OnQuestUnSelect()
    --     end
    -- end
    if self.IsTracking then
        self.Task_SubItem:OnTracking()
    end
    --self:PlayImageTaskTypeAnimation()
    if self.OwnerWidget.CurSelectId == self.QuestChainId then
        self.Task_SubItem:SelectQuestProactively()
        --self:StopImageTaskTypeAnimationAndSelection()
    else
        self.Task_SubItem:OnQuestUnSelect()
        self:PlayImageTaskTypeAnimation()
    end
    if self.QuestChainId == -1 then
        self.Text_ChapterName:SetText(GText("AllQuest_Over"))
        self.Text_TaskArea:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Text_Chapter:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Text_TaskArea:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Text_Chapter:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        local TaskArea = DataMgr.TextMap[QuestConfig.ChapterName] and  GText(QuestConfig.ChapterName) or GText("UI_QUEST_UNKNOWN")
        local ChapterName = DataMgr.TextMap[QuestConfig.QuestChainName] and GText(QuestConfig.QuestChainName) or GText("UI_QUEST_UNKNOWN")
        local Chapter = DataMgr.TextMap[QuestConfig.EpisodeName] and GText(QuestConfig.EpisodeName)  or GText("UI_QUEST_UNKNOWN")
        self.Text_ChapterName:SetText(ChapterName)
        self.Text_Chapter:SetText(Chapter)
        self.Text_TaskArea:SetText(TaskArea)
        -- 设置图片
        local BossImagePath = DataMgr.QuestChain[self.QuestChainId].CharacterImagePath
        if BossImagePath then
            local Image = LoadObject(BossImagePath)
            if Image then
                local DynamicMaterial = self.Image_Head:GetDynamicMaterial()
                DynamicMaterial:SetTextureParameterValue("MainTex",Image)
                self.Group_Head:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            end
        end
    end

end

function WBP_TaskListItem_C:TriggerRecommendedLevelUIShow(TaskInfo)
    local Level = self.OwnerWidget.CurPlayerCharacterLevel

    local ConfigRecommandLevel = nil
    if TaskInfo and TaskInfo.RecommendLevel then
        ConfigRecommandLevel = TaskInfo.RecommendLevel
    end
    self.Text_RecommendedLevel_Desc:SetText(GText("UI_QUEST_SUGGEST_LEVEL"))
    if ConfigRecommandLevel == nil or ConfigRecommandLevel == -1 then
        self.Group_RecommendedLevel:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    else
        self.Text_RecommendedLevel:SetText(GText("UI_LEVEL_NAME")..ConfigRecommandLevel)
        self.Image_RedBG:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Group_RecommendedLevel:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end

    if ConfigRecommandLevel ~= nil and ConfigRecommandLevel > Level then
        self.Text_RecommendedLevel:SetText(GText("UI_LEVEL_NAME")..ConfigRecommandLevel)
        self.Image_RedBG:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

-- 控制已完成任务列表的显隐
function WBP_TaskListItem_C:ShowCompletedQuestList(IsExpansion)
    -- if IsExpansion then
    --     self.List_MainTask:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- else
    --     self.List_MainTask:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- end
    -- self.OwnerWidget.RootWidget.List_Task:RequestRefresh()
end
-- 返回用于初始化SubItem的Uobject
function WBP_TaskListItem_C:PreCreateSubItemContent(State,QuestChainId,QuestId)
    local Content = {}
    Content.QuestChainId = QuestChainId
    Content.QuestId = QuestId
    Content.OwnerWidget = self
    Content.MainWidget = self.OwnerWidget

    -- local NewQuestChainTable = EMCache:Get("NewQuestChainTable", true) or {}
    -- Content.IsNew = NewQuestChainTable[Content.QuestChainId] == nil -- 是否需要显示新任务图标
    -- if NewQuestChainTable[Content.QuestChainId] == nil then
    --     NewQuestChainTable[Content.QuestChainId] = true
    -- end

    -- 此处的State与SubItem中的State不太一样，此处的State包括进行中、已完成、未解锁，SubItem的State包括已完成、未解锁、进行中限时、进行中不限时
    if State == QuestStateEnum.DOING then
        -- Content.State = DataMgr.QuestChain[self.QuestChainId].OutOfDateTime and 1 or -1 -- 判断是否为限时任务 @lhq 2024.1.15:先暂时注掉，目前没有配置限时任务
        Content.State = State
        Content.IsDoingQuest = true
    elseif State == QuestStateEnum.COMPLETED then
        Content.State = 2
        Content.IsNew = false
    elseif State == QuestStateEnum.LOCK then
        Content.State = 0
    end
    -- EMCache:Set("NewQuestChainTable", NewQuestChainTable, true)

    -- local AllQuestChainReddotCache = EMCache:Get("AllQuestChainReddotSet", true) or {}
    -- local QuestChainData = DataMgr.QuestChain[Content.QuestChainId]
    -- if QuestChainData and QuestChainData.QuestChainType then
    --     AllQuestChainReddotCache[QuestChainData.QuestChainType] = AllQuestChainReddotCache[QuestChainData.QuestChainType] or {}
    --     if AllQuestChainReddotCache[QuestChainData.QuestChainType][Content.QuestChainId] == nil then
    --         AllQuestChainReddotCache[QuestChainData.QuestChainType][Content.QuestChainId] = false
    --     end
    --     EMCache:Set("AllQuestChainReddotSet", AllQuestChainReddotCache, true)
    --     self.OwnerWidget:UpdateTabWidgetReddot()
    -- end

    return TaskUtils:CreateSubItemContent(Content)
end

-- 点击进行折叠
function WBP_TaskListItem_C:OnClicked()
    if not self.IsExpansion then
        self.Task_SubItem:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        if self.Task_SubItem.IsExpansion then
            --self.List_MainTask:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
        self.IsExpansion = true
    else
        self.Task_SubItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
        --self.List_MainTask:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.IsExpansion = false
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
    self.OwnerWidget.RootWidget.List_Task:RequestRefresh()
    if self.OwnerWidget.UsingGamepad == true then

    else
        self.OwnerWidget.RootWidget:SetFocus()
    end
end

function WBP_TaskListItem_C:PlayImageTaskTypeAnimation()
    local QuestChainType = nil
    if self.QuestChainId == -1 then
        QuestChainType = 1
    else
        QuestChainType = DataMgr.QuestChain[self.QuestChainId].QuestChainType
    end
    --local QuestChainType = DataMgr.QuestChain[self.QuestChainId].QuestChainType
    if QuestChainType == Const.MainQuestChainType or QuestChainType == Const.MainActivityQuestChainType then
        self:PlayAnimation(self.Task_MainColor)
    elseif QuestChainType == 2 then
        self:PlayAnimation(self.Task_DailyColor)
    elseif QuestChainType == Const.SideQuestChainType then
        self:PlayAnimation(self.Task_SideColor)
    elseif QuestChainType == Const.LimTimeQuestChainType or QuestChainType == Const.SpecialSideQuestChainType then
        self:PlayAnimation(self.Task_SpecialColor)
    end
end


function WBP_TaskListItem_C:OnFocusReceived(MyGeometry, InFocusEvent)
    self:UpdateTabInfo()
    local LastIndex = -1
    if self.OwnerWidget.CurFocusWidget then
        LastIndex = self.OwnerWidget.RootWidget.List_Task:GetIndexForItem(self.OwnerWidget.CurFocusWidget.Content)
    end
    local CurIndex = self.OwnerWidget.RootWidget.List_Task:GetIndexForItem(self.Content)
    --切页
    self:SetItemNavigation()
    self.OwnerWidget.CurFocusWidget = self
    --self.Task_SubItem:OnQuestSelected()
    if LastIndex == -1 then  
            
        return  UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.Task_SubItem)
    else
        if LastIndex > CurIndex then  --下往上
            if self.IsExpansion then
                return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.Task_SubItem)
            else
                return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.Common_List_Cell_PC)
            end
        elseif LastIndex < CurIndex then --上往下
            return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.Common_List_Cell_PC)
        else
            return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.Task_SubItem)
        end
    end
end


function WBP_TaskListItem_C:SetItemNavigation()
    self.Common_List_Cell_PC:SetNavigationRuleCustom(EUINavigation.Up, {self, function()
        if self.Content.PreItem then
            self.OwnerWidget.RootWidget.List_Task:BP_CancelScrollIntoView()
            self.OwnerWidget.RootWidget.List_Task:BP_SetSelectedItem(self.Content.PreItem)
            self.OwnerWidget.RootWidget.List_Task:BP_NavigateToItem(self.Content.PreItem)
            return self.OwnerWidget.RootWidget.List_Task
        end
    end})

    self.Common_List_Cell_PC:SetNavigationRuleCustom(EUINavigation.Down, {self, function()
 
        if self.IsExpansion then
            return self.Task_SubItem
        else
            if self.Content.NextItem then
                self.OwnerWidget.RootWidget.List_Task:BP_CancelScrollIntoView()
                self.OwnerWidget.RootWidget.List_Task:BP_SetSelectedItem(self.Content.NextItem)
                self.OwnerWidget.RootWidget.List_Task:BP_NavigateToItem(self.Content.NextItem)
                return self.OwnerWidget.RootWidget.List_Task
            end
        end
    end})
    self.Task_SubItem:SetNavigationRuleExplicit(EUINavigation.Up, self.Common_List_Cell_PC)

    self.Task_SubItem:SetNavigationRuleCustom(EUINavigation.Down, {self, function()
        if self.Content.NextItem then
            self.OwnerWidget.RootWidget.List_Task:BP_CancelScrollIntoView()
            self.OwnerWidget.RootWidget.List_Task:BP_SetSelectedItem(self.Content.NextItem)
            self.OwnerWidget.RootWidget.List_Task:BP_NavigateToItem(self.Content.NextItem)
            return self.OwnerWidget.RootWidget.List_Task
        end
    end}) 

end

function WBP_TaskListItem_C:UpdateTabInfo()
    if self.OwnerWidget.UsingGamepad then
        self.OwnerWidget:InitTabPadKeyInfo()
    end

end

function WBP_TaskListItem_C:OnAddedToFocusPath(InFocusEvent)
    if self.OwnerWidget.UsingGamepad then
        self.OwnerWidget:IsShowGamePad(true)
    end
end

function WBP_TaskListItem_C:BP_OnEntryReleased()
    if self.Task_SubItem then
        self.Task_SubItem.SubRegionId = 0
        self.Task_SubItem.RegionId = 0
    end
end

---停止当前TaskListItem的ImageTaskTypeAnimation
function WBP_TaskListItem_C:StopImageTaskTypeAnimation()
    local QuestChainType = nil
    if self.QuestChainId == -1 then
        QuestChainType = 1
    else
        QuestChainType = DataMgr.QuestChain[self.QuestChainId].QuestChainType
    end
    if QuestChainType == Const.MainQuestChainType or QuestChainType == Const.MainActivityQuestChainType then
        self:StopAnimation(self.Task_MainColor)
    elseif QuestChainType == 2 then
        self:StopAnimation(self.Task_DailyColor)
    elseif QuestChainType == Const.SideQuestChainType then
        self:StopAnimation(self.Task_SideColor)
    elseif QuestChainType == Const.LimTimeQuestChainType or QuestChainType == Const.SpecialSideQuestChainType then
        self:StopAnimation(self.Task_SpecialColor)
    end
end

---获取QuestChainId对应的颜色
function WBP_TaskListItem_C:GetAnimationColorByQuestChainId(QuestChainId)
    if not QuestChainId then
        return nil
    end
    local QuestChainType = nil
    if QuestChainId == -1 then
        QuestChainType = 1
    else
        QuestChainType = DataMgr.QuestChain[QuestChainId].QuestChainType
    end
    
    local Color = nil
    if QuestChainType == Const.MainQuestChainType or QuestChainType == Const.MainActivityQuestChainType then
        Color = self.MainColor
    elseif QuestChainType == 2 then
        Color = self.DailyColor
    elseif QuestChainType == Const.SideQuestChainType then
        Color = self.SideColor
    elseif QuestChainType == Const.LimTimeQuestChainType or QuestChainType == Const.SpecialSideQuestChainType then
        Color = self.SpecialColor
    end
    return Color
end

---停止当前TaskListItem的ImageTaskTypeAnimation并显示当前TaskListItem被选中的效果
function WBP_TaskListItem_C:StopImageTaskTypeAnimationAndSelection()
    local QuestChainId = self.QuestChainId
    local Color = self:GetAnimationColorByQuestChainId(QuestChainId)
    local ColorSolid = FLinearColor(Color.R, Color.G, Color.B, 1)
    local ColorTransparent = FLinearColor(Color.R, Color.G, Color.B, 0)
    self:StopImageTaskTypeAnimation()
    self.VX_Wave3:SetColorAndOpacity(ColorSolid)
    self.VX_Wave4:SetColorAndOpacity(ColorTransparent)
end


---更新所有TaskListItem的状态，当前被选中项显示，其他隐藏，作为回调给WBP_TaskSubItem_C:OnQuestSelected使用
function WBP_TaskListItem_C:RefreshSelectionAnimation()
    local ListItemContents = self.OwnerWidget.RootWidget.List_Task:GetListItems()
    
    for _, ListItemContent in pairs(ListItemContents) do
        local UI = ListItemContent.UI
        if UI and UI ~= self then
            UI:PlayImageTaskTypeAnimation()
        end    
    end
    self:StopImageTaskTypeAnimationAndSelection()
end


return WBP_TaskListItem_C

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_JJGame_ChallengeTask_P_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.TimerMgr"})
local ChallengeRewardReddotName = "JJGameTask_Challenge_Reddot"
local ChallengeTaskNewReddotName = "JJGameTask_Challenge_New"

local TaskType = {
    Daily = {1,2},
    Cycle = 3,
    Achievement = 4,
}
---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.MidTermConst = DataMgr.MidTermGoalConstant
    self.AchievementRewardPoint = self.MidTermConst["AchievementRewardPoint"].ConstantValue
    self.MidTermGoalEventId = self.MidTermConst["MidTermGoalEventId"].ConstantValue
    self.AchievementPrize = DataMgr.AchievementPrize
    self.Text_Empty:SetText(GText("UI_Event_MidTerm_End"))
    self.Text_TaskScoreTodayTitle:SetText(GText("UI_Event_MidTerm_ChallengePoint"))
    self.Text_TaskScoreToday_Total:SetText(self.MidTermConst["MaxPrizePoint"].ConstantValue)
    self.Text_TaskScoreToday_Total:SetText(50)
    self.Btn_OneClickGet.Text_GetReward:SetText(GText("UI_CTL_ClaimALL"))
    self.Btn_OneClickGet.Btn_GetReward.OnClicked:Add(self,self.GetAllTaskScores)
    self.Btn_Score.OnClicked:Add(self, function()
        AudioManager(self):PlayUISound(self, "event:/ui/activity/wenmingboyi_challenge_btn_click", nil, nil)
        local Params = {
            Count = self.Count,
            Index = self.Index,
            ActivityId = self.MidTermGoalEventId,
            BackFocusWidget = self.List_Challenge,
            OnCloseCallbackFunction = function()
                self.List_Challenge:SetFocus()
            end
        }
        UIManager(self):ShowCommonPopupUI(100101, Params, self)
    end)
    self:InitListenEvent()
    self:RefreshBaseInfo()
    self.List_Challenge:SetScrollBarVisibility(UIConst.VisibilityOp.Hidden)
    self.List_Challenge:SetControlScrollbarInside(true)
    -- self.List_Challenge.BP_OnEntryInitialized:Add(self,self.OnElementEntryInitialized)
    self.CurFocusTask = nil
end

function M:Destruct()
    if self.HasNewTask then
        self:TryClearChallengeTaskNewReddot()
    end
    self.Btn_OneClickGet.Btn_GetReward.OnClicked:Clear()
end

function M:Init(Params)
    self.Params = Params
    self.Owner = Params.Owner
    self.EventDay = Params.EventDay
    self._Avatar = GWorld:GetAvatar()
    self.MidTermGoals = self._Avatar.MidTermGoals[self.MidTermGoalEventId] or {}
    self.MidTermTask = self.MidTermGoals.Tasks or {}
    self.MidTermAchvProgressRewarded = self.MidTermGoals.AchvProgressRewarded or {}
    self.EventEndTime = DataMgr.EventMain[self.MidTermGoalEventId].EventEndTime
    self:InitTaskList()
    self:InitChallengeScoreItem()
    self.ChallengeTaskScore = self:CalChallengeTaskScore()
    self:UpdateChallengeTaskScore(self.ChallengeTaskScore)
    self:PlayAnimation(self.In)
    -- 显示活动天数和剩余时间
    if Params.RemainDays ~= false then
        self.Text_BottomOneClickTitle:SetText(string.format(GText("UI_Event_MidTerm_NewChallenge"),Params.RemainDays,Params.RemainHours))
    else
        self.Text_BottomOneClickTitle:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if TimeUtils.NowTime() > self.EventEndTime then
         --清除任务红点
         self:ClearChallengeReddot()
        self.WS_Right:SetActiveWidgetIndex(1)
    end
    if CommonUtils.GetDeviceTypeByPlatformName()~="Mobile" then
        self.Key_TitleScore:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "X"
                }
            }
        })
    end
    self.Btn_OneClickGet.Key_GetReward:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Y"
            }
        }
    })
    self:SetFocus()
end

function M:CalChallengeTaskScore()
    -- local completedTaskCount = 0
    -- for _, taskItem in pairs(self.ChallengeTaskList) do
    --     if taskItem.TaskProp.RewardsGot then
    --         completedTaskCount = completedTaskCount + 1
    --     end
    -- end
    -- return completedTaskCount * self.AchievementRewardPoint
    local Avatar = GWorld:GetAvatar()
    self.MidTermGoals = Avatar.MidTermGoals[self.MidTermGoalEventId] or {}
    local MidTermAchvScores = self.MidTermGoals.AchvScores or 0
    return MidTermAchvScores
end

function M:UpdateChallengeTaskScore(TaskScoreToday)
    self.Text_TaskScoreToday:SetText(TaskScoreToday)
    self:UpdateChallengeScoreItem(TaskScoreToday)
end

function M:InitTaskList()
    self:UpdateChallengeTaskList()
    self:UpdateOneClickBtnState()
end

function M:UpdateChallengeTaskList()
    self.List_Challenge:ClearListItems()
    local Avatar = GWorld:GetAvatar()
    self.MidTermGoals = Avatar.MidTermGoals[self.MidTermGoalEventId] or {}
    local MidTermTasks = self.MidTermGoals.Tasks or {}
    local SortedTaskList = self:SortTaskList(MidTermTasks)
    self.ChallengeTaskList = {}
    for i,Task in pairs(SortedTaskList) do
        local TaskData = DataMgr.MidTermTask[Task.UniqueID]
        if not TaskData then
            print("TaskData is nil, Task.UniqueID = ", Task.UniqueID)
            Utils.ScreenPrint("MidTermTask表中不存在UniqueID为"..Task.UniqueID.."的任务，请检查配置")
           goto continue
        end
        if TaskData.EnableDay > self.EventDay then -- 活动未开放，不显示
            goto continue
        end
        local TaskItem = nil
        if TaskData.TaskType == TaskType.Achievement then
            TaskItem = self:NewItemContent(TaskData.TaskType, TaskData.TaskId, self.MidTermConst["AchievementRewardPoint"].ConstantValue, TaskData.TaskDes)
        end
        if TaskItem then
            TaskItem.TaskProp = Task
            TaskItem.TaskConfig = TaskData
            self.List_Challenge:AddItem(TaskItem)
            table.insert(self.ChallengeTaskList, TaskItem)
        end
        ::continue::
    end
    self.List_Challenge:RequestPlayEntriesAnim()
    self.List_Challenge:SetFocus()
    self:TryIncreaceChallengeTaskNewReddot()
end

function M:SortTaskList(TaskList)
    local ClaimableTasks = {}    -- 可领取（已完成但未领取）
    local OngoingTasks = {}      -- 进行中（未完成）
    local CompletedTasks = {}    -- 已完成（已领取）
    
    for k, v in pairs(TaskList) do
        local taskKey = tonumber(k)
        local isFinished = v.Progress >= v.Target  -- 判断任务是否完成
        
        if v.RewardsGot then
            -- 已领取奖励
            table.insert(CompletedTasks, {key = taskKey, value = v})
        elseif isFinished then
            -- 已完成但未领取，可领取状态
            table.insert(ClaimableTasks, {key = taskKey, value = v})
        else
            -- 进行中
            table.insert(OngoingTasks, {key = taskKey, value = v})
        end
    end
    
    -- 对每个分类按key排序
    table.sort(ClaimableTasks, function(a, b)
        return a.key < b.key
    end)
    table.sort(OngoingTasks, function(a, b)
        return a.key < b.key
    end)
    table.sort(CompletedTasks, function(a, b)
        return a.key < b.key
    end)
    
    -- 按优先级组合：可领取 > 进行中 > 已完成
    local result = {}
    for _, pair in ipairs(ClaimableTasks) do
        table.insert(result, pair.value)
    end
    for _, pair in ipairs(OngoingTasks) do
        table.insert(result, pair.value)
    end
    for _, pair in ipairs(CompletedTasks) do
        table.insert(result, pair.value)
    end
    
    return result
end

function M:TryIncreaceChallengeTaskNewReddot()
    for _, TaskItem in pairs(self.ChallengeTaskList) do
        local CacheKey = TaskItem.TaskProp.UniqueID
        local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeTaskNewReddotName)
        if CacheData and CacheData[CacheKey] == nil then
            CacheData[CacheKey] = true
            ReddotManager.IncreaseLeafNodeCount(ChallengeTaskNewReddotName)
        end
        if CacheData and CacheData[CacheKey] == true then
            self.HasNewTask = true
        end
    end
end

function M:TryClearChallengeTaskNewReddot()
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeTaskNewReddotName)
    if CacheData then
        for key, _ in pairs(CacheData) do
            CacheData[key] = false
        end
    end
    ReddotManager.ClearLeafNodeCount(ChallengeTaskNewReddotName)
    self.HasNewTask = false
end

function M:InitChallengeScoreItem()
    for Count,RewardId in pairs(self.AchievementPrize) do
        local Index = math.floor(Count/10)
        local Params = {
            Owner = self,
            Count = Count,
            Index = Index,
            RewardId = RewardId,
            CanGet = self.MidTermAchvProgressRewarded[Count] and true or false,
            IsReceived = self.MidTermAchvProgressRewarded[Count] == 1,
            CacheKey = "ChallengeScoreItem"..Count,
        }
        
        self["ChallengeScoreItem_"..Index]:Init(Params)
    end
end

function M:TryIncreaceChallengeRewardReddot(Count)
    local CacheKey = "ChallengeScoreItem"..Count
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeRewardReddotName)
    if CacheData and CacheData[CacheKey] == nil then
        CacheData[CacheKey] = true
        ReddotManager.IncreaseLeafNodeCount(ChallengeRewardReddotName)
    end
end

-- function M:TrySubChallengeRewardReddot(Target)
--     local CacheKey = "ChallengeScoreItem"..Target
--     local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeRewardReddotName)
--     if CacheData and CacheData[CacheKey] then
--         CacheData[CacheKey] = nil
--         ReddotManager.DecreaseLeafNodeCount(ChallengeRewardReddotName)
--     end
-- end

-- function M:TryIncreaceChallengeTaskRewardReddot(TaskId)
--     local CacheKey = ChallengeRewardReddotName..TaskId
--     local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeRewardReddotName)
--     if CacheData and CacheData[CacheKey] == nil then
--         CacheData[CacheKey] = true
--         ReddotManager.IncreaseLeafNodeCount(ChallengeRewardReddotName)
--     end
-- end

function M:TrySubChallengeTaskRewardReddot(TaskId)
    local CacheKey = ChallengeRewardReddotName..TaskId
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeRewardReddotName)
    if CacheData and CacheData[CacheKey] then
        CacheData[CacheKey] = nil
        ReddotManager.DecreaseLeafNodeCount(ChallengeRewardReddotName)
    end
end

function M:TrySubChallengeTaskNewReddot(TaskId)
    local CacheKey = TaskId
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeTaskNewReddotName)
    if CacheData and CacheData[CacheKey] then
        CacheData[CacheKey] = false
        ReddotManager.DecreaseLeafNodeCount(ChallengeTaskNewReddotName)
    end
end

function M:UpdateChallengeScoreItem(TaskScoreToday)
    local Avatar = GWorld:GetAvatar()
    local MidTermGoals = Avatar.MidTermGoals[self.MidTermGoalEventId] or {}
    local MidTermAchvProgressRewarded = MidTermGoals.AchvProgressRewarded or {}
    local RewardCanGet = false
    for Count,RewardId in pairs(self.AchievementPrize) do
        local Index = math.floor(Count/10)
        local Item = self["ChallengeScoreItem_"..Index]
        if TaskScoreToday >= Count then
            if MidTermAchvProgressRewarded[Count] == 1 then
                Item:StopAnimation(Item.Reward)
                Item:PlayAnimation(Item.Recived)
            else
                Item:StopAnimation(Item.Forbidden)
                Item:PlayAnimation(Item.In_Reward)
                Item:PlayAnimation(Item.Reward,0,0)
                Item.CanGet = true
                RewardCanGet = true
                self:TryIncreaceChallengeRewardReddot(Count)
            end
        else
            Item:PlayAnimation(Item.Forbidden)
        end
    end
    self.RewardCanGet = RewardCanGet
    if self.RewardCanGet then
        if self.CurInputDevice == ECommonInputType.Gamepad then
            self.Text_TaskScoreTodayTitle:SetText(GText("UI_Event_MidTerm_GetPrize"))
        end
    else
        if self.CurInputDevice == ECommonInputType.Gamepad then
            self.Text_TaskScoreTodayTitle:SetText(GText("UI_Event_MidTerm_GotoPreview"))
        end
    end
end

function M:UpdateOneClickBtnState()
    local canReceive = false
    local function checkTaskItemCanReceive(TaskItem)
        if not TaskItem or not TaskItem.TaskProp then return false end
        local taskProp = TaskItem.TaskProp
        -- 挑战任务均为成就类：达成且未领取
        return taskProp.Progress >= taskProp.Target and not taskProp.RewardsGot
    end
    if self.ChallengeTaskList then
        for _, TaskItem in pairs(self.ChallengeTaskList) do
            if checkTaskItemCanReceive(TaskItem) then
                canReceive = true
                break
            end
        end
    end
    if TimeUtils.NowTime() > self.EventEndTime then canReceive = false end
    if canReceive then
        self.Btn_OneClickGet.Btn_GetReward:SetForbidden(false)
        self.Btn_OneClickGet.Key_GetReward:SetForbidKey(false)
        if CommonUtils.GetDeviceTypeByPlatformName()~="Mobile" then
            self.Owner.Com_Tab:UpdateBottomKeyInfo({
                {KeyInfoList = {{Type="Text", Text="SpaceBar", ClickCallback=self.GetAllTaskScores, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="Y", ClickCallback=self.GetAllTaskScores}},
                Desc = GText("UI_CTL_ClaimALL"), bLongPress = false},
                {KeyInfoList = {{Type="Text", Text="Escape", ClickCallback=self.CloseSelf, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf}},
                Desc = GText("UI_BACK"), bLongPress = false}
            })
        end
    else
        self.Btn_OneClickGet.Btn_GetReward:SetForbidden(true)
        self.Btn_OneClickGet.Key_GetReward:SetForbidKey(true)
        if CommonUtils.GetDeviceTypeByPlatformName()~="Mobile" then
            self.Owner.Com_Tab:UpdateBottomKeyInfo({
            {KeyInfoList = {{Type="Text", Text="Escape", ClickCallback=self.CloseSelf, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf}},
                Desc = GText("UI_BACK"), bLongPress = false}
            })
        end
    end
    self.canReceive = canReceive
end

function M:GetAllTaskScores()
    if TimeUtils.NowTime() > self.EventEndTime then return end
    if self.Btn_OneClickGet.Btn_GetReward:GetForbidden() then return end
    local Avatar = GWorld:GetAvatar()
    AudioManager(self):PlayUISound(self, "event:/ui/activity/wenmingboyi_all_btn_click", nil, nil)
    local function Cb(ErrCode,Ret)
        DebugPrint("GetAllChallengeTaskScores",ErrorCode:Name(ErrCode))
        if ErrCode == ErrorCode.RET_SUCCESS then
            self:UpdateChallengeTaskList()
            self.ChallengeTaskScore = self:CalChallengeTaskScore()
            self:UpdateChallengeTaskScore(self.ChallengeTaskScore)
            self:UpdateOneClickBtnState()
            -- 清理挑战任务“新”红点
            self:ClearChallengeTaskNewReddot()
            -- 清理每个已领取任务对应的奖励红点缓存
            if self.ChallengeTaskList then
                for _, TaskItem in pairs(self.ChallengeTaskList) do
                    if TaskItem.TaskProp and TaskItem.TaskProp.RewardsGot then
                        self:TrySubChallengeTaskRewardReddot(TaskItem.TaskProp.UniqueID)
                    end
                end
            end
            self:PlayAnimation(self.Up)
            AudioManager(self):PlayUISound(self, "event:/ui/activity/wenmingboyi_challenge_score_add", nil, nil)
            -- else
            --     local ErrorCodeData = DataMgr.ErrorCode[ErrCode]
            --     UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(ErrorCodeData.ErrorCodeContent))
        end
        self.Owner:BlockAllUIInput(false)
    end
    self.Owner:BlockAllUIInput(true)
    Avatar:MidTermGetAllAchvScores(Cb)
end

function M:NewItemContent(TaskType, TaskId, TaskPoint, TaskDes)
    local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
    ItemContent.Owner = self
    ItemContent.TaskType = TaskType
    ItemContent.TaskId = TaskId
    ItemContent.Point = TaskPoint
    ItemContent.Desc = TaskDes
    return ItemContent
end

function M:OnAchvFinished(TaskId)
    if not self.ChallengeTaskList then return end
    for _, TaskItem in pairs(self.ChallengeTaskList) do
        if TaskItem.SelfWidget and TaskItem.SelfWidget.OnAchvFinished then
            TaskItem.SelfWidget:OnAchvFinished(TaskId)
        end
    end
    self:UpdateOneClickBtnState()
end

function M:OnMidTermTaskProgressChange(TaskId, Progress)
    if not self.ChallengeTaskList then return end
    for _, TaskItem in pairs(self.ChallengeTaskList) do
        if TaskItem.SelfWidget and TaskItem.SelfWidget.OnMidTermTaskProgressChange then
            TaskItem.SelfWidget:OnMidTermTaskProgressChange(TaskId, Progress)
        end
    end
end

function M:OnTaskGet(Item)
    Item.WS_Btn:SetActiveWidgetIndex(3)
    Item:PlayAnimation(Item.In_Got)
    Item.Content.CanGet = false
    -- 同步更新数据源状态，防止列表项滑出再滑入时状态丢失
    Item.Content.TaskProp.RewardsGot = true
    -- self.ChallengeTaskScore = self.ChallengeTaskScore + self.AchievementRewardPoint
    self.ChallengeTaskScore = self:CalChallengeTaskScore()
    self:TrySubChallengeTaskRewardReddot(Item.TaskProp.UniqueID)
    self:TrySubChallengeTaskNewReddot(Item.TaskProp.UniqueID)
    Item.New:SetVisibility(UIConst.VisibilityOp.Hidden)
    self:UpdateChallengeTaskScore(self.ChallengeTaskScore)
    self:UpdateOneClickBtnState()
    self:AddTimer(0.1,function()
        AudioManager(self):PlayUISound(self, "event:/ui/activity/wenmingboyi_challenge_score_add", nil, nil)
        self:PlayAnimation(self.Up)
    end)
end

function M:OnChallengeRewardGet()
    --获取当前所有可领取挑战的奖励  
    local Avatar = GWorld:GetAvatar()
    local function Callback(ErrCode,Ret)
        if ErrCode == ErrorCode.RET_SUCCESS then
            UIManager(GWorld.GameInstance):LoadUI(UIConst.LoadInConfig, "GetItemPage", nil, nil,nil,nil,Ret,function()
                self:AddTimer(0.1,function()
                    local FocusedTask =self.CurFocusTask or self.List_Challenge:GetItemAt(0)
                    self.List_Challenge:BP_NavigateToItem(FocusedTask)
                end)
            end)
            self:UpdateChallengeScoreItem(self:CalChallengeTaskScore())
            self:ClearChallengeRewardReddot()
        else
            local Params = {
                Count = self.Count,
                Index = self.Index,
                ActivityId = self.MidTermGoalEventId,
                BackFocusWidget = self.List_Challenge,
                OnCloseCallbackFunction = function()
                    self:AddTimer(0.1,function()
                        local FocusedTask =self.CurFocusTask or self.List_Challenge:GetItemAt(0)
                        self.List_Challenge:BP_NavigateToItem(FocusedTask)
                    end)
                end
            }
            UIManager(self):ShowCommonPopupUI(100101, Params, self)
        end
        self.Owner:BlockAllUIInput(false)
    end
    self.Owner:BlockAllUIInput(true)
    Avatar:MidTermGetProgressReward(Callback)
end

--清除奖励红点
function M:ClearChallengeReddot()
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeRewardReddotName)
    if CacheData then
        for key, _ in pairs(CacheData) do
            CacheData[key] = nil
        end
    end
    ReddotManager.ClearLeafNodeCount(ChallengeRewardReddotName)
end

function M:ClearChallengeRewardReddot()
    local Avatar = GWorld:GetAvatar()
    local AchievementPrize = DataMgr.AchievementPrize
    local MidTermAchvScores = Avatar.MidTermGoals[self.MidTermGoalEventId].AchvScores or 0
    
    -- 找到最大档位分数
    local maxCount = 0
    for Count, _ in pairs(AchievementPrize) do
        if Count > maxCount then
            maxCount = Count
        end
    end
    
    -- 如果分数大于等于最大档位，说明所有奖励已经领完，清理所有红点
    if MidTermAchvScores >= maxCount then
        self:ClearChallengeReddot()
        return
    end
    
    -- 否则，只清理已解锁档位的红点
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeRewardReddotName)
    if CacheData then
        for Count, _ in pairs(AchievementPrize) do
            local CacheKey = "ChallengeScoreItem"..Count
            if MidTermAchvScores >= Count then
                CacheData[CacheKey] = nil
                ReddotManager.DecreaseLeafNodeCount(ChallengeRewardReddotName)
            end
        end
    end
end

function M:ClearChallengeTaskNewReddot()
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeTaskNewReddotName)
    if CacheData then
        for _, TaskItem in pairs(self.ChallengeTaskList) do
            local CacheKey = TaskItem.TaskProp.UniqueID
            CacheData[CacheKey] = false
        end
    end
end

--region 手柄
function M:InitListenEvent()
    local PlayerController = self:GetOwningPlayer()
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
    self:InitNavigationRules()
end

function M:RefreshBaseInfo()
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.CurGamepadName = CurGamepadName
    local IsUseGamepad = CurInputDevice == ECommonInputType.Gamepad
    if (IsUseGamepad) then
        --手柄
        if CommonUtils.GetDeviceTypeByPlatformName()~="Mobile" then
            self.Key_TitleScore:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
        if self.RewardCanGet then
            self.Text_TaskScoreTodayTitle:SetText(GText("UI_Event_MidTerm_GetPrize"))
        else
            self.Text_TaskScoreTodayTitle:SetText(GText("UI_Event_MidTerm_GotoPreview"))
        end
        self.Btn_OneClickGet.Key_GetReward:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        if CommonUtils.GetDeviceTypeByPlatformName()~="Mobile" then
            self.Key_TitleScore:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        self.Text_TaskScoreTodayTitle:SetText(GText("UI_Event_MidTerm_ChallengePoint"))
        self.Btn_OneClickGet.Key_GetReward:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.CurInputDevice = CurInputDevice
end

function M:InitNavigationRules()
    self.List_Challenge:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self.List_Challenge:SetNavigationRuleBase(EUINavigation.Left,EUINavigationRule.Stop)
end

function M:BP_GetDesiredFocusTarget()
    if self.CurFocusTask ~= nil then
        return self.CurFocusTask.SelfWidget
    elseif self.List_Challenge:GetItemAt(0) then
        return self.List_Challenge:GetItemAt(0).SelfWidget
    else
        return nil
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = true

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    elseif (InKeyName == "Escape") then
        IsEventHandled = false
    elseif InKeyName == "Q" then
        IsEventHandled = false
    elseif InKeyName == "E" then
        IsEventHandled = false
    elseif InKeyName == "SpaceBar" then
        self:GetAllTaskScores()
    end
    
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = true
    if (InKeyName == Const.GamepadFaceButtonLeft) then
        self:OnChallengeRewardGet()
    elseif (InKeyName == Const.GamepadFaceButtonUp) then
        self:GetAllTaskScores()
    elseif (InKeyName == Const.GamepadFaceButtonRight) then
        IsEventHandled = false
    elseif InKeyName == Const.GamepadLeftShoulder then
        IsEventHandled = false
    elseif InKeyName == Const.GamepadRightShoulder then
        IsEventHandled = false
    end

    if IsEventHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
end
--endregion

return M
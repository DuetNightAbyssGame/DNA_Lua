--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local TaskType = {
    Daily = {1,2},
    Cycle = 3,
    Achievement = 4,
}
---@type WBP_Activity_JJGame_Task_Base_C
local M = Class({"BluePrints.UI.BP_UIState_C",})
local NormalTaskBP_P = "/Game/UI/WBP/Activity/PC/JJGame/WBP_Activity_JJGame_NormalTask_P.WBP_Activity_JJGame_NormalTask_P"
local NormalTaskBP_M = "/Game/UI/WBP/Activity/Mobile/JJGame/WBP_Activity_JJGame_NormalTask_M.WBP_Activity_JJGame_NormalTask_M"
local ChallengeTaskBP_P = "/Game/UI/WBP/Activity/PC/JJGame/WBP_Activity_JJGame_ChallengeTask_P.WBP_Activity_JJGame_ChallengeTask_P"
local ChallengeTaskBP_M = "/Game/UI/WBP/Activity/Mobile/JJGame/WBP_Activity_JJGame_ChallengeTask_M.WBP_Activity_JJGame_ChallengeTask_M"
local NormalRewardReddotName = "JJGameTask_Normal_Reddot"
local ChallengeRewardReddotName = "JJGameTask_Challenge_Reddot"
local NormalTaskNewReddotName = "JJGameTask_Normal_New"
local ChallengeTaskNewReddotName = "JJGameTask_Challenge_New"
---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Super.Construct(self)
    self:AddDispatcher(EventID.OnMidTermTaskComplete,self,self.OnAchvFinished)
    self:AddDispatcher(EventID.OnMidTermTaskProgressChange,self,self.OnMidTermTaskProgressChange)
    self:InitListenEvent()
    self:RefreshBaseInfo()
    ReddotManager.AddListenerEx(NormalTaskNewReddotName, self, self.UpdateNormalTaskNewReddot)
    ReddotManager.AddListenerEx(ChallengeTaskNewReddotName, self, self.UpdateChallengeTaskNewReddot)
    ReddotManager.AddListenerEx(NormalRewardReddotName, self, self.UpdateNormalRewardReddot)
    ReddotManager.AddListenerEx(ChallengeRewardReddotName, self, self.UpdateChallengeRewardReddot)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "JJGameTaskBase", nil)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    AudioManager(self):SetEventSoundParam(self, "JJGameTaskBase", { ToEnd = 1 })
    self.Super.Destruct(self)
    ReddotManager.RemoveListener(NormalTaskNewReddotName, self)
    ReddotManager.RemoveListener(ChallengeTaskNewReddotName, self)
    ReddotManager.RemoveListener(NormalRewardReddotName, self)
    ReddotManager.RemoveListener(ChallengeRewardReddotName, self)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
    self.NormalTaskBP = nil
    self.ChallengeTaskBP = nil
    if CommonUtils.GetDeviceTypeByPlatformName()=="Mobile" then
        self.NormalTaskBP = NormalTaskBP_M
        self.ChallengeTaskBP = ChallengeTaskBP_M
    else
        self.NormalTaskBP = NormalTaskBP_P
        self.ChallengeTaskBP = ChallengeTaskBP_P
    end
    self.Params = Params
    self.Owner = Params.Owner
    self:SwitchBG(Params.TabId)
    self._Avatar = GWorld:GetAvatar()
    self:InitTaskData()
    self:InitMainTab(Params.TabId)
    -- self:InitTask(Params.TabId)
    self:UpdateTabNewReddot()
    self:PlayAnimation(self.In)
    self:SetFocus()
end

function M:InitTaskData()
    --读表
    self.MidTermConst = DataMgr.MidTermGoalConstant
    self.MidTermGoalEventId = self.MidTermConst["MidTermGoalEventId"].ConstantValue
    self.EventStartTime = DataMgr.EventMain[self.MidTermGoalEventId].EventStartTime
    self.EventEndTime = DataMgr.EventMain[self.MidTermGoalEventId].EventEndTime
    self.RewardEndTime = DataMgr.EventMain[self.MidTermGoalEventId].RewardEndTime
    --avatar
    self.MidTermGoals = self._Avatar.MidTermGoals[self.MidTermGoalEventId] or {}
    self.MidTermAchvScores = self.MidTermGoals.AchvScores or 0
    self.MidTermTasks = self.MidTermGoals.Tasks  -- 任务列表
    self.MidTermTasksRecord = self.MidTermGoals.TaskFinishCount  -- 循环任务记录
    self.MidTermAchvProgressRewarded = self.MidTermGoals.AchvProgressRewarded or {} -- 成就任务进度奖励
    self.MidTermScores = self.MidTermGoals.Scores or 0 -- 常规任务分数
    self.MidTermScoresRewards = self.MidTermGoals.ScoresRewards or {} -- 常规任务分数奖励
    self.remainDays, self.remainHours = self:UpdateEventDay()
end

function M:UpdateEventDay()
    local currentTime = TimeUtils.NowTime()
    local SECOND_IN_DAY = CommonConst.SECOND_IN_DAY
    local SECOND_IN_HOUR = CommonConst.SECOND_IN_HOUR
    local RESET_HOUR = 5
    local RESET_OFFSET = RESET_HOUR * SECOND_IN_HOUR
    
    local intervalDays = TimeUtils.GetIntervalDay(self.EventStartTime, currentTime)
    local calculatedEventDay = intervalDays + 1
    local hasDailyTask = false
    local enableDayEventDay = -1
    for _, Task in pairs(self.MidTermTasks) do
        local TaskData = DataMgr.MidTermTask[Task.UniqueID]
        if not TaskData then
            Utils.ScreenPrint("MidTermTask表中不存在UniqueID为"..Task.UniqueID.."的任务，请检查配置")
            goto continue
        end
        if TaskData.TaskType == TaskType.Daily[1] or TaskData.TaskType == TaskType.Daily[2] then
            enableDayEventDay = TaskData.EnableDay
            hasDailyTask = true
            break
        end
        ::continue::
    end
    
    -- 交叉验证：两种方法计算的活动天数应该一致
    if hasDailyTask and calculatedEventDay ~= enableDayEventDay then
        DebugPrint(TXTTag, "警告：EventDay计算不一致！GetIntervalDay方法：" .. calculatedEventDay .. "，EnableDay方法：" .. enableDayEventDay)
    end
    self.EventDay = calculatedEventDay
    
    if not hasDailyTask then
        DebugPrint(TXTTag, "NO DailyTask, EventDay: " .. self.EventDay .. " currentTime: ", TimeUtils.TimeToYMDHMStr(currentTime))
        return false, false 
    end
    -- 查找下一个解锁的Achievement任务
    local nextEnableDay = nil
    for _, Task in pairs(DataMgr.MidTermTask) do
        local TaskData = Task
        if not TaskData then
            Utils.ScreenPrint("MidTermTask表中不存在UniqueID为"..Task.UniqueID.."的任务，请检查配置")
            goto continue
        end
        if TaskData and TaskData.TaskType == TaskType.Achievement and TaskData.EnableDay then
            local enableDay = TaskData.EnableDay
            if enableDay > self.EventDay then
                if not nextEnableDay or enableDay < nextEnableDay then
                    nextEnableDay = enableDay
                end
            end
        end
        ::continue::
    end
   
    if not nextEnableDay then
        DebugPrint(TXTTag, "NO nextEnableDay, EventDay: " .. self.EventDay .. " currentTime: ", TimeUtils.TimeToYMDHMStr(currentTime))
        return false, false
    end

    local nextUnlockTime
    if nextEnableDay == 1 then
        nextUnlockTime = self.EventStartTime
    else
        local eventStartData = TimeUtils.TimestampToDataObj(self.EventStartTime)
        
        -- 第N天的解锁时间 = 活动开始日期 + (N-1)天 + 5点时间 即：活动开始日期的第N天早上5点
        local targetDate = TimeUtils.DataToTimestamp(
            eventStartData.year, eventStartData.month, eventStartData.day + (nextEnableDay - 1), 
            RESET_HOUR, 0, 0
        )
        nextUnlockTime = targetDate
    end
    
    local remainTime = nextUnlockTime - currentTime
    if remainTime < 0 then remainTime = 0 end

    local remainDays = math.floor(remainTime / SECOND_IN_DAY)
    local remainHours = math.floor((remainTime - remainDays * SECOND_IN_DAY) / SECOND_IN_HOUR)
    -- 如果还有剩余时间，但不足1小时，则显示为至少0天1小时
    if remainDays == 0 and remainHours == 0 and remainTime > 0 then
        remainHours = 1
    end
    DebugPrint(TXTTag, "EventDay: " .. self.EventDay .. " remainDays: " .. remainDays .. " remainHours: " .. remainHours, TimeUtils.TimeToYMDHMStr(currentTime))
    return remainDays, remainHours
end

function M:InitMainTab(TargetTabId)
    local IsInPc = CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"
    if IsInPc then
        self.Com_Tab = self.Com_Tab_P
    else
        self.Com_Tab = self.Com_Tab_M
    end
    self.Tabs = {
        {
            TabId = 0,
            Text = GText("UI_Event_MidTerm_NormalTask"),
            IconPath = self.MidTermConst["TabIcon_1"].ConstantString,},
        {
            TabId = 1,
            Text = GText("UI_Event_MidTerm_ChallengeTask"),
            IconPath = self.MidTermConst["TabIcon_2"].ConstantString,},
    }
    self.Com_Tab:Init({
        Tabs = self.Tabs,
        DynamicNode={"Back" ,"BottomKey"},
        BottomKeyInfo = {
            {KeyInfoList = {{Type="Text", Text="SpaceBar", Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="Y", Owner=self}},
                Desc = GText("UI_CTL_ClaimALL"), bLongPress = false},
            {KeyInfoList = {{Type="Text", Text="Escape", ClickCallback=self.CloseSelf, Owner=self}},
            GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf}},
            Desc = GText("UI_BACK"), bLongPress = false}
        },
        OwnerPanel = self,
        BackCallback = self.CloseSelf,
        StyleName = "TextImage",
        TitleName = GText("Event_Title_103006"),
    })
    if self.Com_Tab.Btn_Confirm then
        self.Com_Tab.Btn_Confirm:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.Com_Tab:BindEventOnTabSelected(self, self.OnTabChanged)
    self.IsInited = true
    self.Com_Tab:SelectTabById(TargetTabId)
end

function M:UpdateTabNewReddot()
    local HasNewNormalTask = false
    local HasNewChallengeTask = false
    local HasNormalReward = false
    local HasChallengeReward = false
    local Avatar = GWorld:GetAvatar()
    self.MidTermGoals = Avatar.MidTermGoals[self.MidTermGoalEventId] or {}
    local MidTermTasks = self.MidTermGoals.Tasks or {}
	for TaskId, Task in pairs(MidTermTasks) do
        local TaskData = DataMgr.MidTermTask[Task.UniqueID]
        if not TaskData then
            Utils.ScreenPrint("MidTermTask表中不存在UniqueID为"..Task.UniqueID.."的任务，请检查配置")
            goto continue
        end
        local CacheKey = Task.UniqueID
        if TaskData.TaskType == TaskType.Achievement then
            local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeTaskNewReddotName)
            if CacheData and CacheData[CacheKey] then
                HasNewChallengeTask = true
            end
        else
            local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalTaskNewReddotName)
            if CacheData and CacheData[CacheKey] then
                HasNewNormalTask = true
            end
        end
        ::continue::
    end
    
    -- 检查reward红点状态
    local NormalRewardCacheData = ReddotManager.GetLeafNodeCacheDetail(NormalRewardReddotName)
    if NormalRewardCacheData then
        -- 检查ScoresRewards红点
        if NormalRewardCacheData[NormalRewardReddotName.."ScoresRewards"] then
            HasNormalReward = true
        end
        -- 检查任务相关红点
        if not HasNormalReward then
            for TaskId, Task in pairs(MidTermTasks) do
                local TaskData = DataMgr.MidTermTask[Task.UniqueID]
                if not TaskData then
                    Utils.ScreenPrint("MidTermTask表中不存在UniqueID为"..Task.UniqueID.."的任务，请检查配置")
                    goto continue
                end
                if TaskData.TaskType ~= TaskType.Achievement then
                    local TaskCacheKey = NormalRewardReddotName..Task.UniqueID
                    if NormalRewardCacheData[TaskCacheKey] then
                        HasNormalReward = true
                        break
                    end
                end
                ::continue::
            end
        end
    end
    
    local ChallengeRewardCacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeRewardReddotName)
    if ChallengeRewardCacheData then
        for key, _ in pairs(ChallengeRewardCacheData) do
            if ChallengeRewardCacheData[key] then
                HasChallengeReward = true
                break
            end
        end
    end
    
    -- Normal Tab reward优先级高于new
    if HasNormalReward then
        self.Com_Tab:ShowTabRedDot(1, false, true) -- 显示reddot类型
    elseif HasNewNormalTask then
        if TimeUtils.NowTime() < self.EventEndTime then
            self.Com_Tab:ShowTabRedDot(1, true, false) -- 显示new类型
        end
    else
        self.Com_Tab:ShowTabRedDot(1, false)
    end
    
    -- Challenge Tab reward优先级高于new
    if HasChallengeReward then
        self.Com_Tab:ShowTabRedDot(2, false, true) -- 显示reddot类型
    elseif HasNewChallengeTask then
        if TimeUtils.NowTime() < self.EventEndTime then
            self.Com_Tab:ShowTabRedDot(2, true, false) -- 显示new类型
        end
    else
        self.Com_Tab:ShowTabRedDot(2, false)
    end

    -- 活动结束，清除所有Tab红点
    if TimeUtils.NowTime() > self.RewardEndTime then
        self.Com_Tab:ShowTabRedDot(1, false)
        self.Com_Tab:ShowTabRedDot(2, false)
        return
    end
end

function M:UpdateNormalRewardReddot(Count)
    if not self.Com_Tab then return end
    self:UpdateTabNewReddot()
end

function M:UpdateChallengeRewardReddot(Count)
    if not self.Com_Tab then return end
    self:UpdateTabNewReddot()
end

function M:UpdateNormalTaskNewReddot(Count)
    if not self.Com_Tab then return end
    self:UpdateTabNewReddot()
end

function M:UpdateChallengeTaskNewReddot(Count)
    if not self.Com_Tab then return end
    self:UpdateTabNewReddot()
end

function M:InitTask(TargetTabId)
    self.PanelAnchor:ClearChildren()
    if TargetTabId == 0 then
        self.NormalTaskWidget = UIManager(self):CreateWidget(self.NormalTaskBP)
        self.TaskWidget = self.NormalTaskWidget
    else 
        self.ChallengeTaskWidget = UIManager(self):CreateWidget(self.ChallengeTaskBP)
        self.TaskWidget = self.ChallengeTaskWidget
    end
    if not self.TaskWidget then return end

    local Slot = self.PanelAnchor:AddChildToOverlay(self.TaskWidget)
    Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    local Params = {
        Owner = self,
        EventDay = self.EventDay,
        RemainDays = self.remainDays,
        RemainHours = self.remainHours,
        EventEndTime = self.EventEndTime,
    }
    self.TaskWidget:Init(Params)
    -- self.PanelAnchor:AddChild(self.TaskWidget)
end

function M:TryIncreaceNormalRewardReddot(TaskId)
    local CacheKey = NormalRewardReddotName..TaskId
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalRewardReddotName)
    if CacheData and CacheData[CacheKey] == nil then
        CacheData[CacheKey] = true
        ReddotManager.IncreaseLeafNodeCount(NormalRewardReddotName)
    end
end

function M:TryIncreaceChallengeTaskRewardReddot(TaskId)
    -- 检查左侧奖励是否全部领取完毕
    local allRewardsClaimed = true
    for _, v in pairs(self.MidTermAchvProgressRewarded) do
        if v == 0 then
            allRewardsClaimed = false
            break
        end
    end
    
    -- 如果左侧奖励全部领完，不显示红点
    if allRewardsClaimed then
        return
    end
    local CacheKey = ChallengeRewardReddotName..TaskId
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeRewardReddotName)
    if CacheData and CacheData[CacheKey] == nil then
        CacheData[CacheKey] = true
        ReddotManager.IncreaseLeafNodeCount(ChallengeRewardReddotName)
    end
end

function M:OnAchvFinished(TaskId)
    -- TaskBase统一处理任务完成事件，通知当前的TaskWidget
    -- if self.TaskWidget and self.TaskWidget.OnAchvFinished then
    --     self.TaskWidget:OnAchvFinished(TaskId)
    -- end
    if self.NormalTaskWidget and self.NormalTaskWidget.OnAchvFinished then
        self.NormalTaskWidget:OnAchvFinished(TaskId)
    end
    if self.ChallengeTaskWidget and self.ChallengeTaskWidget.OnAchvFinished then
        self.ChallengeTaskWidget:OnAchvFinished(TaskId)
    end
    
    -- 检查任务类型并添加相应的奖励红点
    local Avatar = GWorld:GetAvatar()
    local MidTermGoals = Avatar.MidTermGoals[self.MidTermGoalEventId] or {}
    local MidTermTasks = MidTermGoals.Tasks or {}
    local Task = MidTermTasks[TaskId]
    if Task then
        local TaskData = DataMgr.MidTermTask[Task.UniqueID]
        if TaskData and TaskData.TaskType == TaskType.Achievement then
            -- 挑战任务完成，添加挑战任务奖励红点
            if TaskData.EnableDay <= self.EventDay then -- 任务已开放才添加红点
                self:TryIncreaceChallengeTaskRewardReddot(TaskId)
            end
        else
            -- 常规任务完成，添加常规任务奖励红点
            self:TryIncreaceNormalRewardReddot(TaskId)
        end
    end
end

function M:OnMidTermTaskProgressChange(TaskId, Progress)
    if self.TaskWidget and self.TaskWidget.OnMidTermTaskProgressChange then
        self.TaskWidget:OnMidTermTaskProgressChange(TaskId, Progress)
    end
end

--region 服务器回调相关
function M:GetTaskReward(Item,TaskWidget,TaskId)
    local Avatar = GWorld:GetAvatar()
    local function Callback(ErrCode)
        print("MidTermGetTaskReward",ErrorCode:Name(ErrCode))
        if ErrCode == ErrorCode.RET_SUCCESS then
            TaskWidget:OnTaskGet(Item)
        else
            local ErrorCodeData = DataMgr.ErrorCode[ErrCode]
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(ErrorCodeData.ErrorCodeContent))
        end
        self:BlockAllUIInput(false)
    end
    self:BlockAllUIInput(true)
    Avatar:MidTermGetTaskReward(TaskId,Callback)
end

--endregion

function M:OnTabChanged(TabWidget)
    if self.IsInited then
        self.IsInited = false
    else
        AudioManager(self):PlayUISound(self, "event:/ui/activity/wenmingboyi_page_refresh", nil, nil)
    end
    self:PlayAnimation(self.Change)
    local TabId = TabWidget:GetTabId()
    self.CurrentTabIndex = TabId
    self:SwitchBG(TabId)
    self:InitTask(TabId)
end

function M:SwitchBG(TabId)
    if TabId == 0 then
        self.WS_BG:SetActiveWidgetIndex(0)
    else 
        self.WS_BG:SetActiveWidgetIndex(1)
    end
end

function M:CloseSelf()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    self:BindToAnimationFinished(self.Out, { self, self.Close })
    EventManager:FireEvent(EventID.OnActivityEntryShowVisible)
    self:PlayAnimation(self.Out)
    if self.Params.CloseCallback then
        self.Params.CloseCallback(self,self.Params.CloseCallbackObj)
    end
end
--region 手柄
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        if (InKeyName == "Escape") then
            self:CloseSelf()
        elseif InKeyName == "Q" then
            self.Com_Tab:TabToLeft()
        elseif InKeyName == "E" then
            self.Com_Tab:TabToRight()
        end
    end

    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == "Gamepad_FaceButton_Right" then
        if self.NormalTaskWidget and self.NormalTaskWidget.IsFocusBigReward then
            self.NormalTaskWidget.IsFocusBigReward = false
            return UE4.UWidgetBlueprintLibrary.Handled() 
        end
        self:CloseSelf()
    elseif InKeyName == Const.GamepadLeftShoulder then
        self.Com_Tab:TabToLeft()
    elseif InKeyName == Const.GamepadRightShoulder then
        self.Com_Tab:TabToRight()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:InitListenEvent()
    local PlayerController = self:GetOwningPlayer()
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
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
        -- if not self.TaskWidget:HasAnyUserFocus() then
        --     self.TaskWidget:SetFocus()
        -- end
    else
        
    end
    self.CurInputDevice = CurInputDevice
end

function M:BP_GetDesiredFocusTarget()
    return self.TaskWidget
end

function M:ReceiveEnterState(StackAction)
    self.Super.ReceiveEnterState(self,StackAction)
    if self.CurrentTabIndex == 0 then
        if IsValid(self.TaskWidget.NormalItem) then
            local FirstItem = self.TaskWidget.NormalItem.List_Task:GetItemAt(0)
            if FirstItem and FirstItem.SelfWidget then
                FirstItem.SelfWidget:SetFocus()
            else
                self.TaskWidget.NormalItem:SetFocus()
            end
        end
    elseif self.CurrentTabIndex == 1 then
        if IsValid(self.TaskWidget.List_Challenge) then
            local FirstItem = self.TaskWidget.List_Challenge:GetItemAt(0)
            if FirstItem and FirstItem.SelfWidget then
                FirstItem.SelfWidget:SetFocus()
            else
                self.TaskWidget.List_Challenge:SetFocus()
            end
        end
    end
end
--endregion

return M
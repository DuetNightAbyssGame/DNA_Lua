--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"
local TaskType = {
    Daily = {1,2},
    Cycle = 3,
    Achievement = 4,
}
---@type WBP_Activity_JJGame_TaskEntryBtn_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local NormalRewardReddotName = "JJGameTask_Normal_Reddot"
local NormalTaskNewReddotName = "JJGameTask_Normal_New"
local ChallengeRewardReddotName = "JJGameTask_Challenge_Reddot"
local ChallengeTaskNewReddotName = "JJGameTask_Challenge_New"
---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.MidTermConst = DataMgr.MidTermGoalConstant
    self.MidTermGoalEventId = self.MidTermConst["MidTermGoalEventId"].ConstantValue
    self.EventEndTime = DataMgr.EventMain[self.MidTermGoalEventId].EventEndTime
    self.RewardEndTime = DataMgr.EventMain[self.MidTermGoalEventId].RewardEndTime
    self.Text_TaskScoreToday_Total:SetText(tonumber(self.MidTermConst["MaxPrizePoint"].ConstantValue))
    self.Text_NormalTask:SetText(GText("UI_Event_MidTerm_NormalTask"))
    self.Text_ChallengeTask:SetText(GText("UI_Event_MidTerm_ChallengeTask"))
    self.Text_TaskScoreTodayTitle:SetText(GText("UI_Event_MidTerm_PointView"))
    self.Btn_NormalTask.OnClicked:Add(self,self.OnNormalTaskClicked)
    self.Btn_ChallengeTask.OnClicked:Add(self,self.OnChallengeTaskClicked)
    self._Avatar = GWorld:GetAvatar()
    self.MidTermGoals = self._Avatar.MidTermGoals[self.MidTermGoalEventId] or {}
    self.Text_TaskScoreToday:SetText(self.MidTermGoals.Scores or 0)
    self:InitGamepadKey()
    self:RefreshBaseInfo()
    self:InitListenEvent()
    self:InitJJGameReddot()
end

function M:Destruct()
    self.Btn_NormalTask.OnClicked:Clear()
    self.Btn_ChallengeTask.OnClicked:Clear()
    ReddotManager.RemoveListener(NormalRewardReddotName, self)
    ReddotManager.RemoveListener(ChallengeRewardReddotName, self)
    ReddotManager.RemoveListener(NormalTaskNewReddotName, self)
    ReddotManager.RemoveListener(ChallengeTaskNewReddotName, self)
end

function M:Init()
    self:PlayAnimation(self.In_1)
    self:PlayAnimation(self.In_2)
end

function M:InitPage(EventId)
    self:PlayAnimation(self.In_1)
    self:PlayAnimation(self.In_2)
end

function M:OnNormalTaskClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/activity/wenmingboyi_entrance_btn_click", nil, nil)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if not UIManager then return end
    local params = {
        Owner = self,
        TabId = 0,
        CloseCallback = self.OnCloseCallback,
        CloseCallbackObj = self,
    }
    if IsValid(self.ActivityJJGameTask) then
        UIManager:LoadUI(UIConst.LoadInConfig,"ActivityJJGameTask", self.ActivityJJGameTask:GetZOrder(),params)
        return
    end
    self.ActivityJJGameTask = UIManager:LoadUINew("ActivityJJGameTask", params)
end

function M:OnChallengeTaskClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/activity/wenmingboyi_entrance_btn_click", nil, nil)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if not UIManager then return end
    local params = {
        Owner = self,
        TabId = 1,
        CloseCallback = self.OnCloseCallback,
        CloseCallbackObj = self,
    }
    if IsValid(self.ActivityJJGameTask) then
        UIManager:LoadUI(UIConst.LoadInConfig,"ActivityJJGameTask", self.ActivityJJGameTask:GetZOrder(),params)
        return
    end
    self.ActivityJJGameTask = UIManager:LoadUINew("ActivityJJGameTask", params)
end

function M:OnCloseCallback(CloseCallbackObj)
    -- self:CheckIsMidTermGoalNeedShowReddot()
    CloseCallbackObj:InitJJGameReddot()
    -- CloseCallbackObj:UpdateActivityTabNewReddot()
end

function M:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:RefreshBaseInfo()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.CurGamepadName = CurGamepadName
    local IsUseGamepad = CurInputDevice == ECommonInputType.Gamepad
    if (IsUseGamepad) then
        --手柄
        self.Key_Normal:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Key_Challenge:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Key_Normal:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Key_Challenge:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.CurInputDevice = CurInputDevice
end

function M:InitGamepadKey()
    self.Key_Normal:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "X"
            }
        }
    })
    self.Key_Challenge:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Y"
            }
        }
    })
end

function M:HandleKeyDownInPage(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadButtonDown(InKeyName)
    else
        IsEventHandled = false
    end
    return IsEventHandled
end

function M:OnGamePadButtonDown(InKeyName)
    local IsEventHandled = self:HandleKeyDownOnGamePad(InKeyName)
    return IsEventHandled
end

function M:HandleKeyDownOnGamePad(InKeyName)
    local IsEventHandled = false
    if (InKeyName == Const.GamepadFaceButtonLeft) then
        self:OnNormalTaskClicked()
    elseif (InKeyName == Const.GamepadFaceButtonUp) then
        self:OnChallengeTaskClicked()
    end
    return IsEventHandled
end

--region 红点
function M:InitJJGameReddot()
    if not ReddotManager.GetTreeNode(NormalRewardReddotName) then
        ReddotManager.AddNodeEx(NormalRewardReddotName,nil,Const.ReddotCacheType.UserCache)
    end
    if not ReddotManager.GetTreeNode(ChallengeRewardReddotName) then
        ReddotManager.AddNodeEx(ChallengeRewardReddotName,nil,Const.ReddotCacheType.UserCache)
    end
    if not ReddotManager.GetTreeNode(NormalTaskNewReddotName) then
        ReddotManager.AddNodeEx(NormalTaskNewReddotName,nil,Const.ReddotCacheType.UserCache)
    end
    if not ReddotManager.GetTreeNode(ChallengeTaskNewReddotName) then
        ReddotManager.AddNodeEx(ChallengeTaskNewReddotName,nil,Const.ReddotCacheType.UserCache)
    end

    ReddotManager.AddListenerEx(NormalRewardReddotName, self, self.UpdateNormalReddot)
    ReddotManager.AddListenerEx(ChallengeRewardReddotName, self, self.UpdateChallengeReddot)
    ReddotManager.AddListenerEx(NormalTaskNewReddotName, self, self.UpdateNormalTaskNewReddot)
    ReddotManager.AddListenerEx(ChallengeTaskNewReddotName, self, self.UpdateChallengeTaskNewReddot)
    self._Avatar = GWorld:GetAvatar()
    self.MidTermGoals = self._Avatar.MidTermGoals[self.MidTermGoalEventId] or {}
    self:CheckIsMidTermGoalNeedShowReddot()
    self:UpdateActivityTabNewReddot()
end

function M:CalEventDay()
    local MidTermGoalEventId = DataMgr.MidTermGoalConstant["MidTermGoalEventId"].ConstantValue
    local EventStartTime = DataMgr.EventMain[MidTermGoalEventId].EventStartTime
    local currentTime = TimeUtils.NowTime()
    local intervalDays = TimeUtils.GetIntervalDay(EventStartTime, currentTime)
    local calculatedEventDay = intervalDays + 1
    return calculatedEventDay
end

function M:CheckIsMidTermGoalNeedShowReddot()
    self:ClearNormalRewardReddot()--清掉常规奖励红点并重新计算，防止过期的每日任务显示红点
    local MidTermScoresRewards = self.MidTermGoals.ScoresRewards or {}
    local MidTermAchvProgressRewarded = self.MidTermGoals.AchvProgressRewarded or {}
    local TaskFinishCounts = self.MidTermGoals.TaskFinishCount or {}
    local MidTermTasks = self.MidTermGoals.Tasks or {}
    local AchievementPrize = DataMgr.AchievementPrize
    local MidTermAchvScores = self.MidTermGoals.AchvScores or 0

    if CommonUtils.Size(MidTermScoresRewards) > 0 then
		self:TryIncreaceNormalRewardReddot("ScoresRewards") --入口常规奖励
	else
		self:TrySubNormalRewardReddot("ScoresRewards")
	end
	for Count, v in pairs(AchievementPrize) do
		if MidTermAchvScores >= Count then
			if MidTermAchvProgressRewarded[Count] ~= 1 then
				self:TryIncreaceChallengeRewardReddot(Count) --入口挑战奖励
			else
				self:TrySubChallengeRewardReddot(Count)
			end
		end
	end

    for TaskId, Task in pairs(MidTermTasks) do
        local TaskData = DataMgr.MidTermTask[Task.UniqueID]
        if not TaskData then
            Utils.ScreenPrint("MidTermTask表中不存在UniqueID为"..Task.UniqueID.."的任务，请检查配置")
            goto continue
        end
        if TaskData.TaskType == TaskType.Achievement then
            if not self._Avatar:CheckIsChallengeRewardAllClaimed() and Task.Progress >= Task.Target and Task.RewardsGot == false and TaskData.EnableDay <= self:CalEventDay() then
                self:TryIncreaceChallengeRewardReddot(Task.UniqueID) --入口挑战奖励,任务可领取也显示红点
            else
                self:TrySubChallengeTaskRewardReddot(Task.UniqueID)
            end
            self:TryIncreaceChallengeTaskNewReddot(Task) --入口挑战任务new
        elseif TaskData.TaskType == TaskType.Cycle then
            if TaskFinishCounts[TaskId] and TaskFinishCounts[TaskId] > 0 then
                self:TryIncreaceNormalRewardReddot(Task.UniqueID) --入口循环任务
            else
                self:TrySubNormalRewardReddot(Task.UniqueID)
            end
            self:TryIncreaceNormalTaskNewReddot(Task) --入口循环任务new
        else
            if Task.Progress >= Task.Target and Task.RewardsGot == false and TaskData.EnableDay == self:CalEventDay() then
                self:TryIncreaceNormalRewardReddot(Task.UniqueID) --入口常规任务(每日)
            else
                self:TrySubNormalRewardReddot(Task.UniqueID)
            end
            if not (CommonUtils.Size(MidTermScoresRewards) > 0) then  --奖励表不空表示未领取
                self:TryIncreaceNormalTaskNewReddot(Task) --入口常规任务new
            end
        end
        ::continue::
    end
    --如果活动结束，清除任务红点
    if TimeUtils.NowTime() > self.EventEndTime then
        self:ClearChallengeTaskNewReddot()
        self:ClearChallengeRewardReddot()
        self:ClearNormalTaskNewReddot()
        local hasUnclaimedScoreRewards = CommonUtils.Size(MidTermScoresRewards) > 0
        
        if not hasUnclaimedScoreRewards or TimeUtils.NowTime() > self.RewardEndTime then
            self:ClearNormalRewardReddot()
        end
    end
end

function M:TryIncreaceNormalRewardReddot(Key)
    local CacheKey = NormalRewardReddotName..Key
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalRewardReddotName)
    if CacheData and CacheData[CacheKey] == nil then
        CacheData[CacheKey] = true
        ReddotManager.IncreaseLeafNodeCount(NormalRewardReddotName)
    end
end

function M:TrySubNormalRewardReddot(Key)
    local CacheKey = NormalRewardReddotName..Key
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalRewardReddotName)
    if CacheData and CacheData[CacheKey] then
        CacheData[CacheKey] = nil
        ReddotManager.DecreaseLeafNodeCount(NormalRewardReddotName)
    end
end

function M:TryIncreaceChallengeRewardReddot(Key)
    local CacheKey = ChallengeRewardReddotName..Key
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeRewardReddotName)
    if CacheData and CacheData[CacheKey] == nil then
        CacheData[CacheKey] = true
        ReddotManager.IncreaseLeafNodeCount(ChallengeRewardReddotName)
    end
end

function M:TrySubChallengeTaskRewardReddot(TaskId)
    local CacheKey = ChallengeRewardReddotName..TaskId
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeRewardReddotName)
    if CacheData and CacheData[CacheKey] then
        CacheData[CacheKey] = nil
        ReddotManager.DecreaseLeafNodeCount(ChallengeRewardReddotName)
    end
end

function M:TrySubChallengeRewardReddot(Target)
    local CacheKey = "ChallengeScoreItem"..Target
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeRewardReddotName)
    if CacheData and CacheData[CacheKey] then
        CacheData[CacheKey] = nil
        ReddotManager.DecreaseLeafNodeCount(ChallengeRewardReddotName)
    end
end

function M:TryIncreaceChallengeTaskNewReddot(TaskItem)
    local CacheKey = TaskItem.UniqueID
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeTaskNewReddotName)
    if CacheData and CacheData[CacheKey] == nil then
        CacheData[CacheKey] = true
        ReddotManager.IncreaseLeafNodeCount(ChallengeTaskNewReddotName)
    end
end

function M:TryIncreaceNormalTaskNewReddot(TaskItem)
    local CacheKey = TaskItem.UniqueID
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalTaskNewReddotName)
    if CacheData and CacheData[CacheKey] == nil then
        CacheData[CacheKey] = true
        ReddotManager.IncreaseLeafNodeCount(NormalTaskNewReddotName)
    end
end

function M:UpdateNormalReddot(Count)
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalRewardReddotName)
    if not CacheData then return end
    -- if CacheData[NormalRewardReddotName] and Count > 0 then
    self.HasNormalReddot = false
    if Count > 0 then
        if self.NormalNew:IsVisible() then
            self.NormalNew:SetVisibility(UIConst.VisibilityOp.Hidden)
        end
        self.NormalReddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.HasNormalReddot = true 
    else
        self.NormalReddot:SetVisibility(UIConst.VisibilityOp.Hidden)
        self.HasNormalReddot = false
    end
    ActivityReddotHelper.RefreshReddotNode(self.MidTermGoalEventId)
end

function M:UpdateChallengeReddot(Count)
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeRewardReddotName)
    if not CacheData then return end
    -- if CacheData[ChallengeRewardReddotName] and Count > 0 then
    self.HasChallengeReddot = false
    if Count > 0 then
        if self.SpecialNew:IsVisible() then
            self.SpecialNew:SetVisibility(UIConst.VisibilityOp.Hidden)
        end
        self.SpecialReddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.HasChallengeReddot = true
    else
        self.SpecialReddot:SetVisibility(UIConst.VisibilityOp.Hidden)
        self.HasChallengeReddot = false
    end

    ActivityReddotHelper.RefreshReddotNode(self.MidTermGoalEventId)
end

function M:UpdateNormalTaskNewReddot(Count)
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalTaskNewReddotName)
    if not CacheData then return end
    -- if CacheData[NormalTaskNewReddotName] and Count > 0 then
    if Count > 0 then
        if self.NormalReddot:IsVisible() then return end
        self.NormalNew:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.NormalNew:SetVisibility(UIConst.VisibilityOp.Hidden)
    end
end

function M:UpdateChallengeTaskNewReddot(Count)
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeTaskNewReddotName)
    if not CacheData then return end
    -- if CacheData[ChallengeTaskNewReddotName] and Count > 0 then
    if Count > 0 then
        if self.SpecialReddot:IsVisible() then return end
        self.SpecialNew:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.SpecialNew:SetVisibility(UIConst.VisibilityOp.Hidden)
    end
end
--endregion

function M:ClearChallengeTaskNewReddot()
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeTaskNewReddotName)
    if CacheData then
        for key, _ in pairs(CacheData) do
            CacheData[key] = nil
        end
    end
    ReddotManager.ClearLeafNodeCount(ChallengeTaskNewReddotName)
end

function M:ClearChallengeRewardReddot()
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeRewardReddotName)
    if CacheData then
        for key, _ in pairs(CacheData) do
            CacheData[key] = nil
        end
    end
    ReddotManager.ClearLeafNodeCount(ChallengeRewardReddotName)
end

function M:ClearNormalTaskNewReddot()
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalTaskNewReddotName)
    if CacheData then
        for key, _ in pairs(CacheData) do
            CacheData[key] = nil
        end
    end
    ReddotManager.ClearLeafNodeCount(NormalTaskNewReddotName)
end

function M:ClearNormalRewardReddot()
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalRewardReddotName)
    if CacheData then
        for key, _ in pairs(CacheData) do
            CacheData[key] = nil
        end
    end
    ReddotManager.ClearLeafNodeCount(NormalRewardReddotName)
end

function M:UpdateActivityTabNewReddot()
    local EventId = self.MidTermGoalEventId
    local NormalTaskNewCacheData = ReddotManager.GetLeafNodeCacheDetail(NormalTaskNewReddotName)
    local function hasTrueValue(cache)
        if not cache then return false end
        for _, v in pairs(cache) do
            if v == true then return true end
        end
        return false
    end
    local ChallengeTaskNewCacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeTaskNewReddotName)
    local hasNormalJJGameTaskNew = hasTrueValue(NormalTaskNewCacheData)
    local hasChallengeJJGameTaskNew = hasTrueValue(ChallengeTaskNewCacheData)
    if hasNormalJJGameTaskNew or hasChallengeJJGameTaskNew then
        ActivityReddotHelper.TryAddReddotCount(ActivityUtils, EventId, "New")
    else
        ActivityReddotHelper.TrySubReddotCount(ActivityUtils, EventId, "New")
    end
end

return M
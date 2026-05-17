--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local TimeUtils = require("Utils.TimeUtils")

local M = Class({"BluePrints.Common.TimerMgr"})

local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"

function M:InitPage(ActivityId, ParentTabId, AllActivityId, ParentWidget)
    self.CurActivityId = ActivityId
    self.ParentTabId = ParentTabId
    self.AllActivityId = AllActivityId
    self.ParentWidget = ParentWidget
    local ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
    self.ActivityEndTime = ActivityConfigData.EventEndTime and ActivityConfigData.EventEndTime or ActivityConfigData.PermanenEventTime
    self.RewardEndTime = ActivityConfigData.RewardEndTime
    self.FinishCondition = ActivityConfigData.EventEndCondition
    self.IsComplete = false
    self.IsCanGetReward = false
    self.IsGetReward = false
    self:UpdateActivityConditionAndRewardState()
    self:InitUI()
    -- 刷新剩余时间
    self:InitTimeInfo()

    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then

    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        DebugPrint("thy    已经显示的是该输入模式，不需要进行刷新")
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    self.IsSwitchDevice = true
    --更新UI
    self:UpdateUIByInputDevice(CurInputDevice)
end

function M:GetPageConfigData()
    return DataMgr.ConditionalRewardEvent[self.CurActivityId]
end

function M:ShowPage(IsNeedPlayInAnim)
    if (IsNeedPlayInAnim) then
        self:PlayFadeIn()
    end
    self:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    self:UpdateActivityConditionAndRewardState()
    self:InitUI()
    -- 刷新剩余时间
    self:InitTimeInfo()
end

function M:HidePage(IsNeedPlayOutAnim)
    if (IsNeedPlayOutAnim) then
        self:PlayFadeOut()
    end
    self:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:PlayFadeIn()
    self:PlayAnimation(self.In)
end

function M:PlayFadeOut(IsRemoveFromParent)
    -- 播放退场动画
    self:PlayAnimation(self.Out)
    if (IsRemoveFromParent) then
        self:BindToAnimationFinished(self.Out, {self, self.RemoveFromParent})
    end
end

function M:UpdatePage(OperateSrc)
end

function M:InitCommonUI()
    local ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
    self.Activity_TimeView:SetForeverTimeText(GText("UI_GameEvent_EventTimeRemain"))
    self.Text_ActivityDescView:SetText(GText(ActivityConfigData.EventDes))
    if (self.Text_TitleView) then
        self.Text_TitleView:SetText(GText(ActivityConfigData.EventName))
    end
    if (self.Text_ActivityDescView_White) then
        self.Text_ActivityDescView_White:SetText(GText(ActivityConfigData.EventDes))
    end

    -- 手柄
    self.FocusWidgetWidget = nil
    self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:InitTimeInfo()
    if (self.ActivityEndTime ~= nil or self.RewardEndTime ~= nil or self.IsComplete) and self.Activity_TimeView then
        local bCheckNextDayFiveStamp = true
        ActivityUtils.RefreshLeftTime(self, self.Activity_TimeView, bCheckNextDayFiveStamp)
        self:AddTimer(1.0, ActivityUtils.RefreshLeftTime, true, 0, "RefreshLeftTime", true, self.Activity_TimeView, bCheckNextDayFiveStamp)
    else
        ActivityUtils.SetLeftTimeView(self.Activity_TimeView, true)
    end
end

function M:UpdateActivityConditionAndRewardState()
    local Avatar = GWorld:GetAvatar()
    if Avatar and self.FinishCondition then
        self.IsComplete = ConditionUtils.CheckCondition(Avatar, self.FinishCondition)
    end

    local PageConfigData = self:GetPageConfigData()
    self.RewardId = PageConfigData.EventReward
    if Avatar and PageConfigData.RewardClaimCondition then
        self.IsCanGetReward = ConditionUtils.CheckCondition(Avatar, PageConfigData.RewardClaimCondition)
    end

    if Avatar and Avatar.ClaimActivityConditionRewardRecord then
        self.IsGetReward = Avatar.ClaimActivityConditionRewardRecord[self.CurActivityId]
    end
end

function M:OnBtnClick()
    if self.IsCanGetReward ~= true then
        return
    end

    if self.IsGetReward or self.IsComplete then
        return
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local function Callback(Ret, Rewards)
        if Ret == 0 then
            local AllRewards = RewardUtils:GetRewards(self.RewardId, nil)
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, AllRewards, false, nil, self)
            self.IsGetReward = true
            self:InitUI()
            ActivityReddotHelper.TrySubReddotCount(ActivityUtils, self.CurActivityId, "Red")
        end
    end
    Avatar:CallServer("ClaimActivityConditionReward", Callback, self.CurActivityId)
end

return M

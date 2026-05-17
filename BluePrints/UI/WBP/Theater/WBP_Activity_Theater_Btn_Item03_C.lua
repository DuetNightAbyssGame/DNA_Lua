--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Theater_Btn_item03_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.TimerMgr"})

function M:OnListItemObjectSet(Content)
    self:Init(Content)
    self.Content = Content
    self.Content.SelfWidget = self
end

function M:Init(Content)
    self.LevelId = Content.LevelId
    self.ParentWidget = Content.ParentWidget
    self.TotalTime = Content.Time
    self.CountDownTime = Content.Time
    self.Index = Content.Index
    self.Switch_item:SetActiveWidgetIndex(0)
    if Content.IsNotDisplay then
        if self.ParentWidget.CurLevelIndex and self.ParentWidget.CurLevelIndex == self.Index then
            self.CountDownTime = Content.EndTime - TimeUtils.NowTime()
            self:OnLevelStart()
        else
            self:PlayAnimation(self.Fail)
            self.Image_Time:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        self:PlayAnimation(self.Normal)
    end
end

function M:OnLevelStart()
    self:PlayAnimation(self.Load)
    self.Text_Time:SetText(tostring(self.CountDownTime))
    self.Image_Time:GetDynamicMaterial():SetScalarParameterValue("Percent", 1)
    -- 添加定时器
    if self.CountDownTimer then
        self:RemoveTimer(self.CountDownTimer)
    end

    self.CountDownTimer = self:AddTimer(1.0, function()
        if self.FinishPerform then
            self.CountDownTime = 0
        else
            self.CountDownTime = self.CountDownTime - 1
        end
        self.Text_Time:SetText(tostring(self.CountDownTime))
        local Percent = self.CountDownTime / self.TotalTime
        self.Image_Time:GetDynamicMaterial():SetScalarParameterValue("Percent", Percent)
        DebugPrint("ayff Theater倒计时:"..self.CountDownTime)
        
        if self.CountDownTime <= 10 and self.CountDownTime > 0 then
            self:PlayAnimation(self.Load_Countdown)
            -- if not self.SuccessPerform then
                AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning_short_reverb", nil, nil)
            -- end
        elseif self.CountDownTime <= 0 then
            self:RemoveTimer(self.CountDownTimer)
            self.CountDownTimer = nil
            self:OnCountDownFinished()
        else
            self.Switch_item:SetActiveWidgetIndex(1)
        end
    end, true, 0, "LevelCountDown", true)
end

function M:OnCountDownFinished()
    -- 倒计时结束后的处理
    -- self.ParentWidget:ClearPerformAction()
    if self.SuccessPerform == true then
        if not self.IsFinished then
            self:PlayAnimation(self.Success)
            self:RemoveTimer("LevelSuccessDelay")
            self.ParentWidget:RemoveTimer("TheaterPerformResultDelay")
            self.ParentWidget:PlayAnimation(self.Tips_Success)
        end
        AudioManager(self):PlayUISound(self, "event:/ui/activity/theater_online_skill_match", nil, nil)
        self.IsFinished = true
    else
        self:PlayAnimation(self.Fail)
        AudioManager(self):PlayUISound(self, "event:/ui/activity/theater_online_skill_match_fail", nil, nil)
    end
    self.YellowBg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function M:SetSuccess(State)
    -- 在匹配成功时不销毁NPC
    -- 阶段结束时销毁
    self.SuccessPerform = State
    if self.SuccessPerform == true then
        local DelayTime = DataMgr.TheaterConstant.TheaterPerformResultDelay.ConstantValue or 0
        self:AddTimer(DelayTime, function()
            self:PlayAnimation(self.Success_Load)
            self.Text_Time:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.IsFinished = true
        end, false, 0, "LevelSuccessDelay")
    end
end

function M:Close()
    self.ParentWidget:Close()
    self.Super.Close(self)
end

function M:Destruct()
    if self.CountDownTimer then
        self:RemoveTimer(self.CountDownTimer)
        self.CountDownTimer = nil
    end
end

return M

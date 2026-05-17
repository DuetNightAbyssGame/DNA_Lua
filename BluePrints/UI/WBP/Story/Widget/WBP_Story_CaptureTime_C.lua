local EState = {
    None = 0,
    Timing = 1,
    Paused = 2,
    Completed = 3
}

local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr"
})

function M:Construct()
    self.TitleText = self.TaskTitle
    self.TimeText = self.TextBlock_LeftTime
    self.TimeTextEffect = self.TextBlock_LeftTime_1

    self.InAnimation = self.FadeIn
    self.OutAnimation = self.Out
    self.RedAnimation = self.FadeInRed

    self.CountdownSeconds = 0
    self.bShowTips = false
    self.Title = ""
    self.RedCountdownSeconds = 0
    self.UpdateSeconds = 1
    self.OnCompleted = nil

    self.State = EState.None
    self.RemainSeconds = 0
    self.Timer = nil

    self:BindToAnimationFinished(self.OutAnimation, { self, self.RemoveFromParent })

    self:PlayAnimation(self.InAnimation)
end

function M:Destruct()
    self:UnbindFromAnimationFinished(self.OutAnimation, { self, self.RemoveFromParent })

    if (self.OnCompleted and self.OnCompleted[1] and self.OnCompleted[2]) then
        self.OnCompleted[2](self.OnCompleted[1])
    end
end

function M:Init(CountdownSeconds, bShowTips, Title, RedCountdownSeconds, OnCompleted)
    self.CountdownSeconds = CountdownSeconds or 0
    self.bShowTips = bShowTips or false
    self.Title = Title or ""
    self.RedCountdownSeconds = RedCountdownSeconds or 0
    self.OnCompleted = OnCompleted

    if (bShowTips) then
        self:SetRenderOpacity(1)
    else
        self:SetRenderOpacity(0)
    end

    if (Title and Title ~= "") then
        self.TitleText:SetText(Title)
        self.TitleText:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.TitleText:SetVisibility(ESlateVisibility.Collapsed)
    end

    self:BeginCountdown()
end

function M:Close()
    if (self:IsAnimationPlaying(self.OutAnimation)) then
        return
    end

    if (self.State ~= EState.Completed) then
        self:EndCountdown()
    end

    self:PlayAnimation(self.OutAnimation)
end

function M:BeginCountdown()
    if (self.State ~= EState.None) then
        DebugPrint(_G.ErrorTag, "%s begin countdown failed, current state is %d", self.ClassName, self.State)
        return
    end

    self.State = EState.Timing
    self.RemainSeconds = self.CountdownSeconds

    self:UpdateCountdown(0)
    self.TimerHandle = self:AddTimer(self.UpdateSeconds, function()
        self:UpdateCountdown(self.UpdateSeconds)
    end, true)
end

function M:UpdateCountdown(DeltaSeconds)
    if (self.State ~= EState.Timing) then
        DebugPrint(_G.ErrorTag, "%s update countdown failed, current state is %d", self.ClassName, self.State)
        return
    end

    self.RemainSeconds = self.RemainSeconds - DeltaSeconds

    local TimeText = self:SecondsToText(self.RemainSeconds)
    self.TimeText:SetText(TimeText)
    self.TimeTextEffect:SetText(TimeText)

    if (self.RemainSeconds <= 0) then
        self:EndCountdown()
    elseif (self.RemainSeconds <= self.RedCountdownSeconds) then
        self:PlayAnimation(self.RedAnimation)
    end
end

function M:PauseCountdown()
    if (self.State ~= EState.Timing) then
        DebugPrint(_G.ErrorTag, "%s pause countdown failed, current state is %d", self.ClassName, self.State)
        return
    end

    self.State = EState.Paused
    self:RemoveTimer(self.TimerHandle)
end

function M:ResumeCountdown()
    if (self.State ~= EState.Paused) then
        DebugPrint(_G.ErrorTag, "%s resume countdown failed, current state is %d", self.ClassName, self.State)
        return
    end

    self.State = EState.Timing
    self.TimerHandle = self:AddTimer(self.UpdateSeconds, function()
        self:UpdateCountdown(self.UpdateSeconds)
    end, true)
end

function M:EndCountdown()
    if (self.State ~= EState.Timing) then
        DebugPrint(_G.ErrorTag, "%s end countdown failed, current state is %d", self.ClassName, self.State)
        return
    end

    self.State = EState.Completed
    self:RemoveTimer(self.TimerHandle)
    self:Close()
end

function M:SecondsToText(Seconds)
    local Mins = math.floor(Seconds / 60)
    local Secs = Seconds % 60
    return string.format("%02d:%02d", Mins, Secs)
end

return M

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Dungeon_TempleTime_C
local M = Class("BluePrints.UI.Dungeon.WBP_DungeonUIBase_C")

function M:Initialize(Initializer)
    self.Super.Initialize(self)
	self.RemainingTime = nil
    self.TurnRedTime = -1
    self.BGDefaultColor = FLinearColor(0.0,0.0,0.0,0.8)
end

function M:InitListenEvent()
    self:AddDispatcher(EventID.ShowDungeonUI, self, self.ShowDungeonUI)
    self:AddDispatcher(EventID.CloseDungeonUI, self, self.CloseDungeonUI)
end

function M:InitTempleTimeUIOnShowDownTime()
    local TimeStr = self:GetTimeStr(math.floor(self.RemainingTime))
    self.Text_TempleTimeTitle:SetText(GText("UI_DUNGEON_DES_RESCUE_5"))
    self.Text_Time:SetText(TimeStr)
	self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function M:InitTempleDelayTimeUI(Title,Time, RedCountdownTime)
    self.RemainingTime = Time
    self.RedCountdownTime = RedCountdownTime
    self.AlreadyRed = false
    local TimeStr = self:GetTimeStr(math.floor(self.RemainingTime))
    self.Text_TempleTimeTitle:SetText(GText(Title))
    self.Text_Time:SetText(TimeStr)
    self:AddTimer(1, self.UpdateRemainingTimeInTemple, true, 0, "TempleDelayTimer", false)
    if Time > RedCountdownTime then
        EMUIAnimationSubsystem:EMPlayAnimation(self,self.In)
    else
        EMUIAnimationSubsystem:EMPlayAnimation(self,self.Warning_In)
        self.AlreadyRed = true
        AudioManager(self):PlayUISound(self, "event:/ui/common/shenmiao_countdown_appear", nil, nil)
    end
	self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function M:ShowDungeonUI()
    EMUIAnimationSubsystem:EMPlayAnimation(self,self.Warning_In)
    self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self.Text_Time:SetColorAndOpacity(self.NormalColor)
    self.AlreadyClose = false
end

function M:CloseDungeonUI()
    if self.AlreadyClose then return end
    self.AlreadyClose = true
    local OutAnim = self.Out
    self:RemoveTimer("RefreshDistanceTimer")
    self:RemoveTimer("TempleDelayTimer")
    if OutAnim then
	    EMUIAnimationSubsystem:EMPlayAnimation(self,OutAnim)
    else
        self:SetVisibility(ESlateVisibility.Collapsed)
    end
end

-- 神庙Delay节点倒计时
function M:UpdateRemainingTimeInTemple()
    -- 这个倒计时只给显示用，Delay节点的计时器在GameMode上
    self.RemainingTime = self.RemainingTime - 1
    if self.RemainingTime > self.RedCountdownTime then
        local TimeStr = self:GetTimeStr(math.floor(self.RemainingTime))
        self.Text_Time:SetText(TimeStr)
        AudioManager(self):PlayUISound(self, "event:/ui/common/battle_countdown", nil, nil)
    elseif self.RemainingTime >= 0 then
        local TimeStr = self:GetTimeStr(math.floor(self.RemainingTime))
        self.Text_Time:SetText(TimeStr)
        AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning_short_reverb", nil, nil)
        if not self.AlreadyRed then
            EMUIAnimationSubsystem:EMPlayAnimation(self,self.Warning_In)
            self.AlreadyRed = true
            AudioManager(self):PlayUISound(self, "event:/ui/common/shenmiao_countdown_appear", nil, nil)
        end
    else
        self:RemoveTimer("TempleDelayTimer")
        if not self.AlreadyClose then
            EMUIAnimationSubsystem:EMPlayAnimation(self,self.Out)
        end
    end
end


return M

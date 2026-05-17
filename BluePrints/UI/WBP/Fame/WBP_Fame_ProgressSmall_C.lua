--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Fame_ProgressSmall_C
local M = Class("BluePrints.UI.BP_UIState_C")

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

function M:Init(Content)
    rawset(self, "FameLevel", Content.FameLevel)
    rawset(self, "CurrentFameValue", Content.CurrentFameValue)
    rawset(self, "MaxFameValue", Content.MaxFameValue)
    rawset(self, "bMaxLevel", Content.bMaxLevel)
    -- 不更新进度条
    rawset(self, "bNotUpdateProgress", Content.bNotUpdateProgress)

    self.TextLevel:SetText(GText("ReputationLevel_Title01"))
    self.TextLevelNum:SetText(self.FameLevel)
    if self.bMaxLevel then
        self.TextNow_1:SetText(GText("Reputation_MaxLevel"))
        self.WidgetSwitcher_0:SetActiveWidgetIndex(1)
    else
        if self.MaxFameValue then
            self.TextTotal:SetText(string.format("/%d", self.MaxFameValue))
        end
        self.WidgetSwitcher_0:SetActiveWidgetIndex(0)
    end

    -- bNotUpdateProgress 为True时，不更新进度条 此时进度条交由动画控制
    if not self.bNotUpdateProgress then
        self.TextNow:SetText(self.CurrentFameValue)
        local LevelPercent = 1
        if self.MaxFameValue then
            LevelPercent = self.CurrentFameValue / self.MaxFameValue
        end
        self.ProgressBar_Fame:SetPercent(LevelPercent)
    end
end

function M:UpdateReputationExp(ReputationExpAddInfo)
    rawset(self, "OldLevel", ReputationExpAddInfo.OldLevel)
    rawset(self, "OldExp", ReputationExpAddInfo.OldExp)
    rawset(self, "CurLevel", ReputationExpAddInfo.CurLevel)
    rawset(self, "CurExp", ReputationExpAddInfo.CurExp)
    local bLevelUp = self.OldLevel == self.CurLevel
    local ExpFrom = bLevelUp and self.OldExp or 0
    rawset(self, "UpdateExpFrom", ExpFrom)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Up)
end

function M:UpdateCurrentExp()
    local CurreentTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
    local ElapsedTime = CurreentTime - self.StartUpdateExpTime
    local Progress = ElapsedTime / self.UpdateExpDuration
    Progress =  math.min(Progress, 1.0)
    local ExpGrowNum = self.UpdateExpTo - self.UpdateExpFrom
    local CurrentExp = self.UpdateExpFrom + ExpGrowNum * Progress
    local FinExpText = string.format("%.0f", CurrentExp)
    self.TextNow:SetText(FinExpText)
    local LevelPercent = 1
    if self.MaxFameValue then
        LevelPercent = CurrentExp / self.MaxFameValue
    end
    self.ProgressBar_Fame:SetPercent(LevelPercent)
end

function M:StartAddExp_Lua()
    rawset(self, "StartUpdateExpTime", UE4.UGameplayStatics.GetRealTimeSeconds(self))
    rawset(self, "UpdateExpDuration", self.ExpAddTime)
    rawset(self, "UpdateExpTo", self.CurExp)
    self:AddTimer(0.03, self.UpdateCurrentExp, true, 0, "AddExpLoop", true)
    if not self.PlayingSound then
        -- ScreenPrint("PlayUISound region_level_task_complete")
        AudioManager(self):PlayUISound(self, "event:/ui/common/region_level_task_complete", nil, nil)
        rawset(self, "PlayingSound", true)
    end
end

function M:EndAddExp_Lua()
    self:RemoveTimer("AddExpLoop",true)
    rawset(self, "PlayingSound", false)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M

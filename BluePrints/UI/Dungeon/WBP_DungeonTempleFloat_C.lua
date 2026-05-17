require "UnLua"

---@type WBP_Dungeon_Temple_C
local WBP_DungeonTempleFloat_C = Class("BluePrints.UI.Dungeon.WBP_DungeonUIBase_C")

function WBP_DungeonTempleFloat_C:Initialize(Initializer)
    self.Super.Initialize(self)
    self.ScoreOrCollect = 0   --总分
    -- self.InAnimationScore = 0   --记录在播放动画的过程中累积的得分
    self.CurTime = 0  -- 剩余时间
    self.CurStar = 0  -- 当前达成的星级
    self.IsStarTemple = false  -- 是否为星级神庙
end

function WBP_DungeonTempleFloat_C:InitListenEvent()
	self.Super.InitListenEvent(self)
    self:AddDispatcher(EventID.OnSetTempleLimit, self, self.OnSetTempleLimit)
    self:AddDispatcher(EventID.OnTempleTimeChanged, self, self.OnTempleTimeChanged)
    self:AddDispatcher(EventID.OnTempleScoreCollectChanged, self, self.OnTempleScoreCollectChanged)
    self:AddDispatcher(EventID.OnTempleEnter, self, self.OnTempleEnter)
end

function WBP_DungeonTempleFloat_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self:InitListenEvent()
    self:InitInfo()
end

function WBP_DungeonTempleFloat_C:InitInfo()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if not GameInstance then
        return
    end
    self.DungeonId = GameInstance:GetCurrentDungeonId()
    self.DungeonInfo = DataMgr.Dungeon[self.DungeonId]
    if not self.DungeonInfo then
        return
    end
    if self.DungeonInfo.DungeonType == "Temple" then
        self.TempleInfo = DataMgr.Temple[self.DungeonId]
        self:InitTemple()
    end
end

function WBP_DungeonTempleFloat_C:InitTemple()
    -- 神庙左侧UI
    self.HB_Time:SetVisibility(ESlateVisibility.Hidden)
    self.HB_ScoreNum:SetVisibility(ESlateVisibility.Hidden)
    self.Text_ScoreNum:SetText(0)
    if #self.TempleInfo.RewardId <= 1 or not self.TempleInfo.RatingRange or #self.TempleInfo.RatingRange <= 1 then
        self.IsStarTemple = false
        self.VB_Item:SetVisibility(ESlateVisibility.Collapsed)
    elseif #self.TempleInfo.RewardId > 1 and self.TempleInfo.RatingRange and #self.TempleInfo.RatingRange > 1 then
        self.IsStarTemple = true
        self.VB_Item:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    self.IsCountDown = false
    if self.TempleInfo.SucRule == "CountDown" then
        self.IsCountDown = true
    else
        self:InitTargetInfo()
    end
end

function WBP_DungeonTempleFloat_C:OnTempleTimeChanged(CurrentTime, ThresholdTime)
    -- 超过1s的时间变化用动画加减
    local Time = ThresholdTime - CurrentTime
    local ChangeValue = Time - self.CurTime
    if ChangeValue > 1 then
        self.Text_TimeNumChange:SetText("+" .. ChangeValue)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Time_Add)
    elseif ChangeValue < -1 then
        self.Text_TimeNumChange:SetText(ChangeValue)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Time_Minus)
    end

    if self.TempleInfo.SucRule == "Time" then
        self.Text_Time:SetText(self:GetTimeStr(CurrentTime))
    end
    if self.Limit == "TIME" then
        -- local Time = ThresholdTime - CurrentTime
        self.CurTime = Time
        if Time >= 0 then
            self.Text_Time:SetText(self:GetTimeStr(Time))
        end
    end

    self:CheckStar()
end

function WBP_DungeonTempleFloat_C:OnSetTempleLimit(Limit, Value)
    self.Limit = Limit
    self.HB_Time:SetVisibility(ESlateVisibility.Visible)
    if Limit == "TIME" then
        self.TimeThreshold = Value
        self.CurTime = Value
        local Time = self:GetTimeStr(Value)
        self.Text_Time:SetText(Time)
    else
        self.Text_Time:SetText(Value)
    end
    if self.IsCountDown then
        self:InitTargetInfo()
    end
end

function WBP_DungeonTempleFloat_C:OnTempleScoreCollectChanged(Value)
    local Dif = Value - self.ScoreOrCollect
    -- self.InAnimationScore = self.InAnimationScore + Dif
    -- if self.InAnimationScore >= 0 then
    --     self.Text_ScoreNumChange:SetText("+" .. self.InAnimationScore)
    --     if not self:IsAnimationPlaying(self.Point_Add) then
    --         --self.Text_ScoreNum:SetText(self.ScoreOrCollect)
    --         if self:IsAnimationPlaying(self.Point_Minus) then
    --             self:UnbindAllFromAnimationFinished(self.Point_Minus)
    --             self:StopAnimation(self.Point_Minus)
    --         end
    --         self:PlayAnimation(self.Point_Add)
    --         self:BindToAnimationFinished(self.Point_Add, function()
    --             self.Text_ScoreNum:SetText(self.ScoreOrCollect)
    --             self.InAnimationScore = 0
    --         end)
    --     end
    -- elseif self.InAnimationScore < 0 then
    --     self.Text_ScoreNumChange:SetText("-" .. self.InAnimationScore)
    --     if not self:IsAnimationPlaying(self.Point_Minus) then
    --         --self.Text_ScoreNum:SetText(self.ScoreOrCollect)
    --         if self:IsAnimationPlaying(self.Point_Add) then
    --             self:UnbindAllFromAnimationFinished(self.Point_Add)
    --             self:StopAnimation(self.Point_Add)
    --         end
    --         self:PlayAnimation(self.Point_Minus)
    --         self:BindToAnimationFinished(self.Point_Minus, function()
    --             self.Text_ScoreNum:SetText(self.ScoreOrCollect)
    --             self.InAnimationScore = 0
    --         end)
    --     end
    -- end
    if Dif > 0 then
        self.Text_ScoreNumChange:SetText("+" .. Dif)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Point_Add)
    elseif Dif < 0 then
        self.Text_ScoreNumChange:SetText(Dif)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Point_Minus)
    end

    self.ScoreOrCollect = math.max(0, Value)
    self.Text_ScoreNum:SetText(self.ScoreOrCollect)

    self:CheckStar()
end

function WBP_DungeonTempleFloat_C:InitTargetInfo()
    local TextRule2 = ""
    if self.TempleInfo.SucRule == "Time" then
        TextRule2 = "SECONDS"
    elseif self.TempleInfo.SucRule == "CountDown" then
        TextRule2 = "SECONDS"
    elseif self.TempleInfo.SucRule == "Score" then
        TextRule2 = "SCORE"
        self.HB_ScoreNum:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_ScoreTitle:SetText(GText("UI_TEMPLE_TOTAL_" .. string.upper(self.TempleInfo.SucRule)) .. ": ")
    elseif self.TempleInfo.SucRule == "Collect" then
        TextRule2 = "COUNT"
        self.HB_ScoreNum:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_ScoreTitle:SetText(GText("UI_TEMPLE_TOTAL_" .. string.upper(self.TempleInfo.SucRule)) .. ": ")
    end
    if self.IsStarTemple then
        for i = 3, 1, -1 do
            local TextInfo = ""
            local Target = self.TempleInfo.RatingRange[i]
            if Target == 0 then
                TextInfo = GText("UI_TEMPLE_SUCRULE_ZERO")
            else
                if self.TempleInfo.SucRule == "CountDown" and self.TempleInfo.UIShowType and self.TempleInfo.UIShowType > 0 and self.TimeThreshold and self.TimeThreshold > 0 then
                    TextInfo = string.format(GText("UI_TEMPLE_SUCRULE_COUNTDOWN_" .. self.TempleInfo.UIShowType), self.TimeThreshold - Target)
                elseif TextRule2 == "SCORE" or TextRule2 == "COUNT" then
                    TextInfo = GText("UI_TEMPLE_SUCRULE_" .. string.upper(self.TempleInfo.SucRule)) .. Target
                else
                    TextInfo = GText("UI_TEMPLE_SUCRULE_" .. string.upper(self.TempleInfo.SucRule)) .. Target .. GText("UI_TEMPLE_MEASURE_" .. TextRule2)
                end
            end
            self["TempleItem_"..i]:SetTargetInfo(TextInfo)
            self["TempleItem_"..i]:PlayNormalAnimation()
        end
    end

    self.Text_TempleTitle:SetText(GText("UI_TEMPLE_" .. self.DungeonId))

    -- 在这里初次检查星级达成进度，因为有些神庙是从三星开始往下扣
    if self.IsStarTemple then
        if self.TempleInfo.SucRule == "Score" or self.TempleInfo.SucRule == "Collect" then
            for i = 1, 3 do
                if self.ScoreOrCollect >= self.TempleInfo.RatingRange[i] then
                    self.CurStar = i
                    self["TempleItem_"..i]:PlayStarAnimation()
                end
            end
        elseif self.TempleInfo.SucRule == "CountDown" then
            for i = 1, 3 do
                if self.CurTime >= self.TempleInfo.RatingRange[i] then
                    self.CurStar = i
                    self["TempleItem_"..i]:PlayStarAnimation()
                end
            end
        end
    end
end

function WBP_DungeonTempleFloat_C:CheckStar()
    if self.IsStarTemple then
        if self.TempleInfo.SucRule == "Score" or self.TempleInfo.SucRule == "Collect" then
            if self.CurStar > 0 and self.ScoreOrCollect < self.TempleInfo.RatingRange[self.CurStar] then
                self["TempleItem_"..self.CurStar]:PlayLossAnimation()
                self.CurStar = self.CurStar - 1
            elseif self.CurStar < 3 and self.ScoreOrCollect >= self.TempleInfo.RatingRange[self.CurStar+1] then
                self["TempleItem_"..self.CurStar + 1]:PlayStarAnimation()
                self.CurStar = self.CurStar + 1
            end
        elseif self.TempleInfo.SucRule == "CountDown" then
            if self.CurStar > 0 and self.CurTime < self.TempleInfo.RatingRange[self.CurStar] then
                self["TempleItem_"..self.CurStar]:PlayLossAnimation()
                self.CurStar = self.CurStar - 1
            elseif self.CurStar < 3 and self.CurTime >= self.TempleInfo.RatingRange[self.CurStar+1] then
                self["TempleItem_"..self.CurStar + 1]:PlayStarAnimation()
                self.CurStar = self.CurStar + 1
            end
        end
    end
end

function WBP_DungeonTempleFloat_C:OnTempleEnter()
    if self.IsStarTemple then
        if self.TempleInfo.SucRule == "Score" or self.TempleInfo.SucRule == "Collect" then
            for i = 1, 3 do
                if self.ScoreOrCollect >= self.TempleInfo.RatingRange[i] then
                    self.CurStar = i
                    self["TempleItem_"..i]:PlayStarAnimation()
                else
                    self["TempleItem_"..i]:PlayNormalAnimation()
                end
            end
        elseif self.TempleInfo.SucRule == "CountDown" then
            for i = 1, 3 do
                if self.CurTime >= self.TempleInfo.RatingRange[i] then
                    self.CurStar = i
                    self["TempleItem_"..i]:PlayStarAnimation()
                else
                    self["TempleItem_"..i]:PlayNormalAnimation()
                end
            end
        end
    end
    EMUIAnimationSubsystem:EMStopAnimation(self, self.Point_Add)
    EMUIAnimationSubsystem:EMStopAnimation(self, self.Point_Minus)
    EMUIAnimationSubsystem:EMStopAnimation(self, self.Time_Add)
    EMUIAnimationSubsystem:EMStopAnimation(self, self.Time_Minus)
end

return WBP_DungeonTempleFloat_C

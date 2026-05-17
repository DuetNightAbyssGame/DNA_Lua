require "UnLua"

---@type WBP_Activity_GuideWar_Progress
local M = Class("BluePrints.UI.BP_EMDungeonWidget_C")

local PROGRESS_BAR_WIDTH = 426  -- 进度条总长度
local WARNING_TIME = 10         -- 剩余多少秒开始警告
local StyleToVisibility = {     -- 在这里配置哪些Style需要显示本Widget
    EStandard = true,
    ELeftOnly = false,
    EClassic = false,
    EClassicTime = false,
    ELeftOnlyNumber = false,
}

function M:InitWidgetUI()
    local BattleMain = UIManager(self):GetUIObj("BattleMain")
    assert(BattleMain, "WBP_Activity_GuideWar_Progress 加载时拿不到BattleMain！")
    BattleMain.Pos_Abyss_CountDown_1:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    BattleMain.Pos_Abyss_CountDown_1:AddChildToOverlay(self)

    self:InitCountDown()
    self:UpdateGameStateOnRepInfo()
end

function M:UpdateGameStateOnRepInfo()
    self:OnRepBattleProgressInfo(self.GameState.BattleProgressInfo)
    self:OnRepBattleProgressNum(self.GameState.BattleProgressNum, self.GameState.BattleProgressInfo.MaxProgressNum)
end

function M:OnRepBattleProgressInfo(BattleProgressInfo)
    -- 根据Style来控制自己显隐
    local StyleName = EBattleProgressStyle:GetNameByValue(BattleProgressInfo.Style)
    local IsActive = StyleToVisibility[StyleName] or false
    self:SetWidgetActive(IsActive)
end

function M:InitUi()
    -- 初始化状态
    self.CurTimerHandle = ""

    -- 初始化监听
    self:InitListenEvent()

    -- 初始化进度显示
    local Progress = 0
    self.Bar_Progress:SetPercent(Progress)
    local IconEnemyX = PROGRESS_BAR_WIDTH * Progress - PROGRESS_BAR_WIDTH
    self.Icon_Enemy:SetRenderTranslation(FVector2D(IconEnemyX, 0))
    -- 默认隐藏
    -- self:SetWidgetActive(false) 放到OnRepBattleProgressInfo 根据Style来初始化

    self.IsSuccess = false

    -- 拿GameState
    self.GameState = UE4.UGameplayStatics.GetGameState(self)
end

function M:InitListenEvent()
    self:AddDispatcher(EventID.OnRepBattleProgressInfo, self, self.OnRepBattleProgressInfo)
    -- 监听击杀进度更新
    self:AddDispatcher(EventID.OnRepBattleProgressNum, self, self.OnRepBattleProgressNum)
end

-- 倒计时相关功能
function M:InitCountDown()
    self:InitUi()
    -- self:SetWidgetActive(true) 放到OnRepBattleProgressInfo 根据Style来初始化
    self.CurTimerHandle = Const.BattleProgressTimerHandle
    
    self:StopAnimation(self.Success)
    self:PlayAnimation(self.In)
end

-- 存疑 也许之后需要 先注释掉
-- function M:HideAbyssCountDown()
--     self:RemoveTimer("AbyssCountDownUI")
--     self:PlayAnimation(self.Success)
-- end

function M:UpdateCountDownProgress()
    local DisplayRemainTime = CommonUtils.GetClientTimerStructRemainTime(self.CurTimerHandle)
    if DisplayRemainTime < 0 then
        DisplayRemainTime = 0
    end

    -- 更新倒计时文本
    local currentTimeText = self:GetTimeStr(DisplayRemainTime)
    self.Text_Time:SetText(currentTimeText)
    
    -- 检查是否需要播放警告动画
    if DisplayRemainTime <= WARNING_TIME then
        -- 初始化上次显示的文本（如果不存在）
        if not self.LastWarningTimeText then
            self.LastWarningTimeText = currentTimeText
            AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning", nil, nil)
        end
        
        -- 如果显示的文本发生变化，播放音效
        if currentTimeText ~= self.LastWarningTimeText then
            AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning", nil, nil)
            self.LastWarningTimeText = currentTimeText
        end
        
        -- 播放警告动画（如果尚未播放）
        if not self:IsAnimationPlaying(self.Warning) then
            self:PlayAnimation(self.Warning, 0, 0, UE4.EUMGSequencePlayMode.Forward, 1, true)
        end
    elseif DisplayRemainTime <= 0 then
        -- 根据成功失败播放不同动画
        if self.IsSuccess then
            self:StopAnimation(self.Warning)
            self:PlayAnimation(self.Success)
        else
            self:PlayAnimation(self.Fail)
        end
    elseif DisplayRemainTime > WARNING_TIME then
        self:StopAnimation(self.Warning)
        -- 重置上次播放时间
        self.LastWarningTimeText = nil
    end

    -- 更新时间Icon位置
    local TimeProgress = (self.TotalTime - DisplayRemainTime) / self.TotalTime
    local IconTimeX = PROGRESS_BAR_WIDTH * TimeProgress
    self.Icon_Line:SetRenderTranslation(FVector2D(IconTimeX, 0))
    self.Icon_Clock:SetRenderTranslation(FVector2D(IconTimeX, 0))
end

-- 击杀进度相关功能
function M:OnRepBattleProgressNum(BattleProgressNum, MaxProgressNum)
    -- 更新进度条
    local Progress = BattleProgressNum / MaxProgressNum
    self.Bar_Progress:SetPercent(Progress)
    -- 更新敌人Icon位置
    local IconEnemyX = PROGRESS_BAR_WIDTH * Progress - PROGRESS_BAR_WIDTH
    self.Icon_Enemy:SetRenderTranslation(FVector2D(IconEnemyX, 0))

    -- 检查是否完成
    if BattleProgressNum >= MaxProgressNum then
        self.IsSuccess = true
        self:PlayAnimation(self.Success)
    end
end

function M:Destruct()
    self:RemoveTimer("UpdateCountDownProgress")
    -- 清理事件监听
    self:RemoveDispatcher(EventID.OnRepBattleProgressInfo)
    self:RemoveDispatcher(EventID.OnRepBattleProgressNum)
    self.Super.Destruct(self)
end

-- 设置本Widget是否启用，如果启用，显示且添加Timer；反之折叠且关闭Timer
function M:SetWidgetActive(IsActive)
    if IsActive then
        self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self:SetUpdateTimerActive(IsActive)
end

function M:SetUpdateTimerActive(IsActive)
    if IsActive then
        local Info = self.GameState.ClientTimerStruct:GetTimerInfo(self.CurTimerHandle)
        self.TotalTime = Info.Time
        self:AddTimer(0.1, self.UpdateCountDownProgress, true, 0, "UpdateCountDownProgress")
        AudioManager(self):PlayUISound(self, "event:/ui/activity/drama_challenge_progressbar_show", nil, nil)
    else
        self:RemoveTimer("UpdateCountDownProgress")
    end
end

return M

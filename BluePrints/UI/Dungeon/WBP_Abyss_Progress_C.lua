require "UnLua"

---@type WBP_Abyss_Progress_C
local WBP_Abyss_Progress_C = Class({"BluePrints.UI.BP_UIState_C"})

local PROGRESS_BAR_WIDTH = 426  -- 进度条总长度
local WARNING_TIME = 10         -- 剩余多少秒开始警告

function WBP_Abyss_Progress_C:OnLoaded(...)
    WBP_Abyss_Progress_C.Super.OnLoaded(self, ...)

    local BattleMain = UIManager(self):GetUIObj("BattleMain")
    assert(BattleMain, "WBP_Abyss_Progress_C 加载时拿不到BattleMain！")
    BattleMain.Pos_Abyss_CountDown_1:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    BattleMain.Pos_Abyss_CountDown_1:AddChildToOverlay(self)

    self:InitUi()
end

function WBP_Abyss_Progress_C:InitUi()
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
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)

    self.IsSuccess = false

    -- 拿GameState
    self.GameState = UE4.UGameplayStatics.GetGameState(self)
end

function WBP_Abyss_Progress_C:InitListenEvent()
    -- 监听击杀进度更新
    self:AddDispatcher(EventID.OnRepAbyssBattleCount, self, self.OnRepAbyssBattleCount)
end

-- 倒计时相关功能
function WBP_Abyss_Progress_C:ShowAbyssCountDown(TimerHandle)
    self:InitUi()
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.CurTimerHandle = TimerHandle
    -- 获取GameState
    if not self.GameState then
        return
    end
    
    -- 获取Timer信息
    local Info = self.GameState.ClientTimerStruct:GetTimerInfo(TimerHandle)
    self.TotalTime = Info.Time
    self:AddTimer(0.1, self.UpdateAbyssCountDownUI, true, 0, "AbyssCountDownUI")
    self:StopAnimation(self.Success)
    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/ui/activity/drama_challenge_progressbar_show", nil, nil)
end

function WBP_Abyss_Progress_C:HideAbyssCountDown(TimerHandle)
    if self.CurTimerHandle ~= TimerHandle then
        return
    end
    self:RemoveTimer("AbyssCountDownUI")
    --self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:PlayAnimation(self.Success)
end

function WBP_Abyss_Progress_C:UpdateAbyssCountDownUI()
    local DisplayRemainTime = CommonUtils.GetClientTimerStructRemainTime(self.CurTimerHandle)
    if DisplayRemainTime < 0 then
        DisplayRemainTime = 0
    end

    -- 更新倒计时文本
    local currentTimeText = self:GetTimeStr_Cpp(DisplayRemainTime)
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
function WBP_Abyss_Progress_C:OnRepAbyssBattleCount()
    if not self.GameState then
        return
    end
    local MaxNum = self.GameState.AbyssBattleMaxNum or 1
    local Count = self.GameState.AbyssBattleCount or 0
    
    -- 更新进度条
    local Progress = Count / MaxNum
    self.Bar_Progress:SetPercent(Progress)
    -- 更新敌人Icon位置
    local IconEnemyX = PROGRESS_BAR_WIDTH * Progress - PROGRESS_BAR_WIDTH
    self.Icon_Enemy:SetRenderTranslation(FVector2D(IconEnemyX, 0))

    -- 检查是否完成
    if Count >= MaxNum then
        self.IsSuccess = true
        self:PlayAnimation(self.Success)
    end
end

function WBP_Abyss_Progress_C:Destruct()
    self:RemoveTimer("AbyssCountDownUI")
    -- 清理事件监听
    self:RemoveDispatcher(EventID.OnRepAbyssBattleCount)
    self.Super.Destruct(self)
end

return WBP_Abyss_Progress_C
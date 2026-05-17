--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_DeputeWeekly_Hud_ClueProgressItem_C
local M = Class("BluePrints.UI.BP_UIState_C")
local TaskUtils = require("BluePrints.UI.TaskPanel.TaskUtils")

function M:Construct()
    self.TotalBarLength = 320   -- 写死，但其实可以开放给蓝图配置

    -- 提前声明一下，免得因为nil出trace
    self.RageValueStages = {100}
    self.MaxRangeValue = 100
    self.DestructionPoints = {}
    self.CurDisplayPercent = 0                 -- 当前【显示】的进度百分比（可能并非真实进度，考虑到未来可能需要做进度条分帧上涨动画）
    self.FinishPercent = 1              -- 进度达到FinishPercent，就该隐藏了。FinishPercent可能小于1（即玩家提前发现了主管）
    self.IsShowSideTaskBar = false
    --self.GuideSupervisorByRageCount = 0  -- 迭代后已废弃  -- 通过RageValue上涨发现的主管数量. 这个数量 + 主动发现 > 已死亡数量，显示小任务栏

    -- 交互要求进度分帧“顺滑”上涨
    self.TickInterval = 0.1
    self.ProgressUpdateSpeed = 10  -- 进度条上涨的速度，单位是百分比/秒. 例: 10表示每秒上涨10%
    self.RealRageValue = 0         -- 真实的RageValue，和GameState的RageValue保持一致，但上限锁在self.MaxRangeValue
    self.DisplayRageValue = 0      -- 显示的RageValue，如果和RealRageValue不一致，会分帧更新
end

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)

    local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
    if BattleMainUI then
        self:AddTaskToOverlay(BattleMainUI)
    end

    self:InitDungeonInfo()
    self:InitListenEvent()

    self:InitDisplay()
    --self:InitBuffList()

    self:PlayAnimation(self.In)

    self.IsInit = true
end

function M:AddTaskToOverlay(BattleMainUI)
	BattleMainUI.Pos_Weekly:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	BattleMainUI.Pos_Weekly:AddChildToOverlay(self)
end

function M:InitDungeonInfo()
    self.DungeonId = GameState(self).DungeonId
    local DungeonData = DataMgr.Synthesis[self.DungeonId]
    if not DungeonData then
        GameState(self):ShowDungeonError("SynthesisComponent:Client 当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id："..self.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
        return
    end
    self.RageValueStages = DungeonData.RageValueStages or {100}
    self.MaxRangeValue = self.RageValueStages[#self.RageValueStages]
end

function M:InitDisplay()
    local GameState = GameState(self)
    self:SetTotalProgressPercent(1)     -- 先设为满，后续可能更新
    self:SetCurProgressPercent(0)       -- 先设为0，后续可能更新
    self.Text_Title:SetText(GText("DUNGEON_SYNTHESIS_101"))
    self:SetProgressFXVisibility(false)

    -- 点位相关
    self:InitDestructionPoints()
    self:UpdateDestructionPoints(GameState.GuideSupervisorEids, GameState.DeadSupervisorEids)

    self:UpdateRageValue(GameState.RageValue)
    GameState:UpdateSynthesisDestructionTaskProgress()      -- 联机刚进副本不会触发Onrep 这里补一下

    self:AddTimer(self.TickInterval, self.TickUpdateProgress, true)
end

function M:InitListenEvent()
    --self.Super.InitListenEvent(self)
    self:AddDispatcher(EventID.OnRepSynthesisRageValue, self, self.UpdateRageValue)
    self:AddDispatcher(EventID.OnRepGuideSupervisorEids, self, self.UpdateDestructionPoints)
    self:AddDispatcher(EventID.OnRepDeadSupervisorEids, self, self.UpdateDestructionPoints)
end

function M:UpdateRageValue(RageValue)
    if RageValue > self.MaxRangeValue then
        self.RealRageValue = self.MaxRangeValue
    else
        self.RealRageValue = RageValue
    end
end

function M:TickUpdateProgress(IsForceUpdate)
    if (not IsForceUpdate) and self.DisplayRageValue == self.RealRageValue then
        self:SetProgressFXVisibility(false)
        return
    end

    self:SetProgressFXVisibility(true)

    local PercentUpdateThisTick = self.ProgressUpdateSpeed * self.TickInterval / 100                        -- 每次Tick上涨的最大百分比（步长）
    local TargetPercent = self.DisplayRageValue / self.MaxRangeValue                                        -- 默认为当前百分比
    local IsSetToReal = false                                                                               -- 防止浮点和整数比较时的精度问题
    if self.DisplayRageValue < self.RealRageValue then
        if self.DisplayRageValue + PercentUpdateThisTick * self.MaxRangeValue < self.RealRageValue then     -- 如果这一步更新后仍然小于真实值
            TargetPercent = TargetPercent + PercentUpdateThisTick                                           -- 更新百分比为当前百分比 + 步长
        else
            IsSetToReal = true                                                                              -- 否则，直接设为真实百分比
        end
    end
    if self.DisplayRageValue > self.RealRageValue then
        if self.DisplayRageValue - PercentUpdateThisTick * self.MaxRangeValue > self.RealRageValue then
            TargetPercent = TargetPercent - PercentUpdateThisTick
        else
            IsSetToReal = true
        end
    end

    if IsSetToReal then
        self.DisplayRageValue = self.RealRageValue
        TargetPercent = self.RealRageValue / self.MaxRangeValue
    else
        self.DisplayRageValue = TargetPercent * self.MaxRangeValue
    end

    -- 上面是更新逻辑
    -- 下面是显示逻辑
    self:SetCurProgressPercent(TargetPercent)

    -- 所有点的状态，全部改为受 GuideSupervisorEids 和 DeadSupervisorEids 的OnRep管理
    -- for _, DestructionPoint in pairs(self.DestructionPoints) do
    --     if not DestructionPoint.IsFinalHide then
    --         if self.DisplayRageValue >= DestructionPoint.RageValue then
    --             DestructionPoint:SetRed()
    --             DestructionPoint:PlayHideAnimation()
    --             self.GuideSupervisorByRageCount = self.GuideSupervisorByRageCount + 1
    --             --self:ShowSideTaskBar(true)
    --             self:UpdateSideTaskBar(nil, nil)
    --         end
    --     end
    -- end

    -- 现在要所有主管死亡才隐藏
    -- if self.IsShowOut then
    --     return
    -- end
    -- if TargetPercent >= self.FinishPercent then
    --     self:ShowOut()
    -- end

    self:ShowProgressFXAtPercent(TargetPercent)
end

function M:ShowOut()
    self:AddTimer(1, function()
        self:PlayAnimation(self.Out)
    end)
    self:ShowSideTaskBar(false)
    self.IsShowOut = true           -- 只播一次out
end

function M:InitDestructionPoints()
    self.Group_BottomAnchor:ClearChildren()
    local TotalPointNum = #self.RageValueStages
    self.DestructionPoints = {}
    for i = 1, TotalPointNum do
        local DestructionPoint = self:CreateWidgetNew("SynthesisDestructionPoint")
        self.DestructionPoints[i] = DestructionPoint
        self.Group_BottomAnchor:AddChild(DestructionPoint)
        local Percent = self.RageValueStages[i] / self.MaxRangeValue
        self:SetDestructionPointPosByPercent(DestructionPoint, Percent)
        DestructionPoint:InitItem(i, self.RageValueStages[i])
    end
end

function M:SetDestructionPointPosByPercent(DestructionPoint, Percent)
    local PosX = self.TotalBarLength * Percent
    local Pos = FVector2D(PosX,0)
    DestructionPoint:SetRenderTranslation(Pos)
end

function M:UpdateDestructionPoints(GuideSupervisorEids, DeadSupervisorEids)
    for i, GuideEid in pairs(GuideSupervisorEids) do
        local DestructionPoint = self.DestructionPoints[i]
        local IsDead = DeadSupervisorEids:Contains(GuideEid)
        if IsDead then
            DestructionPoint:SetComplete()
        else
            DestructionPoint:SetRed()    -- Point内部处理了不会重复播   
        end
    end

    if self.IsShowOut then
        return
    end
    -- 所有主管死亡，该隐藏了
    if DeadSupervisorEids:Num() >= #self.RageValueStages then
        DebugPrint("SynthesisComponent: ShowOut 击杀所有主管")
        self:ShowOut()
    end

    self:UpdateSideTaskBar(GuideSupervisorEids, DeadSupervisorEids)
end

-- 交互大改显示逻辑 直接重新写了
-- function M:UpdateDestructionPoints(GuideSupervisorEids, DeadSupervisorEids)
--     local GuideSupervisorNum = GuideSupervisorEids:Num()
--     if GuideSupervisorNum == 0 then
--         return
--     end

--     -- 别问我为什么代码会变成这样 问交互
--     -- 先播Highlight动画
--     local AllPointHideEffects = function(HighlightPoint)
--         -- 播完后隐藏
--         HighlightPoint:SetHide()

--         -- 隔一段时间，隐藏其他点
--         self:AddTimer(0.5, function()

--             -- 从后往前，有几个主动发现的，就隐藏几个
--             for i = 1, GuideSupervisorNum do
--                 local index = #self.DestructionPoints - i + 1
--                 local DestructionPoint = self.DestructionPoints[index]
--                 DestructionPoint:SetHide()
--             end

--             self:AddTimer(0.5, function()
--                 -- 再隔一段时间，显示刚刚Highlight的点
--                 HighlightPoint:SetNormal()

--                 -- 并且禁用态长度
--                 self:SetTotalProgressPercent(1 - GuideSupervisorNum / #self.RageValueStages)

--                 -- 强制更新一次进度条, 可能隐藏
--                 self:TickUpdateProgress(true)

--             end)

--         end)

--     end

--     -- 下一个即将显示的，播Highlight动画
--     local HighlightIndex = self:GetShownByRageValuePointNum() + 1
--     local HighlightDestructionPoint = self.DestructionPoints[HighlightIndex]
--     if HighlightDestructionPoint then
--         HighlightDestructionPoint:PlayHighlightAnim(AllPointHideEffects)
--     end

--     if self.IsShowOut then
--         return
--     end
--     if self.CurDisplayPercent >= self.FinishPercent then
--         self:ShowOut()
--     end

--     --self:ShowSideTaskBar(true)
--     self:UpdateSideTaskBar(GuideSupervisorEids, DeadSupervisorEids)
-- end

function M:GetShownByRageValuePointNum()
    local Count = 0
    for _, DestructionPoint in pairs(self.DestructionPoints) do
        if DestructionPoint.IsFinalHide then
            Count = Count + 1
        else
            return Count
        end
    end
    return Count
end

-- 显示小任务栏的条件
-- 主动发现数量 > 已死亡数量
-- 且 发现数量 < 总数
function M:UpdateSideTaskBar(GuideSupervisorEids, DeadSupervisorEids)
    local GuideSupervisorNum = (GuideSupervisorEids or GameState(self).GuideSupervisorEids):Num()
    local DeadSupervisorNum = (DeadSupervisorEids or GameState(self).DeadSupervisorEids):Num()
    local SupervisorTotalNum = #self.RageValueStages

    local IsShow = (GuideSupervisorNum > DeadSupervisorNum) and (GuideSupervisorNum < SupervisorTotalNum)
    self:ShowSideTaskBar(IsShow)
end

function M:SetCurProgressPercent(Percent)
    self.CurDisplayPercent = Percent
    self.Progress_01:SetPercent(Percent)
end

function M:SetTotalProgressPercent(Percent)
    self.FinishPercent = Percent
    self.Progress_02:SetPercent(Percent)
    self.Progress_03:SetPercent(1 - Percent)
end

function M:ShowProgressFXAtPercent(Percent)
    if Percent > 1 then
        Percent = 1
    end
    self:SetProgressFXVisibility(true)
    local PosX = self.TotalBarLength * (Percent - 0.5)  -- 这个特效是中对齐的
    local Pos = FVector2D(PosX,0)
    self.FX_Progress:SetRenderTranslation(Pos)
    self:AddTimer(self.TickInterval, function()
        self:SetProgressFXVisibility(false)
    end, false, 0, "ProgressFXTimer")

    AudioManager(self):PlayUISound(self, "event:/ui/common/week_level_progress_add", nil, nil)
end

function M:SetProgressFXVisibility(IsVisible)
    if IsVisible then
        self.FX_Progress:SetVisibility(UE4.ESlateVisibility.Visible)
    else
        self.FX_Progress:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:ShowSideTaskBar(IsShow)
    local TaskBar = TaskUtils:GetTaskBarWidget()
    if not TaskBar then
        return
    end
    if self.IsShowSideTaskBar == IsShow then
        return
    end
    if self.IsShowOut then
        return
    end

    if IsShow then
        TaskBar:AddSynthesisOptionalTask(GText("DUNGEON_SYNTHESIS_114"), "SpecialEnemy")
    else
        TaskBar:RemoveOptionalTask()
    end
    self.IsShowSideTaskBar = IsShow
end

-- function M:InitBuffList()
--     self.BuffList = self:CreateWidgetNew("SynthesisBuffList")
--     self.BuffList:Init()
-- end

-- function M:RemoveBuffList()
--     self.BuffList:RemoveFromParent()
-- end

-- 玩家跑图发现主管时，进度增加提示
function M:ShowDiscoverSupervisorToast(Percent)
    -- 策划又不要这个percent了 =.=
    self.Text_Title_1:SetText(GText("DUNGEON_SYNTHESIS_132"))
    self:PlayAnimation(self.Up)

    AudioManager(self):PlayUISound(self, "event:/ui/common/week_level_target_update", nil, nil)
end

return M

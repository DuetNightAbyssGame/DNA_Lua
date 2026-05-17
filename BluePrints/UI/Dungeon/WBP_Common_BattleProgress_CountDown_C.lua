--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_BattleProgress_CountDown
local M = Class("BluePrints.UI.BP_EMDungeonWidget_C")

local StyleToVisibility = {     -- 在这里配置哪些Style需要显示本Widget
    EStandard = false,
    ELeftOnly = false,
    EClassic = true,
    EClassicTime = true,
    ELeftOnlyNumber = false,
}

function M:InitWidgetUI()
    local BattleMain = UIManager(self):GetUIObj("BattleMain")
    assert(BattleMain, "加载时拿不到BattleMain！")
    BattleMain.Pos_Abyss_CountDown:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    BattleMain.Pos_Abyss_CountDown:AddChildToOverlay(self)

    self.Panel_time:SetVisibility(ESlateVisibility.Collapsed)

    self.GameState = UE4.UGameplayStatics.GetGameState(self)
    self:InitListenEvent()
    self:OnRepBattleProgressInfo(self.GameState.BattleProgressInfo)

    self.CurTimerHandle = Const.BattleProgressTimerHandle
end

function M:InitListenEvent()
    self:AddDispatcher(EventID.OnRepBattleProgressInfo, self, self.OnRepBattleProgressInfo)
end

function M:OnRepBattleProgressInfo(BattleProgressInfo)
    -- 根据Style来控制自己显隐
    local StyleName = EBattleProgressStyle:GetNameByValue(BattleProgressInfo.Style)
    local IsActive = StyleToVisibility[StyleName] or false
    self:SetWidgetActive(IsActive)

    -- 更新文本
    local Text = BattleProgressInfo.DisplayText:GetRef(2) or ""
    self.TaskTitle:SetText(GText(Text))
end

function M:SetWidgetActive(IsActive)
    if IsActive then
        self:ShowCountDown()
    else
        self:HideCountDown()
    end
end

function M:ShowCountDown()
    self.Panel_time:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:AddTimer(0.1, self.UpdateCountDownUI, true, 0, "UpdateCountDown")
    self:PlayAnimation(self.FadeIn)
end

function M:HideCountDown()
    self.Panel_time:SetVisibility(ESlateVisibility.Collapsed)
    self:RemoveTimer("UpdateCountDown")
    self:PlayAnimation(self.Out)
end

function M:UpdateCountDownUI()
    local RawDisplayRemainTime = CommonUtils.GetClientTimerStructRemainTime(self.CurTimerHandle)
    local DisplayRemainTime = math.floor(RawDisplayRemainTime)
    if DisplayRemainTime < 0 then
        DisplayRemainTime = 0
    end
    if self.LastDisplayRemainTime == DisplayRemainTime then
        return
    end
    -- 改通用了 先注释掉吧
    -- if self.CurTimerHandle == "AbyssNextRoom" and self.LastDisplayRemainTime then      -- 只有进入下个房间前需要；战斗时（目前只有boss）不需要   音效要求弹出的时候不能连播两次，第一次跳的时候干脆不播得了 = =  
    --     AudioManager(self):PlayUISound(self, "event:/ui/common/battle_countdown", nil, nil)
    -- end
    self.LastDisplayRemainTime = DisplayRemainTime

    self.TextBlock_LeftTime:SetText(self:GetTimeStr(DisplayRemainTime))
end


return M

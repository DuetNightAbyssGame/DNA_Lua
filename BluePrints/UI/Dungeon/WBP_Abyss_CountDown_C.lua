--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Abyss_CountDown_C
local WBP_Abyss_CountDown_C = Class({"BluePrints.UI.BP_UIState_C"})

function WBP_Abyss_CountDown_C:OnLoaded(...)
    WBP_Abyss_CountDown_C.Super.OnLoaded(self, ...)

    local BattleMain = UIManager(self):GetUIObj("BattleMain")
    assert(BattleMain, "WBP_Abyss_CountDown_C 加载时拿不到BattleMain！")
    BattleMain.Pos_Abyss_CountDown:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    BattleMain.Pos_Abyss_CountDown:AddChildToOverlay(self)

    self.Panel_time:SetVisibility(ESlateVisibility.Collapsed)

    self.CurTimerHandle = ""

    self.TimerHandle2TextMap =
    {
        AbyssBattle = "UI_Abyss_BattleCountDown",
        AbyssNextRoom = "UI_Abyss_NextRoomCountdown",
    }
end

function WBP_Abyss_CountDown_C:ShowAbyssCountDown(TimerHandle)
    self.CurTimerHandle = TimerHandle
    self.TaskTitle:SetText(GText(self.TimerHandle2TextMap[self.CurTimerHandle]))
    self.Panel_time:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:AddTimer(0.1, self.UpdateAbyssCountDownUI, true, 0, "AbyssCountDownUI")
    self:PlayAnimation(self.FadeIn)
end

function WBP_Abyss_CountDown_C:HideAbyssCountDown(TimerHandle)
    if self.CurTimerHandle ~= TimerHandle then
        return
    end
    self.Panel_time:SetVisibility(ESlateVisibility.Collapsed)
    self:RemoveTimer("AbyssCountDownUI")
    self:PlayAnimation(self.Out)
end

function WBP_Abyss_CountDown_C:UpdateAbyssCountDownUI()
    local RawDisplayRemainTime = CommonUtils.GetClientTimerStructRemainTime(self.CurTimerHandle)
    local DisplayRemainTime = math.floor(RawDisplayRemainTime)
    if DisplayRemainTime < 0 then
        DisplayRemainTime = 0
    end
    if self.LastDisplayRemainTime == DisplayRemainTime then
        return
    end
    if self.CurTimerHandle == "AbyssNextRoom" and self.LastDisplayRemainTime then      -- 只有进入下个房间前需要；战斗时（目前只有boss）不需要   音效要求弹出的时候不能连播两次，第一次跳的时候干脆不播得了 = =  
        AudioManager(self):PlayUISound(self, "event:/ui/common/battle_countdown", nil, nil)
    end
    self.LastDisplayRemainTime = DisplayRemainTime

    self.TextBlock_LeftTime:SetText(self:GetTimeStr_Cpp(DisplayRemainTime))
end


return WBP_Abyss_CountDown_C

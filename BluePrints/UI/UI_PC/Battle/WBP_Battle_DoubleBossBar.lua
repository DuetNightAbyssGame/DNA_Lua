--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_DoubleBossBar_P_C
local M = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

function M:OnLoaded(...)
    self.Super.OnLoaded(self,...)
    self.ActiveBossUINum = 0
    self.Boss_1:SetVisibility(ESlateVisibility.Collapsed)
    self.Boss_2:SetVisibility(ESlateVisibility.Collapsed)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    local BattleMain = UIManager and UIManager:GetUIObj("BattleMain")
    if BattleMain and BattleMain.Pos_Boss_DoubleLifeBar then
        BattleMain.Pos_Boss_DoubleLifeBar:AddChildToOverlay(self)
    end
    self.IsPlayingSe = false
    EventManager:AddEvent(EventID.DoubleBossChargeTextUpdate, self, self.PlayEnergyUpdateSe)
end

function M:Destruct()
    M.Super.Destruct(self)
    EventManager:RemoveEvent(EventID.DoubleBossChargeTextUpdate, self)
end

function M:OnBossDead(Index)
    self.ActiveBossUINum = self.ActiveBossUINum - 1
    if (self.ActiveBossUINum <= 0) then
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
		local UIManager = GameInstance:GetGameUIManager()
        if UIManager then
            UIManager:UnLoadUINew("DoubleBossBlood")
        end
    end
end

function M:ActiveBossUI(Index)
    self.ActiveBossUINum = self.ActiveBossUINum + 1
end

function M:PlayEnergyUpdateSe(IsWarning)
    if self.IsPlayingSe or self.ActiveBossUINum<=0 then
        return
    end
    self.IsPlayingSe = true
    self:AddDelayFrameFunc(function()
        if IsWarning then
            AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning_short_reverb", nil, nil)
        else
            AudioManager(self):PlayUISound(self, "event:/ui/common/tick_beep_01_normal", nil, nil)
        end
        self.IsPlayingSe = false
    end, 1)
end

return M

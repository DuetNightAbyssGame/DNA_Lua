--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_DeputeWeekly02_Hud_Health_C
local M = Class("BluePrints.UI.BP_EMDungeonWidget_C")

function M:Construct()
    EventManager:AddEvent(EventID.OnEndChargeGame, self, self.OnEndChargeGame)
    self.IsStartChargeGame = false
end

function M:InitDungeonWidget(DungeonId)
    M.Super.InitDungeonWidget(self)
    self:AddToBattleMain("Pos_Weekly_Buff","Overlay")
    local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
    if not BattleMainUI then
        return
    end
    BattleMainUI.Pos_Weekly_Buff:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:OnStartChargeGame(DungeonId)
end

function M:InitList(DungeonId)
    local ChargeCreatorId = DataMgr.SynthesisII[DungeonId].ChargeCreatorId
    for i = 1, #ChargeCreatorId do
        local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
        ItemContent.StaticCreatorId = ChargeCreatorId[i]
        ItemContent.Index = i
        self.ListView_Buff:AddItem(ItemContent)
    end
end

function M:OnStartChargeGame(DungeonId)
    if self.IsStartChargeGame then
        return
    end
    self.IsStartChargeGame = true
    self:InitList(DungeonId)
    local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
    if not BattleMainUI then
        return
    end
    BattleMainUI.Pos_Weekly_Buff:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function M:OnEndChargeGame()
    local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
    if not BattleMainUI then
        return
    end
    
    BattleMainUI.Pos_Weekly_Buff:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

return M

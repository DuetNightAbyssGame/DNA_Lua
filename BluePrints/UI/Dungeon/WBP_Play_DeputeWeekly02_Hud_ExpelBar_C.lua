--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_DeputeWeekly02_Hud_ExpelBar_C
local M =Class("BluePrints.UI.BP_EMDungeonWidget_C")

function M:InitDungeonWidget(FortDefenceTargetNum)
    M.Super.InitDungeonWidget(self)
    local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
    if not BattleMainUI then
        return false
    end

    BattleMainUI["Pos_Weekly"]:ClearChildren()
    self:AddToBattleMain("Pos_Weekly","Overlay")
    self.FortDefenceTargetNum = FortDefenceTargetNum
end

function M:UpdateProgress(Progress)
    self.Progress = Progress
    
    self.Text_Expel:SetText(string.format(GText("DUNGEON_SYNTHESIS2_114"), self.Progress, self.FortDefenceTargetNum))

    local Material = self.Bar_Percent:GetDynamicMaterial()
    if Material then
        Material:SetScalarParameterValue("Percent", self.Progress / self.FortDefenceTargetNum)
    end
end

function M:SetFortDefenceTargetNum(FortDefenceTargetNum)
    self.FortDefenceTargetNum = FortDefenceTargetNum
end

return M

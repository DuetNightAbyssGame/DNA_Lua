--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_BattleHUD_Score_C
local M =Class("BluePrints.UI.BP_EMDungeonWidget_C")

function M:InitDungeonWidget()
    M.Super.InitDungeonWidget(self)
    self:AddToBattleMain("Pos_GuildWarScore","SizeBox")

    self.Text_ScoreTitle01:SetText(GText("UI_Raid_Score"))
    self.Text_ScoreTitle02:SetText(GText("UI_Raid_MaxScore"))

    self:OnRepRaidScore(0)
    local DungeonId = GameState(self).DungeonId
    local MaxScore = DataMgr.RaidDungeon[DungeonId].BaseRaidPoint
    self.Text_Score_Max:SetText(tostring(MaxScore))

    self:PlayInAnimation()
end

function M:InitListenEvent()
    M.Super.InitListenEvent(self)
    self:AddDispatcher(EventID.OnRepRaidScore, self, self.OnRepRaidScore)
end

function M:OnRepRaidScore(CurScore)
    if not CurScore then return end

    self.Text_Score_Now:SetText(tostring(CurScore))
    self:TryPlayUpAnim(CurScore)
end

function M:TryPlayUpAnim(CurScore)
    if self.LastScore == nil then
        self.LastScore = CurScore
        return
    end

    if CurScore > self.LastScore then
        self.LastScore = CurScore
        self:PlayAnimation(self.Up)
        AudioManager(self):PlayUISound(self, "event:/ui/activity/gerengonghuizhan_score_add", nil, nil)
    end
end

function M:PlayInAnimation()
    local LoadingUI = GWorld.GameInstance:GetLoadingUI()
	if LoadingUI then
		EventManager:AddEvent(EventID.CloseLoading, self, function()
			EventManager:RemoveEvent(EventID.CloseLoading, self)
			self:PlayAnimation(self.In)
		end)
	else
		self:PlayAnimation(self.In)
	end
end

return M

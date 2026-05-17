
local Component = {}

function Component:QueryRankList(RankId)
	self.logger.debug("QueryRankList", RankId)
	if not RankId then
		RankId = 1
	end
	self:CallServerMethod("QueryRankList", RankId)
end

function Component:OnQueryRankList(RankId, RankListInfo)
	self.logger.debug("OnQueryRankList", RankId)
	-- PrintTable(RankListInfo, 10)
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	local wbp_rankpanel = UIManager:LoadUI("/Game/BluePrints/UI/Rank/WBP_RankPanel.WBP_RankPanel","RankPanel",UIConst.ZORDER_FOR_ZERO, RankListInfo)
end

return Component
require "UnLua"

local BP_SabotageProComponent_C = Class({
	"BluePrints.Common.TimerMgr",
})

--------------------GameMode 流程&事件相关------------------------

function BP_SabotageProComponent_C:InitSabotageProComponent()
	self.GameMode = self:GetOwner()

	self.SabotageProInfo = DataMgr.SabotagePro[self.GameMode.DungeonId]
	if not self.SabotageProInfo then
		GameState(self):ShowDungeonError("SabotageProComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id："..self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end

	self.MonsterSpawnId1:Clear()
	for _, SpawnId in pairs(self.SabotageProInfo.MonsterSpawnIds or {}) do
		self.MonsterSpawnId1:Add(SpawnId)
	end

	self.TimeLimit = self.SabotageProInfo.TimeLimit or -1

	DebugPrint("BP_SabotageProComponent_C InitSabotageProComponent")
end

function BP_SabotageProComponent_C:InitSabotageProBaseInfo()

end


function BP_SabotageProComponent_C:OnStaticCreatorEvent(EventName, Eid, UnitId, UnitType, CreatorId)
	if EventName == "SabotageMonsterGuide" then
		DebugPrint("BP_SabotageProComponent_C OnStaticCreatorEvent Eid", Eid, "UnitId", UnitId, CreatorId)
	end
end

function BP_SabotageProComponent_C:OnMiniGameSuccess()
	if self.TimeLimit < 0 then
		return
	end

	self.GameMode:BpAddTimer("SabotageProLimitTimer", self.TimeLimit, false, Const.GameModeEventServerClient)
end
-----------------------------------------------------------------

return BP_SabotageProComponent_C


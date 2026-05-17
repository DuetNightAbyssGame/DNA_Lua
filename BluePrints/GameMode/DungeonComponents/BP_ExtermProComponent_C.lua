require "UnLua"

local BP_ExtermProComponent_C = Class({
	"BluePrints.GameMode.DungeonComponents.BP_ExterminateComponent_C",
})

function BP_ExtermProComponent_C:InitExtermProComponent()
	-- 先这么写，如果歼灭和歼灭pro区别很大，就单独写初始化逻辑，不写父类里了
	self:InitExterminateBaseComponent()

	if self.ExterminateInfo then
		self.OnInitSpawnRule:Clear()
		for _, SpawnId in pairs(self.ExterminateInfo.OnInitSpawnRule or {}) do
			self.OnInitSpawnRule:Add(SpawnId)
		end
	else
		GameState(self):ShowDungeonError("ExtermProComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id："..self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
	end
end

function BP_ExtermProComponent_C:InitExtermProBaseInfo()
	self:InitGuideUpdateTimerLogic()
end

function BP_ExtermProComponent_C:GetDataMgrInfo()
	return DataMgr.ExtermPro[self.GameMode.DungeonId]
end

function BP_ExtermProComponent_C:OnEliteNumClear()
	self.GameMode:TriggerGameModeEvent("Event_OnEliteNumClear")
end

return BP_ExtermProComponent_C
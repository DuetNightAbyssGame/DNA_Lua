--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
-- require "UnLua"
---@type BP_DanmakuCreature_C
local BP_DanmakuCreature_C = Class(
	--"BluePrints.Combat.Components.EffectSourceInterface"
)

BP_DanmakuCreature_C._components = {
	--"BluePrints.Combat.Components.ActorTypeComponent",
}

-- function BP_DanmakuCreature_C:Initialize(Initializer)
-- end

--function BP_DanmakuCreature_C:ReceiveBeginPlay()
--	
--end

function BP_DanmakuCreature_C:InitVars()
	local CreatureInfo = DataMgr.DanmakuCreature[self.CreatureId]
	if CreatureInfo and CreatureInfo.Vars then
		for VarName, Value in pairs(CreatureInfo.Vars) do
			self[VarName] = Value
		end
	end
end

-- function BP_DanmakuCreature_C:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
-- 	self.Overridden.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
-- end

function BP_DanmakuCreature_C:OnBreakCountDown()
	self.Overridden.OnBreakCountDown(self)
end

return BP_DanmakuCreature_C

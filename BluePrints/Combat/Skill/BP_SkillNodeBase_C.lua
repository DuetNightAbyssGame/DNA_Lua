
require "UnLua"

local BP_SkillNodeBase_C = Class({
	"BluePrints.Common.TimerMgr",
})

-- @zyh 已全部移到C++
function BP_SkillNodeBase_C:Initialize(Initializer)
end

-- 已移到C++
--function BP_SkillNodeBase_C:InitSkillEffects(TableData)
--	 if not TableData.SkillNodeEffects then
--		return
--	end
--	for _, EffectId in ipairs(TableData.SkillNodeEffects)do
--		local EffectInfo = DataMgr.SkillEffects[EffectId]
--		if EffectInfo.EffectExecuteTiming then
--			if EffectInfo.EffectExecuteTiming == "Enter" then
--				if not self.TasksWhenEnter then
--					self.TasksWhenEnter = {}
--				end
--				table.insert(self.TasksWhenEnter, EffectId)
--			elseif EffectInfo.EffectExecuteTiming == "Leave" then
--				if not self.TasksWhenLeave then
--					self.TasksWhenLeave = {}
--				end
--				table.insert(self.TasksWhenLeave, EffectId)
--			end
--		end
--		local NotifyNames = EffectInfo.NotifyName
--		if NotifyNames then
--			for _, NotifyName in ipairs(NotifyNames)do
--				local list = self.NotifyTasks[NotifyName]
--				if list == nil then
--					list = {}
--				end
--				table.insert(list, EffectId)
--				self.NotifyTasks[NotifyName] = list
--			end
--		end
--	end
--end


-- function BP_SkillNodeBase_C:GetCanExtractZVelocity()
-- 	return self.CanExtractZVelocity
-- end

return BP_SkillNodeBase_C

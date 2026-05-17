require "DataMgr"

local Component = {}

function Component:JudgeAndOrNot(Condition, CheckResult, Source, Targets,TraceInfo)
    if Condition.Not ~= nil then
        -- 非
        CheckResult = not CheckResult
    end

    if Condition.And ~= nil then
        -- 与
        for _, V in pairs(Condition.And) do
            if CheckResult == false then
                break
            end
            CheckResult = CheckResult and self:CheckConditionNew(V, Source, Targets,TraceInfo)
        end
    end

    if Condition.Or ~= nil then
        -- 或
        for _, V in pairs(Condition.Or) do
            if CheckResult == true then
                break
            end
            CheckResult = CheckResult or self:CheckConditionNew(V, Source, Targets,TraceInfo)
        end
    end
    return CheckResult
end

function Component:CheckCondition_Lua(ConditionId, Source, Targets, ExtraVars)
    local ret = self.Overridden.CheckCondition(self, ConditionId, Source, Targets)
    if not ret then
        return false
    end
    local _Data = DataMgr.CombatCondition[ConditionId]
    assert(_Data, "CombatCondition【" .. tostring(ConditionId) .. "】不存在!")

    if _Data.FuncName then
        ret = self.ConditionComponent:CheckCondition_Lua(ConditionId, Source, Targets, ExtraVars)
    end

    return self:JudgeAndOrNot(_Data, ret, Source, Targets)
end

-- function Component:CheckNotifyCondition(EffectId, ConditionId, Source)
-- 	local ret = self.Overridden.CheckNotifyCondition(self, EffectId, ConditionId, Source)
-- 	if not ret then
-- 		return false
-- 	end
-- 	local _Data = DataMgr.CombatCondition[ConditionId]
-- 	if not _Data then
-- 		return true
-- 	end
-- 	if _Data.FuncName then
-- 		ret = self.ConditionComponent:CheckNotifyCondition(EffectId, ConditionId, Source)
-- 	end

-- 	return self:JudgeAndOrNot(_Data, ret, Source, Targets)
-- end

return Component
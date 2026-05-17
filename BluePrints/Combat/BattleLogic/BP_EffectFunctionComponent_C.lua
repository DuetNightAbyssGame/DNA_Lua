
---@type EffectFunctionComponent_C
local BP_EffectFunctionComponent_C = Class()

-- function BP_EffectFunctionComponent_C:Initialize(Initializer)
-- end

-- function BP_EffectFunctionComponent_C:ReceiveBeginPlay()
-- end

function BP_EffectFunctionComponent_C:ExecuteFunction(Source, EffectId, FunctionName, Vars)
	self.Overridden.ExecuteFunction(self, Source, EffectId)

	local Func = self.Overridden[FunctionName]
	assert(Func, "找不到技能效果蓝图函数" .. tostring(FunctionName))

	if Vars then
		for VarName,Value in pairs(Vars) do
			self[VarName] = Value
		end
	end
	
	Func(self)
end

-- function BP_EffectFunctionComponent_C:ReceiveEndPlay()
-- end

-- function BP_EffectFunctionComponent_C:ReceiveTick(DeltaSeconds)
-- end

return BP_EffectFunctionComponent_C

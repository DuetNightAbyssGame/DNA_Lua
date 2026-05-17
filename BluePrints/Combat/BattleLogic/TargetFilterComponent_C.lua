
require "UnLua"

local TargetFilterComponent_C = Class()

function TargetFilterComponent_C:DoBPFilter(Source, Targets, FilterFunc, Vars, ExtraVars, CollisionCompMap)
	-- PrintTable({DoBPFilter=DoBPFilter,Source=Source, Targets=Targets,FilterFunc=FilterFunc})
	local TargetEids =  self.Overridden.DoBPFilter(self, Source, Targets)
	if not TargetEids then
		return TargetEids
	end
	-- PrintTable({DoBPFilter=DoBPFilter,Source=Source, TargetEids=TargetEids,FilterFunc=FilterFunc})

	self:SetEid2CollisionComponents(CollisionCompMap)
	if FilterFunc and FilterFunc ~= "None"  then
		local Func = self.Overridden[FilterFunc]
		assert(Func, "找不到目标过滤函数" .. tostring(FilterFunc))

		if Vars then
			for VarName,Value in pairs(Vars) do
				self[VarName] = Value
			end
		end
		if ExtraVars then
			for VarName,Value in pairs(ExtraVars) do
				self[VarName] = Value
			end
		end
		TargetEids = Func(self)
	end

	self.Overridden.FilterResult(self, Source, Targets, TargetEids, FilterFunc, CollisionCompMap)
	return TargetEids
end

-- 将Eid和碰撞体数组的映射关系转存到组件的变量上
function TargetFilterComponent_C:SetEid2CollisionComponents(CollisionCompMap)
	self.Eid2CollisionComponents:Clear()
	if CollisionCompMap then
		self.Eid2CollisionComponents = CollisionCompMap
	end
end

return TargetFilterComponent_C

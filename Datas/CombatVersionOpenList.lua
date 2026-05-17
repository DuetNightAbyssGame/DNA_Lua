local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("CombatVersionOpenList", {
	[10] = true,
	[11] = true,
	[12] = true,
	[13] = true,
})
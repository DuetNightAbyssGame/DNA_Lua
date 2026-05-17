local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("EventId2TempleLevelType", {
	[108001] = {
		[1] = 1080011,
		[2] = 1080012,
		[3] = 1080013,
	},
})
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("WeeklyDungeonId2ChapterId", {
	[91302] = 1,
	[91304] = 1,
	[91306] = 1,
	[91307] = 1,
	[91308] = 1,
	[91502] = 2,
	[91504] = 2,
	[91506] = 2,
	[91507] = 2,
	[91508] = 2,
})
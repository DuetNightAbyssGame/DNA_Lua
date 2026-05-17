local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ConditionId2FishingSpotId", {
	[20021501] = {
		[1] = 10010101,
		[2] = 10110301,
		[3] = 10170101,
		[4] = 10410601,
		[5] = 10410701,
		[6] = 10410801,
		[7] = 10410901,
		[8] = 10411001,
		[9] = 10450201,
		[10] = 10450501,
		[11] = 10490101,
		[12] = 10550101,
	},
})
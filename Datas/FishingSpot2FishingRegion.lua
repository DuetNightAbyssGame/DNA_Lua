local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("FishingSpot2FishingRegion", {
	[10010101] = 1,
	[10110301] = 2,
	[10170101] = 2,
	[10410601] = 3,
	[10410701] = 3,
	[10410801] = 3,
	[10410901] = 3,
	[10411001] = 3,
	[10450201] = 4,
	[10450401] = 4,
	[10450501] = 4,
	[10550101] = 4,
})
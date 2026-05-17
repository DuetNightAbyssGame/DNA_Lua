local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("RegionId2DefaultTeleportPoint", {
	[1001] = 1001,
	[1011] = 1010,
	[1013] = 1020,
	[1017] = 1030,
	[1019] = 1050,
	[1021] = 1040,
	[1041] = 1100,
	[1045] = 1200,
	[1052] = 1300,
	[1053] = 1400,
	[1055] = 1500,
	[1057] = 1113,
	[9997] = 101,
})
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("EventId2TempleRewardId", {
	[108001] = {
		[1] = 10800101,
		[2] = 10800102,
		[3] = 10800103,
		[4] = 10800104,
		[5] = 10800105,
		[6] = 10800106,
		[7] = 10800107,
		[8] = 10800108,
		[9] = 10800109,
		[10] = 10800110,
		[11] = 10800111,
		[12] = 10800112,
	},
})
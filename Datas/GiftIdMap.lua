local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("GiftIdMap", {
	[1] = 120103,
	[2] = 120104,
	[3] = 120202,
	[4] = 120217,
	[5] = 120218,
	[6] = 120301,
	[7] = 120302,
	[8] = 120303,
	[9] = 120325,
	[10] = 120328,
	[11] = 120401,
	[12] = 120402,
	[13] = 120417,
	[14] = 120421,
	[15] = 99992,
	[16] = 99993,
	[17] = 120501,
	[18] = 120537,
})
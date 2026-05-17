local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("AbyssLock2Id", {
	[1012] = {
		[1] = 1013,
	},
	[1014] = {
		[1] = 1015,
	},
	[1111] = {
		[1] = 1112,
	},
	[1113] = {
		[1] = 1114,
	},
	[1211] = {
		[1] = 1212,
	},
	[1213] = {
		[1] = 1214,
	},
	[1311] = {
		[1] = 1312,
	},
	[1313] = {
		[1] = 1314,
	},
	[9991] = {
		[1] = 1211,
		[2] = 1213,
		[3] = 1311,
		[4] = 1313,
		[5] = 1012,
		[6] = 1014,
		[7] = 1111,
		[8] = 1113,
	},
})
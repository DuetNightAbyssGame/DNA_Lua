local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("TargetId2TheaterTask", {
	[10301] = {
		[1] = 6,
	},
	[1010501] = {
		[1] = 9,
	},
	[1080201] = {
		[1] = 1,
	},
	[1400101] = {
		[1] = 2,
	},
	[1900101] = {
		[1] = 7,
	},
	[2100101] = {
		[1] = 5,
	},
	[10051601] = {
		[1] = 4,
	},
	[10102901] = {
		[1] = 8,
	},
	[10102902] = {
		[1] = 10,
	},
	[10102903] = {
		[1] = 11,
	},
	[10102904] = {
		[1] = 12,
	},
	[10102905] = {
		[1] = 3,
	},
	[10102906] = {
		[1] = 13,
	},
})
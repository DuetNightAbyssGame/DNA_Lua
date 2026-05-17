-- Source Excel file path: ..\datas\Map.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("RegionMap", {
	[1] = {
		MainRegionMap = true,
		RegionId = 9997,
		RegionMapId = 1,
	},
	[100] = {
		MainRegionMap = true,
		RegionId = 1001,
		RegionMapId = 100,
	},
	[200] = {
		MainRegionMap = true,
		RegionId = 1011,
		RegionMapId = 200,
		RegionMapUnlockCondition = 26,
	},
	[201] = {
		RegionId = 1017,
		RegionMapId = 201,
		RegionMapUnlockCondition = 312,
	},
	[202] = {
		RegionId = 1013,
		RegionMapId = 202,
		RegionMapUnlockCondition = 314,
	},
	[203] = {
		RegionId = 2101,
		RegionMapId = 203,
		RegionMapUnlockCondition = 27,
	},
	[204] = {
		RegionId = 1019,
		RegionMapId = 204,
		RegionMapUnlockCondition = 317,
	},
	[300] = {
		RegionId = 1021,
		RegionMapId = 300,
		RegionMapUnlockCondition = 11010103,
		UISubRegionType = "EX",
	},
	[400] = {
		MainRegionMap = true,
		RegionId = 1041,
		RegionMapId = 400,
		RegionMapUnlockCondition = 325,
	},
	[401] = {
		RegionId = 1057,
		RegionMapId = 401,
		RegionMapUnlockCondition = 324,
	},
	[500] = {
		MainRegionMap = true,
		RegionId = 1045,
		RegionMapId = 500,
		RegionMapUnlockCondition = 12020101,
	},
	[501] = {
		RegionId = 1052,
		RegionMapId = 501,
		RegionMapUnlockCondition = 326,
	},
	[502] = {
		RegionId = 1053,
		RegionMapId = 502,
		RegionMapUnlockCondition = 328,
	},
	[503] = {
		RegionId = 1055,
		RegionMapId = 503,
		RegionMapUnlockCondition = 329,
	},
})
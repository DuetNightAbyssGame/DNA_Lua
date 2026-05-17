-- Source Excel file path: ..\datas\GameEvent\PaotaiMiniGame.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("PaotaiGamePoint", {
	[1] = {
		Id = 1,
		Monster = 7012005,
		Point = 2000,
	},
	[2] = {
		Id = 2,
		Monster = 7002007,
		Point = 1500,
	},
	[3] = {
		Id = 3,
		Monster = 7001008,
		Point = 2500,
	},
	[4] = {
		Id = 4,
		Monster = 6006002,
		Point = 3000,
	},
	[5] = {
		Id = 5,
		Monster = 8501006,
		Point = 30000,
	},
})
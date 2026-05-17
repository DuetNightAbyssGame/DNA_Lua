-- Source Excel file path: ..\datas\DungeonWalnut.xlsx
local T = {}
T.RT_1 = {
		3,
		3,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("WalnutSelectDungeon", {
	[1] = {
		DungeonId = {
			60102,
			60202,
			60402,
			60502,
			60602,
			60702,
			60902,
			61102,
		},
		DungeonRandomNum = T.RT_1,
		Sequence = 1,
		WalnutType = 1,
	},
	[2] = {
		DungeonId = {
			62102,
			62202,
			62402,
			62502,
			62602,
			62702,
			62902,
			63102,
		},
		DungeonRandomNum = T.RT_1,
		Sequence = 2,
		WalnutType = 2,
	},
	[3] = {
		DungeonId = {
			64102,
			64202,
			64402,
			64502,
			64602,
			64702,
			64902,
			65102,
		},
		DungeonRandomNum = T.RT_1,
		Sequence = 3,
		WalnutType = 3,
	},
})
-- Source Excel file path: ..\datas\RaidDungeon.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("PreRaidRank", {
	[1] = {
		IsOnline = {
			false,
			false,
			false,
			false,
			false,
		},
		PreRaidRank = 1,
		RankName = {
			"SSS",
			"SS",
			"S",
			"A",
			"B",
		},
		RankPercent = {
			15,
			35,
			55,
			75,
			100,
		},
		RankReward = {
			300316,
			300317,
			300318,
			300319,
			300320,
		},
	},
})
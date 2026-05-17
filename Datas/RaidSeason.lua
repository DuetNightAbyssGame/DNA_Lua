-- Source Excel file path: ..\datas\RaidDungeon.xlsx
local T = {}
T.RT_1 = {
		[1000] = 300315,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("RaidSeason", {
	[1001] = {
		EventId = 111001,
		PreRaidRank = 1,
		PreRaidTime = 62,
		RaidPointToRewrad = T.RT_1,
		RaidPointToRewradMaxTime = 750,
		RaidRankCount = 1000,
		RaidSeason = 1001,
		RaidTime = 173,
		Shop = "RaidShopSeason01",
	},
	[1002] = {
		EventId = 111002,
		PreRaidRank = 1,
		PreRaidTime = 62,
		RaidPointToRewrad = T.RT_1,
		RaidPointToRewradMaxTime = 750,
		RaidRankCount = 1000,
		RaidSeason = 1002,
		RaidTime = 173,
		Shop = "RaidShopSeason01",
	},
	[1003] = {
		EventId = 111003,
		PreRaidRank = 1,
		PreRaidTime = 62,
		RaidPointToRewrad = T.RT_1,
		RaidPointToRewradMaxTime = 750,
		RaidRankCount = 1000,
		RaidSeason = 1003,
		RaidTime = 168,
		Shop = "RaidShopSeason01",
	},
})
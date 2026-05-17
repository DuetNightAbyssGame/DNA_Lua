local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("EventId2RaidSeason", {
	[111001] = {
		["EventEndTime"] = LocalTimeProxy(1770584400),
		["EventId"] = 111001,
		["EventStartTime"] = LocalTimeProxy(1769133600),
		["RaidSeasonId"] = 1001,
	},
	[111002] = {
		["EventEndTime"] = LocalTimeProxy(1775768400),
		["EventId"] = 111002,
		["EventStartTime"] = LocalTimeProxy(1774317600),
		["RaidSeasonId"] = 1002,
	},
	[111003] = {
		["EventEndTime"] = LocalTimeProxy(1780606800),
		["EventId"] = 111003,
		["EventStartTime"] = LocalTimeProxy(1779156000),
		["RaidSeasonId"] = 1003,
	},
})
-- Source Excel file path: ..\datas\Abyss\AbyssSystem.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("AbyssSeasonList", {
	[1001] = {
		Abyss = {
			Infinite = 1013,
			Rotate = 1012,
		},
		AbyssEndTime = LocalTimeProxy(1764018000),
		AbyssSeasonId = 1001,
		AbyssSeasonName = "Event_STitle_103002",
		AbyssStartTime = LocalTimeProxy(1761512400),
		CharId = 5301,
		EventId = 103002,
	},
	[1002] = {
		Abyss = {
			Infinite = 1015,
			Rotate = 1014,
		},
		AbyssEndTime = LocalTimeProxy(1766437200),
		AbyssSeasonId = 1002,
		AbyssSeasonName = "Event_STitle_103002",
		AbyssStartTime = LocalTimeProxy(1764018000),
		CharId = 1801,
		EventId = 1030022,
		LastSeason = 1001,
	},
	[1003] = {
		Abyss = {
			Infinite = 1112,
			Rotate = 1111,
		},
		AbyssEndTime = LocalTimeProxy(1768874400),
		AbyssSeasonId = 1003,
		AbyssSeasonName = "Event_STitle_103002",
		AbyssStartTime = LocalTimeProxy(1766437200),
		CharId = 2401,
		EventId = 1030023,
		LastSeason = 1002,
	},
	[1004] = {
		Abyss = {
			Infinite = 1114,
			Rotate = 1113,
		},
		AbyssEndTime = LocalTimeProxy(1770688800),
		AbyssSeasonId = 1004,
		AbyssSeasonName = "Event_STitle_103002",
		AbyssStartTime = LocalTimeProxy(1768874400),
		CharId = 1503,
		EventId = 1030024,
		LastSeason = 1003,
	},
	[1005] = {
		Abyss = {
			Infinite = 1212,
			Rotate = 1211,
		},
		AbyssEndTime = LocalTimeProxy(1773108000),
		AbyssSeasonId = 1005,
		AbyssSeasonName = "Event_STitle_103002",
		AbyssStartTime = LocalTimeProxy(1770688800),
		CharId = 4102,
		EventId = 1030025,
		LastSeason = 1004,
	},
	[1006] = {
		Abyss = {
			Infinite = 1214,
			Rotate = 1213,
		},
		AbyssEndTime = LocalTimeProxy(1775466000),
		AbyssSeasonId = 1006,
		AbyssSeasonName = "Event_STitle_103002",
		AbyssStartTime = LocalTimeProxy(1773108000),
		CharId = 4201,
		EventId = 1030026,
		LastSeason = 1005,
	},
	[1007] = {
		Abyss = {
			Infinite = 1312,
			Rotate = 1311,
		},
		AbyssEndTime = LocalTimeProxy(1777946400),
		AbyssSeasonId = 1007,
		AbyssSeasonName = "Event_STitle_103002",
		AbyssStartTime = LocalTimeProxy(1775527200),
		CharId = 1504,
		EventId = 1030025,
		LastSeason = 1006,
	},
	[1008] = {
		Abyss = {
			Infinite = 1314,
			Rotate = 1313,
		},
		AbyssEndTime = LocalTimeProxy(1780304400),
		AbyssSeasonId = 1008,
		AbyssSeasonName = "Event_STitle_103002",
		AbyssStartTime = LocalTimeProxy(1777946400),
		CharId = 3202,
		EventId = 1030026,
		LastSeason = 1007,
	},
})
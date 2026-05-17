-- Source Excel file path: ..\datas\GameEvent\TheaterEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("TheaterNpc", {
	[900014] = {
		EndTime = LocalTimeProxy(1768856400),
		NPCID = 900014,
		StartTime = LocalTimeProxy(1768769700),
	},
	[900015] = {
		EndTime = LocalTimeProxy(1767041700),
		NPCID = 900015,
		StartTime = LocalTimeProxy(1766628000),
	},
	[900016] = {
		EndTime = LocalTimeProxy(1767473700),
		NPCID = 900016,
		StartTime = LocalTimeProxy(1767041700),
	},
	[900017] = {
		EndTime = LocalTimeProxy(1767905700),
		NPCID = 900017,
		StartTime = LocalTimeProxy(1767473700),
	},
	[900018] = {
		EndTime = LocalTimeProxy(1768337700),
		NPCID = 900018,
		StartTime = LocalTimeProxy(1767905700),
	},
	[900019] = {
		EndTime = LocalTimeProxy(1768769700),
		NPCID = 900019,
		StartTime = LocalTimeProxy(1768337700),
	},
})
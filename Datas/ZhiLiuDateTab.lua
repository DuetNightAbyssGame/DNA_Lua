-- Source Excel file path: ..\datas\GameEvent\ZhiLiuEntrust.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ZhiLiuDateTab", {
	[1] = {
		CombatEntrustID = 102,
		Key = 1,
		SubmitEntrustID = 101,
		Time = LocalTimeProxy(1765159200),
	},
	[2] = {
		CombatEntrustID = 202,
		Key = 2,
		SubmitEntrustID = 201,
		Time = LocalTimeProxy(1765227600),
	},
	[3] = {
		CombatEntrustID = 302,
		Key = 3,
		SubmitEntrustID = 301,
		Time = LocalTimeProxy(1765314000),
	},
	[4] = {
		CombatEntrustID = 402,
		Key = 4,
		SubmitEntrustID = 401,
		Time = LocalTimeProxy(1765400400),
	},
	[5] = {
		CombatEntrustID = 502,
		Key = 5,
		SubmitEntrustID = 501,
		Time = LocalTimeProxy(1765486800),
	},
	[6] = {
		CombatEntrustID = 602,
		Key = 6,
		SubmitEntrustID = 601,
		Time = LocalTimeProxy(1765573200),
	},
	[7] = {
		CombatEntrustID = 702,
		Key = 7,
		SubmitEntrustID = 701,
		Time = LocalTimeProxy(1765659600),
	},
})
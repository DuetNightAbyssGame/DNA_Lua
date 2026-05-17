-- Source Excel file path: ..\datas\GameEvent\CommonQuestEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("SystemUIName", {
	[102001] = {
		EventId = 102001,
		UIName = "ActivityEastTask",
	},
	[1020012] = {
		EventId = 1020012,
		UIName = "ActivityEastTask02",
	},
})
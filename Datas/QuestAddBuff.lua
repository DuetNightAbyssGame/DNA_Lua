-- Source Excel file path: ..\datas\Quest.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("QuestAddBuff", {
	[10010107] = {
		AddorRemove = "Add",
		BuffId = {
			304,
		},
		QuestId = 10010107,
		QuestStartorSuccess = "Start",
	},
	[10010108] = {
		AddorRemove = "Add",
		BuffId = {
			309,
		},
		QuestId = 10010108,
		QuestStartorSuccess = "Start",
	},
	[10010212] = {
		AddorRemove = "Add",
		BuffId = {
			99,
		},
		QuestId = 10010212,
		QuestStartorSuccess = "Start",
	},
	[10010305] = {
		AddorRemove = "Add",
		BuffId = {
			306,
		},
		QuestId = 10010305,
		QuestStartorSuccess = "Success",
	},
	[10010306] = {
		AddorRemove = "Remove",
		BuffId = {
			304,
			99,
			306,
			309,
		},
		QuestId = 10010306,
		QuestStartorSuccess = "Success",
	},
})
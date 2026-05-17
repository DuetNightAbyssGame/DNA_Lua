-- Source Excel file path: ..\datas\QuestBattleWheel.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("QuestBattleWheel", {
	[1] = {
		QuestBattleWheelID = 1,
		ResourceId1 = 1,
		ResourceId2 = 1,
		ResourceId3 = 1,
		ResourceId4 = 1,
		ResourceId5 = 1,
		ResourceId6 = 1,
		ResourceId7 = 1,
		ResourceId8 = 1,
	},
	[10001] = {
		QuestBattleWheelID = 10001,
		ResourceId1 = 42002,
	},
	[10002] = {
		QuestBattleWheelID = 10002,
		ResourceId1 = 42002,
	},
	[10003] = {
		QuestBattleWheelID = 10003,
		ResourceId1 = 42001,
		ResourceId2 = 42002,
	},
	[10004] = {
		QuestBattleWheelID = 10004,
		ResourceId1 = 42002,
		ResourceId2 = 41009,
		ResourceId3 = 41010,
		ResourceId4 = 41002,
		ResourceId5 = 41005,
		ResourceId6 = 41006,
		ResourceId7 = 41004,
		ResourceId8 = 41003,
	},
})
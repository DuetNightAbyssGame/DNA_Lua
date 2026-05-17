-- Source Excel file path: ..\datas\GameEvent\CumulativeTopUpEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("CumulativeTopUpEvent", {
	[113001] = {
		EventDes = "UI_EventDes_113001",
		EventId = 113001,
		EventRule = "UI_EventRule_113001",
		JumpId = 85,
		LastRewardId = 1002,
		LastRewardTypeId = "Mount",
		ScoreRankReward = {
			[60] = 11300101,
			[300] = 11300102,
			[1000] = 11300103,
			[2000] = 11300104,
			[4000] = 11300105,
			[7000] = 11300106,
			[12000] = 11300107,
			[20000] = 11300108,
		},
	},
})
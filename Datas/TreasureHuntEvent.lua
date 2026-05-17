-- Source Excel file path: ..\datas\Extraction\TreasureHuntEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("TreasureHuntEvent", {
	[103014] = {
		EventId = 103014,
		EventProgress = {
			1001,
			1002,
			1003,
			1004,
			1005,
		},
		EventRepeatDungeon = {
			10301401,
			10301402,
			10301403,
			10301404,
		},
		EventShop = 87,
		EventStoryDungeon = {
			10301411,
			10301412,
			10301413,
			10301414,
			10301415,
		},
		LimitTaskId = {
			1301,
			1302,
			1303,
		},
		PermanentTaskId = {
			1304,
		},
		PermanentTaskRewardView = 103014,
	},
})
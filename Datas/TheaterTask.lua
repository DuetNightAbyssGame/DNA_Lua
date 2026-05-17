-- Source Excel file path: ..\datas\GameEvent\TheaterEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("TheaterTask", {
	[1] = {
		ConditionID = 8029,
		Des = "Target_Theater_1",
		IsDaily = true,
		RewardId = 110507,
		RewardViewId = 1030091,
		Target = 1,
		TargetId = {
			1080201,
		},
		TheaterTaskID = 1,
	},
	[2] = {
		ConditionID = 8029,
		Des = "Target_Theater_2",
		IsDaily = true,
		RewardId = 110508,
		RewardViewId = 1030092,
		Target = 1,
		TargetId = {
			1400101,
		},
		TheaterTaskID = 2,
	},
	[3] = {
		ConditionID = 8029,
		Des = "Target_Theater_3",
		IsDaily = true,
		RewardId = 110509,
		RewardViewId = 1030093,
		Target = 1,
		TargetId = {
			10102905,
		},
		TheaterTaskID = 3,
	},
	[4] = {
		ConditionID = 8029,
		Des = "Target_Theater_4",
		IsDaily = true,
		RewardId = 110510,
		RewardViewId = 1030094,
		Target = 1,
		TargetId = {
			10051601,
		},
		TheaterTaskID = 4,
	},
	[5] = {
		ConditionID = 8029,
		Des = "Target_Theater_5",
		IsDaily = true,
		RewardId = 110507,
		RewardViewId = 1030091,
		Target = 1,
		TargetId = {
			2100101,
		},
		TheaterTaskID = 5,
	},
	[6] = {
		ConditionID = 8029,
		Des = "Target_Theater_6",
		IsDaily = true,
		RewardId = 110508,
		RewardViewId = 1030092,
		Target = 1,
		TargetId = {
			10301,
		},
		TheaterTaskID = 6,
	},
	[7] = {
		ConditionID = 8029,
		Des = "Target_Theater_7",
		IsDaily = true,
		RewardId = 110509,
		RewardViewId = 1030093,
		Target = 1,
		TargetId = {
			1900101,
		},
		TheaterTaskID = 7,
	},
	[8] = {
		ConditionID = 8029,
		Des = "Target_Theater_8",
		IsDaily = true,
		RewardId = 110510,
		RewardViewId = 1030094,
		Target = 1,
		TargetId = {
			10102901,
		},
		TheaterTaskID = 8,
	},
	[9] = {
		ConditionID = 8029,
		Des = "Target_Theater_9",
		IsDaily = true,
		RewardId = 110511,
		RewardViewId = 1030095,
		Target = 1,
		TargetId = {
			1010501,
		},
		TheaterTaskID = 9,
	},
	[10] = {
		ConditionID = 8029,
		Des = "Target_Theater_10",
		RewardId = 110512,
		RewardViewId = 1030096,
		Target = 300,
		TargetId = {
			10102902,
		},
		TheaterTaskID = 10,
	},
	[11] = {
		ConditionID = 8029,
		Des = "Target_Theater_11",
		RewardId = 110513,
		RewardViewId = 1030097,
		Target = 100,
		TargetId = {
			10102903,
		},
		TheaterTaskID = 11,
	},
	[12] = {
		ConditionID = 8029,
		Des = "Target_Theater_12",
		RewardId = 110514,
		RewardViewId = 1030098,
		Target = 30,
		TargetId = {
			10102904,
		},
		TheaterTaskID = 12,
	},
	[13] = {
		ConditionID = 8029,
		Des = "Target_Theater_13",
		RewardId = 110515,
		RewardViewId = 1030099,
		Target = 5,
		TargetId = {
			10102906,
		},
		TheaterTaskID = 13,
	},
})
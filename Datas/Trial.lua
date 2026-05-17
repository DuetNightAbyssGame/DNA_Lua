-- Source Excel file path: ..\datas\Dungeons\Trial.xlsx
local T = {}
T.RT_1 = {
		1,
		2,
		3,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("Trial", {
	[1103] = {
		CharTrialId = 1103,
		Tasks = T.RT_1,
	},
	[1502] = {
		CharTrialId = 1502,
		Tasks = T.RT_1,
	},
	[2101] = {
		CharTrialId = 2101,
		Tasks = T.RT_1,
	},
	[3101] = {
		CharTrialId = 3101,
		Tasks = T.RT_1,
	},
	[4301] = {
		CharTrialId = 4301,
		Tasks = T.RT_1,
	},
	[5101] = {
		CharTrialId = 5101,
		Tasks = T.RT_1,
	},
	[101011] = {
		CharTrialId = 101011,
		Tasks = T.RT_1,
	},
	[101012] = {
		CharTrialId = 101012,
		Tasks = T.RT_1,
	},
	[101013] = {
		CharTrialId = 101013,
		Tasks = T.RT_1,
	},
	[101014] = {
		CharTrialId = 101014,
		Tasks = T.RT_1,
	},
	[101015] = {
		CharTrialId = 101015,
		Tasks = T.RT_1,
	},
	[101016] = {
		CharTrialId = 101016,
		Tasks = T.RT_1,
	},
	[101017] = {
		CharTrialId = 101017,
		Tasks = T.RT_1,
	},
	[101018] = {
		CharTrialId = 101018,
		Tasks = T.RT_1,
	},
	[101019] = {
		CharTrialId = 101019,
		Tasks = T.RT_1,
	},
	[101020] = {
		CharTrialId = 101020,
		Tasks = T.RT_1,
	},
	[101021] = {
		CharTrialId = 101021,
		Tasks = T.RT_1,
	},
	[101022] = {
		CharTrialId = 101022,
		Tasks = T.RT_1,
	},
	[101023] = {
		CharTrialId = 101023,
		Tasks = T.RT_1,
	},
	[101024] = {
		CharTrialId = 101024,
		Tasks = T.RT_1,
	},
	[101025] = {
		CharTrialId = 101025,
		Tasks = T.RT_1,
	},
})
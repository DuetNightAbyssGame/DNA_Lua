-- Source Excel file path: ..\datas\GameEvent\TheaterEvent.xlsx
local T = {}
T.RT_1 = {
		[1] = 15000000,
		[2] = 10000000,
		[3] = 2000000,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("TheaterDonateStep", {
	[103011] = {
		[1] = {
			EventId = 103011,
			Expectation = {
				0,
				0.3,
				0.7,
				1,
			},
			MailId = 10034,
			Num = {
				[1] = 15000000,
				[2] = 15000000,
				[3] = 2000000,
			},
			Resource = {
				[1] = 20009,
				[2] = 20012,
				[3] = 4030001,
			},
			RewardViewId = 1030080,
			StepId = 1,
		},
		[2] = {
			EventId = 103011,
			Expectation = {
				0,
				0,
				0,
				0.1,
				0.4,
				0.7,
				1,
			},
			MailId = 10035,
			Num = T.RT_1,
			Resource = {
				[1] = 20002,
				[2] = 20004,
				[3] = 4030001,
			},
			RewardViewId = 1030081,
			StepId = 2,
		},
		[3] = {
			EventId = 103011,
			Expectation = {
				0,
				0,
				0,
				0,
				0,
				0,
				0.1,
				0.4,
				0.7,
				1,
			},
			MailId = 10036,
			Num = T.RT_1,
			Resource = {
				[1] = 20005,
				[2] = 20016,
				[3] = 4030001,
			},
			RewardViewId = 1030082,
			StepId = 3,
		},
	},
})
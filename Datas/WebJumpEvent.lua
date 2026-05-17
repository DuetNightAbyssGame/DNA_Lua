-- Source Excel file path: ..\datas\GameEvent\WebJumpEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("WebJumpEvent", {
	[109001] = {
		America = {
			EventId = 109001,
			Reward = 109001,
			ServerId = "America",
			WebId = 4,
		},
		Asian = {
			EventId = 109001,
			Reward = 109001,
			ServerId = "Asian",
			WebId = 3,
		},
		China = {
			EventId = 109001,
			Reward = 109001,
			ServerId = "China",
			WebId = 1,
		},
		Europe = {
			EventId = 109001,
			Reward = 109001,
			ServerId = "Europe",
			WebId = 5,
		},
		HMT = {
			EventId = 109001,
			Reward = 109001,
			ServerId = "HMT",
			WebId = 2,
		},
		SEA = {
			EventId = 109001,
			Reward = 109001,
			ServerId = "SEA",
			WebId = 6,
		},
	},
	[109002] = {
		America = {
			EventId = 109002,
			Reward = 109001,
			ServerId = "America",
			WebId = 4,
		},
		Asian = {
			EventId = 109002,
			Reward = 109001,
			ServerId = "Asian",
			WebId = 3,
		},
		China = {
			EventId = 109002,
			Reward = 109001,
			ServerId = "China",
			WebId = 1,
		},
		Europe = {
			EventId = 109002,
			Reward = 109001,
			ServerId = "Europe",
			WebId = 5,
		},
		HMT = {
			EventId = 109002,
			Reward = 109001,
			ServerId = "HMT",
			WebId = 2,
		},
		SEA = {
			EventId = 109002,
			Reward = 109001,
			ServerId = "SEA",
			WebId = 6,
		},
	},
})
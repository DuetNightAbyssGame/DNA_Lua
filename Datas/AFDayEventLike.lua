-- Source Excel file path: ..\datas\GameEvent\AprilFoolsDayEvent2026.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("AFDayEventLike", {
	[1] = {
		LikeID = 1,
	},
	[2] = {
		LikeID = 2,
	},
	[3] = {
		LikeID = 3,
	},
	[4] = {
		LikeID = 4,
	},
})
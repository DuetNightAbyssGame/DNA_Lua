-- Source Excel file path: ..\datas\GameEvent\LimitedPrizePool.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("LimitedPrizePool", {
	[103021] = {
		EventId = 103021,
		LimitedPrizePoolId = {
			1001,
			1002,
		},
	},
})
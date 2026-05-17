-- Source Excel file path: ..\datas\RougeLike\RougeLike_MiniGame.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("RougeLikeMiniGameScore", {
	[1] = {
		MiniGameScore = {
			[1] = 0,
			[2] = 1600,
			[3] = 3200,
		},
		ScoreId = 1,
	},
	[2] = {
		MiniGameScore = {
			[1] = 0,
			[2] = 100,
		},
		ScoreId = 2,
	},
})
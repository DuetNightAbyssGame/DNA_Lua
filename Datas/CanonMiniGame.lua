-- Source Excel file path: ..\datas\RougeLike\RougeLike_MiniGame.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("CanonMiniGame", {
	[7001007] = {
		KillScore = 50,
		SelfKillScore = 0,
		UnitId = 7001007,
	},
	[7002001] = {
		KillScore = 50,
		SelfKillScore = 0,
		UnitId = 7002001,
	},
	[7003001] = {
		KillScore = 50,
		SelfKillScore = 0,
		UnitId = 7003001,
	},
	[7012001] = {
		KillScore = 50,
		SelfKillScore = 0,
		UnitId = 7012001,
	},
	[9500053] = {
		KillScore = 1000,
		SelfKillScore = 0,
		UnitId = 9500053,
	},
})
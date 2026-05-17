local T = {}
T.RT_1 = {
	[1] = 5,
	[2] = 10,
	[3] = 15,
	[4] = 20,
	[5] = 25,
	[6] = 30,
}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("FameLevelBigReward", {
	[1001] = T.RT_1,
	[1002] = T.RT_1,
})
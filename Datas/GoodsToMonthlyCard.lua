local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("GoodsToMonthlyCard", {
	["com.hero.dna.Pay_107"] = {
		[1] = 10005,
		[2] = 10006,
		[3] = 10007,
		[4] = 10008,
		[5] = 10009,
		[6] = 10010,
		[7] = 10011,
		[8] = 10012,
		[9] = 10013,
		[10] = 10014,
		[11] = 10015,
		[12] = 10001,
		[13] = 10002,
		[14] = 10003,
		[15] = 10004,
	},
})
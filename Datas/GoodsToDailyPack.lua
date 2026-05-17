local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("GoodsToDailyPack", {
	["com.hero.dna.Pay_DailyCharaShards_fushu"] = 9001,
	["com.hero.dna.Pay_DailyCharaShards_kamila"] = 9006,
	["com.hero.dna.Pay_DailyCharaShards_kezhou"] = 9002,
	["com.hero.dna.Pay_DailyCharaShards_suyi"] = 9005,
	["com.hero.dna.Pay_DailyCharaShards_yuming"] = 9004,
	["com.hero.dna.Pay_DailyCharaShards_zhiliu"] = 9003,
})
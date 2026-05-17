local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("GoodsToBattlePass", {
	["com.hero.dna.Pay_BattlePassRank2"] = {
		[100001] = "RANK2",
		[100002] = "RANK2",
		[100003] = "RANK2",
		[100004] = "RANK2",
		[100005] = "RANK2",
		[100006] = "RANK2",
		[100007] = "RANK2",
		[100008] = "RANK2",
	},
	["com.hero.dna.Pay_BattlePassRank2to3"] = {
		[100001] = "RANK2_UPGRADE_RANK3",
		[100002] = "RANK2_UPGRADE_RANK3",
		[100003] = "RANK2_UPGRADE_RANK3",
		[100004] = "RANK2_UPGRADE_RANK3",
		[100005] = "RANK2_UPGRADE_RANK3",
		[100006] = "RANK2_UPGRADE_RANK3",
		[100007] = "RANK2_UPGRADE_RANK3",
		[100008] = "RANK2_UPGRADE_RANK3",
	},
	["com.hero.dna.Pay_BattlePassRank3"] = {
		[100001] = "RANK3",
		[100002] = "RANK3",
		[100003] = "RANK3",
		[100004] = "RANK3",
		[100005] = "RANK3",
		[100006] = "RANK3",
		[100007] = "RANK3",
		[100008] = "RANK3",
	},
})
-- Source Excel file path: ..\datas\GameEvent\CumulativeTopUpEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("PayGoodsToScore", {
	[113001] = {
		["com.hero.dna.Pay_101"] = {
			EventId = 113001,
			GoodsId = "com.hero.dna.Pay_101",
			GoodsName = "GoodsName_101",
			PayGoodsScore = 60,
		},
		["com.hero.dna.Pay_102"] = {
			EventId = 113001,
			GoodsId = "com.hero.dna.Pay_102",
			GoodsName = "GoodsName_102",
			PayGoodsScore = 300,
		},
		["com.hero.dna.Pay_103"] = {
			EventId = 113001,
			GoodsId = "com.hero.dna.Pay_103",
			GoodsName = "GoodsName_103",
			PayGoodsScore = 980,
		},
		["com.hero.dna.Pay_104"] = {
			EventId = 113001,
			GoodsId = "com.hero.dna.Pay_104",
			GoodsName = "GoodsName_104",
			PayGoodsScore = 1980,
		},
		["com.hero.dna.Pay_105"] = {
			EventId = 113001,
			GoodsId = "com.hero.dna.Pay_105",
			GoodsName = "GoodsName_105",
			PayGoodsScore = 3280,
		},
		["com.hero.dna.Pay_106"] = {
			EventId = 113001,
			GoodsId = "com.hero.dna.Pay_106",
			GoodsName = "GoodsName_106",
			PayGoodsScore = 6480,
		},
		["com.hero.dna.Pay_107"] = {
			EventId = 113001,
			GoodsId = "com.hero.dna.Pay_107",
			GoodsName = "GoodsName_107",
			PayGoodsScore = 300,
		},
		["com.hero.dna.Pay_108"] = {
			EventId = 113001,
			GoodsId = "com.hero.dna.Pay_108",
			GoodsName = "GoodsName_108",
			PayGoodsScore = 12800,
		},
		["com.hero.dna.Pay_109"] = {
			EventId = 113001,
			GoodsId = "com.hero.dna.Pay_109",
			GoodsName = "GoodsName_109",
			PayGoodsScore = 32800,
		},
		["com.hero.dna.Pay_BattlePassRank2"] = {
			EventId = 113001,
			GoodsId = "com.hero.dna.Pay_BattlePassRank2",
			GoodsName = "GoodsName_BattlePassRank2",
			PayGoodsScore = 680,
		},
		["com.hero.dna.Pay_BattlePassRank2to3"] = {
			EventId = 113001,
			GoodsId = "com.hero.dna.Pay_BattlePassRank2to3",
			GoodsName = "GoodsName_BattlePassRank2to3",
			PayGoodsScore = 780,
		},
		["com.hero.dna.Pay_BattlePassRank3"] = {
			EventId = 113001,
			GoodsId = "com.hero.dna.Pay_BattlePassRank3",
			GoodsName = "GoodsName_BattlePassRank3",
			PayGoodsScore = 1280,
		},
		["com.hero.dna.Pay_Bundle1"] = {
			EventId = 113001,
			GoodsId = "com.hero.dna.Pay_Bundle1",
			GoodsName = "Pack_Name_Shop_Start_01",
			PayGoodsScore = 60,
		},
		["com.hero.dna.Pay_Bundle2"] = {
			EventId = 113001,
			GoodsId = "com.hero.dna.Pay_Bundle2",
			GoodsName = "Pack_Name_Shop_Start_02",
			PayGoodsScore = 300,
		},
		["com.hero.dna.Pay_Bundle3"] = {
			EventId = 113001,
			GoodsId = "com.hero.dna.Pay_Bundle3",
			GoodsName = "Pack_Name_Shop_Start_03",
			PayGoodsScore = 680,
		},
		["com.hero.dna.Pay_Bundle4"] = {
			EventId = 113001,
			GoodsId = "com.hero.dna.Pay_Bundle4",
			GoodsName = "Pack_Name_Shop_Start_04",
			PayGoodsScore = 1280,
		},
	},
})
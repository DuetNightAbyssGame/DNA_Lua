local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("UnrestrictedPayGoods", {
	[1] = "com.hero.dna.Pay_101",
	[2] = "com.hero.dna.Pay_102",
	[3] = "com.hero.dna.Pay_103",
	[4] = "com.hero.dna.Pay_104",
	[5] = "com.hero.dna.Pay_105",
	[6] = "com.hero.dna.Pay_106",
	[7] = "com.hero.dna.Pay_108",
	[8] = "com.hero.dna.Pay_109",
})
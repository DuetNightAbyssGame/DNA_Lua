-- Source Excel file path: ..\datas\GameEvent\TempleEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("TempleEventLevel", {
	[80401] = {
		TempleId = 80401,
		TempleTypeId = 1080012,
	},
	[80402] = {
		PreDungeon = 80401,
		TempleId = 80402,
		TempleTypeId = 1080012,
		UnlockDate = LocalTimeProxy(1767646800),
	},
	[80403] = {
		PreDungeon = 80402,
		TempleId = 80403,
		TempleTypeId = 1080012,
		UnlockDate = LocalTimeProxy(1767733200),
	},
	[80404] = {
		IsHardMode = true,
		PreDungeon = 80403,
		TempleId = 80404,
		TempleTypeId = 1080012,
		UnlockDate = LocalTimeProxy(1767819600),
	},
	[80801] = {
		TempleId = 80801,
		TempleTypeId = 1080011,
	},
	[80802] = {
		PreDungeon = 80801,
		TempleId = 80802,
		TempleTypeId = 1080011,
		UnlockDate = LocalTimeProxy(1767646800),
	},
	[80803] = {
		PreDungeon = 80802,
		TempleId = 80803,
		TempleTypeId = 1080011,
		UnlockDate = LocalTimeProxy(1767733200),
	},
	[80804] = {
		IsHardMode = true,
		PreDungeon = 80803,
		TempleId = 80804,
		TempleTypeId = 1080011,
		UnlockDate = LocalTimeProxy(1767819600),
	},
	[81201] = {
		TempleId = 81201,
		TempleTypeId = 1080013,
	},
	[81202] = {
		PreDungeon = 81201,
		TempleId = 81202,
		TempleTypeId = 1080013,
		UnlockDate = LocalTimeProxy(1767646800),
	},
	[81203] = {
		PreDungeon = 81202,
		TempleId = 81203,
		TempleTypeId = 1080013,
		UnlockDate = LocalTimeProxy(1767733200),
	},
	[81204] = {
		IsHardMode = true,
		PreDungeon = 81203,
		TempleId = 81204,
		TempleTypeId = 1080013,
		UnlockDate = LocalTimeProxy(1767819600),
	},
})
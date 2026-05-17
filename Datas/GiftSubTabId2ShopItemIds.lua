local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("GiftSubTabId2ShopItemIds", {
	[900011] = {
		[1] = 120103,
		[2] = 120104,
		[3] = 99992,
		[4] = 99993,
	},
	[900012] = {
		[1] = 120202,
		[2] = 120217,
		[3] = 120218,
		[4] = 120301,
		[5] = 120302,
		[6] = 120303,
		[7] = 120325,
		[8] = 120328,
	},
	[900013] = {
		[1] = 120401,
		[2] = 120402,
		[3] = 120417,
		[4] = 120421,
		[5] = 120501,
		[6] = 120537,
	},
})
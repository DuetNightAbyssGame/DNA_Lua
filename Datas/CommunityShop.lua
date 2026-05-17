-- Source Excel file path: ..\datas\CumulativeDayPrize.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("CommunityShop", {
	[10002] = {
		CommunityShopItemId = 10002,
		RewardId = 12147,
	},
	[10003] = {
		CommunityShopItemId = 10003,
		PurchaseLimit = 1,
		RewardId = 12148,
	},
	[20060] = {
		CommunityShopItemId = 20060,
		PurchaseLimit = 1,
		RewardId = 12149,
	},
	[20300] = {
		CommunityShopItemId = 20300,
		PurchaseLimit = 1,
		RewardId = 12150,
	},
	[30001] = {
		CommunityShopItemId = 30001,
		PurchaseLimit = 1,
		RewardId = 12151,
	},
})
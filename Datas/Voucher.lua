-- Source Excel file path: ..\datas\ShopPayGoods.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("Voucher", {
	[1001] = {
		CoinResourceId = 99,
		DiscountPrice = 50,
		ItemId = {
			120101,
			120103,
			120104,
		},
		ResourceId = 120001,
		ThresholdPrice = 100,
		VoucherId = 1001,
	},
	[1002] = {
		CoinResourceId = 99,
		DiscountPrice = 50,
		ItemId = {
			120108,
		},
		ResourceId = 120002,
		VoucherId = 1002,
	},
})
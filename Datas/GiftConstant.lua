-- Source Excel file path: ..\datas\Shop.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("GiftConstant", {
	GiftCountPerMonth_S = {
		ConstantName = "GiftCountPerMonth_S",
		ConstantValue1 = 10,
	},
	GiftLimitLevel = {
		ConstantName = "GiftLimitLevel",
		ConstantValue1 = 5,
	},
	GiftMailId = {
		ConstantName = "GiftMailId",
		ConstantValue1 = 10067,
	},
	KeepFriendshipTime = {
		ConstantName = "KeepFriendshipTime",
		ConstantValue1 = 14,
	},
})
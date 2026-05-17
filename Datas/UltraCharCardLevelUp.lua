-- Source Excel file path: ..\datas\Character.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("UltraCharCardLevelUp", {
	[2101] = {
		CharId = 2101,
		CollectRewardExp = 250,
		ExtraUnlockCondition = 210180,
		ResourceId1 = 1001101,
		ResourceNum1 = 30,
		UnlockDes = "CardLevel7thUnlockDEs",
	},
	[3201] = {
		CharId = 3201,
		CollectRewardExp = 250,
		ExtraUnlockCondition = 320180,
		ResourceId1 = 1001101,
		ResourceNum1 = 30,
		UnlockDes = "CardLevel7thUnlockDEs",
	},
})
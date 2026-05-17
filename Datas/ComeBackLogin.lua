-- Source Excel file path: ..\datas\GameEvent\ComeBackEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ComeBackLogin", {
	[114001] = {
		EventLoginId = 114001,
		LoginDuration = 7,
		LoginReward = {
			114001001,
			114001002,
			114001003,
			114001004,
			114001005,
			114001006,
			114001007,
		},
		RewardBannerBP = "/Game/UI/WBP/Activity/Widget/SevenDay/Saiqi/WBP_Activity_SevenDayItems.WBP_Activity_SevenDayItems",
	},
})
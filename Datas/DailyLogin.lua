-- Source Excel file path: ..\datas\GameEvent\DailyLogin.xlsx
local T = {}
T.RT_1 = {
		1010012,
		1010012,
		1010013,
		1010012,
		1010012,
		1010012,
		1010014,
	}
T.RT_2 = {
		1010041,
		1010042,
		1010043,
		1010044,
		1010045,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("DailyLogin", {
	[101001] = {
		EventId = 101001,
		EventReward = T.RT_1,
		LoginDuration = 7,
		RewardBannerBP = "/Game/UI/WBP/Activity/Widget/SevenDay/Saiqi/WBP_Activity_SevenDayItems.WBP_Activity_SevenDayItems",
	},
	[101002] = {
		EventId = 101002,
		EventReward = T.RT_1,
		LoginDuration = 7,
		RewardBannerBP = "/Game/UI/WBP/Activity/Widget/SevenDay/Baiheng/WBP_Activity_SevenDayItems.WBP_Activity_SevenDayItems",
	},
	[101003] = {
		EventId = 101003,
		EventReward = T.RT_1,
		LoginDuration = 7,
		RewardBannerBP = "/Game/UI/WBP/Activity/Widget/SevenDay/Baiheng/WBP_Activity_SevenDayItems.WBP_Activity_SevenDayItems",
	},
	[101004] = {
		EventId = 101004,
		EventReward = T.RT_2,
		LoginDuration = 5,
	},
	[101005] = {
		EventId = 101005,
		EventReward = T.RT_1,
		LoginDuration = 7,
		RewardBannerBP = "/Game/UI/WBP/Activity/Widget/SevenDay/FeiNa/WBP_Activity_SevenDayItems.WBP_Activity_SevenDayItems",
	},
	[101006] = {
		EventId = 101006,
		EventReward = T.RT_1,
		LoginDuration = 7,
		RewardBannerBP = "/Game/UI/WBP/Activity/Widget/SevenDay/Zhiliu/WBP_Activity_SevenDayItems.WBP_Activity_SevenDayItems",
	},
	[101007] = {
		EventId = 101007,
		EventReward = T.RT_1,
		LoginDuration = 7,
		RewardBannerBP = "/Game/UI/WBP/Activity/Widget/SevenDay/Yuming/WBP_Activity_SevenDayItems.WBP_Activity_SevenDayItems",
	},
	[101008] = {
		EventId = 101008,
		EventReward = T.RT_2,
		LoginDuration = 5,
	},
	[101009] = {
		EventId = 101009,
		EventReward = T.RT_2,
		LoginDuration = 5,
	},
	[101010] = {
		EventId = 101010,
		EventReward = T.RT_1,
		LoginDuration = 7,
		RewardBannerBP = "/Game/UI/WBP/Activity/Widget/SevenDay/Suyi/WBP_Activity_SevenDayItems_Suyi.WBP_Activity_SevenDayItems_Suyi",
	},
	[101011] = {
		EventId = 101011,
		EventReward = T.RT_1,
		LoginDuration = 7,
		RewardBannerBP = "/Game/UI/WBP/Activity/Widget/SevenDay/Kami/WBP_Activity_SevenDayItems_Kami.WBP_Activity_SevenDayItems_Kami",
	},
})
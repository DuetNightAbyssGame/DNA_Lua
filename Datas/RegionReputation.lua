-- Source Excel file path: ..\datas\RegionReputation.xlsx
local T = {}
T.RT_1 = {
		3,
		3,
		3,
	}
T.RT_2 = {
		WEEK = 1,
	}
T.RT_3 = {
		DAY = 1,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("RegionReputation", {
	[1001] = {
		Condition = 4420,
		LockToast = "Reputation_LockToast01",
		ManualRefreshCount = 10000,
		ManualRefreshId = 101,
		ManualRefreshNumber = 99,
		ManualRefreshType = "Resource",
		RefreshBeginTime = LocalTimeProxy(1767578400),
		RefreshNum1 = T.RT_1,
		RefreshNum2 = 8,
		RefreshTime1 = T.RT_2,
		RefreshTime2 = T.RT_3,
		RegionIconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_IceLake.T_Tab_IceLake",
		RegionId = {
			1001,
			1011,
			1013,
			1017,
			1019,
			1021,
			1022,
			1032,
			2101,
		},
		RegionName = "RegionReputation_Title01",
		RegionUIBG = "/Game/UI/WBP/Fame/Widget/Region/WBP_Fame_Bg_IceLake.WBP_Fame_Bg_IceLake",
		RegionUIButtonBGIndex = 0,
		RegionUIIcon = "/Game/UI/Texture/Dynamic/Image/Region/T_Region_IceLake.T_Region_IceLake",
		ReputationID = 1001,
		RewardView = 1040001,
		WeekLimit = 1500,
	},
	[1002] = {
		Condition = 12010101,
		LockToast = "Reputation_LockToast02",
		ManualRefreshCount = 10000,
		ManualRefreshId = 101,
		ManualRefreshNumber = 99,
		ManualRefreshType = "Resource",
		RefreshBeginTime = LocalTimeProxy(1767578400),
		RefreshNum1 = T.RT_1,
		RefreshNum2 = 8,
		RefreshTime1 = T.RT_2,
		RefreshTime2 = T.RT_3,
		RegionIconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_East_Season01.T_Tab_East_Season01",
		RegionId = {
			1041,
			1042,
			1046,
			1047,
			1059,
			1043,
			1044,
			1050,
			1057,
		},
		RegionName = "RegionReputation_Title02",
		RegionUIBG = "/Game/UI/WBP/Fame/Widget/Region/WBP_Fame_Bg_Yanjindu.WBP_Fame_Bg_Yanjindu",
		RegionUIButtonBGIndex = 1,
		RegionUIIcon = "/Game/UI/Texture/Dynamic/Image/Region/T_Region_Yanjindu.T_Region_Yanjindu",
		ReputationID = 1002,
		RewardView = 1040002,
		WeekLimit = 1500,
	},
})
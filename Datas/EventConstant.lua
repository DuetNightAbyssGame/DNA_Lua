-- Source Excel file path: ['..\\datas\\GameEvent\\AprilFoolsDayEvent2026.xlsx', '..\\datas\\GameEvent\\FeinaEvent.xlsx', '..\\datas\\GameEvent\\FollowCommunityEvent.xlsx', '..\\datas\\GameEvent\\ZhiLiuEntrust.xlsx']
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("EventConstant", {
	AFDayEvent2026ID = {
		ConstantName = "AFDayEvent2026ID",
		ConstantValue = 103018,
	},
	FeinaEventId = {
		ConstantName = "FeinaEventId",
		ConstantValue = 103010,
	},
	FollowCommunityEvent = {
		ConstantName = "FollowCommunityEvent",
		ConstantValue = 103008,
	},
	MiniGameCountdown = {
		ConstantName = "MiniGameCountdown",
		ConstantValue = 10,
	},
	PhotoWallLoadingNum = {
		ConstantName = "PhotoWallLoadingNum",
		ConstantValue = 12,
	},
	PictureCharacterLimit = {
		ConstantName = "PictureCharacterLimit",
		ConstantValue = 50,
	},
	PictureUploadLimit = {
		ConstantName = "PictureUploadLimit",
		ConstantValue = 20,
	},
	TransformResourceID = {
		ConstantName = "TransformResourceID",
		ConstantValue = 6000002,
	},
	ZhiLiuEntrustEventID = {
		ConstantName = "ZhiLiuEntrustEventID",
		ConstantValue = 103005,
	},
	ZhiLiuEntrustGrandReward = {
		ConstantName = "ZhiLiuEntrustGrandReward",
		ConstantValue = 110000,
	},
	ZhiLiuEntrustGrandRewardView = {
		ConstantName = "ZhiLiuEntrustGrandRewardView",
		ConstantValue = 1030052,
	},
	ZhiLiuEntrustRewardResource = {
		ConstantName = "ZhiLiuEntrustRewardResource",
		ConstantValue = 10100,
	},
	ZhiLiuEntrustRewardResourceNum = {
		ConstantName = "ZhiLiuEntrustRewardResourceNum",
		ConstantValue = 1,
	},
})
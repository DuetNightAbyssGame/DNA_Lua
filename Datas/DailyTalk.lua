-- Source Excel file path: ..\datas\Talk\DailyTalk.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("DailyTalk", {
	[88888801] = {
		RefreshRule = 1,
		RewardId = 3888,
		TalkTriggerId = 88888801,
	},
})
-- Source Excel file path: ..\datas\GameEvent\ComeBackEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ComeBackEventConstant", {
	CurrentEventId = {
		ConstantName = "CurrentEventId",
		ConstantValue = 114001,
	},
	CurrentEventSchemeId = {
		ConstantName = "CurrentEventSchemeId",
		ConstantValue = 114001,
	},
	CurrentEventTabId = {
		ConstantName = "CurrentEventTabId",
		ConstantValue = 53,
	},
	EventCD = {
		ConstantName = "EventCD",
		ConstantValue = 40,
	},
	EventDuration = {
		ConstantName = "EventDuration",
		ConstantValue = 14,
	},
	OfflineInterval = {
		ConstantName = "OfflineInterval",
		ConstantValue = 14,
	},
})
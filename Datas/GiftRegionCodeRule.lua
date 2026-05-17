-- Source Excel file path: ..\datas\Shop.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("GiftRegionCodeRule", {
	AR = {
		Recv = {
			"AR",
		},
		Sender = "AR",
	},
	BR = {
		Recv = {
			"BR",
		},
		Sender = "BR",
	},
	MX = {
		Recv = {
			"MX",
		},
		Sender = "MX",
	},
	RU = {
		Recv = {
			"RU",
		},
		Sender = "RU",
	},
	TR = {
		Recv = {
			"TR",
		},
		Sender = "TR",
	},
	UA = {
		Recv = {
			"UA",
		},
		Sender = "UA",
	},
})
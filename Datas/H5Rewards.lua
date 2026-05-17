-- Source Excel file path: ..\datas\H5Rewards.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("H5Rewards", {
	[18] = {
		asdaf1 = {
			MailID = {
				10001,
				10002,
				10003,
			},
			ServerId = 101,
			cid = 18,
			cuid = "asdaf1",
		},
	},
})
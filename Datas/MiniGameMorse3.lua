-- Source Excel file path: ..\datas\MiniGame\MiniGameMorse.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("MiniGameMorse3", {
	[1] = {
		Id = 1,
		PasswordLen = {
			2,
			3,
			4,
		},
		Turn = 3,
	},
})
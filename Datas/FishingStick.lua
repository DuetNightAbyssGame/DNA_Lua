-- Source Excel file path: ..\datas\Fishing.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("FishingStick", {
	[1] = {
		FishingStickId = 1,
		MoveCurve = {
			[1] = "OutSine",
			[2] = "InSine",
		},
		MoveParam = {
			[1] = 1.5,
			[2] = 0.9,
		},
	},
})
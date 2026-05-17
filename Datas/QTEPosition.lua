-- Source Excel file path: ..\datas\Talk\QTEPosition.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("QTEPosition", {
	[1] = {
		OffsetX = 150,
		OffsetY = -400,
		PositionId = 1,
	},
	[2] = {
		OffsetX = 350,
		OffsetY = 200,
		PositionId = 2,
	},
})
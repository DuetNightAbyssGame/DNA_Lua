-- Source Excel file path: ..\datas\Talk\TalkConfig.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("FreeCamera", {
	[1] = {
		BlockRange = 14,
		CameraControl = true,
		CameraHeight = 100,
		EaseExp = 2.5,
		FreeCameraId = 1,
		IfBlockThenRot = 20,
		MinCameraDistance = 140,
		PivotOffset = 40,
		PullDistance = 0,
		PushDistance = 1,
	},
})
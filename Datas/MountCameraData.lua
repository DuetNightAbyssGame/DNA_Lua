-- Source Excel file path: ..\datas\Combat\CameraControlData.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("MountCameraData", {
	Default = {
		BackwardLocation = {
			280,
			390,
			130,
		},
		CameraFocal = 38.6,
		CameraName = "Default",
		Ease = 14,
		ForwardLocation = {
			195,
			275,
			130,
		},
		Location = {
			240,
			315,
			130,
		},
		Rotation = {
			0,
			-4,
			-130,
		},
		Time = 1.2,
	},
})
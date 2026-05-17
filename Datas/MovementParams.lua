-- Source Excel file path: ..\datas\SlideSpline.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("MovementParams", {
	AccTime = {
		ParamValue = 2,
		SlideParam = "AccTime",
	},
	ActiveDeattachSpeedPer = {
		ParamValue = 1,
		SlideParam = "ActiveDeattachSpeedPer",
	},
	CanInteractiveAngle = {
		ParamValue = 45,
		SlideParam = "CanInteractiveAngle",
	},
	CanInteractiveDis = {
		ParamValue = 1000,
		SlideParam = "CanInteractiveDis",
	},
	FlySpeed = {
		ParamValue = 800,
		SlideParam = "FlySpeed",
	},
	PassiveDeattachSpeedPer = {
		ParamValue = 1.5,
		SlideParam = "PassiveDeattachSpeedPer",
	},
	SideJumpAttachTime = {
		ParamValue = 0.2,
		SlideParam = "SideJumpAttachTime",
	},
	Speed = {
		ParamValue = 500,
		SlideParam = "Speed",
	},
})
-- Source Excel file path: ..\datas\CharAccessory.xlsx
local T = {}
T.RT_1 = {
		-15,
		15,
	}
T.RT_2 = {
		-180,
		180,
	}
T.RT_3 = {
		0.5,
		1.5,
	}
T.RT_4 = {
		-10,
		10,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("CustomOffset", {
	Back = {
		AllowCustom = true,
		LocationLimit = T.RT_1,
		LocationUnit = 0.5,
		OffsetId = "Back",
		RotationLimit = T.RT_2,
		RotationUnit = 1,
		ScaleLimit = T.RT_3,
		ScaleUnit = 0.05,
	},
	Face = {
		AllowCustom = true,
		LocationLimit = {
			-5,
			5,
		},
		LocationUnit = 0.1,
		OffsetId = "Face",
		RotationLimit = T.RT_2,
		RotationUnit = 1,
		ScaleLimit = T.RT_3,
		ScaleUnit = 0.05,
	},
	Hat = {
		AllowCustom = true,
		LocationLimit = T.RT_4,
		LocationUnit = 0.5,
		OffsetId = "Hat",
		RotationLimit = T.RT_2,
		RotationUnit = 1,
		ScaleLimit = T.RT_3,
		ScaleUnit = 0.05,
	},
	Head = {
		AllowCustom = true,
		LocationLimit = T.RT_4,
		LocationUnit = 0.5,
		OffsetId = "Head",
		RotationLimit = {
			-90,
			90,
		},
		RotationUnit = 1,
		ScaleLimit = T.RT_3,
		ScaleUnit = 0.05,
	},
	Tail = {
		AllowCustom = true,
		LocationLimit = T.RT_1,
		LocationUnit = 0.5,
		OffsetId = "Tail",
		RotationLimit = T.RT_2,
		RotationUnit = 1,
		ScaleLimit = T.RT_3,
		ScaleUnit = 0.05,
	},
	Waist = {
		AllowCustom = true,
		LocationLimit = T.RT_1,
		LocationUnit = 0.5,
		OffsetId = "Waist",
		RotationLimit = T.RT_2,
		RotationUnit = 1,
		ScaleLimit = T.RT_3,
		ScaleUnit = 0.05,
	},
})
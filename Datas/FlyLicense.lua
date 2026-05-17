-- Source Excel file path: ..\datas\Mount.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("FlyLicense", {
	[1001] = {
		Des = "RESOURCE_DESC_301",
		FlyLicense = 1001,
		Name = "Mount_FlyLicense_01",
		Photo = "/Game/UI/Texture/Dynamic/Image/Mounts/T_Mounts_License01.T_Mounts_License01",
		Resource = {
			[1] = 301,
		},
	},
	[1002] = {
		Des = "RESOURCE_DESC_302",
		FlyLicense = 1002,
		Name = "Mount_FlyLicense_02",
		Photo = "/Game/UI/Texture/Dynamic/Image/Mounts/T_Mounts_License02.T_Mounts_License02",
		Resource = {
			[1] = 302,
		},
	},
})
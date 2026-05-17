-- Source Excel file path: ..\datas\UISpecialRule.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("AndroidSafeZoneRule", {
	HUAWEI = {
		["GRL-AL10"] = {
			[784] = {
				[720] = {
					DeviceMake = "HUAWEI",
					DeviceModel = "GRL-AL10",
					LRPadding = 0,
					UDPadding = 0,
					VSizeX = 784,
					VSizeY = 720,
				},
			},
			[1024] = {
				[720] = {
					DeviceMake = "HUAWEI",
					DeviceModel = "GRL-AL10",
					LRPadding = 0,
					UDPadding = 0,
					VSizeX = 1024,
					VSizeY = 720,
				},
			},
			[1592] = {
				[720] = {
					DeviceMake = "HUAWEI",
					DeviceModel = "GRL-AL10",
					LRPadding = 45,
					UDPadding = 0,
					VSizeX = 1592,
					VSizeY = 720,
				},
			},
		},
	},
})
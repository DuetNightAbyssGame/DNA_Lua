-- Source Excel file path: ..\datas\Fishing.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("FishingRegion", {
	[1] = {
		FishingRegionId = 1,
		FishingRegionName = "FishingRegion_Name_1",
		FishingSpotList = {
			10010101,
		},
		IconId = 1,
		IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_PurgatorioIsland",
	},
	[2] = {
		FishingRegionId = 2,
		FishingRegionName = "FishingRegion_Name_2",
		FishingSpotList = {
			10110301,
			10170101,
		},
		IconId = 2,
		IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_IceLake",
	},
	[3] = {
		FishingRegionId = 3,
		FishingRegionName = "FishingRegion_Name_3",
		FishingSpotList = {
			10410801,
			10411001,
			10410701,
			10410601,
			10410901,
		},
		IconId = 3,
		IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_East_Season01",
	},
	[4] = {
		FishingRegionId = 4,
		FishingRegionName = "FishingRegion_Name_4",
		FishingSpotList = {
			10450501,
			10450201,
			10550101,
			10450401,
		},
		IconId = 4,
		IconPath = "/Game/UI/Texture/Dynamic/Image/Area/T_Area_06.T_Area_06",
	},
})
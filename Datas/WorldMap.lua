-- Source Excel file path: ..\datas\Map.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("WorldMap", {
	[1] = {
		RegionIcon = "/Game/UI/Texture/Dynamic/Image/Chapter/T_Chapter_Icon01.T_Chapter_Icon01",
		RegionName = "UI_WORLDMAP_REGIONNAME_3",
		RegionUIIndex = 3,
		UIIndex = 3,
		WorldMapId = 1,
		WorldMapName = "UI_WORLDMAP_NAME_1",
		WorldMapRegion = {
			100,
		},
	},
	[2] = {
		RegionIcon = "/Game/UI/Texture/Dynamic/Image/Chapter/T_Chapter_Icon01.T_Chapter_Icon01",
		RegionName = "UI_WORLDMAP_REGIONNAME_1",
		RegionUIIndex = 1,
		UIIndex = 2,
		WorldMapId = 2,
		WorldMapName = "UI_WORLDMAP_NAME_2",
		WorldMapRegion = {
			200,
			201,
			202,
			203,
			204,
		},
		WorldMapUnlockCondition = 26,
	},
	[3] = {
		RegionIcon = "/Game/UI/Texture/Dynamic/Image/Chapter/T_Chapter_Icon02.T_Chapter_Icon02",
		RegionName = "UI_WORLDMAP_REGIONNAME_1",
		RegionUIIndex = 1,
		UIIndex = 1,
		UIRegionType = "EX",
		WorldMapId = 3,
		WorldMapName = "UI_WORLDMAP_NAME_3",
		WorldMapRegion = {
			300,
		},
		WorldMapUnlockCondition = 11010103,
	},
	[4] = {
		RegionIcon = "/Game/UI/Texture/Dynamic/Image/Chapter/T_Chapter_Icon03.T_Chapter_Icon03",
		RegionName = "UI_WORLDMAP_REGIONNAME_2",
		RegionUIIndex = 2,
		UIIndex = 5,
		WorldMapId = 4,
		WorldMapName = "UI_WORLDMAP_NAME_4",
		WorldMapRegion = {
			400,
			401,
		},
		WorldMapUnlockCondition = 325,
	},
	[5] = {
		RegionIcon = "/Game/UI/Texture/Dynamic/Image/Chapter/T_Chapter_Icon03.T_Chapter_Icon03",
		RegionName = "UI_WORLDMAP_REGIONNAME_2",
		RegionUIIndex = 2,
		UIIndex = 6,
		WorldMapId = 5,
		WorldMapName = "UI_WORLDMAP_NAME_6",
		WorldMapRegion = {
			500,
			501,
			502,
			503,
		},
		WorldMapUnlockCondition = 12020101,
	},
})
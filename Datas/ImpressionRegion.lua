-- Source Excel file path: ..\datas\Talk\Impression.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ImpressionRegion", {
	[1011] = {
		Icon = "/Game/UI/Texture/Dynamic/Image/Area/T_Area_01.T_Area_01",
		ImpressionRegionId = 1011,
		RegionId = {
			2101,
			1001,
			1011,
			1013,
			1014,
			1017,
			1018,
			1019,
			1021,
			1022,
			1031,
			1032,
		},
		RegionName = "ImpressionRegionName_1011",
		RegionPointId = 2612,
		UIName = "DimensionGraph_Hyper",
	},
	[1041] = {
		Icon = "/Game/UI/Texture/Dynamic/Image/Area/T_Area_05.T_Area_05",
		ImpressionRegionId = 1041,
		RegionId = {
			1041,
			1049,
			1057,
			1045,
			1048,
			1051,
			1052,
			1053,
			1054,
			1055,
			1056,
		},
		RegionName = "ImpressionRegionName_1041",
		RegionPointId = 2826,
		UIName = "DimensionGraph_East",
	},
})
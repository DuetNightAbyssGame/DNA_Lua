-- Source Excel file path: ..\datas\GameEvent\TempleEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("TempleEventType", {
	[1080011] = {
		EventId = 108001,
		GUIPath = "/Game/UI/Texture/Dynamic/Atlas/Activity/Temple/Solo/T_Activity_Temple_Solo_IconType_03.T_Activity_Temple_Solo_IconType_03",
		TempleTypeId = 1080011,
		TempleTypeName = "UI_TempleEvent_Ball",
	},
	[1080012] = {
		EventId = 108001,
		GUIPath = "/Game/UI/Texture/Dynamic/Atlas/Activity/Temple/Solo/T_Activity_Temple_Solo_IconType_01.T_Activity_Temple_Solo_IconType_01",
		TempleTypeId = 1080012,
		TempleTypeName = "UI_TempleEvent_Shot",
	},
	[1080013] = {
		EventId = 108001,
		GUIPath = "/Game/UI/Texture/Dynamic/Atlas/Activity/Temple/Solo/T_Activity_Temple_Solo_IconType_02.T_Activity_Temple_Solo_IconType_02",
		TempleTypeId = 1080013,
		TempleTypeName = "UI_TempleEvent_ShiftShot",
	},
})
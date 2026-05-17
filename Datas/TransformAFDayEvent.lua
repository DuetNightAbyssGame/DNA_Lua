-- Source Excel file path: ..\datas\GameEvent\AprilFoolsDayEvent2026.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("TransformAFDayEvent", {
	[1] = {
		Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/T_Activity_Fool_ChangeItem01.T_Activity_Fool_ChangeItem01",
		StaticMeshPath = "/Game/Asset/Char/Player/Common/Part/Show/Mesh/SM_Show_Hide01.SM_Show_Hide01",
		TransformID = 1,
	},
	[2] = {
		Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/T_Activity_Fool_ChangeItem17.T_Activity_Fool_ChangeItem17",
		StaticMeshPath = "/Game/Asset/Char/Player/Common/Part/Show/Mesh/SM_Show_Hide02.SM_Show_Hide02",
		TransformID = 2,
	},
	[5] = {
		Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/T_Activity_Fool_ChangeItem09.T_Activity_Fool_ChangeItem09",
		StaticMeshPath = "/Game/Asset/Char/Player/Common/Part/Show/Mesh/SM_Show_Hide06.SM_Show_Hide06",
		TransformID = 5,
	},
	[6] = {
		Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/T_Activity_Fool_ChangeItem10.T_Activity_Fool_ChangeItem10",
		StaticMeshPath = "/Game/Asset/Char/Player/Common/Part/Show/Mesh/SM_Show_Hide07.SM_Show_Hide07",
		TransformID = 6,
	},
	[7] = {
		Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/T_Activity_Fool_ChangeItem19.T_Activity_Fool_ChangeItem19",
		StaticMeshPath = "/Game/Asset/Char/Player/Common/Part/Show/Mesh/SM_Show_Hide08.SM_Show_Hide08",
		TransformID = 7,
	},
	[8] = {
		Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/T_Activity_Fool_ChangeItem11.T_Activity_Fool_ChangeItem11",
		StaticMeshPath = "/Game/Asset/Char/Player/Common/Part/Show/Mesh/SM_Show_Hide09.SM_Show_Hide09",
		TransformID = 8,
	},
	[10] = {
		Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/T_Activity_Fool_ChangeItem08.T_Activity_Fool_ChangeItem08",
		StaticMeshPath = "/Game/Asset/Char/Player/Common/Part/Show/Mesh/SM_Show_Hide11.SM_Show_Hide11",
		TransformID = 10,
	},
	[11] = {
		Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/T_Activity_Fool_ChangeItem12.T_Activity_Fool_ChangeItem12",
		StaticMeshPath = "/Game/Asset/Char/Player/Common/Part/Show/Mesh/SM_Show_Hide12.SM_Show_Hide12",
		TransformID = 11,
	},
	[12] = {
		Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/T_Activity_Fool_ChangeItem13.T_Activity_Fool_ChangeItem13",
		StaticMeshPath = "/Game/Asset/Char/Player/Common/Part/Show/Mesh/SM_Show_Hide13.SM_Show_Hide13",
		TransformID = 12,
	},
	[13] = {
		Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/T_Activity_Fool_ChangeItem14.T_Activity_Fool_ChangeItem14",
		StaticMeshPath = "/Game/Asset/Char/Player/Common/Part/Show/Mesh/SM_Show_Hide14.SM_Show_Hide14",
		TransformID = 13,
	},
	[14] = {
		Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/T_Activity_Fool_ChangeItem15.T_Activity_Fool_ChangeItem15",
		StaticMeshPath = "/Game/Asset/Char/Player/Common/Part/Show/Mesh/SM_Show_Hide15.SM_Show_Hide15",
		TransformID = 14,
	},
})
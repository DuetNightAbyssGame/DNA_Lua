-- Source Excel file path: ..\datas\PatchResource.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("PatchResource", {
	Patch_East = {
		Background = "WidgetBlueprint'/Game/UI/WBP/Fame/Widget/Region/WBP_Fame_Bg_Yanjindu.WBP_Fame_Bg_Yanjindu'",
		Desc = "Patch_East_Desc",
		Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Download/T_Download_Image02.T_Download_Image02'",
		Name = "Patch_East_Name",
		PatchId = "Patch_East",
		SortPriority = 2,
		TitleBP = "WidgetBlueprint'/Game/UI/WBP/Download/Widget/Title/WBP_Download_ContentTitle02.WBP_Download_ContentTitle02'",
	},
	Patch_Icelake = {
		Background = "WidgetBlueprint'/Game/UI/WBP/Fame/Widget/Region/WBP_Fame_Bg_IceLake.WBP_Fame_Bg_IceLake'",
		Desc = "Patch_Icelake_Desc",
		Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Download/T_Download_Image01.T_Download_Image01'",
		Name = "Patch_Icelake_Name",
		PatchId = "Patch_Icelake",
		SortPriority = 1,
		TitleBP = "WidgetBlueprint'/Game/UI/WBP/Download/Widget/Title/WBP_Download_ContentTitle01.WBP_Download_ContentTitle01'",
	},
})
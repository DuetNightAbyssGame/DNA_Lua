-- Source Excel file path: ..\datas\Fishing.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("FishingMontage", {
	[1] = {
		MontageId = 1,
		MontageName = "Fish_StartFish_Montage",
	},
	[2] = {
		MontageId = 2,
		MontageName = "Fish_GetFish_Montage",
	},
	[3] = {
		MontageId = 3,
		MontageName = "Fish_GetFishEnd_Montage",
	},
	[4] = {
		MontageId = 4,
		MontageName = "Fish_Prepare_Montage",
	},
})
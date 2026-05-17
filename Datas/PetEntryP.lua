-- Source Excel file path: ..\datas\Pet.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("PetEntryP", {
	[3] = {
		Probability = 60,
		Rarity = 3,
		ResourceCount = 10000,
		ResourceID = 101,
	},
	[4] = {
		Probability = 10,
		Rarity = 4,
		ResourceCount = 10000,
		ResourceID = 101,
	},
	[5] = {
		Probability = 3,
		Rarity = 5,
		ResourceCount = 10000,
		ResourceID = 101,
	},
})
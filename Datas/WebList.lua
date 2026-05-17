-- Source Excel file path: ..\datas\GameEvent\WebJumpEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("WebList", {
	[1] = {
		PCJumpLink = "https://dna.yingxiong.com/hd/",
		PhoneJumpLink = "https://dna.yingxiong.com/hd/",
		WebId = 1,
	},
	[2] = {
		PCJumpLink = "https://duetnightabyss.dna-panstudio.com/dna-event/",
		PhoneJumpLink = "https://duetnightabyss.dna-panstudio.com/dna-event/",
		WebId = 2,
	},
	[3] = {
		PCJumpLink = "https://duetnightabyss.dna-panstudio.com/dna-event/",
		PhoneJumpLink = "https://duetnightabyss.dna-panstudio.com/dna-event/",
		WebId = 3,
	},
	[4] = {
		PCJumpLink = "https://duetnightabyss.dna-panstudio.com/dna-event/",
		PhoneJumpLink = "https://duetnightabyss.dna-panstudio.com/dna-event/",
		WebId = 4,
	},
	[5] = {
		PCJumpLink = "https://duetnightabyss.dna-panstudio.com/dna-event/",
		PhoneJumpLink = "https://duetnightabyss.dna-panstudio.com/dna-event/",
		WebId = 5,
	},
	[6] = {
		PCJumpLink = "https://duetnightabyss.dna-panstudio.com/dna-event/",
		PhoneJumpLink = "https://duetnightabyss.dna-panstudio.com/dna-event/",
		WebId = 6,
	},
})
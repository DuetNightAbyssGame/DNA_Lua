-- Source Excel file path: ..\datas\GameEvent\ComeBackEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("InviteEventScheme", {
	[114001] = {
		America = {
			InviteEventSchemeId = 114001,
			PCJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/en?source=game",
			PhoneJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/en?source=game",
			ServerId = "America",
		},
		Asian = {
			InviteEventSchemeId = 114001,
			PCJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling?source=game",
			PhoneJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling?source=game",
			ServerId = "Asian",
		},
		China = {
			InviteEventSchemeId = 114001,
			PCJumpLink = "https://dna.yingxiong.com/atlasiacalling/#/?source=game",
			PhoneJumpLink = "https://dna.yingxiong.com/atlasiacalling/#/?source=game",
			ServerId = "China",
		},
		Europe = {
			InviteEventSchemeId = 114001,
			PCJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/en?source=game",
			PhoneJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/en?source=game",
			ServerId = "Europe",
		},
		HMT = {
			InviteEventSchemeId = 114001,
			PCJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/zh-tw?source=game",
			PhoneJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/zh-tw?source=game",
			ServerId = "HMT",
		},
		SEA = {
			InviteEventSchemeId = 114001,
			PCJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/en?source=game",
			PhoneJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/en?source=game",
			ServerId = "SEA",
		},
	},
})
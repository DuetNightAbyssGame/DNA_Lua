-- Source Excel file path: ..\datas\GameEvent\FollowCommunityEvent.xlsx
local T = {}
T.RT_1 = {
		4,
		5,
		6,
		7,
		8,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("FollowCommunityEvent", {
	AbroadCN = {
		CommunityList = T.RT_1,
		Languagetype = "AbroadCN",
	},
	AbroadDE = {
		CommunityList = T.RT_1,
		Languagetype = "AbroadDE",
	},
	AbroadEN = {
		CommunityList = {
			4,
			6,
			5,
			7,
			8,
			9,
			10,
			11,
		},
		Languagetype = "AbroadEN",
	},
	AbroadES = {
		CommunityList = T.RT_1,
		Languagetype = "AbroadES",
	},
	AbroadFR = {
		CommunityList = T.RT_1,
		Languagetype = "AbroadFR",
	},
	AbroadJP = {
		CommunityList = {
			4,
			6,
			5,
			7,
			8,
			11,
		},
		Languagetype = "AbroadJP",
	},
	AbroadKR = {
		CommunityList = {
			4,
			6,
			5,
			7,
			12,
			8,
		},
		Languagetype = "AbroadKR",
	},
	AbroadTC = {
		CommunityList = T.RT_1,
		Languagetype = "AbroadTC",
	},
	ChinaCN = {
		CommunityList = {
			1,
			2,
			3,
		},
		Languagetype = "ChinaCN",
	},
})
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("SteamAchievement", {
	[1] = {
		["AchvId"] = 8010101,
		["SteamAPIName"] = "STEAM_ACH_8010101",
	},
	[2] = {
		["AchvId"] = 50131701,
		["SteamAPIName"] = "STEAM_ACH_50131701",
	},
	[3] = {
		["AchvId"] = 20101,
		["SteamAPIName"] = "STEAM_ACH_20101",
	},
	[4] = {
		["AchvId"] = 9910301,
		["SteamAPIName"] = "STEAM_ACH_9910301",
	},
	[5] = {
		["AchvId"] = 1005170101,
		["SteamAPIName"] = "STEAM_ACH_1005170101",
	},
})
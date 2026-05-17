local T = {}
T.RT_1 = {
	[0] = 160101,
	[1] = 1601,
}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("Player2RoleId", {
	["EXPlayer"] = {
		[0] = 114,
		[1] = 113,
	},
	["Player"] = T.RT_1,
	["PlayerLight"] = T.RT_1,
	["PlayerRed"] = {
		[0] = 160103,
		[1] = 160102,
	},
})
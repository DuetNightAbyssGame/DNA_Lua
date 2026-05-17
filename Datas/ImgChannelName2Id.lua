local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ImgChannelName2Id", {
	["bilibili"] = {
		[1] = 46,
		[2] = 269,
	},
	["cloud"] = {
		[1] = 314,
		[2] = 301,
		[3] = 300,
	},
	["hero"] = {
		[1] = 160,
		[2] = 171,
		[3] = 18,
		[4] = 237,
		[5] = 240,
		[6] = 56,
		[7] = 305,
		[8] = 315,
		[9] = 295,
	},
	["lenovo"] = {
		[1] = 297,
	},
	["oppo"] = {
		[1] = 303,
	},
	["wegame"] = {
		[1] = 286,
	},
})
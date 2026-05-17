local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("DialogueOptionNode2ImprNode", {
	[51127901] = {
		[51127906] = {
			[51127902] = 1,
			["Count"] = 1,
		},
		[51127911] = {
			[51127907] = 1,
			["Count"] = 1,
		},
	},
})
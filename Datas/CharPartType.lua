local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("CharPartType", {
	["Back"] = 1,
	["Body"] = 1,
	["Hair"] = 1,
	["Hat"] = 1,
	["Tail"] = 1,
})
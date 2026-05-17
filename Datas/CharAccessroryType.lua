local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("CharAccessroryType", {
	["Back"] = 1,
	["FX_Body"] = 1,
	["FX_Dead"] = 1,
	["FX_Footprint"] = 1,
	["FX_HelixLeap"] = 1,
	["FX_PlungingATK"] = 1,
	["FX_Teleport"] = 1,
	["Face"] = 1,
	["Hair"] = 1,
	["Hat"] = 1,
	["Head"] = 1,
	["MVP"] = 1,
	["Tail"] = 1,
	["Waist"] = 1,
})
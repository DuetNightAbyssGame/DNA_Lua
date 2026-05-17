-- Source Excel file path: ..\datas\Combat\Buff.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("BuffSpecialEffect", {
	Breakable = {
		Breakable = 1,
		SpecialEffect = "Breakable",
	},
	Invincible = {
		Invincible = 1,
		SpecialEffect = "Invincible",
	},
	Invisible = {
		Invisible = 1,
		SpecialEffect = "Invisible",
	},
	Stealth = {
		SpecialEffect = "Stealth",
		Stealth = 1,
	},
	Taunt = {
		SpecialEffect = "Taunt",
	},
	Translucency = {
		SpecialEffect = "Translucency",
		Translucency = 1,
	},
})
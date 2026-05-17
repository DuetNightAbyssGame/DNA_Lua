local T = {}
T.RT_1 = {
	[1] = "TERM_Common_SkillSpeed",
}
T.RT_2 = {
	[1] = "TERM_Common_OverES",
}
T.RT_3 = {
	[1] = "TERM_Common_AdditionalDmg",
}
T.RT_4 = {
	[1] = "TERM_Common_Taunt",
}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("Desc2ProperTerm", {
	[404] = T.RT_2,
	[414] = T.RT_2,
	[426] = T.RT_3,
	[601] = T.RT_1,
	[150404] = T.RT_2,
	[160102] = T.RT_2,
	[160192] = T.RT_2,
	[180103] = T.RT_3,
	[240102] = T.RT_2,
	[240103] = T.RT_1,
	[320102] = T.RT_4,
	[320104] = T.RT_4,
	[410201] = T.RT_2,
	[420202] = T.RT_2,
	[420203] = T.RT_2,
	[510202] = T.RT_2,
	[530102] = T.RT_2,
})
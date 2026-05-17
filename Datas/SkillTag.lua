-- Source Excel file path: ..\datas\Combat\SKill\SkillType.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("SkillTag", {
	NotRealSkill1 = {
		SkillTag = "NotRealSkill1",
	},
	NotRealSkill2 = {
		SkillTag = "NotRealSkill2",
	},
})
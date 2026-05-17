-- Source Excel file path: ..\datas\Combat\StateMachine.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("TagType", {
	Avoid = {
		TagType = "Avoid",
	},
	Controlled = {
		TagType = "Controlled",
	},
	Crouch = {
		TagType = "Crouch",
	},
	Hit = {
		TagType = "Hit",
	},
	Interactive = {
		TagType = "Interactive",
	},
	LandHeavy = {
		TagType = "LandHeavy",
	},
	Move = {
		TagType = "Move",
	},
	Seating = {
		TagType = "Seating",
	},
	Shooting = {
		TagType = "Shooting",
	},
	Skill = {
		TagType = "Skill",
	},
	Slide = {
		TagType = "Slide",
	},
})
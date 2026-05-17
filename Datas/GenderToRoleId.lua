-- Source Excel file path: ..\datas\GenderToRoleId.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("GenderToRoleId", {
	[1] = {
		Gender = 1,
		GenderToRoleId = 1,
		RoleId = 1601,
		SwitchPlayer = "Player",
	},
	[2] = {
		Gender = 0,
		GenderToRoleId = 2,
		RoleId = 160101,
		SwitchPlayer = "Player",
	},
	[3] = {
		Gender = 1,
		GenderToRoleId = 3,
		RoleId = 113,
		SwitchPlayer = "EXPlayer",
	},
	[4] = {
		Gender = 0,
		GenderToRoleId = 4,
		RoleId = 114,
		SwitchPlayer = "EXPlayer",
	},
	[5] = {
		Gender = 1,
		GenderToRoleId = 5,
		RoleId = 1601,
		SwitchPlayer = "PlayerLight",
	},
	[6] = {
		Gender = 0,
		GenderToRoleId = 6,
		RoleId = 160101,
		SwitchPlayer = "PlayerLight",
	},
	[7] = {
		Gender = 1,
		GenderToRoleId = 7,
		RoleId = 160102,
		SwitchPlayer = "PlayerRed",
	},
	[8] = {
		Gender = 0,
		GenderToRoleId = 8,
		RoleId = 160103,
		SwitchPlayer = "PlayerRed",
	},
})
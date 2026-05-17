-- Source Excel file path: ..\datas\RaidDungeon.xlsx
local T = {}
T.RT_1 = {
		[1] = "$#GlobalPassiveData[30101].Vars.Divider*100$%",
		[2] = "$#GlobalPassiveData[30101].Vars.Penetration*100$%",
		[3] = "$(#GlobalPassiveData[30101].Vars.MaxSkillInten-1)/(#GlobalPassiveData[30101].Vars.Divider)*(#GlobalPassiveData[30101].Vars.Penetration)*100$%",
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("RaidBuff", {
	[1] = {
		RaidBuffDes = "Raid_Buff_11",
		RaidBuffID = 1,
		RaidBuffParameter = T.RT_1,
	},
	[2] = {
		RaidBuffDes = "Raid_Buff_11",
		RaidBuffID = 2,
		RaidBuffParameter = T.RT_1,
	},
	[3] = {
		RaidBuffDes = "Raid_Buff_11",
		RaidBuffID = 3,
		RaidBuffParameter = T.RT_1,
	},
	[12] = {
		RaidBuffDes = "Raid_Buff_12",
		RaidBuffID = 12,
		RaidBuffParameter = {
			[1] = "$#GlobalPassiveData[30102].Vars.Divider*100$%",
			[2] = "$#GlobalPassiveData[30102].Vars.Penetration*100$%",
			[3] = "$(#GlobalPassiveData[30102].Vars.MaxSkillInten-1)/(#GlobalPassiveData[30102].Vars.Divider)*(#GlobalPassiveData[30102].Vars.Penetration)*100$%",
		},
	},
	[13] = {
		RaidBuffDes = "Raid_Buff_13",
		RaidBuffID = 13,
		RaidBuffParameter = {
			[1] = "$#GlobalPassiveData[30103].Vars.Divider1*100$%",
			[2] = "$#GlobalPassiveData[30103].Vars.Penetration1*100$%",
			[3] = "$(#GlobalPassiveData[30103].Vars.MaxRange)/(#GlobalPassiveData[30103].Vars.Divider1)*(#GlobalPassiveData[30103].Vars.Penetration1)*100$%",
			[4] = "$#GlobalPassiveData[30103].Vars.Divider2*100$%",
			[5] = "$#GlobalPassiveData[30103].Vars.Penetration2*100$%",
			[6] = "$(#GlobalPassiveData[30103].Vars.MaxSustain)/(#GlobalPassiveData[30103].Vars.Divider2)*(#GlobalPassiveData[30103].Vars.Penetration2)*100$%",
		},
	},
})
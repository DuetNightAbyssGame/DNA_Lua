-- Source Excel file path: ..\datas\Combat\AIBattleMgr.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("MonsterConstant", {
	OutBattleBornPointDis = {
		ConstantName = "OutBattleBornPointDis",
		ConstantValue = 5000,
	},
	OutBattleTargetBornPointDis = {
		ConstantName = "OutBattleTargetBornPointDis",
		ConstantValue = 10000,
	},
	OutBattleTargetDis = {
		ConstantName = "OutBattleTargetDis",
		ConstantValue = 10000,
	},
})
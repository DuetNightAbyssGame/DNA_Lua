-- Source Excel file path: ..\datas\Combat\CombatTest\Test_Monster.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("MonsterTest", {
	[7002001] = {
		BTName = "BT_Test",
		UnitId = 7002001,
	},
})
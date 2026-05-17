-- Source Excel file path: ..\datas\VisualEffect.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("BatchFXConfig", {
	["/Game/Asset/Effect/Niagara/Player/Zhiliu/NS_Zhiliu_Skill01_Fuzhou_Batch"] = {
		EffectPath = "/Game/Asset/Effect/Niagara/Player/Zhiliu/NS_Zhiliu_Skill01_Fuzhou_Batch",
		bTickEvenWhenPaused = true,
	},
})
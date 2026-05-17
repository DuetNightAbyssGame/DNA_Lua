-- Source Excel file path: ..\datas\VisualEffect.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("FootstepFX", {
	Common_Bian = {
		EffectPath = "/Game/Asset/Effect/Niagara/Steed/Common/NS_Bian_FootSteps_Dust.NS_Bian_FootSteps_Dust",
		EffectPathForFastState = "/Game/Asset/Effect/Niagara/Steed/Common/NS_Bian_FootSteps_Dust.NS_Bian_FootSteps_Dust",
		EffectPathForSlowState = "/Game/Asset/Effect/Niagara/Steed/Common/NS_Bian_FootSteps_Dust.NS_Bian_FootSteps_Dust",
		PhysicalSurface = "Common_Bian",
	},
	Common_SongluSummon = {
		EffectPath = "/Game/Asset/Effect/Niagara/Player/Songlu/NS_Songlu_Skill02_Foot.NS_Songlu_Skill02_Foot",
		EffectPathForFastState = "/Game/Asset/Effect/Niagara/Player/Songlu/NS_Songlu_Skill02_Foot.NS_Songlu_Skill02_Foot",
		EffectPathForSlowState = "/Game/Asset/Effect/Niagara/Player/Songlu/NS_Songlu_Skill02_Foot.NS_Songlu_Skill02_Foot",
		PhysicalSurface = "Common_SongluSummon",
	},
	DeepWater = {
		EffectPath = "/Game/Asset/Effect/Niagara/Player/A_Common/NS_EastNai_FootSteps01.NS_EastNai_FootSteps01",
		EffectPathForFastState = "/Game/Asset/Effect/Niagara/Player/A_Common/NS_EastNai_FootSteps01.NS_EastNai_FootSteps01",
		EffectPathForSlowState = "/Game/Asset/Effect/Niagara/Player/A_Common/NS_EastNai_FootSteps01.NS_EastNai_FootSteps01",
		PhysicalSurface = "DeepWater",
	},
	Grass = {
		EffectPath = "NiagaraDataChannelAsset'/Game/Asset/Effect/Niagara/Player/A_Common/NDC/NDC_FootSteps_Dust.NDC_FootSteps_Dust'",
		EffectPathForFastState = "NiagaraDataChannelAsset'/Game/Asset/Effect/Niagara/Player/A_Common/NDC/NDC_FootSteps_Dust.NDC_FootSteps_Dust'",
		EffectPathForSlowState = "NiagaraDataChannelAsset'/Game/Asset/Effect/Niagara/Player/A_Common/NDC/NDC_FootSteps_Dust.NDC_FootSteps_Dust'",
		PhysicalSurface = "Grass",
	},
	Grass_Bai = {
		EffectPath = "/Game/Asset/Effect/Niagara/NPC/Bai/NS_Bai_FootSteps_Dust.NS_Bai_FootSteps_Dust",
		EffectPathForFastState = "/Game/Asset/Effect/Niagara/NPC/Bai/NS_Bai_FootSteps_Dust.NS_Bai_FootSteps_Dust",
		EffectPathForSlowState = "/Game/Asset/Effect/Niagara/NPC/Bai/NS_Bai_FootSteps_Dust.NS_Bai_FootSteps_Dust",
		PhysicalSurface = "Grass_Bai",
	},
	Mud = {
		EffectPath = "NiagaraDataChannelAsset'/Game/Asset/Effect/Niagara/Player/A_Common/NDC/NDC_FootSteps_Mud.NDC_FootSteps_Mud'",
		EffectPathForFastState = "NiagaraDataChannelAsset'/Game/Asset/Effect/Niagara/Player/A_Common/NDC/NDC_FootSteps_Mud.NDC_FootSteps_Mud'",
		EffectPathForSlowState = "/Game/Asset/Effect/Niagara/Player/A_Common/NS_FootSteps_MudWalk.NS_FootSteps_MudWalk",
		PhysicalSurface = "Mud",
	},
	Mud_Bian_L = {
		EffectPath = "/Game/Asset/Effect/Blueprint/Child/EF_BP_Decal_Footstep_Mud_L_Bian.EF_BP_Decal_Footstep_Mud_L_Bian",
		EffectPathForFastState = "/Game/Asset/Effect/Blueprint/Child/EF_BP_Decal_Footstep_Mud_L_Bian.EF_BP_Decal_Footstep_Mud_L_Bian",
		EffectPathForSlowState = "/Game/Asset/Effect/Blueprint/Child/EF_BP_Decal_Footstep_Mud_L_Bian.EF_BP_Decal_Footstep_Mud_L_Bian",
		PhysicalSurface = "Mud_Bian_L",
	},
	Mud_Bian_R = {
		EffectPath = "/Game/Asset/Effect/Blueprint/Child/EF_BP_Decal_Footstep_Mud_R_Bian.EF_BP_Decal_Footstep_Mud_R_Bian",
		EffectPathForFastState = "/Game/Asset/Effect/Blueprint/Child/EF_BP_Decal_Footstep_Mud_R_Bian.EF_BP_Decal_Footstep_Mud_R_Bian",
		EffectPathForSlowState = "/Game/Asset/Effect/Blueprint/Child/EF_BP_Decal_Footstep_Mud_R_Bian.EF_BP_Decal_Footstep_Mud_R_Bian",
		PhysicalSurface = "Mud_Bian_R",
	},
	Mud_L = {
		EffectPath = "/Game/Asset/Effect/Blueprint/Child/EF_BP_Decal_Footstep_Mud_L.EF_BP_Decal_Footstep_Mud_L",
		EffectPathForFastState = "/Game/Asset/Effect/Blueprint/Child/EF_BP_Decal_Footstep_Mud_L.EF_BP_Decal_Footstep_Mud_L",
		EffectPathForSlowState = "/Game/Asset/Effect/Blueprint/Child/EF_BP_Decal_Footstep_Mud_L.EF_BP_Decal_Footstep_Mud_L",
		PhysicalSurface = "Mud_L",
	},
	Mud_R = {
		EffectPath = "/Game/Asset/Effect/Blueprint/Child/EF_BP_Decal_Footstep_Mud_R.EF_BP_Decal_Footstep_Mud_R",
		EffectPathForFastState = "/Game/Asset/Effect/Blueprint/Child/EF_BP_Decal_Footstep_Mud_R.EF_BP_Decal_Footstep_Mud_R",
		EffectPathForSlowState = "/Game/Asset/Effect/Blueprint/Child/EF_BP_Decal_Footstep_Mud_R.EF_BP_Decal_Footstep_Mud_R",
		PhysicalSurface = "Mud_R",
	},
	None = {
		PhysicalSurface = "None",
	},
	None_Bai = {
		EffectPath = "/Game/Asset/Effect/Niagara/NPC/Bai/NS_Bai_FootSteps_Dust.NS_Bai_FootSteps_Dust",
		EffectPathForFastState = "/Game/Asset/Effect/Niagara/NPC/Bai/NS_Bai_FootSteps_Dust.NS_Bai_FootSteps_Dust",
		EffectPathForSlowState = "/Game/Asset/Effect/Niagara/NPC/Bai/NS_Bai_FootSteps_Dust.NS_Bai_FootSteps_Dust",
		PhysicalSurface = "None_Bai",
	},
	None_Bian = {
		EffectPath = "/Game/Asset/Effect/Niagara/Steed/Common/NS_Bian_FootSteps_Dust.NS_Bian_FootSteps_Dust",
		EffectPathForFastState = "/Game/Asset/Effect/Niagara/Steed/Common/NS_Bian_FootSteps_Dust.NS_Bian_FootSteps_Dust",
		EffectPathForSlowState = "/Game/Asset/Effect/Niagara/Steed/Common/NS_Bian_FootSteps_Dust.NS_Bian_FootSteps_Dust",
		PhysicalSurface = "None_Bian",
	},
	Sand = {
		EffectPath = "/Game/Asset/Effect/Niagara/Player/A_Common/NDC/NDC_FootSteps_Sand.NDC_FootSteps_Sand",
		EffectPathForFastState = "/Game/Asset/Effect/Niagara/Player/A_Common/NDC/NDC_FootSteps_Sand.NDC_FootSteps_Sand",
		EffectPathForSlowState = "/Game/Asset/Effect/Niagara/Player/A_Common/NS_FootSteps_SandWalk.NS_FootSteps_SandWalk",
		PhysicalSurface = "Sand",
	},
	SandSea = {
		EffectPath = "/Game/Asset/Effect/Niagara/Player/A_Common/NS_FootSteps_SandSeaWalk.NS_FootSteps_SandSeaWalk",
		EffectPathForFastState = "/Game/Asset/Effect/Niagara/Player/A_Common/NS_FootSteps_SandSeaWalk.NS_FootSteps_SandSeaWalk",
		EffectPathForSlowState = "/Game/Asset/Effect/Niagara/Player/A_Common/NS_FootSteps_SandSeaWalk.NS_FootSteps_SandSeaWalk",
		PhysicalSurface = "SandSea",
	},
	Snow = {
		EffectPath = "/Game/Asset/Effect/Niagara/Player/A_Common/NDC/NDC_FootSteps_Snow.NDC_FootSteps_Snow",
		EffectPathForFastState = "/Game/Asset/Effect/Niagara/Player/A_Common/NDC/NDC_FootSteps_Snow.NDC_FootSteps_Snow",
		EffectPathForSlowState = "/Game/Asset/Effect/Niagara/Player/A_Common/NDC/NDC_FootSteps_Snow.NDC_FootSteps_Snow",
		PhysicalSurface = "Snow",
	},
	Snow_Bai = {
		EffectPath = "/Game/Asset/Effect/Niagara/Player/A_Common/NDC/NDC_FootSteps_Snow.NDC_FootSteps_Snow",
		EffectPathForFastState = "/Game/Asset/Effect/Niagara/Player/A_Common/NDC/NDC_FootSteps_Snow.NDC_FootSteps_Snow",
		EffectPathForSlowState = "/Game/Asset/Effect/Niagara/Player/A_Common/NDC/NDC_FootSteps_Snow.NDC_FootSteps_Snow",
		PhysicalSurface = "Snow_Bai",
	},
	Snow_Bian = {
		EffectPath = "/Game/Asset/Effect/Niagara/Steed/Common/NS_Bian_FootSteps_Snow.NS_Bian_FootSteps_Snow",
		EffectPathForFastState = "/Game/Asset/Effect/Niagara/Steed/Common/NS_Bian_FootSteps_Snow.NS_Bian_FootSteps_Snow",
		EffectPathForSlowState = "/Game/Asset/Effect/Niagara/Steed/Common/NS_Bian_FootSteps_Snow.NS_Bian_FootSteps_Snow",
		PhysicalSurface = "Snow_Bian",
	},
	Water = {
		EffectPath = "/Game/Asset/Effect/Niagara/Player/A_Common/NDC/NDC_FootSteps_Water.NDC_FootSteps_Water",
		EffectPathForFastState = "/Game/Asset/Effect/Niagara/Player/A_Common/NDC/NDC_FootSteps_Water.NDC_FootSteps_Water",
		EffectPathForSlowState = "/Game/Asset/Effect/Niagara/Player/A_Common/NS_FootSteps_WaterWalk.NS_FootSteps_WaterWalk",
		PhysicalSurface = "Water",
	},
	Water_Bian = {
		EffectPath = "/Game/Asset/Effect/Niagara/Steed/Common/NS_Bian_FootSteps_Water.NS_Bian_FootSteps_Water",
		EffectPathForFastState = "/Game/Asset/Effect/Niagara/Steed/Common/NS_Bian_FootSteps_Water.NS_Bian_FootSteps_Water",
		EffectPathForSlowState = "/Game/Asset/Effect/Niagara/Steed/Common/NS_Bian_FootSteps_Water.NS_Bian_FootSteps_Water",
		PhysicalSurface = "Water_Bian",
	},
	Water_SongluSummon = {
		EffectPath = "/Game/Asset/Effect/Niagara/Player/A_Common/NDC/NDC_FootSteps_Water.NDC_FootSteps_Water",
		EffectPathForFastState = "/Game/Asset/Effect/Niagara/Player/A_Common/NDC/NDC_FootSteps_Water.NDC_FootSteps_Water",
		EffectPathForSlowState = "/Game/Asset/Effect/Niagara/Player/A_Common/NDC/NDC_FootSteps_Water.NDC_FootSteps_Water",
		PhysicalSurface = "Water_SongluSummon",
	},
})
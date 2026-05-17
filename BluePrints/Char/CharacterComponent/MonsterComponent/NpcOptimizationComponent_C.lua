
require "UnLua"

local M = Class()


-- C++
-- function M:GetOptimizationsConfig(Owner, Config)
-- 	local OptimizationConfigCppMap = TMap("", false)
-- 	OptimizationConfigCppMap:Add("EnableMonsterPreloadPackage", Const.EnableMonsterPreloadPackage) 
-- 	OptimizationConfigCppMap:Add("EnableNpcPreloadPackage",Const.EnableNpcPreloadPackage)
-- 	OptimizationConfigCppMap:Add("EnableBornOverlapCheck", Const.EnableBornOverlapCheck) 

-- 	Config.OptimizationConfigCppMap = OptimizationConfigCppMap

-- 	if Owner:IsNPC() then
-- 		return self:GetConfig_NPC(Owner, Config)
-- 	else
-- 		return self:GetConfig_All(Owner, Config)
-- 	end
-- end

function M:GetConfig_NPC(Owner, Config)
	Config.bEnableSCO = true
	if IsDedicatedServer(Owner) and IsAuthority(Owner) then
		Config.bEnableURO = false
	else
		Config.bEnableURO = true
	end
	Config.bEnableSAO = true

	local UROSkipMap = TMap(0.0, 0)
    UROSkipMap:Add(0.003,  3)
    UROSkipMap:Add(0.002,  4)
    UROSkipMap:Add(0.001,  5)
    UROSkipMap:Add(0.0005, 8)
	Config.UROMap = UROSkipMap

	-- TickLod开关
	Config.bEnableTicklod = not Owner:IsInStory()
	-- Mesh. Move Comp的Ticklod在AISignificanceComponent::SignificancaceConfig单独发起
	Config.TickLodFlag = ETickObjectFlag.FLAG_ALL ~ ETickObjectFlag.FLAG_SKMESHCOMPONENT ~ ETickObjectFlag.FLAG_CHARMOVEMENTCOMPONENT

	-- NPC HiddenBudget开关
	Config.bEnableHiddenBudget = true

	-- MeshLOD
	Config.bEnableMeshLODBudget = false

end

function M:GetConfig_All(Owner, Config)
	Config.bEnableSCO = true
	if IsDedicatedServer(Owner) and IsAuthority(Owner) then
		Config.bEnableURO = false -- 服务器动画不更新，不用开URO
	else
		Config.bEnableURO = (Owner:IsRealMonster() and not Owner:IsBossMonster()) and true  -- 动画插值，小怪
	end
	Config.bEnableSAO = true

	local UROSkipMap = TMap(0.0, 0)
    UROSkipMap:Add(0.003,  3)
    UROSkipMap:Add(0.002,  4)
    UROSkipMap:Add(0.001,  5)
    UROSkipMap:Add(0.0005, 8)
	Config.UROMap = UROSkipMap
	
	-- TickLod开关
	Config.bEnableTicklod = not (Owner.Data.DisableTicklod or Owner:IsPhantom())
	-- Mesh. Move Comp的Ticklod在AISignificanceComponent::SignificancaceConfig单独发起
	Config.TickLodFlag = ETickObjectFlag.FLAG_ALL ~ ETickObjectFlag.FLAG_SKMESHCOMPONENT ~ ETickObjectFlag.FLAG_CHARMOVEMENTCOMPONENT
	
	-- 怪物EMBudget开关	
	Config.bEnableEMBudget = false
	
	-- 怪物UnitBudget 开关
	-- if IsStandAlone(Owner) then
	-- 	local GameMode = UE.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	-- 	if GameMode:IsInRegion() == false then
	-- 		Config.bEnableUnitBudget = Owner:IsRealMonster() and not Owner:IsBossMonster()
	-- 	else
	-- 		Config.bEnableUnitBudget = false
	-- 	end
	-- else
	-- 	Config.bEnableUnitBudget = false
	-- end

	-- MeshLOD
	Config.bEnableMeshLODBudget = false
	-- 移动同步数据合并.
	Config.bEnableReplicatedOptimization = true
	--动态阴影控制
	Config.bEnableDynamicShadowBudget = true;
	return Config
end


return M
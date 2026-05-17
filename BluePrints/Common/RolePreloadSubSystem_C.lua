require "Unlua"
require "Const"
local AssetPathTable = require "Utils.PreloadAssetPath"
local M = Class()

-- @wuzhijun
-- CharPreload和DungeonPreload两种预加载思路
-- CharPreload是在角色初始化时执行预加载，按需加载，避免初始化等待时间过长
-- DungeonPreload是在关卡Loading时进行全量预加载

local PIELoadLimit = false -- PIE下测试只测逻辑，限制下加载的数量，否则会很卡
local PIELoadLimitNum = 5 -- 

local bUseAssetPathStaticData = true -- 是否使用静态扫描数据的开关
UE4.URolePreloadGameInstanceSubsystem.SetUseAssetPathStaticData(bUseAssetPathStaticData)


local DungeonPreloadOutTime = 15
UE4.URolePreloadGameInstanceSubsystem.SetDungeonPreloadOutTime(DungeonPreloadOutTime)

function M:Init_Lua()
	-- 限制同时只有15个资源预加载
	self:SetMaxAsyncLoadNum(15)
	-- PreloadSystem:EnableLimitLoadNum(false)
	self.DungeonAssetsPreloading = false
	self.DungeonAssetsPreloadFinishCb = nil
	self.OutTimeHandle = nil
end

-- function M:GetCommonAssetsPath_Lua()
-- 	local Path = {}
-- 	table.insert(Path, FEMLoadPath("Blueprint'/Game/BluePrints/Combat/BP_AttributesSet.BP_AttributesSet_C'", true))
	
-- 	-- Weapon
-- 	table.insert(Path, FEMLoadPath("Blueprint'/Game/BluePrints/Combat/BP_WeaponAttributesSet.BP_WeaponAttributesSet'", true))
-- 	table.insert(Path, FEMLoadPath("NiagaraSystem'/Game/Asset/Effect/Niagara/Weapon/A_Common/NS_WeaponAppear.NS_WeaponAppear'", false))

-- 	-- SkillCreature
-- 	table.insert(Path,FEMLoadPath("Blueprint'/Game/BluePrints/Combat/SkillCreatures/BP_SkillCreatureAttributesSet.BP_SkillCreatureAttributesSet_C'", true))

-- 	-- 这个TalkContext在怪物上会很经常被用于判断
-- 	table.insert(Path, FEMLoadPath("Blueprint'/Game/BluePrints/Story/Talk/BP_TalkContext.BP_TalkContext_C'", true))

-- 	-- 配件蓝图
-- 	table.insert(Path, FEMLoadPath(Const.CharResourcePaths.AccessoryBP, true))
-- 	table.insert(Path, FEMLoadPath(Const.CharResourcePaths.StaticAccessoryBP, true))
-- 	table.insert(Path, FEMLoadPath(Const.CharResourcePaths.DistructableBodyBp, true))
	
-- 	return Path
-- end

function M:GetUseAssetPathStaticData()
	return bUseAssetPathStaticData
end

function M:EnableOptimization()
	-- local IsPIE = UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self)
	return Const.EnableDungeonAssetsPreload
end

function M:EnablePIELimit()
	local IsPIE = UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self)
	return PIELoadLimit and IsPIE
end

-- ==============================Player=============================
-- 加载主角资源
-- function M:PreloadPlayerAssets(PlayerCharacter)
-- 	if not PlayerCharacter then return end
-- 	local Paths = self:GetPathsTable()
-- 	local BattlePaths = self:CommonPrepareAllBattleMontage(EObjType.PlayerCharacter, PlayerCharacter.CurrentRoleId)
-- 	local WeaponMontageTags = PlayerCharacter:GetCharPreloadComp():GetPlayerWeaponMontageTags()
-- 	local WeaponPaths = self:PreparePlayerWeaponMontage(WeaponMontageTags,PlayerCharacter.CurrentRoleId)
-- 	Paths = Paths + BattlePaths + WeaponPaths
-- 	self:BuildDungeonRoleAssetRequest_Lua(PlayerCharacter.CurrentRoleId, Paths)
-- end

-- 加载召唤物资源
-- function M:PreloadSummonAssets(CurrentRoleId)
-- 	if not CurrentRoleId then return end
-- 	local BattleCharInfo = DataMgr.BattleChar[CurrentRoleId]
-- 	if BattleCharInfo.SummonId then
-- 		self:CacheDungeonMonsterAssets_Lua(BattleCharInfo.SummonId, true)
-- 	end
-- end


-- =============================副本==============================
-- 关卡Loading时调的接口
-- 缓存主角绑定召唤物
-- 缓存该关卡在Dungeon表里配的PreloadMonsters怪物
-- function M:CacheDungeonGameAssetsOuter(FinishCallback)
-- 	if self.DungeonAssetsPreloading then
-- 		return false
-- 	end

-- 	if GWorld:IsDedicatedServer() then
-- 		return false
-- 	end
-- 	-- self:PreloadCommonAssets()
-- 	local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
-- 	if not DungeonId or not DataMgr.Dungeon[DungeonId] then
--         return false
--     end

-- 	self.DungeonAssetsPreloading = true
-- 	self.DungeonAssetsPreloadFinishCb = FinishCallback

-- 	self.LoadingUnitNum = 0
-- 	self.DungeonLoadingRequests = {}
-- 	self:EnableLimitLoadNum(false)

-- 	local GameState = UE4.UGameplayStatics.GetGameState(self)
-- 	self.Players = GameState and GameState:GetAllPlayer():ToTable()
-- 	if self.Players then
-- 		for _,PlayerCharacter in pairs(self.Players) do
-- 			DebugPrint("WPSDEBUG pre load player asset, roleid = ",PlayerCharacter.CurrentRoleId)
-- 			self:PreloadPlayerAssets(PlayerCharacter)
-- 			self:PreloadSummonAssets(PlayerCharacter.CurrentRoleId)
-- 		end
-- 		-- self:PreloadPhantomAssets()
-- 	else
-- 		DebugPrint("CacheDungeonGameAssetsOuter  Can Not Find PlayerInfo!!!!!!!!!!!!!!!")
-- 	end

-- 	-- Monster
-- 	local MonsterIds = self:GetPreloadMonsterIds() or {}--DataMgr.Dungeon[DungeonId].PreloadMonsters
-- 	for MonsterId,_ in pairs(MonsterIds) do
-- 		self:CacheDungeonMonsterAssets_Lua(MonsterId, true)
-- 	end
-- 	-- local MonsterIds = { 7002001 }
-- 	-- if MonsterIds and #MonsterIds>0 then
-- 	-- 	for i = 1, #MonsterIds do
-- 	-- 		self:CacheDungeonMonsterAssets_Lua(MonsterIds[i], true)
-- 	-- 	end
-- 	-- end

-- 	-- 处理超时, 时序需在Consume前, 因为Consume可能是当帧完成的, 会导致定时器后于AllLoadFinish
-- 	if self.OutTimeHandle then
-- 		UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.OutTimeHandle)
-- 		self.OutTimeHandle = nil
-- 	end

-- 	local function OutTimeFunc()
-- 		GWorld.logger.errorlog	("wzj- 副本资源预加载超时, 超时时间:" .. DungeonPreloadOutTime.. "秒")
-- 		self:PreloadDungeonGameAssetsFinished_Lua()
-- 	end
-- 	self.OutTimeHandle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, OutTimeFunc}, DungeonPreloadOutTime, false, 0)

-- 	-- 发起加载请求
-- 	self:ConsumeDungeonRoleAssetRequest_Lua()

-- 	return true
-- end

-- 副本魅影资源预加载
function M:CacheDungeonPhantomAssets_Lua(UnitId)
	if not UnitId then
		return
	end

	local Paths = self:GetPathsTable()
	local BPMeshs = self:PreparePhantomAllBPMesh(UnitId)
	-- local Montages= self:CommonPrepareAllMontage(EObjType.PhantomCharacter, UnitId)
	local Montages= self:CommonPrepareAllBattleMontage(EObjType.PhantomCharacter, UnitId)

	Paths = Paths + BPMeshs + Montages
	-- self:CacheDungeonRoleAssets_WithCb_Lua(UnitId, Paths)
	self:BuildDungeonRoleAssetRequest_Lua(UnitId, Paths)
end

-- TODO @wuzhijun 优化技能、技能流程（Buff等）索引的蓝图、特效获取流程
-- 副本怪物资源预加载
-- function M:CacheDungeonMonsterAssets_Lua(UnitId, bForceCache)
-- 	local Paths = self:CommonCacheMonsterAssets_Lua(UnitId, bForceCache)
-- 	if Paths == nil or #Paths == 0 then
-- 		return
-- 	end
-- 	self:BuildDungeonRoleAssetRequest_Lua(UnitId, Paths)
-- 	-- self:CacheDungeonRoleAssets_WithCb_Lua(UnitId, Paths)
-- end

-- function M:CacheDungeonRoleAssets_WithCb_Lua(UnitId, Paths)
-- 	-- if self.LoadingUnitNum == nil then
-- 	-- 	self.LoadingUnitNum = 0
-- 	-- end
-- 	-- self.LoadingUnitNum = self.LoadingUnitNum + 1
-- 	-- print(_G.LogTag, "wzj-  CacheDungeonRoleAssets_WithCb_Lua", UnitId, #Paths, self.LoadingUnitNum)
-- 	if self:EnablePIELimit() then
-- 		if #Paths > PIELoadLimitNum then
-- 			for i = PIELoadLimitNum+1, #Paths, 1 do
-- 				Paths[i] = nil
-- 			end
-- 		end
-- 	end
-- 	print(_G.LogTag, "wzj-  预加载副本战斗资源，UnitId：", UnitId, "  加载数量：", #Paths)
-- 	local Res = self:CacheDungeonRoleAssets(UnitId, Paths, {self, M.DungeonRoleAssetsLoadFinished_Cb_Lua})
-- 	if not Res then
-- 		self:DungeonRoleAssetsLoadFinished_Cb_Lua()
-- 	end
-- end

-- function M:BuildDungeonRoleAssetRequest_Lua(unitId, paths)
-- 	if paths == nil or #paths == 0 or unitId == nil then
-- 		return
-- 	end

-- 	local TmpRequest = {
-- 		UnitId = unitId,
-- 		Paths = paths,
-- 	}

-- 	table.insert(self.DungeonLoadingRequests, TmpRequest)
-- end

-- function M:ConsumeDungeonRoleAssetRequest_Lua()
-- 	self.LoadingUnitNum = self.DungeonLoadingRequests and #self.DungeonLoadingRequests or 0
-- 	if self.LoadingUnitNum > 0 then
-- 		for _, Request in ipairs(self.DungeonLoadingRequests) do
-- 			-- 副本会挂起loading等待加载回调，需要计数，再加个定时器保底
-- 			self:CacheDungeonRoleAssets_WithCb_Lua(Request.UnitId, Request.Paths)
-- 		end
-- 	else
-- 		self:PreloadDungeonGameAssetsFinished_Lua()
-- 	end
-- end

-- function M:DungeonRoleAssetsLoadFinished_Cb_Lua(bRes)
-- 	self.LoadingUnitNum = self.LoadingUnitNum - 1
-- 	print(_G.LogTag, "wzj-  收到副本资源预加载完成回调，当前剩余未完成数量：", self.LoadingUnitNum)

-- 	if self.LoadingUnitNum == 0 then
-- 		self:PreloadDungeonGameAssetsFinished_Lua()
-- 	end
-- end

-- function M:PreloadDungeonGameAssetsFinished_Lua()
-- 	-- 处理超时定时器
-- 	if self.OutTimeHandle then
-- 		UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.OutTimeHandle)
-- 		self.OutTimeHandle = nil
-- 	end

-- 	if self.DungeonAssetsPreloading == false then
-- 		return
-- 	end

-- 	self:EnableLimitLoadNum(true)
-- 	local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
-- 	if GameState then
-- 		-- 标记预加载
-- 		GameState.bDungeonMonPreloadDone = true
-- 	end

-- 	print(_G.LogTag, "wzj-  副本战斗资源加载完毕")
-- 	if self.DungeonAssetsPreloadFinishCb ~= nil then
-- 		self.DungeonAssetsPreloadFinishCb(GameState)
-- 		self.DungeonAssetsPreloadFinishCb = nil
-- 	end
-- 	self.DungeonAssetsPreloading = false
-- end

-- =============================副本END==============================


-- =============================区域==============================

-- 区域怪物资源预加载
-- function M:CacheRegionGameAssetsOuter(UnitId)
-- 	-- 目前暂时只有怪物缓存
-- 	local Paths = self:CommonCacheMonsterAssets_Lua(UnitId, false)

-- 	if not Paths then
-- 		Paths = self:CommonCacheNpcAssets_Lua(UnitId,false)
-- 	end

-- 	if Paths == nil or #Paths == 0 then
-- 		return false
-- 	end

-- 	if self:EnablePIELimit() then
-- 		if #Paths > PIELoadLimitNum then
-- 			for i = PIELoadLimitNum+1, #Paths, 1 do
-- 				Paths[i] = nil
-- 			end
-- 		end
-- 	end
-- 	print(_G.LogTag, "wzj-  预加载区域战斗资源，UnitId", UnitId, "    数量：", #Paths)
-- 	self:CacheRegionRoleAssets(UnitId, Paths)
-- 	return true
-- end

-- =============================区域END==============================


-- =============================Mon==============================

-- 怪物：准备所有资源路径
-- function M:CommonCacheMonsterAssets_Lua(UnitId, bForceCache)
-- 	if not self:EnableOptimization() then
-- 		return nil	
-- 	end

-- 	if not UnitId or not DataMgr.Monster[UnitId] then
-- 		return nil
-- 	end

-- 	if self:HasRoleCache(UnitId) and not bForceCache then
-- 		print(_G.LogTag, "wzj-  资源已经存在，不需要重复加载，UnitId：", UnitId)
-- 		return nil
-- 	end

-- 	local Paths = self:GetPathsTable()

-- 	local BPMeshs = self:CommonPrepareMonAllBPMesh(UnitId):ToTable()
-- 	-- local Montages= self:CommonPrepareAllMontage(EObjType.MonsterCharacter, UnitId)
-- 	local Montages= self:CommonPrepareAllBattleMontage(EObjType.MonsterCharacter, UnitId)
-- 	local BehaviorTrees = self:CommonPrepareMonBehaviorTree(UnitId):ToTable()
-- 	local SkillEffcets = self:CommonPrepareMonSkillEffects(UnitId)

-- 	Paths = Paths + BPMeshs + Montages + BehaviorTrees + SkillEffcets
-- 	return Paths
-- end

-- 怪物及怪物相关类的所有蓝图Mesh资源索引
-- function M:CommonPrepareMonAllBPMesh(UnitId)
-- 	local MonsterData = DataMgr.Monster[UnitId]
-- 	local ModelData = DataMgr.Model[MonsterData.ModelId]

-- 	local Paths = self:GetPathsTable()

-- 	-- 怪物蓝图
-- 	if MonsterData.UnitBPPath then
-- 		table.insert(Paths, FEMLoadPath(MonsterData.UnitBPPath, true))
-- 	end

-- 	-- 怪物动画蓝图
-- 	if MonsterData.AnimCoverPath then
-- 		table.insert(Paths, FEMLoadPath(MonsterData.AnimCoverPath, true))
-- 	elseif ModelData and ModelData.AnimInstancePath then
-- 		table.insert(Paths, FEMLoadPath(ModelData.AnimInstancePath, true))
-- 	end

-- 	-- 怪物行为树
-- 	if MonsterData.BT then
-- 		table.insert(Paths, FEMLoadPath(MonsterData.BT))
-- 	end

-- 	-- AIControllerClass
-- 	local ControllerPath = MonsterData.EnableFly == true and Const.FlyAIControllerPath or Const.DefaultAIControllerPath
-- 	table.insert(Paths, FEMLoadPath(ControllerPath, true))
	
-- 	-- 武器蓝图
-- 	local WeaponId = MonsterData.WeaponId
-- 	if WeaponId then
-- 		if type(WeaponId) == "table" then
-- 			for i, Id in ipairs(WeaponId) do
-- 				local WeaponBPPath = DataMgr.BattleWeapon[Id].WeaponBlueprint
-- 				table.insert(Paths, FEMLoadPath(WeaponBPPath, true))
-- 			end
-- 		else
-- 			local WeaponBPPath = DataMgr.BattleWeapon[WeaponId].WeaponBlueprint
-- 			table.insert(Paths, FEMLoadPath(WeaponBPPath, true))
-- 		end
-- 	end

-- 	-- Mesh
-- 	Paths = Paths + self:CommonPrepareAllMesh(EObjType.MonsterCharacter, UnitId)

-- 	return Paths
-- end

-- 怪物行为树子树索引
-- function M:CommonPrepareMonBehaviorTree(UnitId)
-- 	local PreloadEffects = require "Utils.MonsterBTPath"
-- 	if not PreloadEffects then
-- 		return {}
-- 	end
-- 	local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
-- 	local GameModeType = GameState.GameModeType
-- 	if GameModeType == "" or GameModeType == "Traning" or GameModeType == "Blank" then
-- 		GameModeType = "Test"
-- 	elseif GameModeType == "SurvivalPro" then
-- 		GameModeType = "Survival"
-- 	end
-- 	if PreloadEffects[UnitId] and PreloadEffects[UnitId][GameModeType] then
-- 		local TmpPaths = PreloadEffects[UnitId][GameModeType]
-- 		local OutPaths = {}
-- 		for _, Path in pairs(TmpPaths) do
-- 			table.insert(OutPaths, FEMLoadPath(Path))
-- 		end
-- 		return OutPaths
-- 	else
-- 		return {}
-- 	end

-- end

-- 怪物特效索引
function M:CommonPrepareMonSkillEffects(UnitId)
	local PreloadEffects = require "Utils.MonsterEffectsPath"
	if not PreloadEffects then
		return {}
	end
	local MonsterData = DataMgr.Monster[UnitId]
	if MonsterData == nil then
		return {}
	end
	UnitId = MonsterData.BattleRoleId
	local RetPathTable = {}
	if PreloadEffects[UnitId] then
		if not IsEmptyTable(PreloadEffects[UnitId]) then
			for _, v in pairs(PreloadEffects[UnitId]) do
				local EffectPath = DataMgr.VisualEffect[v]
				if EffectPath and EffectPath.EffectPath then
					table.insert(RetPathTable, FEMLoadPath(EffectPath.EffectPath))
				end
			end
		end
	end
	return RetPathTable
end

-- 主角通用特效资源加载
-- 角色特效索引
function M:CommonPreparePlayerSkillEffects(PlayerCharacter, IsPrepareMainPlayer)
	local PreloadEffects = require "Utils.PlayerEffectsPath"
	if not PreloadEffects or not PlayerCharacter then
		return {}
	end

	local RetPathTable = {}

	local UnitId = PlayerCharacter.CurrentRoleId
	local ModelId = PlayerCharacter.ModelId
	if not ModelId or ModelId == 0 then 
		ModelId = UnitId
	end
	-- 角色特效
	local ModelEffectsTable = PreloadEffects.PlayerEffects[ModelId]
	if ModelEffectsTable and not IsEmptyTable(ModelEffectsTable) then
		for _, v in ipairs(ModelEffectsTable) do
			table.insert(RetPathTable, FEMLoadPath(v))
		end
	end
	local AccessoryType2Id = PlayerCharacter.CharacterFashion and PlayerCharacter.CharacterFashion.AccessoryType2Id
	--收集角色配饰特效
	if AccessoryType2Id then
		local AccessoryEffects = PreloadEffects.AccessoryEffects
		for _, AccessoryId in pairs(AccessoryType2Id) do
			local EffectsTable = AccessoryEffects and AccessoryEffects[AccessoryId]
			if EffectsTable and not IsEmptyTable(EffectsTable) then
				for _, v in ipairs(EffectsTable) do
					table.insert(RetPathTable, FEMLoadPath(v))
				end
			end
		end
	else 
		AccessoryType2Id = {}
	end
	
	-- 武器特效 & 角色配饰特效组
	-- 武器配饰没有特效
	if PlayerCharacter.Weapons then
		local function _CommonPreparePlayerWeaponEffects(PreloadEffects, RetPathTable, AccessoryType2Id, WeaponId)
			local AccessoryEffects = PreloadEffects.AccessoryEffects
			local AccessoryGroups = PreloadEffects.AccessoryGroups
			local WeaponEffects = PreloadEffects.WeaponEffects
			local EffectsTable = WeaponEffects and WeaponEffects[WeaponId]
			if EffectsTable and not IsEmptyTable(EffectsTable) then
				for _, v in ipairs(EffectsTable) do
					table.insert(RetPathTable, FEMLoadPath(v))
				end
			end
			for _, AccessoryId in pairs(AccessoryType2Id) do
				local AccessoryGroupName = AccessoryGroups and AccessoryGroups[AccessoryId]
				if AccessoryGroupName then 
					local WeaponBlueprintPath = DataMgr.BattleWeapon[WeaponId].WeaponBlueprint
					local WeaponBlueprint = string.match(WeaponBlueprintPath, "([^%.]+)")
					local BlueprintInfo = WeaponBlueprint and DataMgr.WeaponBlueprintId[WeaponBlueprint]
					if BlueprintInfo and BlueprintInfo.WeaponBlueprintId then
						local WeaponFx = DataMgr.WeaponFX[BlueprintInfo.WeaponBlueprintId]
						local GroupEffect = WeaponFx and WeaponFx[AccessoryGroupName]
						if GroupEffect and GroupEffect.FXAsset then
							table.insert(RetPathTable, FEMLoadPath(GroupEffect.FXAsset))
						end
					end
				end
			end
		end
		for _, Weapon in pairs(PlayerCharacter.Weapons) do
        	_CommonPreparePlayerWeaponEffects(PreloadEffects, RetPathTable, AccessoryType2Id, Weapon.WeaponId)
    	end
	end

	-- 常用特效挂主角身上
	if IsPrepareMainPlayer then
		local MainPlayEffects = PreloadEffects.MainPlayEffects
		for _, v in ipairs(MainPlayEffects) do
			table.insert(RetPathTable, FEMLoadPath(v))
		end
	end

	return RetPathTable
end

function M:CommonPreparePlayerFrontSightUI(PlayerCharacter)
	local FrontSightUtils = require "Utils.FrontSightUtils"
	if not IsValid(PlayerCharacter) then
		return {}
	end
	local RetPathTable = {}

	local Weapons = {
		PlayerCharacter.RangedWeapon,
		PlayerCharacter.UltraWeapon,
	}
	local StyleNames = {}
	for _,Weapon in pairs(Weapons) do
		if IsValid(Weapon) then
			local SightUIName = FrontSightUtils:GetWeaponSightUI(Weapon, PlayerCharacter.ModelId)
			local WeaponStyleNode = FrontSightUtils:GetWeaponStyleNode(SightUIName)
			if WeaponStyleNode and not StyleNames[WeaponStyleNode] then
				local FrontSightUIPath = FrontSightUtils:GetFrontSightUIPath(WeaponStyleNode)
				if FrontSightUIPath then
					StyleNames[WeaponStyleNode] = 1
					table.insert(RetPathTable, FEMLoadPath(FrontSightUIPath))
				end
			end

			local MagazineCapacity = Weapon:GetAttr("MagazineCapacity")
			local AmmoBarStyleName = FrontSightUtils:GetAmmoBarStyle(Weapon, WeaponStyleNode, MagazineCapacity, SightUIName)
			if AmmoBarStyleName and not StyleNames[AmmoBarStyleName] then
				local AmmoBarUIPath = FrontSightUtils:GetAmmoBarUIPath(AmmoBarStyleName)
				if AmmoBarUIPath then
					StyleNames[AmmoBarStyleName] = 1
					table.insert(RetPathTable, FEMLoadPath(AmmoBarUIPath))
				end
			end
		end
	end
	return RetPathTable
end
-- =============================MonEND==============================

-- =============================Npc=================================
-- function M:CommonCacheNpcAssets_Lua(UnitId, bForceCache)
-- 	if not self:EnableOptimization() then
-- 		return nil	
-- 	end

-- 	local NpcData = DataMgr.Npc[UnitId]
-- 	if not UnitId or not NpcData then
-- 		return nil
-- 	end

-- 	if self:HasRoleCache(UnitId) and not bForceCache then
-- 		print(_G.LogTag, "wzj-  资源已经存在，不需要重复加载，UnitId：", UnitId)
-- 		return nil
-- 	end

-- 	local Paths = self:GetPathsTable()
-- 	if NpcData and NpcData.BT then
-- 		table.insert(Paths, FEMLoadPath(NpcData.BT))
-- 	end
-- 	return Paths
-- end
-- =============================Npc End=============================

-- =============================Phantom==============================
-- function M:PreparePhantomAllBPMesh(UnitId)
-- 	local PhantomData = DataMgr.Phantom[UnitId]
-- 	local PhantomRoleInfo = DataMgr.BattleChar[PhantomData.BattleRoleId]
-- 	local ModelData = DataMgr.Model[PhantomRoleInfo.ModelId]

-- 	local Paths = self:GetPathsTable()

-- 	-- 魅影蓝图
-- 	if PhantomData.UnitBPPath then
-- 		table.insert(Paths, FEMLoadPath(PhantomData.UnitBPPath, true))
-- 	end

-- 	-- 动画蓝图
-- 	if ModelData.AnimInstancePath then
-- 		table.insert(Paths, FEMLoadPath(ModelData.AnimInstancePath, true))
-- 	end

-- 	-- 行为树
-- 	if PhantomData.BT and PhantomData.BT[1] then
-- 		table.insert(Paths, FEMLoadPath(PhantomData.BT[1]))
-- 	end

-- 	-- AI控制器
-- 	local ControllerPath = PhantomData.EnableFly == true and Const.FlyAIControllerPath or Const.DefaultAIControllerPath
-- 	table.insert(Paths, FEMLoadPath(ControllerPath, true))

-- 	-- All Mesh
-- 	Paths = Paths + self:CommonPrepareAllMesh(EObjType.PhantomCharacter, UnitId):ToTable()

-- 	-- todo 魅影武器

-- 	return Paths
-- end

-- function M:PreparePhantomWeaponMontage(WeaponTags, ObjType, UnitId)
-- 	local ModelData = self:GetModelData(ObjType, UnitId)
-- 	return self:CommonPrepareAllWeaponMontage(WeaponTags, ModelData)
-- end

-- =============================PhantomEND==============================

-- =============================Player==============================

-- function M:PreparePlayerWeaponMontage(WeaponTags,CurrentRoleId)
-- 	local ModelData = self:GetModelData(EObjType.PlayerCharacter, CurrentRoleId)
-- 	return self:CommonPrepareAllWeaponMontage(WeaponTags, ModelData)
-- end

-- =============================PlayerEND==============================

-- =============================Common==============================
-- 全部Mesh统一加载（Char、武器、配件和物理等
-- function M:CommonPrepareAllMesh(ObjType, UnitId)
-- 	local ModelData = self:GetModelData(ObjType, UnitId)
-- 	if ModelData == nil then
-- 		return {}
-- 	end
-- 	local bStaticDataEmpty = false
-- 	if bUseAssetPathStaticData then
-- 		local Temp = self:GetPreloadAssetPathFromStaticData(ModelData.ModelId,"Mesh")
-- 		if not next(Temp) then
-- 			bStaticDataEmpty = true
-- 			DebugPrint("CommonPrepareAllMesh Lua表中没有对应数据",ObjType, UnitId,ModelData.ModelId,"Mesh")
-- 		else
-- 			return Temp
-- 		end
-- 	end
-- 	if not bUseAssetPathStaticData or bStaticDataEmpty then
-- 		local MeshPath = ModelData.SkeletonMeshPath
-- 		if MeshPath then
-- 			local MeshFiles = {}
-- 			local AssetStringIndex = UE4.UKismetStringLibrary.FindSubstring(MeshPath, "Mesh/")
-- 			if AssetStringIndex > 0 then
-- 				local MeshFolder = UE4.UKismetStringLibrary.GetSubstring(MeshPath, 0, AssetStringIndex + 5)
-- 				local _, MeshPaths = self.GetFolderAssetPaths(MeshFolder)
-- 				return MeshPaths:ToTable()
-- 			end
-- 		end
-- 	end
-- 	return {}
-- end

-- 全部蒙太奇统一加载
function M:CommonPrepareAllMontage(ObjType, UnitId)
	local ModelData = self:GetModelData(ObjType, UnitId)
	if ModelData == nil then
		return {}
	end
	if not ModelData.MontageFolder then
		return {}
	end

	local MontageFolder = ModelData.MontageFolder
	local AssetStringIndex = UE4.UKismetStringLibrary.FindSubstring(MontageFolder, "Asset/")
	MontageFolder = UE4.UKismetStringLibrary.GetSubstring(MontageFolder, AssetStringIndex, UE4.UKismetStringLibrary.Len(MontageFolder))
	local _, Paths = self.GetFolderAssetPaths(MontageFolder)
	return Paths:ToTable()
end

-- 获取所有战斗相关蒙太奇资源，路径包括：Combat/Hit, Combat/Skill, Locomotion/
-- 怪物额外包括： SpecialIdle/
-- 主角和魅影的 Comabt/Weapon/ 因为绑定了武器逻辑，需要特殊处理
-- function M:CommonPrepareAllBattleMontage(ObjType, UnitId)
-- 	local ModelData = self:GetModelData(ObjType, UnitId)
-- 	if ModelData == nil then
-- 		return {}
-- 	end
-- 	if not ModelData.MontageFolder then
-- 		return {}
-- 	end

-- 	local Paths = self:GetPathsTable()

-- 	local bStaticDataEmpty = false
-- 	if bUseAssetPathStaticData then
-- 		local Temp = self:GetPreloadAssetPathFromStaticData(ModelData.ModelId,"Montage"):ToTable() or {}
-- 		if not next(Temp) then
-- 			bStaticDataEmpty = true
-- 			DebugPrint("CommonPrepareAllBattleMontage Lua表中没有对应数据",ObjType, UnitId,ModelData.ModelId,"Montage")
-- 		end
-- 		Paths = Paths + Temp
-- 	end
-- 	if not bUseAssetPathStaticData or bStaticDataEmpty then
-- 		local MontageFolder = ModelData.MontageFolder
-- 		local AssetStringIndex = UE4.UKismetStringLibrary.FindSubstring(MontageFolder, "Asset/")
-- 		MontageFolder = UE4.UKismetStringLibrary.GetSubstring(MontageFolder, AssetStringIndex, UE4.UKismetStringLibrary.Len(MontageFolder))

-- 		local CombatHit_Folder = MontageFolder .. "Combat/Hit/"
-- 		local _, CombatHit_Paths = self.GetFolderAssetPaths(CombatHit_Folder)

-- 		local CombatSkill_Folder = MontageFolder .. "Combat/Skill/"
-- 		local _, CombatSkill_Paths = self.GetFolderAssetPaths(CombatSkill_Folder)

-- 		local Locomotion_Folder = MontageFolder .. "Locomotion/"
-- 		local _, Locomotion_Paths = self.GetFolderAssetPaths(Locomotion_Folder)

-- 		Paths = Paths + CombatHit_Paths:ToTable() + CombatSkill_Paths:ToTable() + Locomotion_Paths:ToTable()

-- 		if ObjType == EObjType.MonsterCharacter then
-- 			local SpecialIdle_Folder = MontageFolder .. "SpecialIdle/"
-- 			local _, SpecialIdle_Paths = self.GetFolderAssetPaths(SpecialIdle_Folder)

-- 			Paths = Paths + SpecialIdle_Paths:ToTable()
-- 		-- else if ObjType == EObjType.PhantomCharacter or ObjType == EObjType.PlayerCharacter then
-- 		end
-- 	end

-- 	if tonumber(UnitId) == 2301 then
-- 		-- 章鱼需要额外加载Tentacle目录Montage, todo, 先写死
-- 		local TentaclePaths = {}
-- 		table.insert(TentaclePaths, FEMLoadPath('/Game/Asset/Char/Player/Char004_Zhangyu/Animation/Tentacle/Montage/Combat/Hit/Zhangyu_Tentacle_Die_Montage.Zhangyu_Tentacle_Die_Montage'))
-- 		table.insert(TentaclePaths, FEMLoadPath('/Game/Asset/Char/Player/Char004_Zhangyu/Animation/Tentacle/Montage/Combat/Hit/Zhangyu_Tentacle_Birth_Montage.Zhangyu_Tentacle_Birth_Montage'))
-- 		table.insert(TentaclePaths, FEMLoadPath('/Game/Asset/Char/Player/Char004_Zhangyu/Animation/Tentacle/Montage/Combat/Skill/Zhangyu_Tentacle_Attack01_Montage.Zhangyu_Tentacle_Attack01_Montage'))
-- 		table.insert(TentaclePaths, FEMLoadPath('/Game/Asset/Char/Player/Char004_Zhangyu/Animation/Tentacle/Montage/Combat/Skill/Zhangyu_Tentacle_Attack02_Montage.Zhangyu_Tentacle_Attack02_Montage'))
		
-- 		Paths = Paths + TentaclePaths
-- 	end

-- 	return Paths
-- end

-- function M:CommonPrepareAllWeaponMontage(WeaponTags, ModelData)
-- 	if ModelData == nil then
-- 		return {}
-- 	end
-- 	if not ModelData.MontageFolder then
-- 		return {}
-- 	end
-- 	local Paths = self:GetPathsTable()
-- 	local bStaticDataEmpty = false
-- 	if bUseAssetPathStaticData then
-- 		for _,Tag in pairs(WeaponTags) do
-- 			local Temp = self:GetPreloadAssetPathFromStaticData(ModelData.ModelId, "Weapon", Tag):ToTable() or {}
-- 			Paths = Paths + Temp
-- 		end
-- 		if not next(Paths) then
-- 			bStaticDataEmpty = true
-- 			DebugPrint("CommonPrepareAllWeaponMontage Lua表中没有对应数据",ModelData.ModelId,"Montage")
-- 		end
-- 	end
-- 	if not bUseAssetPathStaticData or bStaticDataEmpty then
-- 		local MontageFolder = ModelData.MontageFolder
-- 		local AssetStringIndex = UE4.UKismetStringLibrary.FindSubstring(MontageFolder, "Asset/")
-- 		MontageFolder = UE4.UKismetStringLibrary.GetSubstring(MontageFolder, AssetStringIndex, UE4.UKismetStringLibrary.Len(MontageFolder))
-- 		for _, Tag in pairs(WeaponTags) do
-- 			local Weapon_Folder = MontageFolder .. "Combat/Weapon/" .. Tag .. "/"
-- 			local _, TmpPaths = self.GetFolderAssetPaths(Weapon_Folder)
-- 			Paths = Paths + TmpPaths:ToTable()
-- 		end
-- 	end

-- 	return Paths
-- end

-- 除了BattleMontage路径外的所有剩余蒙太奇，暂时还没需求，先不处理
function M:CommonPrepareAllExceptBattleMontage(ObjType, UnitId)
	return {}
end

function M:GetModelData(ObjType, UnitId)
	if ObjType == EObjType.MonsterCharacter then
		local Data = DataMgr.Monster[UnitId]
		local ModelData = DataMgr.Model[Data.ModelId]
		return ModelData
	
	elseif ObjType == EObjType.PhantomCharacter then
		local PhantomData = DataMgr.Phantom[UnitId]
		local PhantomRoleInfo = DataMgr.BattleChar[PhantomData.BattleRoleId]
		local ModelData = DataMgr.Model[PhantomRoleInfo.ModelId]
		return ModelData

	elseif ObjType == EObjType.PlayerCharacter then
		local PlayerRoleInfo = DataMgr.BattleChar[UnitId]
		local ModelData = DataMgr.Model[PlayerRoleInfo.ModelId]
		return ModelData
	elseif ObjType == EObjType.NpcCharacter then
		local NpcData = DataMgr.Npc[UnitId]
		local ModelData = NpcData and NpcData.ModelId and DataMgr.Model[NpcData.ModelId]
		return ModelData
	else
		return nil
	end
end

function M:GetPathsTable()
	local Paths = setmetatable({}, {
		__add = function(Paths, newtable)
			for i = 1, #newtable do
				table.insert(Paths, #Paths + 1, newtable[i])
			end
			return Paths
		end
	})

	return Paths
end

-- =============================CommonEND==============================


function M:CacheDungeonGameAssetsOuter_Test(FinishCallback)
	self.DungeonAssetsPreloading = true
	self.DungeonAssetsPreloadFinishCb = FinishCallback

	self.LoadingUnitNum = 0
	self.DungeonLoadingRequests = {}
	self:EnableLimitLoadNum(false)
	-- self.Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
	-- if self.Player then
	-- 	self:PreloadPlayerAssets()
	-- 	self:PreloadSummonAssets()
	-- 	-- self:PreloadPhantomAssets()
	-- end
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	self.Players = GameState and GameState:GetAllPlayer():ToTable()
	if self.Players then
		for _,PlayerCharacter in pairs(self.Players) do
			self:PreloadPlayerAssets(PlayerCharacter)
			self:PreloadSummonAssets(PlayerCharacter.CurrentRoleId)
		end
		-- self:PreloadPhantomAssets()
	else
		DebugPrint("CacheDungeonGameAssetsOuter  Can Not Find PlayerInfo!!!!!!!!!!!!!!!")
	end

	-- Monster
	local MonsterIds = { 7002001, 7003001 }
	if MonsterIds and #MonsterIds>0 then
		for i = 1, #MonsterIds do
			self:CacheDungeonMonsterAssets_Lua(MonsterIds[i], true)
		end
	end
	
	-- 处理超时
	if self.OutTimeHandle then
		UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.OutTimeHandle)
		self.OutTimeHandle = nil
	end

	local function OutTimeFunc()
		GWorld.logger.errorlog("wzj- 副本资源预加载超时, 超时时间:" .. DungeonPreloadOutTime.. "秒")
		self:PreloadDungeonGameAssetsFinished_Lua()
	end
	self.OutTimeHandle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, OutTimeFunc}, DungeonPreloadOutTime, false, 0)

	-- 发起加载请求
	self:ConsumeDungeonRoleAssetRequest_Lua()

	return true
end

--- @param Type  string 资源类型，比如Montage,Weapon(也是蒙太奇，但规则比较特殊，拆出来)，Mesh
--- @param Label string 用于指定对应类型的哪一部分资产，例如蒙太奇有skill，
--- @return Table FEMLoadPath数组
-- function M:GetPreloadAssetPathFromStaticData(ModelId,Type,Label)
-- 	if not bUseAssetPathStaticData then return end
-- 	if AssetPathTable[ModelId] and AssetPathTable[ModelId][Type] then
-- 		local Res = {}
-- 		-- 获取单个label的所有路径，并封装成数组返回
-- 		local ProcressSingleLabel = function (InLabel)
-- 			local AllPath = AssetPathTable[ModelId][Type][InLabel]
-- 			for _, Path in ipairs(AllPath) do
-- 				table.insert(Res,FEMLoadPath(Path))
-- 			end
-- 		end

-- 		if not Label or Label == "" then
-- 			for k,v in pairs(AssetPathTable[ModelId][Type]) do
-- 				ProcressSingleLabel(k)
-- 			end
-- 		else
-- 			ProcressSingleLabel(Label)
-- 		end


-- 		return Res
-- 	end

-- 	if not Label then
-- 		return UE4.URolePreloadGameInstanceSubsystem.GetPathBySplitRule(ModelId,Type):ToTable()
-- 	end
-- 	return {}
-- end

-- function M:DSLoadBT()
-- 	local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
-- 	if not DungeonId or not DataMgr.Dungeon[DungeonId] then
--         return
--     end
-- 	local MonsterIds = self:GetPreloadMonsterIds() or {}
-- 	-- DebugPrint("DSLoadBT ",DungeonId,#MonsterIds)
	
-- 	for MonsterId,_ in pairs(MonsterIds) do
-- 		local BTPath = self:CommonPrepareMonBehaviorTree(MonsterId)
-- 		for _,Path in pairs(BTPath) do
-- 			local RealPath = Path:GetOriginPath()
-- 			local Asset = LoadObject(RealPath)
-- 			self:ExecLoadTree(Asset)
-- 		end
-- 	end
-- end

-- function M:GetPreloadMonsterIds()
-- 	local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
-- 	if not DungeonId or not DataMgr.Dungeon[DungeonId] then
--         return {}
--     end
-- 	local DungeonData = DataMgr.Dungeon[DungeonId]
-- 	local MonsterIds = {}
-- 	for Id,_ in pairs(DungeonData.PreloadMonstersNum or {}) do
-- 		MonsterIds[Id] = true
-- 	end
-- 	for Id,_ in pairs(DungeonData.PreloadStaticMonstersNum or {}) do
-- 		MonsterIds[Id] = true
-- 	end
-- 	return MonsterIds
-- end

return M
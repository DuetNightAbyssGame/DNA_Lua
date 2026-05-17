require "Unlua"
require "Const"

local M = Class()

function M:Initialize_Lua()
	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local IsTakeRecorder = GameInstance.IsTakeRecorderCapturing or GameInstance.IsTakeRecorderRendering
	if IsTakeRecorder then
		self:DisableOptParams_TR()
	else
		self:InitOptParams()
	end
end

function M:DisableOptParams_TR()
	self.bEnableBalanceTickOpt = false
	self.bEnableMeshLODBiasOpt = false
	self.bEnableNoneDynamicShadowNumOpt = false
	self.bEnableAnimBudget = true
	self.bIgnoreCompletionTimeMs = true
end

function M:InitOptParams()
	if CommonUtils.GetRuntimePlatform(self) == CommonConst.CLIENT_DEVICE_TYPE.MOBILE then
		self.UnitBudgetTickFrameCounter = 15 -- 30帧，一秒2次，一次0.5
	else
		self.UnitBudgetTickFrameCounter = 12 -- 60帧. 一秒5次. 一次0.2
	end
	
	self.bEnableBalanceTickOpt = true
	self.bDynamicShadowDebug = false

	local PlatformName = string.lower(UE4.UUIFunctionLibrary.GetDevicePlatformName(self))

	-- 动画预算
	if PlatformName == CommonConst.CHANNEL_OS.ANDROID then
		self.bEnableAnimBudget = true
	else
		self.bEnableAnimBudget = true
	end
	self.bIgnoreCompletionTimeMs = true

	-- MeshLODBias
	if PlatformName == CommonConst.CHANNEL_OS.ANDROID or PlatformName == CommonConst.CHANNEL_OS.IOS then
		self.bEnableMeshLODBiasOpt = true
	else
		self.bEnableMeshLODBiasOpt = false
	end
	
	-- DynamicShadow
	if PlatformName == CommonConst.CHANNEL_OS.ANDROID or PlatformName == CommonConst.CHANNEL_OS.IOS then
		self.bEnableNoneDynamicShadowNumOpt = true
	else
		self.bEnableNoneDynamicShadowNumOpt = false
	end

	-- 分帧结算
	if PlatformName == CommonConst.CHANNEL_OS.ANDROID then
		self.bUnitBudgetTickFrameLimit = false
		self.RefreshUnitBudgetTickCount = 3
	else
		self.bUnitBudgetTickFrameLimit = false
		-- self.bUnitBudgetTickFrameLimit = true
		-- self.RefreshUnitBudgetTickCount = 3
	end

	-- 动画缓存
	if PlatformName == CommonConst.CHANNEL_OS.ANDROID then
		self.bEnableAnimCache = true
	else
		self.bEnableAnimCache = true
	end

	-- 是否开启区域使用副本性能策略的开关
	-- 规则：开启后，由动态刷怪的入口计算当前怪物的最大同时存在的数量，如果大于UnitBudget配置的限制数量，就会使用副本性能策略。关闭动态刷怪规则后关闭策略。
	-- 最大同时存在数量的计算：MonsterSpawn_Main表的每列刷怪修正数量相加，再加上增补阈值
	-- EMGameMode->TriggerMonsterSpawn, 
	-- ETriggerMonsterSpawnType::Create时尝试开启，
	-- ETriggerMonsterSpawnType::Destroy和Value == ETriggerMonsterSpawnType::DestroyAll关闭，其他不处理
	if PlatformName == CommonConst.CHANNEL_OS.ANDROID then
		self.bEnableRegionUseUnitBudgetOptmization = true
	else
		self.bEnableRegionUseUnitBudgetOptmization = true
	end
	-- 允许区域静态怪加入UnitBudget性能管理
	self.bEnableRegionUseUnitBudget_StaticCreator = true
	-- 距离主角在距离内的静态怪加入，-1表示全场静态怪
	self.StaticCreatorUnitBudgetControlDist = 3000

	self.bEnableUnitHiddenOptimization = true
	
	self.bAutoCheckPlayerHighMeshLOD = true
end

function M:SetEnableAnimCache(bEnable)
	self.bEnableAnimCache = bEnable
end


function M:GetPlayerHighMeshLODIDConfig()
	return {
		1502,
		1503,
		1504,
		1801,
		2101,
		2401,
		3101,
		3102,
		4102,
		4201,
		4301,
		5101,
		5301,
	}
end


return M

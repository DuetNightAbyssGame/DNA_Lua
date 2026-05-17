--设置 性能分级相关@jzn
local SettingUtils = {}
local EMCache = require "EMCache.EMCache"

function SettingUtils.InitPerformanceSetting()
    SettingUtils.InitGameOverallPerformance()
    SettingUtils.InitGameMaxFPS()
end

function SettingUtils.InitGameOverallPerformance()
	local OptionName = "OverallPreset"
	local GameOverallPerformanceCache = EMCache:Get(OptionName)
	local NowGameOverallPerformance = GWorld.GameInstance:GetOverallScalabilityLevel()
	DebugPrint("-----jzn---InitGameOverallPerformance-----",GameOverallPerformanceCache,NowGameOverallPerformance)
	if GameOverallPerformanceCache ~= nil then
		if GameOverallPerformanceCache == CommonConst.OverallPerformanceCustom then
			SettingUtils.InitContentPerformanceCache()
			SettingUtils.InitGameUserSettingsCache()
			SettingUtils.InitConsoleVariableCache()
		end
		GWorld.GameInstance.SetOverallScalabilityLevel(GameOverallPerformanceCache)
		EventManager:FireEvent(EventID.OnOverallPresetChanged,GameOverallPerformanceCache)
	else
		-- local OverallPresetList = {
		-- 	[1] = 0,
		-- 	[2] = 1,
		-- 	[3] = 2,
		-- }
		-- local OptionInfo = DataMgr.Option[OptionName]
		-- local Default = 3
		-- if OptionInfo and OptionInfo.DefaultValue then
		-- 	Default = tonumber(OptionInfo.DefaultValue)
		-- end
		-- local DefaultSet = OverallPresetList[Default]
		-- EMCache:Set(OptionName,DefaultSet)
		-- GWorld.GameInstance.SetOverallScalabilityLevel(DefaultSet)
	end
	SettingUtils.InitAntiAliasingCache(GameOverallPerformanceCache or NowGameOverallPerformance)
	SettingUtils.InitMobileResolution(GameOverallPerformanceCache or NowGameOverallPerformance)
	SettingUtils.InitRealtimeSunlight(GameOverallPerformanceCache or NowGameOverallPerformance)
end

--抗锯齿
function SettingUtils.InitAntiAliasingCache(GameOverallPerformance)
	local OptionName = "AntiAliasing"
	local NowAntiAliasing = URuntimeCommonFunctionLibrary.GetAntiAliasingMethodType()
	local AntiAliasingCache = EMCache:Get(OptionName) or NowAntiAliasing
	local AntiAliasingList
	if GameOverallPerformance == nil then
		GameOverallPerformance = -1
	end
	if CommonUtils.GetRuntimePlatform() == "Mobile" then
		if AntiAliasingCache ~= CommonConst.AntiAliasingClose then --移动端抗锯齿只允许为0和2
			AntiAliasingCache = 2
		end
        AntiAliasingList = {
			[-1] = AntiAliasingCache,
            [0] = 2, --TAA
            [1] = 2, --TAA
            [2] = 2, --TAA
            [3] = 2, --TAA
            [4] = 2, --TAA
        }
    else
        AntiAliasingList = {
			[-1] = AntiAliasingCache,
            [0] = 2, --TAA
            [1] = 2, --SMAA
            [2] = 4, --SMAA
            [3] = 4, --SMAA
            [4] = 4, --SMAA
        }
    end
	local InitAntiAliasing = AntiAliasingList[GameOverallPerformance]
	URuntimeCommonFunctionLibrary.SetAntiAliasingMethodType(InitAntiAliasing)
end

function SettingUtils.InitContentPerformanceCache()
	local OptionName = "ContentPerformance"
	local ContentPerformanceCache = EMCache:Get(OptionName)
	local NowContentPerformance = GWorld.GameInstance.GetGameplayScalabilityLevel()
	if ContentPerformanceCache ~= nil and ContentPerformanceCache ~= NowContentPerformance then
		GWorld.GameInstance.SetGameplayScalabilityLevel(ContentPerformanceCache)
	end
end

function SettingUtils.InitGameUserSettingsCache()
	local OptionName = "GameUserSettings"
	local CacheData = EMCache:Get(OptionName)
	local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
	if CacheData then
		for CacheName,CacheValue in pairs(CacheData) do
			if CacheName == "VSyncEnabled" then
				local NowValue = GameUserSettings:IsVSyncEnabled()
				if CacheValue ~= NowValue then
					GameUserSettings:SetVSyncEnabled(CacheValue)
				end
			else
				local NowValue = GameUserSettings['Get'..CacheName](GameUserSettings)
				if CacheValue ~= NowValue then
					GameUserSettings['Set'..CacheName](GameUserSettings,CacheValue)
				end
			end
		end
		GameUserSettings:ApplySettings(true)
	end
end

function SettingUtils.InitConsoleVariableCache()
	local OptionName = "ConsoleVariable"
	local CacheData = EMCache:Get(OptionName)
	if CacheData then
		for CacheName,CacheValue in pairs(CacheData) do
			local NowValue = UE4.UKismetSystemLibrary.GetConsoleVariableIntValue(CacheName)
			if CacheValue ~= NowValue then
				GWorld.GameInstance:SetGameScalabilityLevelByName(CacheName,CacheValue)
			end
		end
	end
end

function SettingUtils.InitGameMaxFPS()
	local OptionName = "Fps"
	local GameCache = EMCache:Get(OptionName)
	local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
	if GameCache then
		if GameCache == CommonConst.MaxFPS then
			GWorld.GameInstance:SetUnfixedFrameRate()
		else
			local FramePace = GameCache
			if GameCache == 45 then
				FramePace = 60
			end
			UE4.UKismetSystemLibrary.ExecuteConsoleCommand(GWorld.GameInstance,"r.SetFramePace "..FramePace,nil)
			GameUserSettings:SetFrameRateLimit(GameCache)
			GameUserSettings:ApplySettings(true)
		end
	else
		local DefaultFps
		--手机高配默认60帧，低配默认30帧;pc默认60帧
		if CommonUtils.GetRuntimePlatform() == "Mobile" then
			DefaultFps = 30
			local NowGameOverallPerformance = GWorld.GameInstance:GetOverallScalabilityLevel()
			if NowGameOverallPerformance >= CommonConst.OverallPerformanceHigh then
				DefaultFps = 60
			end
		else
			DefaultFps = 60
		end
		if DefaultFps == CommonConst.MaxFPS then
			GWorld.GameInstance:SetUnfixedFrameRate()
		else
			UE4.UKismetSystemLibrary.ExecuteConsoleCommand(GWorld.GameInstance,"r.SetFramePace "..DefaultFps,nil)
			GameUserSettings:SetFrameRateLimit(DefaultFps)
        	GameUserSettings:ApplySettings(true)
		end
	end
end

--移动端分辨率
function SettingUtils.InitMobileResolution(GameOverallPerformance)
	local MobileResolutionList
	local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(GWorld.GameInstance)
    if PlatformName == "Android" then
        MobileResolutionList = {
            [1] = {80,65,648},
            [2] = {85,65,684},
            [3] = {90,70,720},
			[4] = {95,75,764},
			[5] = {115,80,900},
        }
    elseif PlatformName == "IOS" then
        MobileResolutionList = {
            [1] = {55,55,0},
            [2] = {60,60,0},
            [3] = {65,65,0},
			[4] = {70,70,0},
			[5] = {85,85,0},
        }
    else
        return
    end
	if GameOverallPerformance == nil then
		GameOverallPerformance = -1
	end
	local CacheName = "MobileResolution"
	local OptionIndex = EMCache:Get(CacheName)
	if OptionIndex == nil then
		local OptionInfo = DataMgr.Option[CacheName]
		OptionIndex = tonumber(OptionInfo.DefaultValue)
	end
	if GameOverallPerformance >= 0 and GameOverallPerformance < 5 then
		OptionIndex = math.min(GameOverallPerformance + 1, #MobileResolutionList)
	end
	EMCache:Set(CacheName,OptionIndex)
	local MobileResolution = MobileResolutionList[OptionIndex]
	if MobileResolution then
		GWorld.GameInstance.SetScreenPercentageLevel(MobileResolution[1],MobileResolution[2],MobileResolution[3])
	end
end

--设置本地缓存
function SettingUtils.GetEMCache(CacheName,CacheKey,DefaultValue)
	local CacheData = EMCache:Get(CacheName)
	-- 设置选项迭代 覆盖旧的本地缓存
	if type(CacheData) ~= "table" and type(CacheData) ~= type(DefaultValue) then
		SettingUtils.SaveEMCache(CacheName,CacheKey,DefaultValue)
		return DefaultValue
	end
	if CacheData == nil then
		SettingUtils.SaveEMCache(CacheName,CacheKey,DefaultValue)
		return DefaultValue
	else
		if CacheKey then
			if CacheData[CacheKey] then
				return CacheData[CacheKey]
			end
			SettingUtils.SaveEMCache(CacheName,CacheKey,DefaultValue)
			return DefaultValue
		else
			return CacheData
		end
	end
	return DefaultValue
end

function SettingUtils.GetEMCacheForBL(OptionId)
	local OptionInfo = DataMgr.Option[OptionId]
	if not OptionInfo then
		return
	end
	local DefaultValue
	if UIUtils.IsMobileInput() and OptionInfo.DefaultValueM then
		DefaultValue = OptionInfo.DefaultValueM
	else
		DefaultValue = OptionInfo.DefaultValue
	end
	if OptionInfo.ControlType == "Switch" then
		DefaultValue = DefaultValue == "True"
	elseif OptionInfo.ControlType == "Scroll" or OptionInfo.ControlType == "UnFold" then
		DefaultValue = tonumber(DefaultValue)
	else
		return
	end
	local Value = SettingUtils.GetEMCache(OptionInfo.EMCacheName, OptionInfo.EMCacheKey, DefaultValue)
	return Value
end

function SettingUtils.SaveEMCache(CacheName,CacheKey,CacheValue)
	local CacheData = EMCache:Get(CacheName)
	if CacheKey	then
		if CacheData then
			CacheData[CacheKey] = CacheValue
		else
			CacheData = {}
			CacheData[CacheKey] = CacheValue
		end
	else
		CacheData = CacheValue
	end
	EMCache:Set(CacheName,CacheData)
end

function SettingUtils.GetUpValueByValueType(UpOptionValue)
	if UpOptionValue == true or UpOptionValue == false then
		return UpOptionValue and 2 or 1
	end
	return tonumber(UpOptionValue)
end

function SettingUtils.IsOpenRayTracing()
	return UE4.URuntimeCommonFunctionLibrary.GetRayTracingConfigEnabled() and UE4.URuntimeCommonFunctionLibrary.GetRayTracingEnabled()
end

function SettingUtils.ResetMobileResolution()
	local OptionName = "OverallPreset"
	local GameOverallPerformanceCache = EMCache:Get(OptionName)
	if GameOverallPerformanceCache == -1 then
		local NowGameOverallPerformance = GWorld.GameInstance:GetOverallScalabilityLevel()
		SettingUtils.InitMobileResolution(GameOverallPerformanceCache or NowGameOverallPerformance)
	else
		if rawget(SettingUtils, "DefaultMobileResolution") == nil then
			local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(GWorld.GameInstance)
			if PlatformName == "Android" then
				rawset(SettingUtils, "DefaultMobileResolution", {
					[0] = {80,60,648},
					[1] = {85,65,684},
					[2] = {90,70,720},
					[3] = {95,75,720},
					[4] = {115,80,900},
				})
			elseif PlatformName == "IOS" then
				rawset(SettingUtils, "DefaultMobileResolution", {
					[0] = {55,55,0},
					[1] = {60,60,0},
					[2] = {65,65,0},
					[3] = {70,70,0},
					[4] = {85,85,0},
				})
			else
				return
			end
		end
		local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
		if GameUserSettings then
			local AntiAliasingQuality = GameUserSettings:GetAntiAliasingQuality()
			local DefaultResolution = SettingUtils.DefaultMobileResolution[AntiAliasingQuality] or SettingUtils.DefaultMobileResolution[4]
			GWorld.GameInstance.SetScreenPercentageLevel(DefaultResolution[1],DefaultResolution[2],DefaultResolution[3])
		end
	end
end

function SettingUtils.IsShowRedDotForLayoutPlan()
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return false
	end
	local IsFirstShow = EMCache:Get("FirstOpenLayoutPlan", true)
	local Index = Avatar:GetCurrentMobileHudPlanIndex()
	if Index == 1 and not IsFirstShow and UIUtils.IsMobileInput() then
		return true
	end
	return false
end

function SettingUtils.InitRealtimeSunlight(GameOverallPerformance)
	if GameOverallPerformance == nil then
		GameOverallPerformance = -1
	end
	local CacheName = "RealtimeSunlight"
	local GameCache = EMCache:Get(CacheName)
	if GameCache == nil then
		local OptionInfo = DataMgr.Option[CacheName]
		if OptionInfo.DefaultValue == "True" then
			GameCache = true
		else
			GameCache = false
		end
	end
	if CommonUtils.GetRuntimePlatform() == "Mobile" then
		if GameOverallPerformance == 0 then
			GameCache = false
		elseif GameOverallPerformance > 0 then
			GameCache = true
		end
	end
	EMCache:Set(CacheName,GameCache)
	if GameCache then
       	URuntimeCommonFunctionLibrary.SetConsoleVariableIntValue("EM.FixedSunlightDirection", 0, 2)
    else
       	URuntimeCommonFunctionLibrary.SetConsoleVariableIntValue("EM.FixedSunlightDirection", 1, 2)
    end
end
return SettingUtils
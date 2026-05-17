--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

local EMCache = require "EMCache.EMCache"
local EMLuaConst = require "EMLuaConst"

local VariableForGM = {}

VariableForGM.IsInDebugMode = true

VariableForGM.EnableDrawDebugSphere = true

VariableForGM.EnableOpenLogMask = false

VariableForGM.EnableUIData = false

VariableForGM.EnableGodLike = false

VariableForGM.EnableShowBillboard = true

VariableForGM.EnableDrawOutline = true

VariableForGM.EnableDrawHairOutline = true

VariableForGM.EnableDrawMaterialCharacterRim = true

VariableForGM.EnableDrawPostProcessCharacterRim = false

VariableForGM.EnableCharacterDither = true

VariableForGM.SavedPlayerWorldPos = {X = 0,Y = 0,Z = 0}

VariableForGM.AutoResetCameraPitch = true

VariableForGM.AutoResetSpringArm = true

VariableForGM.SetPlayerGhost = false

VariableForGM.MaxTriggerProbability = false

VariableForGM.EnableShowDamageDetails = false

VariableForGM.EnableUseNewJumpWord = true

VariableForGM.DisableSkillFeatureCD = false

VariableForGM.UnlockRegionTeleport = false
VariableForGM.ShowRegionmapPane = false

VariableForGM.EnableConstrainAspect = false
VariableForGM.EnableMobilePostProcessFog = true
VariableForGM.EnableHardwareOcclusion = true
VariableForGM.EnableHZBOcclusion = false
VariableForGM.EnableDynamicShadows = true
VariableForGM.EnableGlobalIllumination = true
VariableForGM.EnableInstancedFoliage = true
VariableForGM.EnableInstancedGrass = true
VariableForGM.EnablePointLights = true
VariableForGM.EnableReflectionEnvironment = true
VariableForGM.EnableSkyLighting = true
VariableForGM.EnableMaterials = true
VariableForGM.EnableDirectLighting = true
VariableForGM.EnablePostProcessing = true
VariableForGM.EnableBloom = true
VariableForGM.EnableRendering = true
VariableForGM.EnableTranslucency = true
VariableForGM.EnableDebugLights = true
VariableForGM.EnableUseLightingScenario=true

VariableForGM.EnableRecordePlayerRoute = false

VariableForGM.EnableShowAchievement = true

VariableForGM.EnableShowLevelLoadingInfo = false
-- 送礼商店：是否忽略好友天数限制
VariableForGM.IgnoreGiftShopFriendLimit = false

VariableForGM.PrintPickupTriggerTick = false
VariableForGM.HideEntertainmentUI = false
VariableForGM.HideEntertainmentUIObj = {}
VariableForGM.HideStoryUI = false
VariableForGM.HideStoryUIObj = {}

-- 音频变量
VariableForGM.EnableAudioListenerDebug = false
VariableForGM.EnableBGM = true
VariableForGM.BGMEnableDebug = false
VariableForGM.EnableEMPreviewSound = false
VariableForGM.EnableDrawDebug = false
VariableForGM.SoundPointCompDebugEnabled = false
VariableForGM.SoundSplineDrawDebug = false
VariableForGM.ReverbLogicDebug = false
VariableForGM.LineSoundDebug = false
VariableForGM.SectorSoundDebug = false
VariableForGM.CircularSoundDebug = false

-- 飞行变量
VariableForGM.ForcePhantomUseRegionRule = false

--保存未定义的变量
VariableForGM.OtherVar = {}

--保存根据元表读写的变量,实现VarFunc[变量名_Get/_Set]函数即可
VariableForGM.VarFunc = {}

VariableForGM.VarFunc.EnableScreenMessages_Get = function (k)
    local res
    if(EMCache)then
        local GMInfo = EMCache:Get("GMInfo")
        if(GMInfo)then
            res = GMInfo.DisableScreenMessages
        end
    end
    return not res
end

VariableForGM.VarFunc.EnableScreenMessages_Set = function (k,v)
    if(EMCache)then
        local GMInfo = EMCache:Get("GMInfo") or {}
        GMInfo.DisableScreenMessages = not v
        EMCache:Set("GMInfo",GMInfo)
    end
end

VariableForGM.VarFunc.UseMapPhoneInPC_Get = function (k)
    if(EMCache)then
        local GMInfo = EMCache:Get("GMInfo")
        if(GMInfo and GMInfo.UseMapPhoneInPC ~= nil)then
            local res = GMInfo.UseMapPhoneInPC
            return not res
        end
    end
    return false
end

VariableForGM.VarFunc.UseMapPhoneInPC_Set = function (k,v)
    if(EMCache)then
        local GMInfo = EMCache:Get("GMInfo") or {}
        GMInfo.UseMapPhoneInPC = not v
        EMCache:Set("GMInfo",GMInfo)
    end
end

setmetatable(VariableForGM, {
    __index = function(t,k)
            if(t.VarFunc[k.."_Get"])then
                return t.VarFunc[k.."_Get"](k)
            else
                return t.OtherVar[k]
            end
        end,
    __newindex = function(t,k,v)
            if(t.VarFunc[k.."_Set"])then
                return t.VarFunc[k.."_Set"](k,v)
            else
                t.OtherVar[k] = v
            end
        end})

VariableForGM.VarFunc.EnableCustomTitleBar_Get = function(k)
    return EMLuaConst.bEnableCustomTitleBar
end
VariableForGM.VarFunc.EnableCustomTitleBar_Set = function(k,v)
    EMLuaConst.bEnableCustomTitleBar = v
end
VariableForGM.VarFunc.ForceUseCustomTitleBar_Get = function(k)
    return EMLuaConst.ForceUseCustomTitleBar
end
VariableForGM.VarFunc.ForceUseCustomTitleBar_Set = function(k,v)
    EMLuaConst.ForceUseCustomTitleBar = v
end

return VariableForGM

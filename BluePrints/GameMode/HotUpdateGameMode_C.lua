require "Unlua"

local HeroUSDKUtils = require "Utils.HeroUSDKUtils"
local EMCache = require "EMCache.EMCache"
local HotUpdateUtils = require "Utils.HotUpdateUtils"

---@type AHotUpdateGameMode
local M = Class()

function M:ShowOptionPatchPopUI(OptionalAssetsSize, TotalSize)
    local GameInstance = UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    ---@type Login_Main_PC_C
    local LoginMain = UIManager:GetUIObj("LoginMainPage")
    LoginMain:ShowOptionPatchPopUI(OptionalAssetsSize, TotalSize)
end

function M:ShowPatchResourcePopUI(BaseSize, TotalSize)
    local GameInstance = UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    ---@type Login_Main_PC_C
    local LoginMain = UIManager:GetUIObj("LoginMainPage")
    if LoginMain then
        LoginMain:ShowPatchResourcePopUI(BaseSize, TotalSize)
    else
        self:EnsureDonwloadOptionAssets(true)
    end
end

function M:ShowPatchUI()
    local GameInstance = UGameplayStatics.GetGameInstance(self)
    ---@type BP_UIManagerComponent_C
    local UIManager = GameInstance:GetGameUIManager()
    ---@type Login_Main_PC_C
    local LoginMain = UIManager:GetUIObj("LoginMainPage")
    LoginMain:ShowPatchUI()
end

function M:ShowLoginMainUI()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManger = GameInstance:GetGameUIManager()
    ---@type Login_Main_PC_C
    local LoginMain = UIManger:LoadUINew("LoginMainPage")
    -- HeroUSDKSubsystem(self):HeroSDKLogin()
    -- if HeroUSDKUtils.IsEnable() and HeroUSDKUtils.HasLogin() then
    --     LoginMain.CanvasPanel_SwitchAccount:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- end
    local PlayerController = UGameplayStatics.GetPlayerController(self, 0)
    if IsValid(PlayerController) then
        if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
            PlayerController.bShowMouseCursor = true
        else
            PlayerController.bShowMouseCursor = false
        end
    end
end

function M:ShowDownloadBasepakUI(bLargeVersion)
    local GameInstance = UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    ---@type Login_Main_PC_C
    local LoginMain = UIManager:GetUIObj("LoginMainPage")
    LoginMain:ShowDownloadBasepakUI(bLargeVersion)
end

-- function M:GetServerIdStr()
--     -- ---@type BP_UIManagerComponent_C
--     -- local UIManager = GWorld.GameInstance:GetGameUIManager()
--     -- ---@type Login_Main_2k_C
--     -- local LoginMainPage = UIManager:GetUIObj("LoginMainPage")
--     -- if LoginMainPage then
--     --     return LoginMainPage:GetServerIdStr()
--     -- end
--     return "Default"
-- end

function M:OnPatchPreSuccess(bFirst)
    if IsDedicatedServer(self) then
        return
    end
    local LoginMainPage = GWorld.GameInstance:GetGameUIManager():GetUIObj("LoginMainPage")
    if LoginMainPage then
        LoginMainPage:OnPatchPreSuccess(bFirst)
    end
end

function M:OnPatchFinished(bFrist)
    if IsDedicatedServer(self) then
        --先处理EMLuaConst,需求单重新整理下这个函数
        if bFrist then
            local EMLuaConst = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UEMLuaConst)
            if EMLuaConst then
                EMLuaConst:RefreshVars()
            end
        end
        return
    end
    if bFrist then --Patch会重置lua虚拟机，红点树需要重新初始化
        ReddotManager._Close()
        ReddotManager._Init()
        --重新初始化公告模块
        local AnnounceController = require "BluePrints.UI.WBP.Announcement.AnnounceController"
	    AnnounceController:Init() 
        local SystemLanguage = EMCache:Get("SystemLanguage")
        if SystemLanguage ~= nil then
            CommonConst.SystemLanguage = CommonConst.SystemLanguages[SystemLanguage]
        end
        local SystemVoice = EMCache:Get("SystemVoice")
        if SystemVoice ~= nil then
            CommonConst.SystemVoice = SystemVoice
        end
        local DelayFrameSubSystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UEMLuaTickManagerSubsystem)
        DelayFrameSubSystem.DelayFuncs = {}
        -- 区域数据管理器
        local RegionDataMgrSubSystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, URegionDataMgrSubsystem)
        if RegionDataMgrSubSystem then
            RegionDataMgrSubSystem:Initialize_Lua()
        end

        local EMLuaConst = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UEMLuaConst)
        if EMLuaConst then
            EMLuaConst:RefreshVars()
        end
        local SubSystems = UE4.URuntimeCommonFunctionLibrary.GetAllGameInstanceSubSystemImplementUnlua()
        if SubSystems then
            for _, SubSystem in pairs(SubSystems) do
                local InitLuaFunc = SubSystem["Initialize_Lua"]
                if InitLuaFunc and type(InitLuaFunc) == "function" then
                    InitLuaFunc(SubSystem)
                end
            end
        end
    end
    local LoginMainPage = GWorld.GameInstance:GetGameUIManager():GetUIObj("LoginMainPage")
    if LoginMainPage then
        LoginMainPage:OnPatchFinished(bFrist)
    end
end

function M:TryCompilePSO_Internal(bFirst)
    if IsDedicatedServer(self) then
        return
    end
    local LoginMainPage = GWorld.GameInstance:GetGameUIManager():GetUIObj("LoginMainPage")
    if LoginMainPage then
        LoginMainPage:PreBindDelegates()
    end
end

function M:ShowRestartDialog()
    ---@type Common_Dialog_Params
    local Params = {}
    Params.LeftCallbackObj = self
    Params.LeftCallbackFunction = self.QuitAndReopenGame
    Params.RightCallbackObj = self
    Params.RightCallbackFunction = self.QuitAndReopenGame
    Params.CloseBtnCallbackObj = self
    Params.CloseBtnCallbackFunction = self.QuitAndReopenGame
    UIManager(self):ShowCommonPopupUI(100053, Params)
end

function M:GetWhiteListDevices()
    local WhiteList = {
        -- "9ca064ed3f3c8aac",
    }
    return WhiteList
end

function M:GetPakOptionalSignBlacklist()
    return { "AudioCH", "AudioEN", "AudioJP", "AudioKR" }
end

function M:GetCurrentSystemVoiceOptionalSign()
    if CommonConst.SystemVoice == CommonConst.SystemVoices.CN or CommonConst.SystemVoice == CommonConst.SystemVoices.Default then
        return "VoiceCN"
    elseif CommonConst.SystemVoice == CommonConst.SystemVoices.JP then
        return "VoiceJP"
    elseif CommonConst.SystemVoice == CommonConst.SystemVoices.KR then
        return "VoiceKR"
    end
    return "VoiceEN"
end

function M:GetCustomSystemVoiceOptionalSign()
    return { "VoiceCN", "VoiceEN", "VoiceJP", "VoiceKR" }
end

function M:ClearCompilePSOFlag()
    EMCache:Set("SkipCompilePSO", false)
    EMCache:SaveCommon()
end

function M:ShouldCompilePSO_Inner()
    return not EMCache:Get("SkipCompilePSO")
end

function M:ClearCompilePSONumCache()
    EMCache:Set("LastCompiledPSONum", nil)
    EMCache:Set("CompiledPSONum", nil)
    EMCache:SaveCommon()
end

function M:CancelCompilePSO_Lua(bFirstPatch)
    EMCache:Set("SkipCompilePSO", true)
    EMCache:SaveCommon()
    self:CancelCompilePSO(bFirstPatch, true)
end

function M:TryShowPSOCompileDialog(bFirstPatch)
    local LastCompiledPSONum = EMCache:Get("LastCompiledPSONum") or -100
    local CompiledPSONum = EMCache:Get("CompiledPSONum") or -100
    if LastCompiledPSONum >= 0 and LastCompiledPSONum == CompiledPSONum then
        -- 显示弹窗
        local Params = {}
        Params.RightCallbackFunction = function()
            self:CancelCompilePSO_Lua(bFirstPatch)
        end
        Params.LeftCallbackFunction = function()
            self:EnsureCompilePSO(bFirstPatch)
        end
        UIManager(self):ShowCommonPopupUI(100308, Params, self)
    else
        self:EnsureCompilePSO(bFirstPatch) 
    end
end

function M:GetCurrentNecessoryPatchSigns()
    return HotUpdateUtils.GetNecessoryPatchSigns()
end

function M:IsCurrentNecessoryPatchSign(PatchSign)
    return HotUpdateUtils.IsCurrentNecessoryPatchSign(PatchSign)
end

return M
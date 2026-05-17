local HeroUSDKUtils = require "Utils.HeroUSDKUtils"
local CommonUtils = require "Utils.CommonUtils"
local SettingUtils = require "Utils.SettingUtils"
local EMACESubsystem = require "BluePrints.Managers.EMACESubsystem"

local M = {}

function M:EnterWorld()
    self:OnEnterWorld_HeroUSDK()
    self:OnEnterWorld_Sentry()
    EMACESubsystem:OnEnterWorld_ACE()
    SettingUtils.InitPerformanceSetting()
end

function M:OnEnterWorld_HeroUSDK()
    local HeroUSDKSubsystem = HeroUSDKSubsystem()
    if not HeroUSDKSubsystem then
        return
    end
    if self.Nickname and self.Nickname ~= "" then
        HeroUSDKSubsystem:HeroSDKRoleEnterGame(HeroUSDKUtils.GenHeroHDCGameRoleInfo())
    end
    HeroUSDKSubsystem:SetNewBDCPublicAttriubute(tostring(self.Uid), tostring(self.Hostnum))
    HeroUSDKSubsystem:MSDKUploadCommonEventByEventName("entry_game")
    ---@type UNewBdcSubsystem
    local BDCSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UNewBdcSubsystem)
    if BDCSubsystem then
        BDCSubsystem:Login(HeroUSDKSubsystem.UserInfo.sdkUserId, CommonUtils.ObjId2Str2(self.Eid))
    end
    -- self:SetNewBDCPublicAttriubute(CommonUtils.ObjId2Str(PlayerAvatar.Eid), PlayerAvatar.AccountId)
end

function M:OnEnterWorld_Sentry()
    local SentrySubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UEMSentrySubsystem)
    if not SentrySubsystem then
        return
    end
    SentrySubsystem:OnLoginSuccess()
end

return M
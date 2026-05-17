local MiscUtils = require "Utils.MiscUtils"
local CommonUtils = require "Utils.CommonUtils"

local M = {}
local ACEPendingData = {}
local SendACEToServer_Callback = nil
function M:Init_ACE_Windows(ACESubsystem)
    local function SendACEToServer(DelegateObject, PacketData, _)
        local BinaryString = PacketData
        if DelegateObject then 
            BinaryString = MiscUtils.ByteArrayToString(PacketData)
        end
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            Avatar:CallServerMethod("AceSendData", BinaryString)
        else 
            table.insert(ACEPendingData, BinaryString)
        end
    end
    SendACEToServer_Callback = SendACEToServer
    ACESubsystem.OnSendPacketToGameServerDelegate:Add(ACESubsystem, SendACEToServer)
end

function M:Init_ACE_Mobile(ACESubsystem)
    local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
    local IsIOS = PlatformName == "IOS"
    local function SendACEToServer(DelegateObject, PacketData, Type)
        local BinaryString = PacketData
        if DelegateObject then 
            BinaryString = MiscUtils.ByteArrayToString(PacketData)
        end
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            Avatar:CallServerMethod("MobileSendData" .. Type, BinaryString, IsIOS)
        else 
            table.insert(ACEPendingData, {PacketData = BinaryString, Type = Type})
            print("ACE Pending Data", PacketData:Num(), CommonUtils.ToHex(BinaryString))
        end
    end
    SendACEToServer_Callback = SendACEToServer
    ACESubsystem.OnSendPacketToGameServerDelegate:Add(ACESubsystem, SendACEToServer)
end

function M:FlushPendingData()
    local Avatar = GWorld:GetAvatar()
    if not Avatar or not SendACEToServer_Callback then 
        return
    end
    local Platform = CommonUtils.GetRuntimePlatform(self) 
    if Platform == "PC" then 
        for k, PendingData in ipairs(ACEPendingData) do 
            SendACEToServer_Callback(nil, PendingData)
        end
    elseif Platform == "Mobile" then 
        for k, PendingData in ipairs(ACEPendingData) do 
            SendACEToServer_Callback(nil, PendingData.PacketData, PendingData.Type)
        end
    end
    ACEPendingData = {}
end

function M:Init_ACE()
    if self.bInitACE then 
        self:FlushPendingData()
        return  
    end
    local ACESubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UACESubsystem)
    if not ACESubsystem then
        return
    end
    self.bInitACE = true
    local Platform = CommonUtils.GetRuntimePlatform(self)
    if Platform == "PC" then 
        self:Init_ACE_Windows(ACESubsystem)
    elseif Platform == "Mobile" then 
        self:Init_ACE_Mobile(ACESubsystem)
    end
end

function M:Login_ACE_Windows()
    local function Callback(_, Ticket)
        local ACESubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UACESubsystem)
        if not ACESubsystem then
            return
        end
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            ACESubsystem:Login(tostring(Avatar.Uid), 601 ,0, Ticket)
        end
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar then 
        Avatar:CallServer("AceGetTicket", Callback)
    end
end

function M:Login_ACE_Mobile()
    local ACESubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UACESubsystem)
    if not ACESubsystem then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        ACESubsystem:Login(tostring(Avatar.Uid), 99 ,0, "")
    end
end


function M:Login_ACE()
    local Platform = CommonUtils.GetRuntimePlatform(self)
    if Platform == "PC" then 
        self:Login_ACE_Windows()
    elseif Platform == "Mobile" then 
        self:Login_ACE_Mobile()
    end
end

function M:OnEnterWorld_ACE()
    self:Init_ACE()
    self:Login_ACE()
end

-- function M:OnHeroSdkLogin()
--     local ACESubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UACESubsystem)
--     if ACESubsystem then
--         self:Init_ACE()
--         ACESubsystem:Login(UserInfoStr.sdkUserId, 99 ,0, "")
--     end
-- end

return M
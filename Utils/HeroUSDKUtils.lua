local CommonConst = require "CommonConst"
local CommonUtils = require "Utils.CommonUtils"
local ServerConfig = require "ServerConfig"
local TimerMgr = require "BluePrints.Common.TimerMgr"

local HeroUSDKUtils = {}

function HeroUSDKUtils.IsEnable()
    return HeroUSDKSubsystem(GWorld.GameInstance):IsHeroSDKEnable()
end

function HeroUSDKUtils.IsGlobalSDK()
    return HeroUSDKSubsystem(GWorld.GameInstance):IsGlobalSDK()
end

function HeroUSDKUtils.HasLogin()
    return HeroUSDKSubsystem(GWorld.GameInstance).UserInfo.sdkUserId ~= ""
end

function HeroUSDKUtils.GetUserInfo()
    return HeroUSDKSubsystem(GWorld.GameInstance).UserInfo
end

function HeroUSDKUtils.GenHeroHDCGameRoleInfo(RoleId, RoleName, Level)
    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar then
        return
    end
    if not IsValid(GWorld.GameInstance) then
        return nil
    end

    local GameRoleInfo = FHeroHDCGameRoleInfo()
    GameRoleInfo.channelUserId = HeroUSDKSubsystem(GWorld.GameInstance).UserInfo.sdkUserId
    GameRoleInfo.gameUserId = CommonUtils.ObjId2Str(PlayerAvatar.Eid)
    GameRoleInfo.serverId = tostring(PlayerAvatar.Hostnum)
    -- todo lyz 后续正式选服流程需要修改
    GameRoleInfo.serverName = ServerConfig[PlayerAvatar.Hostnum].Name
    GameRoleInfo.roleId = PlayerAvatar.Uid
    GameRoleInfo.roleName = PlayerAvatar.Nickname
    GameRoleInfo.roleAvatar = ""
    GameRoleInfo.level = Level and tostring(Level) or tostring(PlayerAvatar.Level)
    GameRoleInfo.vipLevel = "0"
    GameRoleInfo.gold1 = tostring(PlayerAvatar.Resources[CommonConst.PlatinumItemId] and PlayerAvatar.Resources[CommonConst.PlatinumItemId].Count or 0)
    GameRoleInfo.gold2 = tostring(PlayerAvatar.Resources[CommonConst.ExpItemId] and PlayerAvatar.Resources[CommonConst.ExpItemId].Count or 0)
    return GameRoleInfo
end

function HeroUSDKUtils.SetHeroUSDKUploadBaseData(Data, PlayerAvatar)
    Data.Server_Id = tonumber(PlayerAvatar.HostNum)
    Data.Role_Id = CommonUtils.ObjId2Str(PlayerAvatar.Eid)
    Data.Role_Name = PlayerAvatar.Account
end

function HeroUSDKUtils.GenHeroUSDKUploadChatItemData(ChatContents)
    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar then
        return
    end

    local HeroUSDKUploadChatData = FHeroUSDKUploadChatData()
    
    for i = 1, #ChatContents do
        local HeroUSDKUploadChatItemData = FHeroUSDKUploadChatItemData()
        HeroUSDKUtils.SetHeroUSDKUploadBaseData(HeroUSDKUploadChatItemData, PlayerAvatar)
        HeroUSDKUploadChatItemData.Type = 0
        HeroUSDKUploadChatItemData.Message = tostring(ChatContents[i])
        HeroUSDKUploadChatItemData.Vip_Level = 0
        HeroUSDKUploadChatItemData.Level = PlayerAvatar.Level
        HeroUSDKUploadChatItemData.Channel_Id = HeroUSDKSubsystem():GetChannelId()
        HeroUSDKUploadChatData.Chat_Items:Add(HeroUSDKUploadChatItemData)
    end

    return HeroUSDKUploadChatData
end

function HeroUSDKUtils.GenHeroUSDKUploadReportData(ReportData)
    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar then
        return
    end

    local HeroUSDKUploadReportData = FHeroUSDKUploadReportData()

    for i = 1, #ReportData do
        local HeroUSDKUploadReportItemData = FHeroUSDKUploadReportItemData()
        HeroUSDKUtils.SetHeroUSDKUploadBaseData(HeroUSDKUploadReportItemData, PlayerAvatar)
        HeroUSDKUploadReportItemData.From_Server_Id = ReportData[i].FromServerId;
        HeroUSDKUploadReportItemData.From_Role_Id = ReportData[i].FromRoleId;
        HeroUSDKUploadReportItemData.From_Role_Name = ReportData[i].FromRoleName;
        HeroUSDKUploadReportItemData.Level = PlayerAvatar.Level;
        HeroUSDKUploadReportItemData.Vip_Level = 0;
        HeroUSDKUploadReportItemData.Text = ReportData[i].Text;
        HeroUSDKUploadReportItemData.Remark = ReportData[i].Remark;
        HeroUSDKUploadReportItemData.Reason = ReportData[i].Reason;
        HeroUSDKUploadReportData.Report_Items:Add(HeroUSDKUploadReportItemData)
    end

    return HeroUSDKUploadReportData
end


function HeroUSDKUtils.GenHeroUSDKUploadLogItemData(LogItemData)
    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar then
        return
    end

    local HeroUSDKUploadLogData = FHeroUSDKUploadLogData()

    for i = 1, #LogItemData do
        local HeroUSDKUploadLogItemData = FHeroUSDKUploadLogItemData()
        HeroUSDKUtils.SetHeroUSDKUploadBaseData(HeroUSDKUploadLogItemData, PlayerAvatar)
        HeroUSDKUploadLogItemData.Ban_Type = LogItemData[i].BanType
        HeroUSDKUploadLogItemData.Ban_Reason = LogItemData[i].BanReason
        HeroUSDKUploadLogItemData.Ban_Begin_Time = LogItemData[i].BanBeginTime
        HeroUSDKUploadLogItemData.Ban_End_Time = LogItemData[i].BanEndTime
        HeroUSDKUploadLogData.Log_Items:Add(HeroUSDKUploadLogItemData)
    end

    return HeroUSDKUploadLogData
end

function HeroUSDKUtils.CheckStringSensitive(CallObject, Str, SensitiveCallBack, NotSensitiveCallBack, SkipServerCheck)
    local SDKFinished = false
    local ServerFinished = SkipServerCheck or false
    local SDKSucc = false
    local ServerSucc = false
    local FirstSDKCheck = false
    local RealStr = string.gsub(Str, "%s", "")
    print(_G.LogTag,"LXZ SDK CheckStringSensitive")
    if SkipServerCheck then
        UIManager():_BlockAllUIInput(true, "CheckStringSensitive")
    end
    HeroUSDKSubsystem():RequestRealTimeContentValidate(RealStr, 
    {
        CallObject, function(CallObject, ResponseData)
            if SkipServerCheck then
                UIManager():_BlockAllUIInput(false, "CheckStringSensitive")
            end
            print(_G.LogTag,"LXZ SDK CheckStringSensitive Callback", ServerFinished, ServerSucc, ServerFinished)
            SDKFinished = true
            if ResponseData.Data.Result == 0 then
                SDKSucc = true
            end
            local ExtraParam = {
                SDKFinished = SDKFinished,
                ServerFinished = ServerFinished,
                SDKSucc = SDKSucc,
                ServerSucc = ServerSucc,
                FirstSDKCheck = FirstSDKCheck,
                ResponseData = ResponseData
            }
            HeroUSDKUtils.TryCheckStringSensitiveFinished(CallObject, Str, SensitiveCallBack, NotSensitiveCallBack, ExtraParam)
            FirstSDKCheck = true
        end
    },
    {

    })
    local Avatar = GWorld:GetAvatar()
    if not Avatar or ServerFinished then
        return
    end
    print(_G.LogTag,"LXZ Server CheckStringSensitive")
    local function CallBack(NowErrorCode, BackStr)
        ServerFinished = true
        if NowErrorCode == ErrorCode.RET_SUCCESS then
            ServerSucc = true
        end
        local ExtraParam = {
            SDKFinished = SDKFinished,
            ServerFinished = ServerFinished,
            SDKSucc = SDKSucc,
            ServerSucc = ServerSucc,
            FirstSDKCheck = FirstSDKCheck,
            ErrorCode = NowErrorCode,
            Str = BackStr
        }
        if (SDKFinished and SDKSucc) or not SDKFinished then
            HeroUSDKUtils.TryCheckStringSensitiveFinished(CallObject, Str, SensitiveCallBack, NotSensitiveCallBack, ExtraParam)
        end
    end
    Avatar:FilterStringSensitiveWord(RealStr, CallBack)
end

function HeroUSDKUtils.TryCheckStringSensitiveFinished(CallObject, Str, SensitiveCallBack, NotSensitiveCallBack, ExtraParam)
    print(_G.LogTag,"LXZ TryCheckStringSensitiveFinished", ExtraParam.ServerFinished, ExtraParam.SDKFinished, ExtraParam.ResponseData, ExtraParam.ServerSucc, ExtraParam.SDKSucc, ExtraParam.FirstSDKCheck)
    if ExtraParam.SDKFinished and not ExtraParam.FirstSDKCheck then
        HeroUSDKUtils.CheckStringSensitiveFinished(CallObject, Str, SensitiveCallBack, NotSensitiveCallBack, ExtraParam)
    elseif ExtraParam.ServerFinished and not ExtraParam.SDKFinished then
        TimerMgr.AddTimer(CallObject, 1, HeroUSDKUtils.CheckStringSensitiveFinished, false, 0, "WaitSensitiveFinished",
                            true, Str, SensitiveCallBack, NotSensitiveCallBack, ExtraParam)
    end
end

function HeroUSDKUtils.CheckStringSensitiveFinished(CallObject, Str, SensitiveCallBack, NotSensitiveCallBack, ExtraParam)
    TimerMgr.RemoveTimer(CallObject, "WaitSensitiveFinished", true)
    if not ExtraParam.ResponseData then
        if ExtraParam.ErrorCode == ErrorCode.RET_SUCCESS then
            print(_G.LogTag,"LXZ Server CheckStringSensitiveFinished succ")
            NotSensitiveCallBack(CallObject, Str)
        else
            --服务器暂时不返回敏感词列表
            print(_G.LogTag,"LXZ Server CheckStringSensitiveFinished fail")
            SensitiveCallBack(CallObject, ExtraParam.Str, Str, nil)
        end
    else
        print(_G.LogTag,"LXZ SDK CheckStringSensitiveFinished")
        if ExtraParam.ResponseData.Data.Result == 0 then
            print(_G.LogTag,"LXZ SDK CheckStringSensitiveFinished succ")
            print(_G.LogTag,"LXZ SDK CheckStringSensitiveFinished", ExtraParam.ResponseData.Msg, ExtraParam.ResponseData.Code)
            NotSensitiveCallBack(CallObject, Str)
        else
            print(_G.LogTag,"LXZ SDK CheckStringSensitiveFinished fail", ExtraParam.ResponseData.Data.Result)
            print(_G.LogTag,"LXZ SDK Msg:",ExtraParam.ResponseData.Msg)
            print(_G.LogTag,"LXZ SDK Code:",ExtraParam.ResponseData.Code)
            print(_G.LogTag,"LXZ SDK Data Result:",ExtraParam.ResponseData.Data.Result)
            print(_G.LogTag,"LXZ SDK Data Replace_Content:",ExtraParam.ResponseData.Data.Replace_Content)
            SensitiveCallBack(CallObject, ExtraParam.ResponseData.Data.Replace_Content, Str, ExtraParam.ResponseData.Data.Words)
        end
    end
end

function HeroUSDKUtils.IsSteamChannel()
    local Channel = UUsdkSettings:GetDefaultObject().Channel
    return Channel == EHeroUSDKChannel.Steam or Channel == EHeroUSDKChannel.Hero_Steam
end

function HeroUSDKUtils.GetAchievement_Steam(AchievementName)
    if not HeroUSDKUtils.IsSteamChannel() then
        return false, false
    end
    local Subsystem = HeroUSDKSubsystem(GWorld.GameInstance)
    local bAchieved = false
    local Success = Subsystem:GetAchievement_Steam(AchievementName, bAchieved)
    return Success, bAchieved
end

function HeroUSDKUtils.SetAchievement_Steam(AchievementName)
    if not HeroUSDKUtils.IsSteamChannel() then
        return false
    end
    local Subsystem = HeroUSDKSubsystem(GWorld.GameInstance)
    return Subsystem:SetAchievement_Steam(AchievementName)
end

function HeroUSDKUtils.StoreStats_Steam(Callback)
    if not HeroUSDKUtils.IsSteamChannel() then
        if Callback then
            Callback(false)
        end
        return
    end
    local Subsystem = HeroUSDKSubsystem(GWorld.GameInstance)
    Subsystem.HeroSDKStoreStatsResponseDelegate:Add(Callback)
    Subsystem:StoreStats_Steam()
end

function HeroUSDKUtils.SyncSteamAchievements(AchvMgr, Callback)
    if not HeroUSDKUtils.IsSteamChannel() then
        if Callback then
            Callback({})
        end
        return
    end

    -- Steam 客户端会在游戏启动前自动同步数据，不需要调用 RequestCurrentStats
    -- 直接获取成就状态即可
    DebugPrint("SyncSteamAchievements: Steam data already synced by client on launch")

    -- 使用预处理的 Steam 成就数据，避免遍历整个 Achievement 表
    local SteamAchievements = DataMgr.SteamAchievement
    if not SteamAchievements or #SteamAchievements == 0 then
        DebugPrint("No Steam achievements configured")
        if Callback then
            Callback({})
        end
        return
    end

    local AchievementsToSync = {}
    
    for _, Item in ipairs(SteamAchievements) do
        local AchvId = Item.AchvId
        local SteamAPIName = Item.SteamAPIName
        
        local Success, bSteamAchieved = HeroUSDKUtils.GetAchievement_Steam(SteamAPIName)
        if Success then
            local GameAchv = AchvMgr.Achvs[AchvId]
            local bGameFinished = GameAchv and GameAchv:IsFinished()
            
            DebugPrint("Check Achievement", AchvId, "SteamAPI:", SteamAPIName, "SteamAchieved:", bSteamAchieved, "GameFinished:", bGameFinished)
            
            if bGameFinished and not bSteamAchieved then
                table.insert(AchievementsToSync, {
                    AchvId = AchvId,
                    SteamAPIName = SteamAPIName
                })
            end
        else
            DebugPrint("GetAchievement_Steam failed for", SteamAPIName)
        end
    end

    if #AchievementsToSync == 0 then
        DebugPrint("No achievements need to sync")
        if Callback then
            Callback({})
        end
        return
    end

    DebugPrint("Found", #AchievementsToSync, "achievements to sync to Steam")
    
    local SyncedCount = 0
    local FailedCount = 0
    
    for _, Item in ipairs(AchievementsToSync) do
        local Result = HeroUSDKUtils.SetAchievement_Steam(Item.SteamAPIName)
        if Result then
            SyncedCount = SyncedCount + 1
            DebugPrint("SetAchievement_Steam success:", Item.SteamAPIName)
        else
            FailedCount = FailedCount + 1
            DebugPrint("SetAchievement_Steam failed:", Item.SteamAPIName)
        end
    end

    local function OnStoreStatsSuccess(bStoreSuccess)
        if bStoreSuccess then
            DebugPrint("StoreStats_Steam success, synced", SyncedCount, "achievements")
        else
            DebugPrint("StoreStats_Steam failed")
        end
        
        if Callback then
            Callback(AchievementsToSync, bStoreSuccess)
        end
    end
    
    HeroUSDKUtils.StoreStats_Steam(OnStoreStatsSuccess)
end

return HeroUSDKUtils
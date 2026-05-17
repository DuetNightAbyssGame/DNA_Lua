
require "UnLua"
local TeamCommon = require "BluePrints.UI.WBP.Team.TeamCommon"
local ChatCommon = require "BluePrints.UI.WBP.Chat.ChatCommon"
local PlayerHeadWidgetUtils = require "Utils.PlayerHeadWidgetUtils"
local M = Class("BluePrints.Common.TimerMgr")

function M:OnInitialize()
    EventManager:AddEvent(EventID.OnlineAddOtherPlayer, self, self.OnAddRegionOtherPlayer)
    EventManager:AddEvent(EventID.OnlineRemoveOtherPlayer, self, self.OnRemoveRegionOtherPlayer)
    EventManager:AddEvent(EventID.OnlineRegionNickNameChange, self, self.OnRegionPlayerInfoChange)
    EventManager:AddEvent(EventID.OnlineRegionTitleChange, self, self.OnRegionPlayerTitleChange)

    self.bRegisterTeamEvent = false
    self.EIdUIdMap = {}
    self.EIdObjIdMap = {}
    self.UIdEIdMap = {}
    self.EmojiTimer = {}
    self.EmojiDuration = 5
end

function M:OnDeinitialize()
    EventManager:RemoveEvent(EventID.OnlineAddOtherPlayer, self)
    EventManager:RemoveEvent(EventID.OnlineRemoveOtherPlayer, self)
    EventManager:RemoveEvent(EventID.OnlineRegionNickNameChange, self)
    EventManager:RemoveEvent(EventID.OnlineRegionTitleChange, self)

    self:UnRegisterTeamEvent()
end

function M:RegisterTeamEvent()
    if self.bRegisterTeamEvent then
        return
    end
    self.bRegisterTeamEvent = true
    local ListenEvent = {
        [TeamCommon.EventId.TeamOnAddPlayer] = true,
        [TeamCommon.EventId.TeamOnInit] = true,
        [TeamCommon.EventId.TeamOnMemberChange] = true,
    }
    local TeamOnDelPlayer = TeamCommon.EventId.TeamOnDelPlayer
    local TeamLeave = TeamCommon.EventId.TeamLeave
    TeamController:RegisterEvent(self, function(self, EventId, ...)
        -- DebugPrint("BP_SceneManagerComponent_C:RegisterTeamEvent", EventId)
        if EventId == TeamLeave then
            self:RefreshTeamIndex(...)
        elseif EventId == TeamOnDelPlayer then
            local Member = ...
            self:RefreshMember(Member.Uid)
        elseif ListenEvent[EventId] then
            self:RefreshTeamIndex()
        end
    end)

    ChatController:RegisterEvent(self, function(self, EventId, ...)
        if EventId == ChatCommon.EventID.RecvStickerInPubChannels then
            local Uid, EmojiPath = ...
            self:OnShowPlayerEmoji(Uid, EmojiPath)
        end
    end)
end

function M:RefreshTeamIndex(Team)
    local GameInstance = GWorld.GameInstance
    local RegionSyncSubsys = UE4.URegionSyncSubsystem.GetInstance(self)
    if not GameInstance then return end
    local ScenceManager = GameInstance:GetSceneManager()
    if not ScenceManager then return end
    local TeamData = Team or TeamController:GetModel():GetTeam()
    if not TeamData then return end
    local RegionOnlineCharacterInfo = ScenceManager.RegionOnlineCharacterInfo
    if not RegionOnlineCharacterInfo then return end
    local Battle = Battle(self)
    for _, Member in pairs(TeamData.Members) do
        local Uid = Member.Uid
        local Eid = RegionOnlineCharacterInfo[Uid]
        local ObjId = self.EIdObjIdMap[Eid]
        local Player = Eid and Battle:GetEntity(Eid)
        if RegionSyncSubsys then
            local WidgetComp = RegionSyncSubsys:GetPlayerHeadWidgetComp(CommonUtils.ObjId2Str(ObjId))
            PlayerHeadWidgetUtils:RefreshRegionNameInfo(WidgetComp, Uid, ObjId)
            PlayerHeadWidgetUtils:RefreshTitleInfo(WidgetComp, ObjId)
        elseif Player then
            Player:RefreshRegionNameInfo(Uid, ObjId)
            Player:RefreshTitleInfo(ObjId)
        end
    end
end

function M:RefreshMember(Uid)
    if not Uid then return end
    local GameInstance = GWorld.GameInstance
    local RegionSyncSubsys = UE4.URegionSyncSubsystem.GetInstance(self)
    if not GameInstance then return end
    local ScenceManager = GameInstance:GetSceneManager()
    if not ScenceManager then return end
    local RegionOnlineCharacterInfo = ScenceManager.RegionOnlineCharacterInfo
    if not RegionOnlineCharacterInfo then return end
    local Eid = RegionOnlineCharacterInfo[Uid]
    local ObjId = self.EIdObjIdMap[Eid]
    local Battle = Battle(self)
    local Player = Eid and Battle:GetEntity(Eid)
    if RegionSyncSubsys then
        local WidgetComp = RegionSyncSubsys:GetPlayerHeadWidgetComp(CommonUtils.ObjId2Str(ObjId))
        PlayerHeadWidgetUtils:RefreshRegionNameInfo(WidgetComp, Uid, ObjId)
        PlayerHeadWidgetUtils:RefreshTitleInfo(WidgetComp, ObjId)
    elseif Player then
        Player:RefreshRegionNameInfo(Uid, ObjId)
        Player:RefreshTitleInfo(ObjId)
    end
end

function M:UnRegisterTeamEvent()
    if not self.bRegisterTeamEvent then return end
    self.bRegisterTeamEvent = false
    TeamController:UnRegisterEvent(self)
    ChatController:UnRegisterEvent(self)
end

function M:HideCharacterHideUI(PlayerCharacter, bHide)
    local HeadWidgetComponent = PlayerCharacter:GetHeadWidgetComponent()
    if not HeadWidgetComponent then return end
    HeadWidgetComponent:SetUniformWidgetHideWithAnim(bHide, "RegionPlayer")
    if not bHide then
        local Eid = PlayerCharacter.Eid
        local Uid = self.EIdUIdMap[Eid]
        local ObjId = self.EIdObjIdMap[Eid]
        PlayerCharacter:RefreshRegionNameInfo(Uid, ObjId)
        PlayerCharacter:RefreshTitleInfo(ObjId)
    end
end

function M:OnAddRegionOtherPlayer(Eid, Uid, Player, ObjId)
    self:RegisterTeamEvent()
    local GameInstance = GWorld.GameInstance
    local RegionSyncSubsys = UE4.URegionSyncSubsystem.GetInstance(self)
    self.EIdUIdMap[Eid] = Uid
    self.EIdObjIdMap[Eid] = ObjId
    if RegionSyncSubsys then
        local WidgetComp = RegionSyncSubsys:GetPlayerHeadWidgetComp(CommonUtils.ObjId2Str(ObjId))
        if WidgetComp then
            PlayerHeadWidgetUtils:RefreshRegionNameInfo(WidgetComp, Uid, ObjId)
            PlayerHeadWidgetUtils:RefreshTitleInfo(WidgetComp, ObjId)
            local Widget = WidgetComp:GetWidget() or nil
            if Widget and Widget.Npc_Name_PC then
                Widget.Npc_Name_PC:SetRenderOpacity(1.0)
            end
        end
        return
    end
    if not Player then 
        return 
    end
    Player:InitHeadWidgetComponent()
    Player:RefreshRegionNameInfo(Uid, ObjId)
    Player:RefreshTitleInfo(ObjId)
    self:AddRegionPlayer(Player)
    self:HideCharacterHideUI(Player, true)
end

function M:OnRegionPlayerInfoChange(ObjId, Uid)
    if not Uid then return end
    local GameInstance = GWorld.GameInstance
    if not GameInstance then return end
    local ScenceManager = GameInstance:GetSceneManager()
    if not ScenceManager then return end
    local RegionOnlineCharacterInfo = ScenceManager.RegionOnlineCharacterInfo
    if not RegionOnlineCharacterInfo then return end
    local Eid = RegionOnlineCharacterInfo[Uid]
    local RegionSyncSubsys = UE4.URegionSyncSubsystem.GetInstance(self)
    if RegionSyncSubsys  then
        PlayerHeadWidgetUtils:RefreshRegionNameInfo(RegionSyncSubsys:GetPlayerHeadWidgetComp(CommonUtils.ObjId2Str(ObjId)), Uid, ObjId)
        return
    end
    local Battle = Battle(self)
    local Player = Eid and Battle:GetEntity(Eid)
    if Player then
        Player:RefreshRegionNameInfo(Uid, ObjId)
    end
end

function M:OnRegionPlayerTitleChange(ObjId, Uid, PrefixId, SuffixId, TitleFrameId)
    local GameInstance = GWorld.GameInstance
    if not GameInstance then return end
    local ScenceManager = GameInstance:GetSceneManager()
    if not ScenceManager then return end
    local RegionOnlineCharacterInfo = ScenceManager.RegionOnlineCharacterInfo
    if not RegionOnlineCharacterInfo then return end
    local Eid = RegionOnlineCharacterInfo[Uid]
    local RegionSyncSubsys = UE4.URegionSyncSubsystem.GetInstance(self)
    if RegionSyncSubsys  then
        PlayerHeadWidgetUtils:RefreshTitle(RegionSyncSubsys:GetPlayerHeadWidgetComp(CommonUtils.ObjId2Str(ObjId)), PrefixId, SuffixId, TitleFrameId)
        return
    end
    local Battle = Battle(self)
    local Player = Eid and Battle:GetEntity(Eid)
    if Player then
        Player:RefreshTitle(PrefixId, SuffixId, TitleFrameId)
    end
end

function M:OnRemoveRegionOtherPlayer(Eid, Uid)
    local Player = Battle(self):GetEntity(Eid)
    self.EIdUIdMap[Eid] = nil
    self.EIdObjIdMap[Eid] = nil
    if not Player then return end
    self:RemoveRegionPlayer(Player)
end

function M:PlayEmoji(ObjId, Eid, EmojiPath)
    local RegionSyncSubsys = UE4.URegionSyncSubsystem.GetInstance(self)
    if RegionSyncSubsys  then
        PlayerHeadWidgetUtils:PlayEmoji(RegionSyncSubsys:GetPlayerHeadWidgetComp(CommonUtils.ObjId2Str(ObjId)), EmojiPath)
        return
    end

    local Battle = Battle(self)
    local Player = Eid and Battle:GetEntity(Eid)
    if Player then
        Player:PlayEmoji(EmojiPath)
    end
end

function M:StopEmoji(ObjId, Eid)
    local RegionSyncSubsys = UE4.URegionSyncSubsystem.GetInstance(self)
    if RegionSyncSubsys  then
        PlayerHeadWidgetUtils:StopEmoji(RegionSyncSubsys:GetPlayerHeadWidgetComp(CommonUtils.ObjId2Str(ObjId)))
        return
    end

    local Battle = Battle(self)
    local Player = Eid and Battle:GetEntity(Eid)
    if Player then
        Player:StopEmoji()
    end
end

function M:OnShowPlayerEmoji(Uid, EmojiPath)
    local GameInstance = GWorld.GameInstance
    if not GameInstance then return end
    local ScenceManager = GameInstance:GetSceneManager()
    if not ScenceManager then return end
    local RegionOnlineCharacterInfo = ScenceManager.RegionOnlineCharacterInfo
    if not RegionOnlineCharacterInfo then return end
    local Eid = RegionOnlineCharacterInfo[Uid]
    local ObjId = self.EIdObjIdMap[Eid]
    if not ObjId then return end

    local Timer = self.EmojiTimer[ObjId]
    if Timer then
        self:RemoveTimer(Timer)
    end

    self:StopEmoji(ObjId, Eid, EmojiPath)
    self:PlayEmoji(ObjId, Eid, EmojiPath)
    Timer = self:AddTimer(self.EmojiDuration, function()
        self.EmojiTimer[ObjId] = nil
        self:StopEmoji(ObjId, Eid)
    end)
    self.EmojiTimer[ObjId] = Timer
end


return M
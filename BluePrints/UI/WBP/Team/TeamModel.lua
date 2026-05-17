
local TeamDatas = require "BluePrints.UI.WBP.Team.TeamData"
local TeamData = TeamDatas.TeamData
local StrLib = require "BluePrints.Common.DataStructure"
local Deque = StrLib.Deque
local GlobalConstant = DataMgr.GlobalConstant


---@class TeamModel:Model
---@field TeamData TeamData
---@field InviteRecvQueue Deque<InviteInfo>
local M=Class("BluePrints.Common.MVC.Model")

function M:Init()
    M.Super.Init(self)
    self.TeamData = nil
    self.TeamDataBackup = nil --在多人副本中，Avatar的TeamData会被备份，用于离开副本后恢复
    self.InviteRecvQueue = Deque.New()
    self.InviteSendBox = {}
    self.InviteTable = {}
    self.CachedRecoveryTeamInfo = nil
end

--region 队伍操作
function M:SetTeam(Team, bDsData)
    if Team == nil then
        self.TeamData = nil
        if not self.TeamData then
            -- Utils.Traceback("队伍被置空了, TeamData is nil")
            --@note 在队伍数据为空的时候清理一下队伍的聊天数据和红点数据
            ChatController:GetModel():ClearReddotCount(ChatCommon.ChannelDef.InTeam)
            ChatController:GetModel():ClearMessage(ChatCommon.ChannelDef.InTeam)
        end
        self.TeamDataBackup = nil
        return 
    end
    self.TeamData = TeamData.New(Team, bDsData)
end
---@return TeamData
function M:GetTeam()
    if not self.TeamData then
        DebugPrint(DebugTag,LXYTag, "GetTeam !!! TeamData is nil")
        return
    end
    return self.TeamData
end

function M:AddTeamMember(Member)
    --在Avatar备份有效的情况下，Avatar队伍的增减需要同步到备份中
    if self.TeamDataBackup then
        self.TeamDataBackup:AddMember(Member)
    end
    ---这里有点细节，如果是ds的队伍，则不能将Avatar的成员添加到队伍中
    if self.TeamData and not self.TeamData.bDsData then
        self.TeamData:AddMember(Member)
    end
end

---@param Param number|AvatarInfo
function M:DelTeamMember(Param)
    --在Avatar备份有效的情况下，Avatar队伍的增减需要同步到备份中
    if self.TeamDataBackup then
        local Uid = nil
        if type(Param) == "number" then
            Uid = Param
        else
            Uid = Param.Uid
        end
        local Member,Pos = self:GetTeamMember(Uid)
        if Member then
            self.TeamData:_DelMember(Pos)
        end
        self:_RealDelTeamMember(self.TeamDataBackup, Param)
    elseif self.TeamData and not self.TeamData.bDsData then
        self:_RealDelTeamMember(self.TeamData, Param)
    end
end

function M:TryAddCachedRecoveryTeamInfo(TeamInfo)
    if self.CachedRecoveryTeamInfo then
        if self.CachedRecoveryTeamInfo.Members then
            table.insert(self.CachedRecoveryTeamInfo.Members,TeamInfo)
        end
    end
end

function M:TryDelCachedRecoveryTeamInfo(Uid)
    if self.CachedRecoveryTeamInfo then
        if self.CachedRecoveryTeamInfo.Members then
            local RemovedIdx = nil
            for Idx,Member in ipairs(self.CachedRecoveryTeamInfo.Members or {}) do
                if Member.Uid == Uid then
                    RemovedIdx = Idx
                    break
                end
            end
            if RemovedIdx then
                table.remove(self.CachedRecoveryTeamInfo.Members, RemovedIdx)
            end
            if #self.CachedRecoveryTeamInfo.Members == 1 then
                self.CachedRecoveryTeamInfo = nil
            end
        else
            self.CachedRecoveryTeamInfo = nil
        end
    end
end

function M:TryChangeLeaderInRecoveryTeamInfo(LeaderUid)
    if self.CachedRecoveryTeamInfo then
        if self.CachedRecoveryTeamInfo then
            self.CachedRecoveryTeamInfo.LeaderId = LeaderUid
        end
    end
end

function M:_RealDelTeamMember(Team, Param)
    if type(Param) == "number" then
        local Uid = Param
        if self:IsMemberExist(Uid) then
            Team:DelMemberByUid(Uid)
        end
    else
        local Member = Param
        if self:IsMemberExist(Member.Uid) then
            Team:DelMemberByUid(Member.Uid)
        end
    end
end

--ds的队伍减员
function M:DelTeamMemberWithDs(Eid)
    if not self.TeamData then return end
    if not self.TeamData.bDsData then return end
    self:_RealDelTeamMember(self.TeamData, Eid)
end

--ds的队伍加人
function M:AddTeamMemberWithDs(WorldContext,Eid, PlayerState)
    if not self.TeamData then return end
    if not self.TeamData.bDsData then return end
    if self:IsMemberExist(Eid) then return end
    if not PlayerState then
        for i, TeampPlayerState in pairs(GameState(WorldContext).PlayerArray) do
            if Eid == TeampPlayerState.Eid then
                PlayerState = TeampPlayerState
                break
            end
        end
    end
    --ds队伍的Uid是Actor的Eid
    local Member = {
        Uid = Eid, 
        Eid = CommonUtils.Str2ObjId(PlayerState.AvatarEidStr),
        Nickname = PlayerState.PlayerName,
        Char = {
            CharId = PlayerState.CharId,
            Level = PlayerState.CharLevel,
        },
        MeleeWeapon = {
            WeaponId = PlayerState.MeleeWeaponId,
            Level = PlayerState.MeleeWeaponLevel,
        },
        RangedWeapon = {
            WeaponId = PlayerState.RangedWeaponId,
            Level = PlayerState.RangedWeaponLevel,
        },
        Level = PlayerState.PlayerLevel,
        IsInDungeon = true,
        IsOnline = not PlayerState.bIsEMInactive,
        PlayerState = PlayerState, 
        HeadIconId = PlayerState.HeadIconId,
        HeadFrameId = PlayerState.HeadFrameId,
        HeadState = PlayerState.bIsEMInactive and TeamCommon.HeadState.Offline or TeamCommon.HeadState.Normal,
        bDsData = true,
    }
    self.TeamData:AddMember(Member) 
    return true  
end

function M:SetTeamBackup(Team)
    if Team == nil then
        DebugPrint(LXYTag , "清空队伍备份")
        self.TeamDataBackup = nil
    else
        PrintTable(Team , 1 ,LXYTag.."设置队伍备份")
        self.TeamDataBackup = TeamData.New(Team)
    end
end

function M:GetTeamBackup()
    DebugPrint(LXYTag, "获取队伍备份")
    return self.TeamDataBackup
end

function M:CreateTeamDataWithDs(WorldContext)
    if GWorld:IsStandAlone() then return end
    DebugPrint("TeamSyncDebug   CreateTeamDataWithDs")
    --if self:GetTeam() then return end
    self:SetTeamBackup(self:GetTeam())
    local DsTeamData = {
        Members = {},
        LeaderId = 0,
    }
    self:SetTeam(DsTeamData, true)
    ---@param PlayerState BP_EMPlayerState_C
    for i, PlayerState in pairs(GameState(WorldContext).PlayerArray) do
        local Eid = PlayerState.Eid
        DebugPrint("TeamSyncDebug   CreateTeamDataWithDs, Seek PlayerState",Eid)
        self:AddTeamMemberWithDs(WorldContext, Eid,PlayerState)
    end
end

function M:DestoryTeamDataWithDs()
    DebugPrint("TeamSyncDebug  TeamModel DestoryTeamDataWithDs")
    if not self:GetTeam() then return end
    if not self.TeamData.bDsData then return end
    self:SetTeam(self.TeamDataBackup)
    self:SetTeamBackup(nil)
end

---@param Uid number
---@return AvatarInfo
function M:GetTeamMember(Uid)
    if self.TeamDataBackup then
        local Member, Pos = self.TeamDataBackup:GetMember(Uid)
        if Member then
            return Member, Pos
        end
    end
    if self.TeamData  then
        return self.TeamData:GetMember(Uid)
    end
    return nil, 0
end

function M:IsMemberExist(Uid)
    if self.TeamDataBackup then
        if self.TeamDataBackup:IsMemberExist(Uid) then return true end
    end
    if self.TeamData then
        if self.TeamData:IsMemberExist(Uid) then return true end
    end
    return false
end

function M:SetTeadLeaderId(Uid)
    --由于ds没有leader概念，Leader相关的需要尽可能从Avatar的队伍里操作
    if self.TeamDataBackup then
        self.TeamDataBackup:SetLeaderId(Uid)
        return
    end
    if self.TeamData  then
        self.TeamData:SetLeaderId(Uid)
    end 
end

function M:GetTeamLeaderId()
    --由于ds没有leader概念，Leader相关的需要尽可能从Avatar的队伍里操作
    if self.TeamDataBackup then
        return self.TeamDataBackup:GetLeaderId()
    end
    if self.TeamData then
        return self.TeamData:GetLeaderId()
    end
    
    return nil
end

function M:IsTeamLeader(Uid)
    --联机里面没有队长
    if not GWorld:IsStandAlone() then return false end
    if self.TeamDataBackup then
        return self.TeamDataBackup:IsLeader(Uid)
    end
    --由于ds没有leader概念，Leader相关的需要尽可能从Avatar的队伍里操作
    if self.TeamData then
        return self.TeamData:IsLeader(Uid)
    end
    return false
end
--endregion


--region 邀请信息操作
---@param InviteInfo InviteInfo
function M:PushInviteInfo(InviteInfo)
    if self.InviteTable[InviteInfo.Uid] then return end
    self.InviteTable[InviteInfo.Uid] = 1
    if self.InviteRecvQueue:Size() >= GlobalConstant.TeamInviteMax.ConstantValue then
        DebugPrint(ErrorTag, "PushInviteInfo Error !!! InviteQueue is full")
        return
    end
    DebugPrint(LXYTag,"组队邀请QueuePush", InviteInfo.Nickname)
    self.InviteRecvQueue:PushFront(InviteInfo)
end
function M:PopInviteInfo()
    if self.InviteRecvQueue:IsEmpty() then
        DebugPrint(DebugTag, "PopInviteInfo: InviteQueue is empty")
        return false
    end
    local InviteInfo =self.InviteRecvQueue:PopBack()
    self.InviteTable[InviteInfo.Uid] = nil
    -- Utils.Traceback(LXYTag.."  组队邀请QueuePop  "..InviteInfo.Nickname)
    return true
end
---@return InviteInfo
function M:GetBackInviteInfo()
    if self.InviteRecvQueue:IsEmpty() then
        DebugPrint(LXYTag, "GetBackInviteInfo: InviteQueue is empty")
        return
    end
    return self.InviteRecvQueue:Back()
end
function M:CleanInviteInfo()
    self.InviteRecvQueue:Init()
    self.InviteTable = {}
end

function M:IsInviteExist(InviteInfo)
    return self.InviteTable[InviteInfo.Uid]
end

function M:GetTeamOrientation()
    return self:GetAvatar().TeamOrientation
end

function M:AddSentInvite(Uid, TimerKey)
    self.InviteSendBox[Uid] = TimerKey
end
function M:DelSentInvite(Uid)
    self.InviteSendBox[Uid] = nil
end
function M:GetInviteSendBox()
    return self.InviteSendBox
end
--endregion

function M:GetOwnerEidOfUnknowEid(WorldContext,Eid)
    local GameState = GameState(WorldContext)
    for i,PhantomState in pairs(GameState.PhantomArray) do
        if PhantomState.Eid == Eid then
            return PhantomState.OwnerEid,Eid
        end
    end
    DebugPrint(LXYTag,ErrorTag, "魅影归属信息在PhantomState里没有初始化")
    local Entity = Battle(WorldContext):GetEntity(Eid)
    local PlayerEid = Entity.PhantomOwner and Entity.PhantomOwner.Eid or nil
    if not PlayerEid then
        DebugPrint(LXYTag, ErrorTag, "甚至魅影Entity的PhantomOwner也没有初始化")
        PlayerEid = Entity:GetInitLogicComp().PhantomOwnerEid or Entity.InitFinalInfo.PhantomOwnerEid
        if not PlayerEid then
            DebugPrint(LXYTag, ErrorTag, "魅影还是拿不到PhantomOwner!!!!这是要逼我去改PhantomCharacter？？？!!")
            return nil, Eid
        end
    end
    return PlayerEid,Eid
end


function M:Destory()
    self:CleanNowDungeonId()
    M.Super.Destory(self)
end

function M:IsTeammateByAvatarEid(AvatarEid)
	local Team = self:GetTeam()
    if not Team or not Team.Members then 
        return false
    end
    if (type(AvatarEid) == "string" and CommonUtils.IsObjIdStr(AvatarEid)) then
        AvatarEid = CommonUtils.Str2ObjId(AvatarEid)
    end

    for _,Member in ipairs(Team.Members) do
        if Member.Eid == AvatarEid then
            return true
        end
    end
	return false
end

---多人联机中，Uid就是Actor的Eid，否则就是Avatar的Uid
function M:IsYourself(Uid)
    if not GWorld:IsStandAlone() then
        local SelfEid = GWorld:GetMainPlayer().Eid
        if SelfEid then
            return Uid == GWorld:GetMainPlayer().Eid
        end
        local SelfMember= self:GetTeamMember(Uid)
        if SelfMember and self:GetAvatar() then
            return SelfMember.Nickname == self:GetAvatar().Nickname
        end
    else
        return Uid == self:GetAvatar().Uid
    end
    return false
end

function M:IsMatching()
    local MatchTimingBar = UIManager(self):GetUIObj("DungeonMatchTimingBar")

    DebugPrint("gmy@TeamModel:IsMatching", MatchTimingBar, self.bPressedMulti, self.bPressedSolo, (MatchTimingBar or self.bPressedMulti or self.bPressedSolo) and true)
    return (MatchTimingBar or self.bPressedMulti or self.bPressedSolo) and true
end

--region  联机投票发生到进入副本期间的副本ID缓存
function M:CacheNowDungeonId(DungeonId)
    self.DungeonId = DungeonId
end

function M:GetNowDungeonId()
    if not self.DungeonId then
        Utils.Traceback(ErrorCode, LXYTag.."联机投票发生到进入副本期间，副本ID缓存才是有效的，现在是nil")
        return nil
    end
    return self.DungeonId
end

function M:CleanNowDungeonId()
    self.DungeonId = nil
end
--endregion

-- 是否正在打开联机加载
function M:SetIsInOpenCoop(bIsInOpenCoop)
    self.IsInOpenCoop = bIsInOpenCoop
end

function M:GetIsInOpenCoop()
    return self.IsInOpenCoop
end

return M
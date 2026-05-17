
local GlobalConstant = DataMgr.GlobalConstant

local IsCanEnterMultiGame = function(TeamMember)
    if not TeamMember.AvatarStatus then
        Utils.Traceback(WarningTag, LXYTag.."队伍成员没有AvatarStatus数据，无法判断可联机,默认返回True, 有问题的队伍成员："..TeamMember.Nickname)
        return true
    end
    local Avatar = GWorld:GetAvatar()
    local bSelfInBigWorld = not Avatar:IsInDungeon()
    local bSuccess = true
    -- if bSelfInBigWorld and Avatar:IsInDungeon(TeamMember.AvatarStatus) then
    --     bSuccess = false
    -- end

    if bSuccess then
        for _, StateEnum in ipairs(TeamCommon.CanEnterMultiGameStatus) do
            if Avatar:CheckCanSetStatus(TeamMember.AvatarStatus, StateEnum) then
                PrintTable(TeamMember.AvatarStatus, 1, LXYTag.."  队伍成员"..TeamMember.Nickname.."可进入联机状态, 状态表：")
                return true
            end
        end
    end

    PrintTable(TeamMember.AvatarStatus, 1, WarningTag..LXYTag.."  队伍成员"..TeamMember.Nickname.."不可进入联机状态, 状态表：")
    TeamMember.HeadState = TeamCommon.HeadState.CantEnterDungeon
    return false
end

---@class TeamData 队伍数据
---@field TeamId number 队伍ID
---@field LeaderId number 队长Uid
---@field Hostnum number 所在区服
---@field Members table<AvatarInfo>
local TeamData = Class()

TeamData.TeamId = 0
TeamData.LeaderId = 0
TeamData.Hostnum = 0
TeamData.Members = nil
TeamData._MemberUids = nil
function TeamData.New(RawTeam, bDsData)
    local NewObj = {}
    setmetatable(NewObj, TeamData)
    NewObj._MemberUids = {}
    NewObj.Members = {}
    for K,V in pairs(RawTeam) do
        if NewObj[K] == nil then 
            DebugPrint(ErrorTag, "TeamData New Error!!!: RawTeam not TeamData Instance")
            return nil
        end
        NewObj[K] = V
    end
    for i, Member in ipairs(NewObj.Members) do
        NewObj._MemberUids[Member.Uid] = Member
        Member.HeadState = TeamCommon.HeadState.Normal
        Member.Index = i
        Member.IsCanEnterMultiGame = IsCanEnterMultiGame
    end
    NewObj.New = nil
    NewObj.bDsData = bDsData
    return NewObj
end

function TeamData:IsAnyMemberCanNotEnterDungeon()
    local Uids = {}
    for _, Member in ipairs(self.Members) do
        if not Member:IsCanEnterMultiGame() then
            table.insert(Uids, Member.Uid)
        end
    end
    if #Uids > 0 then
        return true, Uids
    end
    return false
end

function TeamData:SetLeaderId(Uid)
    self.LeaderId = Uid
end

function TeamData:IsLeader(Uid)
    return self.LeaderId == Uid
end

function TeamData:GetLeaderId()
    return self.LeaderId
end

function TeamData:AddMember(Member)
    if self._MemberUids[Member.Uid] then
        DebugPrint(LXYTag, "AddMember Error!!!: Team member Repeat", Member.Uid)
        return
    end
    self._MemberUids[Member.Uid] = Member
    if #self.Members > GlobalConstant.MaxTeamMember.ConstantValue then
        DebugPrint(LXYTag, "AddMember Error!!!: Team member limit exceed")
        return
    end
    Member.IsCanEnterMultiGame = IsCanEnterMultiGame
    table.insert(self.Members, Member)
    Member.Index = #self.Members
    Member.HeadState = TeamCommon.HeadState.Normal
end

function TeamData:_DelMember(Pos)
    if #self.Members == 0 then
        DebugPrint(LXYTag, "_DelMember Error!!!: Team member is empty")
        return
    end
    if not self.Members[Pos] then
        return
    end
    self._MemberUids[self.Members[Pos].Uid] = nil
    table.remove(self.Members, Pos)
    for i, Member in ipairs(self.Members) do
        Member.Index = i
    end
end

function TeamData:DelMemberByUid(Uid)
    local Member, Pos = self:GetMember(Uid)
    if Member == nil then
        return
    end
    self:_DelMember(Pos)
end

---@return AvatarInfo
function TeamData:GetMember(Uid)
    local Member = self._MemberUids[Uid]
    if not Member then
        DebugPrint(DebugTag, LXYTag, "TeamData GetMember :: Uid not found in Team member list", Uid)
        return nil, 0
    end
    return Member, Member.Index
end

function TeamData:IsMemberExist(Uid)
    return self._MemberUids[Uid]
end

---@alias InviteInfo AvatarInfo

return {
    TeamData = TeamData
}
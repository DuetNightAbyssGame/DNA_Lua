local TeamController = require "BluePrints.UI.WBP.Team.TeamController"

local Component = {}

function Component:EnterWorld()
	TeamController:Init()
end

function Component:LeaveWorld()
	TeamController:Destory()
end

---踢人
function Component:TeamKickMember(Uid)
	DebugPrint("TeamKickMember",Uid)
	local function Cb(ErrCode)
		if not ErrCode then
			ErrCode = ErrorCode.RET_SUCCESS
		end
		DebugPrint("TeamKickMember",ErrorCode:Name(ErrCode))
		TeamController:RecvTeamKickMember(ErrCode, Uid)
	end
	self:CallServer("TeamKickMember", Cb,Uid) 
end

function Component:NotifyTeamMemberPropChange(ChangeData,Uid)
	DebugPrint("NotifyTeamMemberPropChange",Uid,CommonUtils.TableToString(ChangeData))
	TeamController:RecvTeamMemberPropChange(ChangeData, Uid)
end
--发起组队邀请
function Component:TeamInvite(Uid)
	DebugPrint("TeamInvite",Uid)
    local function Cb(ErrCode)
        DebugPrint("TeamInvite",ErrorCode:Name(ErrCode))
		TeamController:RecvTeamInvite(ErrCode, Uid)
    end
	self:CallServer("TeamInvite", Cb,Uid) 
end

--拒绝组队邀请
function Component:TeamRefuseInvite(Uid,AutoRefuse)
	DebugPrint("TeamRefuseInvite",Uid,AutoRefuse)
	self:CallServerMethod("TeamRefuseInvite", Uid,AutoRefuse) 
end

-- function Component:TeamRequestTeamInfo()
-- 	DebugPrint("TeamRequestTeamInfo")
-- 	local function Cb(ErrCode,TeamInfo)
--         PrintTable(TeamInfo,3,LXYTag.."TeamRequestTeamInfo  "..ErrorCode:Name(ErrCode))
-- 		TeamController:RecvTeamRefresh(ErrCode, TeamInfo)
--     end
-- end

function Component:TeamRequestTeamInfo(TeamInfo)
	-- DebugPrint("TeamRequestTeamInfo")
	-- local function Cb(ErrCode,TeamInfo)
    PrintTable(TeamInfo,3,LXYTag.."TeamRequestTeamInfo  ")
    --end
end

--同意组队邀请
function Component:TeamAgreeInvite(Uid)
	DebugPrint("TeamAgreeInvite",Uid)
	local function Cb(ErrCode)
        DebugPrint("TeamAgreeInvite",ErrorCode:Name(ErrCode))
		TeamController:RecvTeamAgreeInvite(ErrCode, Uid)
    end
	self:CallServer("TeamAgreeInvite", Cb,Uid) 
end

function Component:TeamLeave()
	DebugPrint("TeamLeave")
	local function Cb(ErrCode)
        DebugPrint("TeamLeave Callback",ErrorCode:Name(ErrCode))
		
		TeamController:RecvTeamLeave(ErrCode)
    end
	self:CallServer("TeamLeave",Cb) 
end

function Component:TeamChangeLeader(NewLeaderUid)
	DebugPrint("TeamChangeLeader",NewLeaderUid)
	local function Cb(ErrCode)
        DebugPrint("TeamChangeLeader",ErrorCode:Name(ErrCode))
		TeamController:RecvTeamChangeLeader(ErrCode, NewLeaderUid)
    end
	self:CallServer("TeamChangeLeader",Cb,NewLeaderUid) 
end
function Component:SetTeamOrientation(NewTeamOrientation)
	DebugPrint("SetTeamOrientation",NewTeamOrientation)
	self:CallServerMethod("SetTeamOrientation",NewTeamOrientation) 
end

--通知收到邀请
function Component:NotifyTeamInviteReceived(InviteInfo)
	PrintTable(InviteInfo,100,"NotifyTeamInviteReceived  ")
	TeamController:RecvTeamBeInvited(InviteInfo)
end
--通知组队邀请被拒绝
function Component:NotifyTeamInviteRefused(Uid)
	DebugPrint("NotifyTeamInviteRefused",Uid)
	if type(Uid) == "table" then
		Uid = Uid.Uid
	end
	TeamController:RecvTeamBeRefused(Uid)
end
function Component:NotifyTeamMemberSelectWalnut(Uid,WalnutId)
	DebugPrint("NotifyTeamMemberSelectWalnut",Uid,WalnutId)
	EventManager:FireEvent(EventID.TeamSelectWalnut, Uid, WalnutId)

end

function Component:NotifyTeamMemberSelectTicket(Uid, TicketId)
	DebugPrint("NotifyTeamMemberSelectTicket",Uid,TicketId)
end

--通知组队邀请被同意
function Component:NotifyTeamInviteAgreed(Uid)
	DebugPrint("NotifyTeamInviteAgreed",Uid)
	TeamController:RecvTeamBeAgreed(Uid)
end
function Component:NotifyInitTeam(Team)
	PrintTable(Team,100,"NotifyInitTeam  ")
	TeamController:RecvTeamOnInit(Team)
end

function Component:TeamReconnectNotify(Team)
	PrintTable(Team,100,"TeamReconnectNotify  ")
	TeamController:RecvTeamRefresh(ErrorCode.RET_SUCCESS, Team)
end

function Component:NotifyAddMember(MemberInfo)
	PrintTable(MemberInfo,10,"NotifyAddMember  ")
	TeamController:RecvTeamOnAddPlayer(MemberInfo)
end

function Component:NotifyDelMember(Uid, LeaveReason)
	DebugPrint("NotifyDelMember",Uid)

	if not UIManager(self):GetUI("DungeonSettlement") then
		EventManager:FireEvent(EventID.TeamMatchCancel)
	end
	TeamController:RecvTeamOnDelPlayer(Uid, LeaveReason)
end
function Component:NotifyChangeLeader(Uid)
	DebugPrint("NotifyChangeLeader",Uid)
	TeamController:RecvTeamOnChangeLeader(Uid)
end

function Component:VoteStartBattle(bAccepted, SquadId, Callback)
	bAccepted = bAccepted and true or false
	SquadId = SquadId or 0

	local function cb(ret)
		if not ErrorCode:Check(ret) then
			return
		end

		if Callback then
			Callback(ret)
		end
	end
	print(_G.LogTag, "VoteStartBattle", bAccepted, SquadId)
	self:CallServer("VoteBattle", cb, bAccepted, SquadId)
end

--region TeamBattleEvent
-- 组队战斗事件
function Component:TeamBattleEvent(EventName, ...)
	print(_G.LogTag, "TeamBattleEvent", EventName)
	local func = self["TeamBattleEvent_"..EventName]
	if func then
		func(self, ...)
	else
		print(_G.LogTag, "Unknown TeamBattleEvent", EventName)
	end
end

-- 开始入场投票
function Component:TeamBattleEvent_StartVote(DungeonId, bMatch)
    DebugPrint("gmy@Component:TeamBattleEvent_StartVote", DungeonId)
    -- 尝试打开DungeonMatchTimingBar

    local Avatar = GWorld:GetAvatar()
    assert(Avatar, "Avatar is nil")
    -- 如果是本地发起匹配（页面已设置 bPressedMulti），则不拉起队友确认投票 UI
    local Model = TeamController and TeamController.GetModel and TeamController:GetModel() or nil
    if Model and Model.bPressedMulti then
        TeamController:RecvTeamOnVoteStart(DungeonId)
        return
    end
    local bIsInTeam = Avatar:IsInTeam()
    if bIsInTeam then
        -- 分包检查：若副本必要资源未下载，自动拒绝并弹出下载UI
        local PatchCond = DataMgr.DungeonPatchCondition and DataMgr.DungeonPatchCondition[DungeonId]
        local NecessaryPatch = PatchCond and PatchCond.NecessaryPatch
        if NecessaryPatch and #NecessaryPatch > 0 then
            local HotUpdateSubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UE4.UHotUpdateSubsystem)
            if HotUpdateSubsystem and not HotUpdateSubsystem:IsAllPatchOptionalSignsDownloaded(NecessaryPatch) then
                self:VoteStartBattle(false)
                UIManager(self):LoadUINew("OptionalPatch", NecessaryPatch)
                TeamController:RecvTeamOnVoteStart(DungeonId)
                return
            end
        end

        local Panel = UIManager(self):GetUI("DungeonMatchTimingBar")
        if Panel and Panel.bClosing then
            UIManager(self):UnLoadUINew("DungeonMatchTimingBar")
        end

        UIManager(self):LoadUINew("DungeonMatchTimingBar",
                DungeonId, Const.DUNGEON_MATCH_BAR_STATE.TEAMMATE_CONFIRMING, bMatch)
        TeamController:RecvTeamOnVoteStart(DungeonId)
    else
        assert(false, "Not in team")
    end
end

function Component:TeamBattleEvent_OnMemberVote(Uid, Code)
	DebugPrint(DebugTag, LXYTag, "TeamBattleEvent_OnMemberVote", Uid)
	TeamController:RecvTeamOnVoteAgreed(Uid)
end

-- 有人拒绝
function Component:TeamBattleEvent_Refused(Uid, Code)
	DebugPrint("gmy@Component:TeamBattleEvent_Refused", Code)
	if Code == ErrorCode.RET_SUCCESS then
		EventManager:FireEvent(EventID.TeamMatchOneRefused, Uid)
	else
		DebugPrint("gmy@Team Component:TeamBattleEvent_Refused", Uid, GWorld:GetAvatar().Uid)
		local _, MemberIndex = TeamController:GetModel():GetTeamMember(Uid)
		if Uid == GWorld:GetAvatar().Uid then
			UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Squad_Miss_Challenge"), MemberIndex), 1.5)
		else
			UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Squad_Miss_Online"), MemberIndex), 1.5)
		end
		EventManager:FireEvent(EventID.TeamMatchCancel)
	end
	
	TeamController:RecvTeamOnVoteRefused(Uid)
	self:TeamMatchOneRefused(Uid)
end

function Component:TeamMatchOneRefused(Uid)
	local CurSelectedDungeonId = TeamController:GetModel():GetNowDungeonId()
	
	DebugPrint("gmy@Team M:TeamMatchOneRefused", CurSelectedDungeonId)
	if CurSelectedDungeonId and DataMgr.Dungeon[CurSelectedDungeonId].IsWalnutDungeon then
		if UIManager(self):GetUI("WalnutChoice") then
			return
		end
		local TeamModel = TeamController:GetModel()
		if not TeamModel:IsYourself(Uid) then
			UIManager(self):ShowUITip("CommonToastMain",
					string.format(GText("UI_Walnut_Giveup_Toast"), GText(TeamModel:GetTeamMember(Uid).Nickname)), 1.5)
		end
	else

		if not TeamController:GetModel():IsYourself(Uid) then
			UIManager(self):ShowUITip("CommonToastMain", GText("TOAST_DUNGEON_CANCEL_REJECT"), 1.5)
		end
	end
end

-- 正在等待创建副本
function Component:TeamBattleEvent_WaitEntering()
	DebugPrint("gmy@Component:TeamBattleEvent_WaitEntering")
	EventManager:FireEvent(EventID.TeamMatchStartEntering)
	TeamController:RecvTeamOnVoteEntering()
end

-- 正在等待匹配
function Component:TeamBattleEvent_Matching()
	DebugPrint("gmy@Component:TeamBattleEvent_Matching")
	EventManager:FireEvent(EventID.TeamMatchStartMatching)
end

-- 有人离开，战斗取消
function Component:TeamBattleEvent_LeaveCancel()
	DebugPrint("gmy@Component:TeamBattleEvent_LeaveCancel")
	UIManager(self):ShowUITip("CommonToastMain", GText("TOAST_DUNGEON_CANCEL_LEAVETEAM"), 1.5)
	
	-- 如果是在副本enterdungeon again的话，在选择是否同意、匹配、选核桃过程中离队，都能继续进行下去
	DebugPrint("gmy@Team Component:TeamBattleEvent_LeaveCancel", UIManager(self):GetUI("DungeonSettlement"))
	
	if not UIManager(self):GetUI("DungeonSettlement") then
		EventManager:FireEvent(EventID.TeamMatchCancel)
	end
	EventManager:FireEvent(EventID.InterruptWalnutSelect)
	TeamController:RecvTeamOnVoteRefused()
end

-- 队长取消战斗
function Component:TeamBattleEvent_LeaderCancel()
	DebugPrint("gmy@Component:TeamBattleEvent_LeaderCancel")
	UIManager(self):ShowUITip("CommonToastMain", GText("TOAST_DUNGEON_CANCEL"), 1.5)
	EventManager:FireEvent(EventID.TeamMatchCancel)
	local LeaderUid = TeamController:GetModel():GetTeamLeaderId()
	TeamController:RecvTeamOnVoteRefused(LeaderUid)
end

-- 有队员退出匹配状态
function Component:TeamBattleEvent_MemberCancel()
	DebugPrint("gmy@Component:TeamBattleEvent_MemberCancel")
	UIManager(self):ShowUITip("CommonToastMain", GText("TOAST_DUNGEON_CANCEL_LEAVETEAM"), 1.5)
	if not UIManager(self):GetUI("DungeonSettlement") then
		EventManager:FireEvent(EventID.TeamMatchCancel)
	end
	
	TeamController:RecvTeamOnVoteRefused()
end

-- 加入场景失败，服务器内部问题导致
function Component:TeamBattleEvent_EnterFailed(Ret)
	DebugPrint(ErrorTag, "gmy@Component:TeamBattleEvent_EnterFailed", Ret)
	TeamController:RecvTeamOnVoteInvalid(Ret)
	EventManager:FireEvent(EventID.TeamMatchCancel)
end

-- DS Crash
function Component:TeamBattleEvent_BattleFailed()
	DebugPrint("gmy@Component:TeamBattleEvent_BattleFailed")
	if not self:IsInBigWorld() and not self:IsInSingleDungeon() and not self:IsInEnterSingleDungeon() then
		TeamController:RecvDsServerDie()
		self:ExitDungeon()
	end
	EventManager:FireEvent(EventID.TeamMatchCancel)
end

-- 开始选委托密函
function Component:TeamBattleEvent_SelectWalnut()
	local DungeonId = TeamController:GetModel():GetNowDungeonId()
	local WalnutChoice = UIManager(self):LoadUINew("WalnutChoice", CommonConst.WalnutUser.Depute, DungeonId)
	local WalnutId = TeamController:GetModel().WalnutId
    WalnutChoice:SelectWalnutById(WalnutId)
	EventManager:FireEvent(EventID.SelectWalnut)
end

function Component:TeamBattleEvent_WalnutSelectComplete()
	EventManager:FireEvent(EventID.WalnutSelectComplete)
end

function Component:TeamBattleEvent_SelectTicket()
	EventManager:FireEvent(EventID.SelectTicket)
	local function GetValidAvatar()
		local Avatar = GWorld:GetAvatar()
		if not Avatar then
			assert(Avatar, "Avatar is nil")
			return nil
		end
		return Avatar
	end
	local function OnRightConfirm(_, PackageData)
		local Avatar = GetValidAvatar()
		if not Avatar then return end
		--local CurSelectedDungeonId = TeamController:GetModel():GetNowDungeonId()
		-- DebugPrint("TeamBattleEvent_SelectTicket  CurSelectedDungeonId ",PackageData.Content_1.DungeonId)
		-- DebugPrint("TeamBattleEvent_SelectTicket  TicketId ",PackageData.Content_1.TicketId)
		Avatar:SelectTicket(nil, PackageData.Content_1.DungeonId, PackageData.Content_1.TicketId)
	end

	local function OnCancelVote()
		local Avatar = GetValidAvatar()
		if Avatar then
			Avatar:VoteStartBattle(false)
		end
	end

	local CurSelectedDungeonId = TeamController:GetModel():GetNowDungeonId()
	-- 弹出通用门票确认弹窗
	local CommonDialog = UIManager(self):ShowCommonPopupUI(100123, {
		DungeonId = CurSelectedDungeonId,
		RightCallbackFunction = OnRightConfirm,
		LeftCallbackFunction = OnCancelVote,
		CloseBtnCallbackFunction = OnCancelVote,
		DontCloseWhenRightBtnClicked = true,
		AutoFocus = true,
		YesButtonText = GText("UI_CONFIRM_SELECTION")
	}, self)
end

--endregion


return Component

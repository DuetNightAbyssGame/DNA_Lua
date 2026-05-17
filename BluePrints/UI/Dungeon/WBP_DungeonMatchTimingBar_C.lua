require "UnLua"
local TimeUtils = require "Utils.TimeUtils"
local DeputeDetail = require("BluePrints.UI.WBP.Play.Widget.Depute.WBP_Play_DeputeDetail_C")
-- UIName: DungeonMatchTimingBar
-- WBP: WBP_Team_Timing
local M = Class("BluePrints.UI.BP_UIState_C")

local DUNGEON_MATCH_BAR_STATE = Const.DUNGEON_MATCH_BAR_STATE
local STATE_SET_FUNCTOR = {}
local SQUAD_PANEL_MAP = {}

local WAITING_CONFIRM_TIME = CommonConst.ONLINE_TEAM_VOTE_TIME
local WAITING_MATCHING_TIME = CommonConst.ONLINE_MATCH_TIME

local PROGRESS_PERCENT_SIZE_X = 578

local FORCE_CLOSE_TIME = 30

function M:Construct()
	M.Super.Construct(self)
	STATE_SET_FUNCTOR =
	{
		[DUNGEON_MATCH_BAR_STATE.SPONSOR_WAITING_CONFIRM] = M.SetState_SponsorWaitingConfirm,
		[DUNGEON_MATCH_BAR_STATE.TEAMMATE_CONFIRMING] = M.SetState_TeammateConfirming,
		[DUNGEON_MATCH_BAR_STATE.TEAMMATE_WAITING_CONFIRMING] = M.SetState_TeammateWaitingConfirming,
		[DUNGEON_MATCH_BAR_STATE.WAITING_MATCHING] = M.SetState_WaitingMatching,
		[DUNGEON_MATCH_BAR_STATE.WAITING_MATCHING_WITH_CANCEL] = M.SetState_WaitingMatchingWithCancel,
		[DUNGEON_MATCH_BAR_STATE.WAITING_ENTER_DUNGEON] = M.SetState_WaitingEnterDungeon,
	}

	SQUAD_PANEL_MAP =
	{
		[DUNGEON_MATCH_BAR_STATE.TEAMMATE_CONFIRMING] = true,
	}
	self:SetMatchPanel()
	self:InitEvents()
	self:InitKeyMap()
	self:InitInputSettings()
end

function M:Destruct()
	self:ResetMatchPanel()
	self:ClearLoopSound()
	TeamController:SetTeamPopupBarOpen(false)
	M.Super.Destruct(self)
end

function M:Initialize(Initializer)
	self.Super.Initialize(self)
end

function M:OnLoaded(...)
	local DungeonId, EnterState, bIsMatch = ...
	-- DebugPrint("gmy@WBP_DungeonMatchTimingBar_C:OnLoaded ", DungeonId, EnterState, debug.traceback())
	self.DungeonId = DungeonId
	local DungeonData = DataMgr.Dungeon[self.DungeonId]
	assert(DungeonData, "副本ID错误" .. tostring(self.DungeonId))

	-- 如果是东国联机本，根据传送点找副本名称
	local TeleportId = self:GetTeleportIdByMultiplayerChallenge(DungeonId)

	local MatchTitle = nil
	if DungeonData.DungeonType == "HardBossDg" then
		MatchTitle = GText("UI_HardBoss_TabName_1")
		local DifficultyId = DataMgr.HardBossDg[DungeonId].DifficultyId
		local HardBossName = nil
		for _,HardbossMainData in pairs(DataMgr.HardBossMain) do
			if HardBossName then
				break
			end
			for _,Id in pairs(HardbossMainData.DifficultyId) do
				if DifficultyId == Id then
					HardBossName = HardbossMainData.HardBossName
					break
				end
			end
		end
		if HardBossName then
			MatchTitle = string.format("%s %s", MatchTitle, GText(HardBossName))
		end
		if DataMgr.HardBossDifficulty[DifficultyId] then
			local LevelText = GText("BATTLE_UI_BLOOD_LV")..DataMgr.HardBossDifficulty[DifficultyId].DifficultyLevel
			MatchTitle = string.format("%s %s", MatchTitle, LevelText)
		end
	elseif DungeonData.IsModDungeon then
		MatchTitle = GText("UI_DUNGEONMOD")
		if DungeonData.DungeonName then
			MatchTitle = string.format("%s %s", MatchTitle, GText(DungeonData.DungeonName))
		end
		if DungeonData.DungeonLevel then
			local LevelText = GText("BATTLE_UI_BLOOD_LV")..tostring(DungeonData.DungeonLevel)
			MatchTitle = string.format("%s %s", MatchTitle, LevelText)
		end
	elseif DungeonData.IsWalnutDungeon then
		MatchTitle = GText("UI_DUNGEONWALNUT")
		if DungeonData.DungeonName then
			MatchTitle = string.format("%s %s", MatchTitle, GText(DungeonData.DungeonName))
		end
		if DungeonData.DungeonLevel then
			local LevelText = GText("BATTLE_UI_BLOOD_LV")..tostring(DungeonData.DungeonLevel)
			MatchTitle = string.format("%s %s", MatchTitle, LevelText)
		end
	elseif TeleportId and TeleportId ~= -1 then
		if DataMgr.TeleportPoint[TeleportId] and DataMgr.TeleportPoint[TeleportId].TeleportPointName then
			MatchTitle = GText(DataMgr.TeleportPoint[TeleportId].TeleportPointName)
		end
		if DungeonData.DungeonLevel then
			local LevelText = GText("BATTLE_UI_BLOOD_LV")..tostring(DungeonData.DungeonLevel)
			MatchTitle = string.format("%s %s", MatchTitle, LevelText)
		end
	else
		MatchTitle = GText(DungeonData.DungeonName)
		local LevelIndex = self:GetDungeonIndex(DungeonId)
		local LevelText = GText(Const.RomanNum[LevelIndex])
		MatchTitle = string.format("%s%s", MatchTitle, LevelText)
	end

	DebugPrint("gmy@WBP_DungeonMatchTimingBar_C M:OnLoaded", DungeonId, LevelIndex)
	
	if bIsMatch then
		MatchTitle = string.format("%s%s", MatchTitle, GText('UI_DUNGEON_TITLE_MATCHING'))
	end
	self.bIsMatch = bIsMatch
	self.bIsFocusable = true
	self.SquadFolding = true


	self.Title_Level:SetText(MatchTitle)
	
	self.RemainTime = WAITING_MATCHING_TIME
	self.TotalTime = WAITING_MATCHING_TIME
	-- 记录下当前时间戳
	self.StartTimeStamp = os.clock()
	self:SwitchState(nil, EnterState)
	self:PlayInitSound()
	self:InitSquadPanel()
	self:InitWeekTip(DungeonId)
	TeamController:SetTeamPopupBarOpen(true)
end

function M:GetTeleportIdByMultiplayerChallenge(DungeonId)
	for _,MultiplayerChallengeData in pairs(DataMgr.MultiplayerChallenge) do
		if MultiplayerChallengeData.DungeonId and next(MultiplayerChallengeData.DungeonId) then
			for _,Id in pairs(MultiplayerChallengeData.DungeonId) do
				if Id == DungeonId then
					return MultiplayerChallengeData.TeleportId
				end
			end
		end
	end
	return -1
end

function M:PlayInitSound()
	--AudioManager(self):PlayUISound(self, "event:/ui/common/team_in_line_hud_show","dungeon_match_loop",nil)
end

function M:PlayCancelSound()
	AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_cancel","",nil)
end

function M:Tick(MyGeometry, InDeltaTime)
	self.Overridden.Tick(self, MyGeometry, InDeltaTime)

	self:UpdateTimeProgress(InDeltaTime)
end

function M:SwitchState(OldState, NewState)
	DebugPrint("gmy@M:SwitchState OldState, NewState", OldState, NewState)
	if OldState then
		-- todo
	else
		self:StopAllAnimations()
		self:PlayAnimation(self.In)
	end
	if OldState == NewState then return	end

	if DUNGEON_MATCH_BAR_STATE.WAITING_ENTER_DUNGEON == NewState then
		self:ClearLoopSound()
		AudioManager(self):PlayUISound(self, "event:/ui/common/team_in_line_confirm", "", nil)
	end

	self.NowState = NewState
	if NewState then
		self:SetState(NewState)
	end
end

function M:SetState(State)
	local Functor = STATE_SET_FUNCTOR[State]
	if Functor then
		Functor(self)
	end
end

function M:SetState_SponsorWaitingConfirm()
	DebugPrint("gmy@M:SetState_WaitingConfirm")
	AudioManager(self):PlayUISound(self, "event:/ui/common/team_in_line_hud_show", "dungeon_match_loop", nil)
	self.EndTimeStamp = self.StartTimeStamp + WAITING_CONFIRM_TIME
	local NowTime = os.clock()
	local Delay = self.EndTimeStamp - NowTime
	self.OvertimeTimer = self:AddTimer(Delay, self.OverTimeEnd, false)
	
	self.Text_Split:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self.Text_Timing:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self.Text_Split_1:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self.Panel_Enter:SetVisibility(ESlateVisibility.Collapsed)
	self.Text_Hint:SetText(GText('DUNGEON_TITLE_WAITING_CONFIRM'))

	self:SetBtnYes(false)
	self:SetBtnNo(true, GText('UI_PATCH_CANCEL'), function()
		DebugPrint("gmy@M:SponsorWaitingConfirm Cancel")
		local Avatar = GWorld:GetAvatar()
		if Avatar then
			if self:IsInSettlement() then
				Avatar:VoteStartBattle(false)
			else
				Avatar:CancelEnterDungeon(CommonConst.DungeonNetMode.DedicatedServer)
			end
			self:Close()
		end
		self:PlayCancelSound()
	end)
end

function M:SetState_TeammateConfirming()
	DebugPrint("gmy@M:SetState_TeammateConfirming")
	AudioManager(self):PlayUISound(self, "event:/ui/common/team_in_line_hud_show", "dungeon_match_loop", nil)

	-- todo 最好是读服务器时间
	local Avatar = GWorld:GetAvatar()
	self.EndTimeStamp = self.StartTimeStamp + WAITING_CONFIRM_TIME
	local NowTime = os.clock()
	local Delay = self.EndTimeStamp - NowTime
	self.OvertimeTimer = self:AddTimer(Delay, self.OverTimeEnd, false)
	
	self.Text_Split:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self.Text_Timing:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self.Text_Split_1:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self.Panel_Enter:SetVisibility(ESlateVisibility.Collapsed)
	self.Text_Hint:SetText(GText('DUNGEON_TITLE_CONFIRMING'))
	
	self:SetBtnYes(true, GText('UI_BTN_AGREE'), function()
		local SquadId = self:GetSquadId()
		DebugPrint("gmy@M:TeammateConfirm", SquadId)
		Avatar:VoteStartBattle(true, SquadId)
		self:SwitchState(self.NowState, DUNGEON_MATCH_BAR_STATE.TEAMMATE_WAITING_CONFIRMING)
	end)
	self:SetBtnNo(true, GText('UI_BTN_REJECT'), function()
		local SquadId = self:GetSquadId()
		DebugPrint("gmy@M:TeammateReject", SquadId)
		Avatar:VoteStartBattle(false, SquadId)
		self:PlayCancelSound()
		self:Close()
	end)
end

function M:SetState_TeammateWaitingConfirming()
	DebugPrint("gmy@M:SetState_TeammateWaitingConfirming")
	AudioManager(self):PlayUISound(self, "event:/ui/common/team_in_line_hud_show", "dungeon_match_loop", nil)
	self.bWaitingTextChange = true
	--self.Text_Hint:SetText(GText('DUNGEON_TITLE_WAITING_CONFIRM'))
	
	self:StopAllAnimations()
	self:PlayAnimation(self.Agree)
	
	-- 这个状态应该是TEAMMATE_CONFIRMING转换来的, EndTime也继承
	self:SetBtnYes(false)
	self:SetBtnNo(false)
end

-- 动效要求事件节点触发时更新文本
function M:TextChange()
	if self.bWaitingTextChange then
		if self.NowState == DUNGEON_MATCH_BAR_STATE.TEAMMATE_WAITING_CONFIRMING then
			self.Text_Hint:SetText(GText('DUNGEON_TITLE_WAITING_CONFIRM'))
		elseif self.NowState == DUNGEON_MATCH_BAR_STATE.WAITING_ENTER_DUNGEON then
			self.Text_Hint:SetText(GText('DUNGEON_TITLE_ENTER_GAME'))
		else
			self.Text_Hint:SetText(GText('DUNGEON_TITLE_MATCHING_GAME'))
		end
	end
end

function M:SetState_WaitingMatching()
	DebugPrint("gmy@M:SetState_WaitingMatching")
	
	AudioManager(self):PlayUISound(self, "event:/ui/common/team_in_line_state_search", "dungeon_match_loop", nil)
	
	-- 重置读条时间
	if self.OvertimeTimer then
		self:RemoveTimer(self.OvertimeTimer)
	end
	self.StartTimeStamp = os.clock()
	self.EndTimeStamp = self.StartTimeStamp + WAITING_MATCHING_TIME
	local NowTime = os.clock()
	local Delay = self.EndTimeStamp - NowTime
	self.OvertimeTimer = self:AddTimer(Delay, self.OverTimeEnd, false)

	self.Text_Split:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self.Text_Timing:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self.Text_Split_1:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self.Panel_Enter:SetVisibility(ESlateVisibility.Collapsed)
	
	--self.Text_Hint:SetText(GText('DUNGEON_TITLE_MATCHING_GAME'))

	--self:StopAllAnimations()
	self:PlayAnimation(self.Agree)
	self.bWaitingTextChange = true
	self:SetBtnYes(false)
	self:SetBtnNo(false)
	-- 超时保底关闭
	self:AddTimer(FORCE_CLOSE_TIME, function()
		if not self or self.bClosing then return end
		self:Close()
		UIManager(self):ShowUITip("CommonToastMain", GText("UI_Rematch_Fail_TimeOut"), 1.5)
	end, false)
end

function M:SetState_WaitingMatchingWithCancel()
	DebugPrint("gmy@M:SetState_WaitingMatchingWithCancel")

	AudioManager(self):PlayUISound(self, "event:/ui/common/team_in_line_state_search", "dungeon_match_loop", nil)
	self.EndTimeStamp = self.StartTimeStamp + WAITING_MATCHING_TIME
	local NowTime = os.clock()
	local Delay = self.EndTimeStamp - NowTime
	self.OvertimeTimer = self:AddTimer(Delay, self.OverTimeEnd, false)
	
	self.Text_Split:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self.Text_Timing:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self.Text_Split_1:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self.Panel_Enter:SetVisibility(ESlateVisibility.Collapsed)
	self.Text_Hint:SetText(GText('DUNGEON_TITLE_MATCHING_GAME'))
	
	self:SetBtnYes(false)
	self:SetBtnNo(true, GText('UI_PATCH_CANCEL'), function()
		DebugPrint("gmy@M:Matching Cancel")

		local Avatar = GWorld:GetAvatar()
		if Avatar then
			if self:IsInSettlement() then
				Avatar:VoteStartBattle(false)
			else
				Avatar:CancelEnterDungeon(CommonConst.DungeonNetMode.DedicatedServer)
			end
		end
		self:PlayCancelSound()
		self:Close()
    	EventManager:FireEvent(EventID.OnDisableEscOnDungeonLoading, false)
		EventManager:FireEvent(EventID.OnMatchStateChanged)
		UIManager(self):ShowUITip("CommonToastMain", GText("DUNGEONMATCH_CANCEL"), 1.5)
	end)
	-- 超时保底关闭
	self:AddTimer(FORCE_CLOSE_TIME, function()
		if not self or self.bClosing then return end
		self:Close()
		UIManager(self):ShowUITip("CommonToastMain", GText("UI_Rematch_Fail_TimeOut"), 1.5)
	end, false)
end

function M:SetState_WaitingEnterDungeon()
	DebugPrint("gmy@M:SetState_WaitingEnterDungeon")

	self.Panel_Enter:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self.Text_Split:SetVisibility(ESlateVisibility.Collapsed)
	self.Text_Timing:SetVisibility(ESlateVisibility.Collapsed)
	self.Text_Split_1:SetVisibility(ESlateVisibility.Collapsed)
	
	-- 策划要求去掉
	--self:BindToAnimationFinished(self.Enter, {self, function()
	--	self:Close()
	--end})
	self:PlayAnimation(self.Enter)
	self.bWaitingTextChange = true
	--self.Text_Hint:SetText(GText('DUNGEON_TITLE_ENTER_GAME'))
	
	self:SetBtnYes(false)
	self:SetBtnNo(false)
end

function M:UpdateTimeProgress(InDeltaTime)
	if self.StartTimeStamp and self.EndTimeStamp and self.StartTimeStamp < self.EndTimeStamp then
		self.RemainTime = self.RemainTime - InDeltaTime
		self.RemainTime = self.RemainTime > 0 and self.RemainTime or 0
		local ElapsedTime = self.TotalTime - self.RemainTime
		local Percent = ElapsedTime / self.TotalTime
		
		-- 设置尺寸
		local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Panel_Progress)
		local CurrentSize = CanvasSlot:GetSize()
		CanvasSlot:SetSize(FVector2D((1 - Percent) * PROGRESS_PERCENT_SIZE_X, CurrentSize.Y))

		self.Text_Timing:SetText(string.format(GText('DUNGEON_TIME_REMAIN_FMT'), self.RemainTime))
		if not self:HasFocusedDescendants() and TeamController:IsTeamPopupBarOpenInGamepad() then
			DebugPrint(LXYTag, WarningTag , "组队进本倒计时UI需要抢夺聚焦！！！！！！")
			self:SetFocus()
		end
	end
end

function M:OverTimeEnd()
	DebugPrint("gmy@M:OverTimeEnd")

	if self.OvertimeTimer then
		self:RemoveTimer(self.OvertimeTimer)
		self.OvertimeTimer = nil
	end

	self:ClearLoopSound()
	
	local NowState = self.NowState
	if NowState == DUNGEON_MATCH_BAR_STATE.WAITING_MATCHING_WITH_CANCEL then
		self:SwitchState(NowState, DUNGEON_MATCH_BAR_STATE.WAITING_ENTER_DUNGEON)
	elseif NowState == DUNGEON_MATCH_BAR_STATE.TEAMMATE_CONFIRMING then
		if self.bIsMatch then
			self:SwitchState(NowState, DUNGEON_MATCH_BAR_STATE.WAITING_MATCHING)
		else
			self:SwitchState(NowState, DUNGEON_MATCH_BAR_STATE.WAITING_ENTER_DUNGEON)
		end
	elseif NowState == DUNGEON_MATCH_BAR_STATE.SPONSOR_WAITING_CONFIRM then
		return
	elseif NowState == DUNGEON_MATCH_BAR_STATE.TEAMMATE_WAITING_CONFIRMING then
		return
	elseif NowState == DUNGEON_MATCH_BAR_STATE.WAITING_MATCHING then
		return
	else
		self:Close()
	end
end

function M:InitEvents()
	self:AddDispatcher(EventID.TeamMatchStartMatching, self, self.OnTeamMatchStartMatching)
	self:AddDispatcher(EventID.TeamMatchStartEntering, self, self.OnTeamMatchStartEntering)
	self:AddDispatcher(EventID.TeamMatchOneRefused, self, self.OnTeamMatchCancel)
	self:AddDispatcher(EventID.TeamMatchCancel, self, self.OnTeamMatchCancel)
	self:AddDispatcher(EventID.SelectWalnut, self, self.OnTeamMatchCancel)					--开始选择核桃时，隐藏倒计时进度条
	self:AddDispatcher(EventID.SelectTicket, self, self.OnTeamMatchCancel)					--开始选择门票时，隐藏倒计时进度条
	self:AddDispatcher(EventID.InLoading, self, self.ClearLoopSound)
	self:AddDispatcher(EventID.OnMatchPrepareToBattle, self, self.OnMatchPrepareToBattle)
	self:AddDispatcher(EventID.TeamMatchSquadFold, self, self.OnTeamMatchSquadFold)
	self:AddDispatcher(EventID.TeamMatchSquadUnfold, self, self.OnTeamMatchSquadUnfold)
	self:AddDispatcher(EventID.GameViewportInputKeyReleased, self, function(self, Key)
		if Key.KeyName == self.YES_KEY_TEXT then 
			self:ConfirmKeyDown()
		elseif Key.KeyName == self.NO_KEY_TEXT then 
			self:RefuseKeyDown()
		end
	end)
	
	self:AddDispatcher(EventID.GameViewportInputKeyPressed, self, function(self, Key)
		DebugPrint("gmy@WBP_DungeonMatchTimingBar_C M:InitEvents", Key.KeyName)
		if Key.KeyName == Const.GamepadSpecialRight then
			self:ConfirmKeyDown()
		elseif Key.KeyName == Const.GamepadSpecialLeft then
			self:RefuseKeyDown()
		end
	end)
	self:AddDispatcher(EventID.OnRequestToMatch, self, self.OnTeamMatchCancel)
end

function M:OnTeamMatchStartMatching()
	DebugPrint("gmy@M:OnTeamMatchStartMatching")
	local Avatar = GWorld:GetAvatar()
	if not Avatar then return end
	local bIsSoloMatch = not Avatar:IsInMultiSettlement()
	DebugPrint("gmy@WBP_DungeonMatchTimingBar_C M:OnTeamMatchStartMatching", bIsSoloMatch)
	if bIsSoloMatch then
		self:SwitchState(self.NowState, DUNGEON_MATCH_BAR_STATE.WAITING_MATCHING_WITH_CANCEL)
	else
		self:SwitchState(self.NowState, DUNGEON_MATCH_BAR_STATE.WAITING_MATCHING)
	end
end

function M:OnTeamMatchStartEntering()
	DebugPrint("gmy@M:OnTeamMatchStartEntering")
	self:SwitchState(self.NowState, DUNGEON_MATCH_BAR_STATE.WAITING_ENTER_DUNGEON)
end

function M:OnTeamMatchCancel(Ret)
	-- DebugPrint("gmy@WBP_DungeonMatchTimingBar_C M:OnTeamMatchCancel", tostring(Ret), debug.traceback())
	if not Ret then
		self:Close()
	elseif Ret == ErrorCode.RET_FAIL then -- 发起匹配失败 OnRequestToMatch 返回1
		self:Close()
		local ShowTipStr = GText("UI_Rematch_Fail_Client")
		UIManager(self):ShowUITip("CommonToastMain", ShowTipStr, 1.5)
	elseif Ret == ErrorCode.RET_SUCCESS then -- 发起匹配成功 OnRequestToMatch 返回0
		return
	elseif Ret == "Match Destroyed" then -- 匹配结束进入副本时DS已被销毁，OnMatchFailed 返回"Match Destroyed"
		self:Close()
		local ShowTipStr = GText("UI_Rematch_Fail_Server")
		UIManager(self):ShowUITip("CommonToastMain", ShowTipStr, 1.5)
	else
		self:Close()
		ErrorCode:Check(Ret, true)
	end
end

function M:SetMatchPanel()
	EventManager:FireEvent(EventID.TeamMatchTimingStart, true)
end

function M:ResetMatchPanel()
	TeamController:GetModel().bPressedSolo = false
	TeamController:GetModel().bPressedMulti = false
	EventManager:FireEvent(EventID.TeamMatchTimingEnd, false)
end

function M:Close()
	if not self then return end
	if not self.bClosing then
		self.bClosing = true
	else
		return
	end
	self:StopAllAnimations()
	self.Super.Close(self)
	self:ClearLoopSound()
	self:BindToAnimationFinished(self.Auto_Out, {self, self.RealClose})
	self:PlayAnimationForward(self.Auto_Out)
	self:RemoveAllDispatcher()
	
	if not self.SquadFolding then
		self:SetInputUIOnly(false)
	end
end

function M:ClearLoopSound()
	AudioManager(self):StopSound(self, "dungeon_match_loop")
end

function M:GetDungeonIndex(DungeonId)
	local ChapterId = DataMgr.DungeonId2ChapterId[DungeonId]
	
	local ChapterData = DataMgr.SelectDungeon[ChapterId]
	local WeeklyChapterData = DataMgr.WeeklySelectDungeon[ChapterId]
	
	if ChapterData then
		for Index, Id in ipairs(ChapterData.DungeonList) do
			if Id == DungeonId then
				return Index
			end
		end
	end
	
	if WeeklyChapterData then
		for Index, Id in ipairs(WeeklyChapterData.DungeonList) do
			if Id == DungeonId then
				return Index
			end
		end
	end
	
	return 1
end

function M:SetBtnYes(bVisible, Text, Callback)
	Text = Text or ""
	Callback = Callback or function() end
	self.YesCallback = Callback
	
	if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
		self.WidgetSwitcher_MP:SetActiveWidgetIndex(1)

		--self.BtnYes_Mobile:SetText(Text)
		self.BtnYes_Mobile:SetVisibility(bVisible and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
		self.BtnYes_Mobile:BindEventOnClicked(self, Callback)
	else
		self.WidgetSwitcher_MP:SetActiveWidgetIndex(0)
		
		self.BtnYes_PC:SetText(Text)
		self.BtnYes_PC:SetVisibility(bVisible and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
		self.BtnYes_PC:SetBtnNormalCallback(Callback)
		self.BtnYes_PC:SetImg(self.YES_GAMEPAD_IMG, self.YES_KEY_TEXT)
	end
end

function M:SetBtnNo(bVisible, Text, Callback)
	Text = Text or ""
	Callback = Callback or function() end
	self.NoCallback = Callback

	if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
		self.WidgetSwitcher_MP:SetActiveWidgetIndex(1)

		--self.BtnNo_Mobile:SetText(Text)
		self.BtnNo_Mobile:SetVisibility(bVisible and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
		self.BtnNo_Mobile:BindEventOnClicked(self, Callback)
	else
		self.WidgetSwitcher_MP:SetActiveWidgetIndex(0)

		self.BtnNo_PC:SetText(Text)
		self.BtnNo_PC:SetVisibility(bVisible and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
		self.BtnNo_PC:SetBtnNormalCallback(Callback)
		self.BtnNo_PC:SetImg(self.NO_GAMEPAD_IMG,self.NO_KEY_TEXT)
	end
end

--function M:OnKeyDown(MyGeometry, InKeyEvent)
--	DebugPrint("gmy@M:OnKeyDown 111", MyGeometry, InKeyEvent)
--
--	local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
--	local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
--
--	DebugPrint("gmy@M:OnKeyDown ", InKey, InKeyName)
--	return UE4.UWidgetBlueprintLibrary.Handled()
--end
--
--function M:OnKeyUp(MyGeometry, InKeyEvent)
--	DebugPrint("gmy@M:OnKeyUp 111", MyGeometry, InKeyEvent)
--
--	local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
--	local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
--	
--	return UE4.UWidgetBlueprintLibrary.Handled()
--end

function M:InitKeyMap()
	-- 缓存下按键和文本
	self.YES_KEY_TEXT = "Y"
	self.NO_KEY_TEXT = "N"
	self.YES_GAMEPAD_IMG = "Menu"
	self.NO_GAMEPAD_IMG = "View"
end

function M:ConfirmKeyDown()
	DebugPrint("gmy@M:ConfirmKeyDown")
	if self.YesCallback then
		self.YesCallback()
	end
end

function M:RefuseKeyDown()
	DebugPrint("gmy@M:RefuseKeyDown")
	if self.NoCallback then
		self.NoCallback()
	end
end

function M:OnMatchPrepareToBattle()
	DebugPrint("gmy@WBP_DungeonMatchTimingBar_C M:OnMatchPrepareToBattle")
	self:AddTimer(FORCE_CLOSE_TIME, function()
		if not self or self.bClosing then return end
		self:Close()
		UIManager(self):ShowUITip("CommonToastMain", GText("UI_Rematch_Fail_TimeOut"), 1.5)
	end, false)
end

function M:GetSquadInfo(DungeonId)
	local Avatar = GWorld:GetAvatar()
	if Avatar then
		local DungeonInfo = DataMgr.Dungeon[DungeonId]
		if DungeonInfo then
			local DungeonType = DungeonInfo.DungeonType
			local SquadIndex = Avatar.DungeonSquad[DungeonType] or 0

			if SquadIndex then
				local SquadInfo = Avatar.Squad[SquadIndex]
				if SquadInfo then
					return SquadInfo, SquadIndex
				end
			end
		end
	end

	return {}, 0
end

-- 获取当前选中的SquadId
function M:GetSquadId()
	if self.DefaultList and self.DefaultList.CurrentSquad then
		DebugPrint("gmy@WBP_DungeonMatchTimingBar_C M:GetSquadId", self.DefaultList.CurrentSquad)
		return self.DefaultList.CurrentSquad
	end
	
	DebugPrint("gmy@WBP_DungeonMatchTimingBar_C M:GetSquadId000")
	return 0
end

function M:InSameDungeonType()
	DebugPrint("gmy@WBP_DungeonMatchTimingBar_C M:InSameDungeonType", DeputeDetail.SelectedDungeonId)
	local Avatar = GWorld:GetAvatar()
	if not Avatar or not DeputeDetail.SelectedDungeonId then
		return false
	end
	local SelectedDungeonInfo = DataMgr.Dungeon[DeputeDetail.SelectedDungeonId]
	if not SelectedDungeonInfo then
		return false
	end
	local SelectedDungeonType = SelectedDungeonInfo.DungeonType
	
	local NowDungeonInfo = DataMgr.Dungeon[self.DungeonId]
	if not NowDungeonInfo then
		return false
	end
	
	local NowDungeonType = NowDungeonInfo.DungeonType
	return SelectedDungeonType == NowDungeonType
end

function M:InitSquadPanel()
	self.DefaultList:SetVisibility(ESlateVisibility.Visible)
	
	if self.NowState and self.DungeonId then
		local Avatar = GWorld:GetAvatar()
		if not Avatar then return end
		
		-- 1. 检查是否是发起者, 如果是发起者, 则隐藏Squad面板
		local bShowSquadPanel = SQUAD_PANEL_MAP[self.NowState]
		--local bIsInDungeonPanel = DeputeDetail.bOpened
		local bInSameDungeonType = self:InSameDungeonType()
		
		-- 2. 根据副本ID获取Squad配置
		local SquadInfo, SquadId = self:GetSquadInfo(self.DungeonId)
		local bIsNowEquipSquad = SquadId == 0

		-- 3. 检查是否处于结算界面， 如果是结算界面， 则隐藏Squad面板
		local SettlementUI = UIManager(self):GetUIObj("DungeonSettlement")
		local bIsSettlement = SettlementUI and SettlementUI:GetVisibility() ~= ESlateVisibility.Collapsed

		local DungeonData = DataMgr.Dungeon[self.DungeonId]
		
		DebugPrint("gmy@WBP_DungeonMatchTimingBar_C M:InitSquadPanel", self.NowState, bShowSquadPanel, SquadId, SquadInfo.Props, bIsNowEquipSquad, bInSameDungeonType)
		local bHidden = not bShowSquadPanel or nil == SquadInfo or (not bIsNowEquipSquad and nil == SquadInfo.Props) or bInSameDungeonType
						or (DungeonData and not DungeonData.Squad and DungeonData.DungeonType == "HardBossDg")
						or bIsSettlement
		self.DefaultList:SetVisibility(bHidden and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
		if bHidden then
			return
		end

		--self:SetSquadSelectBtnState(not bIsInDungeonPanel)
		
		self:RefreshSquadPanel(SquadId)
	else
		self.DefaultList:SetVisibility(ESlateVisibility.Collapsed)
	end
end

function M:InitInputSettings()
	local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
	self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
	DebugPrint("gmy@WBP_BattlePurchase_C M:OnUpdateUIStyleByInputTypeChange", CurInputDevice, CurGamepadName)
	
	self.DefaultList:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
	if (self.CurInputDeviceType == CurInputDevice) then
		return
	end
	self.CurInputDeviceType = CurInputDevice

	if (CurInputDevice == ECommonInputType.Touch) then
		-- 触控模式即默认样式，不需要刷新
		return
	end

	--- 切换手柄端相关图标显隐
	local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
	if IsUseKeyAndMouse then
		self.UsingGamepad = false
	else
		self.UsingGamepad = true
	end
end

function M:RefreshSquadPanel(SquadId)
	DebugPrint("gmy@WBP_DungeonMatchTimingBar_C M:RefreshSquadPanel", SquadId)
	self.DefaultList:Init(self, SquadId,self.DungeonId)
end

function M:SetSquadSelectBtnState(bActive)
	if bActive then
		self.DefaultList.WS_Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
		self.DefaultList.Btn_Show:SetVisibility(ESlateVisibility.Visible)
	else
		self.DefaultList.WS_Controller:SetVisibility(ESlateVisibility.Collapsed)
		self.DefaultList.Btn_Show:SetVisibility(ESlateVisibility.Collapsed)
	end
end

function M:OnTeamMatchSquadFold()
	DebugPrint("gmy@WBP_DungeonMatchTimingBar_C M:OnTeamMatchSquadFold")
	self:SetInputUIOnly(false)
	self.SquadFolding = true
end

function M:OnTeamMatchSquadUnfold()
	DebugPrint("gmy@WBP_DungeonMatchTimingBar_C M:OnTeamMatchSquadUnfold")
	self:SetInputUIOnly(true)

	self.SquadFolding = false
end

function M:IsInSettlement()
	return UIManager(self):GetUI("DungeonSettlement") ~= nil
end

function M:InitWeekTip(DungeonId)
	local Avatar = GWorld:GetAvatar()
	if Avatar and DungeonId and DataMgr.Dungeon[DungeonId] and DataMgr.Dungeon[DungeonId].DungeonType == "HardBossDg" then
		local RemainTimes = Avatar.HardBoss.HardBossRewardTimesLeft
		local DifficultyId = DataMgr.HardBossDg[DungeonId].DifficultyId
		if RemainTimes and RemainTimes <= 0 and Avatar.HardBoss:GetPassCount(DifficultyId) > 0 then
			self.GroupWeekly:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
			self.Text_WeeklyDesc:SetText(GText("UI_HardBoss_Match_Noreward"))
			self:PlayAnimation(self.Warning)
			return
		end
	end
	self.GroupWeekly:SetVisibility(ESlateVisibility.Collapsed)
end

return M
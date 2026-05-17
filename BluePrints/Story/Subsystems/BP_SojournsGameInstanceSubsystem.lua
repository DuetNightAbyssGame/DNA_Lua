
require "UnLua"
local GameFlowUtils = require "Utils.GameFlowUtils"

local EInvitationState = {
	None = "None",
	Going = "Going",
	Inviting = "Inviting",
	Backing = "Backing",
	Ending = "Ending",
	Recording = "Recording"
}

---@class (partial) BP_SojournsGameInstanceSubsystem_C
local M = Class("BluePrints.Common.TimerMgr")

local InviteLogType = UE.EStoryLogType.Invite

-- protected:

function M:PostOnInitialize()
	self:TryInitialize()
end

function M:PreOnDeinitialize()
	self.bIsInitialized = false
	if EventManager then
		EventManager:RemoveEvent(EventID.OnGuideStart, self)
		EventManager:RemoveEvent(EventID.OnGuideEnd, self)
	end
end

function M:OnCloseLoading()
	local GameMode = UE.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	local Avatar = GWorld:GetAvatar()
	--- 传送进入了副本，或者当前区域不对
	if (not GameMode) or (not GameMode:IsInRegion()) or (not Avatar) or (Avatar:GetCurrentRegionId() ~= self.TargetSubregionId) then
		self:StopInvitation()
	end
end

function M:OnInLoading() --- 还没开始进入传送阶段就被拉走了，说明被打断了，停止邀约
	if not self:IsInInvitation() then return end
	if self.InvitationState ~= EInvitationState.Inviting and self.InvitationState ~= EInvitationState.Backing then 
		self:StopInvitation()
		return
	end
end

function M:ListenInterruptInvitataion()
	EventManager:AddEvent(EventID.CloseLoading, self, self.OnCloseLoading)
	EventManager:AddEvent(EventID.InLoading, self, self.OnInLoading)
	EventManager:AddEvent(EventID.OnNetDisconnect, self, self.StopInvitation)
end


-- public:

function M:BeginInvitation(CharacterId, TopicLevel, bIsReview, OnFailed, OnSucceed)
	self:TryInitialize()

	if (self:IsInInvitation()) then
		DebugPrint(string.format("Error：邀约子系统：开始邀约失败，已处于邀约 %s 中。",
				self.InvitationState))
		return
	end
	local Avatar = GWorld:GetAvatar()
	self.PartyNPCData = DataMgr.PartyNpc[CharacterId]
	assert(self.PartyNPCData, string.format("Error：邀约子系统：PartyNpc 表不存在键：%d。", CharacterId))

	local PartyTopicId = self.PartyNPCData.PartyTopicList[TopicLevel]
	self.PartyTopicData = DataMgr.PartyTopic[PartyTopicId]
	assert(self.PartyTopicData, string.format("Error：邀约子系统：PartyTopic 表不存在键：%d。", PartyTopicId))
	self.TopicLevel = TopicLevel
	self.bIsReview = bIsReview
	self.InvitationState = EInvitationState.Going
	self:ListenInterruptInvitataion() --- 监听可能被拉去打副本或者进入其他区域，打断邀约

	Avatar:StartSojourns(CharacterId, TopicLevel, function(bSuccess, Ret)
		if not bSuccess then 
			self:StopInvitation()
			if OnFailed then
				OnFailed()
			end
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "邀约发起服务器返回失败", 
				string.format("邀约服务器返回失败 邀约ID: %d 邀约等级: %d 错误码 %d", CharacterId or -1, TopicLevel or -1, Ret))
			return
		end

		if not self:IsInInvitation() then
			if OnFailed then
				OnFailed()
			end
			return
		end

		self.Flow = GameFlowUtils:AddFlow("Sojourn", {
			self, function(_, Flow)
				if OnSucceed then
					OnSucceed()
				end
				DebugPrint(string.format("邀约子系统：开始邀约 %d %d %s。", CharacterId, TopicLevel, tostring(bIsReview)))
				-- self:ListenEnterOtherRegion() --- 监听进入其他区域，如果状态正确重跑STL
				self:StartStoryline()
			end
		})
	end)
end

function M:EndInvitation()
	self:TryInitialize()

	if (self:IsInInvitation() == false) then
		return
	end

	local CharacterId = self.PartyNPCData.CharId
	local TopicLevel = self.TopicLevel
	local bIsReview = self.bIsReview

	DebugPrint(string.format("邀约子系统：结束邀约 %d %d %s。", CharacterId, TopicLevel, tostring(bIsReview)))
	self:ClearInvitation()

	GameFlowUtils:AddFlow("Sojourn", {
		self, function(_, Flow)
			GameFlowUtils:AddFlow("OpenSystemUI", {
				self, function(_, FlowOpenUI)
					try{
						exec= function()
							UIManager(self):AddFlow("Entertainment", FlowOpenUI)
							UIManager(self):LoadUINew("Entertainment", CharacterId, TopicLevel, Flow)
						end,
						catch = function (err)
							GameFlowUtils:RemoveFlow(Flow)
							DebugPrint(ErrorTag, "LoadUINew Entertainment Error! traceback: ")
							Traceback(ErrorTag, err, false)
						end
					}
				end
			})
		end
	})
end

function M:StopInvitation()
	self:TryInitialize()

	if (self:IsInInvitation() == false) then
		return
	end

	local CharacterId = self.PartyNPCData.CharId
	local TopicLevel = self.TopicLevel
	local bIsReview = self.bIsReview

	DebugPrint(string.format("邀约子系统：停止邀约 %d %d %s。", CharacterId, TopicLevel, tostring(bIsReview)))
	self:StopJumpToSubregion()
	self:StopStoryline()
	self:StopBlackScreen()
	self:ClearInvitation()
end

function M:IsInInvitation()
	self:TryInitialize()
	return self.InvitationState ~= EInvitationState.None
end

function M:IsNeedBlockAfterLoading()
	self:TryInitialize()
	return self.InvitationState == EInvitationState.Going or self.InvitationState == EInvitationState.Inviting or self.InvitationState == EInvitationState.Backing
end

-- private:

function M:TryInitialize()
	if (self.bIsInitialized) then
		return
	end

	self.bIsInitialized = true

	self.InvitationState = EInvitationState.None

	self.PartyNPCData = nil
	self.PartyTopicData = nil
	self.TopicLevel = nil
	self.bIsReview = nil
	self.HomebaseSubregionId = 210101
	self.RecordWaitSeconds = 0.5

	self.TargetSubregionId = nil

	self.StorylinePath = nil
	self.OnStorylineCompleted = nil

	self.BlackScreenHandle = nil
	self.bSpecialGuide = false
	local SystemGuideId = DataMgr.GlobalConstant.InvitationGuideId
	self.ListenSystemGuideId = SystemGuideId and SystemGuideId.ConstantValue
	EventManager:AddEvent(EventID.OnGuideStart, self, self.OnGuideStart)
	EventManager:AddEvent(EventID.OnGuideEnd, self, self.OnGuideEnd)
end

function M:OnGuideStart(Guide)
	if self.ListenSystemGuideId == Guide then
		self.bSpecialGuide = true
	end
end

function M:OnGuideEnd(Guide)
	if self.ListenSystemGuideId == Guide then
		self.bSpecialGuide = false
	end
end

function M:ClearInvitation()
	DebugPrint("邀约子系统：清理邀约")
	self.InvitationState = EInvitationState.None
	local CharacterId = self.PartyNPCData.CharId
	local TopicLevel = self.TopicLevel
	self.PartyNPCData = nil
	self.PartyTopicData = nil
	self.TopicLevel = nil
	self.bIsReview = nil
	-- EventManager:RemoveEvent(EventID.OnRegionLoaded, self)
	EventManager:RemoveEvent(EventID.CloseLoading, self)
	EventManager:RemoveEvent(EventID.InLoading, self)
	EventManager:RemoveEvent(EventID.OnNetDisconnect, self)
	local Avatar = GWorld:GetAvatar()
	Avatar:ExitSojourns(CharacterId, TopicLevel, function (bSuccess, Ret)
		if not bSuccess then
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "邀约结束服务器返回失败", 
				string.format("邀约服务器返回失败 邀约ID: %d 邀约等级: %d 错误码 %d", CharacterId or -1, TopicLevel or -1, Ret))
		end
	end)
end

-- function M:GoToInviteLocation(OnFailed)
-- 	local TargetSubregionId = self.PartyTopicData.SubRegionId or self.HomebaseSubregionId
-- 	DebugPrint(string.format("邀约子系统：前往邀约地点 %d。", TargetSubregionId))
-- 	self.InvitationState = EInvitationState.Going
-- 	self:JumpToSubregion(TargetSubregionId, function()
-- 		-- self:ArriveAtInviteLocation(TargetSubregionId)
-- 		return true
-- 	end, OnFailed)
-- end

function M:OnEnterOtherRegion()
	if not self:IsInInvitation() then return end
	if self.InvitationState == EInvitationState.Inviting then
		self:StartStoryline()
	else
		self.InvitationState = EInvitationState.Ending
	end
end

function M:StartStoryline()
	local StorylinePath = self.PartyTopicData.PartyTopicTalkId

	local OnCompleted = function()
		GameFlowUtils:RemoveFlow(self.Flow)
		self.Flow = nil
		self:CompleteInvite()
	end
	local Avatar = GWorld:GetAvatar()
	DebugPrint(string.format("邀约子系统：传送至地点 %d，开始邀约剧情 %s。",Avatar.CurrentRegionId,
			StorylinePath))
	if not StorylinePath then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "邀约子系统错误: PartyTopicTalkId无效", 
			string.format("邀约STL配置为空,话题ID %d", self.PartyTopicData.PartyTopicId))
		OnCompleted()
		return
	end
	self.InvitationState = EInvitationState.Inviting
	self:RunStoryline(StorylinePath, OnCompleted)
end

function M:CompleteInvite()
	local TargetSubregionId = self.HomebaseSubregionId
	DebugPrint(string.format("邀约子系统：邀约完成，返回 %d。", TargetSubregionId))
	self.InvitationState = EInvitationState.Backing
	--self:StartBlackScreen()
	self:JumpToSubregion(TargetSubregionId, function()
		--self:StopBlackScreen()
		self:BackFromInvite()
		return true
	end)
end

function M:BackFromInvite()
	-- if (self.bIsReview) then
	-- 	self:EndInvitation()
	-- else
		
	-- end
	self:RecordInvite()
end

function M:RecordInvite()
	local CharacterId = self.PartyNPCData.CharId
	local TopicLevel = self.TopicLevel

	local Avatar = GWorld:GetAvatar()
	if (Avatar == nil) then
		DebugPrint("Error: 邀约子系统：记录邀约失败，Avatar 为空。")
		return
	end

	DebugPrint("邀约子系统：记录邀约。")
	self.InvitationState = EInvitationState.Recording

	self:StartBlackScreen()
	self:SetPlayerInputEnabled(false)

	Avatar:TriggerPartyTopicComplete(CharacterId, TopicLevel, function(Ret)
		ErrorCode:Check(Ret)

		self:StopBlackScreen()
		self:SetPlayerInputEnabled(true)

		self:EndInvitation()
	end)
end

function M:SetInvitationRegionId(TargetRegionId)
	if not self:IsInInvitation() then return end
	self.TargetSubregionId = TargetRegionId
end

function M:JumpToSubregion(TargetSubregionId, OnSucceed, OnFailed)
	local Avatar = GWorld:GetAvatar()
	if (Avatar == nil) then
		DebugPrint("Error: 跳转到 %d 子区域失败，Avatar 为空。", TargetSubregionId)
		if OnFailed then
			OnFailed()
		end
		return
	end

	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	if (IsValid(GameMode) == false) then
		DebugPrint("Error: 跳转到 %d 子区域失败，GameMode 为空。", TargetSubregionId)
		if OnFailed then
			OnFailed()
		end
		return
	end

	self:SetInvitationRegionId(TargetSubregionId)
	Avatar:StartJumpRegion(TargetSubregionId, function()
		self:StopJumpToSubregion(TargetSubregionId)
		if (OnSucceed) then
			OnSucceed()
		end
	end)
	--- ESC直接关闭
	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
	local UIManager = GameInstance:GetGameUIManager()
	if UIManager then
		local MenuWorld = UIManager:GetUI("MenuWorld")
		if (MenuWorld) then
			MenuWorld.CloseByChild = true
		end
	end
	GameMode:HandleLevelDeliver(UE4.EModeType.ModeRegion, TargetSubregionId, 1, nil, true)
end

function M:StopJumpToSubregion()
	local Avatar = GWorld:GetAvatar()
	if (Avatar == nil) then
		DebugPrint("Error: 中断跳转 %d 子区域失败，Avatar 为空。", self.TargetSubregionId)
		return
	end

	Avatar:StopJumpRegion(self.TargetSubregionId)
	self.TargetSubregionId = nil
end

function M:RunStoryline(StorylinePath, OnCompleted)
	self.StorylinePath = StorylinePath
	self.OnStorylineCompleted = function()
		self:ClearRunStorylineCache()

		if (OnCompleted) then
			OnCompleted()
		end
	end
	GWorld.StoryMgr:RunStory(StorylinePath, nil, nil, self.OnStorylineCompleted, nil, {
		bIsInvitation = true
	})
end

function M:StopStoryline()
	local StorylinePath = self.StorylinePath
	local OnCompleted = self.OnStorylineCompleted
	GWorld.StoryMgr:StopStoryline(StorylinePath, OnCompleted)

	self:ClearRunStorylineCache()
end

function M:ClearRunStorylineCache()
	self.StorylinePath = nil
	self.OnStorylineCompleted = nil
end

function M:StartBlackScreen()
	local UIManager = UIManager(self)
	if (IsValid(UIManager) == false) then
		DebugPrint("Error: 邀约子系统：开始黑屏失败，UIManager 为空。")
		return
	end
	if self.BlackScreenHandle then 
		self:StopBlackScreen()
	end
	self.BlackScreenHandle = UIManager:ShowCommonBlackScreen({})
end

function M:StopBlackScreen()
	local UIManager = UIManager(self)
	if (IsValid(UIManager) == false) then
		DebugPrint("Error: 邀约子系统：停止黑屏失败，UIManager 为空。")
		return
	end

	if (self.BlackScreenHandle) then
		UIManager:HideCommonBlackScreen(self.BlackScreenHandle)
		self.BlackScreenHandle = nil
	end
end

function M:SetPlayerInputEnabled(bNewEnabled)
	local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
	if (IsValid(PlayerCharacter) == false) then
		return
	end

	local UIManager = UIManager(self)
	if (IsValid(UIManager) == false) then
		return
	end

	local Tag = "Invitation"
	local KeyboardSetName = "Invitation"
	if (bNewEnabled) then
		PlayerCharacter:RemoveDisableInputTag(Tag)
		--UIManager:HideAllUI(false, Tag)
		UIManager:SetBannedActionCallback(KeyboardSetName, false, Tag)
	else
		PlayerCharacter:AddDisableInputTag(Tag)
		--UIManager:HideAllUI(true, Tag)
		UIManager:SetBannedActionCallback(KeyboardSetName, true, Tag)
	end
end

return M

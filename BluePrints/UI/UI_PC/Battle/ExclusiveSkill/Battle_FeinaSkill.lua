require "UnLua"

---@type WBP_Battle_FeinaSkill_C
local M = Class("BluePrints.UI.UI_PC.Battle.ExclusiveSkill.Base.Battle_Skill_UI_Base")

--function M:Initialize(Initializer)
--end

function M:Construct()
	self:InitListenEvent()
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
	self:StopAllAnimations()
end

function M:OnLoaded(OwnerPlayer, Params)
	self.Super.OnLoaded(self)
	EMUIAnimationSubsystem:EMPlayAnimation(self, self.In)

	self:InitFeinaUIInfo()
	self:InitBuffParam(OwnerPlayer, Params)
	self:ResetToNormal()
end

function M:InitBuffParam(PlayerCharacter, Params)
	self.Owner = PlayerCharacter
	self:K2_SetBuffsOwner(PlayerCharacter)
	self:RegisterOnBuffsChangedDelegate()

	self.Buff2Anim = {}
	self.Buff2State = {}
	self.Buff2Index = {}
	self.BuffAnimPlaying = {}
	-- Param = {["BuffId"] = "AnimationName"}
	if Params then
		for BuffId, BuffIndex in pairs(Params) do
			self.Buff2Anim[BuffId] = self.BuffAnims[BuffIndex]
			self.Buff2State[BuffId] = false
			self.Buff2Index[BuffId] = BuffIndex
			self.BuffAnimPlaying[BuffIndex] = false -- 初始化动画播放状态
		end
	end
	self.bHasBuff = false
end

-- 返回某个 Buff 索引当前是否有激活的 Buff（任意 BuffId 映射到该索引且处于激活态）
function M:IsBuffIndexActive(BuffIndex)
	if not self.Buff2State or not self.Buff2Index then
		return false
	end
	for BuffId, Index in pairs(self.Buff2Index) do
		if Index == BuffIndex and self.Buff2State[BuffId] then
			return true
		end
	end
	return false
end

function M:ResetToNormal(ExceptIndex)
	self:StopAllAnimations()
	for Index, NormalAnim in ipairs(self.SummonNormalAnim) do
		if Index ~= ExceptIndex then
			EMUIAnimationSubsystem:EMPlayAnimation(self, NormalAnim)
		end
	end

	-- 仅在没有对应激活 Buff 的情况下，才回收该索引的 Buff UI
	for BuffIndex, BuffAnim in pairs(self.BuffAnims) do
		local bHasActiveBuff = self.Buff2State and self.Buff2Index and self:IsBuffIndexActive(BuffIndex)

		if not bHasActiveBuff then
			-- 只有当 Buff 动画正在播放时，才需要播放反向动画来停止它
			if BuffAnim and self.BuffAnimPlaying and self.BuffAnimPlaying[BuffIndex] then
				EMUIAnimationSubsystem:EMPlayAnimation(self, BuffAnim, EUMGSequencePlayMode.Reverse)
				self.BuffAnimPlaying[BuffIndex] = false
			end

			if BuffIndex and self.SummonBuffText[BuffIndex] then
				self.SummonBuffText[BuffIndex]:SetVisibility(UE4.ESlateVisibility.Collapsed)
			end
		end
	end
end

function M:InitFeinaUIInfo()
	self.SummonUINodes =
	{
		self.Skill_Water,
		self.Skill_Fire,
		self.Skill_Thunder,
		self.Skill_Wind,
	}

	self.SummonNormalAnim =
	{
		self.Water_Normal,
		self.Fire_Normal,
		self.Thunder_Normal,
		self.Wind_Normal,
	}

	self.SummonHoverAnim =
	{
		self.Water_Hover,
		self.Fire_Hover,
		self.Thunder_Hover,
		self.Wind_Hover,
	}

	self.SummonUnHover =
	{
		self.Water_UnHover,
		self.Fire_UnHover,
		self.Thunder_UnHover,
		self.Wind_UnHover,
	}

	self.SummonClickAnim =
	{
		self.Water_Click,
		self.Fire_Click,
		self.Thunder_Click,
		self.Wind_Click,
	}

	self.SummonBuffText =
	{
		self.Text_Time_Water,
		self.Text_Time_Fire,
		self.Text_Time_Thunder,
		self.Text_Time_Wind,
	}

	self.BuffAnims =
	{
		self.Water_Buff,
		self.Fire_Buff,
		self.Thunder_Buff,
		self.Wind_Buff,
	}
end

function M:Tick(MyGeometry, InDeltaTime)
	self.Super.Tick(self, MyGeometry, InDeltaTime)

	if IsValid(self.NowSummoner) then
		local SummonID = self.NowSummoner.SummonID
		local NewSummonID = self.NowSummoner.NewSumID
		local bResetSumID = self.NowSummoner.ResetSumID

		--DebugPrint("gmy@M:Tick ", self.NowSummonID, SummonID, self.NowNewSummonID, NewSummonID)
		local bNewSummonChanged = self.NowNewSummonID ~= NewSummonID
		local bSummonChanged = self.NowSummonID ~= SummonID
		if bNewSummonChanged then
			self:HoverSummon(self.NowNewSummonID, NewSummonID)
			self.NowNewSummonID = NewSummonID
		end

		if bSummonChanged then
			self:SelectSummon(self.NowSummonID, SummonID)
			self.NowSummonID = SummonID
		end

		if bResetSumID then
			self:SelectSummon(self.NowSummonID, SummonID)
			self.NowSummonID = SummonID
			self.NowSummoner.ResetSumID = false
		end
	end
end

function M:InitListenEvent()
	self:AddDispatcher(EventID.OnCharCallSummoner, self, self.OnSummonerAdd)
	self:AddDispatcher(EventID.OnCharRemoveSummoner, self, self.OnSummonRemove)
end

function M:OnSummonerAdd(NowSummoner, RemainingLifeTime)
	DebugPrint("gmy@M:OnSummonerAdd", NowSummoner.Eid, RemainingLifeTime)
	-- TestScene的事件系统会串
	if self:IsRealSummonMainPlayer(NowSummoner) then
		self.bHasSummoner = true
		self.NowSummoner = NowSummoner
	end
end

function M:OnSummonRemove(NowSummoner)
	DebugPrint("gmy@M:OnSummonRemove", NowSummoner.Eid)
	if self:IsRealSummonMainPlayer(NowSummoner) then
		self.bHasSummoner = false
		self:ResetToNormal()
		self:ClearState()
	end
end

function M:IsRealSummonMainPlayer(NowSummoner)
	local PC = UE4.UGameplayStatics.GetPlayerController(self, 0)
	local SummonMaster = NowSummoner:GetDirectSource()
	if PC and SummonMaster and SummonMaster == PC:GetMyPawn() and NowSummoner.SummonID ~= nil and NowSummoner:IsSummonByMainPlayer() then
		return true
	end
	return false
end

function M:HoverSummon(OldIndex, NewIndex)
	DebugPrint("gmy@M:HoverSummon", OldIndex, NewIndex)
	if OldIndex then
		EMUIAnimationSubsystem:EMStopAnimation(self, self.SummonHoverAnim[OldIndex + 1])
		EMUIAnimationSubsystem:EMPlayAnimation(self, self.SummonUnHover[OldIndex + 1])
	end

	if NewIndex then
		EMUIAnimationSubsystem:EMPlayAnimation(self, self.SummonHoverAnim[NewIndex + 1])
		AudioManager(self):PlayUISound(self, "event:/ui/common/feina_skill_press", "feina_switch", nil)
	end
end

function M:SelectSummon(OldIndex, NewIndex)
	DebugPrint("gmy@M:SelectSummon", OldIndex, NewIndex)
	self:ResetToNormal(NewIndex + 1)

	if NewIndex then
		EMUIAnimationSubsystem:EMPlayAnimation(self, self.SummonClickAnim[NewIndex + 1])
		AudioManager(self):PlayUISound(self, "event:/ui/common/feina_skill_switch", "feina_switch", nil)
		--if self.SummonBuffText[NewIndex + 1] then
		--	self.SummonBuffText[NewIndex + 1]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
		--end
	end
end

function M:StopAllAnimations()
	if self.SummonNormalAnim then
		for Index, NormalAnim in ipairs(self.SummonNormalAnim) do
			EMUIAnimationSubsystem:EMStopAnimation(self, NormalAnim)
		end
	end

	if self.SummonHoverAnim then
		for Index, HoverAnim in ipairs(self.SummonHoverAnim) do
			EMUIAnimationSubsystem:EMStopAnimation(self, HoverAnim)
		end
	end

	if self.SummonUnHover then
		for Index, UnHoverAnim in ipairs(self.SummonUnHover) do
			EMUIAnimationSubsystem:EMStopAnimation(self, UnHoverAnim)
		end
	end

	if self.SummonClickAnim then
		for Index, ClickAnim in ipairs(self.SummonClickAnim) do
			EMUIAnimationSubsystem:EMStopAnimation(self, ClickAnim)
		end
	end
end

function M:ClearState()
	self.NowSummoner = nil
	self.NowSummonID = nil
	self.NowNewSummonID = nil
end

function M:ReceiveOnBuffsChanged()
	local Buffs = self.Owner.BuffManager.Buffs
	self:OnBuffsChanged(Buffs)
end

function M:OnBuffsChanged(Buffs)
	local NewBuffState = {}
	local bHasAnyBuff = false
	for _, Buff in pairs(Buffs) do
		if IsValid(Buff) then
			if Buff.BuffId and nil ~= self.Buff2Anim[Buff.BuffId] then
				NewBuffState[Buff.BuffId] = true
				bHasAnyBuff = true
			end
		end
	end

	if bHasAnyBuff then
		if not self.bHasBuff then
			self:StartRefreshBuffTime()
			self.bHasBuff = true
		end
	else
		if self.bHasBuff then
			self:EndRefreshBuffTime()
			self.bHasBuff = false
		end
	end

	for BuffId, OldState in pairs(self.Buff2State) do
		local NewState = not not NewBuffState[BuffId]

		if OldState ~= NewState then
			local BuffAnim = self.Buff2Anim[BuffId]
			local BuffIndex = self.Buff2Index[BuffId]

			-- Changed
			if NewState then
				-- AddBuff
				if BuffAnim then
					DebugPrint("gmy@Battle_FeinaSkill BuffAdd", BuffId, BuffAnim)
					EMUIAnimationSubsystem:EMPlayAnimation(self, BuffAnim)
					-- 标记动画为播放状态
					if BuffIndex and self.BuffAnimPlaying then
						self.BuffAnimPlaying[BuffIndex] = true
					end
				end
				if BuffIndex and self.SummonBuffText[BuffIndex] then
					self:DoRefreshBuffTime()
				end
			else
				-- RemoveBuff
				if BuffAnim then
					DebugPrint("gmy@Battle_FeinaSkill BuffStop", BuffId, BuffAnim)
					EMUIAnimationSubsystem:EMPlayAnimation(self, BuffAnim, EUMGSequencePlayMode.Reverse)
					-- 标记动画为停止状态
					if BuffIndex and self.BuffAnimPlaying then
						self.BuffAnimPlaying[BuffIndex] = false
					end
				end
				if BuffIndex and self.SummonBuffText[BuffIndex] then
					self.SummonBuffText[BuffIndex]:SetVisibility(UE4.ESlateVisibility.Collapsed)
				end
			end
			self.Buff2State[BuffId] = NewState
		end
	end
end

function M:StartRefreshBuffTime()
	self.TimeTextHandle = self:AddTimer(0.5, function()
		self:DoRefreshBuffTime()
	end, true)
end

function M:EndRefreshBuffTime()
	if self.TimeTextHandle then
		self:RemoveTimer(self.TimeTextHandle)
		self.TimeTextHandle = nil
	end
end

function M:DoRefreshBuffTime()
	if IsValid(self.Owner) then
		for BuffId, State in pairs(self.Buff2State) do
			if State then
				local BuffIndex = self.Buff2Index[BuffId]
				if BuffIndex and self.SummonBuffText[BuffIndex] then
					local Buff = Battle(self):FindBuffById(self.Owner, BuffId, 0, false)
					if IsValid(Buff) and Buff.LeftTime > 0 then
						local TimeText = string.format("%.0fs", Buff.LeftTime)
						self.SummonBuffText[BuffIndex]:SetText(TimeText)
						self.SummonBuffText[BuffIndex]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
					else
						self.SummonBuffText[BuffIndex]:SetVisibility(UE4.ESlateVisibility.Collapsed)
					end
				end
			end
		end
	end
end

return M
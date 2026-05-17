require "UnLua"

local FEntertainmentUtils = require "BluePrints.UI.WBP.Entertainment.EntertainmentUtils"
local FSimpleRewardBox = require "BluePrints.Client.CustomTypes.SimpleRewardBox"
local EPartyTopicState = FEntertainmentUtils.EPartyTopicState
local InviteLogType = UE.EStoryLogType.Invite


local function GetQuestTabName(QuestTabId)
	if (not QuestTabId) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "获取任务标签名称失败",
						"获取任务标签名称失败，QuestTabId 为空。")
		return
	end

	local NativeQuestTabData = DataMgr.QuestTab[QuestTabId]
	if (not NativeQuestTabData) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "获取任务标签名称失败",
						string.format("未在 QuestTab 表找到Id：%d 的数据。", QuestTabId))
		return
	end

	return GText(NativeQuestTabData.TabName)
end

local function CreateQuestChainConditionData(QuestChainId)
	if (not QuestChainId) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建任务链条件数据失败",
						"创建任务链条件数据失败，任务链Id为空。")
		return
	end

	local Avatar = GWorld:GetAvatar()
	if (not Avatar) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建任务链条件数据失败",
						"创建任务链条件数据失败，Avatar 为空。")
		return
	end

	local NativeQuestChainData = DataMgr.QuestChain[QuestChainId]
	if (not NativeQuestChainData) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建任务链条件数据失败",
						string.format("未在 QuestChain 表找到Id：%d 的数据。", QuestChainId))
		return
	end

	return {
		QuestTypeName = GetQuestTabName(NativeQuestChainData.QuestChainType),
		QuestChainName = GText(NativeQuestChainData.QuestChainName),
		bIsFinished = Avatar:IsQuestChainFinished(QuestChainId),
		QuestChainId = QuestChainId
	}
end

local function CreateNotRealQuestChainConditionData(QuestChainId)
	if (not QuestChainId) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建任务链条件数据失败",
						"创建任务链条件数据失败，任务链Id为空。")
		return
	end

	local Avatar = GWorld:GetAvatar()
	if (not Avatar) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建任务链条件数据失败",
						"创建任务链条件数据失败，Avatar 为空。")
		return
	end

	local NativeQuestChainData = DataMgr.QuestChain[QuestChainId]
	if (not NativeQuestChainData) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建任务链条件数据失败",
						string.format("未在 QuestChain 表找到Id：%d 的数据。", QuestChainId))
		return
	end

	return {
		QuestTypeName = GetQuestTabName(NativeQuestChainData.QuestChainType),
		QuestChainName = GText(NativeQuestChainData.QuestChainName),
		bIsFinished = Avatar:IsQuestChainFinished(QuestChainId) or Avatar:IsQuestChainAssumeFinished(QuestChainId),
		QuestChainId = QuestChainId
	}
end

local function CreateQuestChainConditionDataArray(QuestChainIdArray)
	if (not QuestChainIdArray) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建任务链条件数据数组失败",
						"创建任务链条件数据数组失败，任务链Id数组为空。")
		return
	end

	local QuestChainConditionDataArray = {}
	for _, QuestChainId in pairs(QuestChainIdArray) do
		local QuestChainConditionData = CreateQuestChainConditionData(QuestChainId)
		if (QuestChainConditionData) then
			table.insert(QuestChainConditionDataArray, QuestChainConditionData)
		end
	end
	return QuestChainConditionDataArray
end

local function CreateNotRealQuestChainConditionDataArray(QuestChainIdArray)
	if (not QuestChainIdArray) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建任务链条件数据数组失败",
						"创建任务链条件数据数组失败，任务链Id数组为空。")
		return
	end

	local QuestChainConditionDataArray = {}
	for _, QuestChainId in pairs(QuestChainIdArray) do
		local QuestChainConditionData = CreateNotRealQuestChainConditionData(QuestChainId)
		if (QuestChainConditionData) then
			table.insert(QuestChainConditionDataArray, QuestChainConditionData)
		end
	end
	return QuestChainConditionDataArray
end

local function CreateConditionDataMap(ConditionMap)
	if (not ConditionMap) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建条件数据失败",
						"创建条件数据失败，条件数据为空。")
		return
	end
	local QuestChainConditionDataArray = {}
	if ConditionMap.QuestChain then
		local Array = CreateNotRealQuestChainConditionDataArray(ConditionMap.QuestChain)
		for _, Data in ipairs(Array) do
			table.insert(QuestChainConditionDataArray, Data)
		end
	end

	if ConditionMap.TrueQuestChain then
		local Array = CreateQuestChainConditionDataArray(ConditionMap.TrueQuestChain) 
		for _, Data in ipairs(Array) do
			table.insert(QuestChainConditionDataArray, Data)
		end
	end

	return {
		QuestChainConditionDataArray = QuestChainConditionDataArray
	}
end

local function CreateConditionData(ConditionId)
	if (not ConditionId) then
		return
	end

	local Avatar = GWorld:GetAvatar()
	if (not Avatar) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建条件数据失败", "创建条件数据失败，Avatar 为空。")
		return
	end

	local NativeConditionData = DataMgr.Condition[ConditionId]
	if (not NativeConditionData) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建条件数据失败",
						string.format("未在 Condition 表找到Id：%d 的数据。", ConditionId))
		return
	end

	if (NativeConditionData.ConditionLogic ~= "AND") then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建条件数据失败",
						string.format("条件Id：%d 的条件逻辑不是 AND。", ConditionId))
		return
	end

	return {
		ConditionDataMap = CreateConditionDataMap(NativeConditionData.ConditionMap),
		bIsFinished = ConditionUtils.CheckCondition(Avatar, ConditionId)
	}
end

local function CreateResourceData(ResourceId)
	if (not ResourceId) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建资源数据失败", "创建资源数据失败，资源Id为空。")
		return
	end

	local NativeResourceData = DataMgr.Resource[ResourceId]
	if (not NativeResourceData) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建资源数据失败",
						string.format("未在 Resource 表找到Id：%d 的数据。", ResourceId))
		return
	end

	return {
		Id = NativeResourceData.ResourceId,
		Rarity = NativeResourceData.Rarity,
		IconPath = NativeResourceData.Icon
	}
end

local function CreateResourceConsumeData(ResourceId, NeedCount)
	local Avatar = GWorld:GetAvatar()
	if (not Avatar) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建资源消耗数据失败",
						"创建资源消耗数据失败，Avatar 为空。")
		return
	end
	return {
		ResourceData = CreateResourceData(ResourceId),
		Count = Avatar:GetResourceNum(ResourceId),
		NeedCount = NeedCount
	}
end

local function CreateResourceConsumeDataArray(ConsumeCountMap)
	if (not ConsumeCountMap) then
		return
	end

	local ConsumeItemDataArray = {}
	for ResourceId, NeedCount in pairs(ConsumeCountMap) do
		local ConsumeItemData = CreateResourceConsumeData(ResourceId, NeedCount)
		if (ConsumeItemData) then
			table.insert(ConsumeItemDataArray, ConsumeItemData)
		end
	end
	return ConsumeItemDataArray
end

local function CreateConsumeData(ConsumeCountMap)
	local Avatar = GWorld:GetAvatar()
	if (not Avatar) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建消耗数据失败", "创建消耗数据失败，Avatar 为空。")
		return
	end
	local IsEnough = Avatar:CheckEnough(ConsumeCountMap)
	local HighLevelNeedCount = 0
	if not IsEnough then
		for ResourceId, Count in pairs(ConsumeCountMap) do
			local ItemCount = Avatar:GetResourceNum(ResourceId)
			local NeedCount = Count - ItemCount
			HighLevelNeedCount = HighLevelNeedCount + (NeedCount > 0 and NeedCount or 0)
		end
	end

	return {
		ResourceConsumeDataArray = CreateResourceConsumeDataArray(ConsumeCountMap),
		bIsEnough = IsEnough,
		HighLevelNeedCount = HighLevelNeedCount
	}
end

local function CreateResourceRewardData(ResourceId, RewardCount)
	return {
		ResourceData = CreateResourceData(ResourceId),
		Count = FSimpleRewardBox:GetCount(RewardCount)
	}
end

local function CreateResourceRewardDataArray(ResourceRewardCountMap)
	if (not ResourceRewardCountMap) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建资源奖励数据数组失败",
						"创建资源奖励数据数组失败，资源奖励数据为空。")
	end

	local ResourceRewardDataArray = {}
	for ResourceId, RewardCount in pairs(ResourceRewardCountMap) do
		local ResourceRewardData = CreateResourceRewardData(ResourceId, RewardCount)
		if (ResourceRewardData) then
			table.insert(ResourceRewardDataArray, ResourceRewardData)
		end
	end
	return ResourceRewardDataArray
end

local function CreateRewardData(RewardId)
	if (not RewardId) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建奖励数据失败", "创建奖励数据失败，奖励Id为空。")
		return
	end

	local Rewards = RewardUtils:GetRewards({RewardId}, nil)
	if (not Rewards) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建奖励数据失败", string.format(
						"创建奖励数据失败，奖励Id：%d 的奖励数据为空。", RewardId))
		return
	end

	return {
		Rewards = Rewards,
		ResourceRewardDataArray = CreateResourceRewardDataArray(Rewards.Resources)
	}
end

local function GetPartyTopicState(PartyTopic, LastPartyTopic, ConditionData, ConsumeData)
	if (PartyTopic:IsLocked()) then
		if (LastPartyTopic and LastPartyTopic:IsCompleted() == false) then
			return EPartyTopicState.NotMeetLastPartyTopic
		end
		if (ConditionData and ConditionData.bIsFinished == false) then
			return EPartyTopicState.NotMeetCondition
		end

		if (ConsumeData and ConsumeData.bIsEnough == false) then
			local Avatar = GWorld:GetAvatar()
			local HighLevelItemCount = Avatar:GetResourceNum(19000)
			if HighLevelItemCount >= ConsumeData.HighLevelNeedCount then
				return EPartyTopicState.RedeemResource
			else
				return EPartyTopicState.NotMeetResource
			end
		end
		return EPartyTopicState.CanUnlockPartyTopic
	end
	if (PartyTopic:IsUnLock()) then
		return EPartyTopicState.CanStartPartyTopic
	end
	if (PartyTopic:IsCompleted()) then
		return EPartyTopicState.CanReviewPartyTopic
	end
	return EPartyTopicState.None
end

local function CreatePartyTopicData(CharacterId, PartyTopicLevel, PartyTopicId)
	local Avatar = GWorld:GetAvatar()

	local PartyTopic = Avatar:GetPartyTopic(CharacterId, PartyTopicLevel)
	assert(PartyTopic,
					string.format("Character: %d PartyTopicLevel: %d 的 PartyTopic 不存在。", CharacterId, PartyTopicLevel))

	local NativePartyTopicData = DataMgr.PartyTopic[PartyTopicId]
	assert(NativePartyTopicData, string.format("PartyTopic: %d 不存在。", PartyTopicId))

	local LastPartyTopic = Avatar:GetPartyTopic(CharacterId, PartyTopicLevel - 1)
	local ConditionData = CreateConditionData(NativePartyTopicData.ConditionId)
	local ConsumeData = CreateConsumeData(NativePartyTopicData.PartyTopicConsume)
	local State = GetPartyTopicState(PartyTopic, LastPartyTopic, ConditionData, ConsumeData)

	return {
		CharacterId = CharacterId,
		Level = PartyTopicLevel,
		Id = PartyTopicId,

		Name = GText(NativePartyTopicData.PartyTopicName),
		Description = GText(NativePartyTopicData.PartyTopicDescription),

		State = State,

		ConditionData = ConditionData,
		ConsumeData = ConsumeData,
		RewardData = CreateRewardData(NativePartyTopicData.PartyTopicReward),
		bIsRewardGot = not PartyTopic:IsLocked(),

		MemoryName = GText(NativePartyTopicData.MemoryName),
		MemoryDescription = GText(NativePartyTopicData.MemoryDescription),
		MemoryIconPath = NativePartyTopicData.MemoryIconPath,

		TargetRegionId = NativePartyTopicData.SubRegionId,
		StorylinePath = NativePartyTopicData.PartyTopicTalkId
	}
end

local function CreatePartyTopicDataArray(CharacterId, TopicIdArray)
	if (not TopicIdArray) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "创建邀约数据失败",
						"创建邀约数据失败，邀约Id数组为空。")
		return
	end

	local PartyTopicDataArray = {}
	for i, PartyTopicId in pairs(TopicIdArray) do
		local PartyTopicData = CreatePartyTopicData(CharacterId, i, PartyTopicId)
		if (PartyTopicData) then
			table.insert(PartyTopicDataArray, PartyTopicData)
		end
	end
	return PartyTopicDataArray
end

---@type WBP_Entertainment_TopicDetail_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.DelayFrameComponent"})

-- public:

function M:SetEntertainmentUI(EntertainmentUI)
	self.EntertainmentUI = EntertainmentUI
end

function M:OpenPanel(DisplayTabIndex, AudioObj)
	DisplayTabIndex = DisplayTabIndex or 1

	if (self:IsPanelOpened()) then
		return
	end
	self.bIsOpened = true
	self:SetTab(DisplayTabIndex)

	self:StopAllAnimations()
	self:PlayAnimation(self.In)
	AudioManager(AudioObj):PlayUISound(AudioObj, "event:/ui/common/invite_section_select_show", "EntertainmentTopicDetail", nil)
end

function M:ClosePanel(OnPanelClosed, AudioObj)
	if (not self:IsPanelOpened()) then
		return
	end
	self.bIsOpened = false
	self:SetTab(nil)

	self:StopAllAnimations()

	if (OnPanelClosed) then
		self.OnPanelClosed = function()
			OnPanelClosed()
			self:UnbindFromAnimationFinished(self.Out, {self, self.OnPanelClosed})
			self.OnPanelClosed = nil
		end
		self:BindToAnimationFinished(self.Out, {self, self.OnPanelClosed})
	end

	self:PlayAnimation(self.Out)
	self.Badge:ClosePanel()
	AudioManager(AudioObj):SetEventSoundParam(AudioObj, "EntertainmentTopicDetail", {ToEnd = 1})
end

function M:IsPanelOpened()
	return self.bIsOpened
end

function M:SetPartyTopic(CharacterData)
	if (not CharacterData) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "设置邀约失败", "设置邀约失败，角色数据为空。")
		return
	end

	self.CharacterData = CharacterData
	self.PartyTopicDataArray = CreatePartyTopicDataArray(CharacterData.Id, CharacterData.PartyTopicIdArray)
	for i, TopicTab in pairs(self.TopicTabArray) do
		local PartyTopicData = self.PartyTopicDataArray[i]
		if (PartyTopicData) then
			TopicTab:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
			TopicTab:EnableReddot(PartyTopicData.State == EPartyTopicState.CanUnlockPartyTopic 
				or PartyTopicData.State == EPartyTopicState.CanStartPartyTopic
				or PartyTopicData.State == EPartyTopicState.RedeemResource)
		else
			TopicTab:SetVisibility(ESlateVisibility.Collapsed)
		end
	end
end

function M:RefreshPartyTopic()
	if (self.CharacterData == nil) then
		return
	end
	self:SetPartyTopic(self.CharacterData)

	local CurrentTabIndex = self.CurrentTabIndex
	self:SetTab(nil)
	self:SetTab(CurrentTabIndex)
end

function M:SwitchUpTab()
	local NewTabIndex = math.max(1, self.CurrentTabIndex - 1)
	if (NewTabIndex == self.CurrentTabIndex) then return end
	self:SetTab(NewTabIndex)
end

function M:SwitchDownTab()
	local NewTabIndex = math.min(#self.PartyTopicDataArray, self.CurrentTabIndex + 1)
	if (NewTabIndex == self.CurrentTabIndex) then return end
	self:SetTab(NewTabIndex)
end

function M:SetTab(NewTabIndex)
	if (self.CurrentTabIndex == NewTabIndex) then
		return
	end

	if (self.CurrentTabIndex) then
		local CurrentTab = self.TopicTabArray[self.CurrentTabIndex]
		CurrentTab:SetSelected(false)
	end

	self.CurrentTabIndex = NewTabIndex
	if (NewTabIndex) then
		local NewTab = self.TopicTabArray[NewTabIndex]
		NewTab:SetSelected(true)

		local PartyTopicData = self.PartyTopicDataArray[NewTabIndex]
		self.Text_TopicName:SetText(PartyTopicData.Name)
		self.Text_Describe:SetText(PartyTopicData.Description)

		self:SetState(PartyTopicData.State)
		self:SetCondition(PartyTopicData.ConditionData, PartyTopicData.bIsRewardGot)
		self:SetConsume(PartyTopicData.ConsumeData, PartyTopicData.bIsRewardGot)
		self:SetReward(PartyTopicData.RewardData, PartyTopicData.bIsRewardGot)
		self:SetMemory(PartyTopicData)
	else
		self.EnableButton = nil
	end
end

function M:GetState()
	local CurrentTabIndex = self.CurrentTabIndex
	local PartyTopicData = self.PartyTopicDataArray[CurrentTabIndex]
	if (PartyTopicData) then
		return PartyTopicData.State
	else
		return nil
	end
end


function M:BindOnPanelClosed(OnPanelClosed)
	self.OnPanelClosed = OnPanelClosed
end

function M:ExecuteOnPanelClosed()
	if (self.OnPanelClosed) then
		self.OnPanelClosed()
	end
end

function M:BindOnGotReward(OnGotReward)
	self.OnGotReward = OnGotReward
end

function M:ExecuteOnGotReward()
	if (self.OnGotReward) then
		self.OnGotReward()
	end
end

-- function M:BindOnSetMemory(OnSetMemory)
-- 	self.OnSetMemory = OnSetMemory
-- end

-- function M:ExecuteOnSetMemory(bDisplayMemory, MemoryName, MemoryDescription, MemoryIconPath)
-- 	if (self.OnSetMemory) then
-- 		self.OnSetMemory(bDisplayMemory, MemoryName, MemoryDescription, MemoryIconPath)
-- 	end
-- end

-- function M:BindOnUnlockMemory(OnUnlockMemory)
-- 	self.OnUnlockMemory = OnUnlockMemory
-- end

function M:ExecuteOnUnlockMemory(MemoryName, MemoryDescription, MemoryIconPath)
	if (self.OnUnlockMemory) then
		self.OnUnlockMemory(MemoryName, MemoryDescription, MemoryIconPath)
	end
end

function M:BindOnDisplayMemory(OnDisplayMemory)
	self.OnDisplayMemory = OnDisplayMemory
end

function M:ExecuteOnDisplayMemory(MemoryName, MemoryDescription, MemoryIconPath)
	if (self.OnDisplayMemory) then
		self.OnDisplayMemory(MemoryName, MemoryDescription, MemoryIconPath)
	end
end

function M:BindOnEnterInvitation(OnEnterInvitation)
	self.OnEnterInvitation = OnEnterInvitation
end

function M:ExecuteOnEnterInvitation(CharacterId, TopicLevel, bIsReview)
	if (self.OnEnterInvitation) then
		self.OnEnterInvitation(CharacterId, TopicLevel, bIsReview)
	end
end

-- protected:

function M:Initialize(Initializer)
	--self.LockText = GText("UI_Aaccessory_Locked")
	self.UnlockCostText = GText("UI_Cost_For_Unlock")
	self.UnlockConditionText = GText("UI_Unlock_Condition")

	self.NotMeetLastPartyTopic = GText("UI_Previous_Topic_Incomplete")
	self.NotMeetConditionText = GText("UI_Complete_The_Prerequisite")
	self.NotMeetResourceText = GText("UI_Lack_of_Resources")
	self.RedeemResourceText = GText("UI_Resources_Exchange")
	self.UnlockPartyTopicText = GText("UI_Unlock_Topic")
	self.StartPartyTopicText = GText("UI_Enter_Topic")
	self.ReviewPartyTopicText = GText("UI_Review_Chats")
	self.UnlockRewardText = GText("UI_Unlock_Reward")

	self.bIsOpened = true

	self.PartyTopicDataArray = nil
	self.CurrentTabIndex = nil

	self.TopicButtonClickedSound = "event:/ui/common/click_btn_confirm"
end

function M:Construct()
	-- self.Key_Left:CreateCommonKey({
	-- 	KeyInfoList = {{
	-- 		Type = "Text",
	-- 		Text = UE4.EKeys.A.KeyName
	-- 	}}
	-- })
	-- self.Key_Right:CreateCommonKey({
	-- 	KeyInfoList = {{
	-- 		Type = "Text",
	-- 		Text = UE4.EKeys.D.KeyName
	-- 	}}
	-- })
	DebugPrint("PartyTopicPanel Construct")
	--self.Text_Lock:SetText(self.LockText)
	self.Text_Cost:SetText(self.UnlockCostText)
	self.Text_Condition:SetText(self.UnlockConditionText)
	self.Text_Reward:SetText(self.UnlockRewardText)
	self.Badge:BindOnDisplayMemory(function(MemoryName, MemoryDescription, MemoryIconPath)
		self:ExecuteOnDisplayMemory(MemoryName, MemoryDescription, MemoryIconPath)
	end)


	self.Btn_Unlock.OnPressed:Add(self, function()
		AudioManager(self):PlayUISound(self, self.TopicButtonClickedSound, nil, nil)
	end)
	self.Btn_Unlock.OnClicked:Add(self, self.HandlePartyTopicStateTransition)

	self.Btn_Continue.OnPressed:Add(self, function()
		AudioManager(self):PlayUISound(self, self.TopicButtonClickedSound, nil, nil)
	end)
	self.Btn_Continue.OnClicked:Add(self, self.HandlePartyTopicStateTransition)

	self.TopicTabArray = {}
	local TopicTabCount = self.TopicTabs:GetChildrenCount()
	for i = 1, TopicTabCount do
		local TopicTab = self.TopicTabs:GetChildAt(i - 1)
		self.TopicTabArray[i] = TopicTab
		TopicTab:SetIndex(i)
		TopicTab:BindOnClicked(function(Index)
			self:SetTab(Index)
		end)
	end

	self.UnlockTopic:SetVisibility(ESlateVisibility.Collapsed)

	self:BindToAnimationStarted(self.In, {self, self.HandleOnInAnimationStarted})
	self:BindToAnimationFinished(self.Out, {self, self.HandleOnOutAnimationFinished})
end

function M:Destruct()
	self:UnbindFromAnimationStarted(self.In, {self, self.HandleOnInAnimationStarted})
	self:UnbindFromAnimationFinished(self.Out, {self, self.HandleOnOutAnimationFinished})
end

-- private:

function M:HandlePartyTopicStateTransition()
	local PartyTopicData = self.PartyTopicDataArray[self.CurrentTabIndex]
	if (not PartyTopicData or PartyTopicData.State == EPartyTopicState.None) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "设置话题状态失败", "话题状态无效。")
	elseif (PartyTopicData.State == EPartyTopicState.RedeemResource) then
		self:HandleOnExchangeLowLevelPartyTopic(PartyTopicData)
	elseif (PartyTopicData.State == EPartyTopicState.CanUnlockPartyTopic) then
		self:HandleOnUnlockPartyTopic(PartyTopicData)
	elseif (PartyTopicData.State == EPartyTopicState.CanStartPartyTopic) then
		self:HandleOnStartPartyTopic(PartyTopicData)
	elseif (PartyTopicData.State == EPartyTopicState.CanReviewPartyTopic) then
		self:HandleOnReviewPartyTopic(PartyTopicData)
	end
end

function M:HandleOnExchangeLowLevelPartyTopic(PartyTopicData)
	local ItemData = PartyTopicData.ConsumeData.ResourceConsumeDataArray
	local Avatar = GWorld:GetAvatar()
	local ItemExchangeTable = {
		LeftItems = {{
			ItemId = 19000,
			ItemType = "Resource",
			Count = PartyTopicData.ConsumeData.HighLevelNeedCount
		}},
		RightItems = {},
		ShortTextParams = {PartyTopicData.ConsumeData.HighLevelNeedCount},
		RightCallbackFunction = function()
			self:HandleOnUnlockPartyTopic(PartyTopicData)
		end
	}
	for i = 1, #ItemData do
		local ConsumeData = ItemData[i]
		local CurItemCount = Avatar:GetResourceNum(ConsumeData.ResourceData.Id)
		local RedeemCount = ConsumeData.NeedCount - CurItemCount

		if (RedeemCount > 0) then
			table.insert(ItemExchangeTable.RightItems, {
				ItemId = ConsumeData.ResourceData.Id,
				ItemType = "Resource",
				Count = RedeemCount
			})
		end
	end
	UIManager(self):ShowCommonPopupUI(100122, ItemExchangeTable)
end


function M:HandleOnUnlockMemory(MemoryName, MemoryDescription, MemoryIconPath)
	self.Badge:SetMemory(MemoryName, MemoryDescription, MemoryIconPath)
	self.Badge:OpenPanel(true)
end

function M:HandleOnSetMemory(bDisplayMemory, MemoryName, MemoryDescription, MemoryIconPath)
	self.Badge:ClosePanel()
	if (bDisplayMemory) then
		self.Badge:SetMemory(MemoryName, MemoryDescription, MemoryIconPath)
		self.Badge:OpenPanel(false)
	else
		self.Badge:SetEmpty()
		self.Badge:OpenPanel(false)
	end
end

function M:HandleOnUnlockPartyTopic(PartyTopicData)
	if (self.EntertainmentUI) then
		self.EntertainmentUI:SetInteractionEnabled(false)
	end

	local Avatar = GWorld:GetAvatar()
	Avatar:TriggerPartyTopicUnLock(PartyTopicData.CharacterId, PartyTopicData.Level, function(Ret)
		if (self.EntertainmentUI) then
			self.EntertainmentUI:SetInteractionEnabled(true)
		end

		self:HandleOnPartyTopicUnlocked(Ret, PartyTopicData)
	end)
end

function M:HandleOnPartyTopicUnlocked(Ret, PartyTopicData)
	if (ErrorCode:Check(Ret) == false) then
		return
	end
	local TopicTab = self.TopicTabArray[self.CurrentTabIndex]
	TopicTab:EnableReddot(PartyTopicData.State == EPartyTopicState.CanUnlockPartyTopic 
		or PartyTopicData.State == EPartyTopicState.CanStartPartyTopic
		or PartyTopicData.State == EPartyTopicState.RedeemResource)
	self:RefreshPartyTopic()

	EventManager:FireEvent(EventID.OnGotTopicReward)
	self:ExecuteOnGotReward()


	UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, PartyTopicData.RewardData.Rewards, false, function()
		self:UnlockMemory(PartyTopicData)
	end, self, false)
end

function M:HandleOnStartPartyTopic(PartyTopicData)
	self:ExecuteInvitation(PartyTopicData, false)
end

function M:HandleOnReviewPartyTopic(PartyTopicData)
	self:ExecuteInvitation(PartyTopicData, true)
end

function M:HandleOnInAnimationStarted()
	self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function M:HandleOnOutAnimationFinished()
	self:SetVisibility(ESlateVisibility.Collapsed)
end

function M:SetState(State)
	-- if (State == EPartyTopicState.CanStartPartyTopic) then
	-- 	self.Btn_Continue:SetReddotVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
	-- else
	-- 	self.Btn_Continue:SetReddotVisibility(UIConst.VisibilityOp.Collapsed)
	-- end
	self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
	if (State == EPartyTopicState.None) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "设置状态失败", "设置状态失败，状态无效。")
	elseif (State == EPartyTopicState.NotMeetLastPartyTopic) then
		self.Switch_Type:SetActiveWidgetIndex(0)
		self.Text_Lack:SetText(self.NotMeetLastPartyTopic)
		-- self.UnlockTopic:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	elseif (State == EPartyTopicState.NotMeetCondition) then
		self.Switch_Type:SetActiveWidgetIndex(0)
		self.Text_Lack:SetText(self.NotMeetConditionText)
		-- self.UnlockTopic:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	elseif (State == EPartyTopicState.NotMeetResource) then
		self.Switch_Type:SetActiveWidgetIndex(0)
		self.Text_Lack:SetText(self.NotMeetResourceText)
		-- self.UnlockTopic:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	elseif (State == EPartyTopicState.RedeemResource) then
		self.Switch_Type:SetActiveWidgetIndex(1)
		self.Text_Continue:SetText(self.RedeemResourceText)
		self.EnableButton = self.Btn_Continue
		self.Reddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
		-- self.UnlockTopic:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	elseif (State == EPartyTopicState.CanUnlockPartyTopic) then
		self.Switch_Type:SetActiveWidgetIndex(2)
		self.Text_Unlock:SetText(self.UnlockPartyTopicText)
		self.EnableButton = self.Btn_Unlock
		self.Reddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
		-- self.UnlockTopic:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	elseif (State == EPartyTopicState.CanStartPartyTopic) then
		self.Switch_Type:SetActiveWidgetIndex(2)
		self.Text_Unlock:SetText(self.StartPartyTopicText)
		self.EnableButton = self.Btn_Unlock
		self.Reddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
		-- self.UnlockTopic:SetVisibility(ESlateVisibility.Collapsed)
	elseif (State == EPartyTopicState.CanReviewPartyTopic) then
		self.Switch_Type:SetActiveWidgetIndex(1)
		self.Text_Continue:SetText(self.ReviewPartyTopicText)
		self.EnableButton = self.Btn_Continue
		-- self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
		-- self.UnlockTopic:SetVisibility(ESlateVisibility.Collapsed)
	end
end

function M:SetCondition(ConditionData, bIsRewardGot)
	if ((not ConditionData) or bIsRewardGot) then
		self.Condition:SetVisibility(ESlateVisibility.Collapsed)
		return
	end

	self.Condition:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self.List_Condition:ClearListItems()
	self:SetConditionDataMap(ConditionData.ConditionDataMap)
end

function M:SetConditionDataMap(ConditionDataMap)
	if (not ConditionDataMap) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "设置条件数据失败",
						"设置条件数据失败，条件数据为空。")
		return
	end

	self:AddQuestChainConditionList(ConditionDataMap.QuestChainConditionDataArray)
end

function M:AddQuestChainConditionList(QuestChainConditionDataArray)
	if (not QuestChainConditionDataArray) then
		return
	end

	for _, QuestChainConditionData in pairs(QuestChainConditionDataArray) do
		local QuestChainConditionItem = self:CreateQuestChainConditionItem(QuestChainConditionData)
		self.List_Condition:AddItem(QuestChainConditionItem)
	end
end

function M:SetConsume(ConsumeData, bIsRewardGot)
	if ((not ConsumeData) or bIsRewardGot) then
		self.Cost:SetVisibility(ESlateVisibility.Collapsed)
		return
	end

	self.Cost:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self:SetConsumeList(ConsumeData.ResourceConsumeDataArray)
end

function M:SetConsumeList(ResourceConsumeDataArray)
	local ResourceConsumeItemArray = {}
	for _, ResourceConsumeData in pairs(ResourceConsumeDataArray) do
		local ResourceConsumeItem = self:CreateConsumeItem(ResourceConsumeData)
		table.insert(ResourceConsumeItemArray, ResourceConsumeItem)
	end

	self.List_Material:ClearListItems()
	for _, ResourceConsumeItem in pairs(ResourceConsumeItemArray) do
		self.List_Material:AddItem(ResourceConsumeItem)
	end
end

function M:SetReward(RewardData, bIsRewardGot)
	if (not RewardData) then
		self.Reward:SetVisibility(ESlateVisibility.Collapsed)
		return
	end

	self.Reward:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self:SetRewardList(RewardData.ResourceRewardDataArray, bIsRewardGot)
end

function M:SetRewardList(ResourceRewardDataArray, bIsRewardGot)
	local ResourceRewardItemArray = {}
	for _, ResourceRewardData in pairs(ResourceRewardDataArray) do
		local ResourceRewardItem = self:CreateRewardItem(ResourceRewardData, bIsRewardGot)
		table.insert(ResourceRewardItemArray, ResourceRewardItem)
	end

	self.List_Reward:ClearListItems()
	self:SortResourceItem(ResourceRewardItemArray)
	for _, Item in pairs(ResourceRewardItemArray) do
		self.List_Reward:AddItem(Item)
	end
end

function M:SetMemory(PartyTopicData)
	local bDisplayMemory = false
	if (PartyTopicData.State == EPartyTopicState.CanStartPartyTopic) then
		bDisplayMemory = true
	elseif (PartyTopicData.State == EPartyTopicState.CanReviewPartyTopic) then
		bDisplayMemory = true
	end

	self:HandleOnSetMemory(bDisplayMemory, PartyTopicData.MemoryName, PartyTopicData.MemoryDescription,
					PartyTopicData.MemoryIconPath)
end

function M:UnlockMemory(PartyTopicData)
	if (PartyTopicData.State ~= EPartyTopicState.CanStartPartyTopic) then
		return
	end

	self:HandleOnUnlockMemory(PartyTopicData.MemoryName, PartyTopicData.MemoryDescription, PartyTopicData.MemoryIconPath)
end

function M:CreateQuestChainConditionItem(QuestChainData)
	local ConditionItemClass = LoadClass(
					"/Game/UI/WBP/Entertainment/Widget/BP_Entertainment_ConditionItem.BP_Entertainment_ConditionItem_C")
	local ConditionItem = NewObject(ConditionItemClass)
	ConditionItem.Type = "QuestChain"
	ConditionItem.QuestTypeName = QuestChainData.QuestTypeName
	ConditionItem.QuestChainName = QuestChainData.QuestChainName
	ConditionItem.bIsFinished = QuestChainData.bIsFinished
	ConditionItem.QuestChainId = QuestChainData.QuestChainId
	return ConditionItem
end

function M:CreateConsumeItem(ResourceConsumeData)
	local ConsumeItem = self:CreateResourceItem(ResourceConsumeData.ResourceData)
	ConsumeItem.NeedCount = ResourceConsumeData.NeedCount
	ConsumeItem.Count = ResourceConsumeData.Count
	return ConsumeItem
end

function M:CreateRewardItem(ResourceRewardData, bIsRewardGot)
	local RewardItem = self:CreateResourceItem(ResourceRewardData.ResourceData)
	RewardItem.Count = ResourceRewardData.Count
	RewardItem.bHasGot = bIsRewardGot
	return RewardItem
end

function M:CreateResourceItem(ResourceData)
	local ResourceItem = NewObject(UIUtils.GetCommonItemContentClass())
	ResourceItem.Id = ResourceData.Id
	ResourceItem.Rarity = ResourceData.Rarity
	ResourceItem.Icon = ResourceData.IconPath

	ResourceItem.ItemType = "Resource"
	ResourceItem.IsShowDetails = true
	ResourceItem.UIName = "Entertainment"
	ResourceItem.OnMenuOpenChangedEvents = {Obj = self, Callback = self.OnResourceItemTipChange}
	return ResourceItem
end

function M:BindOnTipStateChange(Obj, Func)
	self.OnTipStateChange = Func
	self.OnTipStateChangeObj = Obj
end

function M:OnResourceItemTipChange(bIsOpen)
	if (self.OnTipStateChange) then
		self.OnTipStateChange(self.OnTipStateChangeObj, bIsOpen)
	end
end

function M:SortResourceItem(ResourceItemArray)
	table.sort(ResourceItemArray, function(a, b)
		if (a.Rarity == b.Rarity) then
			return a.Id > b.Id
		else
			return a.Rarity > b.Rarity
		end
	end)
end

function M:ExecuteInvitation(PartyTopicData, bIsReview)
	self:ExecuteOnEnterInvitation(PartyTopicData.CharacterId, PartyTopicData.Level, bIsReview)
end

return M

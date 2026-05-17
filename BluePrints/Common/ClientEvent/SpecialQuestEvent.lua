
local SpecialQuestEvent = Class('BluePrints.Common.ClientEvent.BaseClientEvent')

local SpecialQuestLogType = UE.EStoryLogType.SpecialQuest

function SpecialQuestEvent:InitEvent(SpecialQuestId, BlackScreenImmediately, PreQuestChainId, Callback)
	-- Event Type
	self.Type = "SpecialQuest"
	self.SpecialQuestId = SpecialQuestId
	self.BlackScreenImmediately = BlackScreenImmediately
	self.PreQuestChainId = PreQuestChainId
	self.SpecialQuestFinishCallback = Callback
	self.SuccessNodeCallback = nil
	self.FailNodeCallback = nil
	self.SpecialQuestStory = nil
	self.UniversalConfig = nil
	self.TryActive = false
	self.IsActive = false
	self.TryFinish = false
	self.IsFinish = false
	self.RealFinish = false
	self.PreRunSpecialStoryFinish = false
	self.RunSpecialStoryFinish = false
	self.ResultTable = {
		Success = true,
		Fail = false,
		PassiveFail = false,
		NoExit = false,
	}
	self.Reason2Result = {
		FailCustomEvent = "PassiveFail",
		CharDie = "PassiveFail",
		Exit = "Fail",
		LeaveRegion = "Fail",
		LeaveTriggerBox = "Fail",
		FailNode = "Fail",
		SuccessNode = "Success",
		ServerNotifyEnd = "NoExit",
		NodeClear = "NoExit",--Do Not Execute Any Outport
	}
	self.FinishReason = nil
	self.FinishResult = nil
	self.FailCustomEventCallback = nil
	self.StartBlackScreenFadeInFinish = false
	self.StartBlackScreenContinueFinish = false
	self.SuccessBlackScreenFadeInFinish = false
	self.SuccessBlackScreenContinueFinish = false
	self.FailBlackScreenFadeInFinish = false
	self.FailBlackScreenContinueFinish = false
end

function SpecialQuestEvent:OnStartEvent( ... )
	DebugPrint("gyy@StartSpecialQuestEvent ", self.SpecialQuestId)
	self.SpecialQuestConfig = DataMgr.SpecialQuestConfig[self.SpecialQuestId]
	if not self.SpecialQuestConfig then
		local Message = "找不到特殊任务编号"..
        "\n开启特殊任务的任务链Id:"..self.PreQuestChainId..
        "\n特殊任务编号:"..self.SpecialQuestId
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, SpecialQuestLogType, "找不到特殊任务编号", Message)
		return
	end

	local Avatar = GWorld:GetAvatar()
	local SpecialQuestData = Avatar.SpecialQuestData[self.SpecialQuestId]
	if SpecialQuestData and SpecialQuestData:IsSuccess() then
		DebugPrint("gyy@SpecialQuest Is Successed ", self.SpecialQuestId)
		-- self.SpecialQuestFinishCallback("Success")
		-- return
	end

	if self.SpecialQuestConfig.UniversalConfigId then
		self.UniversalConfig = DataMgr.UniversalConfig[self.SpecialQuestConfig.UniversalConfigId]
	end
	if self.SpecialQuestConfig.TriggerBoxStaticCreatorId then
		self.TriggerBoxStaticCreatorId = self.SpecialQuestConfig.TriggerBoxStaticCreatorId
		EventManager:AddEvent(EventID.OnEnterTriggerBox, self, self.OnEnterTriggerBox)
		local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
		GameMode:TriggerActiveStaticCreator_SpecialQuestId({self.TriggerBoxStaticCreatorId}, self.SpecialQuestId)
	elseif self.SpecialQuestConfig.SubRegionIds then
		self.SubRegionIds = self.SpecialQuestConfig.SubRegionIds
		if self:CheckSubRegionIds() then
			self:TryActivateEvent()
		else
			self:WaitingEnterSubRegion()
		end
	end

	if self.BlackScreenImmediately then
		if self.UniversalConfig and self.UniversalConfig.StartBlackScreen then
			--开始黑屏处理
			DebugPrint("gyy@StartBlackScreenImmediately ", self.SpecialQuestId)
			self:PlayStartBlackScreen()
		else
			local Message = "STL节点上勾选了立刻黑屏，UniversalConfig表中未配置播放黑屏参数"..
			"\n开启特殊任务的任务链Id:"..self.PreQuestChainId..
			"\n特殊任务编号:"..self.SpecialQuestId
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, SpecialQuestLogType, "STL节点上勾选了立刻黑屏，UniversalConfig表中未配置播放黑屏参数", Message)
			return
		end
	end
end

function SpecialQuestEvent:TryActivateEvent( ... )
	DebugPrint("gyy@TryActivateSpecialQuestEvent ", self.SpecialQuestId)
	self.TryActive = true
	local Avatar = GWorld:GetAvatar()
    if Avatar then
		local Infos = self:GetStartInfos()
		local Callback = function( ... )
			self:OnActivateEvent()
		end
		Avatar:StartSpecialQuest(self.SpecialQuestId, Infos, Callback)
    end
	if self.UniversalConfig and self.UniversalConfig.StartBlackScreen and not self.BlackScreenImmediately then
		--开始黑屏处理
		DebugPrint("gyy@StartBlackScreenAfterActivate ", self.SpecialQuestId)
		self:PlayStartBlackScreen()
	end
end

function SpecialQuestEvent:OnActivateEvent()
	DebugPrint("gyy@ActivateSpecialQuestEvent ", self.SpecialQuestId)
	local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
	ClientEventUtils:SetCurrentEvent(self)
	self.IsActive = true
	if self.SpecialQuestConfig.TriggerBoxStaticCreatorId then
		EventManager:AddEvent(EventID.OnLeaveTriggerBox, self, self.OnLeaveTriggerBox)
	elseif self.SpecialQuestConfig.SubRegionIds then
		self:WaitingLeaveSubRegion()
	end
	local Avatar = GWorld:GetAvatar()
	if Avatar then
		Avatar.InSpecialQuest = true
		Avatar.SpecialQuestId = self.SpecialQuestId
	end
	if self.UniversalConfig and self.UniversalConfig.StartBlackScreen then
		self:TryPreRunSpecialStory()
		self:TryRunSpecialStory()
		self:TryFinishStartBlackScreen()
	else
		self:PreRunSpecialStory()
		self:RunSpecialStory()
	end
end

function SpecialQuestEvent:TryPreRunSpecialStory()
	if self.StartBlackScreenFadeInFinish and self.IsActive then
		self:PreRunSpecialStory()
	end
end

function SpecialQuestEvent:PreRunSpecialStory()
	PrintTable({OnActivateEvent=self.SpecialQuestId})
	--通用配置
	self:SetUniversalConfig()
	--停止其他任务
	self:StopOtherQuest()
	--停止动态事件
	self:StopDynamicQuest()
	self:SaveRegionData()
	self:ResetQuestArtLevel()
	self:SetFailCondition()
	self:WaitingFail()

	local BattleMainUI = UIManager():GetUIObj("BattleMain")
	if BattleMainUI ~= nil and BattleMainUI.Pos_TaskBar ~= nil then
        local TaskBarWidget = BattleMainUI.Pos_TaskBar:GetChildAt(0)
		if TaskBarWidget then
			TaskBarWidget:SwitchTaskBarContentByTracking(true, true)
		end
    end
	EventManager:FireEvent(EventID.OnNpcEnterOrQuitSpecialQuest)

	self.PreRunSpecialStoryFinish = true
end

function SpecialQuestEvent:TryRunSpecialStory()
	if self.StartBlackScreenContinueFinish and self.PreRunSpecialStoryFinish then
		self:RunSpecialStory()
	end
end

function SpecialQuestEvent:RunSpecialStory()
	DebugPrint("gyy@RunSpecialStory ", self.SpecialQuestId)
	local StoryPath = self.SpecialQuestConfig.StoryPath
	self.SpecialQuestStory = GWorld.StoryMgr:RunStory(StoryPath, nil, nil, nil, nil, {SpecialQuestId = self.SpecialQuestId})
	self.RunSpecialStoryFinish = true
end

function SpecialQuestEvent:TryFinishEvent(Reason)
	DebugPrint("gyy@TryFinishEvent TryFinish:", self.TryFinish, self.SpecialQuestId)
	EventManager:RemoveEvent(EventID.OnSpecialQuestFail, self)
	if not self.TryFinish then
		self.TryFinish = true
		self.FinishReason = Reason
		self.FinishResult = self.Reason2Result[self.FinishReason]
		if self.FinishReason == "ServerNotifyEnd" then
			self:OnFinishEvent(self.FinishResult)
		else
			local Avatar = GWorld:GetAvatar()
			if Avatar then
				local Infos = self:GetFinishInfos(self.FinishReason)
				if self.ResultTable[self.FinishResult] then
					local _Callback = function(Ret)
						self:OnFinishEvent(self.FinishResult)
					end
					Avatar:SuccessSpecialQuest(self.SpecialQuestId, Infos, _Callback)
				else
					local _Callback = function(Ret)
						self:OnFinishEvent(self.FinishResult)
					end
					Avatar:FailerSpecialQuest(self.SpecialQuestId, Infos, _Callback)
				end
			else
				DebugPrint("gyy@TryFinishEvent Avatar Is nil", self.SpecialQuestId)
				self:OnFinishEvent(self.FinishResult)
			end
		end

		self:PlaySuccessOrFailBlackScreen(self.FinishResult)
	end
end

function SpecialQuestEvent:OnFinishEvent(Result)
	DebugPrint("gyy@FinishSpecialQuestEvent ", self.SpecialQuestId)
	local Avatar = GWorld:GetAvatar()
	if Avatar then
		Avatar.InSpecialQuest = false
		Avatar.SpecialQuestId = nil
	end
	EventManager:FireEvent(EventID.OnNpcEnterOrQuitSpecialQuest)
	
	self.IsFinish = true
	if not self.ResultTable[Result] and self.UniversalConfig and self.UniversalConfig.FailBlackScreen then
		self:TryRealFinishEvent(Result)
		if Result == "PassiveFail" and self.UniversalConfig.FailureGuidanceCombinationId then
			self:TryOpenFailureGuidanceUIAndFinishFailBlackScreen()
		else
			self:TryRecoverQuestAndFinishFailBlackScreen(Result)
		end
	elseif self.ResultTable[Result] and self.UniversalConfig and self.UniversalConfig.SuccessBlackScreen then
		self:TryRealFinishEvent(Result)
		self:TryRecoverQuestAndFinishSuccessBlackScreen(Result)
	else
		self:RealFinishEvent(Result)
		if Result == "PassiveFail" and self.UniversalConfig.FailureGuidanceCombinationId then
			self:OpenFailureGuidanceUI()
		else
			self:RecoverOtherQuestAndPreQuest(Result)
		end
	end
end

function SpecialQuestEvent:TryRealFinishEvent(Result)
	if self.ResultTable[Result] then
		if self.SuccessBlackScreenFadeInFinish and self.IsFinish then
			self:RealFinishEvent(Result)
		end
	else
		if self.FailBlackScreenFadeInFinish and self.IsFinish then
			self:RealFinishEvent(Result)
		end
	end
end

function SpecialQuestEvent:RealFinishEvent(Result)
	DebugPrint("gyy@RealFinishSpecialQuestEvent ", self.SpecialQuestId)
	self:EndInteractive()
	TalkSubsystem():InterruptAllLightTask()
	self:ExecuteFinishNodeCallback(Result)
	self:Destroy(Result)
	self:InitPlayerOnFinish()
	self:RecoverUniversalConfig()
	self:RecoverRegionData()
	self:RecoverQuestArtLevel()
	self:EventEnd()
	self.RealFinish = true
end

function SpecialQuestEvent:InitPlayerOnFinish()
	self:InitPlayer()
end

function SpecialQuestEvent:RecoverOtherQuestAndPreQuest(Result)
	--重新开始其他任务
	self:RecoverOtherQuest()
	if self.SpecialQuestFinishCallback and Result ~= "NoExit" then
		DebugPrint("gyy@ContinueMainQuest ", self.SpecialQuestId)
		self.SpecialQuestFinishCallback(Result)
	end
	self.SpecialQuestFinishCallback = nil
end

function SpecialQuestEvent:Destroy(Result, Info)
	EventManager:RemoveEvent(EventID.OnSpecialQuestFail,self)
	EventManager:RemoveEvent(EventID.OnEnterTriggerBox,self)
	EventManager:RemoveEvent(EventID.OnLeaveTriggerBox,self)
	EventManager:RemoveEvent(EventID.CharDie, self)
	if self.SpecialQuestConfig.FailCustomEvent and self.FailCustomEventCallback then
		local GameInstance = GWorld.GameInstance
		local GameMode = UE4.UGameplayStatics.GetGameMode(GameInstance)
		GameMode.OnCustomEventDelegates:Remove(GameInstance, self.FailCustomEventCallback)
		self.FailCustomEventCallback = nil
	end
	local Avatar = GWorld:GetAvatar()
	if Avatar then
		if self.EnterRegionSkipCallback then
			for _, SubRegionId in pairs(self.SubRegionIds) do
				Avatar:RemoveSubRegionSkipCallback(SubRegionId, self, self.EnterRegionSkipCallback)
			end
		end
		if self.LeaveRegionSkipCallback then
			for _, SubRegionId in pairs(self.SubRegionIds) do
				Avatar:RemoveSubRegionSkipCallback(SubRegionId, self, self.LeaveRegionSkipCallback)
			end
		end
	end
	if self.SpecialQuestStory then
		DebugPrint("gyy@StopSpecialQuestStoryline ", self.SpecialQuestId)
		local IgnoreFinishClear = false
		if self.ResultTable[Result] then
			IgnoreFinishClear = true
		end
		GWorld.StoryMgr:StopStoryline(self.SpecialQuestStory, IgnoreFinishClear)
	end
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if not IsValid(GameMode) then
		local Message = "GameMode is not valid，无法清理区域数据"..
		"\n特殊任务编号:"..self.SpecialQuestId
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, SpecialQuestLogType, "GameMode is not valid，无法清理区域数据", Message)
		return
	end
	-- local StaticCreatorArray = TArray(0)
	-- StaticCreatorArray:Add(self.TriggerBoxStaticCreatorId)
	-- GameMode:TriggerInactiveStaticCreator(StaticCreatorArray)
	-- 清理该特殊任务的所有区域数据
	GameMode:ClearRegionActorData("SpecialQuestId", self.SpecialQuestId, EDestroyReason.QuestChainClear, function(Target, Key, Value)
        return Target.ExtraRegionInfo.SpecialQuestId == Value
    end)
end

function SpecialQuestEvent:ExecuteFinishNodeCallback(Result)
	local Callbacks = nil
	if self.ResultTable[Result] then
		if self.SuccessNodeCallback then
			DebugPrint("gyy@ExecuteSuccessNodeCallback ", self.SpecialQuestId)
			Callbacks = self.SuccessNodeCallback
		end
	else
		if self.FailNodeCallback then
			DebugPrint("gyy@ExecuteFailNodeCallback ", self.SpecialQuestId)
			Callbacks = self.FailNodeCallback
		end
	end
	if Callbacks then
		for Obj,Callback in pairs(Callbacks) do
			Callback(Obj)
		end
	end
	self.SuccessNodeCallback = nil
	self.FailNodeCallback = nil
end

function SpecialQuestEvent:EventEnd()
	local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
	ClientEventUtils:ClearSpecailQuestEvent(self.SpecialQuestId)
end

--------------------触发事件----------------------
function SpecialQuestEvent:OnEnterTriggerBox(TriggerEventId, TriggerBase, EMActorEid)
	PrintTable({OnEnterTriggerBox=1})
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if not Player then
		DebugPrint("gyy@Player Is nil When EnterTriggerBox", self.SpecialQuestId)
		return
	end
	if TriggerEventId == self.TriggerBoxStaticCreatorId and Player.Eid == EMActorEid then
		-- 玩家进入触发
		EventManager:RemoveEvent(EventID.OnEnterTriggerBox,self)
		self:TryActivateEvent()
	end
end

function SpecialQuestEvent:OnLeaveTriggerBox(TriggerEventId, TriggerBase, EMActorEid)
	PrintTable({OnLeaveTriggerBox=1})
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if not Player then
		DebugPrint("gyy@Player Is nil When LeaveTriggerBox", self.SpecialQuestId)
		return
	end
	if TriggerEventId == self.TriggerBoxStaticCreatorId and Player.Eid == EMActorEid then
		-- 玩家离开触发
		DebugPrint("gyy@SpecialQuestFail,LeaveTriggerBox ", self.SpecialQuestId)
		EventManager:RemoveEvent(EventID.OnLeaveTriggerBox,self)
		EventManager:FireEvent(EventID.OnSpecialQuestFail, "LeaveTriggerBox")
	end
end

function SpecialQuestEvent:CheckSubRegionIds()
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return false
	end
	local CurrentRegionId = Avatar.CurrentRegionId
	for _, SubRegionId in pairs(self.SubRegionIds) do
		if CurrentRegionId == SubRegionId then
			return true
		end
	end
	return false
end

function SpecialQuestEvent:WaitingEnterSubRegion()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
	self.EnterRegionSkipCallback = function ()
		self:TryActivateEvent()
		for _, SubRegionId in pairs(self.SubRegionIds) do
			Avatar:RemoveSubRegionSkipCallback(SubRegionId, self, self.EnterRegionSkipCallback)
		end
    end
	for _, SubRegionId in pairs(self.SubRegionIds) do
		Avatar:AddRegionSkipCallback(SubRegionId, self, self.EnterRegionSkipCallback)
	end
end

function SpecialQuestEvent:WaitingLeaveSubRegion()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
	self.LeaveRegionSkipCallback = function ()
		if not self:CheckSubRegionIds() then
			DebugPrint("gyy@SpecialQuestFail,LeaveSubRegion ", self.SpecialQuestId)
			EventManager:FireEvent(EventID.OnSpecialQuestFail, "LeaveRegion")
			for _, SubRegionId in pairs(self.SubRegionIds) do
				Avatar:RemoveSubRegionSkipCallback(SubRegionId, self, self.LeaveRegionSkipCallback)
			end
		else
			for _, SubRegionId in pairs(self.SubRegionIds) do
				Avatar:AddRegionSkipCallback(SubRegionId, self, self.LeaveRegionSkipCallback)
			end
		end
    end
	for _, SubRegionId in pairs(self.SubRegionIds) do
		Avatar:AddRegionSkipCallback(SubRegionId, self, self.LeaveRegionSkipCallback)
	end
end
--------------------触发事件----------------------

--------------------黑屏处理----------------------
function SpecialQuestEvent:PlaySuccessOrFailBlackScreen(Result)
	if not self.ResultTable[Result] and self.UniversalConfig and self.UniversalConfig.FailBlackScreen then
		--失败黑屏处理
		DebugPrint("gyy@FailBlackScreen ", self.SpecialQuestId)
		self:PlayFailBlackScreen(Result)
	elseif self.ResultTable[Result] and self.UniversalConfig and self.UniversalConfig.SuccessBlackScreen then
		--成功黑屏处理
		DebugPrint("gyy@SuccessBlackScreen ", self.SpecialQuestId)
		self:PlaySuccessBlackScreen(Result)
	end
end

function SpecialQuestEvent:PlayStartBlackScreen()
	local PlayBlackScreenTime = {
		FadeIn = self.UniversalConfig.StartBlackScreen[1] or 0,
		FadeOut = self.UniversalConfig.StartBlackScreen[2] or 0,
		Continue = self.UniversalConfig.StartBlackScreen[3] or DataMgr.GlobalConstant.SpecialQuestBlackTimeMin.ConstantValue,
	}
	local OnStartBlackScreenFadeOutSecond = function()
		self:FinishStartBlackScreen()
		assert(false, "已达黑屏最长时间，但特殊任务未成功开始，SpecialQuestId:"..self.SpecialQuestId..",TryActive:"..tostring(self.TryActive)..",BlackScreenImmediately:"..tostring(self.BlackScreenImmediately))
	end
	local OnStartBlackScreenFadeOutFirst = function()
		self.StartBlackScreenContinueFinish = true
		self:TryRunSpecialStory()
		local Ans = self:TryFinishStartBlackScreen()
		if not Ans then
			GWorld.GameInstance:AddTimer(DataMgr.GlobalConstant.SpecialQuestBlackTimeMax.ConstantValue-PlayBlackScreenTime.Continue,OnStartBlackScreenFadeOutSecond,false,nil,"SpecialQuestStartBlackScreenTimer",true)
		end
	end
	local StartBlackScreenContinue = function()
		self.StartBlackScreenFadeInFinish = true
		self:TryPreRunSpecialStory()
		GWorld.GameInstance:AddTimer(PlayBlackScreenTime.Continue,OnStartBlackScreenFadeOutFirst,false,nil,nil,true)
	end
	local OnStartBlackScreenFnish = function()
		local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
		if IsValid(Player) then
			Player:RemoveDisableInputTag("SpecialQuestStart")
		end
		UIManager(GWorld.GameInstance):SetBannedActionCallback("BlackScreen", false, "SpecialQuestStart")
	end

	local UIManager = GWorld.GameInstance:GetGameUIManager()
	local Params = {}
	Params.BlackScreenHandle = "SpecialQuestStart"
	Params.InAnimationObj = self
	Params.InAnimationCallback = StartBlackScreenContinue
	Params.InAnimationPlayTime = PlayBlackScreenTime.FadeIn
	Params.OutAnimationObj = self
    Params.OutAnimationCallback = OnStartBlackScreenFnish
	Params.OutAnimationPlayTime = PlayBlackScreenTime.FadeOut
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if IsValid(Player) then
        Player:AddDisableInputTag("SpecialQuestStart")
    end
	UIManager:SetBannedActionCallback("BlackScreen", true, "SpecialQuestStart")
	UIManager:ShowCommonBlackScreen(Params)
end

function SpecialQuestEvent:TryFinishStartBlackScreen()
	if self.RunSpecialStoryFinish then
		self:FinishStartBlackScreen()
		return true
	end
	return false
end

function SpecialQuestEvent:FinishStartBlackScreen()
	DebugPrint("gyy@FinishStartBlackScreen ", self.SpecialQuestId)
	GWorld.GameInstance:RemoveTimer("SpecialQuestStartBlackScreenTimer")
	UIManager(self):HideCommonBlackScreen("SpecialQuestStart")
end

function SpecialQuestEvent:PlaySuccessBlackScreen(Result)
	local PlayBlackScreenTime = {
		FadeIn = self.UniversalConfig.SuccessBlackScreen[1] or 0,
		FadeOut = self.UniversalConfig.SuccessBlackScreen[2] or 0,
		Continue = self.UniversalConfig.SuccessBlackScreen[3] or DataMgr.GlobalConstant.SpecialQuestBlackTimeMin.ConstantValue,
	}
	local OnSuccessBlackScreenFadeOutSecond = function()
		self:FinishSuccessBlackScreen()
		assert(false, "已达黑屏最长时间，但特殊任务未成功结束，SpecialQuestId:"..self.SpecialQuestId..",TryFinish:"..tostring(self.TryFinish))
	end
	local OnSuccessBlackScreenContinueFinish = function()
		self.SuccessBlackScreenContinueFinish = true
		local Ans = self:TryRecoverQuestAndFinishSuccessBlackScreen(Result)
		if not Ans then
			GWorld.GameInstance:AddTimer(DataMgr.GlobalConstant.SpecialQuestBlackTimeMax.ConstantValue-PlayBlackScreenTime.Continue,OnSuccessBlackScreenFadeOutSecond,false,nil,"SpecialQuestSuccessBlackScreenTimer",true)
		end
	end
	local OnSuccessBlackScreenFnish = function()
		local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
		if IsValid(Player) then
			Player:RemoveDisableInputTag("SpecialQuestSuccess")
		end
		UIManager(GWorld.GameInstance):SetBannedActionCallback("BlackScreen", false, "SpecialQuestSuccess")
	end
	local SuccessBlackScreenContinue = function()
		self.SuccessBlackScreenFadeInFinish = true
		self:TryRealFinishEvent(Result)
		GWorld.GameInstance:AddTimer(PlayBlackScreenTime.Continue,OnSuccessBlackScreenContinueFinish,false,nil,nil,true)
	end

	local UIManager = GWorld.GameInstance:GetGameUIManager()
	local Params = {}
	Params.BlackScreenHandle = "SpecialQuestSuccess"
	Params.InAnimationObj = self
	Params.InAnimationCallback = SuccessBlackScreenContinue
	Params.InAnimationPlayTime = PlayBlackScreenTime.FadeIn
	Params.OutAnimationObj = self
    Params.OutAnimationCallback = OnSuccessBlackScreenFnish
	Params.OutAnimationPlayTime = PlayBlackScreenTime.FadeOut
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if IsValid(Player) then
		Player:AddDisableInputTag("SpecialQuestSuccess")
	end
	UIManager:SetBannedActionCallback("BlackScreen", true, "SpecialQuestSuccess")
	UIManager:ShowCommonBlackScreen(Params)
end

function SpecialQuestEvent:TryRecoverQuestAndFinishSuccessBlackScreen(Result)
	if self.RealFinish and self.SuccessBlackScreenContinueFinish then
		self:RecoverOtherQuestAndPreQuest(Result)
		self:FinishSuccessBlackScreen()
		return true
	end
end

function SpecialQuestEvent:FinishSuccessBlackScreen()
	DebugPrint("gyy@FinishSuccessBlackScreen ", self.SpecialQuestId)
	GWorld.GameInstance:RemoveTimer("SpecialQuestSuccessBlackScreenTimer")
	UIManager(self):HideCommonBlackScreen("SpecialQuestSuccess")
end

function SpecialQuestEvent:PlayFailBlackScreen(Result)
	local PlayBlackScreenTime = {
		FadeIn = self.UniversalConfig.FailBlackScreen[1] or 0,
		FadeOut = self.UniversalConfig.FailBlackScreen[2] or 0,
		Continue = self.UniversalConfig.FailBlackScreen[3] or DataMgr.GlobalConstant.SpecialQuestBlackTimeMin.ConstantValue,
	}
	local OnFailBlackScreenFadeOutSecond = function()
		self:FinishFailBlackScreen()
		assert(false, "已达黑屏最长时间，但特殊任务未成功结束，SpecialQuestId:"..self.SpecialQuestId..",TryFinish:"..tostring(self.TryFinish))
	end
	local OnFailBlackScreenContinueFinish = function()
		self.FailBlackScreenContinueFinish = true
		local Ans = false
		if Result == "PassiveFail" and self.UniversalConfig.FailureGuidanceCombinationId then
			Ans = self:TryOpenFailureGuidanceUIAndFinishFailBlackScreen()
		else
			Ans = self:TryRecoverQuestAndFinishFailBlackScreen(Result)
		end
		if not Ans then
			GWorld.GameInstance:AddTimer(DataMgr.GlobalConstant.SpecialQuestBlackTimeMax.ConstantValue-PlayBlackScreenTime.Continue,OnFailBlackScreenFadeOutSecond,false,nil,"SpecialQuestFailBlackScreenTimer",true)
		end
	end
	local OnFailBlackScreenFnish = function()
		local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
		if IsValid(Player) then
			Player:RemoveDisableInputTag("SpecialQuestFail")
		end
		UIManager(GWorld.GameInstance):SetBannedActionCallback("BlackScreen", false, "SpecialQuestFail")
	end
	local FailBlackScreenContinue = function()
		self.FailBlackScreenFadeInFinish = true
		self:TryRealFinishEvent(Result)
		GWorld.GameInstance:AddTimer(PlayBlackScreenTime.Continue,OnFailBlackScreenContinueFinish,false,nil,nil,true)
	end

	local UIManager = GWorld.GameInstance:GetGameUIManager()
	local Params = {}
	Params.BlackScreenHandle = "SpecialQuestFail"
	Params.BlackScreenText = GText(self.UniversalConfig.FailBlackScreenText)
	Params.InAnimationObj = self
	Params.InAnimationCallback = FailBlackScreenContinue
	Params.InAnimationPlayTime = PlayBlackScreenTime.FadeIn
	Params.OutAnimationObj = self
    Params.OutAnimationCallback = OnFailBlackScreenFnish
	Params.OutAnimationPlayTime = PlayBlackScreenTime.FadeOut
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if IsValid(Player) then
		Player:AddDisableInputTag("SpecialQuestFail")
	end
	UIManager:SetBannedActionCallback("BlackScreen", true, "SpecialQuestFail")
	UIManager:ShowCommonBlackScreen(Params)
end

function SpecialQuestEvent:TryRecoverQuestAndFinishFailBlackScreen(Result)
	if self.RealFinish and self.FailBlackScreenContinueFinish then
		self:RecoverOtherQuestAndPreQuest(Result)
		self:FinishFailBlackScreen()
		return true
	end
end

function SpecialQuestEvent:FinishFailBlackScreen()
	DebugPrint("gyy@FinishFailBlackScreen ", self.SpecialQuestId)
	GWorld.GameInstance:RemoveTimer("SpecialQuestFailBlackScreenTimer")
	UIManager(self):HideCommonBlackScreen("SpecialQuestFail")
end

function SpecialQuestEvent:TryOpenFailureGuidanceUIAndFinishFailBlackScreen()
	if self.RealFinish and self.FailBlackScreenContinueFinish then
		self:OpenFailureGuidanceUI()
		self:FinishFailBlackScreen()
		return true
	end
end

function SpecialQuestEvent:OpenFailureGuidanceUI()
	local StoryBattleFailUI = UIManager(self):LoadUINew("StoryBattleFail", self.UniversalConfig.FailureGuidanceCombinationId)
	StoryBattleFailUI:BindEventOnRetry(self, self.RetryCallback)
	StoryBattleFailUI:BindEventOnExit(self, self.ExitCallback)
end

function SpecialQuestEvent:RetryCallback()
	local Result = "PassiveFail"
	self:RecoverOtherQuestAndPreQuest(Result)
end

function SpecialQuestEvent:ExitCallback()
	local Result = "Fail"
	self:RecoverOtherQuestAndPreQuest(Result)
end
--------------------黑屏处理----------------------

--------------------通用配置----------------------
function SpecialQuestEvent:SetUniversalConfig()
	if self.UniversalConfig then
		local GameInstance = GWorld.GameInstance
		local GameMode = UE4.UGameplayStatics.GetGameMode(GameInstance)
		local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
		local PlayerController = UE4.UGameplayStatics.GetPlayerController(GameInstance, 0)
		
		DebugPrint("gmy@SpecialQuestEvent:SetUniversalConfig ", self.UniversalConfig.DisableBattleWheel, self.UniversalConfig.HideBattleWheel)
		if Player then
			Player:SetQuestBattleWheelID(self.UniversalConfig.QuestBattleWheelID)
			if self.UniversalConfig.DisableBattleWheel then
				Player:DisableBattleWheel()
			elseif not self.UniversalConfig.DisableBattleWheel then
                Player:EnableBattleWheel()
			end

			if self.UniversalConfig.HideBattleWheel then
				Player:HideBattleWheel()
			end
		end
		if self.UniversalConfig.IfDestoryPhantom then
			UE4.UPhantomFunctionLibrary.CancelAllPhantom(Player, EDestroyReason.SpecialQuestClear)
		else
			local PhantomTeammates = Player:GetPhantomTeammates()
			for _,PhantomTeammate in pairs(PhantomTeammates) do
				if PhantomTeammate:IsPhantom() then
					--PhantomTeammate:InitCharacterInfo(PhantomTeammate.InfoForInit)
					if IsValid(GameMode) then
						local ContextCopy = PhantomTeammate.CreateUnitContextCopy
						ContextCopy.BoolParams:Add("SkipInitWaitCheck", true)
						GameMode.EMGameState.EventMgr:RegisterCreateData(PhantomTeammate.Eid, ContextCopy)
					end
					PhantomTeammate:TryInitCharacterInfo("InitInfo")
				end
			end
		end
		if self.UniversalConfig.IfInitPlayer then
			--self:EndInteractive()
			self:InitPlayer()
		end
		if Player and self.UniversalConfig.RespawnRuleId then
			Player:RefreshRecoveryData(self.UniversalConfig.RespawnRuleId)
		end
		if self.UniversalConfig.HideBattlePet then
			if Player.GetBattlePet then
				local BattlePet = Player:GetBattlePet()
				if BattlePet then
					BattlePet:HideBattlePet("SpecialQuest", true)
				end
			end
			self.Skill3IsInActive = PlayerController:CheckSkillInActive(ESkillName.Skill3)
			if not self.Skill3IsInActive then
				local InActiveSkills = TArray(0)
				InActiveSkills:Add(ESkillName.Skill3)
				PlayerController:InActiveSkills(InActiveSkills, "Lock")
			end
		end
		if self.UniversalConfig.SetPlayerTransform then
			self:SetPlayerLocation(self.UniversalConfig.SetPlayerTransform)
		end
		if self.UniversalConfig.IfCloseRegionOnline then
			EventManager:FireEvent(EventID.SpecialQuestCloseRegionOnline, false, true, "SpecialQuest")
		end
		if self.UniversalConfig.IfStartStoryMode then
			self.LastStoryMode = false
			local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
			if PlayerController then
				self.LastStoryMode = PlayerController:GetStoryModeState()
				PlayerController:SetStoryModeState(true)
			end
		end
		if self.UniversalConfig.IfChangeESC then
			local BattleMainUI = UIManager():GetUIObj("BattleMain")
			if BattleMainUI ~= nil then
				BattleMainUI:InitEsc()
			end
		end
		if self.UniversalConfig.IfInActiveInteractive then
			local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
			if self.UniversalConfig.IfInActiveInteractive.Type == "Part" and not self.UniversalConfig.IfInActiveInteractive.Id then
				local Message = "特殊任务启用关闭部分机关交互，但是没有填机关ID"..
                "\n特殊任务编号:"..self.SpecialQuestId
				UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, SpecialQuestLogType, "特殊任务启用关闭部分机关交互，但是没有填机关ID", Message)
				--GWorld.logger.error("特殊任务通用配置"..self.SpecialQuestConfig.UniversalConfigId.."启用关闭部分机关交互，但是没有填机关ID")
				return
			end
			GameState:ChangeMechanismInteractiveInSpecialQuest(true, self.UniversalConfig.IfInActiveInteractive.Type, self.UniversalConfig.IfInActiveInteractive.Id)
		end
	end
end

function SpecialQuestEvent:SaveRegionData()
	-- 记录特殊任务开始
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	local HoldRegionDataType =  self.UniversalConfig and self.UniversalConfig.RegionDataType
	HoldRegionDataType = HoldRegionDataType or {}
	local TriggerBoxStaticCreatorId = self.SpecialQuestConfig.TriggerBoxStaticCreatorId
	local SpecialQuestId = self.SpecialQuestId
	local DestroyPhantom = self.UniversalConfig.IfDestoryPhantom == 0

	for _,v in pairs(HoldRegionDataType) do
		if v == "All" then
			return
		end
	end

	if GameMode then
		GameMode:RecoverDataAndStopBySpecialQuest(self.PreQuestChainId, self.SpecialQuestId)
		local DataLibrary = GameMode:GetRegionDataMgrSubSystem().DataLibrary
		DataLibrary:OnSpecialQuestBegin(self.PreQuestChainId,self.SpecialQuestId,HoldRegionDataType)
		GameMode:ClearRegionData_DestroyActor("PrequestChainId",self.PreQuestChainId,UE4.EDestroyReason.SepcialQuestStart,function(Target,Key,Value)
			if TriggerBoxStaticCreatorId and Target.TriggerEventId and Target.TriggerEventId == TriggerBoxStaticCreatorId then
				return false
			end

			if Target.ExtraRegionInfo.DynQuestId > 0 then
				return false
			end

			if not DestroyPhantom and Target.IsPhantom and Target:IsPhantom() then
				return false
			end

			if Target.ExtraRegionInfo.SpecialQuestId == SpecialQuestId then
				return false
			end

			if Target.BpBorn then
				return false
			end

			if Target.GetUnitRealType and Target.SourceEid then
				local Source = Battle(Target):GetEntity(Target.SourceEid)
				if IsValid(Source) then
					if Target:GetUnitRealType() == "MiniGame" then
						return DataLibrary:CheckRegionDataTypeNeedDestroy(Source.RegionDataType,Source.QuestChainId)
					elseif Target:GetUnitRealType() == "Controller" then
						return DataLibrary:CheckRegionDataTypeNeedDestroy(Source.RegionDataType,Source.QuestChainId) and not Source.BpBorn
					end
				end
			end

			if Target.GetRootSource and Target:GetRootSource() and Target:GetRootSource():IsMainPlayer() then
				DebugPrint("Special Quest Can Not Destroy PlayerSummon")
				return
			end 

			return DataLibrary:CheckRegionDataTypeNeedDestroy(Target.RegionDataType,Target.QuestChainId)
		end)
		if GameMode.EMGameState.EventMgr then
			GameMode.EMGameState.EventMgr:OnSpecialQuestBeginNew()
			-- GameMode.EMGameState.EventMgr:OnSpecialQuestBegin()
		end
	end
end

function SpecialQuestEvent:RecoverRegionData()
	-- 特殊任务结束，恢复开始时被销毁的Actor
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if GameMode and self.UniversalConfig then
		GameMode:GetRegionDataMgrSubSystem().DataLibrary:OnSpecialQuestEnd()
		if self.UniversalConfig.RegionDataType~="All" then
			GameMode:GetRegionDataMgrSubSystem():OnSpecialQuestFinish()
		end
	end
end

function SpecialQuestEvent:RecoverUniversalConfig()
	if self.UniversalConfig then
		local GameInstance = GWorld.GameInstance
		local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
		local PlayerController = UE4.UGameplayStatics.GetPlayerController(GameInstance, 0)
		DebugPrint("gmy@SpecialQuestEvent:RecoverUniversalConfig ", self.UniversalConfig.DisableBattleWheel, self.UniversalConfig.HideBattleWheel)
		if Player then
			Player:SetQuestBattleWheelID(nil)
		end
		if self.UniversalConfig.DisableBattleWheel then
			if Player then
				Player:EnableBattleWheel()
			end
		end
		
		if self.UniversalConfig.HideBattleWheel then
			if Player then
				Player:ShowBattleWheel()
			end
		end
		if self.UniversalConfig.RespawnRuleId then
			local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
			if Player and GameMode then
				local RespawnRuleName = GameMode:GetRespawnRuleName(Player)
				Player:RefreshRecoveryData(RespawnRuleName)
			end
		end
		if self.UniversalConfig.HideBattlePet then
			if Player.GetBattlePet then
				local BattlePet = Player:GetBattlePet()
				if BattlePet then
					BattlePet:HideBattlePet("SpecialQuest", false)
				end
			end
			if not self.Skill3IsInActive then
				local ActiveSkills = TArray(0)
				ActiveSkills:Add(ESkillName.Skill3)
				PlayerController:ActiveSkills(ActiveSkills, "UnLock")
			end
		end
		if self.UniversalConfig.IfWaitDead then
			EventManager:RemoveEvent(EventID.CharDie, self)
		end
		if self.UniversalConfig.IfCloseRegionOnline then
			EventManager:FireEvent(EventID.SpecialQuestOpenRegionOnline, false, true, "SpecialQuest")
		end
		if self.UniversalConfig.IfStartStoryMode then
			if PlayerController then
				PlayerController:SetStoryModeState(self.LastStoryMode)
			end
		end
		if self.UniversalConfig.IfChangeESC then
			local BattleMainUI = UIManager():GetUIObj("BattleMain")
			if BattleMainUI ~= nil then
				BattleMainUI:InitEsc()
			end
		end
		if self.UniversalConfig.IfInActiveInteractive then
			local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
			if self.UniversalConfig.IfInActiveInteractive.Type == "Part" and not self.UniversalConfig.IfInActiveInteractive.Id then
				local Message = "特殊任务启用打开部分机关交互，但是没有填机关ID"..
                "\n特殊任务编号:"..self.SpecialQuestId
				UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, SpecialQuestLogType, "特殊任务启用打开部分机关交互，但是没有填机关ID", Message)
				--GWorld.logger.error("特殊任务通用配置"..self.SpecialQuestConfig.UniversalConfigId.."启用打开部分机关交互，但是没有填机关ID")
				return
			end
			GameState:ChangeMechanismInteractiveInSpecialQuest(false, self.UniversalConfig.IfInActiveInteractive.Type, self.UniversalConfig.IfInActiveInteractive.Id)
		end
	end
end

function SpecialQuestEvent:InitPlayer()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if GameMode then
    	GameMode:SwitchToQuestRole(0)
    end
end

function SpecialQuestEvent:SetPlayerLocation(TargetPointName)
	local GameInstance = GWorld.GameInstance
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
	local PlayerController = UE4.UGameplayStatics.GetPlayerController(GameInstance, 0)
	local GameState = UE4.UGameplayStatics.GetGameState(Player)
	local PlayerPoint = GameState:GetTargetPoint(TargetPointName)
	if PlayerPoint then
		Player:K2_SetActorLocation(PlayerPoint:k2_GetActorLocation(), false, nil, false)
		Player:K2_SetActorRotation(PlayerPoint:K2_GetActorRotation(), false)
		PlayerController:SetControlRotation(FRotator(0,PlayerPoint:K2_GetActorRotation().Yaw,0))
	end
end

function SpecialQuestEvent:EndInteractive()
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if Player then
		local Eid = Player.MechanismEid
		if Eid ~= 0 then
			local Mechanism = Battle(GWorld.GameInstance):GetEntity(Eid)
			if Mechanism and Mechanism.ChestInteractiveComponent then
				Mechanism.ChestInteractiveComponent:ForceEndInteractive(Player, false, Const.ForceEndInteractive)
			end
		end
	end
end
--------------------通用配置----------------------

--------------------埋点信息----------------------
function SpecialQuestEvent:GetStartInfos()
	local Infos = {
			scriptboss_pve_id = self.SpecialQuestId
		}
	return Infos
end

function SpecialQuestEvent:GetFinishInfos(Reason, Result)
	local Infos = {}
	local GameInstance = GWorld.GameInstance
	local PlayerController = UE4.UGameplayStatics.GetPlayerController(GameInstance, 0)
	Infos = PlayerController:GetCombatStatistics()
	Infos.scriptboss_pve_id = self.SpecialQuestId
	if self.ResultTable[Result] then
		Infos.pve_result = "Win"
	else
		if Reason == "Exit" then
			Infos.pve_result = "Exit"
		else
			Infos.pve_result = "Fail"
		end
	end
	return Infos
end
--------------------埋点信息----------------------

--------------------重置/恢复场景----------------------
function SpecialQuestEvent:ResetQuestArtLevel()
	self:UpdateQuestArtLevel_SpecialQuest(0)
end

function SpecialQuestEvent:RecoverQuestArtLevel()
	self:UpdateQuestArtLevel_SpecialQuest(1)
end

function SpecialQuestEvent:UpdateQuestArtLevel_SpecialQuest(NewValue)
	if not self.SpecialQuestConfig.ResetVarNameList then
		return
	end
	local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
	local SubRegionId = Avatar:GetCurrentRegionId()
	local SubRegionData = DataMgr.SubRegion[SubRegionId]
	if not SubRegionData then 
		return
	end
	local RegionId = SubRegionData.RegionId
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if not IsValid(GameMode) then
		return
	end
	local BlackScreenEnable = (NewValue == 1)
	for i, VarName in pairs(self.SpecialQuestConfig.ResetVarNameList) do
		local VarValue = Avatar.StoryVariable[VarName]
		if VarValue == 1 then
			GameMode:RealQuestArtLevelChange(RegionId, VarName, BlackScreenEnable, NewValue)
		end
	end
end
--------------------重置/恢复场景----------------------

--------------------暂停/恢复任务----------------------
function SpecialQuestEvent:StopOtherQuest()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
		Avatar:StopQuestChainExcept(self.PreQuestChainId)
    end
	EventManager:FireEvent(EventID.HideNpcSideIndicator, false)
end

function SpecialQuestEvent:RecoverOtherQuest()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
		Avatar:TriggerQuestChain()
    end
	EventManager:FireEvent(EventID.HideNpcSideIndicator, true)
end

function SpecialQuestEvent:StopDynamicQuest()
    local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
	if ClientEventUtils:GetCurrentDoingDynamicEvent() then
		ClientEventUtils:ClearCurrentDoingDynamicEvent(true)
	end
end
--------------------暂停/恢复任务----------------------

--------------------失败条件----------------------
function SpecialQuestEvent:SetFailCondition()
	--死亡失败
    if self.UniversalConfig and self.UniversalConfig.IfWaitDead then
		EventManager:AddEvent(EventID.CharDie, self, function(_, Eid)
			local Entity = Battle(GWorld.GameInstance):GetEntity(Eid)
			if Entity:IsPlayer() then
				EventManager:RemoveEvent(EventID.CharDie, self)
				EventManager:FireEvent(EventID.OnSpecialQuestFail, "CharDie")
				DebugPrint("gyy@SpecialQuestFail,PlayerCharacterDead ",self.SpecialQuestId)
			end
		end)
	end
	--收到FailCustomEvent消息，失败
	if self.SpecialQuestConfig.FailCustomEvent then
		local GameInstance = GWorld.GameInstance
		local GameMode = UE4.UGameplayStatics.GetGameMode(GameInstance)
		self.FailCustomEventCallback = function (Owner, EventName, Channel)
			if EventName == self.SpecialQuestConfig.FailCustomEvent then
				EventManager:FireEvent(EventID.OnSpecialQuestFail, "FailCustomEvent")
				DebugPrint("gyy@SpecialQuestFail,ReceiveFailCustomEvent ", EventName, self.SpecialQuestId)
			end
		end
		GameMode.OnCustomEventDelegates:Add(GameInstance, self.FailCustomEventCallback)
	end
end
--------------------失败条件----------------------

--------------------等待失败----------------------
function SpecialQuestEvent:WaitingFail()
	local SpecialQuestFail = function (_, Reason)
        EventManager:RemoveEvent(EventID.OnSpecialQuestFail, self)
        self:TryFinishEvent(Reason)
    end

	EventManager:RemoveEvent(EventID.OnSpecialQuestFail, self)
    EventManager:AddEvent(EventID.OnSpecialQuestFail, self, SpecialQuestFail)
end

function SpecialQuestEvent:AddFailNodeCallback(Obj,FailNodeCallback)
	if not self.FailNodeCallback then
		self.FailNodeCallback = {}
	end
	if not self.FailNodeCallback[Obj] then
		self.FailNodeCallback[Obj] = FailNodeCallback
	end
end

function SpecialQuestEvent:RemoveFailNodeCallback(Obj)
	if not self.FailNodeCallback then
		return
	end
	self.FailNodeCallback[Obj] = nil
end
--------------------等待失败----------------------

--------------------成功回调----------------------
function SpecialQuestEvent:AddSuccessNodeCallback(Obj,SuccessNodeCallback)
	if not self.SuccessNodeCallback then
		self.SuccessNodeCallback = {}
	end
	if not self.SuccessNodeCallback[Obj] then
		self.SuccessNodeCallback[Obj] = SuccessNodeCallback
	end
end

function SpecialQuestEvent:RemoveSuccessNodeCallback(Obj)
	if not self.SuccessNodeCallback then
		return
	end
	self.SuccessNodeCallback[Obj] = nil
end
--------------------成功回调----------------------

function SpecialQuestEvent:InterruptSpecialQuestEvent(Reason)
	DebugPrint("gyy@InterruptSpecialQuestEvent ", self.SpecialQuestId, Reason)
	if Reason == "NodeClear" then
		self.SpecialQuestFinishCallback = nil
	end
	if not self.TryActive then
		self.SpecialQuestFinishCallback = nil
		EventManager:RemoveEvent(EventID.OnEnterTriggerBox,self)
		local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
		if IsValid(GameMode) then
			local StaticCreatorArray = TArray(0)
			StaticCreatorArray:Add(self.TriggerBoxStaticCreatorId)
			GameMode:TriggerInactiveStaticCreator(StaticCreatorArray)
		end
		local Avatar = GWorld:GetAvatar()
		if Avatar then
			if self.EnterRegionSkipCallback then
				for _, SubRegionId in pairs(self.SubRegionIds) do
					Avatar:RemoveSubRegionSkipCallback(SubRegionId, self, self.EnterRegionSkipCallback)
				end
			end
		end
		local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
		ClientEventUtils:ClearSpecailQuestEvent(self.SpecialQuestId)
	else
		self:TryFinishEvent(Reason)
	end
end

return SpecialQuestEvent
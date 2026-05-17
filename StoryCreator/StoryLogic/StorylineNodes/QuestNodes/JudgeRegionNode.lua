local JudgeRegionNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

function JudgeRegionNode:Init()
	self.IsWaitingEnterRegion = false
	self.RegionIds = {}
	self.RegionSkipCallback = nil
end

function JudgeRegionNode:Execute()
	self:GoToRegion()
end

function JudgeRegionNode:GetOutIndex()
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end
	local CurrentRegionId = Avatar.CurrentRegionId
	local OutIndex = nil
	for Index, RegionId in pairs(self.RegionIds) do
		if CurrentRegionId == RegionId then
			OutIndex = Index
		end
	end
	return OutIndex
end

function JudgeRegionNode:FinishAction(OutPortName)
	local WCSubsystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self, UE4.UWorldCompositionSubSystem)
	if WCSubsystem then
		self:CheckIsAsyncTraveling(WCSubsystem, OutPortName)
		return
	end
	self:Finish(OutPortName)
end

function JudgeRegionNode:GoToRegion()
	local OutIndex = self:GetOutIndex()
	if OutIndex then
		self:FinishAction("Region_"..OutIndex)
	elseif not self.IsWaitingEnterRegion then
		self:FinishAction("LastDefaultOut")
	else
		local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
		local Avatar = GWorld:GetAvatar()
		if not GameMode or not Avatar then
			return
		end
		self.RegionSkipCallback = function ()
			OutIndex = self:GetOutIndex()
			if OutIndex then
				for _, RegionId in pairs(self.RegionIds) do
					Avatar:RemoveSubRegionSkipCallback(RegionId, self, self.RegionSkipCallback)
				end
				self:FinishAction("Region_"..OutIndex)
			end
		end
		for _, RegionId in pairs(self.RegionIds) do
			Avatar:AddRegionSkipCallback(RegionId, self, self.RegionSkipCallback)
		end
	end
end

function JudgeRegionNode:CheckIsAsyncTraveling(WCSubsystem, OutPortName)
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if not Player then
		self:Finish(OutPortName)
		return
	end
	local MovementComponent = Player:GetMovementComponent()
	if not MovementComponent then
		self:Finish(OutPortName)
		return
	end

	if not MovementComponent.bIsAsyncTraveling then
		self:Finish(OutPortName)
		return
	end
	
	local Func = function()
		self:Finish(OutPortName)
	end
	WCSubsystem:AddOnAsyncTravelEnded(self, Func)
end

function JudgeRegionNode:Clear()
	if self.RegionSkipCallback then
		local Avatar = GWorld:GetAvatar()
		if Avatar then
			for _, RegionId in pairs(self.RegionIds) do
				Avatar:RemoveSubRegionSkipCallback(RegionId, self, self.RegionSkipCallback)
			end
		end
	end
end

return JudgeRegionNode

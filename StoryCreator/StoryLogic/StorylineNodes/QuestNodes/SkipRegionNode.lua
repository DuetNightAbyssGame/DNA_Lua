





local SkipRegionNode = Class('StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode')


function SkipRegionNode:Init()
    -- self.ModeType = 0
    -- self.Id = 100101
    -- self.StartIndex = 0
	self.Callback = nil
end

function SkipRegionNode:Start(Context)
	self.Context = Context	
	self:Delivery()
end

function SkipRegionNode:Delivery()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    local Avatar = GWorld:GetAvatar()
    if not GameMode or not Avatar then return end
       
   
    local function Callback()
        self:FinishAction()
		Avatar:RemoveSubRegionSkipCallback(self.Id, self, self.Callback)
    end
	self.Callback = Callback
    Avatar:AddRegionSkipCallback(self.Id, self, self.Callback)

	local bIsFromMap = nil
	local bShouldReturnAndDownloadPatch = true
    local Res = GameMode:HandleLevelDeliver(self.ModeType, self.Id, self.StartIndex, self.IsWhite, self:GetPayload("bIsInvitation"), bIsFromMap, bShouldReturnAndDownloadPatch)
    DebugPrint("ZJT_ AddRegionSkipCallBack SkipRegionNode ", self.Id, Res, self.ModeType, self.StartIndex)

	-- 由STL发起的区域跳转不需要设置bIsAsyncTraveling
	local WCSubsystem = GameMode:GetWCSubSystem()
	if not WCSubsystem then
		return
	end
	local Player =  UE4.UGameplayStatics.GetPlayerCharacter(GameMode, 0)
	if not Player then
		return
	end
	local MovementComponent = Player:GetMovementComponent()
	if MovementComponent then
		MovementComponent.bIsAsyncTraveling = false
	end
end

function SkipRegionNode:FinishAction()	
	self:Finish()
end

function SkipRegionNode:Clear()	
	local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
	Avatar:RemoveSubRegionSkipCallback(self.Id, self, self.Callback)
end

return SkipRegionNode
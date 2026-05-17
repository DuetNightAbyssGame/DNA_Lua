





local SetNpcPoseNode = Class('StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode')


function SetNpcPoseNode:Init()
	self.NpcInfos = {}
	-- self.NpcPose = "Idle"
end

function SetNpcPoseNode:Start(Context)
	self.Context = Context
	local GameInstance = GWorld.GameInstance
	local GameState = UE4.UGameplayStatics.GetGameState(GameInstance)
	EventManager:AddEvent(EventID.OnNpcPoseChange,self,self.FinishActionEvent)
	for i, NpcInfo in pairs(self.NpcInfos) do
		local Npc = GameState.NpcCharacterMap:Find(NpcInfo.NpcId)
		if Npc then
			if NpcInfo.NpcPose == "Idle" and Npc:GetCharacterTag() ~= "Idle" then
				Npc:SetIdlePose(true)
				self.RealSetPose = true
			elseif NpcInfo.NpcPose == "Seating" and Npc:GetCharacterTag() == "Idle" then
				local Comp = Npc:GetComponentByClass(UMonsterLookAtComponent:StaticClass())
				if Comp and not Comp.bMontagePlayEnded then 
					Comp.bNpcCallSitPoseAfterCompleteTurnInPlace = true
				else
					Npc:SetSitPoseInteractive()
				end
				self.RealSetPose = true
				-- Npc:AddTimer(2, self.FinishActionEvent)
			else
				self:FinishActionEvent()
			end
		else
			self:FinishActionEvent()
		end
	end
	-- self:FinishAction()
end

function SetNpcPoseNode:FinishActionEvent()
	if self.FinishActionEvent ~= true then
		self:FinishAction()
		DebugPrint("========================================================================SetNpcPoseNode:FinishActionEvent:",self.NpcInfos[1].NpcPose,self.RealSetPose)
	end
	self.FinishActionEvent = true
end

function SetNpcPoseNode:FinishAction()
	EventManager:RemoveEvent(EventID.OnNpcPoseChange,self)
	self:Finish()
end

function SetNpcPoseNode:OnQuestlineFail()
	local GameInstance = GWorld.GameInstance
	local GameState = UE4.UGameplayStatics.GetGameState(GameInstance)
	for i, NpcInfo in pairs(self.NpcInfos) do
		local Npc = GameState.NpcCharacterMap:Find(NpcInfo.NpcId)
		if Npc then
			Npc.RealSetPose = self.RealSetPose
			DebugPrint("========================================================================SetNpcPoseNode:OnQuestlineFail:",self.NpcInfos[1].NpcPose,self.RealSetPose)
			--等所有SetNpcPoseNode的OnQuestlineFail执行完毕后执行下面逻辑，仅一次就够
			Npc:RemoveTimer("SetNpcPoseNodeOnQuestlineFail")
			Npc:AddTimer(0.1,
				function()
					DebugPrint("========================================================================SetNpcPoseNode:OnQuestlineFail:Npc:GetCharacterTag():",Npc:GetCharacterTag())
					if Npc.RealSetPose == true then
						if NpcInfo.NpcPose == "Seating" and Npc:GetCharacterTag() ~= "Idle" then
							Npc:SetIdlePose(true)
							DebugPrint("========================================================================SetNpcPoseNode:Npc:SetIdlePose")
						elseif NpcInfo.NpcPose == "Idle"  and Npc:GetCharacterTag() == "Idle" then
							Npc:SetSitPoseInteractive()
							DebugPrint("========================================================================SetNpcPoseNode:Npc:SetSitPoseInteractive")
						else
							DebugPrint("========================================================================SetNpcPoseNode:Npc Not Change Pose")
						end
					end
				end, false, 0, "SetNpcPoseNodeOnQuestlineFail")
		end
	end
end

return SetNpcPoseNode
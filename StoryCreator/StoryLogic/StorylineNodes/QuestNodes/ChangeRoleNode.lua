
local ChangeRoleNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode')

function ChangeRoleNode:Init()
	self.Context.RevertRole = false
	self.Context.CurrentRole = nil
end

function ChangeRoleNode:Execute()
	if not DataMgr.QuestRoleInfo[self.QuestRoleId] then
		local Message = "QuestRoleId不存在"..
		"\n\t在调用SwitchToQuestRole的时候，传入的参数QuestRoleId 【"..tostring(self.QuestRoleId).."】 在QuestRoleInfo表中不存在，请查阅QuestRoleInfo表格"
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "切换角色节点出错：QuestRoleId不存在", Message)
		return 
	end

	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end

	local GameInstance = GWorld.GameInstance
	local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
	if not PlayerCharacter then
		return
	end


	if PlayerCharacter.AvatarQuestRoleID == self.QuestRoleId and PlayerCharacter.AvatarSex == Avatar.Sex then
		return
	end
	
	local GameMode = UE4.UGameplayStatics.GetGameMode(PlayerCharacter)
	if not IsValid(GameMode) then
		return
	end

	GameMode:SwitchToQuestRole(self.QuestRoleId, self.IsPlayFX)
	PlayerCharacter.AvatarSex = Avatar.Sex
	self.Context.CurrentRole = self.QuestRoleId
end

function ChangeRoleNode:OnQuestlineFail()
	-- 在任务失败的时候，回退到初始状态，只回退一次
	if self.Context.RevertRole then
		return
	end

	local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	local GameMode = UE4.UGameplayStatics.GetGameMode(PlayerCharacter)
	if not IsValid(GameMode) then
		return
	end

	GameMode:SwitchToQuestRole(0)

	self.Context.RevertRole = true
	self.Context.CurrentRole = nil
end

return ChangeRoleNode
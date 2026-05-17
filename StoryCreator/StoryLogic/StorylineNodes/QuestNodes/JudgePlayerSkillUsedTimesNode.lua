local JudgePlayerSkillUsedTimesNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode')

function JudgePlayerSkillUsedTimesNode:Execute()
	local GameInstance = GWorld.GameInstance
	local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
	local UsedTimes = PlayerCharacter:GetCountPlayerSkillUsedTimes(self.SkillId) or 0

	local Result = false
	if self.CompareFunc == 0 then
		Result = UsedTimes > self.Times
	elseif self.CompareFunc == 1 then
		Result = UsedTimes < self.Times
	elseif self.CompareFunc == 2 then
		Result = UsedTimes >= self.Times
	elseif self.CompareFunc == 3 then
		Result = UsedTimes <= self.Times
	elseif self.CompareFunc == 4 then
		Result = UsedTimes == self.Times
	elseif self.CompareFunc == 5 then
		Result = UsedTimes ~= self.Times
	end


	local Branch = 'False'
	if Result then
		Branch = 'True'
	end
	return Branch
end

return JudgePlayerSkillUsedTimesNode
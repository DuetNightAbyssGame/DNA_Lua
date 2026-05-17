local AsyncConditionNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

function AsyncConditionNode:Execute(Callback)
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end
	local Res = ConditionUtils.CheckCondition(Avatar, self.ConditionId)
	EventManager:RemoveEvent(EventID.ConditionComplete, self)
	if Res then
		Callback("Success")
	else
		self.Callback = Callback
		EventManager:AddEvent(EventID.ConditionComplete, self, self.ConditionComplete)
	end
end

function AsyncConditionNode:ConditionComplete()
	if not self.Callback then
		return
	end
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end
	local Res = ConditionUtils.CheckCondition(Avatar, self.ConditionId)
	if Res then
		EventManager:RemoveEvent(EventID.ConditionComplete, self)
		self.Callback("Success")
	end
end

function AsyncConditionNode:Clear()
	EventManager:RemoveEvent(EventID.ConditionComplete, self)
end

return AsyncConditionNode

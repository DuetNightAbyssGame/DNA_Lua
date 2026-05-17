local EActorEventType = require 'StoryCreator.StoryLogic.StorylineUtils'.EActorEventType

local ListenActorDestroyNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')


function ListenActorDestroyNode:Init()
	self.StaticCreatorId = 0
	self.DestroyReason = "Default"
end

function ListenActorDestroyNode:Execute(Callback)
	self.Callback = Callback

	DebugPrint("ListenActorDestroyNode: 传入的静态点Id: ", self.StaticCreatorId, " 销毁原因: ", self.DestroyReason)
	GWorld.StoryMgr:BindStaticCreatorActorEvent(self.StaticCreatorId, EActorEventType.OnActorDestroyed, self, self.OnSTLActorDestroyed)
end

function ListenActorDestroyNode:OnSTLActorDestroyed(Info)
	local Actor = Info.Actor
	local DestroyReason = Info.DestroyReason
	DebugPrint("ListenActorDestroyNode: 触发回调，静态点Id:", self.StaticCreatorId, "==", Actor.CreatorId, ", 传入的销毁原因：", EDestroyReason:GetNameByValue(DestroyReason))
	if (self.DestroyReason == "Default") or (self.DestroyReason == "")then
		self.Callback()
	end
	if EDestroyReason:GetNameByValue(DestroyReason) == self.DestroyReason then
		self.Callback()
	end
end

function ListenActorDestroyNode:Clear()
	self.Callback = nil
	GWorld.StoryMgr:UnbindStaticCreatorActorEventByType(self.StaticCreatorId, EActorEventType.OnActorDestroyed)
end

return ListenActorDestroyNode
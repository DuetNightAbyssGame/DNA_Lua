local EActorEventType = require 'StoryCreator.StoryLogic.StorylineUtils'.EActorEventType

local ListenMonsterDeathNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

function ListenMonsterDeathNode:Init()
	self.StaticCreatorId = 0
    self.KillMineRoleEid = 0
    self.KillMineSkillId = 0
    self.DeathReason = "Default"
end

function ListenMonsterDeathNode:Execute(Callback)
	self.Callback = Callback

	DebugPrint("ListenMonsterDeathNode: 传入的静态点Id: ", self.StaticCreatorId, " 造成死亡来源的ActorId：", self.KillMineRoleEid, " 造成死亡来源的SkillId：", self.KillMineSkillId, " 死亡原因：", self.DeathReason)
	GWorld.StoryMgr:BindStaticCreatorActorEvent(self.StaticCreatorId, EActorEventType.OnMonsterDeath, self, self.OnSTLMonsterDeath)
end

function ListenMonsterDeathNode:OnSTLMonsterDeath(Info)
    local MonsterC = Info.MonsterC
	local KillMineRoleEid = Info.KillMineRoleEid
	local KillMineSkillId = Info.KillMineSkillId
	local DeathReason = Info.DeathReason
    DebugPrint("ListenMonsterDeathNode: 触发回调，静态点Id:", self.StaticCreatorId, "==", MonsterC.CreatorId, ", 传入的怪物死亡原因：", EDeathReason:GetNameByValue(DeathReason), 
                ", 造成死亡来源的ActorId：", KillMineRoleEid, ", 造成死亡来源的SkillId：", KillMineSkillId)
    if self.DeathReason == "Default" then
        self.Callback()
		return
    end
    if EDeathReason:GetNameByValue(DeathReason) == self.DeathReason then
		self.Callback()
	end
end

function ListenMonsterDeathNode:Clear()
	self.Callback = nil
	GWorld.StoryMgr:UnbindStaticCreatorActorEventByType(self.StaticCreatorId, EActorEventType.OnMonsterDeath)
end

return ListenMonsterDeathNode
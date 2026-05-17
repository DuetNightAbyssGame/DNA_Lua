--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_AOITriggerBox_SpecialQuest_C
require "UnLua"

local M = Class("BluePrints.Common.Triggers.BP_AOITriggerBox_C")

function M:InitTriggerEventId(Info)
    M.Super.InitTriggerEventId(self, Info)
    local SpecialConfigId = DataMgr.SpecialQuestMechanism2SpecialConfigId[self.CreatorId]
    if not SpecialConfigId then
        return
    end
    -- 对应的任务Id
    self.TriggerQuestId = SpecialConfigId[1]
    -- 对应的提示Id
    self.TriggerTalkId = DataMgr.SpecialQuestConfig[SpecialConfigId[1]].TalkTriggerId or 0
end

function M:SetBoxExtent_Lua(QuestSize, TipsSize)
    M.Super.SetBoxExtent_Lua(self, QuestSize)
    self.TipTrigger.OnComponentBeginOverlap:Add(self, self.TalkBeginOverlap)
    self.TipTrigger.OnComponentEndOverlap:Add(self, self.TalkEndOverlap)
    self.TipTrigger:SetBoxExtent(TipsSize)
end

function M:TalkBeginOverlap(Component, OtherActor)
    print(_G.LogTag,"LXZ TalkBeginOverlap")
    if self:IsActorBeingDestroyed() then
        return
    end
end

function M:TalkEndOverlap(Component, OtherActor)
    print(_G.LogTag,"LXZ TalkEndOverlap", self.TriggerTalkId)
    if self:IsActorBeingDestroyed() then
        return
    end
    if not OtherActor:IsMainPlayer() or self.TriggerTalkId == 0 then
        return
    end
    UE4.UTalkFunctionLibrary.PlayDirectTalkByTalkTriggerId(GWorld.GameInstance, self.TriggerTalkId)
end

function M:CreateTriggerRule(Creator)
    M.Super.CreateTriggerRule(self, Creator)
    --特殊任务要求进入离开都能触发
    self.InOrOutTrigger = "All"
end

function M:OnEMActorDestroy(DestroyReason)
    self.TipTrigger.OnComponentBeginOverlap:Remove(self, self.TalkBeginOverlap)
    self.TipTrigger.OnComponentEndOverlap:Remove(self, self.TalkEndOverlap)
    M.Super.OnEMActorDestroy(self, DestroyReason)
end

-- function M:SetBoxExtent_Lua(QuestSize, TipsSize)
--     self.CollisionComponent:SetBoxExtent(QuestSize)
--     self.TipTrigger:SetBoxExtent(TipsSize)
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return M

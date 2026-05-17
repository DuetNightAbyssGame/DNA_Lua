--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@type BP_Bomu_Base_C
local M = Class("BluePrints.Item.BP_CombatItemBase_C")

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    self.StateId1 = self.UnitParams["StateId1"]
    self.StateId2 = self.UnitParams["StateId2"]
end

function M:OnActorReady(Info)
    M.Super.OnActorReady(self,Info)
    local MainStoryType = self:CheckMainStoryType()
    if MainStoryType == 1 then
        self:ChangeState("Manual", 0, self.StateId1)
    elseif MainStoryType == 2 then
        self:ChangeState("Manual", 0, self.StateId2)
    end
end

function M:CheckMainStoryType()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return nil
    end
    local DoingQuestChainIds = {}
    local DoingQuestIds = nil
    DoingQuestChainIds, DoingQuestIds = Avatar:GetCurrentDoingQuest()
    for i, v in pairs(DoingQuestChainIds) do
        local QuestChainData = DataMgr.QuestChain[v]
        if QuestChainData and QuestChainData.MainStoryType then
            return QuestChainData.MainStoryType
        end
    end
    return nil
end

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
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

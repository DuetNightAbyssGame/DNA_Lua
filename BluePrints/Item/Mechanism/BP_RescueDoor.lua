--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local M = Class("BluePrints.Item.Mechanism.BP_PrologueDoor")

function M:AuthorityInitInfo(Info)
    M.Super.AuthorityInitInfo(self,Info)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then
        return
    end
    self.bIsHostageDoor = false
    self.bSpawnHostage = false
    if self.HostageStaticId == GameMode:GetDungeonComponent().HostageStaticId then
        self.bIsHostageDoor = true
        GameMode:TriggerDungeonComponentFun("SetRescueHostageDoor", self)
    end
end

function M:OpenMechanism(CharacterEid)
    M.Super.OpenMechanism(self,CharacterEid)
    if not IsAuthority(self) and not IsStandAlone(self) then
        return
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode:TriggerDungeonAchieve("OpenRescueDoor", -1)
    if not self.bSpawnHostage then
        GameMode:TriggerDungeonAchieve("SpawnHostage", -1, self.HostageStaticId, self.ManualItemId)
        self.bSpawnHostage = true
    end
    if GameMode:TriggerDungeonComponentFun("GetHostageEid") ~= 0 or not self.bIsHostageDoor then
    	return
    end
    local Character = Battle(self):GetEntity(CharacterEid)
    GameMode:TriggerDungeonComponentFun("TriggerSpawnHostage", Character)
    GameMode:AddDungeonEvent("ShowRescuePanel")
end

function M:TriggerByChild(SourceEid)
    M.Super.TriggerByChild(self, SourceEid)
    if self.bIsHostageDoor then
        self:DeactiveAllGuide()
    else
        self:DeactiveGuide()
    end
end

function M:OnDoorHasOpened(SourceEid)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then
        return
    end
    GameMode:TriggerDungeonComponentFun("TriggerStartHostageBT")
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

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@type BP_RockBlock_C
local BP_RockBlock_C = Class({
    "BluePrints/Item/CombatProp/BP_CombatPropBase_C",
})
-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function BP_RockBlock_C:ReceiveBeginPlay()
--     self:CameraShake()
--     self:PlaySound(self.SoundName)
--     local FXObject = self.FXComponent:PlayFX(self.BronFX,self.Mesh,self:GetCurrentModelInfo().DamageFXSockets[1],self.Crash:K2_GetComponentLocation(),FRotator(0,0,0),true,nil)
-- end

function BP_RockBlock_C:OnActorReady(Info)
    self.Super.OnActorReady(self,Info)
    -- if self.NeedReadyEffect then
        -- self:CameraShake(1)
        -- self:PlaySound(self.SoundName)
        -- local FXObject = self.FXComponent:PlayFX(self.BornFX,self.Mesh,nil,self:K2_GetActorLocation(),FRotator(0,0,0),true,nil)
        -- FXObject:SetRelativeScale3D(self.BornScale)
    -- end
end

function BP_RockBlock_C:UseSkill()
    local Radius = self.UnitParams["SkillRadius"] or 1500
    local EffectId = self.UnitParams["SkillEffect"] or 900010
    local ObjectTypes = TArray(EObjectTypeQuery)
    ObjectTypes:Add(EObjectTypeQuery.Pawn)
    ObjectTypes:Add(EObjectTypeQuery.MonsterPawn)
    local ActorsToIgnore = TArray(AActor)
    ActorsToIgnore:Add(self)
    local OutActors = TArray(AActor)
    local bHit = UE4.UKismetSystemLibrary.SphereOverlapActors(self,self.CrashPoint:K2_GetComponentLocation(),Radius,ObjectTypes,nil,ActorsToIgnore,OutActors)
    for key,value in pairs(OutActors) do
        self.Super.PropUseSkill(self,EffectId,value)
    end
end

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

return BP_RockBlock_C

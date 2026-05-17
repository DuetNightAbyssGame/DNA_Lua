--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_DelayBomb_C = Class({
    "BluePrints/Item/CombatProp/BP_BombBarrel_C",
})

--function BP_DelayBomb_C:Initialize(Initializer)
--end

--function BP_DelayBomb_C:UserConstructionScript()
--end

function BP_DelayBomb_C:CommonInitInfo(Info)
    BP_DelayBomb_C.Super.CommonInitInfo(self, Info)

    self.BombRadius = self.UnitParams["BombRadius"]
    self.BombRisingHeight = self.UnitParams["BombRisingHeight"]
end

function BP_DelayBomb_C:ChangeToBomb()
    if not IsAuthority(self) or IsStandAlone(self) then
        local FXAsset = LoadObject('/Game/Asset/Effect/Niagara/Scene/Common/NS_Scene_Baolie_Explode.NS_Scene_Baolie_Explode')
        local BombLoc = self.Mesh:K2_GetComponentLocation()
        local FXObject = self.FXComponent:PlayEffectByIDParams(self.BombEffectId, {
            UseAbsoluteLocation = true,
            Location = {BombLoc.X,BombLoc.Y,BombLoc.Z},
        })
        if FXObject then
            local Scale = FVector(self.BombRadius/250, self.BombRadius/250, self.BombRadius/250)
            FXObject:SetRelativeScale3D(Scale)
            FXObject:SetNiagaraVariableVec3("Scale", Scale)
        end
    end
    if IsAuthority(self) then
        self:OnBomb()
        self:AddTimer(0.1, function( ... )
            Battle(self):RemoveEntity(self.Eid)
            self:EMActorDestroy(EDestroyReason.MechanismDead)
        end)
    end
end

function BP_DelayBomb_C:OnBomb()
    --self:BluePrintBomb()
    local ObjectTypes = TArray(EObjectTypeQuery)
    ObjectTypes:Add(EObjectTypeQuery.Pawn)
    ObjectTypes:Add(EObjectTypeQuery.MonsterHitedCapsule)
    ObjectTypes:Add(EObjectTypeQuery.BreakableItem)
    local ActorsToIgnore = TArray(AActor)
    ActorsToIgnore:Add(self)
    local OutActors = TArray(AActor)
    local bHit = UE4.UKismetSystemLibrary.SphereOverlapActors(self,self:K2_GetActorLocation(),self.BombRadius,ObjectTypes,nil,ActorsToIgnore,OutActors)
    --print(_G.LogTag,"OnBombOnBombOnBombOnBombOnBomb   "..self.BombRadius)
    for key,value in pairs(OutActors) do
        self.Super.PropAttack(self, value)
    end
end

function BP_DelayBomb_C:OnActorReady(Info)
    BP_DelayBomb_C.Super.OnActorReady(self,Info)
    self:BombReady()
end

return BP_DelayBomb_C

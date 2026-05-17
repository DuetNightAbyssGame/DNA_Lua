require "UnLua"
require "Utils"
require "DataMgr"
require "Const"
local PickupUseComponent = require "BluePrints.Item.Pickups.PickupUseComponent"
local PickupComponent = {}

function PickupComponent:Initialize(Initializer)
    self.EffectsInProcess = {}
    self.DropPlaying = false
end

-- function PickupComponent:ReceiveBeginPlay()
--     self.CapsuleComponent.OnComponentBeginOverlap:Add(self, self.OnBeginOverlap)
--     self.CapsuleComponent.OnComponentEndOverlap:Add(self, self.OnEndOverlap)
-- end

-- function PickupComponent:OnBeginOverlap(OverlappedComponent, OtherActor, OtherComp,OtherBodyIndex, bFromSweep, SweepResult)
--     -- if self.AutoSyncProp.CharacterTag == "Dead" or self:GetLocalRole() == ENetRole.ROLE_SimulatedProxy then
--     --     return
--     -- end
--     -- if OtherActor:Cast(APickupBase) then
--     --     if not OtherActor.InitSuccess or OtherActor.PickType ~= EPickType.Auto then
--     --         return
--     --     end
--     --     if self:IsPhantom() then
--     --         local GetDropData=DataMgr.PhantomGetDrop[OtherActor.UnitId]
--     --         if not GetDropData or not GetDropData.IsCanDrop then
--     --             return
--     --         end
--     --     end
--     --     if OtherActor:CanBePickedUp(self)  then
--     --         if OtherActor.IsShowJumping then
--     --             self:PlayDrop_InCharacter(OtherActor)
--     --         end
--     --         OtherActor:PickupOnTouch(self)
--     --     else
--     --         OtherActor:EndPickFly()
--     --     end
--     -- end
-- end

-- function PickupComponent:OnEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)
--     if self.AutoSyncProp.CharacterTag == "Dead" or self:GetLocalRole() == ENetRole.ROLE_SimulatedProxy then
--         return
--     end
--     -- if OtherActor:Cast(APickupBase) then
--     --     OtherActor.IsSignDead = false
--     --     OtherActor:CloseAutoPickup()
--     -- end
-- end

-- function PickupComponent:PlayDrop_InCharacter(OtherActor)
--     local bNiagaraValid = IsValid(self.Drop_InCharacter)
--     if bNiagaraValid and self.DropPlaying then
--         return 
--     end
--     local function PlayDrop_Inner()
--         self:RemoveTimer("PlayDrop_InnerTimer")
--         self.DropPlaying = false
--     end
--     self:AddTimer(0.2, PlayDrop_Inner, false, 0, "PlayDrop_InnerTimer")

--     if not bNiagaraValid then
--         local FXMgr = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UE4.UFXPriorityManager)
--         local DropAsset = LoadObject('/Game/Asset/Effect/Niagara/Item/NS_Item_Base_Chara.NS_Item_Base_Chara')
--         local Mesh = self:K2_GetRootComponent()
--         self.Drop_InCharacter = FXMgr:SpawnSystemAttached(self:GetOwner(), EFXPriorityType.DropEffect, false, DropAsset, Mesh, "", UE4.FVector(0, 0, 0), UE4.FRotator(0, 0, 0), 0)
--     end
--     local ShowColor = OtherActor:GetEffectColor()
--     if self.Drop_InCharacter then
--         self.Drop_InCharacter:SetNiagaraVariableLinearColor("User.Color", ShowColor)
--         self.Drop_InCharacter:Activate(true)
--         self.DropPlaying = true
--     end
-- end

return PickupComponent

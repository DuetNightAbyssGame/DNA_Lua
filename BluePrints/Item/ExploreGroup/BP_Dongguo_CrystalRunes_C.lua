--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_Dongguo_CrystalRunes_C
require "UnLua"

local M = Class({
    "BluePrints/Item/ExploreGroup/BP_DongGuoBreakableItem_C",
})

function M:OnEnergyZero()
    self.Overridden.OnEnergyZero(self)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local PlayerLoc = Player:K2_GetActorLocation()
    self.bCanMove = true
    self:SetMovementTarget(5, true, PlayerLoc)
    -- local FXObject = Player.FXComponent:PlayEffectByIDParams(FXID, {
    --     UseAbsoluteLocation = true,
    --     Location = {Loc.X,Loc.Y,Loc.Z},
    --     Rotation = {Rot.Pitch, Rot.Yaw, Rot.Roll}
    -- })
    -- if FXObject then
    --     -- self:OnFxObjectCreated(FXObject)
    --     FXObject.OnSystemFinished:Add(self, self.OnFxObjectFinished)
    --     UE4.UNiagaraFunctionLibrary.OverrideSystemUserVariableSkeletalMeshComponent(FXObject,"Skeletal Mesh",self.SkeletalMesh)
    --     FXObject:SetNiagaraVariableVec3("AttarctionPosition",PlayerLoc)
    -- end
end

function M:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
    M.Super.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
    self:EMActorDestroy(EDestroyReason.MechanismDead) 
end

function M:MoveTargetEnd()
    if not self.bCanMove then
        return
    end
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    -- if GameMode then
    --     local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    --     local ExtraInfo = {
    --         UniqueSign = self.Eid,
    --         SourceEid = Player.Eid,
    --         WorldRegionEid = self.WorldRegionEid,
    --         RegionDataType = self.RegionDataType
    --     }
    --     GameMode:TriggerRewardEvent(self.UnitId, CommonConst.RewardReason.Chest, self:GetTransform(), ExtraInfo)
    -- end
    self.Overridden.MoveTargetEnd(self)
    self.bCanMove = false
end

function M:StateCreateReward(PlayerId, NextStateId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        local ExtraInfo = {
            UniqueSign = self.Eid,
            SourceEid = Player.Eid,
            WorldRegionEid = self.WorldRegionEid,
            RegionDataType = self.RegionDataType
        }
        local function CallBack()
            self.CombatStateChangeComponent:TriggerOnEventEnd(NextStateId)
        end
        return GameMode:TriggerRewardEvent(self.UnitId, CommonConst.RewardReason.Chest, self:GetTransform(), ExtraInfo, CallBack)
    end
    return false
end

function M:GetEffectCreature()
    local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
    local EffectList = Player:GetEffectCreatureByTag("Prop")
    if EffectList:Length() > 0 then
        return EffectList:GetRef(1)
    end
    return Player
end

-- function M:ReceiveTick(DeltaSeconds)
--     if self.bCanMove then
--         local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
--         local PlayerLoc = Player:K2_GetActorLocation()
--         self:SetMovementTarget(5, false, PlayerLoc)
--         self:MoveTarget(DeltaSeconds)
--     end
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return M

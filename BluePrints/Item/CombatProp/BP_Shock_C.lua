--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_Shock_C = Class({
    "BluePrints/Item/CombatProp/BP_CombatPropBase_C",
})

--function BP_Shock_C:Initialize(Initializer)
--end

--function BP_Shock_C:UserConstructionScript()
--end

function BP_Shock_C:AuthorityInitInfo(Info)
    BP_Shock_C.Super.AuthorityInitInfo(self,Info)
    self.ActiveRange = self.UnitParams["ActiveRange"]
    self.SkillRange = 0
    --BP_Shock_C.Super.AuthorityInitInfo(self,Info)
end

function BP_Shock_C:CommonInitInfo(Info)
    BP_Shock_C.Super.CommonInitInfo(self,Info)
    self.SkillEffect = self.UnitParams["SkillEffect"]
    self.ShockWidth = self.UnitParams["ShockWidth"]
    self.InCD = false
    self.MaxRadius = self.UnitParams["MaxRadius"]
    self.ShockInterval = self.UnitParams["AttackCD"]
    self.Speed = self.MaxRadius/self.ShockInterval
    self.ShockRange:SetBoxExtent(FVector(self.MaxRadius,self.MaxRadius,10))
    self.SkillRange = 0
end

function BP_Shock_C:SetActiveType()
    self.ActiveType = "Distance"
end

function BP_Shock_C:OnActiveStateChange()
    self.Super.OnActiveStateChange(self)
    if self.IsActive then
        self:PlayActiveMontage()
    else
        self.HitedCDMap:Clear()
        -- self:PlayDeactiveMontage()
    end
    self:PlaySound("event:/sfx/common/scene/laser_gear_open")
end

function BP_Shock_C:ReceiveBeginPlay()
    BP_Shock_C.Super.ReceiveBeginPlay(self)
    self.HitMap = UE4.TMap(AActor, AActor)
    self:DeActiveFX(self.ShockFX)
    --self:DeActiveFX(self.MagicCube_LaserCenter)
end

-- function BP_Shock_C:ReceiveTick(DeltaSeconds)
--     --BP_Shock_C.Super.ReceiveTick(self,DeltaSeconds)
--     if not self.IsStart or not self.InitSuccess then
--         return
--     end
--     self.SkillRange = self.SkillRange+DeltaSeconds*self.Speed
--     if(self.SkillRange >= self.MaxRadius) then
--         self.SkillRange = 0
--     end
--     if(self.SkillRange == 0) then
--         self.HitedArray:Clear()
--         -- self.PlaySound("event:/sfx/common/scene/laser_circle_gear_shoot")
--         -- self.PlaySound("event:/sfx/common/scene/laser_circle_light_loop")
--     end
--     if not IsAuthority(self) or IsStandAlone(self) then
--         self.LaserCenter = self.Mesh:GetSocketLocation("Center")
--     end
--     self:LaunchShock()
-- end

function BP_Shock_C:ChangeCD()
    self.InCD = false
end

-- function BP_Shock_C:LaunchShock()
--     -- print(_G.LogTag,"LaunchShock",  self.HitMap:Length())
--     for key,value in pairs(self.HitMap) do
--         if IsValid(value) then
--             local Distance = (self:K2_GetActorLocation()-value:K2_GetActorLocation()):Size()
--             if(Distance>=self.SkillRange-self.ShockWidth and Distance<=self.SkillRange+self.ShockWidth) and not self.HitedArray:Contains(value.Eid) then
--                 self:PlaySound("event:/sfx/common/scene/laser_hit")
--                 self.Super.PropUseSkill(self,self.SkillEffect,value)
--                 self.HitedArray:Add(value.Eid)
--             end
--         else
--             self.HitMap:Remove(key)
--         end
--     end
-- end

function BP_Shock_C:AddHitMap(Actor)
    if not IsAuthority(self) then
        return
    end
    if Actor.Eid and Actor.Eid == self.Eid then
        return
    end
    self.HitMap:Add(Actor.Eid,Actor.Eid)
end

function BP_Shock_C:RemoveHitMap(Actor)
    if not IsAuthority(self) then
        return
    end
    self.HitMap:Remove(Actor.Eid)
end

function BP_Shock_C:ShowDeath()
    self:RemoveTimer("DistanceDeActiveTimer")
    self:DeActiveFX(self.ShockFX)
    self:PlayDeadMontage()
    self:PlaySound("event:/sfx/common/scene/laser_gear_break")
    BP_Shock_C.Super.ShowDeath(self)
end

function BP_Shock_C:DeActive()
    BP_Shock_C.Super.DeActive(self)
    self.SkillRange = 0
    if not IsAuthority(self) or IsStandAlone(self) then
        self:DeActiveFX(self.ShockFX)
    end
    self:PlayDeactiveMontage()
end

--function BP_Shock_C:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function BP_Shock_C:ReceiveActorBeginOverlap(OtherActor)
--end

--function BP_Shock_C:ReceiveActorEndOverlap(OtherActor)
--end

return BP_Shock_C

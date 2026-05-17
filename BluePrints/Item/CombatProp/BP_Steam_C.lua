--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_CombatProp_Steam_C
local BP_Steam_C = Class({
    "BluePrints/Item/CombatProp/BP_CombatPropBase_C",
})

BP_Steam_C.HitedArray = {}

function BP_Steam_C:CommonInitInfo(Info)
    self.SkillEffect = self.UnitParams["SkillEffect"]
    self.GasNum = self.UnitParams["GasNum"]
    self.GasLength = self.UnitParams["GasLength"]
    self.GasHeight = self.UnitParams["GasHeight"]
    self.RotateSpeed = self.UnitParams["RotateSpeed"]
    self.FRotateSpeed = FRotator(0, self.UnitParams["RotateSpeed"] / 180 * 3.14, 0)
    self.AttackCD = self.UnitParams["AttackCD"]
    self.WarningTime = self.UnitParams["WarningTime"] or 2
    self.CurWarningTime = 0
    self.IsWarning = false
    -- self.HitedArray = {}
    -- self:ShowSteamEffect()
    self.ActorsToIgnore = TArray(AActor)
    self.HitResult = FHitResult()
    self.ActorsToIgnore:Add(self)
    self.Color1 = UE4.FLinearColor(1, 0, 0, 1)
    self.Color2 = UE4.FLinearColor(0, 1, 0, 1)
    BP_Steam_C.Super.CommonInitInfo(self,Info)

    self.RotateMesh = self.Mesh
    self.MeshRelativeRotation = self.Mesh.RelativeRotation
    self.CapsuleRadius = self.Capsule:GetUnscaledCapsuleRadius()
end

-- function BP_Steam_C:ShowSteamEffect()
--     if self.IsShowSteamEffect == true then
--         return
--     end
--     self.IsShowSteamEffect = true
--     -- if self.Box0 then self.Box0:SetHiddenInGame(true) end
--     -- if self.NS_Steam0 then self.NS_Steam0:SetHiddenInGame(false) end
--     -- if self.Box90 then self.Box90:SetHiddenInGame(true) end
--     -- if self.NS_Steam90 then self.NS_Steam90:SetHiddenInGame(self.GasNum ~= 4) end
--     -- if self.Box180 then self.Box180:SetHiddenInGame(true) end
--     -- if self.NS_Steam180 then self.NS_Steam180:SetHiddenInGame(self.GasNum ~= 2 and self.GasNum ~= 4) end
--     -- if self.Box270 then self.Box270:SetHiddenInGame(true) end
--     -- if self.NS_Steam270 then self.NS_Steam270:SetHiddenInGame(self.GasNum ~= 4) end
--     -- if self.Box120 then self.Box120:SetHiddenInGame(true) end
--     -- if self.NS_Steam120 then self.NS_Steam120:SetHiddenInGame(self.GasNum ~= 3) end
--     -- if self.Box240 then self.Box240:SetHiddenInGame(true) end
--     -- if self.NS_Steam240 then self.NS_Steam240:SetHiddenInGame(self.GasNum ~= 3) end

--     self:ShowNS(0)
--     print(_G.LogTag,"LXZ ShowSteamEffect", self.GasNum)
--     if self.GasNum == 4 then
--         self:ShowNS(90)
--     end
--     if self.GasNum == 2 or self.GasNum == 4 then
--         self:ShowNS(180)
--     end
--     if self.GasNum == 4 then
--         self:ShowNS(270)
--     end
--     if self.GasNum == 3 then
--         self:ShowNS(120)
--     end
--     if self.GasNum == 3 then
--         self:ShowNS(240)
--     end
-- end

-- function BP_Steam_C:HideSteamEffect()
--     if self.IsShowSteamEffect == false then
--         return
--     end
--     self.IsShowSteamEffect = false
--     -- if self.Box0 then self.Box0:SetHiddenInGame(true) end
--     -- if self.NS_Steam0 then self.NS_Steam0:SetHiddenInGame(true) end
--     -- if self.Box90 then self.Box90:SetHiddenInGame(true) end
--     -- if self.NS_Steam90 then self.NS_Steam90:SetHiddenInGame(true) end
--     -- if self.Box180 then self.Box180:SetHiddenInGame(true) end
--     -- if self.NS_Steam180 then self.NS_Steam180:SetHiddenInGame(true) end
--     -- if self.Box270 then self.Box270:SetHiddenInGame(true) end
--     -- if self.NS_Steam270 then self.NS_Steam270:SetHiddenInGame(true) end
--     -- if self.Box120 then self.Box120:SetHiddenInGame(true) end
--     -- if self.NS_Steam120 then self.NS_Steam120:SetHiddenInGame(true) end
--     -- if self.Box240 then self.Box240:SetHiddenInGame(true) end
--     -- if self.NS_Steam240 then self.NS_Steam240:SetHiddenInGame(true) end

--     self:HideNS(0)
--     if self.GasNum == 4 then
--         self:HideNS(90)
--     end
--     if self.GasNum == 2 or self.GasNum == 4 then
--         self:HideNS(180)
--     end
--     if self.GasNum == 4 then
--         self:HideNS(270)
--     end
--     if self.GasNum == 3 then
--         self:HideNS(120)
--     end
--     if self.GasNum == 3 then
--         self:HideNS(240)
--     end
-- end

-- function BP_Steam_C:UpdateHitedArray(DeltaSeconds)
--     for i,v in pairs(self.HitedArray) do
--         self.HitedArray[i] = v + DeltaSeconds
--         if self.HitedArray[i] >= self.AttackCD then
--             self.HitedArray[i] = nil
--         end
--     end
-- end

-- function BP_Steam_C:ReceiveTick(DeltaSeconds)
--     self.IsPreInSound = self.IsInSound
--     self.IsInSound = false
--     self:UpdateHitedArray(DeltaSeconds)
--     if self.IsActive then

--         if self.IsWarning then
--             self.CurWarningTime = self.CurWarningTime + DeltaSeconds
--              if self.CurWarningTime > self.WarningTime then
--                 self.IsWarning = false
--             end
--         end

--         if self.RotateSpeed ~= nil and self.RotateSpeed ~= 0 then
--             self.Mesh:K2_AddLocalRotation(self.FRotateSpeed, false, nil, false)
--         end
--         if self.IsWarning then
--             return
--         end
--         local GameState = UE4.UGameplayStatics.GetGameState(self)
--         if GameState ~= nil and GameState.MonsterMap ~= nil then
--             for _, Monster in pairs(GameState.MonsterMap) do
--                 if IsValid(Monster) and Monster:IsRealMonster() then
--                     self:CharacterInSteam(Monster)
--                 end
--             end
--         end
--         local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--         if GameMode ~= nil and GameMode.GetAllPlayer ~= nil then
--             local AllPlayer = GameMode:GetAllPlayer()
--             if AllPlayer:Num() > 0 then
--                 for _, Player in pairs(AllPlayer) do
--                     self:CharacterInSteam(Player)
--                 end
--             end
--         end

--     end
--     self:PlaySoundInOut()
-- end

-- function BP_Steam_C:CharacterInSteam(Player)
--     if IsValid(Player) == false then
--         return
--     end
--     -- local SelfLocation = self:K2_GetActorLocation()
--     local SelfLoc = self:K2_GetActorLocation()
--     local SelfTrans = self:GetTransform()
--     local Up = self:GetActorUpVector()
--     local PlayerTrans = Player:GetTransform()
--     local PlayerHeadTrans = FTransform()
--     PlayerHeadTrans.Translation = PlayerTrans.Translation + FVector(0, 0, Player.CapsuleComponent:GetScaledCapsuleHalfHeight())
--     PlayerHeadTrans.Rotation = PlayerTrans.Rotation
--     PlayerHeadTrans.Scale3D = PlayerTrans.Scale3D
--     local PlayerFootTrans = FTransform()
--     PlayerFootTrans.Translation = PlayerTrans.Translation - FVector(0, 0, Player.CapsuleComponent:GetScaledCapsuleHalfHeight())
--     PlayerFootTrans.Rotation = PlayerTrans.Rotation
--     PlayerFootTrans.Scale3D = PlayerTrans.Scale3D
--     local RelateTrans = UE4.UKismetMathLibrary.MakeRelativeTransform(PlayerTrans, SelfTrans)
--     local RelateHeadTrans = UE4.UKismetMathLibrary.MakeRelativeTransform(PlayerHeadTrans, SelfTrans)
--     local RelateFootTrans = UE4.UKismetMathLibrary.MakeRelativeTransform(PlayerFootTrans, SelfTrans)
--     local RelatePos, RelateRot=UE4.UKismetMathLibrary.BreakTransform(RelateTrans)
--     local RelateHeadPos, RelateHeadRot=UE4.UKismetMathLibrary.BreakTransform(RelateHeadTrans)
--     local RelateFootPos, RelateFootRot=UE4.UKismetMathLibrary.BreakTransform(RelateFootTrans)
--     -- DebugPrint("====================================RelatePos:", RelatePos, "RelateRot:",RelateRot)
--     local RelateDistance2D = RelatePos:Size2D()
--     local RelateHeadDistance2D = RelateHeadPos:Size2D()
--     local RelateFootDistance2D = RelateFootPos:Size2D()
--     local RelateDistanceZ = math.abs(RelatePos.Z)
--     local RelateHeadDistanceZ = math.abs(RelateHeadPos.Z)
--     local RelateFootDistanceZ = math.abs(RelateFootPos.Z)
--     if (RelateDistance2D < self.GasLength and RelateDistanceZ < self.GasHeight / 2)
--     or (RelateHeadDistance2D < self.GasLength and RelateHeadDistanceZ < self.GasHeight / 2)
--     or (RelateFootDistance2D < self.GasLength and RelateFootDistanceZ < self.GasHeight / 2) then
--         local Sin = RelatePos.Y / RelateDistance2D
--         local SinHead = RelateHeadPos.Y / RelateHeadDistance2D
--         local SinFoot = RelateFootPos.Y / RelateFootDistance2D
--         local RerlateDegree = UE.UKismetMathLibrary.DegAsin(Sin)
--         local RerlateHeadDegree = UE.UKismetMathLibrary.DegAsin(SinHead)
--         local RerlateFootDegree = UE.UKismetMathLibrary.DegAsin(SinFoot)
--         if RelatePos.X < 0 then
--             if RerlateDegree > 0 then
--                 RerlateDegree = 180 - RerlateDegree
--             else
--                 RerlateDegree = -180 - RerlateDegree
--             end
--         end
--         if RelateHeadPos.X < 0 then
--             if RerlateHeadDegree > 0 then
--                 RerlateHeadDegree = 180 - RerlateHeadDegree
--             else
--                 RerlateHeadDegree = -180 - RerlateHeadDegree
--             end
--         end
--         if RelateFootPos.X < 0 then
--             if RerlateFootDegree > 0 then
--                 RerlateFootDegree = 180 - RerlateFootDegree
--             else
--                 RerlateFootDegree = -180 - RerlateFootDegree
--             end
--         end
--         -- DebugPrint("====================================RerlateDegree:", RerlateDegree,"Rotate:",self.Mesh.RelativeRotation.Yaw)
--         local Offset = math.abs(self.Mesh.RelativeRotation.Yaw - RerlateDegree)
--         local OffsetHead = math.abs(self.Mesh.RelativeRotation.Yaw - RerlateHeadDegree)
--         local OffsetFoot = math.abs(self.Mesh.RelativeRotation.Yaw - RerlateFootDegree)
--         Offset = Offset % 360
--         OffsetHead = OffsetHead % 360
--         OffsetFoot = OffsetFoot % 360
--         local PlayerLoc = Player:K2_GetActorLocation()
--         local Radius = self.Capsule:GetUnscaledCapsuleRadius()
--         -- DebugPrint("===================================================Offset:",Offset)
--         local stepAngle = 360 / self.GasNum
--         for i = 0, self.GasNum/2 do
--             local HitOffset = stepAngle * i
--             if math.abs(HitOffset - Offset) < 6 or math.abs(HitOffset - OffsetHead) < 6 or math.abs(HitOffset - OffsetFoot) < 6 then
--                 --  DebugPrint("===================================================Hit:",HitOffset)
--                  if Player:IsDead() ~= true and not self.HitedArray[Player.Eid] then
--                     local PlayerHalfHeight = Player.CapsuleComponent:GetScaledCapsuleHalfHeight()
--                     local PlayerLoc1 = FVector(PlayerLoc.X, PlayerLoc.Y, PlayerLoc.Z - PlayerHalfHeight)
--                     local SelfLoc1 = SelfLoc + Up * (RelatePos.Z - PlayerHalfHeight)
--                     local Dir1 = PlayerLoc1 - SelfLoc1
--                     Dir1:Normalize()
--                     local PlayerLoc2 = FVector(PlayerLoc.X, PlayerLoc.Y, PlayerLoc.Z + PlayerHalfHeight)
--                     local SelfLoc2 = SelfLoc + Up * (RelatePos.Z + PlayerHalfHeight)
--                     local Dir2 = PlayerLoc2 - SelfLoc2
--                     Dir2:Normalize()
--                     local bHit1 = UE4.UKismetSystemLibrary.LineTraceSingle(self, SelfLoc1 + Dir1 * Radius, PlayerLoc1, ETraceTypeQuery.TraceScene, false, self.ActorsToIgnore, 0, self.HitResult, true, self.Color1, self.Color2)
--                     local bHit2 = UE4.UKismetSystemLibrary.LineTraceSingle(self, SelfLoc2 + Dir2 * Radius, PlayerLoc2, ETraceTypeQuery.TraceScene, false, self.ActorsToIgnore, 0, self.HitResult, true, self.Color1, self.Color2)
--                     if bHit1 == false or bHit2 == false then
--                         self.HitedArray[Player.Eid] = 0
--                         -- self:PlaySound("event:/sfx/common/scene/laser_hit")
--                         self.Super.PropAttack(self, Player)
--                     end
--                 end
--             end
--         end
--     end

--     if RelateDistance2D < self.GasLength + 500 and RelateDistanceZ < self.GasHeight / 2 then
--         local Sin = RelatePos.Y / RelateDistance2D
--         local RerlateDegree = UE.UKismetMathLibrary.DegAsin(Sin)
--         if RelatePos.X < 0 then
--             if RerlateDegree > 0 then
--                 RerlateDegree = 180 - RerlateDegree
--             else
--                 RerlateDegree = -180 - RerlateDegree
--             end
--         end
--         -- DebugPrint("====================================RerlateDegree:", RerlateDegree,"Rotate:",self.Mesh.RelativeRotation.Yaw)
--         local Offset = math.abs(self.Mesh.RelativeRotation.Yaw - RerlateDegree)
--         Offset = Offset % 360
--         local PlayerLoc = Player:K2_GetActorLocation()
--         local Radius = self.Capsule:GetUnscaledCapsuleRadius()
--         -- DebugPrint("===================================================Offset:",Offset)
--         local stepAngle = 360 / self.GasNum
--         for i = 0, self.GasNum/2 do
--             local HitOffset = stepAngle * i
--             if math.abs(HitOffset - Offset) < 26 then
--                 self.IsInSound = true
--             end
--         end
--     end

--     -- local PlayerLocation = Player:K2_GetActorLocation()
--     -- local PlayerLoc = Player:K2_GetActorLocation()
--     -- local Distance2D = UE4.UKismetMathLibrary.Vector_Distance2D(PlayerLocation, SelfLocation)
--     -- local DistanceZ = math.abs(PlayerLocation.Z - SelfLocation.Z)
--     -- if Distance2D < self.GasLength and DistanceZ < self.GasHeight / 2 then
--     --     PlayerLocation.Z = 0
--     --     SelfLocation.Z = 0
--     --     local Dir = PlayerLocation - SelfLocation
--     --     local Forward = self:GetActorForwardVector()
--     --     Forward.Z = 0
--     --     Dir:Normalize()
--     --     Forward:Normalize()
--     --     local Angle = Dir:Dot(Forward)
--     --     local Cross = Dir:Cross(Forward)
--     --     local Degree = UE.UKismetMathLibrary.DegAcos(Angle)
--     --     local OnRight = Cross.Z < 0
--     --     if OnRight == false then
--     --         Degree = - Degree
--     --     end

--     --     -- DebugPrint("===================================================SelfLocation:",SelfLocation)
--     --     -- DebugPrint("===================================================PlayerLocation:",PlayerLocation)
--     --     -- DebugPrint("===================================================Degree:",Degree)
--     --     -- DebugPrint("===================================================Rotate:",self.Mesh.RelativeRotation.Yaw)
--     --     -- DebugPrint("===================================================OnRight:",OnRight)
--     --     local Offset = math.abs(self.Mesh.RelativeRotation.Yaw - Degree)
--     --     Offset = Offset % 360
--     --     -- DebugPrint("===================================================Offset:",Offset)
--     --     local stepAngle = 360 / self.GasNum
--     --     for i = 0, self.GasNum/2 do
--     --         local HitOffset = stepAngle * i
--     --         if math.abs(HitOffset - Offset) < 2 then
--     --             --  DebugPrint("===================================================Hit:",HitOffset)
--     --              if Player:IsDead() ~= true and not self.HitedArray[Player.Eid] then
--     --                 local PlayerHalfHeight = Player.CapsuleComponent:GetScaledCapsuleHalfHeight()
--     --                 local SelfLoc1 = FVector(SelfLoc.X, SelfLoc.Y, PlayerLoc.Z - PlayerHalfHeight)
--     --                 local PlayerLoc1 = FVector(PlayerLoc.X, PlayerLoc.Y, PlayerLoc.Z - PlayerHalfHeight)
--     --                 local SelfLoc2 = FVector(SelfLoc.X, SelfLoc.Y, PlayerLoc.Z + PlayerHalfHeight)
--     --                 local PlayerLoc2 = FVector(PlayerLoc.X, PlayerLoc.Y, PlayerLoc.Z + PlayerHalfHeight)
--     --                 local bHit1 = UE4.UKismetSystemLibrary.LineTraceSingle(self, SelfLoc1, PlayerLoc1, ETraceTypeQuery.TraceScene, false, self.ActorsToIgnore, 0, self.HitResult, true, self.Color1, self.Color2)
--     --                 local bHit2 = UE4.UKismetSystemLibrary.LineTraceSingle(self, SelfLoc2, PlayerLoc2, ETraceTypeQuery.TraceScene, false, self.ActorsToIgnore, 0, self.HitResult, true, self.Color1, self.Color2)
--     --                 if bHit1 == false or bHit2 == false then
--     --                     self.HitedArray[Player.Eid] = 0
--     --                     -- self:PlaySound("event:/sfx/common/scene/laser_hit")
--     --                     self.PropUseSkill(self,self.SkillEffect,Player)
--     --                 end
--     --             end
--     --         end
--     --     end
--     -- end
-- end

-- function BP_Steam_C:PlaySoundInOut()
--     if self.IsPreInSound ~= true and self.IsInSound == true then
--         self:SoundIn()
--     elseif self.IsPreInSound == true and self.IsInSound ~= true then
--         self:SoundOut()
--     end
-- end

function BP_Steam_C:ActiveOnServer()
    self:ShowSteamEffect()
    self:StartWarning()
end

function BP_Steam_C:StartWarning()
    self.IsWarning = true
    self.CurWarningTime = 0
end

function BP_Steam_C:DeActive()
    self:HideSteamEffect()
end

return BP_Steam_C

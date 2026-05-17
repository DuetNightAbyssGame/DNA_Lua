-- 是 BP_CharacterBase_C.lua 的 Component 所以 Player Monster NPC 都会有这个 Component 的逻辑

require "UnLua"

local Component = {}

-- function Component:BeforeEnableCheckOverlapPush(bNeedStopBT)
--     self.BeforeCheckOverlapGravityScale = nil
--     self.BeforeCheckOverlapHitCapsuleCollisionType = nil
--     self.BeforeCheckOverlapBlockPlayerCollisionType = nil

--     self:SetActorHideTag("CheckOverlap", true)

--     -- 存了之前的GravityScale(非0的)
--     if self:GetMovementComponent().GravityScale ~= 0 then
--         self.BeforeCheckOverlapGravityScale = self:GetMovementComponent().GravityScale
--         self:GetMovementComponent().GravityScale = 0
--     end

--     -- MonsterHitedCapsule MonsterBlockPlayer 存了之前的碰撞预设(非NoCollision的)
--     if self.MonsterHitedCapsule and self.MonsterHitedCapsule:GetCollisionEnabled() ~= ECollisionEnabled.NoCollision then
--         self.BeforeCheckOverlapHitCapsuleCollisionType = self.MonsterHitedCapsule:GetCollisionEnabled()
--         self.MonsterHitedCapsule:SetCollisionEnabled(ECollisionEnabled.NoCollision)
--     end
--     if self.MonsterBlockPlayer and self.MonsterBlockPlayer:GetCollisionEnabled() ~= ECollisionEnabled.NoCollision then
--         self.BeforeCheckOverlapBlockPlayerCollisionType = self.MonsterBlockPlayer:GetCollisionEnabled()
--         self.MonsterBlockPlayer:SetCollisionEnabled(ECollisionEnabled.NoCollision)
--     end
--     self:GetMovementComponent().Velocity = FVector(0,0,0)

--     -- 根据参数决定是否 StopBT
--     if bNeedStopBT and self:IsAIControlled() then
--         self:StopBT("CheckOverlap")
--     end
-- end

-- function Component:AfterEnableCheckOverlapPush(bNeedStartBT)
--     self:SetActorHideTag("CheckOverlap", false)

--     if self.BeforeCheckOverlapGravityScale then
--         self:GetMovementComponent().GravityScale = self.BeforeCheckOverlapGravityScale
--     end
--     if self.BeforeCheckOverlapHitCapsuleCollisionType then
--         self.MonsterHitedCapsule:SetCollisionEnabled(self.BeforeCheckOverlapHitCapsuleCollisionType)
--     end
--     if self.BeforeCheckOverlapBlockPlayerCollisionType then
--         self.MonsterBlockPlayer:SetCollisionEnabled(self.BeforeCheckOverlapBlockPlayerCollisionType)
--     end

--     if bNeedStartBT and self:IsAIControlled() then
--         self:ReStartBT()
--     end
-- end

-- 在 CharacterBase.cpp 中声明
-- function Component:EnableCheckOverlapPush_CPP(bNeedStopBT, bNeedStartBT, bNeedHideAndNoCollision)
--     if bNeedHideAndNoCollision then
--         return self:EnableCheckOverlapPush_HideAndNoCollision(nil, bNeedStopBT, bNeedStartBT)
--     else
--         return self:EnableCheckOverlapPush(nil)
--     end
-- end

-- 会隐藏角色，胶囊体不可碰撞，行为树根据参数选择停止或不停止 的检查重叠 + 推怪
-- function Component:EnableCheckOverlapPush_HideAndNoCollision(callback, bNeedStopBT, bNeedStartBT)
--     local function AfterEnableCheckOverlapPush()
--         self:AfterEnableCheckOverlapPush(bNeedStartBT)
--     end
--     table.insert(self.OverlapPushCallback, AfterEnableCheckOverlapPush)
--     self:BeforeEnableCheckOverlapPush(bNeedStopBT)
--     if not self:EnableCheckOverlapPush(callback) then
--         self:AfterEnableCheckOverlapPush(bNeedStartBT)
--         self.OverlapPushCallback = {}
--         return false
--     end
--     return true
-- end

-- 单纯的推怪,对显隐和胶囊体碰撞不进行任何操作
-- function Component:EnableCheckOverlapPush(callback)
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     if GameMode and not GameMode.bEnableMonsterCollisionPush then
--         return false
--     end

--     self.bCheckOverlapPush = true
--     table.insert(self.OverlapPushCallback, callback)
--     if self:IsExistTimer("CheckOverlapPushTimer") then
--         self:RemoveTimer("CheckOverlapPushTimer")
--     end
--     self:AddTimer(0.05, self.CheckOverlapPushTickTimer, true, 0, "CheckOverlapPushTimer")

--     return true
-- end

-- function Component:CheckOverlapPushTickTimer()
--     local CapsulePos = self:K2_GetActorLocation()
--     local Radius = self.CapsuleComponent:GetScaledCapsuleRadius()
--     local HalfHeight = self.CapsuleComponent:GetScaledCapsuleHalfHeight()
--     local ObjectTypes = TArray(EObjectTypeQuery)
--     ObjectTypes:Add(EObjectTypeQuery.Pawn)
--     ObjectTypes:Add(EObjectTypeQuery.MonsterPawn)
--     local ActorsToIgnore = self:GetAttachedActors()
--     ActorsToIgnore:Add(self)
--     local OutActors = TArray(AActor)

--     local bHit = UE4.UKismetSystemLibrary.CapsuleOverlapActors(self, CapsulePos, Radius, HalfHeight, ObjectTypes, nil, ActorsToIgnore, OutActors)
--     if not bHit then
--         if #self.OverlapPushCallback > 0 then
--             for _, cb_func in pairs(self.OverlapPushCallback) do
--                 cb_func()
--             end
--         end
--         -- self.EnableCheckOverlapPushEndDelegate:Broadcast()
--         self.bCheckOverlapPush = false
--         self.OverlapPushCallback = {}
--         self:RemoveTimer("CheckOverlapPushTimer")
--         if self:GetMovementComponent() and not IsDedicatedServer(self) then
--             self:GetMovementComponent().bAdjustPenetratWhileFalling = true
--         end
--         return
--     end

--     for _, Target in pairs(OutActors) do
--         if not UE4.UKismetMathLibrary.ClassIsChildOf(Target:GetClass(), ACharacterBase:StaticClass()) then
--             goto continue
--         end

--         if not Target.BattleCharInfo then
--             goto continue
--         end

--         local SelfCollisionLevel = self.InitSuccess and self:GetAttr("CollisionLevel") or self.BattleCharInfo["CollisionLevel"] or 0
--         local TargetCollisionLevel = Target.InitSuccess and Target:GetAttr("CollisionLevel") or Target.BattleCharInfo["CollisionLevel"] or 0
--         local CanNotBePush = Target.BattleCharInfo and Target.BattleCharInfo.CannotBePushed == 1
--         local bCanPushTarget = (not CanNotBePush) and self:CheckTargetCanBePushed(Target)

--         local PushDir, PushEnt
--         if SelfCollisionLevel < TargetCollisionLevel or not bCanPushTarget then
--             -- Push self
--             PushDir = self:K2_GetActorLocation() - Target:K2_GetActorLocation()
--             PushEnt = self
--         else
--             -- Push Other
--             PushDir = Target:K2_GetActorLocation() - self:K2_GetActorLocation()
--             PushEnt = Target
--         end

--         PushDir.Z = 0
--         if PushDir:Size() < 0.005 then
--             PushDir = FVector(math.random(), math.random(), 0)
--         end
--         PushDir:Normalize()
--         local PushVelocity = PushDir * Const.MonsterOverlapPushVelocity
--         self:DirectPush(PushEnt, PushVelocity)

--         ::continue::
--     end
-- end

-- function Component:DirectPush(Target, TargetVelocity)
--     if Target.InitSuccess and not Target:IsSummonMonster() then
--         Target.bBePushed = true
--         Target:GetMovementComponent().bSkipLaunchSetFalling = true
--         if Target:IsMonster() then
--             Target:GetMovementComponent():ClearAvoidanceLockTimer()
--         end
--         Target:LaunchCharacter(TargetVelocity, true, true)
--     else
--         local TmpLoc = TargetVelocity * UE4.UGameplayStatics.GetWorldDeltaSeconds(self)
--         Target:K2_SetActorLocation(Target:K2_GetActorLocation() + TmpLoc, false, nil, false)
--     end
-- end

-- function Component:CheckTargetCanBePushed(Target)
--     if not Target then
--         return true
--     end

--     return Target:GetAttachParentActor() == nil
-- end

return Component
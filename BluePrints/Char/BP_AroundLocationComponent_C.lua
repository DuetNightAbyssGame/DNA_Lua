--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_AroundLocationComponent_C = Class()

function BP_AroundLocationComponent_C:AIGetTargetActor(Source, ClockWise)
    -- 废弃, 调用GetTargetActorCrossJump
    return nil
end

function BP_AroundLocationComponent_C:AIReleaseTargetActor(Actor)
    -- 废弃, 调用ReleaseTargetActor
end

-- function BP_AroundLocationComponent_C:GetTargetActorCrossJump(Source, ActorMaxNumber, ActorDis, JumpCount, ActorIndex)
--     -- 怪物TeamMove脱离队伍时，通过遍历查一个合适的AroundActor
--     if self.LocationActorNumber <= 0 then
--         return 0, -1, nil
--     end
    
--     if Source == nil then 
--         return 0, -1, nil 
--     end

--     self:EnableActorActive(true)

--     local function IsLocationActorFreeAndValid(TmpActor, Index)
--         if self.ActorNavValidArray[Index] == false then
--             return false
--         end
--         local MonsterEid = self.LocationActorMap:Find(TmpActor)
--         if MonsterEid == nil then return false end
--         if MonsterEid == Source.Eid then return true end
--         if (MonsterEid == 0) or (MonsterEid > 0 and Battle(self):GetEntity(MonsterEid) == nil) then
--             self.LocationActorMap:Add(TmpActor, Source.Eid)
--             if ActorDis > 0 then self:ResetLocationOffset(Index, ActorDis) end
--             return true
--         end
--         return false
--     end

--     local IndexStep = ActorMaxNumber <= 4 and 2 or 1
--     local Index = self:CalculateIndex(Source:K2_GetActorLocation(),self:GetOwner():K2_GetActorLocation(), IndexStep)
--     local TmpActor = self.LocationActorMap:Keys():GetRef(Index)

--     if IsLocationActorFreeAndValid(TmpActor, Index) then return 0, Index-1, TmpActor end

--     local tmpJumpCnt = 1
--     while(tmpJumpCnt < (self.LocationActorNumber/2 + 1)) do
--         local i = Index + tmpJumpCnt
--         JumpCount = tmpJumpCnt * -1
--         if i > self.LocationActorNumber then
--             i = i - self.LocationActorNumber
--         end
--         TmpActor = self.LocationActorMap:Keys():GetRef(i)
--         if IsLocationActorFreeAndValid(TmpActor, i) then return JumpCount, i-1, TmpActor end     
        
--         i = Index - tmpJumpCnt
--         JumpCount = tmpJumpCnt
--         if i <= 0 then
--             i = i + self.LocationActorNumber
--         end
--         TmpActor = self.LocationActorMap:Keys():GetRef(i)
--         if IsLocationActorFreeAndValid(TmpActor, i) then return JumpCount, i-1, TmpActor end

--         tmpJumpCnt = tmpJumpCnt + 1
--     end
    
--     self:EnableActorActive(false)
--     return 0, -1, nil
-- end

-- function BP_AroundLocationComponent_C:GetNearstTargetActorByCloseMove(Source, ActorMaxNumber, ActorDis, ActorIndex)
--     -- 怪物TeamMove在脱离队伍后，追玩家过程中，以一定频率查最近的点，如果这个点有其他怪离得更近，则循环查
--     -- 如果这个点符合离得最近条件，但是寻路不可达，则直接走向玩家，否则，走向新的点
--     -- 如果发生点抢占的情况，还需通知被抢的怪重新找点
--     if self.LocationActorNumber <= 0 then
--         return -1, nil
--     end
    
--     if Source == nil then 
--         return -1, nil
--     end

--     self:EnableActorActive(true)

--     local function TryGetValidActor(TmpActor, Index)
--         local bIsNearst = false
--         local MonsterEid = self.LocationActorMap:Find(TmpActor)
--         if (MonsterEid == nil or MonsterEid == Source.Eid) then bIsNearst = true end
--         local MonsterEnt = Battle(self):GetEntity(MonsterEid)

--         if bIsNearst == false then
--             if MonsterEnt == nil then
--                 -- 占空点
--                 bIsNearst = true
--             else
--                 -- 尝试抢点
--                 local MLoc = MonsterEnt:K2_GetActorLocation()
--                 local SLoc = Source:K2_GetActorLocation()
--                 local ALoc = TmpActor:K2_GetActorLocation()
--                 local M2A = UE4.UKismetMathLibrary.Vector_Distance(MLoc, ALoc)
--                 local S2A = UE4.UKismetMathLibrary.Vector_Distance(SLoc, ALoc)
--                 bIsNearst = S2A < M2A
--             end
--         end

--         if bIsNearst then
--             if self.ActorNavValidArray[Index] then
--                 if MonsterEnt~=nil and MonsterEnt.Eid ~= Source.Eid then
--                     -- 抢点，通知旧怪重新算点
--                     if MonsterEnt:GetMonMoveComp() then
--                         MonsterEnt:GetMonMoveComp().MoveTeamData.bChangeCloseActor = true
--                     end
--                 end
--                 self.LocationActorMap:Add(TmpActor, Source.Eid)
--                 if ActorDis > 0 then
--                     self:ResetLocationOffset(Index, ActorDis)
--                 end
--                 return true, true
--             end
--             return true, false
--         end
--         return false, false
--     end

--     -- 最近点
--     local IndexStep = ActorMaxNumber <= 4 and 2 or 1
--     local Index = self:CalculateIndex(Source:K2_GetActorLocation(), self:GetOwner():K2_GetActorLocation(), IndexStep);
--     local TmpActor = self.LocationActorMap:Keys():GetRef(Index)

--     local IsNearst, IsNavValid = TryGetValidActor(TmpActor, Index)

--     if IsNearst then
--         if IsNavValid then
--             return Index - 1, TmpActor
--         else
--             self:EnableActorActive(false)
--             return -1, nil
--         end
--     end

--     -- 开始遍历找次近点
--     local tmpJumpCnt = 1
--     while(tmpJumpCnt < (self.LocationActorNumber/2 + 1)) do
--         local i = Index + tmpJumpCnt
--         if i > self.LocationActorNumber then
--             i = i - self.LocationActorNumber
--         end
--         TmpActor = self.LocationActorMap:Keys():GetRef(i)

--         IsNearst, IsNavValid = TryGetValidActor(TmpActor, i)
--         if IsNearst then
--             if IsNavValid then
--                 return i - 1, TmpActor
--             else
--                 self:EnableActorActive(false)
--                 return -1, nil
--             end
--         end
        
--         i = Index - tmpJumpCnt
--         if i <= 0 then
--             i = i + self.LocationActorNumber
--         end
--         TmpActor = self.LocationActorMap:Keys():GetRef(i)

--         IsNearst, IsNavValid = TryGetValidActor(TmpActor, i)
--         if IsNearst then
--             if IsNavValid then
--                 return i - 1, TmpActor
--             else
--                 self:EnableActorActive(false)
--                 return -1, nil
--             end
--         end

--         tmpJumpCnt = tmpJumpCnt + 1
--     end
    
--     self:EnableActorActive(false)
--     return -1, nil

-- end

-- function BP_AroundLocationComponent_C:ReleaseTargetActor(Actor, SourceEid)
--     if self.LocationActorMap:Find(Actor) == SourceEid then 
--         self.LocationActorMap:Add(Actor, 0)
--         self:ResetLocationOffset(self.LocationActorArray:Find(Actor), self.LocationActorDis)
--         self:EnableActorActive(false)
--     end
-- end

-- function BP_AroundLocationComponent_C:ResetLocationOffset(Index, Dis)
--     -- Index = [1, LocationActorNumber]
--     if Index <= 0 or Index > self.LocationActorNumber then
--         return
--     end
--     if math.abs(self.LocationOffset[Index]:Size() - Dis) < 0.1 then
--         return
--     end
--     local RotatorIndex = 0
--     if Index > 1 then
--         RotatorIndex = Index - 1
--     end
--     local Rotator = FRotator(0, (360/self.LocationActorNumber) * RotatorIndex, 0)
--     self.LocationOffset[Index] = Rotator:RotateVector(FVector(1, 0, 0) * Dis)
-- end

-- function BP_AroundLocationComponent_C:CalculateIndex(MonsterLoc, PlayerLoc, IndexStep)
--     -- return Index = [1, LocationActorNumber]
--     local AxisX = FVector(1, 0, 0)
--     local MonsterDir = MonsterLoc - PlayerLoc
--     MonsterDir.Z = 0
     
--     local Angle = math.acos(math.max(-1, math.min(MonsterDir:Dot(AxisX) / (AxisX:Size() * MonsterDir:Size()), 1)))
--     Angle = (Angle / math.pi) * 180
--     local tmpAngle = 360 / self.LocationActorNumber
--     if Angle < tmpAngle/2 then
--         return IndexStep
--     end
--     if MonsterDir.Y < 0 then
--         Angle = 360 - Angle
--     end
--     local Index = math.floor((Angle + tmpAngle/2) / tmpAngle) + 1
--     Index = Index % IndexStep > 0 and Index + 1 or Index
--     Index = Index > self.LocationActorNumber and 1 or Index
--     return Index
-- end


return BP_AroundLocationComponent_C

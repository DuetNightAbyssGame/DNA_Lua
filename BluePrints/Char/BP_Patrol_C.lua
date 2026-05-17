--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_Patrol_C = Class()

--function BP_Patrol_C:Initialize(Initializer)
--end

--function BP_Patrol_C:UserConstructionScript()
--end

--function BP_Patrol_C:ReceiveBeginPlay()
--end

function BP_Patrol_C:ReceiveBeginPlay()
	self.Overridden.ReceiveBeginPlay(self)
	for i = 1, self.ChildPatrolActors:Length() do
		local ChildPatrolActor = self.ChildPatrolActors:GetRef(i)
		if IsValid(ChildPatrolActor) then
			self.ChildPatrolLocs:Add(ChildPatrolActor:K2_GetActorLocation())
		end
	end
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	GameState:AddPatrolInfo(self)
end

--function BP_Patrol_C:ReceiveEndPlay()
--end

-- function BP_Patrol_C:ReceiveTick(DeltaSeconds)
-- end

-- function BP_Patrol_C:GetNextPatrolLoc(PatrolType, Character)
-- 	-- 巡逻点查找方式   循环 123123   返程 123321
-- 	Character.PatrolIndex = Character.PatrolIndex + 1
-- 	local LocLength = self.ChildPatrolLocs:Length()
-- 	local RealIndex = Character.PatrolIndex % LocLength
-- 	local RealLoc = UE4.FVector(0, 0, 0)
-- 	if PatrolType == 0 then
-- 		-- 循环 123 123
-- 		RealLoc = self.ChildPatrolLocs:GetRef(RealIndex + 1)
-- 		self.PatrolIndex = RealIndex
-- 	elseif PatrolType == 1 then 
-- 		-- 往返 123212321
-- 		-- 把 1232 作为一组
-- 		local RealLength = LocLength * 2 - 2
-- 		RealIndex = Character.PatrolIndex % RealLength
-- 		if RealIndex < LocLength then
-- 			RealLoc = self.ChildPatrolLocs:GetRef(RealIndex + 1)
-- 			self.PatrolIndex = RealIndex
-- 		else
-- 			RealLoc = self.ChildPatrolLocs:GetRef(RealLength - RealIndex + 1)
-- 			self.PatrolIndex = RealLength - RealIndex
-- 		end
-- 	else
-- 		-- 单次 123
-- 		if Character.PatrolIndex <= LocLength then 
-- 			RealLoc = self.ChildPatrolLocs:GetRef(Character.PatrolIndex)
-- 			self.PatrolIndex = Character.PatrolIndex - 1
-- 		end
-- 	end
-- 	return RealLoc
-- end

--function BP_Patrol_C:ReceiveActorBeginOverlap(OtherActor)
--end

--function BP_Patrol_C:ReceiveActorEndOverlap(OtherActor)
--end

return BP_Patrol_C

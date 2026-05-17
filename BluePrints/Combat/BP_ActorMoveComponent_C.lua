
require "UnLua"

local Component = Class()

-- function Component:ReceiveBeginPlay()
-- 	self.Character = self:GetOwner()
-- 	self.TotalTime = 0
-- 	self.PassTime = 0
-- 	self.MoveArgs = nil
-- 	self.Tag = nil
-- end

-- function Component:ReceiveTick(DeltaSeconds)
-- 	if(self.MoveArgs == nil) then
-- 		return
-- 	end
-- 	local LeftTime = 0.0
-- 	if (DeltaSeconds > self.TotalTime - self.PassTime) then
-- 		LeftTime = self.TotalTime - self.PassTime
-- 	else
-- 		LeftTime = DeltaSeconds
-- 	end
-- 	if LeftTime <= 0 then
-- 		return
-- 	end
-- 	local SpeedX = (self.MoveArgs["SpeedX"] or 0)
--     local SpeedY = (self.MoveArgs["SpeedY"] or 0)
--     local SpeedZ = (self.MoveArgs["SpeedZ"] or 0)

-- 	self:Move(LeftTime, FVector(SpeedX, SpeedY, SpeedZ), self.MoveArgs.bWorldCoordinate)

-- 	self.PassTime = self.PassTime + LeftTime
-- 	if (self.PassTime >= self.TotalTime) then
-- 		self:ClearAllMoveInfo()
-- 	end
-- end

-- function Component:Move(TotalTime, Speed, bWorldCoordinate)
-- 	self.Overridden.Move(self, TotalTime, Speed, bWorldCoordinate or false)
-- 	if TotalTime == 0 then
-- 		return
-- 	end

-- 	-- 如果传进来的是角色坐标系
-- 	if not bWorldCoordinate then
-- 		local CharacterRotation = self.Character:K2_GetActorRotation()
-- 	    Speed = UE.UKismetMathLibrary.GreaterGreater_VectorRotator(Speed, CharacterRotation)
-- 	end
-- 	if not self.Character.CacheInfos["LiftHeightDuration"] or self.Character.CacheInfos["LiftHeightDuration"] <= 0 then
-- 		local Movement = self.Character:GetMovementComponent()
-- 		if Movement.MovementMode ~= Movement.DefaultLandMovementMode and Movement.MovementMode ~= EMovementMode.MOVE_Falling then
-- 			Movement:SetMovementMode(Movement.DefaultLandMovementMode)
-- 		end
-- 	end
-- 	-- 世界坐标系
-- 	self.Character:MoveSmooth(Speed, TotalTime)
-- end


-- function Component:SetMoveInfo(Tag, TotalTime, X, Y, Z, bWorldCoordinate)
-- 	self.Overridden.SetMoveInfo(self, Tag, TotalTime, X, Y, Z, bWorldCoordinate or false)
-- 	if X == 0 and Y == 0 and Z == 0 then
-- 		return
-- 	end
-- 	if TotalTime == 0 then
-- 		return
-- 	end
-- 	self:ClearAllMoveInfo()
-- 	self.Tag = Tag
-- 	self.TotalTime = TotalTime
-- 	self.MoveArgs = 
-- 	{
-- 		SpeedX = X / TotalTime,
-- 		SpeedY = Y / TotalTime,
-- 		SpeedZ = Z / TotalTime,
-- 		bWorldCoordinate = bWorldCoordinate,
-- 	}
-- 	self.Character:LaunchCharacter(FVector(0,0,0.001),true,true)
-- end

-- function Component:ClearMoveInfo(Tag)
-- 	self.Overridden.ClearMoveInfo(self, Tag)
-- 	if self.Tag == Tag then
-- 		self:ClearAllMoveInfo()
-- 	end
-- end

-- function Component:ClearAllMoveInfo()
-- 	self.Overridden.ClearAllMoveInfo(self)
-- 	self.MoveArgs = nil
-- 	self.TotalTime = 0
-- 	self.PassTime = 0
-- end

return Component


require "UnLua"

local Component = Class()

-- function Component:InitComponent()
-- 	self.BornDisTime = 1
-- 	self.BornDisRemainTime = self.BornDisTime
-- 	self.UpdateCanReachEscapeInterval = 0.5
-- 	self.CanReachEscapeRemainTime = self.UpdateCanReachEscapeInterval
-- 	if self:GetOwnBlackBoardComponent() then
-- 		self:GetOwnBlackBoardComponent():SetValueAsVector("BornLoc", self.BornPos)
-- 		local GameMode = UE4.UGameplayStatics.GetGameMode(self)
-- 		if not GameMode or not GameMode:GetDungeonComponent() then 
--         	return
--     	end
-- 		self:InitTreasureBBInfo(GameMode)
-- 		self:InitCaptureBBInfo(GameMode)
-- 	end
-- end

-- function Component:InitTreasureBBInfo(GameMode)
	-- if not self.Owner or not self.Owner:IsTreasureMonster() then 
	-- 	return 
	-- end
	-- GameMode:TriggerDungeonComponentFun("InitTreasureMonsterEecapeLoc", self.Owner)
-- end

function Component:InitCaptureBBInfo(GameMode)
	local Owner = self.Owner
    if not Owner then 
        return
    end
    local EscapeLoc = GameMode:GetDungeonComponent().EscapeLoc
    GameMode:GetDungeonComponent().CaptureMonster = Owner
    if GameMode:GetDungeonComponent().PostEventCaptureTargetSpawnEnable then
        GameMode:GetDungeonComponent().PostEventCaptureTargetSpawnEnable = false
        GameMode:PostCustomEvent("CaptureTargetSpawn")
    end
    if not EscapeLoc then
        return
    end
    Owner:GetOwnBlackBoardComponent():SetValueAsVector("EscapeLoc", EscapeLoc)
end

-- function Component:TickComponent(DeltaSeconds)
-- 	if not self:IsPureMonster() then
-- 		return
-- 	end
-- 	self.BornDisRemainTime = self.BornDisRemainTime - DeltaSeconds
-- 	if self.BornDisRemainTime <= 0 then
-- 		self.BornDisRemainTime = self.BornDisTime
-- 		self:UpdateBornPointDis()
-- 	end

-- 	if self:IsCaptureMonster() or self:IsTreasureMonster() then
-- 		self.CanReachEscapeRemainTime = self.CanReachEscapeRemainTime - DeltaSeconds
-- 		if self.CanReachEscapeRemainTime <= 0 then
-- 			self.CanReachEscapeRemainTime = self.UpdateCanReachEscapeInterval
-- 			self:UpdateCanReachEscape()
-- 		end
-- 	end
-- end

-- function Component:UpdateBornPointDis()
-- 	local Dis = (self:K2_GetActorLocation() - self.BornPos):Size()
-- 	if self:GetOwnBlackBoardComponent() then
-- 		self:GetOwnBlackBoardComponent():SetValueAsFloat("BornPointDis", Dis)
-- 	end
-- end

-- function Component:UpdateCanReachEscape()
-- 	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
-- 	local LevelLoader = GameMode:GetLevelLoader()
-- 	if not LevelLoader or not GameMode:GetDungeonComponent() then return end

-- 	local EscapeLoc = self:GetOwnBlackBoardComponent():GetValueAsVector("EscapeLoc")
-- 	local NextDoorLoc, NextLevelEnable = LevelLoader:GetNextLevelIsLoaded(self, EscapeLoc)
--     local CanReachEscape = true
-- 	if (not NextLevelEnable) and (self:k2_GetActorLocation() - NextDoorLoc):Size() <= 300 then 
--         CanReachEscape = false
--     end
-- 	if self:GetOwnBlackBoardComponent():GetValueAsBool("CanReachEscape") ~= CanReachEscape then
--         self:GetOwnBlackBoardComponent():SetValueAsBool("CanReachEscape", CanReachEscape)
--     end
-- end

function Component:GetNextLevelIsLoaded(MonserCharacter,LevelLoader,EscapeLoc)
	if not MonserCharacter or not LevelLoader then
		return
	end
	local NextLevelEnable = false;
	local OutDoorLoc
	OutDoorLoc,NextLevelEnable = LevelLoader:GetNextLevelIsLoaded(MonserCharacter,EscapeLoc)
	self.NextLevelEnable = NextLevelEnable
	return OutDoorLoc
end

return Component
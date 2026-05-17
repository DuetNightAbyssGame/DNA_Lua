
require "UnLua"

local BP_MonSteeringComponent_C = Class()
-- struct FEnvirInfo
-- {
-- 	FVector Location = FVector::ZeroVector;
-- 	FVector Extent = FVector::ZeroVector;
-- 	FVector ClosestPointOnWall = FVector::ZeroVector;
-- 	int ChokePointSize = 100000;
-- 	int ChockPointLocationX = 0;
-- 	bool HasAnyObstacle = false;
-- 	bool bIsCrossingLevelVolume = false;
-- 	int PotentialMonsterNum = 0;
-- 	int CurrentMonsterNum = 0;
-- }

function BP_MonSteeringComponent_C:Initialize(Initializer)
	-- self:Super(Initializer)
end

-- function BP_MonSteeringComponent_C:BP_GetScoreForPath(EnvirInfoIdList)
-- 	local Score = 1
-- 	local EnvirInfoIdListTable = EnvirInfoIdList:ToTable()

-- 	for _, EnvirInfoId in ipairs(EnvirInfoIdListTable) do
-- 		local EnvirInfo = self:GetEnvirInfoById(EnvirInfoId)
-- 		local Mutiplier = 1
-- 		if EnvirInfo.HasAnyObstacle then
-- 			Mutiplier = 2
-- 		end
-- 		local MonsterPenalty = EnvirInfo.PotentialMonsterNum * 0.1 * Mutiplier
-- 		MonsterPenalty = MonsterPenalty + EnvirInfo.CurrentMonsterNum * 0.15 * Mutiplier
-- 		Score = Score - MonsterPenalty
-- 	end
-- 	if Score < 0 then
-- 		Score = 0
-- 	end
-- 	return Score
-- end

-- function BP_MonSteeringComponent_C:BP_GetScoreForMoveInfo(MoveInfoId)
-- 	local Controller = self:GetOwner()
-- 	local Character = Controller:K2_GetPawn()
-- end

return BP_MonSteeringComponent_C
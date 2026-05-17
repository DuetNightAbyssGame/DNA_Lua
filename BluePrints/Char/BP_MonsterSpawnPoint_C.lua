--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_MonsterSpawnPoint_C = Class()

--function BP_MonsterSpawnPoint_C:Initialize(Initializer)
--end

--function BP_MonsterSpawnPoint_C:UserConstructionScript()
--end

function BP_MonsterSpawnPoint_C:ReceiveBeginPlay()
	self.Overridden.ReceiveBeginPlay(self)
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	GameState:AddMonsterSpawnPointInfo(self)
end

--function BP_MonsterSpawnPoint_C:ReceiveEndPlay()
--end

-- function BP_MonsterSpawnPoint_C:ReceiveTick(DeltaSeconds)
-- end

--function BP_MonsterSpawnPoint_C:ReceiveActorBeginOverlap(OtherActor)
--end

--function BP_MonsterSpawnPoint_C:ReceiveActorEndOverlap(OtherActor)
--end

return BP_MonsterSpawnPoint_C

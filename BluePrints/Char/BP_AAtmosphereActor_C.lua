require "UnLua"
--
--
local M = Class()

function M:ReceiveBeginPlay()
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	GameState.AAtmosphereActorSet:Add(self)
end

function M:ReceiveEndPlay()
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	GameState.AAtmosphereActorSet:Remove(self)
end

return M

local M = Class()

function M:DescribeSelfToManager(NavLinkLeader)
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	if not GameState then
		return
	end
	if NavLinkLeader == nil then
		NavLinkLeader = self
	end
	GameState:RegisterLink(self, NavLinkLeader)
end

function M:UnregisterSelfToManager(NavLinkLeader)
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	if not GameState then
		return
	end
	if NavLinkLeader == nil then
		NavLinkLeader = self
	end
	GameState:UnregisterLink(NavLinkLeader)
end

function M:FindAndOccupyLink(LinkLeader)
	LinkLeader = LinkLeader or self
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	if not GameState then
		return nil
	end
	return GameState:FindAndOccupyLink(LinkLeader)
end

return M

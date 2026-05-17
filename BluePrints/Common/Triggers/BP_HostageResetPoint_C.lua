--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_HostageResetPoint_C
local M = Class()

function M:ReceiveBeginPlay()
    if IsAuthority(self) then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState:AddHostageResetPoint(self)
    end
end

function M:ReceiveEndPlay()
    if IsAuthority(self) then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState:RemoveHostageResetPoint(self)
    end
end

return M

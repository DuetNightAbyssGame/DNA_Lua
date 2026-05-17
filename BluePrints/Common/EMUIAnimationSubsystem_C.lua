require "UnLua"

---@type BP_EMUIAnimationSubsystem_C
local M = Class()

function M:ReceiveInitialize()
    _G.EMUIAnimationSubsystem = self
end

function M:Deinitialize()
    _G.EMUIAnimationSubsystem = nil
end

return M
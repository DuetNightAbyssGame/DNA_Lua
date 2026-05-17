local M = {}

function M:New()
    local Obj = setmetatable({}, { __index = M })
    return Obj
end

function M:Execute()
    local EnvironmentManager = UE4.UGameplayStatics.GetActorOfClass(GWorld.GameInstance, UE4.AEnvironmentManager)
    if (not IsValid(EnvironmentManager)) then
        DebugPrint(_G.ErrorTag, "pause time elapse failed, EnvironmentManager is invalid")
        return
    end

    EnvironmentManager:SetEnableTimeElapse(false, "Talk")
end

function M:Resume()
    local EnvironmentManager = UE4.UGameplayStatics.GetActorOfClass(GWorld.GameInstance, UE4.AEnvironmentManager)
    if (not IsValid(EnvironmentManager)) then
        DebugPrint(_G.ErrorTag, "resume time elapse failed, EnvironmentManager is invalid")
        return
    end

    EnvironmentManager:RevertEnableTimeElapse("Talk")
end

return M

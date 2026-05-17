local M = {}

function M:New()
    local Obj = setmetatable({}, {
        __index = M
    })
    return Obj
end

function M:Execute()
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    if (not IsValid(GameState)) then
        return
    end

    GameState:HideAllCombatItemFX(Const.TalkHideTag, false)
end

function M:Resume()
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    if (not IsValid(GameState)) then
        return
    end

    GameState:HideAllCombatItemFX(Const.TalkHideTag, true)
end

return M

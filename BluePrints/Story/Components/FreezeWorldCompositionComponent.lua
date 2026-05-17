---@class FFreezeWorldCompositionComponent
local FFreezeWorldCompositionComponent = {}

---@return FFreezeWorldCompositionComponent
function FFreezeWorldCompositionComponent:New()
	local FreezeWorldCompositionComponent = setmetatable({}, {
        __index = FFreezeWorldCompositionComponent
    })
    return FreezeWorldCompositionComponent
end

function FFreezeWorldCompositionComponent:Execute()
	DebugPrint("TalkComp_FreezeWorldComposition_C 冻结WC")
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if not GameMode then
        DebugPrint("无GameMode 无法冻结WC")
        return 
    end
    local WorldCompositionSubsystem = GameMode:GetWCSubSystem()
    if WorldCompositionSubsystem then
        WorldCompositionSubsystem:FreezeWorldComposition()
    end
end

function FFreezeWorldCompositionComponent:Resume()
	DebugPrint("TalkComp_FreezeWorldComposition_C 解冻WC")
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if not GameMode then
        DebugPrint("无GameMode 无法解冻WC")
        return 
    end
    local WorldCompositionSubsystem = GameMode:GetWCSubSystem()
    if WorldCompositionSubsystem then
        WorldCompositionSubsystem:UnFreezeWorldComposition()
    end
end

return FFreezeWorldCompositionComponent
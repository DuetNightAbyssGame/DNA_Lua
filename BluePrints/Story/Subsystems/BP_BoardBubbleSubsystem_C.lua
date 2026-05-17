local M = Class("BluePrints.Common.StageTimerMgr")
local SignBoardBubbleTalkModel = require "BluePrints.UI.WBP.SignBoardBubble.SignBoardBubbleTalkModel"
function M:GetCanTriggerIds(NpcId)
    local Array = TArray(0)
    local LuaTriggers = SignBoardBubbleTalkModel:GetNpcCanTrigger(NpcId)
    if not LuaTriggers then return Array end
    for _, TriggerId in ipairs(LuaTriggers) do
        Array:Add(TriggerId)
    end
    return Array
end

return M
---@class TalkLookAtComp_C
local TalkLookAtComp_C = {}
TalkLookAtComp_C.New = function()
    ---@type TalkLookAtComp_C
    local Obj = setmetatable({}, {
        __index = TalkLookAtComp_C
    })
    return Obj
end

---@param DialogueData DialogueDataBase_C
---@param TalkTaskData TalkTaskDataBase_C
---@param TalkTaskData TalkTaskBase_C
---@param DialogueWaitQueue TalkWaitQueue_C
function TalkLookAtComp_C:PlayDialogue(DialogueData, TalkTaskData, TalkTask, DialogueWaitQueue)
end

return TalkLookAtComp_C

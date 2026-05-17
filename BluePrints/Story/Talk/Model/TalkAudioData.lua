---@class TalkAudioData_C
local TalkAudioData_C = {}
TalkAudioData_C.New=function(ChapterId,GUID)
    ---@type TalkAudioData_C
    local Obj = setmetatable({},{})
    Obj.ChapterId = ChapterId
    Obj.GUID = GUID
    return Obj
end

return TalkAudioData_C
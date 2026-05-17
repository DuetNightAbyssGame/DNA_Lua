---@class BaseTagInfo
local BaseInfo = {
    ForbidTags = {}, -- 禁止该Tag转移的列表
    StateLimitInfo = {} -- 该Tag的StateLimit表
}
BaseInfo.__index = BaseInfo
function BaseInfo.OnEnterTag(Owner)
end

function BaseInfo.OnLeaveTag(Owner)
end

function BaseInfo.CanLeaveTag(Owner) 
    return true
end

return BaseInfo
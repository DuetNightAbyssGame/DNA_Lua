
---@class Version 缓存文件版本号，当本地缓存相关的逻辑发生变更时，需要手动更改版本号，使其他同学的缓存文件能顺利重建
---@field CommonCacheVersion number 公共缓存文件版本号
---@field UserCacheVersion number 用户缓存文件版本号

local CommonCacheVersion = 1.2
local UserCacheVersion = 1.2

return {
    CommonCacheVersion = CommonCacheVersion,
    UserCacheVersion = UserCacheVersion,
    GetVersion = function (bUseUUID)
        return bUseUUID and UserCacheVersion or CommonCacheVersion
    end
}
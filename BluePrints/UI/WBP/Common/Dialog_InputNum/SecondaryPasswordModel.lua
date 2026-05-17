local M = Class("BluePrints.Common.MVC.Model")
local TimeUtils = require "Utils.TimeUtils"
local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"

function M:Init()
    M.Super.Init(self)
    self.FreezeTimeStamp = nil
end

function M:GetSecondaryPassword()
    local Avatar = self:GetAvatar()
    if not Avatar then
        return ""
    end
    return Avatar.szSecondaryPassword or ""
end

function M:GetSecondaryPasswordPreLoginValidateOnce()
    local Avatar = self:GetAvatar()
    if not Avatar then
        return false
    end
    return Avatar.SecondaryPasswordPreLoginValidateOnce or false
end

function M:GetSecondaryPasswordEnabled()
    local Avatar = self:GetAvatar()
    if not Avatar then
        return false
    end
    return Avatar.szSecondaryPassword ~= ""
end

function M:GetSecondaryPasswordErrorTimes()
    local Avatar = self:GetAvatar()
    if not Avatar then
        return 0
    end
    return Avatar.nSecondaryPasswordErrorTimes or 0
end

function M:GetSecondaryPasswordFreezeTimeStamp()
    local Avatar = self:GetAvatar()
    if not Avatar then
        return nil
    end
    return Avatar.nSecondaryPasswordFreezeTimeStamp
end

function M:GetSecondaryPasswordIsValidateThisLogin()
    local Avatar = self:GetAvatar()
    if not Avatar then
        return nil
    end
    return Avatar.nSecondaryPasswordIsValidateThisLogin
end

function M:Destory()
    M.Super.Destory(self)
end

_G.SecondaryPasswordModel=M

return M

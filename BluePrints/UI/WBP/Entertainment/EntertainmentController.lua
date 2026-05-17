---@class EntertainmentController :Controller
local M = Class("BluePrints.Common.MVC.Controller")
local Model = require "BluePrints.UI.WBP.Entertainment.EntertainmentModel"

function M:Init()
    M.Super.Init(self)
end

function M:Destory()
    M.Super.Destory(self)
end

function M:GetModel()
    return Model
end

function M:GetEventName()
    return "Entertainment"
end

return M
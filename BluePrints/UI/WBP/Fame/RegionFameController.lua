local RegionFameModel = require "BluePrints.UI.WBP.Fame.RegionFameModel"

---@class RegionFameController:Controller
---@field Super Controller
local M = Class("BluePrints.Common.MVC.Controller")

function M:Init()
    M.Super.Init(self)
end

function M:Destory()
    M.Super.Destory(self)
end

function M:GetModel()
    return RegionFameModel
end

function M:GetEventName()
    return EventID.RegionFameControllerEvent
end

return M
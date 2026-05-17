local WalnutBagModel = require "BluePrints.UI.WBP.Walnut.WalnutBag.WalnutBagModel"
local WalnutBagCommon = require "BluePrints.UI.WBP.Walnut.WalnutBag.WalnutBagCommon"

---@class WalnutBagController:Controller
---@field Super Controller
local M = Class("BluePrints.Common.MVC.Controller")

function M:Init()
    M.Super.Init(self)
    -- EventManager:AddEvent(EventID.CloseLoading , self, self.OnCloseLoading)
end

function M:Destory()
    -- EventManager:RemoveEvent(EventID.CloseLoading, self)
    M.Super.Destory(self)
end

function M:GetModel()
    return WalnutBagModel
end

function M:GetEventName()
    return EventID.WalnutBagControllerEvent
end

--region 界面操作
function M:OpenView(WorldContex, SelectTabType, SelectItemId)
    return M.Super.OpenView(self, WorldContex, WalnutBagCommon.UIName, SelectTabType, SelectItemId)
end

function M:GetView(WorldContex)
    return M.Super.GetView(self, WorldContex, WalnutBagCommon.UIName)
end

--endregion

return M
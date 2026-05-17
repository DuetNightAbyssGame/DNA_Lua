local GuildCommon = require "BluePrints.UI.WBP.Guild.GuildCommon"
local GuildModel = require "BluePrints.UI.WBP.Guild.Model.GuildModel"

---@class GuildController
local M = Class("BluePrints.Common.MVC.Controller")

M._components = {
    "BluePrints.UI.WBP.Guild.Controller.GuildController_ShopComp",
    "BluePrints.UI.WBP.Guild.Controller.GuildController_InfoDetailComp",
    "BluePrints.UI.WBP.Guild.Controller.GuildController_ChatComp",
    "BluePrints.UI.WBP.Guild.Controller.GuildController_BaseMgrComp",
    "BluePrints.UI.WBP.Guild.Controller.GuildController_AuthorityComp",
    "BluePrints.UI.WBP.Guild.Controller.GuildController_AccuseComp",
}

function M:OnInit() end
function M:OnDestory() end
function M:OnOpenView(ViewObj) end
function M:OnGetView() end


function M:Init()
    M.Super.Init(self)
    self:OnInit()
end

function M:Destory()
    self:OnDestory()
    M.Super.Destory(self)
end

function M:GetModel()
    return GuildModel
end

function M:GetEventName()
    return EventID.GuildControllerEvent
end

function M:OpenView(WorldContext,ViewNameOrMainUIId, ...)
    local ViewObj = M.Super.OpenView(self, WorldContext, ViewNameOrMainUIId, ...)
    self:OnOpenView(ViewObj)
    return ViewObj
end

---@param ViewName [@opt]
function M:GetView(WorldContext, ViewName)
    local ViewObj = self:OnGetView()
    if ViewObj then return ViewObj end
    return M.Super.GetView(WorldContext, ViewName)
end

AssembleComponents(M)
_G.GuildController = M
return M
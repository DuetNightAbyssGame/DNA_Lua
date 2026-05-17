local GuildCommon = require "BluePrints.UI.WBP.Guild.GuildCommon"

---@class GuildModel
local M = Class("BluePrints.Common.MVC.Model")
M._components = {
    "BluePrints.UI.WBP.Guild.Model.GuildModel_ShopComp",
    "BluePrints.UI.WBP.Guild.Model.GuildModel_InfoDetailComp",
    "BluePrints.UI.WBP.Guild.Model.GuildModel_ChatComp",
    "BluePrints.UI.WBP.Guild.Model.GuildModel_BaseMgrComp",
    "BluePrints.UI.WBP.Guild.Model.GuildModel_AuthorityComp",
    "BluePrints.UI.WBP.Guild.Model.GuildModel_AccuseComp",
}

function M:OnInit() end
function M:OnDestory() end

function M:Init()
    M.Super.Init(self)
    self:OnInit()
end

function M:Destory()
    self:OnDestory()
    M.Super.Destory(self)
end

AssembleComponents(M)
return M
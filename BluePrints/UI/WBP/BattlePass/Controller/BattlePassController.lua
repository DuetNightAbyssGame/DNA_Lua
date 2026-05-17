--- 战令Controller

local BattlePassModel = require "BluePrints.UI.WBP.BattlePass.Model.BattlePassModel"

--- @class BattlePassController :Controller
local M = Class("BluePrints.Common.MVC.Controller")

function M:Init()
    M.Super.Init(self)

end

function M:Destory()
    M.Super.Destory(self)

end

function M:GetModel()
    return BattlePassModel
end

function M:GetEventName()
    return "BattlePass"
end

function M:SetModelData(Name, Value)
    return BattlePassModel:SetModelData(Name, Value)
end

function M:GetModelData(Name, DefaultValue)
    return BattlePassModel:GetModelData(Name, DefaultValue)
end

--region 界面操作
-- function M:OpenView(WorldContex, Param)
--     return M.Super.OpenView(self, WorldContex, GText("BattlePassMain"), Param)
-- end

-- function M:GetView(WorldContex)
--     return M.Super.GetView(self, WorldContex, GText("BattlePassMain"))
-- end
--endregion

return M


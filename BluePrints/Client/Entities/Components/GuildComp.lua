local GuildController = require "BluePrints.UI.WBP.Guild.Controller.GuildController"
local Decorator = require "BluePrints.Client.Wrapper.Decorator"

local Component = {}
Decorator:ApplyDecorator(Component)

function Component:_OnLoginSuccess()
    GuildController:Init()
end

---@todo rpc函数

function Component:LeaveWorld()
    GuildController:Destory()
end

return Component
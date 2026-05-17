require "UnLua"
local M = Class()

function M:Initialize(Initializer)
end

function M:OnBeginPlayInLua()
    EventManager:AddEvent(EventID.OnLevelDeliverBlackCurtainEnd, self, self.OnPlayerDeliverEnd)
    self:SetComponentTickInterval(0);
end


function M:OnPlayerDeliverEnd()
    self:BeginExecuteMoveToProxy()
end

function M:OnEndPlayInLua()
   	EventManager:RemoveEvent(EventID.OnLevelDeliverBlackCurtainEnd, self)
end

return M

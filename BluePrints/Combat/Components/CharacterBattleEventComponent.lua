
local Component = {}

function Component:ReceiveBeginPlay()
    rawset(self, "BattleEvent", self.BattleEvent)
end

-- function Component:TriggerCharacterEvent(EventName, ...)
-- 	self:_CheckBattleEvent()
--     -- 绑定在角色蓝图中的事件
--     local Event = self.BattleEvent:GetEvent(EventName)
--     if Event then
--         Event:Broadcast(...)
--     end
-- end

-- function Component:_CheckBattleEvent()
-- 	if not self.BattleEvent:HasEvent() then
-- 		self.TriggerCharacterEvent = MiscUtils.EmptyFunction
-- 	end
-- 	self._CheckBattleEvent = MiscUtils.EmptyFunction
-- end

return Component

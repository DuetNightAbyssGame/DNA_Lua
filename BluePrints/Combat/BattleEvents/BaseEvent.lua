
-- -- require "UnLua"

-- local BaseEvent = {}

-- function BaseEvent:Init(Battle)
-- 	self.Battle = Battle
-- 	if self.EventToFuncs then
-- 		for  _, FuncData in pairs(self.EventToFuncs) do
-- 			local EventName = FuncData.EventName
-- 			local FuncName = FuncData.FuncName
-- 			local Priority = FuncData.Priority
-- 			Battle:RegisterBattleEvent(EventName, Battle, self[FuncName], Priority)
-- 		end
-- 	end
-- end

-- function BaseEvent:AddDecorator(Func)
-- 	if not self.Decorators then
-- 		self.Decorators = {}
-- 	end
-- 	table.insert(self.Decorators, Func)
-- end

-- function BaseEvent:Destroy(Battle)
-- 	if self.EventToFuncs then
-- 		for  _, FuncData in pairs(self.EventToFuncs) do
-- 			local EventName = FuncData.EventName
-- 			local FuncName = FuncData.FuncName
-- 			Battle:UnregisterBattleEvent(EventName, Battle, self[FuncName])
-- 		end
-- 	end
-- end

-- function BaseEvent.Decorator(self, EventName, Priority)
-- 	self:AddDecorator(function(FuncName, f)
-- 		if not self.EventToFuncs then
-- 			self.EventToFuncs = {}
-- 		end
-- 		table.insert(self.EventToFuncs, {
-- 			EventName = EventName,
-- 			FuncName = FuncName,
-- 			Priority = Priority,
-- 		})
-- 		local NewFunc = function(Battle, ...)
-- 			self.Battle = Battle
-- 			-- 因为代码11行注册的时候，传入的Obj是Battle，所以触发的时候，第一个参数self指的是Battle，需要在这里先转成默认self
-- 			f(self, ...)
-- 		end
--         return NewFunc
--     end)
-- end

-- BaseEvent = setmetatable(BaseEvent, {
-- 	__newindex = function(_table, key, value)
-- 	    if 'function' == type(value) then
-- 	    	if not _table.Decorators then
-- 				_table.Decorators = {}
-- 			end
-- 	        for i = #_table.Decorators, 1, -1 do
-- 	            value = _table.Decorators[i](key, value)
-- 	            _table.Decorators[i] = nil
-- 	        end
-- 	    end
-- 	    rawset(_table, key, value)
-- 	end
-- })

-- return BaseEvent

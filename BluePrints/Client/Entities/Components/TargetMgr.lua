local Component = {}

function Component:TriggerTarget(targets)
    if type(targets) ~= "table" then
        return
    end

    local function callback(ret)
        PrintTable({TriggerTarget=1,ret=ret})
    end
    self:CallServer("TriggerTarget", callback, targets)
end

function Component:GetTargetCount(id)
    local target = self.AchvTargets[id]
    if target then
        return target.Count
    end
end

function Component:GetTargetCurrentValue(id)
    local target = self.AchvTargets[id]
    if target then
        return target.CurrentValue
    end
end

-- @SnowMoon 定义一下这个组件：用于Avatar触发器，包括客户端完成某个事件/条件的触发器通知服务器，或者服务器完成某个事件/条件通知客户端

 function Component:CombatItemTargetFinish(TargetType, UniqueAttr, Count, ...)
     local Params = {...}
     if #Params < 1 then
         return
     end

     local Key = tostring(TargetType) .. "_" .. tostring(Params[1])
     if not DataMgr.TargetTypeIdValidMap[Key] then
         return
     end

     -- 单机情况下无视第三个参数，把两种参数情况都上报服务端
     table.insert(Params, 0)
     self:ServerTargetFinish(TargetType, UniqueAttr, Count, table.unpack(Params))
     Params[#Params] = 1
     self:ServerTargetFinish(TargetType, UniqueAttr, Count, table.unpack(Params))
 end

function Component:ServerTargetFinish(TargetType, UniqueAttr, Count, ...)
    self.logger.debug("ServerTargetFinish", TargetType, UniqueAttr, Count, ...)
    self:CallServerMethod("ServerTargetFinish", TargetType, UniqueAttr, Count, {...})
end

-- @SnowMoon Avatar触发条件完成，回调通知客户端，需要监听条件完成的模块在EventManager中自行注册监听事件EventID.ConditionComplete
function Component:ConditionComplete(ConditionId)
    print(_G.LogTag, "ConditionComplete", ConditionId)
    -- 服务端的条件已满足，主动CheckCondition一次，判断完整条件是否满足
    local cb = function (ret)
        if ret then
            EventManager:FireEvent(EventID.ConditionComplete, ConditionId)
        end
    end
    ConditionUtils.ServerCheckCondition(self, ConditionId, cb)
end

function Component:GMTestCheckTarget(Index, ErrorReason)
    self.logger.debug(string.format("当前测试的成就触发器: %d, 执行结果：%s ",Index, ErrorReason))
end


return Component

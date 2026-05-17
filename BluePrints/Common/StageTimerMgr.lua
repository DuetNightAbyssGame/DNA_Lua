require "UnLua"

local M = Class("BluePrints.Common.TimerMgr")

-- interval: 每隔多长时间执行func，单位秒
-- func: 需要执行的function
-- isloop: 是否循环func，默认为false
-- delay: 第一次tick的延迟，默认为0,可以为负数
-- Key: timer的键值,传入合法的Key，则使用；否则使用生成的Key
-- IsRealTime: 默认为false/nil会受到时间膨胀和暂停的影响，true则不受影响
function M:AddTimer(interval, func, isloop, delay, Key, IsRealTime, TickGroup, ...)
    -- PrintTable({AddTimer=Key})
    if self == nil then return end
    if func == nil then return end
    local Params = {...}
    if interval == nil or interval <= 0 then
        func(self, ...)
        return
    end

    self:Timer_Init()
    
    if Key == nil then
        self.TimerKeyIdx = self.TimerKeyIdx + 1
        Key = "AutoMade_"..self.TimerKeyIdx
    end

    self:RemoveTimer(Key)

    local f = function(self)
        -- PrintTable({Back=Key})
        if not self then
            return
        end
        if not isloop then
            self:RemoveTimer(Key, true)
        end
        func(self, table.unpack(Params))
    end
    local Timer = ULastDemotableTimerSubsystem.K2_SetTimerDelegate({ self, f }, interval, isloop, IsRealTime, delay, 0, TickGroup)
    self.TimerHandles[Key] = Timer
    self.TimerHandleDatas[Timer] = {Key = Key, IsRealTime = IsRealTime, Func = f, bTickEvenPaused = IsRealTime, TickGroup = TickGroup}
    return Timer, Key
end

function M:RemoveTimer(KeyOrTimer, bNotCallRemoveHandler)
    -- PrintTable({RemoveTimer=KeyOrTimer})
    if KeyOrTimer == nil or not rawget(self, "TimerHandles") then
        return
    end

    local TimerInfo = nil
    local Key, Timer, TimerInfo = self:_GetTimerInfo(KeyOrTimer)
    if not Key then
        return
    end

    ULastDemotableTimerSubsystem.K2_ClearAndInvalidateTimerHandle(self, Timer, TimerInfo.TickGroup, TimerInfo.bTickEvenPaused)

    if not bNotCallRemoveHandler then
        self:RemoveTimerHandler(TimerInfo.Func)
    end

    self.TimerHandles[Key] = nil
    self.TimerHandleDatas[Timer] = nil
end

function M:PauseTimer(KeyOrTimer)
    if KeyOrTimer == nil then
        return
    end

    self:Timer_Init()
    local Key, Timer, TimerInfo = self:_GetTimerInfo(KeyOrTimer)
    if not Key then
        return
    end

    -- 是否是实时定时器
    local IsRealTime = TimerInfo.IsRealTime
    ULastDemotableTimerSubsystem.K2_PauseTimerHandle(self, Timer, TimerInfo.TickGroup, IsRealTime)
end

function M:GetTimerRemainingTime(KeyOrTimer)
    if not KeyOrTimer then
        return -1
    end
    self:Timer_Init()
    local Key, Timer, TimerInfo = self:_GetTimerInfo(KeyOrTimer)
    if not Key then
        return -1
    end

    -- 是否是实时定时器
    local IsRealTime = TimerInfo.IsRealTime
    return ULastDemotableTimerSubsystem.K2_GetTimerRemainingTimeHandle(self, Timer, TimerInfo.TickGroup, IsRealTime)
end

function M:UnPauseTimer(KeyOrTimer)
    if KeyOrTimer == nil then
        return
    end

    self:Timer_Init()
    local Key, Timer, TimerInfo = self:_GetTimerInfo(KeyOrTimer)
    if not Key then
        return
    end

    -- 是否是实时定时器
    local IsRealTime = TimerInfo.IsRealTime
    ULastDemotableTimerSubsystem.K2_UnPauseTimerHandle(self, Timer, TimerInfo.TickGroup, IsRealTime)
end


return M
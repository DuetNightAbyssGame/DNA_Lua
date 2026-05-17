---@class TimerMgr
local Component = {}

function Component:Timer_Init()
	if rawget(self, "TimerHandles") == nil then
        rawset(self, "TimerHandles", {}) -- Key To Timer,

        rawset(self, "TimerHandleDatas", {}) -- Timer To {Key = Key, IsRealTime = IsRealTime, IsCombatTime = IsCombatTime}
        rawset(self, "TimerKeyIdx", 0)
	end
end

-- interval: 每隔多长时间执行func，单位秒
-- func: 需要执行的function
-- isloop: 是否循环func，默认为false
-- delay: 第一次tick的延迟，默认为0,可以为负数
-- Key: timer的键值,传入合法的Key，则使用；否则使用生成的Key
-- IsRealTime: 默认为false/nil会受到时间膨胀和暂停的影响，true则不受影响
function Component:AddTimer(interval, func, isloop, delay, Key, IsRealTime, ...)
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
    local Source = self:GetTimerSource(IsRealTime) or UE4.UKismetSystemLibrary
    local Timer = Source.K2_SetTimerDelegate({ self, f }, interval, isloop, delay)
    self.TimerHandles[Key] = Timer
    self.TimerHandleDatas[Timer] = {Key = Key, IsRealTime = IsRealTime, Func = f}
    return Timer, Key
end

function Component:_GetTimerInfo(Key)
    if (not Key) or (not rawget(self, "TimerHandles")) then
        return nil, nil, nil
    end
    local Timer,TimerInfo = self.TimerHandles[Key], nil
    -- 传入的Key是字符串Key
    if Timer ~= nil then
        -- 找到TimerInfo
        TimerInfo = self.TimerHandleDatas[Timer]
    -- 传入的Key是TimerHandle
    elseif type(Key) == "userdata" then
        Timer = Key
        -- 找到TimerInfo
        TimerInfo = self.TimerHandleDatas[Key]
        -- 这个Timer已经清掉了
        if not TimerInfo then
            return
        end
        Key = TimerInfo.Key
    -- 什么都没找到，return
    else
        return nil, nil, nil
    end

    return Key, Timer, TimerInfo
end

function Component:RemoveTimer(KeyOrTimer, bNotCallRemoveHandler)
    -- PrintTable({RemoveTimer=KeyOrTimer})
    if KeyOrTimer == nil or not rawget(self, "TimerHandles") then
        return
    end

    local TimerInfo = nil
    local Key, Timer, TimerInfo = self:_GetTimerInfo(KeyOrTimer)
    if not Key then
        return
    end

    -- 是否是实时定时器
    local IsRealTime = TimerInfo.IsRealTime
    -- 是否是战斗定时器
    local IsCombatTime = TimerInfo.IsCombatTime
    if IsCombatTime then
        self:ClearTimer_Combat(Timer)
    else
        local Source = self:GetTimerSource(IsRealTime) or UE4.UKismetSystemLibrary
        Source.K2_ClearAndInvalidateTimerHandle(self, Timer)
    end 
    if not bNotCallRemoveHandler then
        self:RemoveTimerHandler(TimerInfo.Func)
    end

    self.TimerHandles[Key] = nil
    self.TimerHandleDatas[Timer] = nil
end

function Component:PauseTimer(KeyOrTimer)
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
    -- 是否是战斗定时器
    local IsCombatTime = TimerInfo.IsCombatTime
    if IsCombatTime then
        self:PauseTimer_Combat(Timer)
    else
        local Source = self:GetTimerSource(IsRealTime) or UE4.UKismetSystemLibrary
        Source.K2_PauseTimerHandle(self, Timer)
    end
end

function Component:UnPauseTimer(KeyOrTimer)
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
    -- 是否是战斗定时器
    local IsCombatTime = TimerInfo.IsCombatTime
    if IsCombatTime then
        self:UnPauseTimer_Combat(Timer)
    else
        local Source = self:GetTimerSource(IsRealTime) or UE4.UKismetSystemLibrary
        Source.K2_UnPauseTimerHandle(self, Timer)
    end
end

function Component:IsExistTimer(KeyOrTimer)
    if KeyOrTimer == nil then
        return false
    end
    local Key, Timer, TimerInfo = self:_GetTimerInfo(KeyOrTimer)
    if not Key then
        return false
    end
    return rawget(self, "TimerHandles") and (self.TimerHandles[Key] ~= nil)
end

function Component:CleanTimer()
    -- PrintTable({CleanTimer=1})
    if rawget(self, "TimerHandles") == nil then
        return
    end
    for Key, Value in pairs(self.TimerHandles) do
        self:RemoveTimer(Key)
    end
    self.TimerHandles = {}
    self.TimerHandleDatas = {}
end

function Component:GetTimerRemainingTime(KeyOrTimer)
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
    -- 是否是战斗定时器
    local IsCombatTime = TimerInfo.IsCombatTime
    if IsCombatTime then
        return self:GetTimerRemainingTimeHandle_Combat(Timer)
    else
        local Source = self:GetTimerSource(IsRealTime) or UE4.UKismetSystemLibrary
        return Source.K2_GetTimerRemainingTimeHandle(self, Timer)
    end
end

function Component:GetTimerSource(IsRealTime)
    if IsRealTime then 
        return URuntimeCommonFunctionLibrary
    else
        return UE4.UKismetSystemLibrary
    end
end

-- Combat Timer
function Component:AddTimer_Combat(interval, func, isloop, delay, Key, ...)
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
    local Timer = self:SetTimerDelegate_Combat({self, f}, interval, isloop, delay, 0)
    self.TimerHandles[Key] = Timer
    self.TimerHandleDatas[Timer] = {Key = Key, IsCombatTime = true, Func = f}
    if isloop then
        self:RegisterLoopTimerHandler(f)
    end
    return Timer, Key
end
-- Combat Timer

return Component
local Component = {}

function Component:ReceiveBeginPlay()
    rawset(self, "EMLuaTickManager", USubsystemBlueprintLibrary.GetWorldSubsystem(self, UEMLuaTickManagerSubsystem))
end

function Component:AddDelayFrameFunc(Func, DelayFrame, Key, ...)
    if not rawget(self, "EMLuaTickManager") then
        rawset(self, "EMLuaTickManager", USubsystemBlueprintLibrary.GetWorldSubsystem(self, UEMLuaTickManagerSubsystem))
    end
    if not IsValid(self.EMLuaTickManager) then
        return
    end
    -- Tick的执行顺序是Actor-动画-其他Component
    -- DelayFrame的值在触发调用的情况需要考虑执行顺序，不然只会在当前帧延迟执行，并不会到下一帧
    self.EMLuaTickManager:AddDelayFrameFunc(self, Func, DelayFrame, Key, ...)
end

return Component
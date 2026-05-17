local Component = {}

function Component:ReceiveInitialize()
    self.DelayFuncs = {}
end

function Component:ReceiveTick(DeltaSeconds)
    if not self.DelayFuncs then
        return
    end
    local TmpInvalidObjs = {}
    for Obj, DelayFuncs in pairs(self.DelayFuncs) do
        if IsValid(Obj) then
            for k, v in pairs(DelayFuncs) do
                v.DelayFrame = v.DelayFrame - 1
                if v.DelayFrame > 0 then
                    -- TempDelayFuncs[k] = v 
                else
                    v.Func(table.unpack(v.Params))
                    self.DelayFuncs[Obj][k] = nil
                    if not next(self.DelayFuncs[Obj]) then
                        table.insert(TmpInvalidObjs, Obj)
                    end
                end
            end
        else
            table.insert(TmpInvalidObjs, Obj)
        end
    end
    for _, v in pairs(TmpInvalidObjs) do
        self.DelayFuncs[v] = nil
        if not next(self.DelayFuncs) then
            self.bAllowTick = false
        end
    end
end

function Component:AddDelayFrameFunc(Object, Func, DelayFrame, Key, ...)
    -- Tick的执行顺序是Actor-动画-其他Component
    -- DelayFrame的值在触发调用的情况需要考虑执行顺序，不然只会在当前帧延迟执行，并不会到下一帧
    if not DelayFrame then
        DelayFrame = 1
    end
    if not Object then
        return
    end
    if not self.DelayFuncs then
        self.DelayFuncs = {}
    end
    if not self.DelayFuncs[Object] then
        self.DelayFuncs[Object] = {}
    end
    if Key then
        self.DelayFuncs[Object][Key] = { DelayFrame = DelayFrame, Func = Func, Params = { ... } }
    else
        table.insert(self.DelayFuncs[Object], { DelayFrame = DelayFrame, Func = Func, Params = { ... } })
    end
    if self.bAllowTick == false then
        self.bAllowTick = true
    end
end

return Component
---@class CountTrigger_C
local CountTrigger_C = {}
CountTrigger_C.New = function(Count, Callback)
    ---@type CountTrigger_C
    local Obj = setmetatable({}, {
        __index = CountTrigger_C
    })
    Obj.Count = Count
    Obj.CurrentCount = 0
    Obj.Callback = Callback
    return Obj
end

function CountTrigger_C:CountIncrement()
    self.CurrentCount = self.CurrentCount + 1
    DebugPrint("CountIncrement", self.CurrentCount, self.Count)
    if (self.CurrentCount == self.Count) then
        if(self.Callback) then
            self.Callback.Func(self.Callback.Obj)
        end
    end
end

return CountTrigger_C

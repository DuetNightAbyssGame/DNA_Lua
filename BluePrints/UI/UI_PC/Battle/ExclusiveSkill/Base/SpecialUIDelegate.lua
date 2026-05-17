---@class FLuaDelegate
---@field protected Table table
---@field protected Func function
local FLuaDelegate = {}

---@field protected Table table
---@field protected Func function
FLuaDelegate.New = function(Table, Func)
    local Delegate = setmetatable({}, {
        __index = FLuaDelegate
    })
    Delegate:Bind(Table, Func)
    return Delegate
end

---@field protected Table table
---@field protected Func function
function FLuaDelegate:Bind(Table, Func)
    self.Table = Table
    self.Func = Func
end

function FLuaDelegate:UnBind()
    self.Table = nil
    self.Func = nil
end

function FLuaDelegate:IsValid()
    return self.Table and self.Func
end

function FLuaDelegate:Execute(...)
    self.Func(self.Table, ...)
end

function FLuaDelegate:ExecuteIfBound(...)
    if self:IsValid() then
        self:Execute(...)
    end
end

return FLuaDelegate

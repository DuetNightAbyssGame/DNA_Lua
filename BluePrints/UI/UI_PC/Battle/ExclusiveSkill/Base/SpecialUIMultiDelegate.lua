local FLuaDelegate = require "BluePrints.UI.UI_PC.Battle.ExclusiveSkill.Base.SpecialUIDelegate"

---@class FLuaMultiDelegate
---@field protected Delegates FLuaDelegate[]
local FLuaMultiDelegate = {}

FLuaMultiDelegate.New = function()
    local MultiCastDelegate = setmetatable({}, {
        __index = FLuaMultiDelegate
    })
    MultiCastDelegate.Delegates = {}
    return MultiCastDelegate
end

---@param Table table
---@param Func function
function FLuaMultiDelegate:Add(Table, Func)
    self.Delegates[Table] = self.Delegates[Table] or {}
    local FunDelegates = self.Delegates[Table]
    FunDelegates[Func] = FLuaDelegate.New(Table, Func)
end

---@param Table table
---@param Func function
function FLuaMultiDelegate:Remove(Table, Func)
    local FunDelegates = self.Delegates[Table]
    if FunDelegates then
        FunDelegates[Func] = nil
    end
end

---@param LuaDelegate FLuaDelegate
function FLuaMultiDelegate:AddDelegate(LuaDelegate)
    self:Add(LuaDelegate.Table, LuaDelegate.Func)
end

---@param LuaDelegate FLuaDelegate
function FLuaMultiDelegate:RemoveDelegate(LuaDelegate)
    self:Remove(LuaDelegate.Table, LuaDelegate.Func)
end

---@param Table table
function FLuaMultiDelegate:Clear(Table)
    self.Delegates[Table] = nil
end

function FLuaMultiDelegate:Execute(...)
    local NotValids = {}
    for Table, FunDelegates in pairs(self.Delegates) do
        for Func, Delegate in pairs(FunDelegates) do
            if Delegate:IsValid() then
                Delegate:Execute(...)
            else
                NotValids[Table] = Func
            end
        end
    end
    for Table, Func in pairs(NotValids) do
        self:RemoveDelegate(Table, Func)
    end
end

return FLuaMultiDelegate

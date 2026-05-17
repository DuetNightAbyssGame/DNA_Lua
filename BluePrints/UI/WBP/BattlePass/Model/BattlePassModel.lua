
--- @class BattlePassModel :Model
local M = Class("BluePrints.Common.MVC.Model")

function M:Init()
    M.Super.Init(self)
    self._ModelData = {}
    self._ModelDataRefCount = {}
end

function M:Destory()
    M.Super.Destory(self)
    self._ModelData = nil
end

--- 设置模型数据
--- @param Name string 数据名称
--- @param Value any 要设置的数据值
function M:SetModelData(Name, Value)
    if not Name or Name == "" then
        return false
    end
    if not self._ModelData then
        self:Init()
    end
    
    self._ModelData[Name] = Value
    return true
end

--- 获取模型数据
--- @param Name string 数据名称，支持点分隔的层级结构
--- @param DefaultValue any 默认值，当数据不存在时返回
--- @return any 返回对应的数据值，如果不存在则返回defaultValue
function M:GetModelData(Name, DefaultValue)
    if not Name or Name == "" then
        return DefaultValue
    end
    if not self._ModelData then
        self:Init()
    end
    
    local Value = self._ModelData[Name]
    if Value ~= nil then
        return Value
    end
    
    return DefaultValue
end

function M:AddModelDataRefCount(Name)
    if not Name or Name == "" then
        return
    end
    local RefCount = self._ModelDataRefCount[Name] or 0
    self._ModelDataRefCount[Name] = RefCount + 1
end

function M:RemoveModelDataRefCount(Name, DelFunc)
    if not Name or Name == "" or not self._ModelDataRefCount then
        return
    end
    local RefCount = self._ModelDataRefCount[Name] or 0
    if RefCount > 0 then
        self._ModelDataRefCount[Name] = RefCount - 1
    end
    if self._ModelDataRefCount[Name] <= 0 then
        if DelFunc then
            DelFunc(self._ModelData[Name])
        end
        self._ModelData[Name] = nil
    end
end

--- 清空所有数据
function M:ClearAllModelData()
    self._ModelData = {}
    self._ModelDataRefCount = {}
end

--- 获取所有数据的副本（用于调试）
--- @return table 所有数据的副本
function M:GetAllModelData()
    local Copy = {}
    for k, v in pairs(self._ModelData) do
        Copy[k] = v
    end
    return Copy
end


return M

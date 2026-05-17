
local HotFixDiff = {}


HotFixDiff.DeepDiff = function(t1, t2, path, diffs, visited)
    diffs = diffs or {}
    path = path or ""
    visited = visited or {}
    
    -- 避免循环引用
    -- local key = tostring(t1) .. ":" .. tostring(t2)
    -- if visited[key] then return diffs end
    -- visited[key] = true
    
    -- 类型不同
    if type(t1) ~= type(t2) then
        table.insert(diffs, {
            path = path,
            value1 = t1,
            value2 = t2,
            type = "type_mismatch"
        })
        return diffs
    end
    
    -- 非 table 直接比较
    if type(t1) ~= "table" then
        if t1 ~= t2 then
            table.insert(diffs, {
                path = path,
                value1 = t1,
                value2 = t2,
                type = "value_mismatch"
            })
        end
        return diffs
    end
    
    -- 收集 t1 有但 t2 没有的键
    for k, v1 in pairs(t1) do
        local currentPath = path .. (path == "" and "" or ".") .. tostring(k)
        if t2[k] == nil then
            table.insert(diffs, {
                path = currentPath,
                value1 = v1,
                value2 = nil,
                type = "missing_in_t2"
            })
        else
            -- 递归比较
            HotFixDiff.DeepDiff(v1, t2[k], currentPath, diffs, visited)
        end
    end
    
    -- 收集 t2 有但 t1 没有的键
    for k, v2 in pairs(t2) do
        local currentPath = path .. (path == "" and "" or ".") .. tostring(k)
        if t1[k] == nil then
            table.insert(diffs, {
                path = currentPath,
                value1 = nil,
                value2 = v2,
                type = "missing_in_t1"
            })
        end
    end
    
    return diffs
end

-- 美化输出差异
HotFixDiff.PrettyPrintDiff =  function(name, diffs, _print)
    _print = _print or print
    if #diffs == 0 then
        _print("name:"..tostring(name)..",No differences found")
        return
    end
    
    local msg = "name:" .. tostring(name) .. ", diff\n"
    for _, diff in ipairs(diffs) do
        msg = msg .. string.format("%s.%s", name, diff.path)
        if diff.type == "type_mismatch" then
            msg = msg .. string.format(" | Type mismatch: Before:%s vs After:%s", 
                type(diff.value1), type(diff.value2))
        elseif diff.type == "value_mismatch" then
            msg = msg .. string.format(" | Value mismatch: Before:%s vs After:%s", 
                tostring(diff.value1), tostring(diff.value2))
        elseif diff.type == "missing_in_t2" then
            msg = msg .. string.format(" | Missing in After: %s", 
                tostring(diff.value1))
        elseif diff.type == "missing_in_t1" then
            msg = msg .. string.format(" | Missing in Before: %s", 
                tostring(diff.value2))
        end
        msg = msg .. "\n"
    end
    _print(msg)
end

HotFixDiff.ShowDiff = function(name, t1, t2, _print)
    local diffs = HotFixDiff.DeepDiff(t1, t2)
    HotFixDiff.PrettyPrintDiff(name, diffs, _print)
end

return HotFixDiff
require "UnLua"
local FileNamePart = 'RpcCache'
local FileDir = UE4.UKismetSystemLibrary.GetProjectContentDirectory().."Script/Test/"..FileNamePart.."/"
local MiscUtils = require "Utils.MiscUtils"
local SerializeOnlineRpc = {}
SerializeOnlineRpc.RPC_Cache = {}
SerializeOnlineRpc.call_counter = 0
SerializeOnlineRpc.IsStartRpcCache = false
local log_file = "rpc_log.lua"
local is_initialized = false

function SerializeOnlineRpc.StartRpcCache() 
    SerializeOnlineRpc.IsStartRpcCache = true
end

function SerializeOnlineRpc.CloseRpcCache()
    SerializeOnlineRpc.IsStartRpcCache = false
end

function SerializeOnlineRpc.GetStartRpcCacheState()
    return SerializeOnlineRpc.IsStartRpcCache
end

-- 初始化函数
function SerializeOnlineRpc.InitRPCLogger()
    if not is_initialized then
        SerializeOnlineRpc.RPC_Cache = {}
        SerializeOnlineRpc.call_counter = 0
        is_initialized = true
        DebugPrint("RPC Logger initialized")
    end
end

-- 递归函数：尝试解析表的内容
local function serialize_table(t, depth)
    if depth > 3 then  -- 限制递归深度，避免无限递归
        return "{...}"
    end
    
    local result = "{"
    local count = 0
    
    -- 首先处理数组部分
    for i, v in ipairs(t) do
        if count > 0 then
            result = result .. ", "
        end
        
        local value_type = type(v)
        if value_type == "string" then
            result = result .. string.format("%q", v)
        elseif value_type == "number" or value_type == "boolean" then
            result = result .. tostring(v)
        elseif value_type == "table" then
            result = result .. serialize_table(v, depth + 1)
        else
            result = result .. string.format("%q", tostring(v) .. " (" .. value_type .. ")")
        end
        
        count = count + 1
        if count >= 10 then  -- 限制元素数量，避免输出过长
            result = result .. ", ..."
            break
        end
    end
    
    -- 然后处理键值对部分（如果有）
    for k, v in pairs(t) do
        if type(k) ~= "number" or k > #t or k < 1 then  -- 跳过数组部分已经处理过的键
            if count > 0 then
                result = result .. ", "
            end
            
            local key_type = type(k)
            local value_type = type(v)
            
            -- 处理键
            if key_type == "string" then
                result = result .. k .. " = "
            elseif key_type == "number" then
                result = result .. "[" .. k .. "] = "
            else
                result = result .. "[" .. string.format("%q", tostring(k) .. " (" .. key_type .. ")") .. "] = "
            end
            
            -- 处理值
            if value_type == "string" then
                result = result .. string.format("%q", v)
            elseif value_type == "number" or value_type == "boolean" then
                result = result .. tostring(v)
            elseif value_type == "table" then
                result = result .. serialize_table(v, depth + 1)
            else
                result = result .. string.format("%q", tostring(v) .. " (" .. value_type .. ")")
            end
            
            count = count + 1
            if count >= 20 then  -- 限制总元素数量，避免输出过长
                result = result .. ", ..."
                break
            end
        end
    end
    
    result = result .. "}"
    return result
end

-- 辅助函数：将参数转换为可序列化的格式
local function serialize_params(...)
    local params = {...}
    local serialized = {}
    
    for i, param in ipairs(params) do
        local param_type = type(param)
        
        if param_type == "string" then
            serialized[i] = string.format("%q", param)
        elseif param_type == "number" or param_type == "boolean" then
            serialized[i] = tostring(param)
        elseif param_type == "table" then
            -- 尝试解析表的内容
            serialized[i] = serialize_table(param, 1)
        else
            serialized[i] = string.format("%q", tostring(param) .. " (" .. param_type .. ")")
        end
    end
    
    return serialized
end

function SerializeOnlineRpc.log_rpc_call(func_name, ...)
    if not is_initialized then
        SerializeOnlineRpc.InitRPCLogger()
    end
    -- 确保 func_name 是字符串
    if type(func_name) ~= "string" then
        func_name = tostring(func_name)
    end
    SerializeOnlineRpc.call_counter = SerializeOnlineRpc.call_counter + 1
    local entry = {
        func_name = func_name,  -- 直接使用字符串
        Params = serialize_params(...)
    }
    -- 添加到缓存
    SerializeOnlineRpc.RPC_Cache[SerializeOnlineRpc.call_counter] = entry
    DebugPrint(string.format("RPC call logged: %s (total: %d)", func_name, SerializeOnlineRpc.call_counter))
end

-- 手动保存RPC调用到文件
function SerializeOnlineRpc.SaveRPCCalls()
    if not is_initialized or SerializeOnlineRpc.call_counter == 0 then
        DebugPrint("No RPC calls to save")
        return false
    end
    
    -- 确保目录存在
    if not UE4.UBlueprintFileUtilsBPLibrary.DirectoryExists(FileDir) then
        DebugPrint("创建本地缓存明文目录: " .. FileDir)
        UE4.UBlueprintFileUtilsBPLibrary.MakeDirectory(FileDir)
    end
    
    -- 写入Lua文件
    local file_path = FileDir .. log_file
    local file = io.open(file_path, "w")
    if file then
        file:write("-- RPC调用记录文件（只读）\n")
        file:write("-- 自动生成，请勿手动编辑\n\n")
        file:write("local RPC_Cache = {\n")
        
        for i, call in ipairs(SerializeOnlineRpc.RPC_Cache) do
            file:write(string.format("\t[%d] = {\n", i))
            file:write(string.format("\t\tfunc_name = %q,\n", call.func_name))  -- 使用 %q 确保字符串被正确引用
            
            file:write("\t\tParams = {")
            for j, param in ipairs(call.Params) do
                if j > 1 then
                    file:write(", ")
                end
                file:write(param)
            end
            file:write("}\n")
            
            file:write("\t},\n")  -- 确保每个条目正确闭合
        end
        
        file:write("}\n\n")  -- 确保表正确闭合
        file:write("return RPC_Cache\n")
        file:close()
        DebugPrint(string.format("RPC calls saved to %s (%d calls)", file_path, SerializeOnlineRpc.call_counter))
        return true
    else
        DebugPrint("Error: Could not open file for writing: " .. file_path)
        return false
    end
end

-- 清空缓存
function SerializeOnlineRpc.ClearRPCCache()
    SerializeOnlineRpc.RPC_Cache = {}
    SerializeOnlineRpc.call_counter = 0
    DebugPrint("RPC cache cleared")
end

-- 获取当前缓存中的调用数量
function SerializeOnlineRpc.GetRPCCallCount()
    return SerializeOnlineRpc.call_counter
end

-- 初始化日志记录器
SerializeOnlineRpc.InitRPCLogger()

return SerializeOnlineRpc
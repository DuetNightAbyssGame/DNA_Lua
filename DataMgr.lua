_G.DataMgr = setmetatable({},{
    __index = function(t, key)
        local OK, Table = pcall(require, "Datas."..key)
        if not OK then Table = nil end
        return Table
    end})

function DataMgr.LocalTimeProxy(_value)
    return setmetatable({
            __Time = true,
            RawTable = true,
            GetTime = function()
                return TimeUtils.TimestampToServerTimestamp(_value)
            end,
        }, {
        __add = function(a, b)
            if type(a) == 'table' and a.__Time then
                a = a.GetTime()
            end
            if type(b) == 'table' and b.__Time then
                b = b.GetTime()
            end
            return a + b
        end,
        
        __sub = function(a, b)
            if type(a) == 'table' and a.__Time then
                a = a.GetTime()
            end
            if type(b) == 'table' and b.__Time then
                b = b.GetTime()
            end
            return a - b
        end,
        
        __mul = function(a, b)
            if type(a) == 'table' and a.__Time then
                a = a.GetTime()
            end
            if type(b) == 'table' and b.__Time then
                b = b.GetTime()
            end
            return a * b
        end,
        
        __div = function(a, b)
            if type(a) == 'table' and a.__Time then
                a = a.GetTime()
            end
            if type(b) == 'table' and b.__Time then
                b = b.GetTime()
            end
            return a / b
        end,
        
        __lt = function(a, b)
            if type(a) == 'table' and a.__Time then
                a = a.GetTime()
            end
            if type(b) == 'table' and b.__Time then
                b = b.GetTime()
            end
            return a < b
        end,
        
        __le = function(a, b)
            if type(a) == 'table' and a.__Time then
                a = a.GetTime()
            end
            if type(b) == 'table' and b.__Time then
                b = b.GetTime()
            end
            return a <= b
        end,
        
        __eq = function(a, b)
            if type(a) == 'table' and a.__Time then
                a = a.GetTime()
            end
            if type(b) == 'table' and b.__Time then
                b = b.GetTime()
            end
            return a == b
        end,
        
        __tostring = function(t)
            return tostring(t.GetTime())
        end
    })
end
    

function DataMgr.Print_t ( t )
    -- print table
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

function DataMgr.GetData(filename)
    local pro_path = UE4.UKismetSystemLibrary.GetProjectContentDirectory()
    local file = io.open(pro_path..'../Datas/'..filename .. '.json', "r")
    local info = file:read("*a")
    file:close()
    local json= require("rapidjson")
    local res = json.decode(info)
    return res
end

function DataMgr.GetLevelLoaderJsonData(shortname)
    local pro_path = UE4.UKismetSystemLibrary.GetProjectContentDirectory()
    local path=pro_path..'Script/Datas/Houdini_data/'..shortname .. '.json'
    local info = UE4.URuntimeCommonFunctionLibrary.LoadFile(path)
    -- local file = io.open(path, "r")
    -- local info = file:read("*a")
    -- file:close()
    local json= require("rapidjson")
    local res = json.decode(info)
    return res
end

-- 预加载数据表，将所有的数据表全部加载到内存中，减少之后读表index的时间消耗
function DataMgr.PreLoad()
    local DataNames = require("Datas.DataNames")
    for _, DataName in pairs(DataNames) do
        require("Datas."..DataName)
    end
end

local all_tables = {}

function DataMgr.CollectTable(Table)
    for k, tbl in pairs(all_tables) do
        if tbl == Table then
            all_tables[k] = nil
            for k, v in pairs(tbl) do
                if type(v) == "table" then
                    DataMgr.CollectTable(v)
                end
            end
            break
        end
    end
end

DataMgr.PartitionCache = {
	Cache = {},
	MaxPartitionsPerFile = 10  -- 每个文件最多缓存10个分区
}

local function GetMaxPartitionsByFileName(FileName)
    local MaxVal = DataMgr.PartitionCache.MaxPartitionsPerFile
    if not FileName or FileName == "" then
        return MaxVal
    end

    -- 定义关键字到上限的映射
    local CacheLimitArray = {
        ["Talk_Sound"] = 10,
        ["Dialogue_Content"] = 2,
        ["DialogueConvert"] = 2
    }

    -- 遍历映射，匹配包含关系，取最大值
    for key, val in pairs(CacheLimitArray) do
        if string.find(FileName, key, 1, true) then
            MaxVal = val
        end
    end

    return MaxVal
end


-- 二分查找实现
function DataMgr.BinarySearch(Key, DataIndexTable)
    local Low, High = 1, #DataIndexTable
    while Low <= High do
        local Mid = math.floor((Low + High) / 2)
        local Entry = DataIndexTable[Mid]
        if Key >= Entry.MinKey and Key <= Entry.MaxKey then
            return Entry.Loader(), Entry.MinKey, Entry.MaxKey
        elseif Key < Entry.MinKey then
            High = Mid - 1
        else
            Low = Mid + 1
        end
    end
    return nil
end

-- 更新文件的分区LRU队列
local function UpdatePartitionLRU(FileName, PartitionKey)
    local FileCache = DataMgr.PartitionCache.Cache[FileName]
    if not FileCache then return end

    -- 从LRU队列中移除旧位置（如果存在）
    for i, key in ipairs(FileCache.LRUQueue) do
        if key == PartitionKey then
            table.remove(FileCache.LRUQueue, i)
            break
        end
    end

    -- 添加到队列头部
    table.insert(FileCache.LRUQueue, 1, PartitionKey)
end

function DataMgr.QueryTable(Key, FileName, Data)
    local Cache = DataMgr.PartitionCache

    -- 1. 获取或初始化文件缓存
    local FileCache = Cache.Cache[FileName]
    if not FileCache then
        local Limit = GetMaxPartitionsByFileName(FileName)
        FileCache = {
            Partitions = {},  -- 分区缓存: { "Min:Max" => {Data, MinKey, MaxKey} }
            LRUQueue = {},    -- 该文件的分区LRU队列
            MaxPartitions = Limit
        }
        Cache.Cache[FileName] = FileCache
    end

    -- 2. 检查缓存中是否已有匹配分区
    for PartitionKey, CachedPartition in pairs(FileCache.Partitions) do
        if Key >= CachedPartition.MinKey and Key <= CachedPartition.MaxKey then
            UpdatePartitionLRU(FileName, PartitionKey)
            return CachedPartition.Data[Key]
        end
    end

    -- 3. 缓存未命中，从文件加载
    local PartitionData, MinKey, MaxKey = DataMgr.BinarySearch(Key, Data)
    if not (PartitionData and PartitionData[Key]) then return nil end

    -- 4. 缓存新分区
    local PartitionKey = MinKey .. ":" .. MaxKey
    FileCache.Partitions[PartitionKey] = {
        Data = PartitionData,
        MinKey = MinKey,
        MaxKey = MaxKey
    }

    -- 更新LRU队列
    UpdatePartitionLRU(FileName, PartitionKey)

    -- 5. 如果超出最大分区数，淘汰最久未使用的
    if #FileCache.LRUQueue > FileCache.MaxPartitions then
        local OldestKey = table.remove(FileCache.LRUQueue)
        FileCache.Partitions[OldestKey] = nil
    end

    return PartitionData[Key]
end

function DataMgr.GetPartitionData(Key, Data)
    local PartitionData, MinKey, MaxKey = DataMgr.BinarySearch(Key, Data)
    if not (PartitionData and PartitionData[Key]) then
        return nil
    end
    return PartitionData
end

DataMgr.ReadOnly_NewIndex = function(t, k, v)
    local rawset = rawset
    local getmetatable = getmetatable
    error("没法对导表数据【" .. tostring(t.__name) .."】中字段【" .. tostring(k) .. "】进行写操作")
end

function DataMgr.CleanAllTable()
    all_tables = {}
    local DataNames = require("Datas.DataNames")
    local HotFix = require("HotFix")
    local data_module_table = rawget(HotFix, "data_module_table")
    for _, DataName in pairs(DataNames) do
        if not (data_module_table and data_module_table[DataName]) then
            require("UnLuaHotReload").RemoveLoadedModule("Datas."..DataName)
        end
    end
end

local function read_only(name, tbl)
    if not all_tables[tbl] then
        local tbl_mt = getmetatable(tbl)
        if not tbl_mt then
            tbl_mt = {}
            setmetatable(tbl, tbl_mt)
        end

        local proxy = tbl_mt.__read_only_proxy
        if not proxy then
            proxy = {__name = name}
            tbl_mt.__read_only_proxy = proxy
            local proxy_mt = {
                __index = tbl,
                __newindex = DataMgr.ReadOnly_NewIndex,
                __pairs = function (t) return pairs(tbl) end,
                -- __ipairs = function (t) return ipairs(tbl) end,   5.3版本不需要此方法
                __len = function (t) return #tbl end,
                __read_only_proxy = proxy
            }
            setmetatable(proxy, proxy_mt)
        end
        all_tables[tbl] = proxy
        for k, v in pairs(tbl) do
            if type(v) == "table" then
                if not rawget(v, "RawTable") then
                    tbl[k] = read_only(name, v)
                end
            end
        end
    end
    return all_tables[tbl]
end

if URuntimeCommonFunctionLibrary.IsDebugDataTable() then
    DataMgr.ReadOnly = read_only
else
    DataMgr.ReadOnly = function (name, tbl) 
        return tbl 
    end
end

return DataMgr

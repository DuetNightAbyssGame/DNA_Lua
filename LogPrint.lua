

local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
local bEnableShippingLog = UE4.URuntimeCommonFunctionLibrary.EnableLogInShipping()
local EmptyFunction = function() end
_G.DebugPrint = (bDistribution and not bEnableShippingLog) and EmptyFunction or function (...)
    for _, Param in ipairs(table.pack(...)) do
        if Param == ErrorTag then
            LogError(_G.LogTag," [Debug Log]: ", ...)
            return
        end
        if Param == WarningTag then
            LogWarn(_G.LogTag," [Debug Log]: ", ... )
            return 
        end
    end
    print(_G.LogTag," [Debug Log]: ", ...)
end

_G.DebugNetPrint = (bDistribution and not bEnableShippingLog) and EmptyFunction or function (...)
    netprint(_G.LogTag," [Debug Log]: ", ...)
end

--region 自定义开发者专属的标记，方便查找日志
_G.LXYTag = "lxy#"
_G.TXTTag = "txt#"  
--endregion

local function NStr(n,str)
    local sumStr=""
    for i=1,n do
        sumStr=sumStr..str
    end
    return sumStr
end

local function PrintTable_internal(tableMemory,deep,table,maxDepth)
    if(maxDepth and deep>maxDepth) then
        return
    end
    for k,v in pairs(table) do
        if(type(v)=="table") then
            DebugPrint(string.format("%s%q : %q",NStr(deep,"---"),tostring(k),tostring(v)))
            if(tableMemory[v]==nil) then
                tableMemory[v]=true
                PrintTable_internal(tableMemory,deep+1,v,maxDepth)
            end
        else
            DebugPrint(string.format("%s%q : %q",NStr(deep,"---"),tostring(k),tostring(v)))
        end
    end
end

_G.DebugPrintTable= (bDistribution and not bEnableShippingLog) and EmptyFunction or function(table,maxDepth)
    local tableMemory={}
    tableMemory[table]=true
    if(type(table)~="table") then
        error(tostring(table).." is not a table!")
        return
    end
    DebugPrint(string.format("Print Table: %q",tostring(table)))
    PrintTable_internal(tableMemory,1,table,maxDepth)
end

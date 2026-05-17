local LogManager = {}
local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
local bEnableShippingLog = UE4.URuntimeCommonFunctionLibrary.EnableLogInShipping()
local EmptyFunction = function() end

function LogManager:GenLogger(Id, ModuleName)
    local Logger = {}

    Logger.info = (bDistribution and not bEnableShippingLog) and EmptyFunction or function (...)
        if Id and ModuleName then
            DebugPrint("["..CommonUtils.ObjId2Str(Id).." "..ModuleName.."]", ...)
        else
            DebugPrint(...)
        end
    end

    Logger.debug = (bDistribution and not bEnableShippingLog) and EmptyFunction or function (...)
        if Id and ModuleName then
            DebugPrint("["..CommonUtils.ObjId2Str(Id).." "..ModuleName.."]", ...)
        else
            DebugPrint(...)
        end
    end

    Logger.error = (bDistribution and not bEnableShippingLog) and EmptyFunction or function (...)
        if Id and ModuleName then
            DebugPrint("["..CommonUtils.ObjId2Str(Id).." "..ModuleName.."]", ...)
        else
            DebugPrint(...)
        end
    end

    return Logger
end

function LogManager:GenClientLogger(Id, ModuleName)
    local Logger = {}

    Logger.info = (bDistribution and not bEnableShippingLog) and EmptyFunction or function (...)
        if Id and ModuleName then
            DebugPrint("["..CommonUtils.ObjId2Str(Id).." "..ModuleName.."]", ...)
        else
            DebugPrint(...)
        end
    end

    Logger.debug = (bDistribution and not bEnableShippingLog) and EmptyFunction or function (...)
        if Id and ModuleName then
            DebugPrint("["..CommonUtils.ObjId2Str(Id).." "..ModuleName.."]", ...)
        else
            DebugPrint(...)
        end
    end

    Logger.error = (bDistribution and not bEnableShippingLog) and EmptyFunction or function (...)
        local Function = UE.UFormulaFunctionLibrary.ShowError
        local str
        if Id and ModuleName then
            str = "["..CommonUtils.ObjId2Str(Id).." "..ModuleName.."]"..tostring(...)
        else
            str = tostring(...)
        end
        Function(GWorld.GameInstance, str)
        Traceback()
    end

    Logger.errorlog = (bDistribution and not bEnableShippingLog) and EmptyFunction or function(...)
        local Function = UE.UFormulaFunctionLibrary.ShowErrorOnlyLog
        local str
        if Id and ModuleName then
            str = "["..CommonUtils.ObjId2Str(Id).." "..ModuleName.."]"..tostring(...)
        else
            str = tostring(...)
        end
        Function(str)
    end

    return Logger
end



return LogManager

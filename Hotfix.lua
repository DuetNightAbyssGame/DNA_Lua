
local HotFixDiff = require "HotFixDiff"

local HotFix = {}

HotFix.ShowDiff = HotFixDiff.ShowDiff

function HotFix.ShowUpValue(show_function)
	DebugPrint("---------ShowUpValue Start---------")
	local i = 1
	while true do
		local name, upvalue = debug.getupvalue(show_function, i)
		DebugPrint("upvalue",name, i, upvalue)
		if name == nil or name == "" then
			break
		end
		i = i + 1
	end
	DebugPrint("---------ShowUpValue End---------")
end

function HotFix.HotFixFunction(old_function, new_function)
	DebugPrint("HotFixFunction", old_function, new_function)

	-- HotFix.ShowUpValue(new_function)
	-- HotFix.ShowUpValue(old_function)


	local i = 1
	while true do
		local name, new_upvalue = debug.getupvalue(new_function, i)
		if name == nil or name == "" then
			break
		end

		DebugPrint("setupvalue,name:", name, ",i:", i, ",old_function:", old_function, ",new_upvalue:", new_upvalue)
		debug.setupvalue(old_function, i, new_upvalue)
		i = i + 1
	end

	debug.replace_function(old_function, new_function)

	-- HotFix.ShowUpValue(new_function)
end

function HotFix.HotFixReference(module, name, new_value)

	local ref_tables = module.ref_tables
	if not ref_tables then
		return
	end
	for _, ref_table in ipairs(ref_tables) do
		-- PrintTable({Replace=ref_table,name=name,new_value=new_value})
		ref_table[name] = new_value
	end
end

HotFix.NewValues = {}
function HotFix.HotFix(module, name, new_value)
	-- 把新值引用住，不被gc掉
	table.insert(HotFix.NewValues, new_value)
	local old_value = module[name]
	if old_value == new_value then
		return true
	end
	if old_value == nil or new_value == nil then
		-- 新增函数或者变量，直接设置
		-- 删除函数或者变量，直接设置
		module[name] = new_value
		if type(old_value) == 'function' or type(new_value) == 'function' then
			HotFix.HotFixReference(module, name, new_value)
		end
	elseif type(old_value) ~= 'function' then
		-- 旧值不是函数，直接设置，不管新值是函数还是变量，但是不更新反向索引
		module[name] = new_value
	elseif type(new_value) ~= 'function' then
		-- 新值不是函数，直接设置，不管新值是函数还是变量，但是不更新反向索引
		module[name] = new_value
	else
		-- 这里肯定新值和旧值都是函数
		local ok, ret = pcall(HotFix.HotFixFunction, old_value, new_value)
		if not ok then
	        ScreenPrint("HotFix执行失败!name:[" .. tostring(name) .. "],ret:" .. tostring(ret))
	        HotFix.Success = false
	        return false
	    end
	end

	return true
end

function HotFix.CopyDataMgr(Object)
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		end
		local new_table = {}
		for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return new_table
	end
	return _copy(Object)
end

function HotFix.DataChangeLog(msg)
	color = color or UE4.FLinearColor(1, 0, 0, 1)
    duration = 999
	UE4.UKismetSystemLibrary.PrintString(nil, msg, true, true, color, duration)
end

function HotFix.ExecHotFix(Index, ScriptData, Debug)
	local LocalFunctionPrefixStr = [[
		HotFixModule.Success = true
		HotFix(_G, "Get_G", function(...)
			return _G
		end)
		HotFix(DataMgr, "ReadOnly_NewIndex", function(t, k, v)
			local mt = getmetatable(t)
			if type(v) == 'table' then
				v = DataMgr.ReadOnly('Hotfix', v)
			end
			rawset(mt.__index, k, v)
		end)
		local data_module_names = {}
		HotFixModule.data_module_table = {}
		local ChangedDatas = {}
		local mt = getmetatable(DataMgr)
		local old_index = mt.__index
		mt.__index = function(t, key)
			table.insert(data_module_names, key)
			HotFixModule.data_module_table[key] = 1
			local Module = require("Datas."..key)
			if Debug and not ChangedDatas[key] then
				ChangedDatas[key] = {HotFixModule.CopyDataMgr(Module), Module}
			end
	        return Module
	    end
	    setmetatable(DataMgr, mt)
	]]
	local LocalFunctionsuffixStr = [[
		mt.__index = old_index
	    setmetatable(DataMgr, mt)
	    if data_module_names then
	    	GWorld.GameInstance:ReloadDataTablesByModuleName(data_module_names)
	    end

	    if Debug then
			for Name, Info in pairs(ChangedDatas) do
				HotFixModule.ShowDiff("DataMgr."..tostring(Name), Info[1], Info[2], HotFixModule.DataChangeLog)
			end
		end
		return HotFixModule.Success
	]]
    local ExecStr = "return function(HotFixModule, HotFix, Debug)\n" .. LocalFunctionPrefixStr .. ScriptData .. "\n" .. LocalFunctionsuffixStr .. "\nend"

    local ok, HotFixExecFunction = pcall(_G.load, ExecStr)
    if not ok then
        ScreenPrint("HotFix执行失败1,请检查HotFix代码编写是否正确:[" .. tostring(ExecStr) .. "]" .. tostring(HotFixExecFunction))
        return
    end

    local ok, HotFixFunction = pcall(HotFixExecFunction)
    if not ok then
        ScreenPrint("HotFix执行失败2,请检查HotFix代码编写是否正确:[" .. tostring(ExecStr) .. "]" .. tostring(HotFixFunction))
        return
    end
    if not HotFixFunction(HotFix, HotFix.HotFix, Debug) then
    	return
    end
    print(LogTag, "HotFix执行成功:[" .. tostring(ExecStr) .. "]")
end

return HotFix
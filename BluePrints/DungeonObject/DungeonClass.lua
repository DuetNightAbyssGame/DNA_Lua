
local GlobalFunction = require "BluePrints.DungeonObject.GlobalFunction"

-- DungeonClass不支持自动更新，是局内的环境
local DungeonClass = {}

DungeonClass.ClearPackageFunc = nil

local function copy_table(source, target)
	-- 复制
	for k,v in pairs(source) do
		repeat
			if k == "__index" or k == "__newindex" or k == "Super" then
				break
			end
			if type(v) == "function" then
				rawset(target, k, v)
			end
		until true
	end
end

DungeonClass.Class = function(super_name)
	local new_class = {}
	new_class.Super = nil

	if super_name then
		if DungeonClass.ClearPackageFunc then
			DungeonClass.ClearPackageFunc(super_name)
		end
		local require_module = require (super_name)
		new_class.Super = require_module
		copy_table(require_module, new_class)
	end

	setmetatable(new_class, {
		__call = function(self, ...)
			local obj = {}
			setmetatable(obj, {
				__index = new_class,
			})

			if obj.__Init__ then
				obj:__Init__(...)
			end

			return obj
		end
	})
	return new_class
end

local UseGlobalFunction = true
DungeonClass.FixFunction = function(Func)
	if UseGlobalFunction then
		local i = 1
		while true do
			local name, upvalue = debug.getupvalue(Func, i)
			if name == nil or name == "" then
				break
			end
			if name == '_ENV' then
				debug.setupvalue(Func, i, GlobalFunction)
			end
			i = i + 1
		end
	end
	return Func
end

DungeonClass.AssembleComponents = function(M, ExceptionList)
	if rawget(M, "__AssembleComponents__") then
		return
	end
	local NameToFuncTable = {}
	for name, value in pairs(M) do
		if type(value) == "function" then
			if NameToFuncTable[name] == nil then
				NameToFuncTable[name] = {}
			end
			table.insert(NameToFuncTable[name], DungeonClass.FixFunction(value))
		end
	end

	local components = rawget(M, "__Component__")
	if type(components) == "table" then
		for _, component_name in ipairs(components) do
			if DungeonClass.ClearPackageFunc then
				DungeonClass.ClearPackageFunc(component_name)
			end
			local component = require(component_name)
			for name, value in pairs(component) do
				if type(value) == "function" then
					if NameToFuncTable[name] == nil then
						NameToFuncTable[name] = {}
					end
					table.insert(NameToFuncTable[name], DungeonClass.FixFunction(value))
				end
			end
		end
	end

	for name, func_t in pairs(NameToFuncTable) do
		if #func_t == 1 then
			rawset(M, name, func_t[1])
		else
			local _wrapper = function(...)
				for _, func in ipairs(func_t) do
					func(...)
				end
			end
			_wrapper = DungeonClass.FixFunction(_wrapper)
			rawset(M, name, _wrapper)
		end
	end

	rawset(M, "__AssembleComponents__", 1)
	return M
end

rawset(GlobalFunction, "DungeonClass", DungeonClass)
_G.DungeonClass = DungeonClass
return DungeonClass
local ClassMgr = require "NetworkEngine.Common.ClassManager"
local PropUtils = require "BluePrints.Client.PropUtils"

local Decorator = {}

local function GetArgsName(fun)
	local args = {}

	local hook = function (...)
		local info = debug.getinfo(3)
		if info.name ~= "pcall" then
			return
		end
		for i = 1, math.huge do
			local name, value = debug.getlocal(2, i)
			if name == '(*temporary)' or name == "(temporary)" or not name then
				debug.sethook()
				error('')
				return
			end
			args[i] = name
		end
	end

	debug.sethook(hook, "c")
	pcall(fun)

	return args
end

-- 忽略字符串首尾的空白字符
local function trim(input)
	return (string.gsub(input, "^%s*(.-)%s*$", "%1"))
end

local function SplitAndTrim(str, reps)
	local Results = {}
	string.gsub(str,'[^'..reps..']+', function ( w ) table.insert(Results, trim(w)) end)
	return Results
end

function Decorator:AddDecorator(Func)
	if not self.Decorators then
		self.Decorators = {}
	end
	table.insert(self.Decorators, Func)
end

local LuaBaseTypes = {
	["Int"] = "number",
	["Float"] = "number",
	["number"] = "number",
	["Callback"] = "number",
	["Str"] = "string",
	["string"] = "string",
	["Bool"] = "boolean",
	["boolean"] = "boolean",
	["table"] = "table",
}

function Decorator:Rpc(args)
	self:AddDecorator(
		function (FuncName, f)
			local args_type = SplitAndTrim(args, ",")
			GWorld:AddRpcFunc(FuncName)
			local NewFunc = function (obj, ...)
				local args_value = {...}
				if #args_type ~= #args_value then
					error(string.format("The argument number is not match, %s need %d args, but %d args are given", FuncName, #args_type, #args_value))
				end
				for index, arg in ipairs(args_value) do
					local arg_type = args_type[index]
					if LuaBaseTypes[arg_type] then
						if type(arg) ~= LuaBaseTypes[arg_type] then
							error(string.format("The argument type is not match, %s %s arg need %s, but %s is given", FuncName, index, arg_type, type(arg)))
						end
						if arg_type == "Int" and math.type(arg) ~= "integer" then
							error(string.format("The argument type is not match, %s %s arg need Int, but %s is given", FuncName, index, math.type(arg)))
						end
					elseif arg_type == "ObjId" then
						if not PropUtils.IsObjId(arg) then
							error(string.format("The argument type is not match, %s %s arg need ObjId", FuncName, index))
						end
					else
						local real_type = ClassMgr:GetType(arg_type)
						if not real_type then
							error(string.format("The argument type is error, %s %s arg %s", FuncName, index, arg_type))
						end
						if arg.__Class__ ~= real_type then
							error(string.format("The argument class is not match, %s %s arg need %s, but %s is given", FuncName, index, arg_type, arg.__Name__))
						end
					end
				end
				f(obj, ...)
			end
			return NewFunc
		end
	)
end

function Decorator:BlockAllUIInput(RPCName)
	self:AddDecorator(function (FuncName, f)
		local NewFunc = function(obj, ...)
			if obj.__Name__ == "Avatar" then
				if not obj.BlockUIMarks then 
					obj.BlockUIMarks = {}
				end
				if not obj.BlockUIMarks[RPCName] then
					obj.BlockUIMarks[RPCName] = 1
					DebugPrint(LXYTag, "Decorator:BlockAllUIInput", RPCName)
					UIManager(GWorld.GameInstance):_BlockAllUIInput(true, RPCName)
				end
			end
			f(obj, ...)
		end
		return NewFunc
	end)
end

function Decorator:LimitCall(interval)
	self:AddDecorator(function (FuncName, f)
		local NewFunc = function (obj, ...)
			local now_time = os.time()
			local refresh_time = GWorld.LimitCallMethods[FuncName]
			refresh_time = refresh_time or 0
			if now_time > refresh_time then
				f(obj, ...)
				GWorld.LimitCallMethods[FuncName] = now_time + interval
			else
				-- DebugPrint("LimitCall:", FuncName)
			end
		end
		return NewFunc
	end)
end

function Decorator:NoShipping()
	self:AddDecorator(
		function (FuncName, f)
			local NewFunc = function (obj, ...)
				local IsDistribution = UE.URuntimeCommonFunctionLibrary.IsDistribution()
				local bEnableShippingLog = UE4.URuntimeCommonFunctionLibrary.EnableLogInShipping()
				if IsDistribution and not bEnableShippingLog then
					DebugPrint(FuncName .. " is not for Distribution")
					return
				end

				f(obj, ...)
			end

			return NewFunc
		end
	)
end

function Decorator:VersionControl(DataName, KeyIndex, ReplacedVersionKey)
	assert(DataName, "DataName is nil")
	self:AddDecorator(
		function (FuncName, f)
			local NewFunc = function (obj, ...)
				local args = {...}
				KeyIndex = KeyIndex or 1
				ReplacedVersionKey = ReplacedVersionKey or "ReleaseVersion"
				local bValidVersion = true
				local Version = -1
				if #args < KeyIndex then
					-- @SnowMoon 指定的版本控制参数不存在，算作无效版本
					bValidVersion = false
				else
					local Key = args[KeyIndex]
					if not DataMgr[DataName][Key] then
						-- @SnowMoon 指定的表格数据不存在，算作无效版本
						bValidVersion = false
					else
						Version = DataMgr[DataName][Key][ReplacedVersionKey] or 0
						bValidVersion = Version <= DataMgr.GlobalConstant.CurrentVersion.ConstantValue
					end
				end

				if not bValidVersion then
					obj.logger.info("The version is not valid to call function", FuncName, Version, DataMgr.GlobalConstant.CurrentVersion.ConstantValue)
					local ret = obj:OnInvalidVersionControlCallback(FuncName, DataName, ...)
					if not ret then
						return
					end
				end

				return f(obj, ...)
			end

			return NewFunc
		end
	)
end

function Decorator:Time()
	self:AddDecorator(
		function (FuncName, f)
			local NewFunc = function (obj, ...)
				local StartTime = GWorld:GetCurrentTime()
				DebugPrint(FuncName.." Start Exe: ", StartTime)
				f(obj, ...)
				local EndTime = GWorld:GetCurrentTime()
				DebugPrint(FuncName.." End Exe: ", EndTime)
				DebugPrint(FuncName.." time-consuming is ", EndTime - StartTime)
			end
			return NewFunc
		end
	)
end

function Decorator:GM_CMD(args)
	self:AddDecorator(
		function (FuncName, f)
			local args_name = GetArgsName(f)
			local real_args_name = {}
			for index, arg_name in ipairs(args_name) do
				repeat
					if arg_name == 'self' or arg_name == 'Id' or arg_name == 'fd' or arg_name == "docs" or arg_name == "doc" then
						break
					end
					table.insert(real_args_name, arg_name)
				until true
			end
			local args_type = SplitAndTrim(args, ",")
			GWorld:AddGmCmd(FuncName, real_args_name, args_type)
			return f
		end
	)
end

Decorator = setmetatable(Decorator, {
	__newindex = function (T, key, value)
		if type(value) == "function" then
			if not T.Decorators then
				T.Decorators = {}
			end
			for i = #T.Decorators, 1, -1 do
				value = T.Decorators[i](key, value)
				T.Decorators[i] = nil
			end
		end

		rawset(T, key, value)
	end
})

function Decorator:ApplyDecorator(Cls)
	for key, value in pairs(self) do
		Cls[key] = value
	end
	setmetatable(Cls, getmetatable(self))
end

return Decorator

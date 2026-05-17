
if _G._UNLUA ~= nil then
	return
end
_G._UNLUA = 1

-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西
-- 后续禁止在Unlua里requre东西


local rawget = rawget
local rawset = rawset
local type = type
local getmetatable = getmetatable
local setmetatable = setmetatable
local require = require
local str_sub = string.sub

local GetUProperty = GetUProperty
local SetUProperty = SetUProperty
local RegisterClass = RegisterClass
local RegisterEnum = RegisterEnum
local print = UEPrint or print
local netprint = NetPrint
local UE = UE

_G._NotExist = _G._NotExist or {}
local NotExist = _NotExist

-- local function Index(t, k)
-- 	local mt = getmetatable(t)

-- 	local v = rawget(mt, k)
-- 	if v~= nil then
-- 		if rawequal(v, NotExist) then
-- 			return nil
-- 		end
-- 		rawset(t, k, v)
-- 		return v
-- 	end

--     local p = mt[k]

--     if p ~= nil then
--         if type(p) == "userdata" then
--             return GetUProperty(t, p)
--         elseif type(p) == "function" then
--         	rawset(t, k, p)
--             rawset(mt, k, p)
--         elseif rawequal(p, NotExist) then
--             return nil
--         end
--     else
--         rawset(mt, k, NotExist)
--     end
-- 	return p
-- end

local function Index(t, k)
	-- 获取元表
	local mt = getmetatable(t)

	-- 从元表lua中取数据
	local p = rawget(mt, k)
	if p == nil then
		-- 从c++取数据放在元表中，对于每个元表的每个k，这个只会走一次
		p = mt[k]
		-- 如果没有数据
	    if p == nil then
	    	rawset(mt, k, NotExist)
	    	return nil
	    end
	    -- 从c++取的数据，放到元表lua中
		rawset(mt, k, p)
	end

    -- 如果没有数据
    if rawequal(p, NotExist) then
        return nil
    end

    -- 如果是c++的变量
    if type(p) == "userdata" then
        return GetUProperty(t, p)
    end

    -- 否则都设到t中
	rawset(t, k, p)
	return p
end

local function NewIndex(t, k, v)
	local mt = getmetatable(t)
	local p = mt[k]
	if type(p) == "userdata" then
		return SetUProperty(t, p, v)
	end
	rawset(t, k, v)
end

local function copy_table(source, target)
	-- 复制
	for k,f in pairs(source) do
		repeat
			if k == "__index" or k == "__newindex" or k == "Super" then
				break
			end
			-- print("rawset-"..tostring(k).."-"..tostring(f).."--"..type(f))
			if type(f) == "function" then
				-- print("rawset-"..tostring(k).."-"..tostring(f))
				rawset(target, k, f)
			end
		until true
	end
end

local a = nil
local function Get_G()
	return a
end

local function Class(super_name)
	local new_class = {}
	new_class.__index = Index
	new_class.__newindex = NewIndex
	new_class.Super = nil
	-- print("Class.."..tostring(super_name))
	-- super_name作为Components，所有Component里的函数都复制过来
	if type(super_name) == "table" then
		for i,v in pairs(super_name) do
			local require_module
			if type(v) == "table" then
				require_module = v
			else
				require_module = require(v)
			end
			if require_module == nil then
				print("Can not require file "..tostring(v))
			else
				-- print("require "..tostring(v))
				if new_class.Super == nil then
					new_class.Super = require_module
					setmetatable(new_class, getmetatable(new_class.Super))
				end

				copy_table(require_module, new_class)
			end
		end
	elseif super_name ~= nil then
		local require_module = require(super_name)
		if require_module == nil then
			print("Can not require file "..tostring(super_name))
		else
			-- print("require "..tostring(super_name))
			new_class.Super = require_module
			setmetatable(new_class, getmetatable(new_class.Super))
			copy_table(require_module, new_class)
		end
	end
	new_class.Get_G = Get_G
	new_class.add_ref = function(ref_table)
		-- print(LogTag, "add_ref", ref_table)
		if not new_class.ref_tables then
			new_class.ref_tables = setmetatable({}, {__mode = "kv"})
			
		end
		table.insert(new_class.ref_tables, ref_table)
	end
	return new_class
end

local function IsInExceptionList(Name, ExceptionList)
	if not ExceptionList then
		return false
	end
	for i, v in pairs(ExceptionList) do
		if Name == v then
			return true
		end
	end
	return false
end

---注意，如果M不是类而是self，self的组件方法会覆盖类方法
local function AssembleComponents(M, ExceptionList)
	local NameToFuncTable = {}
	for name, value in pairs(M) do
		if type(value) == "function" and string.sub(name, 1,2) ~= "__" then
			if NameToFuncTable[name] == nil then
				NameToFuncTable[name] = {}
			end
			table.insert(NameToFuncTable[name], value)
		end
	end

	local components = rawget(M, "_components")
	if type(components) == "table" then
		for _, component_name in ipairs(components) do
			local component = require(component_name)
			for name, value in pairs(component) do
				local NameInExceptionList = IsInExceptionList(name, ExceptionList)
				if type(value) == "function" and string.sub(name, 1,2) ~= "__" and not NameInExceptionList then
					if NameToFuncTable[name] == nil then
						NameToFuncTable[name] = {}
					end
					table.insert(NameToFuncTable[name], value)
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
			rawset(M, name, _wrapper)
		end
	end

end

local function global_index(t, k)
	if type(k) == "string" then
		local s = str_sub(k, 1, 1)
		if s == "U" or s == "A" or s == "F" or s == "E" or s == "T" then
			local v = UE[k]
			if v ~= nil then
				rawset(t, k, v)
			end
		end
	end
	return rawget(t, k)
end


local global_mt = {}
global_mt.__index = global_index
setmetatable(_G, global_mt)
if WITH_UE4_NAMESPACE then
	_G.UE4 = UE
	print("WITH_UE4_NAMESPACE==true")
else
	---使用LuaHelper插件，防止命名空间干扰
	rawset(_G, "UE4",_G)
	rawset(_G, "UE", _G)
	print("WITH_UE4_NAMESPACE==false");
end

local function print_t(logTag, ...)
	if _G.LogTag == "nil" then
		print(logTag, ...)
	elseif logTag == _G.LogTag then
		print(logTag,...)
	end
end

--region Lua Extensions
function math.clamp(v, minValue, maxValue)
    if v < minValue then
        return minValue
    end
    if( v > maxValue) then
        return maxValue
    end
    return v
end

function math.lerp(a, b, t)
    return a + (b - a) * t
end

function math.sign(number)
	if number > 0 then return 1 end
	if number < 0 then return -1 end
	return 0
end

function table.slice(t, i, j)
	return {table.unpack(t, i, j)}
end

function table.reverse(t)
	local n = #t
	for i=1, math.floor(n/2) do
		t[i], t[n-i+1] = t[n-i+1], t[i]
	end
	return t
end

function table.join(...)
	local tt = {...}
	local nt = {}
	for _, t in ipairs(tt) do
		for _, v in ipairs(t) do
			table.insert(nt, v)
		end
	end
	return nt
end

function table.isempty(t)
	return t==nil or next(t) == nil
end

function table.findValue(t, targetValue, finder)
	if not finder then 
		finder = function(v,target)
			return v==target
		end
	end
	for i, v in pairs(t) do
		if finder(v, targetValue) then
			return v,i
		end
	end
end


function string.split(str, reps)
	local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function ( w )
        table.insert(resultStrList,w)
    end)
    return resultStrList
end

function string.trim(str)
	return (string.gsub(str, "^[%s\n\r\t]*(.-)[%s\n\r\t]*$", "%1"))
end

function string.startswith(str, prefix)
    return string.sub(str, 1, string.len(prefix)) == prefix
end

function string.endswith(str, postfix)
	local strLen = string.len(str)
	return string.sub(str, strLen-string.len(postfix)+1, strLen) == postfix
end

function string.insert(str, pos, rep)
	return string.sub(str, 1, pos).. rep.. string.sub(str, pos+1)
end

function string.isempty(str)
	return str == nil or str == ""
end

---lua异常处理
---@alias execFunc = fun(...):any
---@alias catchFunc = fun(err:string):void
---@alias finalFunc = fun(ok:boolean,...):void
---@alias block {exec:execFunc, catch:catchFunc|nil, final:finalFunc|nil}
---@param block block
---@param ... any
---@return any
local function try(block, ...)
	if not block.catch then
		block.catch = function(err)
			LogError(Traceback(ErrorTag, err, false))
			local EMSentrySubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld and GWorld.GameInstance, UEMSentrySubsystem)
			if EMSentrySubsystem then
				local SceneId = "nil"
				if WorldTravelSubsystem and WorldTravelSubsystem() then 
					SceneId = tostring(WorldTravelSubsystem():GetCurrentSceneId())
				end
				local ErrorMsg = debug.traceback(tostring(err), 2)
				EMSentrySubsystem:ReportLuaTrace(ErrorMsg, {
					SceneId = SceneId, SceneName = "unlua.try", Location = "unlua.try"
				})
			end
		end
	end
	local Res = table.pack(xpcall(block.exec, block.catch,...))
	local ok = Res[1]
	if block.final then
		block.final(ok, ...)
	end
	if ok then
		return table.unpack(Res,2) 
	end
end
_G.try = try
--endregion


---直接用协程不能在控制台打印trace，建议用CreateCoroutine
---@return thread
local function CreateCoroutine(Func,...)
	return coroutine.create(function(...)
		try({exec = Func},...)
	end)
end
_G.CreateCoroutine = CreateCoroutine

---启动一次性异步任务的方法
---@param Obj table
---@param TaskName string
---@param TaskFunc fun(CoroutineObj:thread)
local function RunAsyncTask(Obj, TaskName, TaskFunc)
	if Obj[TaskName] then return end
    Obj[TaskName] = coroutine.create(function()
		local Co = Obj[TaskName]
		try({exec = TaskFunc, }, Co, Obj)
		Obj[TaskName] = nil
		coroutine.close(Co)
	end)
	coroutine.resume(Obj[TaskName])
end
_G.RunAsyncTask = RunAsyncTask

local function ForceStopAsyncTask(Obj, TaskName)
	if not Obj[TaskName] then return end
	local Co = Obj[TaskName]
	Obj[TaskName] = nil
	local Status = coroutine.status(Co)
	if (Status == "running" or Status == "suspended") then
		coroutine.close(Co)	
	end
end
_G.ForceStopAsyncTask = ForceStopAsyncTask

require("BluePrints.Managers.EventManager")
require "LogPrint"

_G.print = print_t
_G.Get_G = Get_G
_G.netprint = netprint
_G.ServerPrint = LogEMServer
_G.Index = Index
_G.NewIndex = NewIndex
_G.Class = Class
_G.CopyTable = copy_table
_G.DrawDebugTest = false
_G.AutoCameraReset = true
_G.ShouldUseCreaturePool = true
_G.LogTag = "nil"
_G.ErrorTag = "::Error::"
_G.WarningTag = "::Warning::"
_G.DebugTag = "::Debug::"
_G.AssembleComponents = AssembleComponents


_G.TypeClassModule = require "NetworkEngine.Class"
_G.TypeClass = _G.TypeClassModule.Class
_G.DataMgr = require "DataMgr"
_G.CommonConst = require "CommonConst"
_G.Const = require "Const"
_G.UIConst = require "BluePrints.UI.UIConst"
_G.GWorld = require "GWorld"
_G.BattleEventName = require "BluePrints/Combat/BattleEvents/BattleEventName"
_G.DialogEvent = require "BluePrints.UI.UI_PC.Common.Common_Dialog.DialogEvent"
_G.ErrorCode = require "BluePrints.Client.ErrorCode"
_G.ConditionUtils = require "BluePrints.Common.ConditionUtils"
_G.AvatarUtils = require "BluePrints.Client.AvatarUtils"
_G.ItemUtils = require "Utils.ItemUtils"
_G.CommonUtils = require "Utils.CommonUtils"
_G.RpcUtils = require "Utils.RpcUtils"
_G.RewardUtils = require "Utils.RewardUtils"
_G.UIUtils = require "Utils.UIUtils"
_G.UseDungeonLevelBounds = false
_G.UseMinimumLoad = true
_G.LuaMemoryManager = require "LuaMemoryManager"
_G.SystemGuideManager = require"BluePrints.Managers.SystemGuideManager"
_G.MissionIndicatorManager = require"BluePrints.Managers.MissionIndicatorManager"
_G.ReddotManager = require "BluePrints.UI.Reddot.ReddotManager"
-- _G.RegionUtils = require "Utils.RegionUtils"
_G.I18nUtils = require"Utils.I18nUtils"
_G.PageJumpUtils = require "Utils.PageJumpUtils"
_G.ShopUtils = require "Utils.ShopUtils"
_G.RougeUtils = require "Utils.RougeUtils"
_G.SerializeUtils = require "Utils.SerializeUtils"
_G.TestClass = TestClass or function()
	local Class = {}
	Class.__index = Class
	Class.New = function()
		local o = {}
		setmetatable(o, Class)
		return o
	end
	return Class
end
_G.Serpent = require "Utils.Serpent"
_G.EMGlobalLuaTable = require "EMGlobalLuaTable"
_G.ServerConfig = require "ServerConfig"
_G.Json = require "rapidjson"
_G.bson = require "bson"
_G.Utils = require "Utils"
_G.TimeUtils = require "Utils.TimeUtils"
_G.StubInfos = require "StubInfos"
_G.EMCache = require "EMCache.EMCache"

local Utils = require "Utils"
for k,v in pairs(Utils) do
	rawset(_G, k, v)
end

-- Dont remove, for export classes in standalone game    
-- local CoverPoint = UE.FCoverPointStruct
local FEffectStruct = UE.FEffectStruct
local FEffectSkillInfo = UE.FSkillEffectInfo
local FMonsterSpawnPointParam = UE.FMonsterSpawnPointParam
local FPointCheckInfo = UE.FPointCheckInfo
local FNameArray = UE.FNameArray
local FMonsterEidArray = UE.FMonsterEidArray
local FClientTimerStruct = UE.FClientTimerStruct
local FClientTimerInfo = UE.FClientTimerInfo
local FSkillLevelStruct = UE.FSkillLevelStruct
local FMessage = UE.FMessage
local SetupClient = require "SetupClient"
SetupClient:Setup()

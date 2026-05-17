---CommonUtils是前后端共用的轮子方法，原则上不允许出现UE4的类型！！！
---@todo 目前带UE4的方法后面挪到Utils.lua中
---@class CommonUtils
local CommonUtils = {}
local this = CommonUtils

function CommonUtils.IsObjId(str)
	if #str == 14 and string.byte(string.sub(str,1,1)) == 0 then
        return true
    end
    return false
end

function CommonUtils.IsObjIdStr(ObjIdStr)
	if string.len(ObjIdStr) ~= 36 then
		return false
	end
	if string.sub(ObjIdStr, 1, 8) ~= "ObjectId" then
		return false
	end
	return true
end

function CommonUtils.ObjId2Str(ObjId)
	-- ObjId是一个长度为14的字符串
	local ret = this.ObjId2Str2(ObjId)
	return table.concat({
		"ObjectId(\'",
		ret,
		"\')"
	}, "")
end
-- 字符串中有 nil 的时候使用
function CommonUtils.ToHex(s, limit)
	local n = math.min(#s, limit or #s)
	local t = {}
	for i = 1, n do
	  t[i] = string.format("%02X", string.byte(s, i))
	end
	return table.concat(t, " ")
end

--制作CustomType数据副本集
-- 特性 : DeepCopy 、落地数据库不走这个不用担心Key变形
-- 用途 ：RPC 传输CustomType数据 
function CommonUtils.BinaryDump(Prop)
	if Prop == nil then
		return nil
	end

	if type(Prop) == "table" and Prop.binary_dump then
		return Prop:binary_dump(Prop)
	end
	return Prop
end

function CommonUtils.ObjId2Str2(ObjId)
	-- ObjId是一个长度为14的字符串
	local ret = ""
	if ObjId == nil then
		return ""
	end
	ret = {}
	for index = 3, #ObjId do
		ret[index - 2] = string.format("%02X",string.byte(string.sub(ObjId,index,index)))
	end
	return table.concat(ret, "")
end

function CommonUtils.Str2ObjId(ObjIdStr)
	if not ObjIdStr then
		return ""
	end
	if ObjIdStr == "" then
		return ""
	end
	if not CommonUtils.IsObjIdStr(ObjIdStr) then
		return ""
	end
	return bson.str2objectid(string.sub(ObjIdStr,11,34))
end

function CommonUtils.Split(str, reps)
    local Results = {}
	if not str then
		return Results
	end
    string.gsub(str,'[^'..reps..']+',function ( w )
        table.insert(Results, w)
    end)
    return Results
end

function CommonUtils.DeepCopy(Object)
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		end
		local new_table = {}
		for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
	end
	return _copy(Object)
end

function CommonUtils.GenDeclareUpvaluesCode(entity,FuncName,fun_owner_name)
    if not entity then return end
	local entity = entity.__Class__ or entity
	if not entity[FuncName] or type(entity[FuncName]) ~= "function" then
		return ""
	end
    local formatStr = [[local %s = CommonUtils.GetUpvalues(%s.%s, "%s")]]
	local ret = ""
	local i = 1
	while true do
		local name, value = debug.getupvalue(entity[FuncName], i)
		if name == nil then break end
		i = i + 1
		if name ~= "_ENV" then
			ret = ret .. string.format(formatStr, name,fun_owner_name, FuncName ,name) .. "\n"
		end
	end
	return ret
end

function CommonUtils.ReloadPakFromDisk(path)
	local path, err = package.searchpath(path, package.path)
	DebugPrint("CommonUtils.ReloadPakFromDisk searchpath", path, err)
	if not path then
		return package.loaded[path]
	end
	package.loaded[path] = CommonUtils.DoFile(path)
	return package.loaded[path]
end

function CommonUtils.DoFile(filePath)
	local file = io.open(filePath, "r")
	local content = file:read("*a") -- 读取文件全部内容
	file:close()
	local func, err = load(content)
	return func()
end

function CommonUtils.LoadNewFuncStr(entity,func_name)
	local prop_class = entity.__Class__
	if not prop_class[func_name] then
		return nil,nil,"no function ".. func_name .. " in entity"
	end

    local old_func_info = debug.getinfo(prop_class[func_name], "S")
	if old_func_info.what ~= "Lua" then
		return nil,nil,"Cannot extract source for C functions."
	end
	local old_file_name = old_func_info.source:sub(2)

	-- 加载新文件
	local comp = CommonUtils.DoFile(old_file_name)
	if comp == nil then
		return nil,nil,"no file:" .. old_file_name
	end
	-- 获取新函数
	local func = comp[func_name]
	if not func then
		return nil,nil,"no function:" .. func_name .. " in file:" .. old_file_name
	end 

    local info = debug.getinfo(func, "S")
	local lines = {}
	for line in io.lines(old_file_name) do -- 去掉开头的"@"
		table.insert(lines, line)
	end
	
	local get_class_code =[[
	local ClassMgr = require "NetworkEngine.Common.ClassManager"
	local _class_ = ClassMgr:GetType("]] .. entity.__Class__.__Name__ .. [[")
	]]
	
	local new_func_str = table.concat(lines, "\n", info.linedefined, info.lastlinedefined)
	-- skynet.error(new_func_str)
	local new_func_str = CommonUtils.ConvertFuncString(new_func_str,func_name,"_class_")
	-- skynet.error(new_func_str)
	local upvalues_code = CommonUtils.GenDeclareUpvaluesCode(prop_class,func_name,"_class_")

	return "\n" .. get_class_code .. "\n" .. upvalues_code .. "\n" .. new_func_str ,old_func_info.source
end

function CommonUtils.LoadNewFuncStrProp(class_name,func_name)
	local prop_name = string.match(class_name, "([^.]+)$")
	local ClassMgr = require "NetworkEngine.Common.ClassManager"
	-- local Pet = ClassMgr:GetType("Pet.Pet")
	local prop_class = ClassMgr:GetType(class_name)
	if not prop_class[func_name] then
		return nil,nil,"no function ".. func_name .. " in entity"
	end

    local old_func_info = debug.getinfo(prop_class[func_name], "S")
	if old_func_info.what ~= "Lua" then
		return nil,nil,"Cannot extract source for C functions."
	end
	local old_file_name = old_func_info.source:sub(2)

	-- 加载新文件
	local comp = CommonUtils.DoFile(old_file_name)
	if comp == nil then
		return nil,nil,"no file:" .. old_file_name
	end
	-- 获取新函数
	local func = comp[prop_name][func_name]
	if not func then
		return nil,nil,"no function:" .. func_name .. " in file:" .. old_file_name
	end 

    local info = debug.getinfo(func, "S")
	local lines = {}
	for line in io.lines(old_file_name) do -- 去掉开头的"@"
		table.insert(lines, line)
	end

	local get_prop_class_code =[[
	local ClassMgr = require "NetworkEngine.Common.ClassManager"
	local prop_class_ = ClassMgr:GetType("]] .. class_name .. [[")
	]]
	
	local new_func_str = table.concat(lines, "\n", info.linedefined, info.lastlinedefined)
	-- skynet.error(new_func_str)
	local new_func_str = CommonUtils.ConvertFuncString(new_func_str,func_name,"prop_class_")
	-- skynet.error(new_func_str)
	local upvalues_code = CommonUtils.GenDeclareUpvaluesCode(prop_class,func_name,"prop_class_")

	return "\n" .. get_prop_class_code .. "\n" .. upvalues_code .. "\n" .. new_func_str ,old_func_info.source
end

function CommonUtils.ConvertFuncString(funcstr,funcname,fun_owner_name)
	local function hasParameters(funcHeader)
		-- 匹配函数的参数部分，包括括号
		local paramPart = funcHeader:match("%b()")
		if not paramPart then return false end  -- 如果没有匹配到参数部分，假定没有参数
	
		-- 移除参数部分内所有的空白字符（空格、换行、制表符等）
		local cleanedParams = paramPart:gsub("%s+", "")
		
		-- 如果处理后的参数列表仅为"()", 则表示没有参数
		return cleanedParams ~= "()"
	end
	fun_owner_name = fun_owner_name or "self"
	local firstLine = funcstr:match("^(.-)\n") or funcstr
	local head = ""
	if string.find(firstLine, "%:") then
		if hasParameters(firstLine) then
			head = fun_owner_name .. [[.]]..funcname..[[ = function (self,]]
		else
			head = fun_owner_name .. [[.]]..funcname..[[ = function (self]]
		end
	elseif string.find(firstLine, "%.") then
		head = fun_owner_name .. [[.]]..funcname..[[ = function (]]
	end
	
	local startPos = string.find(funcstr, "%(")  -- 查找第一个 '(' 的位置
	if startPos then
		funcstr = string.sub(funcstr, startPos + 1)  -- 截取 '(' 之后的字符串
	end
	return head..funcstr 
end

--线上热更流程用
function CommonUtils.GetUpvalues(func, target)
    if not func then return end
    local i = 1
    while true do
        local name, value = debug.getupvalue(func, i)
		if not name then
			break
		end
        if name == target then
            return value
        end
        i = i + 1
    end
end

--number为键的有序迭代器
--for key, value in CommonUtils.OrderedNumberKeyPairs(myTable) do
    -- print(key, value)
-- end
function CommonUtils.OrderedNumberKeyPairs(t)
    -- 创建一个数组来存储表的键（只考虑数字键）
    local keys = {}
    for key in pairs(t) do
        if type(key) == "number" then  -- 确保只处理数字键
            table.insert(keys, key)
        end
    end
    
    -- 对这些键进行排序
    table.sort(keys)

    -- 定义一个迭代器函数
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end


function CommonUtils.TableToString(Targets,Deep)
    if type(Targets) ~= "table" then
        Targets = { Targets }
    end
    Deep = Deep or 10

    -- 预生成缩进（避免每行重复拼 \t）
    local indents = { ["0"] = "" }
    for i = 1, Deep + 2 do
        indents[tostring(i)] = (indents[tostring(i-1)] or "") .. "\t"
    end

    -- ObjId 判断：不做 sub，直接 byte
    local function IsObjId(str)
        return type(str) == "string" and #str == 14 and string.byte(str, 1) == 0
    end

    -- 更快的 ObjId 转字符串：不用 sub，不用 ret..ret
    local function ObjId2Str(ObjId)
        if ObjId == nil then return "" end
        local bytes = {}
        -- 你原来从 index=3 开始
        for i = 3, #ObjId do
            bytes[#bytes + 1] = string.format("%02X", string.byte(ObjId, i))
        end
        return "ObjectId(\'" .. table.concat(bytes) .. "\')"
    end

    local out = {}
    local function push(...)
        local n = select("#", ...)
        for i = 1, n do
            out[#out + 1] = select(i, ...)
        end
    end

    local visited = {}  -- 防循环引用卡死

    local function val_str(x)
        if type(x) == "string" and IsObjId(x) then
            return ObjId2Str(x)
        end
        return tostring(x)
    end

    local function get_table_str(t, step)
        if visited[t] then
            push(indents[tostring(step)], "<cycle> (table)\n")
            return
        end
        visited[t] = true

        local indent = indents[tostring(step)] or ""
        for k, v in pairs(t) do
            local kstr = (type(k) == "string" and IsObjId(k)) and ObjId2Str(k) or tostring(k)
            local vstr = val_str(v)

            push(
                indent,
                kstr, " (", type(k), ")",
                ": ",
                vstr, " (", type(v), ")\n"
            )

            if type(v) == "table" and step < Deep then
                get_table_str(v, step + 1)
            end
        end

        visited[t] = nil
    end

    push("PrintTable: ", tostring(Targets), "\n")
    if Targets and type(Targets) == "table" then
        get_table_str(Targets, 1)
    end
    return table.concat(out)
end
---@param func function --返回true表示结束遍历
--从中间向两边遍历
function CommonUtils.TraverseFromTheMiddleOfTheArrayToBothSides(arr, start_index,func) 
    if start_index <= #arr // 2 then
        for i = start_index, #arr do
            if func(arr[i]) then return end
            local index2 = 2*start_index  - i
            if index2 <= #arr and index2>0 and index2 ~= i  then
				if func(arr[2*start_index  - i]) then return end
            end
        end
    else
        for i = start_index, 1, -1 do
            if func(arr[i]) then return end
            local index2 = 2*start_index  - i
            if index2 <= #arr and index2>0 and index2 ~= i  then
                if func(arr[2*start_index  - i]) then return end
            end
        end
    end
end

function CommonUtils.MathConcat(a,b)
	local function getDigitCount(n)
		-- 计算一个数字的位数
		if n == 0 then
			return 1
		end
		return math.floor(math.log(n) / math.log(10)) + 1
	end
	-- 获取 b 的位数
	local digitCount = getDigitCount(b)
	-- 拼接两个数字
	return a * (10 ^ digitCount) + b
end

function CommonUtils.Copy(Object)
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

function CommonUtils.GetTimeZone()
	local utcTime = os.time(os.date("!*t"))

	-- 获取本地时间的表表示形式
	local localTimeTable = os.date("*t")
	local localTime = os.time(localTimeTable) -- 将本地时间表转换为时间戳

	-- 计算时区偏移（以小时为单位）
	local timeZoneOffset = (localTime - utcTime) / 3600
	--转换成整型
	timeZoneOffset = math.floor(timeZoneOffset)
	return timeZoneOffset
end

function CommonUtils.Remap(Value, FromA, ToA, FromB, ToB)
	return (Value - FromA) / (ToA - FromA) * (ToB - FromB) + FromB
end

function CommonUtils.IsEqual(array1, array2)
	if #array1 ~= #array2 then
		return false
	end
	for index, value in ipairs(array1) do
		local value2 = array2[index]
		if type(value) ~= type(value2) then
			return false
		end
		if type(value) == "table" then
			if not CommonUtils.IsEqual(value, value2) then
				return false
			end
		else
			if value ~= array2[index] then
				return false
			end
		end
	end

	return true
end

---@param IsRate boolean
---@param Value number
function CommonUtils.AttrValueToString(AttrConfig,Value, IsRate,NotFormat)
	if not AttrConfig then
		return Value
	end
	if AttrConfig['NumCorrect'] and not IsRate then
		Value=Value*AttrConfig['NumCorrect']
	end
	local percent=''
	if AttrConfig['IsPercent'] or IsRate then
		Value = Value*100
		if CommonConst.SystemLanguage == CommonConst.SystemLanguages.FR then
			percent = "\u{00A0}%"
		else
			percent = "%"
		end
	end
	if NotFormat then
		return tostring(Value)..percent
	end
	local a,b=math.modf(Value)
    if not  (math.abs(b - 0) < 10e-6 or math.abs(b - 1) < 10e-6) then
        local floor=math.floor(b*10^2+0.5)/10^2
        if floor ~= 0 then
            a= a + floor
        end
	else
		if b>0.5 then
			a=a+1
		end
    end
    local str=tostring(a)
    local k
    while true do
        str,k=string.gsub(str,"^(-?%d+)(%d%d%d)",'%1,%2')
        if k==0 then
            break
        end
    end
	str = CommonUtils.FormatNumInFrench(str)
	return str..percent
end

function CommonUtils.RandomNumList(M, N, Cnt)
	local Tmp = {}
	for i = M, N do
		table.insert(Tmp, i)
	end
	if Cnt > N - M + 1 then
		return Tmp
	end
	local X = 0
	local T = {}
	while Cnt > 0 do
		X = math.random(1,N - M + 1)
		table.insert(T, Tmp[X])
		table.remove(Tmp, X)
		Cnt = Cnt - 1
		M = M + 1
	end
	return T
end

function CommonUtils.RemoveValue(Target, Value)
	if type(Target) ~= "table" then
		return
	end
	local _index = nil
	for index, value in ipairs(Target) do
		if value == Value then
			_index = index
			break
		end
	end
	if _index then
		table.remove(Target, _index)
		return true
	end
	return false
end

function CommonUtils.HasValue(Target, Value)
	if not Target then
		return false
	end
	if type(Target) ~= "table" then
		return false
	end
	for index, value in pairs(Target) do
		if value == Value then
			return true
		end
	end
	return false
end

function CommonUtils.Size(Target)
	if type(Target) ~= "table" then
		return 0
	end
	local count = 0
	for k,v in pairs(Target) do
		count = count + 1
	end
	return count
end

function CommonUtils.IsEmpty(Target)
	if type(Target) ~= "table" then
		return true
	end
	for _, _ in pairs(Target) do
		return false
	end
	return true
end

-- EventMgr FixLocation 曾用到,但是 FixLocation 已经挪到了cpp,并且直接调用 Run...Library 中的函数,不再经过 CommonUtils
function CommonUtils.GetFixLocation(UObject, Loc, LocationExtraZ, StartZ, EndZ, TraceType)
	TraceType = TraceType or "TraceCreatureHit"
	return UE4.URuntimeCommonFunctionLibrary.GetFixLocation(UObject, Loc, LocationExtraZ or 50, StartZ or 200, EndZ or -1500, Const.FixTraceChannel[TraceType])
end

function CommonUtils.CopyTable(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            copy[k] = CommonUtils.CopyTable(v)
        else
            copy[k] = v
        end
    end
    return copy
end

function CommonUtils.GetFixLocationOld(UObject, Loc, LocationExtraZ, StartZ, EndZ, TraceType)
	TraceType = TraceType or "TraceCreatureHit"
	local NewLoc = Loc
	for _, Offsets in pairs(Const.SummonOffset) do
		local x = Offsets[1]
		local y = Offsets[2]
		local HitResult = FHitResult()
		local _NewLoc = FVector(Loc.X + x, Loc.Y + y, Loc.Z)
		local bHit = UE4.UKismetSystemLibrary.LineTraceSingle(UObject, _NewLoc + FVector(0, 0, StartZ or 200), _NewLoc + FVector(0, 0, EndZ or -1500),
				Const.FixTraceChannel[TraceType], false, TArray(AActor), 0, HitResult, true, 
				UE4.FLinearColor(math.random(0,1), math.random(0,1), math.random(0,1), 1), UE4.FLinearColor(math.random(0,1), math.random(0,1), math.random(0,1), 1),50)
		if bHit then
			-- 不在墙里
			if HitResult.ImpactPoint ~= _NewLoc then
				NewLoc = HitResult.ImpactPoint
				break
			end
		end
	end
	NewLoc = FVector(NewLoc.X, NewLoc.Y, NewLoc.Z + (LocationExtraZ or 50))
	return NewLoc
end

function CommonUtils.GetCapFixLocation(Character, Loc, LocationExtraZ, StartZ, EndZ, TraceType)
	TraceType = TraceType or "TraceCreatureHit"
	local NewLoc = Loc
	local OriginCapsuleRadius = Character.CapsuleComponent and Character.CapsuleComponent:GetScaledCapsuleRadius() or 0
	local OriginHalfHeight = Character.CapsuleComponent and Character.CapsuleComponent:GetScaledCapsuleHalfHeight() or 0
	for _, Offsets in pairs(Const.SummonOffset) do
		local x = Offsets[1]
		local y = Offsets[2]
		local HitResult = FHitResult()
		local _NewLoc = FVector(Loc.X + x, Loc.Y + y, Loc.Z)
		local bHit = UE4.UKismetSystemLibrary.CapsuleTraceSingle(Character, _NewLoc + FVector(0, 0, StartZ or 0), _NewLoc + FVector(0, 0, EndZ or -1500),
				OriginCapsuleRadius, OriginHalfHeight,
				Const.FixTraceChannel[TraceType], false, nil, 0, HitResult, true, UE4.FLinearColor(1, 0, 0, 1),UE4.FLinearColor(0, 1, 0, 1),5)
		if bHit then
			-- 不在墙里
			if HitResult.Location ~= _NewLoc then
				NewLoc = HitResult.Location
				break
			end
		end
	end
	NewLoc = FVector(NewLoc.X, NewLoc.Y, NewLoc.Z + (LocationExtraZ or 50))
	return NewLoc
end

-- EventMgr FixEliteLocation 曾用到,但是 FixEliteLocation 已经挪到了cpp,不再经过 CommonUtils
function CommonUtils.GetEliteLocation(FormationId, Source, Loc, CloseFloor)
	local TeamData = DataMgr.EliteTeamData[FormationId]
	if not TeamData or not TeamData.LocationCheckParam then
		return Loc
	end
	local LocationCheckParam = TeamData.LocationCheckParam
	local HalfHeight = LocationCheckParam.HalfHeight or 40
	local Radius = LocationCheckParam.Radius or 20
	local StepHeight = LocationCheckParam.StepHeight or 100
	local WalkableFloorAngle = LocationCheckParam.WalkableFloorAngle or 45
	local MaxLength = LocationCheckParam.MaxLength or 200
	local MaxWidth = LocationCheckParam.MaxWidth or 50
	CloseFloor = CloseFloor ~= nil and CloseFloor or false
	return URuntimeCommonFunctionLibrary.GetValidLocationBySimulateMovement(Source:K2_GetActorLocation(), Loc, HalfHeight, Radius, StepHeight, WalkableFloorAngle, false, MaxLength, MaxWidth, CloseFloor)
end

CommonUtils.GetDeviceTypeByPlatformName = _G.GetDeviceTypeByPlatformName
CommonUtils.GetRuntimePlatform = _G.GetRuntimePlatform

-- function CommonUtils.GetDeviceTypeByPlatformName(WorldContextObject)
-- 	-- ---PIE模式下根据UesMouseForTouch的设置来决定模拟哪个端
-- 	-- if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(WorldContextObject) then
-- 	-- 	if UInputSettings.GetInputSettings().bUseMouseForTouch then 
-- 	-- 		GWorld.DefaultDevice = CommonConst.CLIENT_DEVICE_TYPE.MOBILE
-- 	-- 	else
-- 	-- 		GWorld.DefaultDevice = CommonConst.CLIENT_DEVICE_TYPE.PC
-- 	-- 	end
-- 	-- end
-- 	-- if(GWorld.DefaultDevice) then
-- 	-- 	return GWorld.DefaultDevice
-- 	-- end
-- 	-- if not WorldContextObject then
-- 	-- 	WorldContextObject = GWorld.GameInstance
-- 	-- end
-- 	-- -- 传WorldContextObject的话可以通过编辑器下改PreviewDevices来切换平台
-- 	-- local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(WorldContextObject)
-- 	-- if (PlatformName == "IOS" or PlatformName == "Android") then
-- 	-- 	return CommonConst.CLIENT_DEVICE_TYPE.MOBILE
-- 	-- elseif (PlatformName == "Mac" or PlatformName == "Windows" ) then
-- 	-- 	return CommonConst.CLIENT_DEVICE_TYPE.PC
-- 	-- end
-- 	-- return CommonConst.CLIENT_DEVICE_TYPE.OTHER
-- 	return GetDeviceTypeByPlatformName(WorldContextObject)
-- end

-- function CommonUtils.GetRealDevicePlatformName(WorldContextObject)
-- 	if not WorldContextObject then
-- 		WorldContextObject = GWorld.GameInstance
-- 	end
-- 	-- 传WorldContextObject的话可以通过编辑器下改PreviewDevices来切换平台
-- 	local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(WorldContextObject)
-- 	if (PlatformName == "IOS" or PlatformName == "Android") then
-- 		return "Mobile"
-- 	elseif (PlatformName == "Mac" or PlatformName == "Windows" ) then
-- 		return "PC"
-- 	end
-- end

function CommonUtils.GetCurrentInputType()
	local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(GWorld.GameInstance)
	return GameInputModeSubsystem:GetCurrentInputType()
end

function CommonUtils.ChooseOptionByPlatform(PCOption,MoblieOption)
	if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
		if(PCOption == nil) then
			DebugPrint("ERROR: ChooseOptionByPlatform, PCOption == nil")
		end
		return PCOption
	else
		if(MoblieOption == nil) then
			DebugPrint("ERROR: ChooseOptionByPlatform, MoblieOption == nil, return PCOption")
			return PCOption
		end
		return MoblieOption
	end
end

function CommonUtils.Shuffle(T)
	for i = #T, 2, -1 do
		local j = math.random(1, i)
		T[i], T[j] = T[j], T[i]
	end
end

function CommonUtils.Reverse(T)
	local Count = #T
	if Count <= 1 then
		return
	end
	local MidIndex
	if Count % 2 == 0 then
		MidIndex = Count / 2
	else
		MidIndex = (Count - 1) / 2
	end
	for i = 1, MidIndex, 1 do
		T[i], T[Count+1-i] = T[Count+1-i], T[i]
	end
end

function CommonUtils.Bind(t, f)
	return function (...)
		return f(t, ...)
	end
end

-- 数组取交集
function CommonUtils.Intersection_Table(T1, T2)
	local TempResult = {}
	for _, Target in pairs(T1) do
		TempResult[Target] = 1
	end
	local Results = {}
	for _, Target in pairs(T2) do
		if TempResult[Target] then
			table.insert(Results, Target)
		end
	end
	return Results
end

function CommonUtils.VectorToTable(Vector)
	return {
		X = Vector.X,
		Y = Vector.Y,
		Z = Vector.Z,
	}
end

function CommonUtils.TableToVector(VectorTable)
	return FVector(VectorTable.X, VectorTable.Y, VectorTable.Z)
end

function CommonUtils.AngleBetweenVectors(VectorA, VectorB)
	if this.VectorA then
		this.VectorA.X = VectorA.X
		this.VectorA.Y = VectorA.Y
		this.VectorA.Z = VectorA.Z
	else
		this.VectorA = FVector(VectorA.X, VectorA.Y, VectorA.Z)
	end
	if this.VectorB then
		this.VectorB.X = VectorB.X
		this.VectorB.Y = VectorB.Y
		this.VectorB.Z = VectorB.Z
	else
		this.VectorB = FVector(VectorB.X, VectorB.Y, VectorB.Z)
	end
	this.VectorA:Normalize()
	this.VectorB:Normalize()
	local DotValue = UE4.UKismetMathLibrary.Dot_VectorVector(this.VectorA, this.VectorB)
	return UE4.UKismetMathLibrary.Acos(DotValue)
end

function CommonUtils.CheckIsTarget(OtherActor)
	return UCharacterFunctionLibrary.IsEffectSource(OtherActor)
end

function CommonUtils.NewEmptyProxy()
	local _EmptyProxy = {}
	setmetatable(_EmptyProxy, {
		__call = function()
			return nil
		end,
		__index = function()
			return _EmptyProxy
		end,
		__newindex = function(t, k, v)
			rawset(_EmptyProxy, k, v)
			return nil
		end,
	})
	return _EmptyProxy
end

CommonUtils.EmptyProxy = CommonUtils.NewEmptyProxy()

function CommonUtils.Keys(Table)
	local keys = {}
	for k,v in pairs(Table) do
		table.insert(keys, k)
	end
	return keys
end

function CommonUtils.TableLength(InTable)
	if not InTable then
		return 0
	end
	local Length = 0
	for k, v in pairs(InTable) do
		Length = Length + 1
	end
	return Length
end

function CommonUtils.GetCountStr(Number,Digit,Delimiter)
	--返回一个N位分节整数字符串，默认以","分隔(输入： Number = -1234567 输出： -1,234,567 )
    Number = math.floor(Number or 0) 
    Digit = Digit or 3
    Delimiter = Delimiter or ","
	local Sign = ""
	local Num = Number
	if(Num < 0)then
		Num = Num * -1
		Sign = "-"
    end
    local Str = ""
    local DigitCount = 0
    while(Num ~= 0)do
        Str = Str .. Num % 10
        Num = Num // 10
        DigitCount = DigitCount + 1
        if( Num > 0 and (DigitCount % Digit) == 0 )then
            Str = Str .. Delimiter
        end
    end
	if(Str == nil or Str == "")then
        return "0"
    end
    Str = string.reverse(Str)
	Str = Sign .. Str
    return Str
end

function CommonUtils:RandomSeed()
	math.randomseed(tostring(os.time()):reverse():sub(1, 7))
end

-- [0, 1)随机浮点数
function CommonUtils:RandomFloat()
	self:RandomSeed()
	return math.random()
end

-- (0, 1]随机浮点数
function CommonUtils:RandomReverseFloat()
	self:RandomSeed()
	return 1 - math.random()
end

-- [m,n]
function CommonUtils:RandomInt(m, n)
	self:RandomSeed()
	return math.random(m, n)
end

function CommonUtils:GetCharMaxLevel()
    local MaxLevel = 0
    for level, _ in pairs(DataMgr.LevelUp) do
        MaxLevel = math.max(level, MaxLevel)
    end
    return MaxLevel
end

function CommonUtils:ToStringEx(value)
	local ValueType = type(value)
    if ValueType=='table' then
       return CommonUtils:TableToStr(value)
    elseif ValueType=='string' then
        return "\""..value.."\""
	elseif ValueType == "number" or ValueType == "boolean" then
		return tostring(value)
    else
	   return "\""..tostring(value).."\""
    end
end

function CommonUtils:TableToStr(t)
    if t == nil then return "" end
    local retstr= "{"

    local i = 1
    for key,value in pairs(t) do
        local signal = ","
        if i==1 then
          signal = ""
        end

        if key == i then
            retstr = retstr..signal..CommonUtils:ToStringEx(value)
        else
            if type(key)=='number' or type(key) == 'string' then
				retstr = retstr..signal.."["..CommonUtils:ToStringEx(key).."]="..CommonUtils:ToStringEx(value)
            else
                if type(key)=='userdata' then
                    retstr = retstr..signal.."*s"..CommonUtils:TableToStr(getmetatable(key)).."*e".."="..CommonUtils:ToStringEx(value)
                else
                    retstr = retstr..signal..key..":"..CommonUtils:ToStringEx(value)
                end
            end
        end

        i = i+1
    end

     retstr = retstr.."}"
     return retstr
end

function CommonUtils:StrToTable(str)
	if str == nil or type(str) ~= "string" or str == "" then
		return {}
	end

	return load("return " .. str)()
end

function CommonUtils.Round(FloatValue)
	if FloatValue == 0 then return 0 end
	if FloatValue > 0 then return math.floor(FloatValue + 0.5)
	else return -CommonUtils.Round(-FloatValue) end
end

CommonUtils.AttrConvert = {
    Hp = CommonUtils.Round,
    MaxHp = CommonUtils.Round,
    ES = CommonUtils.Round,
    MaxES = CommonUtils.Round,
	MagazineCapacity = CommonUtils.Round,
	MagazineBulletNum = CommonUtils.Round,
	Sp = CommonUtils.Round,
	MaxSp = CommonUtils.Round,
	BulletNum = CommonUtils.Round,
}

function CommonUtils:ShouldDisplayAttr(AttrId,Value,OwnerType,OwnerTag,OwnerId)
    local Data = DataMgr.AttrConfig[AttrId]
    if Data and Data.ShowInInspector then
        if OwnerType == "Weapon" then
			local UIHiddenAttrs = OwnerId and DataMgr.BattleWeapon[OwnerId].UIHiddenAttrs
			if(UIHiddenAttrs)then
				for _, value in ipairs(UIHiddenAttrs) do
					if(AttrId == value)then
						return false
					end
				end
			end
            local WeaponAttrData = DataMgr.BattleWeaponAttr[AttrId]
            if WeaponAttrData then
                if not WeaponAttrData[OwnerTag.."WeaponAttrDisplay"] or WeaponAttrData[OwnerTag.."WeaponAttrDisplay"] == "AlwaysTrue" then
                    return true
                elseif WeaponAttrData[OwnerTag.."WeaponAttrDisplay"] == "OnlyModified" and Value ~= nil and WeaponAttrData.DefaultValue ~= Value then
                    return true
                end
            end
        else
			local RoleAttrData = DataMgr.BattleCharAttr[AttrId]
			if RoleAttrData then
				if(not RoleAttrData.RoleAttrDisplay or RoleAttrData.RoleAttrDisplay == "AlwaysTrue")then
					return true
				elseif RoleAttrData.RoleAttrDisplay == "OnlyModified" and Value ~= nil and RoleAttrData.DefaultValue ~= Value then
					return true
				end
			end
        end
    end
end

--判断日期是否合法 2月允许29天
function CommonUtils:CheckBirthday(Month,Day)
	if Month < 1 or Month > 12 or Day < 1 then
		return false
	end
	if Month == 4 or Month == 6 or Month == 9 or Month == 11 then
		if Day > 30 then
			return false
		end
	elseif Month == 2 then
		if Day > 29 then
			return false
		end
	else
		if Day > 31 then
			return false
		end
	end
	return true
end

---@param ActionName String:操作映射名称
---@param IsGamepad Bool:是否是手柄按键
--获取对应的操作映射按键名
function CommonUtils:GetActionMappingKeyName(ActionName,IsGamepad)
	local Avatar = GWorld:GetAvatar()
	if Avatar and Avatar.ActionMapping:Length() > 0 and Avatar.ActionMapping[ActionName] and not IsGamepad then
		return Avatar.ActionMapping[ActionName]
	else
		local InputSetting = UE4.UInputSettings.GetInputSettings()
		local ActionKeys = UE4.TArray(UE4.FInputActionKeyMapping)
		InputSetting:GetActionMappingByName(ActionName, ActionKeys)
		for Index,Value in pairs(ActionKeys) do
			if IsGamepad then
				if string.find(Value.Key.KeyName,'Gamepad') ~= nil then
					return Value.Key.KeyName
				end
			else
				if string.find(Value.Key.KeyName,'Gamepad') == nil then
					return Value.Key.KeyName
				end
			end
		end
	end
	return ''
end

---@param KeyName String:快捷键名称
--获取快捷键文本
function CommonUtils:GetKeyText(KeyName)
	local KeyInfo = DataMgr.KeyboardText[KeyName]
	if KeyInfo and KeyInfo.KeyText then
		return GText(KeyInfo.KeyText)
	end
	return KeyName
end

---@param ActionName String:操作映射名称,wasd
--获取对应的WASD功能的按键名
function CommonUtils:GetWASDKeyName(ActionName)
	local Ret = ActionName or ''
	if not ActionName then return Ret end
	local Avatar = GWorld:GetAvatar()
	if Avatar and Avatar.ActionMapping:Length() > 0 and Avatar.ActionMapping[ActionName] then
		Ret = Avatar.ActionMapping[ActionName]
	end
	return Ret
end

function CommonUtils:StringReplaceActionName(Str)
	local StrArray = Split(Str, "&")
    for i=2,#StrArray, 2 do
        local ReplaceStr = CommonUtils:GetKeyText(CommonUtils:GetActionMappingKeyName(StrArray[i]))
        local OldStr = "&" .. StrArray[i] .. "&"
        Str = string.gsub(Str, OldStr, ReplaceStr)
    end
	return Str
end

function CommonUtils:GetKeyName(ActionName)
    local InputSetting = UE4.UInputSettings.GetInputSettings()
    local ActionKeys = UE4.TArray(UE4.FInputActionKeyMapping)
    InputSetting:GetActionMappingByName(ActionName, ActionKeys)
    local CurrentInputDevice = {"KeyboardKey","MouseButton"}
    for i,KeyMap in pairs(ActionKeys) do
        local key = KeyMap.Key
        for i,v in pairs(CurrentInputDevice) do
            if UE4.UKismetInputLibrary["Key_Is"..v](key) then
                local res = UE4.UFormulaFunctionLibrary.Key_GetFName(key)
                local res_TextMap_index = string.gsub(res," ","_")
                res = res_TextMap_index
                if v=="KeyboardKey" and DataMgr.TextMap[res] then
                    res = GText(res)
                end
                return res, v
            end
        end
    end
    return nil, nil
end
function CommonUtils.MergeTables(baseTable, mergeTable)
	local function isSequentialTable(t)
		local i = 0
		for _ in pairs(t) do
			i = i + 1
			if t[i] == nil then return false end
		end
		return true
	end

	for key, value in pairs(mergeTable) do
		if type(value) == "table" and type(baseTable[key]) == "table" then
			-- 如果两个表中都有这个键，且对应的值也是表，则递归合并
			if isSequentialTable(value) and isSequentialTable(baseTable[key]) then
				baseTable[key] = value
			else
				CommonUtils.MergeTables(baseTable[key], value)
			end
		else
			-- 否则，直接用第二个表的值覆盖第一个表的值
			baseTable[key] = value
		end
	end
    return baseTable
end

function CommonUtils:GetCurrentAspectRatioAndFOV()
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	local AspectRatio
	local FOV
	local bConstrainAspectRatio
	if IsValid(Player) then
		AspectRatio = Player.CharCameraComponent.AspectRatio
		FOV = Player.CharCameraComponent.FieldOfView
		bConstrainAspectRatio = Player.CharCameraComponent.bConstrainAspectRatio
	end
	-- 返回角色相机的参数，去设置过场相机的参数
	return AspectRatio, FOV, bConstrainAspectRatio
end

---设置Actor及其组件可在暂停时tick
function CommonUtils:SetActorTickableWhenPaused(TargetActor, bTickable)
    if TargetActor ~= nil and  IsValid(TargetActor) then
        TargetActor:SetTickableWhenPaused(bTickable)
        local Components = TargetActor:K2_GetComponentsByClass(UActorComponent:StaticClass())
            if Components then
            for _, _Component in pairs(Components) do
                URuntimeCommonFunctionLibrary.SetComponentTickableWhenPaused(_Component, bTickable)
            end
        end

        if URuntimeCommonFunctionLibrary.ObjIsChildOf(TargetActor, ACharacterBase) then
            local Attaches = TargetActor:GetAllAttaches()
            if Attaches then
                self:SetActorsTickableWhenPaused(Attaches, bTickable)
            end
        end
    end
end

function CommonUtils:SetActorsTickableWhenPaused(TargetActors,bTickable)
    if not TargetActors then
        return
    end

    for _,TargetActor in pairs(TargetActors) do
        self:SetActorTickableWhenPaused(TargetActor, bTickable)
   end
end

---@note 极性一致时，Mod的耐受值算法
function CommonUtils:PerfectPolarityCost(Cost)
    return math.ceil(Cost*DataMgr.GlobalConstant.PerfectModPolarity.ConstantValue)
end

---@note 极性不一致，Mod的耐受值算法
function CommonUtils:WrongPolarityCost(Cost)
    return math.ceil(Cost*DataMgr.GlobalConstant.WrongModPolarity.ConstantValue)
end

--获取数字前N位
function CommonUtils:GetFrontNum(num, frontLength)
    local length = CommonUtils:GetIntNumLength(num)
    local frontNum = num // math.floor(10 ^ (length - frontLength))
    return frontNum
end

--获取整形数字长度
function CommonUtils:GetIntNumLength(num)
    local length = 0
    while num > 0 do
        num = num // 10
        length = length + 1
    end
    return length
end

function CommonUtils:DataToFTransform(Data)
	local Rotation = Data.Rotation and UE4.FRotator(Data.Rotation[2], Data.Rotation[3], Data.Rotation[1]) or FRotator(0, 0, 0)
	local Location = Data.Location and FVector(Data.Location[1], Data.Location[2], Data.Location[3]) or FVector(0, 0, 0)
	local Scale = Data.scale and FVector(Data.scale[1],Data.scale[2],Data.scale[3]) or FVector(1, 1, 1)
    return FTransform(Rotation:ToQuat(),Location,Scale)
end

function CommonUtils:CloseGuideTouchIfExist(widget)
	local GameInstance = UE4.UGameplayStatics.GetGameInstance(widget)
    local UIManger = GameInstance:GetGameUIManager()
	local GuideTouch = UIManger:GetUIObj(UIManger.CurGuideTouchName)
	if(GuideTouch) then
		GuideTouch:PlayOutAnimation()
	end
end

--临时处理 最好改源码统一处理 TODO
function CommonUtils:IfExistSystemGuideUI(widget)
	local GameInstance = UE4.UGameplayStatics.GetGameInstance(widget) or GWorld.GameInstance
    local UIManger = GameInstance:GetGameUIManager()
	local GuideTouch = UIManger:GetUIObj(UIManger.CurGuideTouchName)
	if(GuideTouch) then
		return true
	end
	local GuideTextBox = UIManger:GetUIObj("GuideTextBox")
	if(GuideTextBox) then
		return true
	end
	local GuideMain = UIManger:GetUIObj("GuideMain")
	if(GuideMain) then
		return true
	end
	return false
end

function CommonUtils:SerializeFTransform(Transform)
	return Transform.Translation.X..","..Transform.Translation.Y..","..Transform.Translation.Z.."|"
			..Transform.Rotation.X..","..Transform.Rotation.Y..","..Transform.Rotation.Z..","..Transform.Rotation.W.."|"
			..Transform.Scale3D.X..","..Transform.Scale3D.Y..","..Transform.Scale3D.Z
end

function CommonUtils:UnSerializeFTransform(TransformString)
	local Translation, Rotation, Scale3D = table.unpack(self.Split(TransformString, "|"))
	local Result = FTransform()
	Result.Translation.X, Result.Translation.Y, Result.Translation.Z = table.unpack(self.Split(Translation, ","))
	Result.Rotation.X, Result.Rotation.Y, Result.Rotation.Z, Result.Rotation.W = table.unpack(self.Split(Rotation, ","))
	Result.Scale3D.X, Result.Scale3D.Y, Result.Scale3D.Z = table.unpack(self.Split(Scale3D, ","))
	return Result
end

function CommonUtils:FocalLengthToFOV(FocalLength)
	return 2 * math.atan(36 / (2 * FocalLength) ) * (180 / math.pi)
end

-- 搜索列表{id = Content} 搜索词 是否开启搜索词高亮
function CommonUtils.FuzzySearch(TargetList, Phase, NeedHighlightWord)
	local Result = {}
	if TargetList and Phase then
		for Id, Content in pairs(TargetList) do
			if (not Result[Id]) then
				local IsInContent,Ranges = CommonUtils.IsInContent(Content, Phase, NeedHighlightWord)
				if IsInContent then
					if NeedHighlightWord then
						Content = CommonUtils.HighLightContent(Content, "<Highlight>", Ranges)
					end
					Result[Id] = Content
				end
			end
		end
	end
	return Result
end

function CommonUtils.CheckFuzzySearchWithSinglePhase(CheckList, Phase, bIsAllMatch)
	local IsFinalSuccess = false
	if (bIsAllMatch) then
		IsFinalSuccess = true
		for _, CheckValue in ipairs(CheckList) do
			local IsInContent,Ranges = CommonUtils.IsInContent(CheckValue, Phase)
			if (not IsInContent) then
				IsFinalSuccess = false
				break
			end
		end
	else
		for _, CheckValue in ipairs(CheckList) do
			local IsInContent,Ranges = CommonUtils.IsInContent(CheckValue, Phase)
			if (IsInContent) then
				IsFinalSuccess = true
				break
			end
		end
	end
	return IsFinalSuccess
end


function CommonUtils.IsInContent(Content, Word, NeedHighlightWord)
	local WordArray = {}
	-- lua中的魔法字符需要特殊处理
	local SpecialCharacters = { "%", ".", "*", "+", "-", "?", "[", "]", "(", ")", "^", "$" }
	for _, Char in ipairs(SpecialCharacters) do
		Word = string.gsub(Word, "%"..Char, "%%%1")
	end
	for Char in string.gmatch(Word, ".[\128-\191]*") do
		table.insert(WordArray, Char)
	end
	local Ranges = {}
	local Pos = 1
	for i, Char in ipairs(WordArray) do
		
		if i > 1 and WordArray[i-1] == "%" then
			Char = "%"..Char
		elseif Char == "%" then
			Char = nil
		end
		if Char then
			local StartPos, EndPos = string.find(Content, Char, Pos)
			if NeedHighlightWord then
				if StartPos and EndPos then
					table.insert(Ranges, {[1] = StartPos, [2] = EndPos})
				end
			end
			if StartPos then
				Pos = EndPos + 1
			else
				return false
			end
		end
	end
	if NeedHighlightWord then
		return true, Ranges
	else
		return true
	end
end

function CommonUtils.HighLightWord(Type, Str, WordStart, WordEnd)
	local InsertStrStart = Type
	local InsertStrEnd = "</>"
	local first = string.sub(Str, 1, WordStart - 1)
	local Middle = string.sub(Str, WordStart, WordEnd)
	local last = string.sub(Str, WordEnd+1, -1)
	return string.format("%s%s%s%s%s",first,InsertStrStart,Middle,InsertStrEnd,last)
end

-- Type可以是 <Warning> <Highlight> <Default> 等
function CommonUtils.HighLightContent(Content, Type, Ranges)
	local InsertStrStart = Type
	local InsertStrEnd = "</>"
	local Res = Content
	for i, v in pairs(Ranges) do
		local ExtraWord = string.len(InsertStrStart) + string.len(InsertStrEnd)
		local ExtraLength = ExtraWord * (i - 1)
		Res = CommonUtils.HighLightWord(Type, Res, v[1] + ExtraLength, v[2] + ExtraLength)
	end
	return Res
end

function CommonUtils.CheckDestroyReason(DestroyReason, Operation)
	local Reason = EDestroyReason:GetNameByValue(DestroyReason)
	local OperationMap = DataMgr.DestroyReason[Reason]
	if not OperationMap then
		ScreenPrint("销毁时传入的DestroyReason没有填写在DestroyReason表中。DestroyReason:"..Reason)
		return false
	end
	local Res = OperationMap[Operation]
	if Res == nil then
		--ScreenPrint("销毁时操作没有填写在DestroyReason表中。Operation", Operation)
		return false
	end
	--DebugPrint("CheckDestroyReason_结果", Res, Reason, Operation)
	return Res
end

function CommonUtils:IsWidgetHide(Widget)
	if Widget:GetVisibility() == UE4.ESlateVisibility.Collapsed or Widget:GetVisibility() == UE4.ESlateVisibility.Hidden or (Widget:GetRenderOpacity() == 0 and Widget:Cast(UE4.UButton) == nil) then
		return true
	end
	if Widget:GetParent() == nil then
		return false
	end
	return CommonUtils:IsWidgetHide(Widget:GetParent())
end

---通用的排序值比较
function CommonUtils:Compare(Val1, Val2, SortType)
	if not SortType then SortType = CommonConst.DESC end
    if SortType == CommonConst.DESC then 
        return Val1>Val2
    end
    return Val1<Val2
end

function CommonUtils:DisableScroll(ScrollBox,IsDisable)
	ScrollBox:DisableDrag(IsDisable)
    if IsDisable then
        ScrollBox:SetWheelScrollMultiplier(0)
    else
        ScrollBox:SetWheelScrollMultiplier(1)
    end
end

function CommonUtils:TeleportToCloestTeleportPoint(TriggerBoxID)
    -- local Player=UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    -- if not Player then
    --     return
    -- end
    -- local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    -- if not GameState then
    --     return
    -- end
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    -- if not GameMode then
    --     return
    -- end
    -- local StaticCreator = GameState.StaticCreatorMap:FindRef(TriggerBoxID)
    -- if not StaticCreator then
    --     return
    -- end
    -- local TargetLoc = StaticCreator:k2_GetActorLocation() 
    -- Player:TeleportToCloestTeleportPoint(nil, TargetLoc)
end

function CommonUtils.GetClientTimerStructRemainTime(TimerHandle)
	local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
	if not GameState then
        return 0
    end
    local Info = GameState.ClientTimerStruct:GetTimerInfo(TimerHandle)
	if Info.IsRealTime then
    	return Info.Time - (GameState.ReplicatedRealTimeSeconds - Info.RealTimeSeconds)
	else
		return Info.Time - (GameState.ReplicatedTimeSeconds - Info.TimeSeconds)
	end
end

function CommonUtils.GetClientTimerStructTotalTime(TimerHandle)
	local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
	if not GameState then
        return 0
    end
    local Info = GameState.ClientTimerStruct:GetTimerInfo(TimerHandle)
	if Info and Info.Time then
		return Info.Time
	else
		return 0
	end
end

function CommonUtils.GetClientTimerStructPassedTime(TimerHandle)
	local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
	if not GameState then
        return 0
    end
    local Info = GameState.ClientTimerStruct:GetTimerInfo(TimerHandle)
	if Info.IsRealTime then
    	return GameState.ReplicatedRealTimeSeconds - Info.RealTimeSeconds
	else
		return GameState.ReplicatedTimeSeconds - Info.TimeSeconds
	end
end

function CommonUtils.HasClientTimerStruct(TimerHandle)
	if not TimerHandle then
		return false
	end
	local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
	if not GameState then
        return false
    end
	local Info = GameState.ClientTimerStruct:GetTimerInfo(TimerHandle)
	return Info.Key ~= "None"
end

function CommonUtils.GetDungeonUIParams(UIName)
	local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
	-- 目前只给区域用
	if not GameState:IsInRegion() then
		return false, nil
	end

	local UIParamID = GameState.CurDungeonUIParamID

	if not UIName then
		return false, nil
	end
	if not UIParamID then
		return false, nil
	end

	local UIParamData = DataMgr.DungeonUIParams[UIParamID]
	if not UIParamData then
		return false, nil
	end
	
	local CurIndex = 0
	for i, _UIName in pairs(UIParamData.UIName) do
		if _UIName == UIName then
			CurIndex = i
			break
		end
	end
	if CurIndex == 0 then
		return false, nil
	end

	return true, UIParamData.UIParams[CurIndex]
end

function CommonUtils.HasGamePlayTag(SourceTags, TargetTag)
	if not SourceTags then
		return false
	end

	if type(SourceTags) ~= "table" then
		return string.find(SourceTags, TargetTag)
	end

	for i=1, #SourceTags do
		local Tag = SourceTags[i]
		if string.find(Tag, TargetTag) then
			return true
		end
	end

	return false
end

function CommonUtils.CalcNameLength(name)
    -- 判断是否英文字符
    local function is_english_char(c)
        return (c >= 0x41 and c <= 0x5A) or (c >= 0x61 and c <= 0x7A) -- A-Z or a-z
    end
    local len = 0
    for _, c in utf8.codes(name) do
        if is_english_char(c) then
            len = len + 1
        else
            len = len + 2
        end
    end
    return len
end


-- format 格式 :
-- local ServerConfig = {
--     [101] = {
--         ServerID = 101,
--         DevFlag = "Development",
--         GroupId = 101,
--         Name = "开发服",
--     },
--     [102] = {
--         ServerID = 102,
--         DevFlag = "Development",
--         GroupId = 102,
--         Name = "分支服",
--     },
-- }
function CommonUtils.TableToString2(tbl, compressed)
    local ret = {}  -- 用 table 收集字符串
    local indent = 1
    local indentStr = "    "
    local indentCache = { ["0"] = "" }  -- 缓存缩进

    -- 预生成缩进
    local function getIndent(level)
        if not indentCache[level] then
            indentCache[level] = indentStr:rep(level)
        end
        return indentCache[level]
    end

    local function append(str)
        ret[#ret + 1] = str
    end

    local function exportstring(s)
        s = string.format("%q", s)
        s = s:gsub("\\\n", "\\n")
        s = s:gsub("\r", "")
        s = s:gsub(string.char(26), "\"..string.char(26)..\"")
        return s
    end

    local function serialize(o, level)
        if type(o) == "number" then
            append(tostring(o))
        elseif type(o) == "boolean" then
            append(o and "true" or "false")
        elseif type(o) == "string" then
            append(exportstring(o))
        elseif type(o) == "table" then
            append("{" .. (compressed and "" or "\n"))
            local newIndent = level + 1
            local tab = getIndent(newIndent)
            for k, v in pairs(o) do
                append((compressed and "" or tab) .. "[")
                serialize(k, newIndent)
                append("]" .. (compressed and "=" or " = "))
                serialize(v, newIndent)
                append("," .. (compressed and "" or "\n"))
            end
            append((compressed and "" or getIndent(level)) .. "}")
        else
            print("unable to serialize data: " .. tostring(o))
            append("nil," .. (compressed and "" or " -- ***ERROR: unsupported data type: " .. type(o) .. "!***"))
        end
    end

    append("return {" .. (compressed and "" or "\n"))
    for k, v in pairs(tbl) do
        append((compressed and "" or getIndent(indent)) .. "[")
        serialize(k, indent)
        append("]" .. (compressed and "=" or " = "))
        serialize(v, indent)
        append("," .. (compressed and "" or "\n"))
    end
    append("}")

    return table.concat(ret)
end

function CommonUtils.ConvertServerList(Info)
	local Temp = {}
    Temp.hostnum = Info.hostnum
	if Info.server_area == "Asian" then
		Temp.area = "Asia"
	else
		Temp.area = Info.server_area
	end
    Temp.name = Info.name
	if Info.login_ip and Info.login_port then
		Temp.ip = Info.login_ip
		Temp.port = Info.login_port
	else
		Temp.ip = Info.outer_ip
		Temp.port = Info.gate_port
	end
	if Info.is_recommend then
		Temp.is_recommend = true
	else
		Temp.is_recommend = false
	end
	Temp.recommend_weight = Info.recommend_weight or 0
	return Temp
end

function CommonUtils.UploadStrToCDN(signatureUrl,file_content,file_name)
    -- 获取签名认证密钥对
	local http = require("socket.http")
	local ltn12 = require("ltn12")
    local response_body = {}
    local res, status, headers = http.request {
        url = signatureUrl,
        method = "GET",
        sink = ltn12.sink.table(response_body)
    }
    if status ~= 200 or not response_body then
        print("HTTP request failed with status:", status)
        return
    end
    
    -- 解析密钥对
    local data = Json.decode(table.concat(response_body))
    if not data then
        print("Json decode failed")
        return
    end

    local OSSAccessKeyId = data.accessid
    local policy = data.policy
    local signature = data.signature
    local ossUrl = data.host

    -- 构建Post Body
    local boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
    local body = "--" .. boundary .. "\r\n"
    body = body .. "Content-Disposition: form-data; name=\"OSSAccessKeyId\"\r\n\r\n" 
    body = body .. OSSAccessKeyId .. "\r\n"
    body = body .. "--" .. boundary .. "\r\n"
    body = body .. "Content-Disposition: form-data; name=\"policy\"\r\n\r\n" 
    body = body .. policy .. "\r\n"
    body = body .. "--" .. boundary .. "\r\n"
    body = body .. "Content-Disposition: form-data; name=\"signature\"\r\n\r\n"
    body = body .. signature .. "\r\n"
    body = body .. "--" .. boundary .. "\r\n"
    body = body .. "Content-Disposition: form-data; name=\"key\"\r\n\r\n"
    body = body .. file_name .. "\r\n"
    body = body .. "--" .. boundary .. "\r\n"
    body = body .. "Content-Disposition: form-data; name=\"file\"; filename=\"" 
    body = body .. file_name .. "\"\r\n"
    body = body .. "Content-Type: text/plain\r\n\r\n"
    body = body .. file_content .. "\r\n"
    body = body .. "--" .. boundary .. "--\r\n"

    local response_body = {}

    http.request({
        method = "POST",
        url = ossUrl,
        source = ltn12.source.string(body),
        headers = {
            ["Content-Type"] = "multipart/form-data; boundary=" .. boundary,
            ["Content-Length"] = #body
        },
        sink = ltn12.sink.table(response_body)
    })
    -- print("body:",body)
    print("response_body:",table.concat(response_body))
end

-- format 格式 :
-- local ServerConfig = {
--     [101] = { ServerID = 101, DevFlag = "Development", GroupId = 101, Name = "开发服" },
--     [102] = { ServerID = 102, DevFlag = "Development", GroupId = 102, Name = "分支服" }
-- }
function CommonUtils.TableToString3(tbl)
    local ret = {}

    local function append(str)
        ret[#ret + 1] = str
    end

    local function exportstring(s)
        s = string.format("%q", s)
        return s:gsub("\\\n", "\\n"):gsub("\r", "")
    end

    -- 检查字符串是否可以作为 Lua 变量名（仅包含字母、数字、下划线，且不以数字开头）
    local function isValidLuaIdentifier(s)
        return type(s) == "string" and s:match("^[a-zA-Z_][a-zA-Z0-9_]*$") ~= nil
    end

    local function getSortedKeys(t)
        local keys, isNumeric = {}, true
        for k in pairs(t) do
            if type(k) ~= "number" then
                isNumeric = false
            end
            table.insert(keys, k)
        end
        if isNumeric then
            table.sort(keys) -- 数字键进行排序
        else
            table.sort(keys, function(a, b) return tostring(a) < tostring(b) end) -- 字符串按字典序排序
        end
        return keys
    end

    local function serialize(o, level)
        if type(o) == "number" then
            return tostring(o)
        elseif type(o) == "boolean" then
            return o and "true" or "false"
        elseif type(o) == "string" then
            return exportstring(o)
        elseif type(o) == "table" then
            local elements = {}
            local isDeepOne = (level == 1)  -- 只有第一层需要换行

            local sortedKeys = getSortedKeys(o)
            for _, k in ipairs(sortedKeys) do
                local v = o[k]
                local key
                if type(k) == "string" and isValidLuaIdentifier(k) then
                    key = k  -- 直接使用 Lua 变量名
                else
                    key = "[" .. serialize(k, level + 1) .. "]"  -- 数字键或非法变量名仍用 `[...]`
                end

                local value = serialize(v, level + 1)
                if isDeepOne then
                    table.insert(elements, "    " .. key .. " = " .. value .. ",")
                else
                    table.insert(elements, key .. " = " .. value)
                end
            end

            if isDeepOne then
                return "{\n" .. table.concat(elements, "\n") .. "\n}"
            else
                return "{ " .. table.concat(elements, ", ") .. " }"
            end
        else
            return "nil"
        end
    end
	append("return " .. serialize(tbl, 1) .. "\n")
    return table.concat(ret)
end

function CommonUtils.RotationToTable(Rotation)
	local NewRotation = {}
	NewRotation.Pitch = Rotation.Pitch
	NewRotation.Yaw = Rotation.Yaw
	NewRotation.Roll = Rotation.Roll
	return NewRotation
end

function CommonUtils.LocationToTable(TargetLocation)
	local NewLocation = {}
	NewLocation.X = TargetLocation.X
	NewLocation.Y = TargetLocation.Y
	NewLocation.Z = TargetLocation.Z
	return NewLocation
end

function CommonUtils.GetWeaponTypeById(WeaponId)
	local Data = DataMgr.BattleWeapon[WeaponId]
	if(not Data)then
		return
	end
	if CommonUtils.HasValue(Data.WeaponTag, CommonConst.WeaponType.MeleeWeapon) then
		return CommonConst.WeaponType.MeleeWeapon
	elseif CommonUtils.HasValue(Data.WeaponTag, CommonConst.WeaponType.RangedWeapon) then
		return CommonConst.WeaponType.RangedWeapon
	end
end

--是否是当前外放版本
function CommonUtils.IsOpenVersion(OpenVersionId)
	if not OpenVersionId then
		return false
	end

	if DataMgr.CombatVersionOpenList[OpenVersionId] then
		return true
	else
		return false
	end
end

---某物当前版本是否外放
function CommonUtils.IsCurrentVersionRealease(TableName,Id)
	local Data = DataMgr[TableName] and DataMgr[TableName][Id]
	if(not Data)then
		return
	end
	if(not DataMgr.GlobalConstant.CurrentVersion or not Data.ReleaseVersion)then
		return true
	end
	return DataMgr.GlobalConstant.CurrentVersion.ConstantValue >= Data.ReleaseVersion
end

---某物是否当前版本新外放的
function CommonUtils.IsCurrentVersionNewRealease(TableName,Id)
	local Data = DataMgr[TableName] and DataMgr[TableName][Id]
	if(not Data)then
		return
	end
	if(not DataMgr.GlobalConstant.CurrentVersion or not Data.ReleaseVersion)then
		return
	end
	return DataMgr.GlobalConstant.CurrentVersion.ConstantValue == Data.ReleaseVersion
end

---某物当前时间是否外放
function CommonUtils.IsCurrentTimeRealease(TableName,Id)
	local Data = DataMgr[TableName] and DataMgr[TableName][Id]
	if(not Data)then
		return
	end
	if(Data.BeginTime)then
		local Time = TimeUtils.NowTime()
		if(Time < Data.BeginTime:GetTime())then
			return false
		end
	end
	return true
end

---@param CustomParams string AppearanceSuit.AccessoryCustomParams[id]
---@param AccessoryType string 客户端防挂用，一般不传
function CommonUtils.UnSerializeAccessoryCustomParams(CustomParams,AccessoryType)
    if(not CustomParams)then
        return
    end
    local Params = SerializeUtils:UnSerialize(CustomParams)
    local Position = FVector(0,0,0)
    if(Params.Position)then
        Position.X = Params.Position.X or 0
        Position.Y = Params.Position.Y or 0
        Position.Z = Params.Position.Z or 0
    end
    local Rotation = FRotator(0,0,0)
    if(Params.Rotation)then
        Rotation.Pitch = Params.Rotation.Pitch or 0
        Rotation.Yaw = Params.Rotation.Yaw or 0
        Rotation.Roll = Params.Rotation.Roll or 0
    end
    local Scale = FVector(1,1,1)
    if(Params.Scale)then
        Scale.X = Params.Scale
        Scale.Y = Params.Scale
        Scale.Z = Params.Scale
    end
	if(AccessoryType)then
		local Data = DataMgr.CustomOffset[AccessoryType]
		if(Data)then
			if(Data.LocationLimit)then
				math.clamp(Position.X,Data.LocationLimit[1],Data.LocationLimit[2])
				math.clamp(Position.Y,Data.LocationLimit[1],Data.LocationLimit[2])
				math.clamp(Position.Z,Data.LocationLimit[1],Data.LocationLimit[2])
			end
			if(Data.RotationLimit)then
				math.clamp(Rotation.Pitch,Data.RotationLimit[1],Data.RotationLimit[2])
				math.clamp(Rotation.Pitch,Data.RotationLimit[1],Data.RotationLimit[2])
				math.clamp(Rotation.Roll,Data.RotationLimit[1],Data.RotationLimit[2])
			end
			if(Data.ScaleLimit)then
				math.clamp(Scale.X,Data.ScaleLimit[1],Data.ScaleLimit[2])
				math.clamp(Scale.Y,Data.ScaleLimit[1],Data.ScaleLimit[2])
				math.clamp(Scale.Z,Data.ScaleLimit[1],Data.ScaleLimit[2])
			end
		end
	end
    return FTransform(Rotation:ToQuat(), Position, Scale)
end

function CommonUtils.DeepEqual(t1, t2, seen)
	-- 如果引用相同，直接返回true
	if t1 == t2 then return true end

	-- 处理seen表，防止循环引用
	seen = seen or {}
	local key = tostring(t1) .. ":" .. tostring(t2)
	if seen[key] then return true end
	seen[key] = true

	-- 类型不同直接返回false
	if type(t1) ~= type(t2) then return false end

	-- 非table类型直接比较值
	if type(t1) ~= "table" then return t1 == t2 end

	-- 检查key数量是否相同
	local count1, count2 = 0, 0
	for _ in pairs(t1) do count1 = count1 + 1 end
	for _ in pairs(t2) do count2 = count2 + 1 end
	if count1 ~= count2 then return false end

	-- 递归比较每个键值对
	for k, v1 in pairs(t1) do
		local v2 = t2[k]
		if not CommonUtils.DeepEqual(v1, v2, seen) then
			return false
		end
	end

	-- 反向检查，确保t2中不包含t1中没有的键
	for k, v2 in pairs(t2) do
		local v1 = t1[k]
		if v1 == nil then  -- 注意：nil和不存在是不同的
			return false
		end
	end

	return true
end

local function AddThousandsSeparator(text)
    -- 用于添加千分位分隔符的内部函数
    local function formatNumber(numberStr)
        -- 处理小数部分
        local integerPart, decimalPart = numberStr:match("^(%-?%d*)(%.?%d*)$")
        
        if not integerPart or integerPart == "" then
            return numberStr
        end
        
        -- 处理负数符号
        local sign = ""
        if integerPart:sub(1, 1) == "-" then
            sign = "-"
            integerPart = integerPart:sub(2)
        end
        
        -- 添加千分位分隔符
        local result = ""
        local len = #integerPart
        
        for i = 1, len do
            local digit = integerPart:sub(len - i + 1, len - i + 1)
            if i > 1 and i % 3 == 1 then
                result = digit .. "\u{00A0}" .. result  -- 不换行空格
            else
                result = digit .. result
            end
        end
        
        -- 返回格式化的数字
        return sign .. result .. decimalPart
    end

    -- 主替换逻辑
    -- 匹配数字模式：可选负号、数字、可选小数点和更多数字
    return text:gsub("[-]?%d+%.?%d*", function(match)
        return formatNumber(match)
    end)
end

function CommonUtils.FormatNumInFrench(ret)
	if CommonConst.SystemLanguage == CommonConst.SystemLanguages.FR then
        local CommaIdx = string.find(ret, ",", 1)
        if CommaIdx then
            ret = string.gsub(ret, ",","\u{00A0}")
        end
        local PeriodIdx = string.find(ret, "%.", 1)
        if PeriodIdx then
            ret = string.gsub(ret, "%.", ",")
        end
		DebugPrint("CommonUtils.FormatNumInFrench Before", ret)
		ret = AddThousandsSeparator(ret)
    end
	DebugPrint("CommonUtils.FormatNumInFrench After", ret)
	return ret
end

return CommonUtils

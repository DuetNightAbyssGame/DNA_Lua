local Utils = {}
local table_concat = table.concat
local tostring = tostring
local type = type
local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
local bEnableShippingLog = UE4.URuntimeCommonFunctionLibrary.EnableLogInShipping()
local TextUtils = require("Utils.TextUtils")
local MiscUtils = require "Utils.MiscUtils"

-- Utils.MontageProxyInstance = nil

---@class Utils
--Utils.PrintTable = function(Targets, Deep, Title)
--	if type(Targets) ~= "table" then
--		Targets = {Targets}
--	end
--	Deep = Deep or 1
--	local function get_table_str(t, step)
--		local s = ""
--		for k,v in pairs(t) do
--			for i = 1, step do
--				s = s.."\t"
--			end
--			local _type = type(v)
--			if (_type == "table") and v.IsValid and UE4.UKismetSystemLibrary.IsValid(v) then
--				_type = tostring(UE4.UKismetSystemLibrary.GetDisplayName(v))
--			end
--
--			local k_str = nil
--			local v_str = nil
--			if type(k) == "string" and CommonUtils.IsObjId(k) then
--				k_str = CommonUtils.ObjId2Str(k)
--			else
--				k_str = tostring(k)
--			end
--			if type(v) == "string" and CommonUtils.IsObjId(v) then
--				v_str = CommonUtils.ObjId2Str(v)
--			else
--				v_str = tostring(v)
--			end
--			s = s..k_str.." ("..tostring(type(k))..")"..": "..v_str.." ("..tostring(_type)..")".."\n"
--			if type(v) == "table" and step < Deep and (not v.IsValid or not UE4.UKismetSystemLibrary.IsValid(v)) then
--				s = s..get_table_str(v, step + 1)
--			end
--		end
--		return s
--	end
--	local ret = "PrintTable: "..tostring(Targets).."\n"
--	if Title then
--		ret = ret .. tostring(Title) .. ':\n'
--	end
--	if Targets then
--		ret = ret..get_table_str(Targets, 1)
--	end
--	print(LogTag, ret)
--end

Utils.PrintTable = (bDistribution and not bEnableShippingLog) and MiscUtils.EmptyFunction or function(Targets, deep, Title, PrettyFormat)
	if Targets == nil then
		return
	end

	if type(Targets) ~= "table" then
		print(LogTag, tostring(Targets))
		return
	end

	deep = deep or 1
	local ct = { "PrintTable: ", tostring(Title), tostring(Targets), "\n"}
	MiscUtils.GetStrTable(ct, Targets, 1, deep, PrettyFormat)
	local ret = table_concat(ct)
	print(LogTag, ret)
	return ret
end

Utils.Traceback = (bDistribution and not bEnableShippingLog) and MiscUtils.EmptyFunction or function(logTag, err, bNotPrint)
	local error = debug.traceback()
	if err then error = err.."\n"..error end
	if not logTag then 
		logTag = LogTag
	end
	if not bNotPrint then
		DebugPrint(logTag, error)
	end
	return error
end

-- 放在UnLuaLib.cpp的Open函数中，在非编辑器下使用其他逻辑获取
-- Utils.Battle = function(context)
-- 	return UE4.UGameplayStatics.GetGameState(context).Battle
-- end

Utils.IsStandAlone = function(Actor)
	return UNeModeFunctionLibrary.IsStandAlone(Actor)
end

Utils.IsDedicatedServer = function(Actor)
	if GWorld._IsDedicatedServer ~= nil and not GWorld.IsDev then
		return GWorld._IsDedicatedServer
	end
	return UNeModeFunctionLibrary.IsDedicatedServer(Actor)
end

Utils.IsClient = function(Actor)
	return UNeModeFunctionLibrary.IsClient(Actor)
end

Utils.IsAuthority = function(actor)
	return actor:GetLocalRole() == 3
end

Utils.New = function(Table)
	if Table == nil then
		return Table
	end

	if type(Table) ~= "table" then
		return Table
	end

    local Obj = {}
    local mt = getmetatable(Table)
    if mt ~= nil then
        setmetatable(Obj, mt)
    end

    for i, v in pairs(Table) do
        if type(v) == "table" then
            Obj[i] = New(v)
        else
            Obj[i] = v
        end
    end
    return Obj
end

Utils.IsEmptyTable = function(Table)
	return table.isempty(Table)
end

Utils.Split = function(str, reps)
    local Results = {}
    string.gsub(str,'[^'..reps..']+',function ( w )
        table.insert(Results, w)
    end)
    return Results
end

Utils.ScreenPrint = (bDistribution and not bEnableShippingLog) and MiscUtils.EmptyFunction or function (text)
	GWorld.logger.error(text)
	-- color = color or UE4.FLinearColor(1, 0, 0, 1)
 --    duration = duration or 4
	-- UE4.UKismetSystemLibrary.PrintString(nil, text, true, true, color, duration)
end

-- Utils.ObjId2Str = function(ObjId)
-- 	-- ObjId是一个长度为14的字符串
--     local ret = ""
-- 	if ObjId == nil then
-- 		return ""
-- 	end
-- 	for index=3,#ObjId do
-- 		ret = ret..string.format("%02X",string.byte(string.sub(ObjId,index,index)))
-- 	end
-- 	return "ObjectId(\'"..ret.."\')"
-- end

-- Utils.IsObjId = function (str)
--     if #str == 14 and string.byte(string.sub(str,1,1)) == 0 then
--         return true
--     end
--     return false
-- end

Utils.GLink = function(LinkId)
	local IsGlobalPak = UE.AHotUpdateGameMode.IsGlobalPak()
	local LinkInfo = DataMgr.PolicyLink[LinkId]
	if not LinkInfo then return nil end
	local Link = nil
	if IsGlobalPak then
		local SystemLanguage = EMCache:Get("SystemLanguage") or "EN"
		if LinkInfo then
			Link = LinkInfo["Abroad"..SystemLanguage] or LinkInfo.AbroadEN or LinkInfo.ChinaCN
		end
	else
		if LinkInfo then
			Link = LinkInfo.ChinaCN
		end
	end
	return Link
end
_G.Link = Utils.GLink --给智能提示插件提供识别信息

Utils.GText = function(Text)
	return TextUtils:GetDisplayText(Text)
end
_G.GText = Utils.GText  --给智能提示插件提供识别信息

Utils.EnText = function(Text)
	return TextUtils:GetDisplayText(Text, CommonConst.SystemLanguages.EN)
end
_G.EnText = Utils.EnText  --给智能提示插件提供识别信息

Utils.GDate = function(Month, Day, Language) 
	Language = Language or CommonConst.SystemLanguage
	if  Language == CommonConst.SystemLanguages.CN or 
		Language == CommonConst.SystemLanguages.JP or 
		Language == CommonConst.SystemLanguages.KR then 
		return string.format("%02d-%02d", Month, Day)
	else
		return string.format("%02d-%02d", Day, Month)
	end
end

Utils.GDate_YMD = function(Year, Month, Day, Language)
	Language = Language or CommonConst.SystemLanguage
	if  Language == CommonConst.SystemLanguages.CN or 
		Language == CommonConst.SystemLanguages.JP or 
		Language == CommonConst.SystemLanguages.KR then 
		
		return string.format("%02d-%02d-%02d", Year, Month, Day)
	else
		return string.format("%02d-%02d-%02d", Day, Month, Year)
	end
end

Utils.GDate_YMD_Timestamp = function(Timestamp, Language)
	local Date = os.date("*t",Timestamp)
	return Utils.GDate_YMD(Date.year, Date.month, Date.day, Language)
end

Utils.Split = function(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter == "") then return false end
    local pos, arr = 0, {}
    for st, sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end


---@note 全局获取UIManager
---@return BP_UIManagerComponent_C
Utils.UIManager = function(context)
	if not Utils.IsValid(Utils._UIManager) then
		DebugPrint(WarningTag, "Utils.UIManager 重新获得UIManager")
		if not context then
			context = GWorld.GameInstance
		end
		local GameInstance = UE4.UGameplayStatics.GetGameInstance(context)
		Utils._UIManager = GameInstance:GetGameUIManager()
		return Utils._UIManager
	end
    return Utils._UIManager
end
---@type fun(context:UObject):BP_UIManagerComponent_C
_G.UIManager = Utils.UIManager --给智能提示插件提供识别信息

---@note 全局获取GameState
---@return BP_EMGameState_C
Utils.GameState = function(context)
	--GWorld已经缓存GameState了，这里没必要再缓存了...
	-- if not Utils.IsValid(Utils._GameState) then
	-- 	if not context then
	-- 		context = GWorld.GameInstance
	-- 	end
	-- 	Utils._GameState = UE4.UGameplayStatics.GetGameState(context)
	-- 	return Utils._GameState
	-- end
	if not context then
		context = GWorld.GameInstance
	end
	return UE4.UGameplayStatics.GetGameState(context)
end
---@type fun(context:UObject):BP_EMGameState_C
_G.GameState = Utils.GameState --给智能提示插件提供识别信息

--对UObject判断是否有效的普遍接口
Utils.IsValid = MiscUtils.IsValid
_G.IsValid = Utils.IsValid --给智能提示插件提供识别信息

Utils.AudioManager_Var = nil

---@return BP_AudioManager_C
Utils.AudioManager = function (context)
	if not Utils.AudioManager_Var then
		Utils.AudioManager_Var = MiscUtils.GetAudioManager_Lua(context)
	end
	return Utils.AudioManager_Var
end
---@type fun(context:UObject):BP_AudioManager_C
_G.AudioManager = Utils.AudioManager --给智能提示插件提供识别信息

---@return UEMHeroUSDKSubsystem
Utils.HeroUSDKSubsystem = function(WorldContext)
	if not WorldContext then
		WorldContext = GWorld.GameInstance
	end
	return USubsystemBlueprintLibrary.GetGameInstanceSubsystem(WorldContext, UEMHeroUSDKSubsystem)
end

Utils.WorldTravelSubsystem = function(WorldContext)
	if not WorldContext then
		WorldContext = GWorld.GameInstance
	end
	return USubsystemBlueprintLibrary.GetGameInstanceSubsystem(WorldContext, UWorldTravelSubsystem)
end

---@return UTalkSubsystem
Utils.TalkSubsystem = function(WorldContext)
	if not WorldContext then
		WorldContext = GWorld.GameInstance
	end
	return USubsystemBlueprintLibrary.GetWorldSubsystem(WorldContext, UTalkSubsystem)
end

local function TestCrypt( ... )
	local crypt = require "crypt"
	local s = crypt.randomkey()
	local text = crypt.randomkey()
	local rc4 = crypt.rc4_init(s)
	local rc4_1 = crypt.rc4_init(s)
	local c = crypt.rc4_crypt(rc4, text)
	local p = crypt.rc4_crypt(rc4, c)
	local p = crypt.rc4_crypt(rc4_1, p)
	local p = crypt.rc4_crypt(rc4_1, p)
	if p ~= text then
		Utils.ScreenPrint('加密算法验证失败')
	end
end
TestCrypt()

local function IsDLSSEnabled()
	-- body
	if UE4.UDLSSLibrary then
		return UE4.UDLSSLibrary.IsDLSSSupported() and (UE4.UDLSSLibrary.IsDLAAEnabled() or (UE4.UDLSSLibrary.GetDLSSMode() ~= UE4.UDLSSMode.Off))
	end

	return false
end

local FormatNumberTable = {k = 1000, M = 1000000, B = 1000000000}
-- 格式化数字，比如999899缩成999.9k，包括逗号
---@param Number number @number类型数字
---@param UseFormat bool @是否缩写数字
Utils.FormatNumber = function(Number, UseFormat)
	if not UseFormat then 
		local Result = MiscUtils.FormatNumberWithCommas(Number)
		return Result
	end

	local NumberStr = tostring(math.floor(Number))
	local NumLen = string.len(NumberStr)
	
	local FormatSign = nil	-- 格式化后的尾字符
	local FormatSignLen = nil -- 格式化后省略的位数
	local FormatSignText = nil

	if NumLen >= 11 then 
		FormatSign = "B" 
		FormatSignText = "UI_Amount_Billion"
		FormatSignLen = 9
	elseif NumLen >= 8 then 
		FormatSign = "M"
		FormatSignText = "UI_Amount_Million"
		FormatSignLen = 6
	elseif NumLen >= 6 then 
		FormatSign = "k" 
		FormatSignText = "UI_Amount_Thousand"
		FormatSignLen = 3
	end

	if not FormatSign or FormatNumberTable[FormatSign] == nil then 
		return NumberStr
	end

	local IntegerPart = string.sub(NumberStr,1, NumLen - FormatSignLen)
		IntegerPart = MiscUtils.FormatNumberWithCommas(IntegerPart)
	if Number % FormatNumberTable[FormatSign] == 0 then
		return IntegerPart .. GText(FormatSignText)
	else
		local DecimalNum_1 = (10 * Number // (FormatNumberTable[FormatSign])) % 10	-- 小数点后一位
		if DecimalNum_1 == 9 then 
			return IntegerPart .. ".9" .. GText(FormatSignText)
		else 
			local DecimalNum_2 = (100 * Number // (FormatNumberTable[FormatSign])) % 10	-- 小数点后二位
			DecimalNum_1 = DecimalNum_1 + (DecimalNum_2 >= 5 and 1 or 0)
			if DecimalNum_1 > 0 then 
				return IntegerPart .. "." .. DecimalNum_1 .. GText(FormatSignText)
			else
				return IntegerPart .. GText(FormatSignText)
			end
		end
	end
end

Utils.FormatWeaponInfo = function(TempWeapon, DumpWeaponInfo)
    TempWeapon.SlotData = {}
    TempWeapon.ModData = {}
    TempWeapon.ModPassives = nil
    TempWeapon.SkillInfos = nil
    TempWeapon.ReplaceAttrs = nil
    TempWeapon.EnhanceLevel = DumpWeaponInfo.EnhanceLevel or 0
    TempWeapon.WeaponId = DumpWeaponInfo.WeaponId or 0
    TempWeapon.GradeLevel = DumpWeaponInfo.GradeLevel or 0
    TempWeapon.AppearanceInfo = DumpWeaponInfo
    TempWeapon.AppearanceInfo.EnhanceLevel = nil
    TempWeapon.AppearanceInfo.GradeLevel = nil
end

Utils.NPCCreateSubSystem_Var = nil

---@return BP_NPCCreateSubSystem_C
Utils.NPCCreateSubSystem = function (context)
	return Utils.NPCCreateSubSystem_Var or MiscUtils.GetNPCCreateSubSystem_Lua(context)
end
---@type fun(context:UObject):BP_NPCCreateSubSystem_C
_G.NPCCreateSubSystem = Utils.NPCCreateSubSystem

return Utils

local CommonUtils = require "Utils.CommonUtils"
local Utils = {}
local GetDisplayName = UE4.UKismetSystemLibrary.GetDisplayName
local IsObjId = CommonUtils.IsObjId
local ObjId2Str = CommonUtils.ObjId2Str

local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
local bEnableShippingLog = UE4.URuntimeCommonFunctionLibrary.EnableLogInShipping()

--对UObject判断是否有效的普遍接口
local IsValid = UE4.UObject.IsValid
Utils.IsValid = function(Object)
	if Object == nil then
		return false
	end
	if not Object.IsValid then
		Traceback( WarningTag, "Utils.IsValid本意是给UObject判断有效性的，不建议传luaTable进来")
		return true
	end
	--RuntimeCommonFunctionLibrary的同名IsValid函数最终也是会走到Object的静态绑定去..
	--倒不如直接写成静态绑定的调用了，避免歧义
	return IsValid(Object)
end

Utils.PrintArray = (bDistribution and not bEnableShippingLog) and Utils.EmptyFunction or function(Targets, Log)
	if Targets.ToArray then
		Targets = Targets:ToArray()
	end
	local s = "PrintArray:[" .. tostring(Log) .. "]"..tostring(Targets).."\n"
	if Targets then
		for i, Target in pairs(Targets) do
			s = s.."\t"..tostring(i)..":"..tostring(Target)..":"..tostring(UE4.UKismetSystemLibrary.GetDisplayName(Target)).."\n"
		end
	end
	print(LogTag, s)
end

Utils.DumpMap = function(map)
    local ret = {}
    local keys = map:Keys()
    for i = 1, keys:Length() do
        local key = keys:Get(i)
        local value = map:Find(key)
        table.insert(ret, key .. ":" .. tostring(value))
    end
    return "{" .. table.concat(ret, ",") .. "}"
end

Utils.DumpArray = function(array)
    local ret = {}
    for i = 1, array:Length() do
        table.insert(ret, array:Get(i))
    end
    return "[" .. table.concat(ret, ",") .. "]"
end

Utils.DumpSet = function(set)
    local array = set:ToArray()
    local ret = {}
    for i = 1, array:Length() do
        table.insert(ret, array:Get(i))
    end
    return "(" .. table.concat(ret, ",") .. ")"
end

Utils.PrintMap = (bDistribution and not bEnableShippingLog) and Utils.EmptyFunction or function(Map)
	PrintTable(Map:ToTable())
end

Utils.Error = (bDistribution and not bEnableShippingLog) and Utils.EmptyFunction or function(log)
	local s = "Error.."..tostring(log)
	print(LogTag, s)
end

Utils.Trim = function(str)
    return (string.gsub(str, "^[%s\n\r\t]*(.-)[%s\n\r\t]*$", "%1"))
end

Utils.TrimAll = function(str)
	-- 去掉字符串中的所有空格
	return (str:gsub("%s+", ""))
end

Utils.Keys = function(Table)
	local Keys = {}
	for k,v in pairs(Table) do
		table.insert(Keys, k)
	end
	return Keys
end

Utils.Values = function(Table)
	local Values = {}
	for k,v in pairs(Table) do
		table.insert(Values, v)
	end
	return Values
end

Utils.IKeys = function(Table)
	local Keys = {}
	for k,v in ipairs(Table) do
		table.insert(Keys, k)
	end
	return Keys
end

Utils.IValues = function(Table)
	local Values = {}
	for k,v in ipairs(Table) do
		table.insert(Values, v)
	end
	return Values
end

Utils.PairsByKeys = function(Table)
    local KeyTable = {}
    for n in pairs(Table) do
        KeyTable[#KeyTable + 1] = n
    end
    table.sort(KeyTable)
    local i = 0
    return function()
        i = i + 1
        return KeyTable[i], Table[KeyTable[i]]
    end
end

Utils.Swap = function(x,y)
	local Temp = x
	x = y
	y = Temp
	return x,y
end

Utils.IsListenServer = function(Actor)
	return UNeModeFunctionLibrary.IsListenServer(Actor)
end

Utils.IsSimulatedProxy = function(actor)
	return actor:GetLocalRole() == 1
end

Utils.IsAutonomousProxy = function(actor)
	return actor:GetLocalRole() == 2
end

--对Actor判断是否有效的普遍接口
local IsActorValidInGame = UE4.AActor.IsActorValidInGame
Utils.IsActorValid = function(Actor)
	if Actor == nil then
		return false
	end
	if not IsActorValidInGame then
		Utils.Traceback( ErrorTag, "Utils.IsActorValid本意是给Actor判断有效性的，不建议传其他类型对象进来")
		return true
	end
	return IsActorValidInGame(Actor)
end

Utils.IsWithoutAvatar = function(InWorldContext)
	local IsPIE = UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(InWorldContext)
	local Avatar = GWorld:GetAvatar()
	return IsPIE == true and Avatar == nil
end

Utils.IsTakeRecorderCapturing = function(WorldContext)
	if Utils.IsWithoutAvatar(WorldContext) then
		local GameInstance=UGameplayStatics.GetGameInstance(WorldContext)
		if GameInstance.IsTakeRecorderCapturing then
			return true
		end
	end
	return false
end

Utils.GetObjectRight = function(ObjectInst)
	local ObjectRight = FVector()
	if ObjectInst.GetActorRightVector then 
		ObjectRight = ObjectInst:GetActorRightVector()
	elseif ObjectInst.GetRightVector then 
		ObjectRight = ObjectInst:GetRightVector()
	end
	return ObjectRight
end

Utils.GetObjectFoward = function(ObjectInst)
	local ObjectForward = FVector()
	if ObjectInst.GetActorForwardVector then 
		ObjectForward = ObjectInst:GetActorForwardVector()
	elseif ObjectInst.GetForwardVector then 
		ObjectForward = ObjectInst:GetForwardVector()
	end
	return ObjectForward
end


Utils.GetObjectLocation = function(ObjectInst)
	-- body
	local ObjectLoc = FVector()
	if ObjectInst.K2_GetActorLocation then 
		ObjectLoc = ObjectInst:K2_GetActorLocation()
	elseif ObjectInst.K2_GetComponentLocation then 
		ObjectLoc = ObjectInst:K2_GetComponentLocation()
	end
	return ObjectLoc
end

Utils.ToFVector = function(t)
	if t.X then
		return FVector(t.X, t.Y, t.Z)
	else
		return FVector(t[1],t[2],t[3])
	end
end

---@note 全局获取GameMode
Utils.GameMode = function(context)
	--GWorld已经缓存GameMode了，这里没必要再缓存了...
	-- if not IsValid(Utils._GameMode) then
	-- 	if not context then
	-- 		context = GWorld.GameInstance
	-- 	end
	-- 	Utils._GameMode = UE4.UGameplayStatics.GetGameMode(context)
	-- 	return Utils._GameMode
	-- end
	if not context then
		context = GWorld.GameInstance
	end
	return UE4.UGameplayStatics.GetGameMode(context)
end
---@type fun(context:UObject):BP_EMGameMode_C
-- _G.GameMode = Utils.GameMode

Utils.LazyLoadClass = function (str, persistent)
	-- body
	local object = {}
	object.path = str
	function object:get()
		if IsValid(self.object) then
			return self.object
		end
		self.object = LoadClass(self.path)
		if persistent then AddToRoot(self.object) end
		return self.object
	end
	return object
end

Utils.LazyLoadObject = function (str)
	-- body
	local object = {}
	object.path = str
	function object:get()
		if self.object and Utils.IsValid(self.object) then
			return self.object
		elseif self.path ~= '' or self.path ~= nil then
			return LoadObject(self.path)
		end
		self.object = LoadObject(self.path)
		return self.object
	end
	return object
end

local GlobalDamageStruct = Utils.LazyLoadClass("/Game/BluePrints/Combat/BP_DamageStruct.BP_DamageStruct", true)
local PetClass = Utils.LazyLoadClass("/Game/BluePrints/Char/BP_PetNpc/BP_PetNPC.BP_PetNPC_C", true)
local GlobalFunctionLibrary = Utils.LazyLoadClass("/Game/BluePrints/Common/BP_GlobalFunctionLibrary.BP_GlobalFunctionLibrary_C", true)

Utils.GetHitActor = function (HitResult)
	return GlobalFunctionLibrary:get().GetHitActor(HitResult)
end

Utils.TransEPhysicalSurface = function (EPhysicalSurface)
	return GlobalFunctionLibrary:get().TransEPhysicalSurface(EPhysicalSurface)
end

Utils.DamageEventClass = function()
	return GlobalDamageStruct:get()
end

Utils.PreloadPetClass = function ()
	DebugPrint("BP_PetNpc Class", PetClass:get())
end

Utils.Round = function(FloatValue)
	if FloatValue == 0 then return 0 end
	if FloatValue > 0 then return math.floor(FloatValue + 0.5)
	else return -Utils.Round(-FloatValue) end
end

Utils.IsNilOrEmpty = function(InStr)
	return InStr == nil or InStr == ""
end

Utils.InArray = function(Array, Value)
	if not Array or Array:Length() == 0 then
		return false
	end

	for i=1,Array:Length() do
		if Value == Array:GetRef(i) then
			return true
		end
	end
	return false
end

Utils.Int = function(FloatValue)
	if FloatValue == 0 then return 0 end
	if FloatValue > 0 then return math.floor(FloatValue + 0.0001)
	else return -Utils.Int(-FloatValue) end
end

Utils.NumberToBool = function(Number)
	if Number == nil then return false end 
	if type(Number) == "boolean" then return Number end
	if Number == 0 then return false end 
	if Number == 1 then return true end 
	return Number
end

Utils.IsLowerAuthority = function(actor)
	return actor:GetLocalRole() < 3
end

Utils.GetCacheClass = function (ActorPath)
	if Const.CacheClassMap then
		return Const.CacheClassMap[ActorPath]
	end

	return nil
end

Utils.IsInRange = function(Source, Target, MinDis, MaxDis)
	local Dis = (Target - Source):Size()
	return Dis <= MaxDis and Dis >= MinDis
end

Utils.IsInCircle = function(Source, Target, Radius)
	return (Target - Source):Size() <= Radius
end

Utils.CircleCrossSegment = function(Point1, Point2, CircleCenter, CircleRadius)
	local Flag1 = ((Point1.X - CircleCenter.X)*(Point1.X - CircleCenter.X)+(Point1.Y - CircleCenter.Y)*(Point1.Y - CircleCenter.Y) <= CircleRadius*CircleRadius)
	local Flag2 = ((Point2.X - CircleCenter.X)*(Point2.X - CircleCenter.X)+(Point2.Y - CircleCenter.Y)*(Point2.Y - CircleCenter.Y) <= CircleRadius*CircleRadius)
	if (Flag1 and Flag2) then 
		return false
	elseif (Flag1 or Flag2) then
		return true 
	else
		local A = Point1.Y - Point2.Y 
		local B = Point2.X - Point1.X
		local C = Point1:Cross(Point2)
		local Dist1 = A*CircleCenter.X + B*CircleCenter.Y + C
		Dist1 = Dist1*Dist1
		local Dist2 = (A*A + B*B)*CircleRadius*CircleRadius
		if Dist1 > Dist2 then 
			return false
		end
		local Angle1 = (CircleCenter - Point1):Dot((Point2 - Point1))
		local Angle2 = (CircleCenter - Point2):Dot((Point1- Point2))
		if (Angle1 > 0 and Angle2 > 0) then 
			return true
		end
		return false
	end
end

Utils.IsInsideSector = function(Source, SourceForward, Target, TargetRadius, Radius, Angle)
	-- Out of big Circle
	if (Target - Source):Size() > TargetRadius + Radius then
		return false
	end
	-- Sector is Circle
	if Angle >= 360 then
		return true
	end
	SourceForward:Normalize()

	local TargetToSource = Target - Source
	local HalfAngle = Angle / 2.0
	local CosHalfAngle = UE4.UKismetMathLibrary.DegCos(HalfAngle)
	local SinHalfAngle = UE4.UKismetMathLibrary.DegSin(HalfAngle)
	TargetToSource:Normalize()
	local TargetTheta = SourceForward:Dot(TargetToSource)
	local LeftEdge2D = FVector2D(SourceForward.X * CosHalfAngle - SourceForward.Y * SinHalfAngle, SourceForward.Y * CosHalfAngle + SourceForward.X * SinHalfAngle)
	LeftEdge2D:Normalize()
	local RightEdge2D = FVector2D(SourceForward.X * CosHalfAngle + SourceForward.Y * SinHalfAngle, SourceForward.Y * CosHalfAngle - SourceForward.X * SinHalfAngle)
	RightEdge2D:Normalize()
	-- Inside Sector with Big Circle
	local EdgeTheta = SourceForward:Dot(LeftEdge2D)
	if TargetTheta >= EdgeTheta then 
		return true
	end
	-- In Circle of  Sector's endpoint
	local LeftEdgePoint = Source + LeftEdge2D * Radius
	local RightEdgePoint = Source + RightEdge2D * Radius
	if  Utils.IsInCircle(Source, Target, TargetRadius) or Utils.IsInCircle(LeftEdgePoint, Target, TargetRadius) or Utils.IsInCircle(RightEdgePoint, Target, TargetRadius) then
		return true 
	end
	-- Cross With Left or RightEdge
	if Utils.CircleCrossSegment(LeftEdgePoint, Source, Target, TargetRadius) or Utils.CircleCrossSegment(RightEdgePoint, Source, Target, TargetRadius) then
		return true
	end

	return false
end

Utils.IsRingCrossSector = function(CenterPos2D, Forward2D, TargetLoc2D, OutterRadius, Radius, Angle, InnerRadius)
	if not Utils.IsInsideSector(CenterPos2D, Forward2D, TargetLoc2D, OutterRadius, Radius, Angle) then 
		return false
	end
	if (CenterPos2D - TargetLoc2D):Size() <  InnerRadius then
		return Utils.SectorCrossInnerCircle(CenterPos2D, Forward2D, TargetLoc2D, OutterRadius, Radius, Angle,InnerRadius)
	end
	return true
end

Utils.SectorCrossInnerCircle = function(CenterPos2D, Forward2D, TargetLoc2D, OutterRadius, Radius, Angle, InnerRadius)
	Forward2D:Normalize()

	local HalfAngle = Angle / 2.0
	local CosHalfAngle = UE4.UKismetMathLibrary.DegCos(HalfAngle)
	local SinHalfAngle = UE4.UKismetMathLibrary.DegSin(HalfAngle)

	local LeftEdge2D = FVector2D(Forward2D.X * CosHalfAngle - Forward2D.Y * SinHalfAngle, Forward2D.Y * CosHalfAngle + Forward2D.X * SinHalfAngle)
	LeftEdge2D:Normalize()
	local RightEdge2D = FVector2D(Forward2D.X * CosHalfAngle + Forward2D.Y * SinHalfAngle, Forward2D.Y * CosHalfAngle - Forward2D.X * SinHalfAngle)
	RightEdge2D:Normalize()

	local LeftEdgePoint = CenterPos2D + LeftEdge2D * Radius
	local RightEdgePoint = CenterPos2D + RightEdge2D * Radius
	if not Utils.IsInCircle(LeftEdgePoint, TargetLoc2D, InnerRadius) or not Utils.IsInCircle(RightEdgePoint, TargetLoc2D, InnerRadius) then 
		return true
	end
	if (TargetLoc2D - CenterPos2D):Size() + Radius < InnerRadius then 
		return false
	end
	if (TargetLoc2D - CenterPos2D):Size() == 0 and Radius >= InnerRadius then 
		return true
	end
	--https://math.stackexchange.com/questions/256100/how-can-i-find-the-points-at-which-two-circles-intersect
	local EdgeTheta = Forward2D:Dot(LeftEdge2D)
	local TargetToSource = CenterPos2D - TargetLoc2D
	-- local RSize = TargetToSource:Size()

	TargetToSource:Normalize()
	local TargetTheta = Forward2D:Dot(TargetToSource)
	if TargetTheta < EdgeTheta then 
		return false
	end

	local MaxCrossPoint = CenterPos2D + TargetToSource * Radius
	
	return (MaxCrossPoint - TargetLoc2D):Size() >= InnerRadius

	-- local R_Pow2 = UE4.UKismetMathLibrary.Square(RSize)
	-- local R_Pow4 = UE4.UKismetMathLibrary.Square(R_Pow2)
	-- local R1_Pow2 = UE4.UKismetMathLibrary.Square(Radius)
	-- local R2_Pow2 = UE4.UKismetMathLibrary.Square(InnerRadius)
	-- local Factor1 = (R_Pow2 - R1_Pow2 + R2_Pow2)/(2 * R_Pow2)
	-- local Var1 = 2*(R1_Pow2 + R2_Pow2)/R_Pow2
	-- local Var2 = UE4.UKismetMathLibrary.Square(R1_Pow2 - R2_Pow2) / R_Pow4
	-- local Factor2 = UE4.UKismetMathLibrary.Sqrt(Var1 - Var2 - 1) * 0.5
	-- local CrossPoint1 = FVector2D(Factor1*TargetToSource.X-Factor2*TargetToSource.Y, Factor1*TargetToSource.Y+Factor2*TargetToSource.X)
	-- local CrossPoint2 = FVector2D(Factor1*TargetToSource.X+Factor2*TargetToSource.Y, Factor1*TargetToSource.Y-Factor2*TargetToSource.X)
	-- if Utils.IsInsideSector(CenterPos2D, Forward2D, CrossPoint1, 0, Radius, Angle) or Utils.IsInsideSector(CenterPos2D, Forward2D, CrossPoint2, 0, Radius, Angle) then 
	-- 	return true 
	-- end
	-- return false
end

Utils.PointInRect = function(TargetDotEdge, TargetToSourcePow2, TargetDotEdgePow2, RadiusPow2)
	return TargetDotEdge >= 0 and TargetToSourcePow2 - TargetDotEdgePow2 <= RadiusPow2
end

Utils.CalculateQuadrant = function(CurrentDir, Angle)
	local Forward = 0
	local Backward = 1
	local Right = 6
	local Left = 7
	local Buffer = Const.Buffer
	if Utils.AngleInRange(Angle, Const.FLThreshold, Const.FRThreshold, Buffer, CurrentDir ~= Forward or CurrentDir ~= Backward) then
		return Forward
	end

	if Utils.AngleInRange(Angle, Const.FRThreshold, Const.BRThreshold, Buffer, CurrentDir ~= Right or CurrentDir ~= Left) then
		return Right
	end

	if Utils.AngleInRange(Angle, Const.BLThreshold, Const.FLThreshold, Buffer, CurrentDir ~= Right or CurrentDir ~= Left) then
		return Left
	end

	return Backward
end

Utils.AngleInRange = function (Angle, MinAngle, MaxAngle, Buffer, IncreaseBuffer)
	-- body
	if (IncreaseBuffer) then 
		return Angle >= MinAngle - Buffer and Angle <= MaxAngle + Buffer
	end
	return Angle >= MinAngle + Buffer and Angle <= MaxAngle - Buffer
end

Utils.BetweenTwoVec = function(Left, Mid, Right)
	-- body
	local Left2D = UE4.UKismetMathLibrary.Conv_VectorToVector2D(Left)
	local Mid2D = UE4.UKismetMathLibrary.Conv_VectorToVector2D(Mid)
	local Right2D = UE4.UKismetMathLibrary.Conv_VectorToVector2D(Right)
	return Left2D:Cross(Mid2D)*Right2D:Cross(Mid2D)<=0
end

Utils.FourDirToEightDir = function(LocRelativeVelocityDir)
	-- body
	local TargetVelocityBlend = FVelocityBlend() 
	local Aix,LeanAix = table.unpack(Utils.AixsCheck(Utils.WithTolerance(LocRelativeVelocityDir.X), Utils.WithTolerance(LocRelativeVelocityDir.Y)))
	local Value = math.abs(LocRelativeVelocityDir.X)
	local ValueNormal = math.abs(LocRelativeVelocityDir.Y)
	if ValueNormal > Value then 
		Value, ValueNormal = Utils.Swap(Value, ValueNormal)
	end
	LeanAixVal = UE4.UKismetMathLibrary.Sqrt(2)*ValueNormal
	AixVal = Value - ValueNormal
	AixVal, LeanAixVal = Utils.Average(AixVal, LeanAixVal)
	TargetVelocityBlend[Aix] = UE4.UKismetMathLibrary.FClamp(AixVal, 0.1, 1)
	TargetVelocityBlend[LeanAix] = UE4.UKismetMathLibrary.FClamp(LeanAixVal, 0.1, 1)
	return TargetVelocityBlend
end

Utils.FourDirVelocityBlend = function(LocRelativeVelocityDir)
	-- body
	local TargetVelocityBlend = FVelocityBlend() 
	local Value = math.abs(LocRelativeVelocityDir.X)
	local ValueNormal = math.abs(LocRelativeVelocityDir.Y)
	local Sum = Value + ValueNormal + math.abs(LocRelativeVelocityDir.Z)
	if Sum == 0 then
		TargetVelocityBlend.F = 0.1
		return TargetVelocityBlend
	end
	local RelativeDir =  LocRelativeVelocityDir / Sum
	TargetVelocityBlend.F = UE4.UKismetMathLibrary.FClamp(RelativeDir.X, 0.1, 1)
	TargetVelocityBlend.B = math.abs(UE4.UKismetMathLibrary.FClamp(RelativeDir.X, -1, 0))
	TargetVelocityBlend.L = math.abs(UE4.UKismetMathLibrary.FClamp(RelativeDir.Y, -1, 0))
	TargetVelocityBlend.R = UE4.UKismetMathLibrary.FClamp(RelativeDir.Y, 0, 1)
	return TargetVelocityBlend
end

Utils.AixsCheck = function(x, y)
	local QuadrantTable = {{1,2},{3,4},{5,6},{7,8}}
	local AixsTable = {}
	AixsTable[1] ={"F", "FR"}
	AixsTable[2] ={"R", "FR"}
	AixsTable[3] ={"F", "FL"}
	AixsTable[4] ={"L", "FL"}
	AixsTable[5] ={"B", "LB"}
	AixsTable[6] ={"L", "LB"}
	AixsTable[7] ={"B", "RB"}
	AixsTable[8] ={"R", "RB"}
	local QuadrantIndex = 1
	if x >= 0 and y >= 0 then 
		QuadrantIndex = 1
	elseif x >= 0 and y <= 0 then 
		QuadrantIndex = 2
	elseif x <= 0 and y <= 0 then 
		QuadrantIndex = 3
	else
		QuadrantIndex = 4
	end
	local AixIndex = 1
	if math.abs(x) < math.abs(y) then 
		AixIndex = 2
	end
	return AixsTable[QuadrantTable[QuadrantIndex][AixIndex]]
end

Utils.Sign = function (Value, Tolerance)
	-- body
	local T = Tolerance
	if not Tolerance then
		T = 0.01
	end
	if UE4.UKismetMathLibrary.Abs(Value) < T then
		return 0 
	end
	return 1
end

Utils.Average = function(x,y)
	return x/(math.abs(x)+math.abs(y)), y/(math.abs(x)+math.abs(y))
end

Utils.WithTolerance = function (Value, Tolerance)
	-- body
	local T = Tolerance
	if not Tolerance then
		T = 0.01
	end
	if UE4.UKismetMathLibrary.Abs(1 - Value) < T then
		return 1
	elseif UE4.UKismetMathLibrary.Abs(Value) < T then
		return 0 
	end
	return Value
end

-- 如果超过五位，则每三位加个小数点
Utils.FormatNumberWithCommas = function(Number)
	if type(Number) == "number" then 
		if Number < 100000 then 
			return tostring(math.floor(Number))
		else
			return tostring(math.floor(Number)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
		end
	elseif type(Number) == "string" then 
		if Number:len() < 6 then 
			return Number 
		else 
			return Number:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
		end
	end
end

Utils.GetStrTable = (bDistribution and not bEnableShippingLog) and Utils.EmptyFunction or function(ct, t, step, deep, PrettyFormat)
	if type(t) ~= "table" then
		ct[#ct + 1] = tostring(t)
		return
	end

	local func = function(k, v) 
		--ct[#ct + 1] = string.rep("\t", step)
		for i = 1, step do
			ct[#ct + 1] = "\t"
		end

		local type_k = type(k)
		local type_v = type(v)
		local str_k = nil
		local str_v = nil
		
		if (type_v == "table") and v.IsValid and Utils.IsValid(v) then
			type_v = tostring(GetDisplayName(v))
		end

		if type_k == "string" and IsObjId(k) then
			str_k = ObjId2Str(k)
		else
			str_k = tostring(k)
		end
		if type_v == "string" and IsObjId(v) then
			str_v = ObjId2Str(v)
		else
			if type_v == "table" and PrettyFormat then
				str_v = ""
			else
				str_v = tostring(v)
			end
		end

		ct[#ct + 1] = str_k
		if not PrettyFormat then
			ct[#ct + 1] = " ("
			ct[#ct + 1] = type_k
			ct[#ct + 1] = "): "
		else 
			ct[#ct + 1] = ": "
		end
		ct[#ct + 1] = str_v
		if not PrettyFormat then
			ct[#ct + 1] = " ("
			ct[#ct + 1] = type_v
			ct[#ct + 1] = ")\n"
		else
			ct[#ct + 1] = "\n"
		end
		
		if type(v) == "table" and step < deep then
			Utils.GetStrTable(ct, v, step + 1, deep, PrettyFormat)
		end
	end

	if PrettyFormat then
		local keys = {}
		for k, v in pairs(t) do
			keys[#keys + 1] = k
		end
		table.sort(keys)
		for _, k in ipairs(keys) do
			func(k, t[k])
		end
	else
		for k, v in pairs(t) do
			func(k, v)
		end
	end
end

Utils.CorrectUrl = function(Url)
	Url = string.gsub(Url, "([%%+#&= ])", function(c) 
		return string.format("%%%02X", string.byte(c)) 
	end)
    return Url
end

Utils.IsSingleByteWord = function(Word)
    for i = 1 , #Word do
        local curByte = string.byte(Word, i)
        if curByte < 0 or curByte > 127 then
            return false
        end
    end
    return true
end

Utils.AudioManager_Var = nil

Utils.GetAudioManager_Lua = function(context)
	if IsDedicatedServer(context) then
		Utils.AudioManager_Var = CommonUtils.EmptyProxy
	else
		local GameInstance = UE4.UGameplayStatics.GetGameInstance(context)
		if GameInstance and GameInstance.GetAudioManager then
			Utils.AudioManager_Var = GameInstance:GetAudioManager()
		end
	end
	return Utils.AudioManager_Var
end

Utils.GetGameCofingSettings = function(VarName)
	return UE4.UGameConfigSetttings.Get()[VarName]
end

Utils.InitializeSettings = function(self)
	local WorldContext = GWorld.GameInstance
	local IsPIE = UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(WorldContext)
	if IsPIE then
		UE4.UKismetSystemLibrary.ExecuteConsoleCommand(WorldContext, "Editor.OverrideDPIBasedEditorViewportScaling 1", nil)
	end
	if CommonUtils.GetRuntimePlatform(self) == "Mobile" then
		UE4.UKismetSystemLibrary.ExecuteConsoleCommand(WorldContext, "r.ReflectionCaptureGPUArrayCopy 0", nil)
	end
	--这条指令修复了RetainerBox中富文本显示错误的bug
	UE4.UKismetSystemLibrary.ExecuteConsoleCommand(WorldContext,"Slate.EnableRetainedRenderingWithLocalTransform 0",nil)
	Utils.PreloadPetClass()
end

Utils.AddTickLodActor = function(InTag, InActor, TickLodFlag)
	URuntimeCommonFunctionLibrary.AddTickLodObject(InTag, InActor, TickLodFlag)
end

Utils.RemoveTickLodActor = function(InTag, InActor, TickLodFlag)
	URuntimeCommonFunctionLibrary.RemoveTickLodObject(InTag, InActor, TickLodFlag)
end

Utils.BlockTickLod = function(InTag, bBlock, InActor, BlockTag, TickLodFlag)
	if InActor.BlockTickLod  then
		InActor:BlockTickLod(bBlock, InTag, TickLodFlag)
		return
	end
	---@type UEMSignificanceMgrSubsystem
	local SignificanceMgrSubsystem = USubsystemBlueprintLibrary.GetWorldSubsystem(InActor, UEMSignificanceMgrSubsystem)
	if not SignificanceMgrSubsystem then
		return
	end

	SignificanceMgrSubsystem:BlockTickLod(InTag, bBlock, InActor, BlockTag, TickLodFlag)
end

Utils.PlayMontageBySkeletaMesh = function(Owner, MeshComp, MontageAsset, PlayParam)
	if not MontageAsset then 
		local Result = PlayParam.OnCompleted and PlayParam.OnCompleted(Owner, true)
		return
	end
	
	local _PlayRate = 1.0
	if PlayParam.PlayRate then
		_PlayRate = PlayParam.PlayRate
	end
	local _StartPos = 0.0
	if PlayParam.StartPos then
		_StartPos = PlayParam.StartPos
	end
	local _StartSec = nil
	if PlayParam.StartSec then
		_StartSec = PlayParam.StartSec
	end
	local MontCallbackProxy = UE4.UPlayMontageCallbackProxy.CreateProxyObjectForPlayMontage(MeshComp, MontageAsset, _PlayRate, _StartPos, _StartSec)
	if not Utils.IsValid(MontCallbackProxy) then 
		return 
	end

 	local StopMontageFuncComplete = function()
		if Owner and Owner.RemoveMontPorxy then
			Owner:RemoveMontPorxy(MontCallbackProxy)
		end
		if Owner:IsNPC() and PlayParam.MontageSlotGroupName == "TalkGroup" then
			Owner.CurrentAnimationMontageSectionName = ""
		end
	end

	local StopMontageFunc = function()
		if Owner and Owner.RemoveMontPorxy and MontCallbackProxy.OnCompleted:IsBound() == false then
			Owner:RemoveMontPorxy(MontCallbackProxy)
		end
		if Owner:IsNPC() and PlayParam.MontageSlotGroupName == "TalkGroup"  then
			Owner.CurrentAnimationMontageSectionName = ""
		end
	end

	local OnCompleted = PlayParam.OnCompleted
	local Temp = PlayParam.OnCompleted and MontCallbackProxy.OnCompleted:Add(Owner, PlayParam.OnCompleted)
	if OnCompleted then
		MontCallbackProxy.OnCompleted:Add(Owner, StopMontageFuncComplete)
	end

    if PlayParam.ExcuteFnishOnlyWhenCompelete then
    	OnCompleted = nil
    end
    local BlendOutFunc = PlayParam.OnBlendOut
	if not PlayParam.OnBlendOut then
		BlendOutFunc = OnCompleted
	end
    local Temp = BlendOutFunc and MontCallbackProxy.OnBlendOut:Add(Owner, BlendOutFunc)
	if BlendOutFunc then
		MontCallbackProxy.OnBlendOut:Add(Owner, StopMontageFunc)
	end

	local InterruptedFunc = PlayParam.OnInterrupted
    if not PlayParam.OnInterrupted then
		InterruptedFunc = OnCompleted
	end
    local Temp = InterruptedFunc and MontCallbackProxy.OnInterrupted:Add(Owner, InterruptedFunc)
	if InterruptedFunc then
		MontCallbackProxy.OnInterrupted:Add(Owner, StopMontageFunc)
	end

    if PlayParam.OnNotifyBegin then
    	MontCallbackProxy.OnNotifyBegin:Add(Owner, PlayParam.OnNotifyBegin)
	end
	local EndFunc = PlayParam.OnNotifyEnd
    if not PlayParam.OnNotifyEnd then
		EndFunc = OnCompleted
	end
    local Temp = EndFunc and MontCallbackProxy.OnNotifyEnd:Add(Owner, EndFunc)
    if Owner.CacheMontPorxy then
    	Owner:CacheMontPorxy(MontCallbackProxy)
    end
end

Utils.EnableFriendFXBias = function (enable)
	if Const.EnableFriendFXQualityBias ~= enable then
		Const.EnableFriendFXQualityBias = enable
		Const.ScalabilityUpdateTime = Const.ScalabilityUpdateTime + 1
	end
end

-- quality : 
-- 0 fully disable
-- 1 part disable
-- 2 fully show
Utils.SetFriendFXQuality = function (quality)
	if Const.FriendFXQuality ~= quality then
		Const.FriendFXQuality = quality
		Const.ScalabilityUpdateTime = Const.ScalabilityUpdateTime + 1
	end
end

Utils.EmptyFunction = function( ... ) end

Utils.SaveCacheClass = function (ActorPath, UnitBlueprint)
	if not Const.CacheClassMap then
		Const.CacheClassMap = {}
	end
	if Const.CacheClassMap[ActorPath] == nil then
		Const.CacheClassMap[ActorPath] = UnitBlueprint
		AddToRoot(UnitBlueprint)
	end
end

Utils.GetNPCCreateSubSystem_Lua = function(context)
	if IsDedicatedServer(context) then
		Utils.NPCCreateSubSystem_Var = CommonUtils.EmptyProxy
	else
		Utils.NPCCreateSubSystem_Var = UNPCCreateSubSystem.GetSubsystem(context)
	end
	return Utils.NPCCreateSubSystem_Var
end

Utils.StringToByteTable = function(Data)
	Len = string.len(Data)
	local ByteTable = {}
	for i = 1, Len do
		ByteTable[i] = string.byte(Data, i)
	end
	return ByteTable
end

Utils.ByteArrayToString = function(ByteArray)
	local Chars = {}
	local Len = ByteArray:Num()
	for i = 1, Len do
		Chars[i] = string.char(ByteArray:Get(i))
	end
	return table.concat(Chars)
end

Utils.GetGameReviewPlatform = function()
    local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName()
    if PlatformName == "IOS" then 
        return "IOS"
    end
    local ImgChannelId = HeroUSDKSubsystem():GetMirrorChannelId()
    local ImgChannelInfo = DataMgr.ImgChannelInfo[ImgChannelId]
    if ImgChannelInfo and ImgChannelInfo.Provider == "TapTap" then 
        return "TapTap"
    end

    local ChannelId = HeroUSDKSubsystem():GetChannelId()
    if ChannelId == 160 then 
        return "Google"
    end
	return ""
end
return Utils
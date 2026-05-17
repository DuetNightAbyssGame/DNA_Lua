
require "DataMgr"

local Component = {}

function Component:AddCollisionCompToMap(CollisionCompMap, TargetActor, TargetComp)
	local Eid = self:IsDanmakuTarget(TargetActor) and TargetComp.Eid or TargetActor.Eid

	if Eid then
		CollisionCompMap[Eid] = CollisionCompMap[Eid] or {}
		table.insert(CollisionCompMap[Eid], TargetComp)
	end
end

function Component:ApplyRangeModify(Source, ModifyInfo, Ranges)
	-- Source 可能为 Character、Creature、Summon
	-- Character、Summon 是自身，Creature 是直接创建者
	local RealSource = Source
	if RealSource:IsSkillCreature() then
		RealSource = RealSource:GetDirectSource()
	end
	if ModifyInfo.AllowSkill then
		local SkillRange = RealSource:GetAttrByConstrain(EAttrName.SkillRange)
		for i = 1, #Ranges do Ranges[i] = Ranges[i] * SkillRange end
	end
	if ModifyInfo.AttackRangeType and ModifyInfo.AttackRangeType ~= "None" then
		if RealSource.GetCurrentWeapon then
			local Weapon = RealSource:GetCurrentWeapon()
			if Weapon then
				local AttackRange = Weapon:GetAttr("AttackRange_" .. tostring(ModifyInfo.AttackRangeType)) or 0
				--print(_G.LogTag, "TTT 武器范围：", AttackRange)
				for i = 1, #Ranges do Ranges[i] = Ranges[i] + AttackRange end
			end
		else
			error("TTT" .. " Source: " .. Source:GetName() .. " RealSource: " .. RealSource:GetName())
		end
	end
	return Ranges
end

function Component:GetComponentByName(Target, CompName)
	local CollisionComp = Target[CompName]
	if CollisionComp then
		return CollisionComp
	elseif self:IsDanmakuTarget(Target) then
		return self:GetDanmakuCreatureByName(Target, CompName)
	end
	return Target:K2_GetRootComponent()
end

function Component:GetCollisionNamesByComps(CollisionCompMap)
	local CollisionNames = {}
	if CollisionCompMap then
		for Eid, CollisionCompArray in pairs(CollisionCompMap) do
			CollisionNames[Eid] = {}
			local Collisions = CollisionCompArray.Collisions
			if Collisions then
				for _, CollisionComp in pairs(Collisions) do
					local CompName = UKismetSystemLibrary.GetObjectName(CollisionComp)

					-- 防止Actor上Lua拿到的组件名称和实际名称不一致
					local Entity = self:GetEntity(Eid)
					if Entity and Entity[CompName] == nil then
						CompName = Entity:K2_GetRootComponent():GetName()
					end
					table.insert(CollisionNames[Eid], CompName)
				end
			end
		end
	end
	return CollisionNames
end

-- Table转为TMap对象
function Component:Table2TMap(CollisionCompMap)
	local Eid2CollisionComponents = TMap(0, FCollisionsArray)
	for Eid, CollisionComps in pairs(CollisionCompMap) do
		local CollisionArray = Eid2CollisionComponents:Find(Eid)
		if CollisionArray == nil then
			Eid2CollisionComponents:Add(Eid, FCollisionsArray())
			CollisionArray = Eid2CollisionComponents:FindRef(Eid)
		end
		for _, CollisionComp in ipairs(CollisionComps) do
			CollisionArray.Collisions:AddUnique(CollisionComp)
		end
	end
	return Eid2CollisionComponents
end

-- TMap转为Table(暂时留着接口，目前没有用到)
function Component:TMap2Table(Eid2CollisionComponents)
	local CollisionCompMap = {}
	for Eid, CollisionComps in pairs(Eid2CollisionComponents) do
		CollisionCompMap[Eid] = {}
		for _,CollisionComp in pairs(CollisionComps.Collisions) do
			table.insert(CollisionCompMap[Eid], CollisionComp)
		end
	end
	return CollisionCompMap
end

-- call by C++
function Component:GetConfigFilterResults_Lua(Source, PreTarget, LuaFilter, TargetFilterKey, ModifyInfo, Debug, SkillEffectInfo, Skill)
	local Targets, CollisionComps = self["Filter_"..LuaFilter](self, Source, PreTarget, TargetFilterKey, ModifyInfo, Debug, SkillEffectInfo, Skill)
	
	if LuaFilter ~= "CheckRangeHit" and CollisionComps then
		CollisionComps = self:Table2TMap(CollisionComps)
	end

	if type(Targets) == "table" then
		local TargetArray = TArray(AActor)
		for _, Target in ipairs(Targets) do
			TargetArray:Add(Target)
		end
		Targets = TargetArray
	end
	
	return Targets, CollisionComps
end

function Component:GetPureServerTargetFilters_Lua()
	return 
	{
		"MySummoned",
		"MyCreature",
	}
end

--region 废弃代码

-- function Component:ApplyRangeModifyByEffectId(Source, EffectId, Ranges)
-- 	local EffectInfo = DataMgr.SkillEffects[EffectId]
-- 	if not EffectInfo then
-- 		return Ranges
-- 	end
-- 	local TargetFilterKey = EffectInfo.TargetFilter
-- 	if TargetFilterKey then
-- 		local FilterData = DataMgr.TargetFilter[TargetFilterKey]
-- 		local LuaFilter = FilterData.LuaFilter
-- 		local SkillRange = 1
-- 		if LuaFilter == "CheckRangeHit" then
-- 			local ParamentsTable = FilterData.LuaFilterParaments
-- 			if ParamentsTable.Type == "Sphere" then
-- 				SkillRange = ParamentsTable.Radius
-- 			elseif ParamentsTable.Type == "Rectangle" then
-- 				SkillRange = ParamentsTable.Width
-- 			elseif ParamentsTable.Type == "Cylinder" then
-- 				SkillRange = ParamentsTable.Radius
-- 			end
-- 		end
-- 		local SkillRanges = { SkillRange }
-- 		local ModifyInfo = { AllowSkill = EffectInfo.AllowSkillRangeModify, AttackRangeType = EffectInfo.AttackRangeType }
-- 		self:ApplyRangeModify(Source, ModifyInfo, SkillRanges)
-- 		local Scale = SkillRanges[1] / SkillRange
-- 		if Ranges.ToTable then Ranges = Ranges:ToTable() end
-- 		for i = 1, #Ranges do Ranges[i] = Ranges[i] * Scale end
-- 		-- print("LogInfo", "skill effect scale ", Scale)
-- 	end
-- 	return Ranges
-- end

-- 疑似没用
--function Component:Filter_CheckLineHitBySphere(Source, FilterData, CenterPos, TargetPos, ModifyInfo, Debug)
--	local HitResults = TArray(FHitResult)
--	local Radius = FilterData.LuaFilterParaments.Radius
--	local Targets = TArray(AActor)
--	local CollisionCompMap = {}
--	UE4.UKismetSystemLibrary.SphereTraceMulti(self,CenterPos, TargetPos, Radius, ETraceTypeQuery.TraceThroughWall, false, nil, EDrawDebugTrace.None, HitResults, true)
--	for _, HitResult in pairs(HitResults) do
--		local Target = HitResult.Actor
--		Targets:AddUnique(Target)
--		
--		self:AddCollisionCompToMap(CollisionCompMap, Target, HitResult.Component)
--	end
--	return Targets, CollisionCompMap
--end

--function Component:CheckFlatCircleSector(Target, CenterPos2D, Forward2D, TargetLoc2D, Radius, Angle)
--	local bInSector = false
--	if MiscUtils.GetGameCofingSettings("bUseFlatPolygon") and Target.CapsuleComponent then
--		local TargetRadius = Target.CapsuleComponent:GetScaledCapsuleRadius()
--		bInSector = MiscUtils.IsInsideSector(CenterPos2D, Forward2D, TargetLoc2D, TargetRadius, Radius, Angle)
--	elseif MiscUtils.GetGameCofingSettings("bUseFlatPolygon") and UE4.UKismetMathLibrary.ClassIsChildOf(Target:GetClass(), ASkillCreature:StaticClass()) then 
--		if Target:IsSkillCreature() and Target.ConfigData.ShapeInfo and Target.ConfigData.ShapeInfo["IsHollow"] then
--			local OutterRadius = Target.ConfigData.ShapeInfo["Radius"]
--			local InnerRadius = Target.ConfigData.ShapeInfo["InnerRadius"]
--			bInSector = MiscUtils.IsRingCrossSector(CenterPos2D, Forward2D, TargetLoc2D, OutterRadius, Radius, Angle, InnerRadius)
--		end
--	end
--	return bInSector
--end


--function Component:CheckShouldUseFlatPolygon(Target)
--	return MiscUtils.GetGameCofingSettings("bUseFlatPolygon") and (Target.CapsuleComponent or UE4.UKismetMathLibrary.ClassIsChildOf(Target:GetClass(), ASkillCreature:StaticClass()))
--end

--function Component:Filter_Self(Source, PreTarget, FilterData, Debug)
--	return {Source}
--end
--
--function Component:Filter_Target(Source, PreTarget, FilterData, Debug)
--	if not PreTarget then
--		return
--	end
--	
--    local CollisionCompMap = {}
--    local CollisionName = Source:GetString("CollisionName")
--	
--	if CollisionName then
--		local CollisionComp = self:GetComponentByName(PreTarget, CollisionName)
--		
--		if CollisionComp then
--			local PrimitiveComp = CollisionComp:Cast(UPrimitiveComponent)
--			if PrimitiveComp then
--				local Eid = PreTarget.Eid or PrimitiveComp.Eid
--				CollisionCompMap = {[Eid]={PrimitiveComp}}
--			end
--		end
--	end
--	return {PreTarget}, CollisionCompMap 
--end

--function Component:Filter_BTTarget(Source, PreTarget, FilterData, Debug)
--	local Target = Source.BBTarget
--	if not Target then
--		return
--	end
--	return {Target}
--end

--function Component:Filter_MySummoned(Source, PreTarget, FilterData, Debug)
--	if Source:GetAllDirectorSummon():Length()==0 then
--		return 
--	end
--
--	local Targets = {}
--	for _,SummonEid in pairs(Source:GetAllDirectorSummon():ToTable()) do
--		local Summon = Battle(self):GetEntity(SummonEid)
--		if Summon then
--			table.insert(Targets, Summon)
--		end
--	end
--	
--	return Targets
--end

--function Component:Filter_CustomizedTargets(Source, PreTarget, FilterData, Debug)
--	if not Source.CustomizedTargets then
--		return 
--	end
--
--	local Targets = {}
--	for _,Eid in pairs(Source.CustomizedTargets) do
--		local Target = Battle(self):GetEntity(Eid)
--		if Target then
--			table.insert(Targets, Target)
--		end
--	end
--	
--	return Targets
--end

--function Component:Filter_MyCreature(Source, PreTarget, FilterData, Debug)
--	-- if not Source.DirectCreature then
--	-- 	return
--	-- end
--	local RootCreature = Source:GetRootCreature()
--	local Targets = RootCreature:ToTable()
--	return Targets
--end

--function Component:Filter_CondemnTarget(Source, PreTarget, FilterData, Targets, Debug)
--	if not Source or not Source.CondemnMonsterEid then
--		return
--	end
--
--    local CondemnMonster = Battle(self):GetEntity(Source.CondemnMonsterEid)
--	if not CondemnMonster then
--		return
--	end
--	return {CondemnMonster}
--end

--function Component:Filter_RootSource(Source, PreTarget, FilterData, Targets, Debug)
--	return {Source:GetRootSource()}
--end

--function Component:Filter_GetActor(Source, PreTarget, TargetFilterKey, ModifyInfo, Debug)
--	if not Source then
--		return
--	end
--	DebugPrint("发起了一次GetActor类型的TargetFilter")
--	local FilterData = DataMgr.TargetFilter[TargetFilterKey]
--	local ActorName = FilterData.LuaFilterParaments.ActorName
--	local Actor = nil
--	if (ActorName and Source.DataSet_GetActor) then
--		Actor = Source:DataSet_GetActor(ActorName)
--	end
--	if (not IsValid(Actor)) then
--		return
--	end
--	DebugPrint("TargetFilter的GetActor过滤出的对象是", UKismetSystemLibrary.GetObjectName(Actor))
--	return {Actor}
--end


--function Component:Filter_CheckSphereHit(Source, TargetFilterKey, CenterPos, ObjectTypes, ModifyInfo, Debug, SourceComponent)
--	local FilterData = DataMgr.TargetFilter[TargetFilterKey]
--	local ParamentsTable = FilterData.LuaFilterParaments
--	local TempTargets = TArray(UPrimitiveComponent)
--	local Radius = ParamentsTable.Radius
--	local Ranges = self:ApplyRangeModify(Source, ModifyInfo, {Radius})
--	Radius = Ranges[1]
--
--	local Angle = FilterData.RangeAngle
--	return self:CheckSphereHit(Source, CenterPos, ObjectTypes, Radius, Angle, Debug)
--end
--
--
--function Component:Filter_CheckCylinderHit(Source, TargetFilterKey, CenterPos, ObjectTypes, ModifyInfo, Debug, SourceComponent)
--	local FilterData = DataMgr.TargetFilter[TargetFilterKey]
--	local ParamentsTable = FilterData.LuaFilterParaments
--	local Radius = ParamentsTable.Radius
--	local CylinderHeight = ParamentsTable.CylinderHeight
--	local Ranges = self:ApplyRangeModify(Source, ModifyInfo, {Radius, CylinderHeight})
--	Radius = Ranges[1]
--	CylinderHeight = Ranges[2]
--	
--	local Angle = FilterData.RangeAngle
--	return self:CheckCylinderHit(Source, CenterPos, ObjectTypes, Radius, CylinderHeight, Angle, Debug)
--end


--function Component:DoTargetFilter(Source, PreTarget, TargetFilterKey, AllowSkillRangeModify, AttackRangeType, Debug,
--								  DeadTargetEids, OutCollisionComps, ExtraBPFilter, ExtraVars, SourceComponent)
--	assert(IsValid(Source), 'DoTargetFilter的时候，传入的Source不是有效的')
--	local Data = DataMgr.TargetFilter[TargetFilterKey]
--	self.TargetFilterKey = TargetFilterKey
--	assert(Data, '错误的TargetFilterKey:' .. TargetFilterKey)
--
--	local LuaFilter = Data.LuaFilter
--	--local ModifyInfo = { AllowSkill = AllowSkillRangeModify, AttackRangeType = AttackRangeType }
--	local ModifyInfo = FRangeModifyInfo()
--	ModifyInfo.AllowSkillRangeModify = AllowSkillRangeModify
--	ModifyInfo.AttackRangeType = AttackRangeType
--	local Targets, CollisionComps = self["Filter_"..LuaFilter](self, Source, PreTarget, TargetFilterKey, ModifyInfo, Debug, SourceComponent)
--	if not Targets then
--		return TArray(0)
--	end
--
--	if LuaFilter == "CheckRangeHit" then
--		CollisionComps = self:TMap2Table(CollisionComps)
--	end
--	
--	-- MiscUtils.PrintArray(Targets, "FilterResult:["..TargetFilterKey..']')
--	Targets = self:FilterTargetInitSuccess(Targets)
--	local DeadTargets
--	-- MiscUtils.PrintArray(Targets, "FilterResultInitSuccess:["..TargetFilterKey..']')
--	if LuaFilter ~= "CondemnTarget" then
--		Targets, DeadTargets = self:FilterTargetNotDead(Targets)
--	end
--	-- MiscUtils.PrintArray(Targets, "NotDead List:["..TargetFilterKey..']')
--	local CampFilter = Data.CampFilter
--	if CampFilter then
--		Targets = self:FilterTargetsByCamp(Source, Targets, ECampFilter[CampFilter])
--	end
--	-- MiscUtils.PrintArray(Targets, tostring(CampFilter)..'_List:['..TargetFilterKey..']')
--
--	local TargetEids = TArray(0)
--	if not IsEmptyTable(Targets) then
--		for _, Target in pairs(Targets) do
--			if Target then
--				if self:IsDanmakuTarget(Target) then
--					self:PushDanmakuIdByTarget(TargetEids, Target, CollisionComps)
--				else
--					TargetEids:Add(Target.Eid)
--				end
--			end
--		end
--	end
--
--	-- MiscUtils.PrintArray(TargetEids, 'Eids:['..TargetFilterKey..']')
--
--	-- local DeadTargetEids = TArray(0)
--	if DeadTargetEids and DeadTargets then
--		for _, Target in pairs(DeadTargets) do
--			if Target then
--				DeadTargetEids:Add(Target.Eid)
--			end
--		end
--	end
--	-- MiscUtils.PrintArray(DeadTargetEids, 'DeadEids:')
--
--	local BPFilter = Data.BPFilter
--	if BPFilter then
--		local Vars = Data.BPFilterVars
--		TargetEids = self:DoBPFilter(Source, TargetEids, BPFilter, Vars, ExtraVars, CollisionComps)
--		-- MiscUtils.PrintArray(TargetEids, "DoBPFilter:["..TargetFilterKey..']')
--	end
--
--	if ExtraBPFilter then
--		TargetEids = self:DoBPFilter(Source, TargetEids, ExtraBPFilter, ExtraVars, nil, CollisionComps)
--	end
--
--	if OutCollisionComps and CollisionComps then
--		self:FillOutCollisionComps(OutCollisionComps, TargetEids, CollisionComps)
--	end
--
--	return TargetEids
--end

-- @zyh已移到C++，稳定后删除
--function Component:GetTargetLocation(Target, TargetComponent)
--	if TargetComponent then
--		return TargetComponent:K2_GetComponentLocation()
--	end
--	return Target.CurrentLocation or Target:K2_GetActorLocation()
--end
--
--function Component:GetTargetForwardVector(Target, TargetComponent)
--	if TargetComponent then
--		return TargetComponent:GetForwardVector()
--	end
--	return Target:GetActorForwardVector()
--end
--
--function Component:GetTargetRightVector(Target, TargetComponent)
--	if TargetComponent then
--		return TargetComponent:GetRightVector()
--	end
--	return Target:GetActorRightVector()
--end
--
--function Component:GetTargetUpVector(Target, TargetComponent)
--	if TargetComponent then
--		return TargetComponent:GetUpVector()
--	end
--	return Target:GetActorUpVector()
--end

-- function Component:CreateHitParam(Eid, ActorForwardVector, HitPosition)
-- 	local HitParam = FHitParam()
-- 	HitParam.Eid = Eid
-- 	if ActorForwardVector then
-- 		HitParam.HitDirection = CommonUtils.TableToVector(ActorForwardVector)
-- 	end
-- 	if HitPosition then
-- 		HitParam.HitPosition = CommonUtils.TableToVector(HitPosition)
-- 	end
-- 	return HitParam
-- end

--@zhuyuhao:已移到C++，稳定后删除
--function Component:GetEffectTargetObjectTypes()
--	local ObjectTypes = TArray(EObjectTypeQuery)
--	ObjectTypes:Add(EObjectTypeQuery.Pawn)
--	ObjectTypes:Add(EObjectTypeQuery.MonsterHitedCapsule)
--	ObjectTypes:Add(EObjectTypeQuery.BreakableItem)
--	ObjectTypes:Add(EObjectTypeQuery.MonsterDeadCapsule)
--	return ObjectTypes
--end
--
--function Component:GetEffectCenterPos(TargetFilterKey, Source, PreTarget, SourceComponent)
--	local FilterData = DataMgr.TargetFilter[TargetFilterKey]
--	local ParamentsTable = FilterData.LuaFilterParaments
--	local CenterOffset = FilterData.CenterOffset
--	local ForwardVector
--	local RightVector
--	local CenterPos
--	local UpVector
--	local ZOffset
--	if ParamentsTable.Center == "Target" and PreTarget then
--		CenterPos = self:GetTargetLocation(PreTarget)
--		ForwardVector = PreTarget:GetActorForwardVector()
--		RightVector = PreTarget:GetActorRightVector()
--	elseif ParamentsTable.Center == "Camera" and Source.GetCameraComponent then
--		local CameraComponent = Source:GetCameraComponent()
--		CenterPos = CameraComponent:K2_GetComponentLocation()
--		ForwardVector = CameraComponent:GetForwardVector()
--		RightVector = CameraComponent:GetRightVector()
--	elseif ParamentsTable.Center == "CharSocket" then
--		if ParamentsTable.SocketName then
--			CenterPos = Source.Mesh:GetSocketLocation(ParamentsTable.SocketName)
--		else
--			CenterPos = self:GetTargetLocation(Source, SourceComponent)
--		end
--		ForwardVector = self:GetTargetForwardVector(Source, SourceComponent)
--		RightVector = self:GetTargetRightVector(Source, SourceComponent)
--		UpVector = self:GetTargetUpVector(Source, SourceComponent)
--	elseif ParamentsTable.Center == "WeaponSocket" and Source.GetCurrentWeapon then
--		local Weapon = Source:GetCurrentWeapon()
--		CenterPos = Weapon.WeaponMesh:GetSocketLocation(ParamentsTable.SocketName or "root")
--		ForwardVector = Weapon:GetActorForwardVector()
--		RightVector = Weapon:GetActorRightVector()
--		UpVector = Weapon:GetActorUpVector()
--	else
--		CenterPos = self:GetTargetLocation(Source, SourceComponent)
--		ForwardVector = self:GetTargetForwardVector(Source, SourceComponent)
--		RightVector = self:GetTargetRightVector(Source, SourceComponent)
--		UpVector = self:GetTargetUpVector(Source, SourceComponent)
--	end
--	if CenterOffset then
--		CenterPos = CenterPos + ForwardVector * CenterOffset[1] + RightVector * CenterOffset[2]
--		ZOffset = CenterOffset[3] or 0
--		CenterPos = CenterPos + UpVector * ZOffset
--	end
--	return CenterPos
--end

--function Component:Filter_CheckRangeHit(Source, PreTarget, TargetFilterKey, ModifyInfo, Debug, SourceComponent)
--	local FilterData = DataMgr.TargetFilter[TargetFilterKey]
--    local ParamentsTable = FilterData.LuaFilterParaments
--	local CenterPos = self:GetEffectCenterPos(TargetFilterKey, Source, PreTarget, SourceComponent)
--	local ObjectTypes = self:GetEffectTargetObjectTypes()
--
--
--	local Targets = {}
--	local CollisionCompMap = nil
--	if ParamentsTable.Type == "Sphere" then
--		Targets, CollisionCompMap = self:Filter_CheckSphereHit(Source, TargetFilterKey, CenterPos, ObjectTypes, ModifyInfo, Debug, SourceComponent)
--	end
--	if ParamentsTable.Type == "Rectangle" then
--		Targets, CollisionCompMap = self:Filter_CheckRectangleHit(Source, TargetFilterKey, CenterPos, ObjectTypes, ModifyInfo, Debug, SourceComponent)
--	end
--	if ParamentsTable.Type == "Cylinder"then
--		Targets, CollisionCompMap = self:Filter_CheckCylinderHit(Source, TargetFilterKey, CenterPos, ObjectTypes, ModifyInfo, Debug, SourceComponent)
--	end
--	if ParamentsTable.Type == "Cone"then
--		Targets, CollisionCompMap = self:Filter_CheckConeHit(Source, TargetFilterKey, CenterPos, ObjectTypes, ModifyInfo, Debug, SourceComponent)
--	end
--
--	-- 穿墙检测
--	if FilterData.LineTraceFilter then
--		-- MiscUtils.PrintArray(Targets, "Targets1")
--		-- PrintTable(CollisionNames, 3, "CollisionNames1")
--		Targets, CollisionCompMap = self:LineTraceFilter(Source, CenterPos, Targets, CollisionCompMap)
--        -- MiscUtils.PrintArray(Targets, "Targets2")
--        -- PrintTable(CollisionNames, 3, "CollisionNames2")
--	end
--
--	return Targets, CollisionCompMap
--end

--function Component:LineTraceFilter(Source, CenterPos, Targets, CollisionCompMap)
--	local NewTargets = TArray(AActor)
--	local NewCollisionCompMap = {}
--
--	local ActorsToIgnore = TArray(AActor)
--	for Eid, _CollisionComps in pairs(CollisionCompMap) do
--		for _, Collision in ipairs(_CollisionComps) do
--			local HitResult = FHitResult()
--			local EndPos = Collision:K2_GetComponentLocation()
--			local Target = Collision:GetOwner()
--			local bHit = UE4.UKismetSystemLibrary.LineTraceSingle(Source, CenterPos, EndPos, ETraceTypeQuery.TraceScene, false, ActorsToIgnore, 0, HitResult, true)
--			if not bHit then
--				NewTargets:AddUnique(Target)
--
--				self:AddCollisionCompToMap(NewCollisionCompMap, Target, Collision)
--			end
--		end
--	end
--
--	return NewTargets, NewCollisionCompMap
--end

--function Component:Filter_CheckConeHit(Source, TargetFilterKey, CenterPos, ObjectTypes, ModifyInfo, Debug, SourceComponent)
--	local FilterData = DataMgr.TargetFilter[TargetFilterKey]
--	local ActorsToIgnore = TArray(AActor)
--	local ParamentsTable = FilterData.LuaFilterParaments
--	-- 圆锥的高
--	local ConeHeight = ParamentsTable.ConeHeight
--	-- ConeHeight =ConeHeight * 3
--	if not ConeHeight or ConeHeight <= 0 then
--		return
--	end
--	local ConeAngle = ParamentsTable.ConeAngle
--	-- ConeAngle = 60
--	-- ConeAngle = 19
--	-- ConeHeight = 10
--	-- 圆锥母线和高的夹角
--	if not ConeAngle or ConeAngle <= 0 or ConeAngle >= 90 then
--		return
--	end
--	-- 圆锥的发射方向
--	local Direction = ParamentsTable.Direction
--	if Direction == "Camera" then
--		local CameraComponent = Source:GetCameraComponent()
--		if CameraComponent then
--			local Rotation = CameraComponent:K2_GetComponentRotation()
--			Direction = UE4.UKismetMathLibrary.GetForwardVector(Rotation)
--		end
--	end
--	
--	if not Direction then
--		Direction = Source:GetActorForwardVector()
--	end
--	Direction:Normalize()
--
--	-- 先用圆锥的外界球，做一下碰撞
--	-- 1.求外界球的圆心和半径
--	-- 圆锥底面半径
--	local Radius = UE.UKismetMathLibrary.DegTan(ConeAngle) * ConeHeight
--
--	-- 外界球的半径
--	local SphereRadius = (Radius * Radius + ConeHeight * ConeHeight) / 2 / ConeHeight
--
--	-- 外接球的球心
--	local SphereCenter = CenterPos + Direction * SphereRadius
--	-- PrintTable({C=SphereCenter,SR=SphereRadius})
--	
--	local TempTargets = TArray(UPrimitiveComponent)
--	local bHit = UE4.UKismetSystemLibrary.SphereOverlapComponents(Source, SphereCenter, SphereRadius, ObjectTypes, UPrimitiveComponent, ActorsToIgnore, TempTargets)
--	if  _G.DrawDebugTest or Debug then
--		local Color = UE4.FLinearColor(math.random(0,1), math.random(0,1), math.random(0,1), 1)
--		-- UE4.UKismetSystemLibrary.DrawDebugSphere(Source, SphereCenter, SphereRadius, 30, Color, 2, 3)
--        -- UE4.UKismetSystemLibrary.DrawDebugConeInDegrees(Source, CenterPos, Direction, math.sqrt(ConeHeight * ConeHeight + Radius * Radius), ConeAngle, ConeAngle, 20, Color, 2, 3)
--		-- UE4.UKismetSystemLibrary.DrawDebugConeInDegrees(Source, CenterPos + Direction * ConeHeight, Direction, Radius, 90, 90, 30, Color, 2, 3)
--	end
--	if not bHit then
--		return
--	end
--
--	local CollisionCompMap = {}
--	local Targets = TArray(AActor)
--	for _, TargetComp in pairs(TempTargets) do
--		local TargetLocation = TargetComp:K2_GetComponentLocation()
--		local bInCone = self:PositionInCone(TargetLocation, CenterPos, Direction, ConeHeight, ConeAngle)
--		if bInCone then
--			local TargetActor = TargetComp:GetOwner()
--			Targets:AddUnique(TargetActor)
--			
--			self:AddCollisionCompToMap(CollisionCompMap, TargetActor, TargetComp)
--		end
--	end
--	
--	return Targets, CollisionCompMap
--end

-- TODO@gmy: 这部分已经挪到C++，稳定后删除
--function Component:FillFilterResult(Source, TargetFilterResult, TargetFilter, TargetEids, DeadTargetEids, CollisionComps, PartEidMap)
--	local CollisionNames = self:GetCollisionNamesByComps(CollisionComps)
--
--	if TargetEids and TargetEids:Length() > 0 then
--		local HitPosition = self:GetHitPosition(Source)
--		TargetFilterResult.HitPosition = HitPosition
--
--		local ActorForwardVector = Source:GetActorForwardVector()
--		for _, TargetEid in pairs(TargetEids) do
--			TargetFilterResult.HitTargets:Add(TargetEid)
--
--			if CollisionNames then
--				local TargetEnt = self:GetEntity(TargetEid)
--				if TargetEnt then
--					self:FillCollisionName(TargetEnt, TargetFilterResult, CollisionNames[TargetEid], ActorForwardVector, HitPosition)
--				end
--			end
--		end
--	end
--	if DeadTargetEids and DeadTargetEids:Length() > 0 then
--		for _, TargetEid in pairs(DeadTargetEids) do
--			TargetFilterResult.DeadTargets:Add(TargetEid)
--		end
--	end
--
--	if PartEidMap and PartEidMap:Num() > 0 then
--		for PartOwnerEid, PartEidStruct in pairs(PartEidMap) do
--			local PartEids = PartEidStruct.Data
--			if PartEids and PartEids:Num() > 0 then
--				local PartEidArray = TArray(0)
--				for _, PartEid in pairs(PartEids) do
--					PartEidArray:Add(PartEid)
--				end
--				TargetFilterResult:AddPartEidMapData(PartOwnerEid, PartEidArray)
--			end
--		end
--	end
--
--	local TargetFilterConfig = DataMgr.TargetFilter[TargetFilter]
--	TargetFilterResult.DontCullPartTarget = TargetFilterConfig.DontCullPartTarget or false
--end
--
--function Component:FillCollisionName(Target, TargetFilterResult, CollisionNames, ActorForwardVector, HitPosition)
--	-- https://herogames.feishu.cn/docx/XY0Dd7B6CoYKVJxQGymcmMS0nJg
--	if not CollisionNames then
--		return
--	end
--
--	local function CalcAngle(Target, HitDirection, HitPosition, CollisionName)
--		local CollisionComponent = Target[CollisionName]
--		if not CollisionComponent then
--			CollisionComponent = Target:K2_GetRootComponent()
--		end
--		local Location = CollisionComponent:K2_GetComponentLocation()
--		local Forward = UKismetMathLibrary.Vector_Normal2D(Location - HitPosition, 0.0001);
--		-- PrintTable({Forward=Forward,CollisionName=CollisionName})
--		local DotResult = UKismetMathLibrary.Dot_VectorVector(HitDirection, Forward)
--		local Angle = UE4.UKismetMathLibrary.DegAcos(DotResult)
--		return Angle
--	end
--
--	local HitDirection = UKismetMathLibrary.Vector_Normal2D(ActorForwardVector, 0.0001)
--
--	-- PrintTable({CollisionNames=CollisionNames},10)
--	for _, CollisionName in pairs(CollisionNames) do
--		-- 如果有主胶囊体
--		if CollisionName == "MonsterHitedCapsule" then
--			-- 并且主胶囊体在前方
--			local Angle = CalcAngle(Target, HitDirection, HitPosition, CollisionName)
--			if Angle < 90 then
--				TargetFilterResult.CollisionNames:Add(Target.Eid, CollisionName)
--				return
--			end
--		end
--	end
--
--	-- 否则用角度最小的那个
--	local MinAngle = nil
--	for _, CollisionName in pairs(CollisionNames) do
--		local Angle = CalcAngle(Target, HitDirection, HitPosition, CollisionName)
--		if MinAngle == nil or Angle < MinAngle then
--			TargetFilterResult.CollisionNames:Add(Target.Eid, CollisionName)
--			MinAngle = Angle
--		end
--	end
--end

--function Component:DoBPFilters(Source, TargetEids, TargetFilterKey, ExtraEffectId, CollisionComps, ExtraBPFilter)
--	local Data = DataMgr.TargetFilter[TargetFilterKey]
--	local BPFilter = Data.BPFilter
--	if BPFilter then
--		local Vars = Data.BPFilterVars
--		local ExtraVars = nil
--		if ExtraEffectId ~= 0 and ExtraEffectId ~= -1 then
--			ExtraVars = DataMgr.SkillEffects[ExtraEffectId].TargetFilterVars
--		end
--		TargetEids = self:DoBPFilter(Source, TargetEids, BPFilter, Vars, ExtraVars, CollisionComps)
--	end
--	
--	if ExtraBPFilter and ExtraBPFilter ~= "" then
--        TargetEids = self:DoExtraBPFilter(Source, TargetEids, ExtraBPFilter, ExtraEffectId, CollisionComps)
--	end
--	return TargetEids
--end
--
--function Component:DoExtraBPFilter(Source, TargetEids, FilterFunc, ExtraEffectId, CollisionCompMap)
--	local EffectConfig = DataMgr.SkillEffects[ExtraEffectId]
--	if EffectConfig then
--		local Vars = EffectConfig.TargetFilterVars
--		return self:DoBPFilter(Source, TargetEids, FilterFunc, Vars, nil, CollisionCompMap)
--	end
--	return TargetEids
--end
--
--function Component:DoBPFilter(Source, TargetEids, FilterFunc, Vars, ExtraVars, CollisionCompMap)
--	if not Source or not TargetEids or TargetEids:Length() <= 0 then
--		return TargetEids
--	end
--
--	if FilterFunc then
--		TargetEids = self.TargetFilterComponent:DoBPFilter(Source, TargetEids, FilterFunc, Vars, ExtraVars, CollisionCompMap)
--	end
--
--	return TargetEids
--end

--function Component:GetHitPosition(Source)
--	local HitPosition = Source:K2_GetActorLocation()
--	if Source.Mesh then
--		local HandPos = Source.Mesh:GetSocketLocation("FX_Trail2")
--		if HandPos then
--			HitPosition = HandPos
--		end
--	end
--	return HitPosition
--end

--function Component:Filter_CheckLineHit(Source, PreTarget, TargetFilterKey, ModifyInfo, Debug)
--	local FilterData = DataMgr.TargetFilter[TargetFilterKey]
--	local ParamentsTable = FilterData.LuaFilterParaments
--	local CenterPos = self:GetEffectCenterPos(TargetFilterKey, Source, PreTarget)
--	local TargetPos = self:CalcTargetPos(Source, ParamentsTable, CenterPos)
--	local Targets = {}
--	local CollisionCompMap = nil
--	if ParamentsTable.Type == "Sphere" then
--		Targets, CollisionCompMap = self:Filter_CheckLineHitBySphere(Source, FilterData, CenterPos, TargetPos, ModifyInfo, Debug)
--	end
--	return Targets, CollisionCompMap
--end
--
--function Component:CalcTargetPos(Source, ParamentsTable, CenterPos)
--	local Direction = nil
--	if ParamentsTable.Direction == "Camera" then
--		Direction = CommonUtils.TableToVector(Source:GetCameraComponent():GetForwardVector())
--	elseif ParamentsTable.Direction == "Forward" then
--		Direction = CommonUtils.TableToVector(Source:GetActorForwardVector())
--	else
--		Direction = CommonUtils.TableToVector(Source:GetCameraComponent():GetForwardVector())
--	end
--	Direction:Normalize()
--	FVector.Mul(Direction, ParamentsTable.Length)
--	FVector.Add(Direction, CenterPos)
--	return Direction
--end


-- TODO@gmy: 这部分已经挪到C++，稳定后删除
--function Component:SelectTargetTask(Source, EffectId, TargetFilterResult, PreTarget, SourceComponent)
--	assert(IsValid(Source), 'SelectTargetTask的时候，传入的Source不是有效的')
--	if not IsValid(PreTarget) then
--		PreTarget = nil
--	end
--	local EffectInfo = DataMgr.SkillEffects[EffectId]
--	assert(EffectInfo, '技能效果编号填写错误:' .. tostring(EffectId))
--	TargetFilterResult.EffectId = EffectId
--
--	local TargetFilter = EffectInfo.TargetFilter
--	if TargetFilter then
--		local TargetEids, DeadTargetEids, CollisionComps, OutPartEidMap = self:DoTargetFilter(
--				Source, PreTarget, TargetFilter, EffectInfo.AllowSkillRangeModify or false, EffectInfo.AttackRangeType or "", 
--				false, EffectId, SourceComponent)
--
--		
--		-- todo@ 重新写一下声明
--		self:TestSyncTaskTargets(Source, TargetFilter, TargetEids, TargetFilterResult)
--
--		--self:FillFilterResult(Source, TargetFilterResult, TargetFilter, TargetEids, DeadTargetEids, CollisionComps, OutPartEidMap)
--		--
--		--self:FillExtraInfos(Source, EffectInfo, TargetFilterResult, PreTarget)
--		--
--		--self:SyncTaskTargets(Source, TargetFilterResult)
--	end
--	
--	return TargetFilterResult
--end

--function Component:FillExtraInfos(Source, EffectInfo, TargetFilterResult, PreTarget)
--	if not IsClient(Source) or not MiscUtils.IsAutonomousProxy(Source) then
--		return
--	end
--
--	local Effects = EffectInfo.TaskEffects
--	if not Effects then
--		return
--	end
--
--	for i, Effect in pairs(Effects) do
--		self:FillFallAttackForwardVector(Source, Effect, TargetFilterResult)
--		self:FillEffectSocketPosition(Source, Effect, TargetFilterResult, PreTarget)
--	end
--end

--function Component:FillFallAttackForwardVector(Source, Effect, TargetFilterResult)
--	if not UE4.UKismetMathLibrary.Vector_IsNearlyZero(TargetFilterResult.ControlForwardVector) then
--		return
--	end
--	if Effect.Function ~= 'AddCameraSpeed' then
--		return
--	end
--	if Effect.ClientOnly then
--		return
--	end
--	local FallAttackObject = Source:GetOrAddFallAttackObject()
--	local ControlForwardVector = FallAttackObject:CalcFallAttackForwardVector()
--	TargetFilterResult.ControlForwardVector = ControlForwardVector
--end
--
--function Component:FillEffectSocketPosition(Source, Effect, TargetFilterResult, PreTarget)
--	if Effect.Function ~= 'CreateSkillCreature' then
--		return
--	end
--	if Effect.ClientOnly then
--		return
--	end
--
--	local CreatureId = Effect.CreatureId
--	if not CreatureId then
--		return
--	end
--	local CreatureInfo = DataMgr.SkillCreature[CreatureId]
--	if not CreatureInfo then
--		return
--	end
--	local SpawnSocket = CreatureInfo.SpawnSocket
--	if not SpawnSocket then
--		return
--	end
--	if TargetFilterResult.SocketPositions:Find(SpawnSocket.SpawnSocket) then
--		return
--	end
--	local Location = self:GetSpawnSocketLocation(Source, PreTarget, SpawnSocket.UseLocation, SpawnSocket.SpawnSocket)
--	TargetFilterResult.SocketPositions:Add(SpawnSocket.SpawnSocket, Location)
--end

-- TODO@gmy: 这部分已经挪到C++，稳定后删除
--function Component:SyncTaskTargets(Source, TargetFilterResult)
--	-- 如果是客户端并且是客户端拥有，通知服务器
--	if IsClient(Source) and MiscUtils.IsAutonomousProxy(Source) then
--		local ClientTargetFilter = self:ConvertToClientTargetFilter(TargetFilterResult)
--		Source:ServerTargetFilters(ClientTargetFilter)
--	end
--end

--function Component:FillOutCollisionComps(OutCollisionComps, TargetEids, CollisionComps)
--	-- PrintTable({CollisionNames,TargetEids,TargetEids:Length()}, 10, "CollisionNames")
--	for _, Eid in pairs(TargetEids) do
--		local Target = self:GetEntity(Eid)
--		if Target and Target.MultiHitedCapsule or self:IsDanmakuCreatureEid(Eid) then
--			OutCollisionComps[Eid] = CollisionComps[Eid]
--		end
--	end
--	-- PrintTable(OutCollisionNames, 10, "OutCollisionNames")
--end

--endregion


--function Component:Filter_ShootingTargets(Source, PreTarget, FilterData, Debug)
--	if Source:IsMonster() then
--		return self:Filter_BTTarget(Source, PreTarget, FilterData, Debug)
--	end
--	return Source:GetShootingTargets()
--end

return Component

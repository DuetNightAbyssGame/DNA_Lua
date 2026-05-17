
local SkillEffectClass = {}

SkillEffectClass.New = function(Source, EffectId, TargetFilterResult, Location, Skill, SkillLevelSource, SkillEffectInfo, SourceComponent)
	if not IsValid(Source) then
		return
	end

	local EffectInfo = DataMgr.SkillEffects[EffectId]
	assert(EffectInfo, '技能效果编号填写错误:' .. tostring(EffectId))

	local Effects = EffectInfo.TaskEffects
	-- if not Effects then
	-- 	return
	-- end

	if not IsValid(Skill) then 
		Skill = nil
	end
	SkillLevelSource = SkillLevelSource or Skill

	-- local CutTNInfo = nil
	-- if DataMgr.SkillEffectsCutTN[EffectId] then
	-- 	CutTNInfo = {
	-- 		-- 每个目标是否清空韧性, {Target: true or false}
	-- 		IsEmptyTN = {},
	-- 		CutTNModifyRate = 1,
	-- 		CauseHit = DataMgr.SkillEffectsCutTN[EffectId].CauseHit
	-- 	}
	-- end

	local HitTargetsArray = TArray(0)
	local FirstTargetEid = nil
	if TargetFilterResult.HitTargets then
		for _, Eid in ipairs(TargetFilterResult.HitTargets) do
			HitTargetsArray:Add(Eid)
			if not FirstTargetEid then
				FirstTargetEid = Eid
			end
		end
	end

	local DeadTargetsArray = TArray(0) 
	if TargetFilterResult.DeadTargets then 
		for _, Eid in ipairs(TargetFilterResult.DeadTargets) do 
			DeadTargetsArray:Add(Eid)
		end
	end

	local CollisionNamesMap = TMap(0, FName)
	for Eid, CollisionName in pairs(TargetFilterResult.CollisionNames or {}) do
		CollisionNamesMap:Add(Eid, CollisionName)
	end

	local SkillEffectStruct = {
		Source = Source,
		EffectId = EffectId,
		Result = TargetFilterResult,
		Location = Location,
		Skill = Skill,
		SkillLevelSource = SkillLevelSource,

		EffectInfo = EffectInfo,
		Effects = Effects,

		-- 击中的目标 lua table
		HitTargets = TargetFilterResult.HitTargets,
		-- 击中的一些死亡的一些角色
		DeadTargets = TargetFilterResult.DeadTargets,
		-- 客户端射击的时候的挂接点位置
		SocketPositions = TargetFilterResult.SocketPositions,
		-- 攻击者控制器的方向
		ControlForwardVector = TargetFilterResult.ControlForwardVector,
		-- 攻击者的攻击点
		HitPosition = TargetFilterResult.HitPosition,
		-- TargetFilter 击中的胶囊体名字，只对多胶囊体怪物生效
		CollisionNames = TargetFilterResult.CollisionNames or {},
		-- 击中的目标的eid和part eid的映射
		PartEidMap = TargetFilterResult.PartEidMap or {},
		DontCullPartTarget = TargetFilterResult.DontCullPartTarget or false,
		
		UniqueId = nil,
		CanExecute = not not Effects,

		FirstTargetEid = FirstTargetEid,

		SkillEffectInfo = SkillEffectInfo,

		CppEffectStruct = FSkillEffectStruct(EffectId, HitTargetsArray, DeadTargetsArray, SkillEffectInfo or FSkillEffectInfo(), Skill, SkillLevelSource, Source, TargetFilterResult.HitPosition and CommonUtils.TableToVector(TargetFilterResult.HitPosition) or FVector(), CollisionNamesMap)
	}

	if SkillEffectStruct.CppEffectStruct.CutTNInfo.IsValid then
		SkillEffectStruct.CutTNInfo = SkillEffectStruct.CppEffectStruct.CutTNInfo
	end

	-- 如果传入SourceComponent，使用组件的朝向和位置
	if SourceComponent then
		-- 攻击者的位置
		SkillEffectStruct.ActorLocation = SourceComponent:K2_GetComponentLocation()
		-- 攻击者的朝向
		SkillEffectStruct.ActorForwardVector = SourceComponent:GetForwardVector()
		-- 攻击者的左右朝向
		SkillEffectStruct.ActorRightVector = SourceComponent:GetRightVector()
		-- 攻击者的上下朝向
		SkillEffectStruct.ActorUpVector = SourceComponent:GetUpVector()
	else
		SkillEffectStruct.ActorLocation = Source:K2_GetActorLocation()
		SkillEffectStruct.ActorForwardVector = Source:GetActorForwardVector()
		SkillEffectStruct.ActorRightVector = Source:GetActorRightVector()
		SkillEffectStruct.ActorUpVector = Source:GetActorUpVector()
	end
	
	if SourceComponent and SourceComponent.Eid then
		SkillEffectStruct.SourceComponentEid = SourceComponent.Eid
	end

	return SkillEffectStruct
end

return SkillEffectClass

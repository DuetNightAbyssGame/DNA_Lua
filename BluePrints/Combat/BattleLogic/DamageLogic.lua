
require "DataMgr"
require "Const"
-- local DamageProto = require "BluePrints.Combat.BattleLogic.DamageProto"

local Component = {}

-- function Component:ReceiveBeginPlay()
-- 	if IsStandAlone(self) then
-- 	   self.AddDamageResult = MiscUtils.EmptyFunction 
-- 	end
-- end

-- function Component:DumpDamageEvent(DamageEvent)
-- 	-- self:TestSproto(DamageEvent)
-- 	-- return DamageProto:pencode("Damage", DamageEvent)
-- 	local Ret = {
-- 		DamageValues = {},
-- 		SourceEid = DamageEvent.SourceEid,
-- 		TargetEid = DamageEvent.TargetEid,
-- 		DamageType = DamageEvent.DamageType,
-- 		TrueValue = DamageEvent.TrueValue,
-- 		EnergyShieldReduce = DamageEvent.EnergyShieldReduce,
-- 		CollisionName = DamageEvent.CollisionName,
-- 		SkillId = DamageEvent.SkillId,
-- 		DamageCritLevel = DamageEvent.DamageCritLevel,
-- 		EnableIcon = DamageEvent.EnableIcon,
-- 		KillTarget = DamageEvent.KillTarget,
-- 		DamageTag = DamageEvent.DamageTag,
-- 		HitPosition = DamageEvent.HitPosition,
-- 		HitDirection = DamageEvent.HitDirection,
-- 		CauseHitDamage = DamageEvent.CauseHitDamage,
-- 	}

-- 	for DamageType, DamageRate in pairs(DamageEvent.DamageValues) do
-- 		Ret.DamageValues[DamageType] =
-- 		{
-- 			ExtraDamage = DamageRate.ExtraDamage,
-- 			ExtraEffect = DamageRate.ExtraEffect,
-- 		}
-- 	end

-- 	return Ret
-- end

-- function Component:LoadDamageEvent(DamageEvent)
-- 	return DamageProto:pdecode("Damage", DamageEvent)
-- end

-- function Component:TestSproto(DamageEvent)
-- 	local msgpack = require "msgpack_core"
-- 	local DamageProto = require "BluePrints.Combat.BattleLogic.DamageProto"

-- 	function P1(Content)
-- 		local T1 = URuntimeCommonFunctionLibrary.GetNowMS()
-- 		local _str = msgpack.pack(Content)
-- 		local Ret1 = msgpack.unpack(_str)
-- 		local T2 = URuntimeCommonFunctionLibrary.GetNowMS()
-- 		PrintTable({P1=T2-T1,L = #_str})
-- 		return Ret1
-- 	end

-- 	function P2(Content)
-- 		local T1 = URuntimeCommonFunctionLibrary.GetNowMS()
-- 		local _str = DamageProto:pencode("Damage", Content)
-- 		local Ret2 = DamageProto:pdecode("Damage", _str)
-- 		local T2 = URuntimeCommonFunctionLibrary.GetNowMS()
-- 		PrintTable({P2=T2-T1,L = #_str})
-- 		return Ret2
-- 	end

-- 	function P3(Content)
-- 		local T1 = URuntimeCommonFunctionLibrary.GetNowMS()
-- 		local _str = DamageProto:encode("Damage", Content)
-- 		local Ret3 = DamageProto:decode("Damage", _str)
-- 		local T2 = URuntimeCommonFunctionLibrary.GetNowMS()
-- 		PrintTable({P3=T2-T1,L = #_str})
-- 		return Ret3
-- 	end

-- 	function DumpDamageValues(DamageEvent)
-- 		local Content = {}
-- 		local DamageValues = DamageEvent.DamageValues
-- 		for DamageType, DamageRate in pairs(DamageValues) do
-- 			Content[DamageType] = {
-- 				ExtraDamage = DamageRate.ExtraDamage,
-- 				ExtraEffect = DamageRate.ExtraEffect,
-- 			}
-- 		end
-- 		return Content
-- 	end

-- 	local Content = {
-- 		SourceEid = DamageEvent.SourceEid,
-- 		TargetEid = DamageEvent.TargetEid,
-- 		DamageType = DamageEvent.DamageType,
-- 		TrueValue = DamageEvent.TrueValue,
-- 		SkillId = DamageEvent.SkillId,
-- 		CollisionName = DamageEvent.CollisionName,
-- 		DamageCritLevel = DamageEvent.DamageCritLevel,
-- 		EnableIcon = DamageEvent.EnableIcon,

-- 		DamageValues = DumpDamageValues(DamageEvent),
-- 	}
	
-- 	local Ret1 = P1(Content)
-- 	local Ret2 = P2(DamageEvent)
-- 	local Ret3 = P3(DamageEvent)
-- 	PrintTable({Content,Ret1,Ret2,Ret3},10)
-- end

-- function Component:GenDamage(Source, Target, Skill, SkillLevelSource, EffectStruct, ActorForwardVector)
-- 	local DamageEvent = NewObject(MiscUtils.DamageEventClass(), self)
-- 	--DamageEvent.SourceEid = -1;
-- 	if IsValid(Source) then
-- 		DamageEvent:SetSourceEid(Source.Eid)
-- 		-- if Source.IsSkillCreature and Source:IsSkillCreature() then
-- 		-- 	DamageEvent.bIsCreatureDamage = true
-- 		-- end
-- 		if EffectStruct and EffectStruct.SkillEffectInfo and EffectStruct.SkillEffectInfo.IsLaunchRayCreature then
-- 			DamageEvent.bIsRayCreatureDamage = true
-- 		end
-- 	end
-- 	--DamageEvent.TargetEid = -1;
-- 	if IsValid(Target) then
-- 		if Target.IsCombatItemBase and Target:IsCombatItemBase() then
-- 			DamageEvent.PassiveCanExecute = false
-- 		end
-- 		DamageEvent:SetTargetEid(Target.Eid)
-- 	end
-- 	DamageEvent:SetSkill(Skill)
-- 	-- local TriggerProbability = 0
-- 	-- if Skill and Skill.Weapon then
-- 	-- 	DamageEvent.CalcWeapon = Skill.Weapon
-- 	-- 	TriggerProbability = Source:CalcTriggerProbability(Skill.Weapon.WeaponId)
-- 	-- end
-- 	-- DamageEvent.TriggerProbability = TriggerProbability
-- 	-- if DamageEvent.bIsRayCreatureDamage then
-- 	-- 	local SkillEffectInfo = EffectStruct.SkillEffectInfo
-- 	-- 	local MultiShootValue = SkillEffectInfo.MultiShootValue and SkillEffectInfo.MultiShootValue ~= 0 and SkillEffectInfo.MultiShootValue or 1
-- 	-- 	DamageEvent.TriggerProbability = MultiShootValue * DamageEvent.TriggerProbability
-- 	-- end
-- 	SkillLevelSource = SkillLevelSource or Skill
-- 	if SkillLevelSource then
-- 		DamageEvent:SetSkillLevelInfo(SkillLevelSource:GetSkillLevelInfo())
-- 	end
-- 	-- 合并HitParam
-- 	if ActorForwardVector then
-- 		DamageEvent.HitDirection = CommonUtils.TableToVector(ActorForwardVector)
-- 	end
-- 	if EffectStruct and EffectStruct.HitPosition then
-- 		DamageEvent.HitPosition = CommonUtils.TableToVector(EffectStruct.HitPosition)
-- 	end
-- 	-- PrintTable({DamageEvent_SkillLevel = DamageEvent:GetSkillLevelInfo().SkillLevel, DamageEvent_SkillGrade = DamageEvent:GetSkillLevelInfo().SkillGrade}, 10)
-- 	return DamageEvent
-- end

-- function Component:GenDamageWithType(Source, Target, DamageType, BaseValue, Skill, SkillLevelSource, DamageTag, DamageIconMode)
-- 	assert(DataMgr.DamageType[DamageType], '错误的伤害类型'..tostring(DamageType))
-- 	local DamageEvent = self:GenDamage(Source, Target, Skill, SkillLevelSource, FSkillEffectStruct())
-- 	DamageEvent:SetBaseValue(DamageType, BaseValue)
-- 	DamageEvent.EnableIcon = DamageIconMode or 0
-- 	DamageEvent.DamageTag = DamageTag
-- 	return DamageEvent
-- end

-- function Component:GenDamageByDamage(OldDamage)
-- 	local DamageEvent = NewObject(MiscUtils.DamageEventClass())
-- 	DamageEvent:SetSourceEid(OldDamage.SourceEid)
-- 	DamageEvent:SetTargetEid(OldDamage.TargetEid)
-- 	DamageEvent:SetSkill(OldDamage.Skill)
-- 	-- DamageEvent.bIsCreatureDamage = OldDamage.bIsCreatureDamage
-- 	DamageEvent.bIsRayCreatureDamage = OldDamage.bIsRayCreatureDamage
-- 	DamageEvent.TriggerProbability = OldDamage.TriggerProbability
-- 	DamageEvent:SetSkillLevelInfo(DamageEvent:GetSkillLevelInfo())

-- 	for Type, RateStruct in pairs(OldDamage.DamageValues) do
-- 		DamageEvent:SetBaseValue(Type, RateStruct.BaseValue)
-- 	end
	
-- 	return DamageEvent
-- end

-- function Component:UpdateDamageTriggerProbability(DamageEvent, TriggerProbability)
-- 	DamageEvent.TriggerProbability = TriggerProbability
-- end

-- function Component:SetBaseValues(DamageEvent, DamageValus)
-- 	for DamageType, Value in pairs(DamageValus) do
-- 		assert(DataMgr.DamageType[DamageType], '错误的伤害类型'..tostring(DamageType))

-- 		DamageEvent:SetBaseValue(DamageType, Value)
-- 	end
-- end

-- function Component:AddDamageResult_Lua(DamageEventStr, SourceEid, TargetEid, DelayPerformTime)
-- 	local DamageResult = {
-- 		SourceEid = SourceEid,
-- 		TargetEid = TargetEid,
-- 		DamageEvent = DamageEventStr,
-- 		DelayPerformTime = DelayPerformTime,
-- 	}
-- 	-- if DamageEvent.HitDirection and DamageEvent.HitPosition then
-- 	-- 	DamageResult.HitDirection = {
-- 	-- 		x = DamageEvent.HitDirection.x,
-- 	-- 		y = DamageEvent.HitDirection.y,
-- 	-- 		z = DamageEvent.HitDirection.z,
-- 	-- 	}
-- 	-- 	DamageResult.HitPosition = {
-- 	-- 		x = DamageEvent.HitPosition.x,
-- 	-- 		y = DamageEvent.HitPosition.y,
-- 	-- 		z = DamageEvent.HitPosition.z,
-- 	-- 	}
-- 	-- end

-- 	-- PrintTable({DamageResult=DamageResult},10)
-- 	self.Result:Add("Damage", DamageResult)
-- end

-- function Component:GetDamagePassiveOwner(Source)
-- 	if Source:IsSkillCreature() then
-- 		Source = Source:GetRootSource()
-- 	end

-- 	return Source
-- end

-- function Component:CheckDamagePassiveCanExecute(DamageEvent)
-- 	if DamageEvent.PassiveCanExecute ~= nil then
-- 		return
-- 	end

-- 	local PassiveCanExecute = false
-- 	local DamageValues = DamageEvent.DamageValues
-- 	for DamageType, DamageRate in pairs(DamageValues) do
-- 		local DamageTypeConfig = DataMgr.DamageType[DamageType]
-- 		if DamageTypeConfig and not DamageTypeConfig.DisablePassiveEffect then
-- 			PassiveCanExecute = true
-- 			break
-- 		end
-- 	end

-- 	DamageEvent.PassiveCanExecute = PassiveCanExecute
-- end

-- function Component:AddHealResult(HealEventStr, SourceEid, TargetEid)
-- 	local HealResult = {
-- 		SourceEid = SourceEid,
-- 		TargetEid = TargetEid,
-- 		HealEvent = HealEventStr,
-- 	}

-- 	self.Result:Add("Heal", HealResult)
-- end

-- function Component:CutDownBreakCount(SourceEid, TargetEid, SkillId)
-- 	if not self:CanExecute() then
-- 		return
-- 	end

-- 	local Target = self:GetEntity(TargetEid)
-- 	local Source = self:GetEntity(SourceEid)
-- 	local DanmakuCreature = nil
-- 	if not Target then
-- 		DanmakuCreature = self:GetDanmakuCreatureById(TargetEid)
-- 		if DanmakuCreature then
-- 			self:CutDownDanmakuBreakCount(DanmakuCreature, SourceEid, SkillId)
-- 		end
-- 		return
-- 	end

-- 	if Target:IsInvincible(Source) or Target:IsDead() then
-- 		return
-- 	end

-- 	local BreakCount = Target:GetAttr("BreakCount")

-- 	if BreakCount == 0 then 
-- 		return 
-- 	end

-- 	BreakCount = BreakCount - 1
-- 	self:TriggerBattleEvent(BattleEventName.BreakCountDown, Source, nil, TargetEid)
-- 	Target:SetAttr("BreakCount", BreakCount)
--     Target:OnBreakCountDown()
-- 	if BreakCount == 0 then
-- 		self:BattleOnDead(Target.Eid, SourceEid, SkillId, EDeathReason.HitBreak)
-- 	end
-- end

-- function Component:CutDownDanmakuBreakCount(DanmakuCreature, SourceEid, SkillId)
-- 	local BreakCount = DanmakuCreature.BreakCount
-- 	local Source = self:GetEntity(SourceEid)

-- 	if DanmakuCreature:IsDead() then
-- 		return
-- 	end
	
-- 	if BreakCount == 0 then return end

-- 	BreakCount = BreakCount - 1
-- 	self:TriggerBattleEvent(BattleEventName.BreakCountDown, Source, nil, DanmakuCreature.Eid)
-- 	DanmakuCreature.BreakCount = BreakCount
-- 	DanmakuCreature:OnBreakCountDown()
-- 	if BreakCount <= 0 then
-- 		DanmakuCreature:OnCreatureDead(SourceEid, SkillId, EDeathReason.DanmakuHitDestroy)
-- 		self:BattleOnDead(DanmakuCreature.Eid, SourceEid, SkillId, EDeathReason.DanmakuHitDestroy)
-- 	end
-- end

return Component


local Component = Class("BluePrints.Combat.BattleEvents.BaseEvent")

function Component:ReceiveBeginPlay()
	self.Overridden.ReceiveBeginPlay(self)
end

-- function Component:ApplyHatred(_, DamageEvent, Source, Target)
-- 	if not IsValid(Source) or not IsValid(Target) then
-- 		return
-- 	end
-- 	if not Target:IsAIControlled() then
-- 		return
-- 	end
-- 	local HatredIncrement = self:GetHatred(DamageEvent)
-- 	local HatredDefault = self:GetHatredDefault(Source, Target) + HatredIncrement
-- 	if Source:IsSummonMonster() then
-- 		local Parent
-- 		Source, Parent = Source:GetJoinHatredListSource()
-- 		if Source then
-- 			self:AddHatredTarget(Source, Target, HatredDefault, HatredIncrement)
-- 		end
-- 		if Parent then
-- 			self:AddHatredTarget(Parent, Target, HatredDefault, HatredIncrement)
-- 		end
-- 	elseif Target:GetAlertState_Lua() == Const.NormalState then
-- 		local DirectSource = Source:GetDirectSource()
-- 		local RealSource = DirectSource or Source
-- 		Target:AddTargetAlerted(RealSource.Eid)
-- 		if not Target:TrySetCommonAlertingInfo(0) then
-- 			self:AddHatredTarget(RealSource, Target, HatredDefault, HatredIncrement)
-- 		end
-- 	else
-- 		local DirectSource = Source:GetDirectSource()
-- 		local RealSource = DirectSource or Source
-- 		self:AddHatredTarget(RealSource, Target, HatredDefault, HatredIncrement)
-- 	end
-- 	--print(_G.LogTag,"AddHatredTarget" ,  Source.CreatureId)
-- end

-- function Component:AddHatredOnNormalState(Source, Target, HatredDefault, HatredIncrement)
-- 	local DirectSource = Source:GetDirectSource()
-- 	local RealSource = DirectSource or Source
-- 	Target:AddTargetAlerted(RealSource.Eid)
-- 	if Target.MonAlertComponent and not Target.MonAlertComponent:TrySetCommonAlertingInfo(0) then
-- 		self:AddHatredTarget(RealSource, Target, HatredDefault, HatredIncrement)
-- 	end
-- end

-- function Component:AddHatredOnOthers(Source, Target, HatredDefault, HatredIncrement)
-- 	local DirectSource = Source:GetDirectSource()
-- 	local RealSource = DirectSource or Source
-- 	self:AddHatredTarget(RealSource, Target, HatredDefault, HatredIncrement)
-- end

-- function Component:AddHatredTarget(Source, Target, HatredDefault, HatredIncrement)
-- 	if Target.MonAlertComponent and  Target.MonAlertComponent:GetAlertState() == Const.EndBattleState then
-- 		return
-- 	end
-- 	if Target:IsEnemyOrNeutral(Source) then
-- 		--print(_G.LogTag,"AddHatredTarget" ,  SkillNode.NodeId)
-- 		Target:AddHatredTarget(Source.Eid, HatredDefault, HatredIncrement)
-- 	end
-- end

-- function Component:GetHatred(DamageEvent)
-- 	local Source, Skill, SkillEffects
-- 	if DamageEvent then
-- 		Source = self.Battle:GetEntity(DamageEvent.SourceEid)
-- 		Skill = DamageEvent.Skill
-- 		if DamageEvent.SourceBuff then
-- 			SkillEffects = DamageEvent.SourceBuff.BuffConfig
-- 		end
-- 		if DamageEvent.SourceEffect then
-- 			SkillEffects = DataMgr.SkillEffects[DamageEvent.SourceEffect.EffectId]
-- 		end
-- 	end

-- 	if not SkillEffects or not Skill then
-- 		return 0
-- 	end
	
-- 	local HatredIncrement = SkillEffects["HatredIncrement"]
-- 	if not HatredIncrement then
-- 		return 0
-- 	end
-- 	local TargetHatred = Skill.HatredAll:Find(DamageEvent.TargetEid)
-- 	if TargetHatred == nil then
-- 		Skill.HatredAll:Add(DamageEvent.TargetEid, 0)
-- 		TargetHatred = Skill.HatredAll:Find(DamageEvent.TargetEid)
-- 	end

-- 	local Player = Source.GetDirectSource and Source:GetDirectSource() or Source
-- 	local HatredRate = Player:GetAttr("HatredRate") or 0
-- 	HatredIncrement = HatredIncrement * (1+HatredRate)
-- 	--print(_G.LogTag,  HatredIncrement, Player:GetAttr("HatredRate"))
-- 	if not Skill.MaxHatred then
-- 		return HatredIncrement
-- 	end
-- 	if TargetHatred >= Skill.MaxHatred then
-- 		HatredIncrement = 0
-- 	end

-- 	Skill.HatredAll:Add(DamageEvent.TargetEid, TargetHatred + HatredIncrement)
	
-- 	return HatredIncrement
-- end

-- function Component:GetHatredDefault(Source, Target)
-- 	--参数来自伤害事件，Source是造成仇恨的，Target才是记录仇恨的
-- 	if not Target.GetPresetHatredValue then
-- 		return 0
-- 	end
-- 	local HatredDefault = Target:GetPresetHatredValue(Source, "ReasonDamage")
-- 	return HatredDefault
-- end

return Component
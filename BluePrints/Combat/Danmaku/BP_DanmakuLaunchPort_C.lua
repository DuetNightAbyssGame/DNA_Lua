
---@type BP_DanmakuLaunchPort_C
local BP_DanmakuLaunchPort_C = Class()

-- function BP_DanmakuLaunchPort_C:Initialize(Initializer)
-- end

--function BP_DanmakuLaunchPort_C:ReceiveBeginPlay()
--	self.Owner = self:GetOwner()
--	self.Battle = Battle(self)
--	self.Owner:AddLaunchPort(self)
--end

--function BP_DanmakuLaunchPort_C:Fire()
--	if not self.Character then
--        self.Character = self.Owner.Character
--    end
--	
--	local PortInfo = {
--		Source = self.Character,
--		CreatureId = self:GetCreatureId(self),
--		BornLocation = self:K2_GetComponentLocation(),
--		Skill = self.Owner.Skill,
--		SkillLevelSource = self.Owner.SkillLevelSource,
--		Port = self
--	}
--	
--	local CreatureInfo = DataMgr.DanmakuCreature[PortInfo.CreatureId]
--	if CreatureInfo then
--		local Now = self.Owner.DanmakuFireTime
--		local ExpectTime = self.Owner.Interval * (self.Owner.FireTime - 1)
--		local CompensateTime = Now - ExpectTime
--		local CompensateLocation = self:GetForwardVector() * (CreatureInfo.Speed * CompensateTime)
--		PortInfo.BornLocation = PortInfo.BornLocation + CompensateLocation
--	end
--	
--	PortInfo.TargetLocation = PortInfo.BornLocation + self:GetForwardVector() * 100
--	self.Owner:CreateDanmakuCreature(PortInfo)
--end

--function BP_DanmakuLaunchPort_C:GetCreatureId()
--	if self.Owner then
--		local TemplateId = self.Owner.DanmakuTemplateId
--		local TemplateInfo = DataMgr.DanmakuTemplate[TemplateId]
--		if TemplateInfo.UseDanmakuCreature then
--			local OwnerInstance = self.Owner:GetPortOwnerInstance(self)
--			local DanmakuCreatureId = OwnerInstance.CreatureId
--			return DanmakuCreatureId
--		end
--	end
--
--	return self.CreatureId
--end

return BP_DanmakuLaunchPort_C

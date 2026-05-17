
local Component = {}

--function Component:CreateLaser(LaserParent, NiagaraParticle, LaserInfo)
--	self.LaserPortUniqueId = (self.LaserPortUniqueId or 0) + 1
--	local LaserPortClass = UE4.UClass.Load('/Game/BluePrints/Combat/Skill/BP_LaserPort.BP_LaserPort')
--	local LaserPort = NewObject(LaserPortClass)
--
--	-- 如果LaserInfo中的LastTime小于0，表示想永久持续
--	local LastTime = LaserInfo.LastTime
--	if not LastTime then
--		assert(nil, "【" .. UE4.UKismetSystemLibrary.GetDisplayName(LaserParent) .. "】发射的激光射线持续时间填写有误")
--	end
--	
--	LaserPort.UniqueId = self.LaserPortUniqueId
--	self:AddLaserPort(LaserPort.UniqueId, LaserPort)
--
--	LaserPort:StartFire(self.LaserPortUniqueId, LaserParent, NiagaraParticle, LaserInfo)
--
--	return LaserPort
--end

return Component

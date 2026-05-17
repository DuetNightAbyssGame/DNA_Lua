
---@type BP_DanmakuTemplate_C
local BP_DanmakuTemplate_C = Class("BluePrints.Common.TimerMgr")

-- function BP_DanmakuTemplate_C:Initialize(Initializer)
-- end

function BP_DanmakuTemplate_C:ReceiveBeginPlay()
	if self.BpBorn or not IsAuthority(Battle(self)) then
		self.Overridden.ReceiveBeginPlay(self)
	end
	-- self.bIsDanmakuTemplate = true
	-- self.InitSuccess = true
	-- Battle(self):RegisterDanmakuTemplate(self)
end

function BP_DanmakuTemplate_C:InitDanmakuInfo()
	self.Overridden.ReceiveBeginPlay(self)
end

function BP_DanmakuTemplate_C:InitVars()
	local CreatureInfo = DataMgr.DanmakuTemplate[self.DanmakuTemplateId]
	if CreatureInfo and CreatureInfo.Vars then
		for VarName, Value in pairs(CreatureInfo.Vars) do
			self[VarName] = Value
		end
	end
end

-- 弹幕开始发射
--function BP_DanmakuTemplate_C:StartFire(Duration)
--	local Now  = UE4.UGameplayStatics.GetTimeSeconds(self)
--	-- PrintTable({StartFire = Now, Duration = Duration, Interval = self.Interval})
--	assert(self.Interval > 0, "弹幕模板的发射间隔Interval【" .. tostring(self.Interval) .. "】填写有误")
--	if self.InFire then
--		self:StopFire()
--	end
--
--	self.CustomTimeDilation = self.Character.CustomTimeDilation
--	self.Duration = Duration
--	self.FireTime = 0
--	self.InFire = true
--	self.StartTime =  UE4.UGameplayStatics.GetTimeSeconds(self)
--
--	self.Overridden.OnStartFire(self, Duration)
--
--	--self:DanmakuFire()
--	
--	self.NormalizedIntervalRemain = self.Interval
--	self.NormalizedStopRemain = self.Duration
--	self.bStartTimer = true
--	self.FireTimer = self:AddTimer(self.Interval / self.CustomTimeDilation, self.DanmakuFire, true)
--	self.StopFireTimer = self:AddTimer(self.Duration / self.CustomTimeDilation, self.ReadyToStopFire)
--end

-- -- 获取发射口列表
-- function BP_DanmakuTemplate_C:GetFirePorts(FireTime)
-- 	return self.Overridden.GetFirePorts(self, FireTime)
-- end

-- 弹幕发射一次
--function BP_DanmakuTemplate_C:DanmakuFire()
--	if not IsValid(self.Character) or self.Character:IsDead() then
--		self:StopFire()
--		return
--	end
--	
--	if self.bReadyToStop then
--		return
--	end
--	
--	local Now = UE4.UGameplayStatics.GetTimeSeconds(self)
--	self.FireTime = self.FireTime + 1
--	if not self.DanmakuFireBeginTime then
--		self.DanmakuFireBeginTime = Now
--	end
--	
--	self.DanmakuFireTime = Now - self.DanmakuFireBeginTime 
--	self.Overridden.DanmakuFire(self)
--end

-- 停止发射
--function BP_DanmakuTemplate_C:StopFire()
--	local Now  = UE4.UGameplayStatics.GetTimeSeconds(self)
--	-- PrintTable({StopFire=Now})
--	self:RemoveTimer(self.FireTimer)
--	self:RemoveTimer(self.StopFireTimer)
--	self.InFire = false
--	self.FireTimer = nil
--	self.StopFireTimer = nil
--
--	self.Overridden.OnStopFire(self)
--
--	self:K2_DestroyActor()
--end

--function BP_DanmakuTemplate_C:Destroy()
--	Battle(self):UnregisterDanmakuTemplate(self)
--	self:StopFire()
--end

--function BP_DanmakuTemplate_C:SetDanmakuDilation(Dilation)
--	if Dilation == self.CustomTimeDilation then
--		return
--	end
--	
--	local OldDilation = self.CustomTimeDilation 
--	self.CustomTimeDilation = Dilation
--	if self.FireTimer then
--		local RemainingTime = self:GetTimerRemainingTime(self.FireTimer)
--		if OldDilation ~= 0 then
--			self.NormalizedIntervalRemain = RemainingTime * OldDilation
--		end
--		self:RemoveTimer(self.FireTimer)
--		self.FireTimer = self:AddTimer(self.Interval / self.CustomTimeDilation, self.DanmakuFire, true, 
--			self.NormalizedIntervalRemain / self.CustomTimeDilation)
--	end
--	
--	if self.StopFireTimer then
--		local RemainingTime = self:GetTimerRemainingTime(self.StopFireTimer)
--		if OldDilation ~= 0 then
--			self.NormalizedStopRemain = RemainingTime * OldDilation 			
--		end
--		self:RemoveTimer(self.StopFireTimer)
--		self.StopFireTimer = self:AddTimer(self.NormalizedStopRemain / self.CustomTimeDilation, self.ReadyToStopFire)
--	end
--end

--function BP_DanmakuTemplate_C:AddDanmakuCreature(DanmakuCreature)
--	self.Overridden.AddDanmakuCreature(self, DanmakuCreature)
--	Battle(self):AddDanmakuCreature(DanmakuCreature.Eid, DanmakuCreature)
--end

function BP_DanmakuTemplate_C:RemoveDanmakuCreature_Lua(Eid)
	Battle(self):RemoveDanmakuCreature(Eid)
end

-- function BP_DanmakuTemplate_C:ReceiveTick(DeltaSeconds)
-- 	-- PrintTable({Transforms=1})
-- 	local Transforms = TArray(Transform)
-- 	for UniqueId,DanmakuCreature in pairs(self.DanmakuCreatures) do
-- 		-- DanmakuCreature:Tick(DeltaSeconds)
-- 		local Transform = DanmakuCreature:K2_GetComponentToWorld()
-- 		Transforms:Add(Transform)
-- 	end

-- 	if self.DanmakuInstanced then
-- 		self.DanmakuInstanced:BatchUpdateInstancesTransforms(0, Transforms, true, true, true)
-- 	end
-- end

--function BP_DanmakuTemplate_C:CreateDanmakuCreature(PortInfo)
--	if not self:HasCreature() then
--		return
--	end
--	
--	self.DanmakuData = self.DanmakuData or DataMgr.DanmakuTemplate[self.DanmakuTemplateId]
--	
--	if self.DanmakuData.UseDanmakuCreature then
--		local DanmakuCreatureId = PortInfo.CreatureId
--		local DanmakuCreatureDataInfo = DataMgr.DanmakuCreature[DanmakuCreatureId]
--		if DanmakuCreatureDataInfo then
--			local DanmakuCreaturePath = DanmakuCreatureDataInfo.BPPath
--			local DanmakuCreatureClass = UE4.UClass.Load(DanmakuCreaturePath)
--			local DanmakuCreature = NewObject(DanmakuCreatureClass, self)
--
--			DanmakuCreature.CreatureId = DanmakuCreatureId
--			DanmakuCreature.LaunchPort = PortInfo.Port
--			DanmakuCreature:K2_SetWorldLocation(PortInfo.BornLocation, false, nil, false)
--			self:RotateToTarget(DanmakuCreature, PortInfo.TargetLocation, PortInfo.BornLocation)
--			self:AddDanmakuCreature(DanmakuCreature)
--		end
--	else
--		-- DebugPrint("gmy@CreateSkillCreature(Old)", PortInfo.CreatureId)
--		Battle(self):CreateSkillCreature(PortInfo)
--	end
--end

--function BP_DanmakuTemplate_C:RotateToTarget(DanmakuCreature, TargetLoc, BornLocation)
--	-- 做最终的转向，目的是形成散射，目标是方向上50m的圆环
--	local UpVector = FVector(0, 0, 1)
--	local Forward = TargetLoc - BornLocation
--	Forward:Normalize()
--	local Rotation = UFormulaFunctionLibrary.FRotateMakeFromXZ(Forward, UpVector)
--	DanmakuCreature:K2_SetWorldRotation(Rotation, false, nil, false)
--end

--function BP_DanmakuTemplate_C:OnDanmakuCreatureOverlapBegin(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex, bFromSweep, SweepResult)
--	OverlappedComponent:Destroy()
--end

--function BP_DanmakuTemplate_C:GetCreatureId(DanmakuPortInfo)
--	return DanmakuPortInfo and DanmakuPortInfo.CreatureId or 0
--end

--function BP_DanmakuTemplate_C:ReadyToStopFire()
--	-- 等一个(发射间隔+生命周期)的时间后，销毁模板本身
--	self.bReadyToStop = true
--
--	local CreatureDuration = 0
--	if self:HasCreature() then
--		self.DanmakuData = self.DanmakuData or DataMgr.DanmakuTemplate[self.DanmakuTemplateId]
--
--		for LaunchPortId, Port in pairs(self.LaunchPorts) do
--			local SkillCreatureId = Port:GetCreatureId()
--			if self.DanmakuData.UseDanmakuCreature then
--				CreatureDuration = math.max(CreatureDuration, DataMgr.DanmakuCreature[SkillCreatureId].TimeLife or 0)
--			else
--				CreatureDuration = math.max(CreatureDuration, DataMgr.SkillCreature[SkillCreatureId].TimeLife or 0)
--			end
--		end
--	end
--	
--	local DestroyDelayTime = self.Interval + CreatureDuration
--	self.DestroySelfTimer = self:AddTimer(DestroyDelayTime / self.CustomTimeDilation, self.Destroy)
--end

-- 有的弹幕模板并不会产生弹幕生物 (比如：弹幕模板用来发射激光)
--function BP_DanmakuTemplate_C:HasCreature()
--	return self.bHasAnyCreature and true
--end

return BP_DanmakuTemplate_C

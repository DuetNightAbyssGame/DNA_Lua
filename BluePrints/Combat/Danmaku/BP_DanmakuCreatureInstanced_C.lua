--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
-- require "UnLua"
---@type BP_DanmakuCreature_C
local BP_DanmakuCreature_C = Class()

-- function BP_DanmakuCreature_C:Initialize(Initializer)
-- end

function BP_DanmakuCreature_C:ReceiveBeginPlay()
	-- PrintTable({ReceiveBeginPlay=1})
	-- self.FxObject = self:GetOwner().FXComponent:PlayEffectByIDParams(850007, {Component = self})
end

-- function BP_DanmakuCreature_C:ReceiveEndPlay()
-- end



-- function BP_DanmakuCreature_C:Tick(DeltaSeconds)
-- 	-- PrintTable({Tick=1})
-- 	local Location = self:K2_GetComponentLocation()
-- 	-- PrintTable({TT=Location})
-- 	Location = Location + self:GetForwardVector() * 200 * DeltaSeconds
-- 	self:K2_SetWorldLocation(Location, false, nil, false)
-- end


function BP_DanmakuCreature_C:Destroy()
	-- PrintTable({Destroy=self})
	-- self.FxObject:Deactivate()
	self:K2_DestroyComponent(self)

	-- if self:GetOwner() and self:GetOwner().DanmakuInstanced then
	-- 	self:GetOwner().DanmakuInstanced:RemoveInstance(0)
	-- end
end


return BP_DanmakuCreature_C

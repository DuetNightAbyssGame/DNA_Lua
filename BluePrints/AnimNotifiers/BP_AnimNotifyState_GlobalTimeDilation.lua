--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_AnimNotifyState_GlobalTimeDilation_C
local M = Class({"BluePrints.Common.TimerMgr"})

-- function M:Received_NotifyBegin(MeshComp, Animation, TotalDuration)
-- end

-- function M:Received_NotifyTick(MeshComp, Animation, FrameDeltaTime)
-- end

-- function M:Received_NotifyEnd(MeshComp, Animation)
-- end

function M:Begin(Character)
	if self.TimerHandle then
		GWorld.GameInstance:RemoveTimer(self.TimerHandle)
		self.TimerHandle = nil
	end
	local function Callback()
		self.TimerHandle = nil
		self.Overridden.Begin(self, Character)
		self.HasStarted = true
	end
	self.TimerHandle = GWorld.GameInstance:AddTimer(0.0001, Callback, false, 0, nil, true)
end

function M:End(Character)
	if self.TimerHandle then
		GWorld.GameInstance:RemoveTimer(self.TimerHandle)
		self.TimerHandle = nil
	end
	if self.HasStarted then
		self.Overridden.End(self, Character)
		self.HasStarted = false
	end
end

return M
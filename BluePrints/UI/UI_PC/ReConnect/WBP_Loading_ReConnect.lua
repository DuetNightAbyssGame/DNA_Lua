require "UnLua"

---@type Loading_Reconnect_C
local M = Class("BluePrints.UI.BP_UIState_C")


function M:Construct()
end

function M:ExInit(...)
	self.bDisplayOnly,self.bAsChild = ...
	self:OnLoaded()
end


function M:OnLoaded(...)
	self.bDisplayOnly = ...
	if not self.bDisplayOnly then
		-- DebugPrint("gmy@WBP_Loading_ReConnect M:OnLoaded", debug.traceback())
		-- 主要更新逻辑应该在逻辑层，这个是保底措施
		local NetworkMgr = GWorld.NetworkMgr
		if NetworkMgr then
			NetworkMgr.bUIReConnecting = true
		end
	end
	self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
	--self:StopAnimation(self.Out)
	--self:PlayAnimation(self.In)
	self.Common_Loading_PC:PlayAnimationForward(self.Common_Loading_PC.In)
	self.Common_Loading_PC:PlayAnimation(self.Common_Loading_PC.Loop, 0, 0)
end

function M:Close()
	if not self.bDisplayOnly then
		-- DebugPrint("gmy@WBP_Loading_ReConnect M:Close", debug.traceback())
		local NetworkMgr = GWorld.NetworkMgr
		if NetworkMgr then
			NetworkMgr.bUIReConnecting = false
		end
	end

	if not self.bAsChild then
		self:RealClose()
	else
		self.Common_Loading_PC:StopAllAnimations()
		self:SetVisibility(UIConst.VisibilityOp.Collapsed)
		M.Super.Close()
	end
	--self:BindToAnimationFinished(self.Out, {self, self.RealClose})
	--self.Common_Loading_PC:PlayAnimationForward(self.Common_Loading_PC.Out)
	--self:PlayAnimationForward(self.Out)
end

return M

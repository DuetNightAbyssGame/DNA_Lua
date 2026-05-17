--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_RegionCaptureComponent_C
local BP_RegionCaptureComponent_C = Class()

--------------------GameMode 流程&事件相关------------------------
function BP_RegionCaptureComponent_C:InitRegionCaptureComponent()
	DebugPrint("RegionCaptureComponent: Init!")
	self.GameMode = self:GetOwner()
end


-----------------------------------------------------------------

return BP_RegionCaptureComponent_C

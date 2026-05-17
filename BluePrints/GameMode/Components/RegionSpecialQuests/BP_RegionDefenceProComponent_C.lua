require "UnLua"

local BP_RegionDefenceProComponent_C = Class({
	"BluePrints.Common.TimerMgr",
})

--------------------GameMode 流程&事件相关------------------------
function BP_RegionDefenceProComponent_C:InitRegionDefenceProComponent()
	DebugPrint("RegionDefenceProComponent: Init!")
	self.GameMode = self:GetOwner()
end


-----------------------------------------------------------------
return BP_RegionDefenceProComponent_C


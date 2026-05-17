require "UnLua"

local BP_ExterminateComponent_C = Class({
	"BluePrints.GameMode.DungeonComponents.BP_ExterminateBaseComponent_C",
})

function BP_ExterminateComponent_C:InitExterminateComponent()
	-- 先这么写，如果歼灭和歼灭pro区别很大，就单独写初始化逻辑，不写父类里了
	self:InitExterminateBaseComponent()

end

function BP_ExterminateComponent_C:InitExterminateBaseInfo()
	self:InitGuideUpdateTimerLogic()
end

function BP_ExterminateComponent_C:GetDataMgrInfo()
	return DataMgr.Exterminate[self.GameMode.DungeonId]
end


return BP_ExterminateComponent_C
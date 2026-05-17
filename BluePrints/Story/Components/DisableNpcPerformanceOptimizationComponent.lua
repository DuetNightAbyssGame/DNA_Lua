---@class FDisableNpcPerformanceOptimizationComponent
local FDisableNpcPerformanceOptimizationComponent = {}

---@return FDisableNpcPerformanceOptimizationComponent
function FDisableNpcPerformanceOptimizationComponent:New()
	local DisableNpcPerformanceOptimizationComponent = setmetatable({}, {
		__index = FDisableNpcPerformanceOptimizationComponent
	})
	return DisableNpcPerformanceOptimizationComponent 
end

function FDisableNpcPerformanceOptimizationComponent:Execute()
	-- 关 NPC显隐优化
	local UnitBudgetMgr = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UE4.UUnitBudgetAllocatorSubsystem)
	DebugPrint("Talk:关闭Npc优化", UnitBudgetMgr)
	if UnitBudgetMgr then
		UnitBudgetMgr:ShowAllNpcEnable(true)
	end
end

function FDisableNpcPerformanceOptimizationComponent:Resume()
	local UnitBudgetMgr = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UE4.UUnitBudgetAllocatorSubsystem)
	DebugPrint("Talk:恢复Npc优化", UnitBudgetMgr)
	if UnitBudgetMgr then
		UnitBudgetMgr:ShowAllNpcEnable(false)
	end
end

return FDisableNpcPerformanceOptimizationComponent

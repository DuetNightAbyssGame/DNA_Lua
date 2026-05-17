
---@type BP_BuffManager_C
local BuffsChanged = {}

-- 覆盖C++的BuffsChanged实现，要求：
-- 1. 表头名称写在Return中
-- 2. BuffsChanged.lua中包含方法: function BuffsChanged:OnBuffsChanged_XXXLockHp(AllInfos)
-- AllInfos是一个Array，每一项为 {BuffID， Buff对应的Buff表数据}
-- 3. 如果需要调用回C++的实现: self:CallOnBuffsChangedDirectly("XXX")
function BuffsChanged:GetOverrideProperties()
	return {
	}
end


return BuffsChanged
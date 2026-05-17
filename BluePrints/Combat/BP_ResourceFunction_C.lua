
require "UnLua"

local BP_ResourceFunction_C = Class()

function BP_ResourceFunction_C:InitVars(ResourceId)
	DebugPrint("gmy@InitVars", ResourceId)
	if ResourceId then
		local ResourceConfig = DataMgr.Resource[ResourceId]
		if ResourceConfig and ResourceConfig.FunctionVars then
			for Key, Value in pairs(ResourceConfig.FunctionVars) do
				self[Key] = Value
			end
		end
	end
end

function BP_ResourceFunction_C:UpdateInBattleWheelPropUseData(UseResourceId, ForceSetUsing)
	if not UseResourceId then return end
	local InBattleWheelMenuModel = require "BluePrints.UI.WBP.Battle.Widget.Battle_Menu.InBattleWheelMenuModel"
	InBattleWheelMenuModel:UpdateInBattleWheelPropUseData(UseResourceId, ForceSetUsing)
end

return BP_ResourceFunction_C

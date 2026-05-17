--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_GlobalFunctionLibrary_C = Class()

function BP_GlobalFunctionLibrary_C:Initialize(Initializer)
	print("function library construct")
end

--function BP_GlobalFunctionLibrary_C:UserConstructionScript()
--	print("function library construct")
--end

function BP_GlobalFunctionLibrary_C:IsRunningOnMobile()
	return true
end

return BP_GlobalFunctionLibrary_C
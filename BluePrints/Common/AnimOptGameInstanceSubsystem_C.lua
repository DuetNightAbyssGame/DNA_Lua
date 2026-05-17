require "Unlua"
require "Const"

local M = Class()

function M:Initialize_Lua()
-- 	self.SystemEnableState = 1 -- 2:Custom 1: GlobalEnable, 0: Forbidden
	self.CacheFrameDeltaSeconds = 0.033333 -- 30 FPS
	self.bDebugBonesTrans = false
	self.bDebugCachedTrans = false
	self.DebugCacheTransType = 4
	self.BodyFilterBoneName = "Spine_02"
	-- self.bGlobalEnableAnimCache = false
	self.InitialMeshTickInterval = 0.05

	local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
	if string.lower(PlatformName) == CommonConst.CHANNEL_OS.ANDROID or string.lower(PlatformName) == CommonConst.CHANNEL_OS.IOS then
		UE4.URuntimeCommonFunctionLibrary.EnableGlobalAnimCache(self, true);
	end
end

function M:AnimCachePhysErrorReset_Lua(MeshComp)
	if MeshComp then
		local Mon = MeshComp:GetOwner()
		if Mon and Mon.PhysStateErrorReset_Lua then
			Mon:PhysStateErrorReset_Lua()
		end
	end
end

return M


local BP_PassiveEffectClient_C = Class("BluePrints.Common.TimerMgr")

function BP_PassiveEffectClient_C:ReceiveBeginPlay()
	-- PrintTable({CZC_ReceiveBeginPlay={self,CZC_=IsAuthority(self)}},2)
	-- self.Overridden.ReceiveBeginPlay(self)
	if not self.Owner or not self.Owner.InitSuccess then
		self.InitTimerHandle = self:AddTimer(0.1, self.TryInit, true)
		return
	end

	self:Init()
end

function BP_PassiveEffectClient_C:TryInit()
	-- PrintTable({CZC_TryInit={self,CZC_=IsAuthority(self)}},2)
	if not self.Owner or not self.Owner.InitSuccess then
		return
	end

	self:Init()
end

function BP_PassiveEffectClient_C:Init()
	-- PrintTable({CZC_Init={self,CZC_=IsAuthority(self)}},2)
	self.PassiveOwner = self.Owner
	self.PassiveOwner.PassiveEffectClient = self

	self.Overridden.ReceiveBeginPlay(self)

	self:RemoveTimer(self.InitTimerHandle)
    self.InitTimerHandle = nil
end

return BP_PassiveEffectClient_C

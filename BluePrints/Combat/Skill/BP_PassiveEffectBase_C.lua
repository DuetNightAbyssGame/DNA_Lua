
require "UnLua"

local BP_PassiveEffectBase_C = Class({
	"BluePrints.Combat.Components.SkillLevelInterface",
	"BluePrints.Common.TimerMgr",
})

--function BP_PassiveEffectBase_C:Initialize(Initializer)
--end

--function BP_PassiveEffectBase_C:UserConstructionScript()
--end

function BP_PassiveEffectBase_C:ReceiveBeginPlay()
	-- self.Overridden.ReceiveBeginPlay(self)
	rawset(self, "BattleEvent", self.BattleEvent)
end

-- 这里就是这样，等PassiveOwner有了之后再走初始化
function BP_PassiveEffectBase_C:SetPassiveOwner(PassiveOwner)
	self.SavedPassiveOwner = PassiveOwner
	self:CheckInitSuccess()
end

-- 角色初始化的时候，再让未初始化成功的被动成功初始化
function BP_PassiveEffectBase_C:SetPassiveEffectsReady()
	self:RemoveTimer(self.InitHandle)
	self:CheckInitSuccess()
end

--function BP_PassiveEffectBase_C:ReceiveEndPlay()
--end

function BP_PassiveEffectBase_C:CheckInitSuccess()
	if not IsValid(self.SavedPassiveOwner) then
		return
	end
	if not self.SavedPassiveOwner.InitSuccess then
		return
	end
	if not self.InitSuccess then
		self.PassiveOwner = self.SavedPassiveOwner
		self.Overridden.ReceiveBeginPlay(self)
		self.InitSuccess = true
		self:RemoveTimer(self.InitHandle)
	end
end

--function BP_PassiveEffectBase_C:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function BP_PassiveEffectBase_C:ReceiveActorBeginOverlap(OtherActor)
--end

--function BP_PassiveEffectBase_C:ReceiveActorEndOverlap(OtherActor)
--end

function BP_PassiveEffectBase_C:Destroy()
	self:RemoveTimer(self.InitHandle)
	self:K2_DestroyActor()
end

return BP_PassiveEffectBase_C

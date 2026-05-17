require "UnLua"
local EffectResults = require "BluePrints.Combat.BattleLogic.EffectResults"

---@type BP_MonWeaponBase_C
local BP_MonWeaponBase_C = Class({
	"BluePrints.Combat.Weapons.BP_WeaponBase_C",
})

-- 从缓存出来时初始化
function BP_MonWeaponBase_C:InitFromCache()
	
end

-- 第一次创建时初始化
-- function BP_MonWeaponBase_C:InitWeaponInfo(WeaponId, IsChild, ReplaceAttrs, SkillInfos,WeaponInfo)
-- 	if self.Owner:IsPhantom() then
-- 		BP_MonWeaponBase_C.Super.InitWeaponInfo(self, WeaponId, IsChild, ReplaceAttrs, SkillInfos,WeaponInfo)
-- 		return
-- 	end
-- 	self.ReplaceAttrs = ReplaceAttrs
-- 	self.SkillInfos = SkillInfos
--     self:InitMonWeaponInfoImpl(WeaponId, IsChild)

-- end


--activate as UsingWeapon
-- function BP_MonWeaponBase_C:OnEnter(Owner)
-- 	if not self.Owner and IsValid(Owner) then
-- 		self.Owner = Owner
-- 	end
-- 	if self.Owner:IsPhantom() then
-- 		BP_MonWeaponBase_C.Super.OnEnter(self)
-- 		return
-- 	end


-- 	if not self.InitSuccess then
-- 		return
-- 	end
-- 	if self.InHand then
-- 		return
-- 	end
-- 	self.InHand = true

-- 	-- self:ShouldHideWeapon(false, OnwerInAmory)
-- 	self:ActivateSkills()
-- 	for i = 1, self.Accessories:Length() do
-- 		self.Accessories:GetRef(i):OnEnter()
-- 	end
-- end

-- function BP_MonWeaponBase_C:BindWeaponToHand()
-- 	if self.Owner:IsPhantom() then
-- 		BP_MonWeaponBase_C.Super.BindWeaponToHand(self)
-- 		return
-- 	end


-- 	if not self.InitSuccess then
-- 		return
-- 	end
-- 	if self.BindToCreature then
-- 		return
-- 	end
-- 	self.BindToHand = true
-- 	-- self:SetActorHideTag("Unbind", false)
-- 	-- self:SetActorHideTag('Weapon', false)
-- 	local HandHoldSocket = self.Data.WeaponSockets["HandHold"]
-- 	local AttachSocket = HandHoldSocket["SocketB"]
-- 	local InverseSocket = HandHoldSocket["SocketA"]
-- 	--  self.WeaponFashion:WeaponDisappear()
-- 	self:WeaponEffectCheck("Bind")
-- 	self:K2_AttachToComponent(self.Owner.Mesh, AttachSocket, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.KeepWorld)
-- 	-- self:_InverseWeaponPosition(InverseSocket)
-- 	-- self:WeaponMoveToHand()

-- 	if self.ChildWeapon then
-- 		self.ChildWeapon:BindWeaponToHand()
-- 	end
-- 	for i = 1, self.Accessories:Length() do
-- 		if self.Accessories:GetRef(i) then 
-- 			self.Accessories:GetRef(i):WhenWeaponBindToHand()
-- 		end
-- 	end
-- end



AssembleComponents(BP_MonWeaponBase_C)
return BP_MonWeaponBase_C

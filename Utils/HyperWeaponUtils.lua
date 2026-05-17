
require "UnLua"

local HyperWeaponUtils = {}

-- @param WeaponId number 武器Id
-- @return bool 是否是灵化武器
HyperWeaponUtils.IsHyperWeapon = function(WeaponId)
	local WeaponInfo = DataMgr.Weapon[WeaponId]
	if not WeaponInfo then return false end
	local WeaponSubType = WeaponInfo.WeaponSubType
	return WeaponSubType == CommonConst.WeaponSubType.Hyper
end

-- @param HyperWeaponUid string 灵化武器Uid
-- @param HyperWeaponSkillId number 灵化武器技能Id
-- @return bool 对应灵化武器天赋技能是否已激活
HyperWeaponUtils.IsHyperWeaponSkillActivated = function(HyperWeaponUid, HyperWeaponSkillId)
	local Avatar = GWorld:GetAvatar()
    if not Avatar then return false end
	local ServerWeapon = Avatar and Avatar.Weapons[HyperWeaponUid]
	if not (ServerWeapon and ServerWeapon.WeaponId and HyperWeaponUtils.IsHyperWeapon(ServerWeapon.WeaponId)) then
        return false
	end
	local TargetHyperWeaponSkillInfo = DataMgr.HyperWeaponSkillTree[HyperWeaponSkillId]
	if not TargetHyperWeaponSkillInfo or TargetHyperWeaponSkillInfo.WeaponId ~= ServerWeapon.WeaponId then return false end
	local TargetCardLevel = TargetHyperWeaponSkillInfo.WeaponCardLevel
	if not TargetCardLevel then return false end
	local HyperTalent = ServerWeapon and ServerWeapon.HyperTalent or -1
	if HyperTalent == -1 then return false end
	local TargetLevelTalentInfo = HyperTalent[TargetCardLevel]
	if not TargetLevelTalentInfo or not TargetLevelTalentInfo[HyperWeaponSkillId] then return false end
	return true
end

return HyperWeaponUtils

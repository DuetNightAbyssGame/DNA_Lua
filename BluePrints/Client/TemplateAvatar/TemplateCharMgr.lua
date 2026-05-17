local CommonUtils = require "Utils.CommonUtils"
local Component = {}
local TemplateDumpUtils = require"BluePrints.Client.TemplateDumpUtils"
function Component:GMAddChar(CharId, Level, Reason, NotLog, NeedEnhance)
	local info = DataMgr.Char[CharId] or DataMgr.BattleChar[CharId]
	if not info or info.GMNot == 1 then return end
	return self:AddChar(CharId, Level, Reason, true, NotLog, NeedEnhance)
end

function Component:AddChar(CharId, Level, Reason, GiveNotOpen, NotLog, NeedEnhance)
	return self:AddCharCommon(CharId, Level, Reason, GiveNotOpen, NotLog, NeedEnhance)
end

function Component:DelChar(CharId, Reason)
	self.logger.info("DelChar", CharId)
	local DelChars = {}
	for eid, char in pairs(self.Chars) do
		if char.CharId == CharId then
			table.insert(DelChars, eid)
		end
	end
	for index, eid in ipairs(DelChars) do
		self:DelCharByUuid(eid)
	end
end

function Component:DelCharByUuid(CharUuid, Reason)
	self.logger.debug("DelCharByUuid", CommonUtils.ObjId2Str(CharUuid))
	local Char = self.Chars[CharUuid]
	if not Char then
		return
	end
	local CountReduce = Char.GradeLevel + 1
	for i, v in ipairs(Char.UWeaponEids) do
		local UWeapon = self.UWeapons[v]
		if UWeapon then
			self:UploadWeaponMod(UWeapon)
			self.UWeapons[v] = nil
		end
	end
	self:UploadCharMod(Char)
	local CharId = Char.CharId
	self.Chars[CharUuid] = nil
	local common_char = self.CommonChars[CharId]
	if common_char then
		common_char.Count = 0
		self.CommonChars[CharId] = common_char
	end
end

--清除角色装备的Mod上的引用
function Component:UploadCharMod(Char)
	if not Char then return false end
	self:HandleUploadTargetMod("Char", Char.ModSuit_1, Char.Uuid)
	self:HandleUploadTargetMod("Char", Char.ModSuit_2, Char.Uuid)
	self:HandleUploadTargetMod("Char", Char.ModSuit_3, Char.Uuid)
	return true
end

function Component:UploadWeaponMod(Weapon)
	if not Weapon then return false end
	self:HandleUploadTargetMod("Weapon", Weapon.ModSuit_1, Weapon.Uuid)
	self:HandleUploadTargetMod("Weapon", Weapon.ModSuit_2, Weapon.Uuid)
	self:HandleUploadTargetMod("Weapon", Weapon.ModSuit_3, Weapon.Uuid)
	return true
end

function Component:HandleUploadTargetMod(Tag, ModSuit, CharUuid)
	for ModSlotId = 1, ModSuit:Length() do
		local ModSlotEid = ModSuit[ModSlotId]
		local Mod = self.Mods[ModSlotEid]
		self:RemoveTargetModUuid(Tag, Mod, ModSlotEid)
		if not Mod and ModSlotEid ~= CommonConst.ModSlotUnequipped then
			self.logger.error("ZJT_ HandleUploadCharMod 不存在的Mod被引用 请检测 ",Tag, ModSlotId, CharUuid)
		end
		ModSuit[ModSlotId] = CommonConst.ModSlotUnequipped
	end
end

function Component:RemoveTargetModUuid(Tag, Mod, Uuid)
	if not Mod then return  end
	if Tag == "Weapon" then
		Mod:RemoveWeaponUuid(Uuid)
	elseif Tag == "Char" then
		Mod:RemoveCharUuid(Uuid) 
	else
		self.logger.error("ZJT_ 未知目标 不能移除引用 ", Tag, Mod, Uuid)
		return
	end
	self.Mods[Mod.Uuid] = Mod
end

function Component:AddCharCommon(CharId, Level, Reason, GiveNotOpen, NotLog, NeedEnhance)
	self.logger.debug("AddCharCommon", CharId, Level, Reason)
	GiveNotOpen = GiveNotOpen or false
	local info = DataMgr.Char[CharId] or DataMgr.BattleChar[CharId]
	if not info or (info.IsNotOpen and not GiveNotOpen) then return end
	if not DataMgr.LevelUp[Level] then return end
	local ResultEid = nil
	local CommonChar = self.CommonChars[CharId]
	if not CommonChar then
		self:AddCommonChar(CharId)
		ResultEid = self:RealAddChar(CharId, Level,  NeedEnhance, Reason)
	elseif CommonChar.Count == 0 then
		CommonChar:AddOne()
		ResultEid = self:RealAddChar(CharId, Level,  NeedEnhance, Reason)
	end
	return ResultEid
end
function Component:AddCommonChar(CharId)
	local CommonChar = self.CommonChars:GetNewCommonChar(CharId)
	-- 更新曾经获得的皮肤
	if self.OtherCharSkins[CharId] then
		for _, SkinId in ipairs(self.OtherCharSkins[CharId]) do
			self:AddCommonCharSkin(CommonChar, SkinId, DataMgr.ReasonTypeGet.OTHER_CHAR_SKIN)
		end
		self.OtherCharSkins[CharId] = nil
	end
	self.CommonChars[CharId] = CommonChar
end

function Component:AddCommonCharSkin(CommonChar, SkinId, Reason)
	if not CommonChar then return end
	if not CommonUtils.HasValue(CommonChar.SkinIds, SkinId) then
		return
	end
	if CommonChar.OwnedSkins[SkinId] ~= nil then
		return
	end
	CommonChar.OwnedSkins:GetNewSkin(SkinId, CommonConst.SkinType.Char)
end

function Component:RealAddChar(CharId, Level, NeedEnhance, Reason)
	local uuid = bson.objectid()

	self.logger.debug("ZJT_ RealAddChar ", CommonUtils.ObjId2Str(uuid))


	local char = self.Chars:NewChar(uuid, CharId, Level)
	char:HandleSetLevel(Level, NeedEnhance)
	self:CharInitUltraWeapon(char, Level, DataMgr.ReasonTypeGet.WEAPON_ADDCHAR)
	self:InitCharSetCharAppearanceAccessory(char, Reason)
	self.Chars[char.Uuid] = char
	return char.Uuid
end

function Component:GMAddSkin(SkinId, Reason)
	local SkinInfo = DataMgr.Skin[SkinId]
	if not SkinInfo or not SkinInfo.CharId then return end
	if SkinInfo.GMNot == 1 then
		return
	end
	self:AddSkin(SkinId,Reason,true)
end
function Component:AddSkin(SkinId, Reason, GiveNotOpen)
	GiveNotOpen = GiveNotOpen or false
	local SkinInfo = DataMgr.Skin[SkinId]
	if not SkinInfo or not SkinInfo.CharId then
		return
	end
	if SkinInfo.IsNotOpen and not GiveNotOpen then return end
	local CharId = SkinInfo.CharId
	local CommonChar = self.CommonChars[CharId]
	if not CommonChar then
		self:AddOtherCharSkin(CharId, SkinId, Reason)
	else
		self:AddCommonCharSkin(CommonChar, SkinId, Reason)
		self.CommonChars[CharId] = CommonChar
	end
end
function Component:AddCommonCharSkin(CommonChar, SkinId, Reason)
	if not CommonChar then return end
	if not CommonUtils.HasValue(CommonChar.SkinIds, SkinId) then
		return
	end
	if CommonChar.OwnedSkins[SkinId] ~= nil then
		return
	end
	CommonChar.OwnedSkins:GetNewSkin(SkinId, CommonConst.SkinType.Char)
end

function Component:AddOtherCharSkin(CharId, SkinId, Reason)
	local CharInfo = DataMgr.Char[CharId]
	if not CharInfo then return end
	if not CommonUtils.HasValue(CharInfo.SkinId, SkinId) then return end
	local OtherCharSkin = self.OtherCharSkins[CharId]
	if not OtherCharSkin then
		OtherCharSkin = self.OtherCharSkins:NewIntList()
	end
	if OtherCharSkin:HasValue(SkinId) then
		return
	end
	OtherCharSkin:Append(SkinId)
	self.OtherCharSkins[CharId] = OtherCharSkin
end

function Component:RealSetCharGradeLevel(CharUuid, TargetLevel)
	local Char = self.Chars[CharUuid]
	if not Char then
		return
	end
	if type(TargetLevel) ~= "number" then
		return
	end
	local CharOldGradeKLevel = Char.GradeLevel
	Char:SetGradeLevel(TargetLevel)
	--角色升阶时获得指定技能的额外等级
	local UpgradeSkillExtraLevel = DataMgr.BattleChar[Char.CharId].UpgradeSkillExtraLevel
	local IsUpExtraLevel = false
	if UpgradeSkillExtraLevel ~= nil then
		for key,value in pairs(UpgradeSkillExtraLevel) do
			local skill = Char:GetSkill(value.SkillId)
			if (value.Grade > CharOldGradeKLevel and value.Grade <= TargetLevel )and skill then
				IsUpExtraLevel = true
				skill:AddExtraLevel(tonumber(value.ExtraLv))
				self:ProminentWeaponSkillLevelInheritCharSkillLevel(Char,skill)
			end
		end
	end
	self.Chars[CharUuid] = Char
	for i, v in ipairs(Char.UWeaponEids) do
		local UWeapon = self.UWeapons[v]
		if UWeapon then
			UWeapon:SetGradeLevel(true,TargetLevel)
		end
	end
end

function Component:ProminentWeaponSkillLevelInheritCharSkillLevel(Char,Skill)
	TemplateDumpUtils:HandleWeaponSkillLevelInheritCharSkillLevel(Char, self, Skill)
end

return Component
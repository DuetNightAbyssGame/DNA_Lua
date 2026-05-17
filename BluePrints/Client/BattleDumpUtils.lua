
local TemplateDumpUtils = require "BluePrints.Client.TemplateDumpUtils"
local BattleDumpUtils = {}

function BattleDumpUtils:GetInfoProxy(Info, ModData, ModSuit)
	local Proxy = setmetatable({ModData = ModData, ModSuit = ModSuit}, {__index = Info})
	return Proxy
end

function BattleDumpUtils:GetMeleeWeaponInfoProxy(Info, ModData, ModSuit, SecondModSuit)
	local Proxy = setmetatable({ModData = ModData, ModSuit = ModSuit, SecondModSuit = SecondModSuit}, {__index = Info})
	return Proxy
end

-- 最底层接口，Info数据结构
function BattleDumpUtils:GetBattleInfoByInfo(Avatar, Info, bNotUseUWeapon)
	-- Info = {
	-- 	IsPhantom = 1,
	--  AvatarQuestRoleID = AvatarQuestRoleID,
	-- 	Char = Char, -- 对象,不是UUID
	-- 	CharModSuit = 1, -- nil 表示没有mod
	-- 	CharModData = CharModData, -- Mod详细数据
	-- 	UltraWeapons = { -- 没有就是无
	-- 		{UltraWeapon = UltraWeapon, ModSuit = 1, ModData = ModeData},
	-- 		{UltraWeapon = UltraWeapon, ModSuit = 1, ModData = ModeData},
	-- 		...,
	-- 		{UltraWeapon = UltraWeapon, ModSuit = 1, ModData = ModeData},
	-- 	}

	-- 	MeleeWeapon = MeleeWeapon, -- 对象,不是UUID
	-- 	MeleeWeaponModSuit = 1, -- nil 表示没有mod
	-- 	MeleeWeaponModData = MeleeWeaponModData, -- Mod详细数据

	-- 	RangedWeapon = RangedWeapon, -- 对象,不是UUID
	-- 	RangedWeaponModSuit = 1, -- nil 表示没有mod
	-- 	RangedWeaponModData = RangedWeaponModData, -- Mod详细数据

	-- 	Pet = Pet, -- 对象,不是UUID, 如果是nil表示没有宠物
	-- 	WheelIndex = 1, -- nil 表示没有轮盘
	--  ReplaceAvatar = nil,
	-- }
	if Info.ReplaceAvatar then
		Avatar = Info.ReplaceAvatar
	end
	if not Avatar then
		return {}
	end
	
	Info = Info or {}
	local Char = Info.Char
	local MeleeWeapon = Info.MeleeWeapon
	local RangedWeapon = Info.RangedWeapon
	
	local AvatarInfo = {
		AvatarQuestRoleID = Info.AvatarQuestRoleID
	}
	-- 角色数据
	if Char then
		local InfoProxy = self:GetInfoProxy(Info, Info.CharModData, Info.CharModSuit)
		AvatarInfo.RoleInfo = Char:BattleDump(Avatar, InfoProxy)
	else
		AvatarInfo.RoleInfo = {}
	end

	-- 近战武器
	if MeleeWeapon then
		local InfoProxy = self:GetMeleeWeaponInfoProxy(Info, Info.MeleeWeaponModData, Info.MeleeWeaponModSuit, Info.MeleeWeaponModSuitSecondary)
		AvatarInfo.MeleeWeapon = MeleeWeapon:BattleDump(Avatar, InfoProxy)
	else
		AvatarInfo.MeleeWeapon = {}
	end

	-- 远程武器
	if RangedWeapon then
		local InfoProxy = self:GetInfoProxy(Info, Info.RangedWeaponModData, Info.RangedWeaponModSuit)
		AvatarInfo.RangedWeapon = RangedWeapon:BattleDump(Avatar, InfoProxy)
	else
		AvatarInfo.RangedWeapon = {}
	end

	--显赫武器
	if Char then
		AvatarInfo.UltraWeapons = {}
		local UltraWeapons = Info.UltraWeapons or {}
		for Index, UltraWeaponInfo in ipairs(UltraWeapons) do
			local UltraWeapon = UltraWeaponInfo.UltraWeapon
			if UltraWeapon then
				local ModData
				if bNotUseUWeapon then
					ModData = {}
				else
					ModData = UltraWeaponInfo.ModData
				end
				local InfoProxy = self:GetInfoProxy(Info, ModData, UltraWeaponInfo.ModSuit)
				table.insert(AvatarInfo.UltraWeapons,  UltraWeapon:BattleDump(Avatar, InfoProxy))
			end
		end
	else
		AvatarInfo.UltraWeapons = {}
	end

	AvatarInfo.WheelIndex = Info.WheelIndex

	local Pet = Info.Pet
	-- 宠物数据
	if Pet then
		AvatarInfo.Pet = Pet:BattleDump(Avatar)
	else
		AvatarInfo.Pet = {}
	end

	-- AvatarInfo = BattleDumpUtils:UpdateBattleInfo(AvatarInfo, ExtraInfo)
	-- PrintTable({AvatarInfo = AvatarInfo}, 10, "GetBattleInfoByInfo")
	return AvatarInfo
end

-- 默认
function BattleDumpUtils:GetDefaultBattleInfo(Avatar, ExtraInfo)
	if not Avatar then
		return
	end
	ExtraInfo = ExtraInfo or {}
	local Info = {
		Char = ExtraInfo.Char or Avatar.Chars[Avatar.CurrentChar],
		MeleeWeapon = ExtraInfo.MeleeWeapon or Avatar.Weapons[Avatar.MeleeWeapon],
		RangedWeapon = ExtraInfo.RangedWeapon or Avatar.Weapons[Avatar.RangedWeapon],
		Pet = ExtraInfo.Pet or Avatar.Pets[Avatar.CurrentPet],
	}
	if Info.Char then
		Info.CharModSuit = Info.Char.ModSuitIndex
		-- 显赫武器也是用默认Suit
		Info.UltraWeapons = self:GetDefaultUltraWeaponInfo(Avatar, Info.Char)
	end
	if Info.MeleeWeapon then
		Info.MeleeWeaponModSuit = Info.MeleeWeapon.ModSuitIndex
	end
	if Info.RangedWeapon then
		Info.RangedWeaponModSuit = Info.RangedWeapon.ModSuitIndex
	end

	if ExtraInfo then
		for k,v in pairs(ExtraInfo) do
			Info[k] = v
		end
	end

	return self:GetBattleInfoByInfo(Avatar, Info)
end

-- 默认显赫武器
function BattleDumpUtils:GetDefaultUltraWeaponInfo(Avatar, Char)
	if not Char then
		return {}
	end
	-- 显赫武器也是用默认Suit
	local UltraWeapons = {}
	for Index, Uuid in ipairs(Char.UWeaponEids) do
		local UltraWeapon = Avatar.UWeapons[Uuid]
		if UltraWeapon then
			table.insert(UltraWeapons,  {UltraWeapon = UltraWeapon, ModSuit = UltraWeapon.ModSuitIndex})
		end
	end
	return UltraWeapons
end

-- 魅影
function BattleDumpUtils:GetPhantomBattleInfo(Avatar, Char, Weapon, Pet, bNotUseUWeapon)
	local Info = {
		Char = Char,
		IsPhantom = true,
		Pet = Pet,
	}
	if Weapon then
		if Weapon:IsMelee() then
			Info.MeleeWeapon = Weapon
		else
			Info.RangedWeapon = Weapon
		end
	else
		return {
			RoleInfo = {}
		}
	end
	if Info.Char then
		Info.CharModSuit = Info.Char.ModSuitIndex
		Info.UltraWeapons = self:GetDefaultUltraWeaponInfo(Avatar, Info.Char)
	end
	if Info.MeleeWeapon then
		Info.MeleeWeaponModSuit = Info.MeleeWeapon.ModSuitIndex
	end
	if Info.RangedWeapon then
		Info.RangedWeaponModSuit = Info.RangedWeapon.ModSuitIndex
	end
	local AvatarInfo = self:GetBattleInfoByInfo(Avatar, Info, bNotUseUWeapon)
	AvatarInfo.Pet = {}
	return AvatarInfo
end

-- 角色
function BattleDumpUtils:GetCharBattleInfo(Avatar, Char, ExtraModSuitIndex)
	local Info = {
		Char = Char,
	}
	if Info.Char then
		Info.CharModSuit = Info.Char.ModSuitIndex
	end
	if ExtraModSuitIndex then
		Info.CharModSuit = ExtraModSuitIndex
	end
	return self:GetBattleInfoByInfo(Avatar, Info)
end

-- 武器
function BattleDumpUtils:GetWeaponBattleInfo(Avatar, Weapon,ExtraModSuitIndex)
	local Info = {}
	if Weapon then
		if Weapon:IsMelee() then
			Info.MeleeWeapon = Weapon
			Info.MeleeWeaponModSuit = Info.MeleeWeapon.ModSuitIndex
			if ExtraModSuitIndex then
				Info.MeleeWeaponModSuit = ExtraModSuitIndex
			end
		else
			Info.RangedWeapon = Weapon
			Info.RangedWeaponModSuit = Info.RangedWeapon.ModSuitIndex
			if ExtraModSuitIndex then
				Info.RangedWeaponModSuit = ExtraModSuitIndex
			end
		end
	end
	return self:GetBattleInfoByInfo(Avatar, Info)
end

-- 模板
function BattleDumpUtils:GetSquadInfoByQuestRoleId(RoleId, Avatar)
	local RoleInfo = DataMgr.QuestRoleInfo[RoleId]
	if not RoleInfo then
		return
	end

	--若策划填写了ExStroyInfo，则将CharId替换为当前性别对应的主角或前主角的Id
	local ReplaceCharId = nil
	if (RoleInfo.ExStroyInfo ~= nil) then
		local Sex = Avatar.Sex
		if string.sub(RoleInfo.ExStroyInfo, 1, 2) == "EX" then
			Sex = Avatar.WeitaSex
		else
			Sex = Avatar.Sex
		end

		ReplaceCharId = DataMgr.Player2RoleId[RoleInfo.ExStroyInfo][Sex]
	end
	local TemplateAvatarComponent = require "BluePrints.Client.TemplateAvatar.TemplateAvatarComponent"
	local TemplateAvatar = TemplateAvatarComponent()
	TemplateDumpUtils:CreateTemplate_Char(TemplateAvatar, RoleInfo.CharTemplateRuleId, ReplaceCharId, true)
	TemplateAvatar.MeleeWeapon = TemplateDumpUtils:CreateTemplate_Weapon(TemplateAvatar, RoleInfo.MeleeWeaponRuleId, true)
	TemplateAvatar.RangedWeapon = TemplateDumpUtils:CreateTemplate_Weapon(TemplateAvatar, RoleInfo.RangedWeaponRuleId, true)
	local Info = TemplateAvatar:GetSquadCreateInfoByNow()
	Info.AvatarQuestRoleID = RoleId
	return Info, TemplateAvatar
end

function BattleDumpUtils:GetSquadInfoByTemplate(Avatar, Squad)
	local TemplateAvatarComponent = require "BluePrints.Client.TemplateAvatar.TemplateAvatarComponent"
	local TemplateAvatar = TemplateAvatarComponent()
	local ExtraSquad = {}
	
	local function DumpAvatarData(Prop, Key)
		return Avatar[Prop][Key]:all_dump(Avatar[Prop][Key])
	end

	TemplateAvatar.Mods = TemplateAvatar.Mods:load(Avatar.Mods:save_dump(Avatar.Mods))

	-- 角色
	if Squad.Char.bTrial then
		TemplateDumpUtils:CreateTemplate_Char(TemplateAvatar, Squad.Char.Id, nil, true)
	else
		local CharUuid = Squad.Char.Id
		local CharId = Avatar.Chars[CharUuid].CharId
		TemplateAvatar.CurrentChar = CharUuid
		TemplateAvatar.Chars[CharUuid] = TemplateAvatar.Chars:LoadChar(DumpAvatarData("Chars", CharUuid))
		TemplateAvatar.CommonChars[CharId] = TemplateAvatar.CommonChars:LoadCommonChar(DumpAvatarData("CommonChars", CharId))
		ExtraSquad.CharModSuit = Squad.Char.ModIndex
	end

	-- 近战武器
	if Squad.MeleeWeapon.bTrial then
		TemplateAvatar.MeleeWeapon = TemplateDumpUtils:CreateTemplate_Weapon(TemplateAvatar, Squad.MeleeWeapon.Id)
	else
		local MeleeWeaponUuid = Squad.MeleeWeapon.Id
		TemplateAvatar.MeleeWeapon = MeleeWeaponUuid
		TemplateAvatar.Weapons[MeleeWeaponUuid] = TemplateAvatar.Weapons:LoadWeapon(DumpAvatarData("Weapons", MeleeWeaponUuid))
		ExtraSquad.MeleeWeaponModSuit = Squad.MeleeWeapon.ModIndex
	end

	-- 远程武器
	if Squad.RangedWeapon.bTrial then
		TemplateAvatar.RangedWeapon = TemplateDumpUtils:CreateTemplate_Weapon(TemplateAvatar, Squad.RangedWeapon.Id)
	else
		local RangedWeaponUuid = Squad.RangedWeapon.Id
		TemplateAvatar.RangedWeapon = RangedWeaponUuid
		TemplateAvatar.Weapons[RangedWeaponUuid] = TemplateAvatar.Weapons:LoadWeapon(DumpAvatarData("Weapons", RangedWeaponUuid))
		ExtraSquad.RangedWeaponModSuit = Squad.RangedWeapon.ModIndex
	end

	-- 魅影1
	if Squad.Phantom1 and next(Squad.Phantom1) then
		if Squad.Phantom1.bTrial then
			local Ok, Uuid = TemplateDumpUtils:CreateTemplate_Char(TemplateAvatar, Squad.Phantom1.Id, nil, false)
			if Ok then
				ExtraSquad.Phantom1 = Uuid
			end
		else
			local Phantom1CharUuid = Squad.Phantom1.Id
			local CharId = Avatar.Chars[Phantom1CharUuid].CharId
			TemplateAvatar.Chars[Phantom1CharUuid] = TemplateAvatar.Chars:LoadChar(DumpAvatarData("Chars", Phantom1CharUuid))
			TemplateAvatar.CommonChars[CharId] = TemplateAvatar.CommonChars:LoadCommonChar(DumpAvatarData("CommonChars", CharId))
			ExtraSquad.Phantom1 = Phantom1CharUuid
		end

		if Squad.PhantomWeapon1.bTrial then
			ExtraSquad.PhantomWeapon1 = TemplateDumpUtils:CreateTemplate_Weapon(TemplateAvatar, Squad.PhantomWeapon1.Id)
		else
			local PhantomWeapon1Uuid = Squad.PhantomWeapon1.Id
			TemplateAvatar.Weapons[PhantomWeapon1Uuid] = TemplateAvatar.Weapons:LoadWeapon(DumpAvatarData("Weapons", PhantomWeapon1Uuid))
			ExtraSquad.PhantomWeapon1 = PhantomWeapon1Uuid
		end
	end

	-- 魅影2
	if Squad.Phantom2 and next(Squad.Phantom2) then
		if Squad.Phantom2.bTrial then
			local Ok, Uuid = TemplateDumpUtils:CreateTemplate_Char(TemplateAvatar, Squad.Phantom2.Id, nil, false)
			if Ok then
				ExtraSquad.Phantom2 = Uuid
			end
		else
			local Phantom2CharUuid = Squad.Phantom2.Id
			local CharId = Avatar.Chars[Phantom2CharUuid].CharId
			TemplateAvatar.Chars[Phantom2CharUuid] = TemplateAvatar.Chars:LoadChar(DumpAvatarData("Chars", Phantom2CharUuid))
			TemplateAvatar.CommonChars[CharId] = TemplateAvatar.CommonChars:LoadCommonChar(DumpAvatarData("CommonChars", CharId))
			ExtraSquad.Phantom2 = Phantom2CharUuid
		end

		if Squad.PhantomWeapon2.bTrial then
			ExtraSquad.PhantomWeapon2 = TemplateDumpUtils:CreateTemplate_Weapon(TemplateAvatar, Squad.PhantomWeapon2.Id)
		else
			local PhantomWeapon2Uuid = Squad.PhantomWeapon2.Id
			TemplateAvatar.Weapons[PhantomWeapon2Uuid] = TemplateAvatar.Weapons:LoadWeapon(DumpAvatarData("Weapons", PhantomWeapon2Uuid))
			ExtraSquad.PhantomWeapon2 = PhantomWeapon2Uuid
		end
	end

	-- 宠物
	if Squad.Pet.bTrial then
		ExtraSquad.Pet = TemplateDumpUtils:CreateTemplate_Pet(TemplateAvatar, Squad.Pet.Id)
	else
		local PetUuid = Squad.Pet.Id
		TemplateAvatar.Pets[PetUuid] = TemplateAvatar.Pets:LoadPet(DumpAvatarData("Pets", PetUuid))
		ExtraSquad.Pet = TemplateAvatar.Pets[PetUuid]
	end
	return TemplateAvatar:GetSquadCreateInfoByExtra(ExtraSquad), TemplateAvatar
end

-- 任务
function BattleDumpUtils:GetBattleInfoByQuestRoleId(RoleId, Avatar)
	local Info, TemplateAvatar = self:GetSquadInfoByQuestRoleId(RoleId, Avatar)
	return self:GetBattleInfoByInfo(TemplateAvatar, Info)
end

-- 合并暂离数据
function BattleDumpUtils:UpdateBattleInfo(AvatarInfo, UpdateInfo)
	if not UpdateInfo then
		return AvatarInfo
	end
	if UpdateInfo.RoleInfo then
		AvatarInfo.RoleInfo = AvatarInfo.RoleInfo or {}
		for k,v in pairs(UpdateInfo.RoleInfo) do
			AvatarInfo.RoleInfo[k] = v
		end
	end
	if UpdateInfo.MeleeWeapon then
		AvatarInfo.MeleeWeapon = AvatarInfo.MeleeWeapon or {}
		for k,v in pairs(UpdateInfo.MeleeWeapon) do
			AvatarInfo.MeleeWeapon[k] = v
		end
	end
	if UpdateInfo.RangedWeapon then
		AvatarInfo.RangedWeapon = AvatarInfo.RangedWeapon or {}
		for k,v in pairs(UpdateInfo.RangedWeapon) do
			AvatarInfo.RangedWeapon[k] = v
		end
	end
	if UpdateInfo.UltraWeapons  then
		AvatarInfo.UltraWeapons = AvatarInfo.UltraWeapons or {} 
		for i, extraWeapon in pairs(UpdateInfo.UltraWeapons) do
			AvatarInfo.UltraWeapons[i] = AvatarInfo.UltraWeapons[i] or {}
			for k, v in pairs(extraWeapon) do
				AvatarInfo.UltraWeapons[i][k] = v
			end
		end
	end
	return AvatarInfo
end

return BattleDumpUtils
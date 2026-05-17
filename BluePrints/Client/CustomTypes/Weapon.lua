local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local ModCom = require"BluePrints.Client.CustomTypes.Mod"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties
local SkillUtils = require "Utils.SkillUtils"

---@class Weapon:CustomMetaAttr
---@field ModSuits ModSuits
---@field ModSuitIndex Int
local Weapon = Class("Weapon", CustomTypes.CustomMetaAttr)
	---@type Weapon
	Weapon.__Props__ = {
		-- uuid
		Uuid = prop.prop("ObjId", "client save"),
		-- 武器id
		WeaponId = prop.prop("Int", "client save"),
		-- 经验
		Exp = prop.prop("Int", "client"),
		-- 等级
		Level = prop.prop("Int", "client", 1),
		-- 状态
		Status = prop.prop("Int", "client", 0),  -- 0:解锁，1:锁定
		-- 突破等级
		EnhanceLevel = prop.prop("Int", "client", 0),
		-- 阶级
		GradeLevel = prop.prop("Int", "client", 0),
		--同卡升阶已消耗的武器等级记录
		ConsumeWeaponLevel = prop.prop("Int", "client", 0),
		--同卡升阶已消耗的武器突破等级记录
		ConsumeWeaponEnhanceLevel = prop.prop("Int", "client", 0),
		-- Mod槽极性
		ModSlotPolarity = prop.prop("IntList", "client"),
		-- Mod槽状态
		ModSlotStatus = prop.prop("IntList", "client"),
		-- Mod配置
		ModSuit_1 = prop.prop("ObjectIdList", "client"),
		ModSuit_2 = prop.prop("ObjectIdList", "client"),
		ModSuit_3 = prop.prop("ObjectIdList", "client"),
		-- 生效的Mod配置Index
		ModSuitIndex = prop.prop("Int", "client", 1),
		-- Mod容量
		ModVolume = prop.getter("WeaponLevelData", "ModVolume"),
		-- Mod套装名
		ModSuitsName  = prop.prop("StrList", "client"),
		-- 当前外观
		CurrentAppearanceIndex = prop.prop("Int", "client", 1),
		-- 外观配置
		AppearanceSuits = prop.prop("Appearance.AppearanceList", "client"),
		-- 装扮过的皮肤
		UsedSkins = prop.prop("Appearance.SkinDict", "client"),
		-- 所属的魅影编号
		AssisterId = prop.prop("Int", "client", 0),
		-- 武器名
		WeaponName = prop.getter("Data", "WeaponName"),
		-- 描述
		WeaponDescribe = prop.getter("Data", "WeaponDescribe"),
		-- 武器稀有度
		WeaponRarity = prop.getter("Data", "WeaponRarity"),
		-- 武器标签
		WeaponTag = prop.getter("BattleData", "WeaponTag"),
		-- Mod适用类型
		ModApplicationType = prop.getter("BattleData", "ModApplicationType"),
		--武器的最大等级
		MaxLevel = prop.getter("Data", "WeaponMaxLevel"),
		-- 武器分解奖励
		DecomposeReward = prop.getter("Data", "DecomposeReward"),
		-- 武器子类型：Normal为普通武器，Hyper为灵化武器
		--WeaponSubType = prop.getter("Data", "WeaponSubType"),
		-- 灵化熔炼等级,初始0级
		--HyperCardLevel = prop.prop("Int", "client save", 0),
		-- 灵化天赋树
		--HyperTalent = prop.prop("Int2IntSetDict", "client save")
	}

	function Weapon:Init(Uuid, WeaponId, Level)
		Weapon.Super.Init(self)
		if not Uuid or not WeaponId then
			return
		end
		self.Uuid = Uuid
		self.WeaponId = WeaponId
		self:SetLevel(Level or 1)
		self:InitModConfig()
		self:InitAppearanceConfig()
		--self:InitTalent()
		if WeaponId then
			self:_Init()
		end
	end
	-- 初始化颜色
	function Weapon:InitAppearanceConfig()
		if self:IsUltra() then return end
		self:InitAppearance()
	end
	function Weapon:InitModConfig()
		local WeaponInfo = self:Data()
		if not WeaponInfo then return end
		local ModSlot = WeaponInfo.ModSlot
		local ModSlotUnlock = WeaponInfo.ModSlotUnlock
		if not ModSlot or not ModSlotUnlock then return	end
		local InitCount = 3
		if DataMgr.GlobalConstant.ModPlanMaxSuitCount then
			if DataMgr.GlobalConstant.ModPlanMaxSuitCount.ConstantValue ~= nil and DataMgr.GlobalConstant.ModPlanMaxSuitCount.ConstantValue > 0 then
				InitCount = DataMgr.GlobalConstant.ModPlanMaxSuitCount.ConstantValue
			end
		end
		for i = 1, InitCount, 1 do
			self.ModSuitsName[i] = ""
		end
		for i, v in ipairs(ModSlot) do
			self.ModSlotPolarity:Append(v)
			if self.EnhanceLevel >= ModSlotUnlock[i] then
				self.ModSlotStatus:Append(CommonConst.CommonStatus.UnLock)
			else
				self.ModSlotStatus:Append(CommonConst.CommonStatus.Lock)
			end
			for i = 1, InitCount, 1 do
				if self['ModSuit_'..i] then
					self['ModSuit_'..i]:Append(CommonConst.ModSlotUnequipped)
				end
			end
		end
	end

	function Weapon:InitAppearance()
		self.AppearanceSuits:AddWeaponAppearance(self.WeaponId)
		self.CurrentAppearanceIndex = 1
		-- 初始化皮肤列表
		self.UsedSkins:GetNewSkin(self.WeaponId, CommonConst.SkinType.Weapon)
	end

	function Weapon:InitTalent()
		if not self.WeaponSubType or self.WeaponSubType == "Normal" then
			return
		end
		for k, v in pairs(DataMgr.HyperWeaponSkillTree) do
			if v.WeaponId == self.WeaponId and v.WeaponCardLevel == 0 then
				-- 灵化武器默认解锁0熔炼等级的天赋
				self.HyperTalent:AddElement(v.WeaponCardLevel, v.WeaponSkillId)
			end
		end
	end

	function Weapon:AddSkin(SkinId)
		return self.UsedSkins:GetNewSkin(SkinId, CommonConst.SkinType.Weapon)
	end

	function Weapon:GetSkin(SkinId)
		return self.UsedSkins:GetSkin(SkinId)
	end

	function Weapon:GetAppearance()
		return self.AppearanceSuits[self.CurrentAppearanceIndex]
	end

	function Weapon:GetModVolume()
		return self.ModVolume
	end

	function Weapon:GetCurrentSkin()
		local Appearance = self:GetAppearance()
		return self:GetSkin(Appearance.SkinId)
	end

	--判断武器是否满足突破等级
	function Weapon:CheckCurrentLevelOfBreakUpLevel()
		if self.Level == self:GetCurrentMaxLevel() then
			return true
		end
		return false
	end

	function Weapon:_Init()
		AvatarUtils:RebuildModSuit(self)
	end
	--获取当前阶段武器突破对应的最大等级
	function Weapon:GetCurrentMaxLevel()
		local WeaponBreakInfo = DataMgr.WeaponBreak[self.WeaponId]
		if not WeaponBreakInfo then
			return self.MaxLevel
		end
		local WeaponBreakLevelUpInfo = WeaponBreakInfo[self.EnhanceLevel + 1]
		if not WeaponBreakLevelUpInfo then
			return self.MaxLevel
		end
		return WeaponBreakLevelUpInfo.WeaponBreakLevel
	end

	function Weapon:GetName()
		return GText(self.WeaponName)
	end

	function Weapon:Data()
		local WData = DataMgr.Weapon[self.WeaponId]
		if not WData then
			if self.Uuid == -1 then
				WData = DataMgr.BattleWeapon[self.WeaponId]
			elseif not skynet then
				DebugPrint("ERROR::", string.format("武器Id%s 无效，先更新，不要用老号，用新号重试，还有问题就找策划检查下Weapon表是否同步双端",self.WeaponId))
			end
		end
		return WData
	end
	
	--获取槽位解锁等级
	function Weapon:GetModSlotUnlock()
		local WeaponInfo = self:Data()
		return WeaponInfo.ModSlotUnlock
	end
	
	function Weapon:BattleData()
		return DataMgr.BattleWeapon[self.WeaponId]
	end

	function Weapon:BattleDefaultData()
		return DataMgr.BattleWeaponAttr
	end

	function Weapon:IsMelee()
		if CommonUtils.HasValue(self.WeaponTag, CommonConst.WeaponType.MeleeWeapon) then
			return true
		end
		return false
	end

	function Weapon:IsRanged()
		if CommonUtils.HasValue(self.WeaponTag, CommonConst.WeaponType.RangedWeapon) then
			return true
		end
		return false
	end

	function Weapon:IsUltra()
		if CommonUtils.HasValue(self.WeaponTag, CommonConst.WeaponType.UltraWeapon) then
			return true
		end
		return false
	end

	function Weapon:WeaponLevelData()
		return DataMgr.WeaponLevelUp[self.Level]
	end

	function Weapon:LevelUpData(level)
		level = level or self.Level
		return DataMgr.WeaponLevelUp[level]
	end

	function Weapon:IsLock()
		return self.Status == CommonConst.CommonStatus.Lock
	end

	function Weapon:Lock()
		if not self:IsLock() then
			self.Status = CommonConst.CommonStatus.Lock
			return true
		end
		return false
	end

	function Weapon:UnLock()
		if self:IsLock() then
			self.Status = CommonConst.CommonStatus.UnLock
			return true
		end
		return false
	end

	function Weapon:GetModSuit(SuitIndex)
		if not SuitIndex then 
			SuitIndex = self.ModSuitIndex
		end
		if skynet then
			return AvatarUtils:GetTargetModSuit(self, SuitIndex) 
		else
			return self.ModSuits[SuitIndex]
		end
	end

	function Weapon:GetModSuitCost(SuitIndex)
		if not SuitIndex then
			SuitIndex = self.ModSuitIndex
		end
		return self.ModSuitsCostMap[SuitIndex] or 0
	end

	function Weapon:SetModSuitCost(Cost,SuitIndex)
		if not SuitIndex then 
			SuitIndex = self.ModSuitIndex
		end
		self.ModSuitsCostMap[SuitIndex] = Cost
	end

	function Weapon:AddExp(Count)
		if type(Count) ~= "number" or Count <= 0 then
			return
		end
		if self.Level >= self:GetCurrentMaxLevel() then
			self.Exp = 0
			return
		end
		local OldLevel = self.Level
		local _level = self.Level
		local _exp = self.Exp
		_exp = _exp + Count
		local info = self:LevelUpData(_level)
		local current_max_level = self:GetCurrentMaxLevel()
		while info and (_level + 1) <= #DataMgr.WeaponLevelUp and _exp >= info.WeaponLevelMaxExp and _level < current_max_level do
			_exp = _exp - info.WeaponLevelMaxExp
			_level = _level + 1
			info = self:LevelUpData(_level)
		end
		if _level >= self:GetCurrentMaxLevel() then
			_exp = 0
		end
		self.Exp = _exp
		self:SetLevel(_level)
		local Result = {}
		Result['LevelUp'] = {OldLevel, self.Level}
		return  Result
	end

	function Weapon:SetLevel(Level)
		if Level <= self.Level then return false end
		local LevelUpInfo = DataMgr.WeaponLevelUp[Level]
		if not LevelUpInfo then return false end
		self.Level = Level
		return true
	end
	
	function Weapon:HandleSetLevel(Level, NeedEnhance)
		if NeedEnhance == nil or NeedEnhance == 1 then
			NeedEnhance = true
		else
			NeedEnhance = false
		end
		local LevelUpInfo = DataMgr.WeaponLevelUp[Level]
		if LevelUpInfo then
			self.Level = Level
			local BreakInfo = DataMgr.WeaponBreak[self.WeaponId]
			local NewEnhanceLevel = 0
			if BreakInfo then
				for key ,value in pairs(BreakInfo) do
					if NeedEnhance then
						if Level >= value.WeaponBreakLevel then
							NewEnhanceLevel = math.max(NewEnhanceLevel,key)
						end
					else
						if Level > value.WeaponBreakLevel then
							NewEnhanceLevel = math.max(NewEnhanceLevel,key)
						end
					end
				end
				return self:SetEnhanceLevel(NewEnhanceLevel)
			end
			return true
		end
		return false
	end

	function Weapon:GMSetLevel(Level, NeedEnhance)
		return self:HandleSetLevel(Level,  NeedEnhance)
	end

	function Weapon:SetEnhanceLevel(EnhanceLevel)
		local BreakInfo = DataMgr.WeaponBreak[self.WeaponId][EnhanceLevel]
		if BreakInfo or EnhanceLevel == 0 then
			self.EnhanceLevel = EnhanceLevel
			local WeaponInfo = DataMgr.Weapon[self.WeaponId]
			if WeaponInfo and WeaponInfo.ModSlotUnlock then
				for index=1,#WeaponInfo.ModSlotUnlock do
					if WeaponInfo.ModSlotUnlock[index] <= self.EnhanceLevel then
						AvatarUtils:ModSlotIsUnLock(self, index)
					end
				end
			end
			return true
		end
		return false
	end

	--显赫武器最大阶级跟随角色，普通武器读表,未配表的武器禁止升阶
	function Weapon:UpGradeLevel(IsUWeapon,TargetLevel)
		local MaxGradeLevel
		if IsUWeapon then
			MaxGradeLevel = DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue
		else
			if not DataMgr.WeaponCardLevel[self.WeaponId] then
				return
			end
			MaxGradeLevel = DataMgr.WeaponCardLevel[self.WeaponId].CardLevelMax
		end
		TargetLevel = TargetLevel or 1
		if self.GradeLevel == MaxGradeLevel then
			return
		end
		self.GradeLevel = math.min(self.GradeLevel + TargetLevel,MaxGradeLevel)
	end

	function Weapon:SetGradeLevel(IsUWeapon,TargetLevel)
		local MaxGradeLevel
		if IsUWeapon then
			MaxGradeLevel = DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue
		else
			if not DataMgr.WeaponCardLevel[self.WeaponId] then
				return
			end
			MaxGradeLevel = DataMgr.WeaponCardLevel[self.WeaponId].CardLevelMax
		end
		TargetLevel = TargetLevel or 1
		if TargetLevel > MaxGradeLevel or TargetLevel < 1 then
			return
		end
		self.GradeLevel = TargetLevel
	end

	function Weapon:AddConsumeWeaponLevel(Level)
		if Level > 0 then
			self.ConsumeWeaponLevel = self.ConsumeWeaponLevel + Level
		end
	end

	function Weapon:AddConsumeWeaponEnhanceLevel(Level)
		if Level > 0 then
			self.ConsumeWeaponEnhanceLevel = self.ConsumeWeaponEnhanceLevel + Level
		end
	end

	Weapon.CommunityAttrs = {
		'CRI',
		'CRD',
		'AttackSpeed_Normal',
		'TriggerProbability',
	}

	function Weapon:_GetCommunityWeaponTag()
		local BattleInfo = self:BattleData()
		for _, v in pairs(BattleInfo.WeaponTag) do
			if v ~= 'Ultra' and CommonConst.WeaponTypes[v] then
				return v
			end
		end
	end

	function Weapon:GetCommunityData(Avatar)
		local ExtraInfo = {}
		ExtraInfo.ModSuit = self.ModSuitIndex
		AvatarUtils:InitModInfo(Avatar, ExtraInfo, self)
		local ReplaceAttrs = self:DumpBattleAttr(Avatar)
		local TotalValues = ReplaceAttrs.TotalValues
		local BattleInfo = self:BattleData()
		local CommunityData = {}
		for _AttrName, _ in pairs(DataMgr.Attribute) do
			local AttrName = "ATK_" .. _AttrName
			local Value = BattleInfo[AttrName]
			if Value then
				CommunityData['ATK'] = Value
			end
		end

		for _, AttrName in pairs(Weapon.CommunityAttrs) do
			CommunityData[AttrName] = TotalValues[AttrName]
		end
		CommunityData['WeaponTag'] = self:_GetCommunityWeaponTag()
		return CommunityData
	end

	function Weapon:BattleDump(Avatar, ExtraInfo)
		local ExtraInfo = ExtraInfo or {}
		AvatarUtils:InitModInfo(Avatar, ExtraInfo, self)
		local result = {
			WeaponId = self.WeaponId,
			Level = self.Level,
			Exp = self.Exp,
			GradeLevel = self.GradeLevel,
			EnhanceLevel = self.EnhanceLevel,
			SkillInfos = self:DumpSkillInfos(Avatar, ExtraInfo),
			ModPassives = self:DumpPassiveEffects(Avatar, ExtraInfo),
			ReplaceAttrs = self:DumpBattleAttr(Avatar, ExtraInfo),
			AppearanceInfo = self:DumpAppearanceInfo(),
			ModData = AvatarUtils:DumpModData(ExtraInfo),
			SlotData = ExtraInfo.SlotData,
			ModSuitIndex = ExtraInfo.ModSuit
		}
		return result
	end

	function Weapon:DumpAppearanceInfo()
		if(self:IsUltra())then
			return
		end
		local AppearanceInfo = {}
		local Skin = self:GetCurrentSkin()
		AppearanceInfo.SkinId = Skin and Skin.SkinId
		AppearanceInfo.Colors = self:DumpColors()
		AppearanceInfo.AccessorySuit = self:DumpAccessory()
		AppearanceInfo.WeaponId = self.WeaponId
		return AppearanceInfo
	end


	function Weapon:OnlineDumpInfo()
		local WeaponInfo = self:DumpAppearanceInfo() or  {}
		WeaponInfo.WeaponId = self.WeaponId
		WeaponInfo.EnhanceLevel = self.EnhanceLevel
		WeaponInfo.GradeLevel = self.GradeLevel
		return WeaponInfo
	end

	function Weapon:DumpAccessory()
		local Appearance = self:GetAppearance()
		local Res = {}
		for key, value in pairs(Appearance.Accessory) do
			Res[key] = value
		end
		return Res
	end

	function Weapon:DumpColors(SkinId)
		if(self:IsUltra())then
			return
		end
		local Skin
		if(SkinId)then
			Skin = self:GetSkin(SkinId)
		else
			Skin = self:GetCurrentSkin()
		end
		if(not Skin)then
			return
		end
		local Colors = {
			SpecialColor = Skin:GetWeaponSpecialColor(),
		}
		Colors.Colors = Skin:GetColors():all_dump(Skin:GetColors())
		return Colors
	end

	function Weapon:GetSkillLevel()
		-- 普通武器上的技能等级都为1
		return 1
	end

	function Weapon:DumpSkillInfos(Avatar, ExtraInfo)
		local Skills = {}

		local BattleWeaponInfo = DataMgr.BattleWeapon[self.WeaponId]
		local SkillList = BattleWeaponInfo.WeaponSkillList or {}
		local SkillLevel = self:GetSkillLevel()
		for i, SkillId in ipairs(SkillList) do
			local SkillInfo = {}
			if SkillLevel ~= 1 then
				SkillInfo.Level = SkillLevel
			end
			if self.GradeLevel ~= 0 then
				SkillInfo.Grade = self.GradeLevel -- 武器阶级，就是技能阶级
			end
			Skills[SkillId] = SkillInfo
		end

		local ModData = ExtraInfo and ExtraInfo.ModData
		if ModData then
			for _, Mod in pairs(ModData) do
				local ModData = Mod:Data()
				if ModData.ModActivateSkills then
					for SkillId1,SkillId2 in pairs(ModData.ModActivateSkills) do
						if Skills[SkillId1] then
							Skills[SkillId2] = Skills[SkillId1]
							if ModData.ModLevelAsSkillLevel then
								Skills[SkillId2].Level = Mod.Level + 1
							end
							Skills[SkillId1] = nil
						end
					end
				end
			end
		end
		local ModSuit = ExtraInfo and ExtraInfo.ModSuit
		local SecondModSuit = ExtraInfo and ExtraInfo.SecondModSuit
		if not ModSuit and SecondModSuit then
			for ModSlotId, ModSlotEid in pairs(self:GetModSuit(SecondModSuit)) do
				local Mod = Avatar.Mods[ModSlotEid]
				if Mod then
					local ModData = Mod:Data()
					if ModData.ModActivateSkills and ModData.ActivateInRouge then
						for SkillId1,SkillId2 in pairs(ModData.ModActivateSkills) do
							if Skills[SkillId1] then
								Skills[SkillId2] = Skills[SkillId1]
								if ModData.ModLevelAsSkillLevel then
									Skills[SkillId2].Level = Mod.Level + 1
								end
								Skills[SkillId1] = nil
							end
						end
					end
				end
			end
		end
		return Skills
	end

	function Weapon:DumpPassiveEffects(Avatar, ExtraInfo)
		local PassiveEffects = {}
		local ModPolarityMap = {}
		local ModData = ExtraInfo.ModData
		if ModData then
			for _, Mod in pairs(ModData) do
				Mod:CountModPolarity(ModPolarityMap)
			end
			for _, Mod in pairs(ModData) do
				local ModData = Mod:Data()
				if ModData.PassiveEffects then
					local ShouldAddPassiveEffects = true
					if ModData.PolarityNeedNum then
						for Polarity, NeedNum in pairs(ModData.PolarityNeedNum) do
							if not ModPolarityMap[Polarity] or ModPolarityMap[Polarity] < NeedNum then
								ShouldAddPassiveEffects = false -- 如果填了表，角色身上Mod总极性数量不满足要求，该Mod的被动效果不生效
								break
							end
						end
					end
					if ShouldAddPassiveEffects then
						for k = 1, #ModData.PassiveEffects do
							table.insert(PassiveEffects, {ModData.PassiveEffects[k], Mod.Level, false})
						end
					end
				end
			end
		end
		return PassiveEffects
	end

	function Weapon:SaLogDump(Avatar)
		local Mods = {}
		for ModSlotId, ModSlotEid in pairs(self:GetModSuit()) do
			local Mod = Avatar.Mods[ModSlotEid]
			if Mod then
				table.insert(Mods,{Mod.ModId,Mod.Level})
			end
		end
		return Mods
	end

	-- 1.武器需要显示的属性
	-- 2.武器会被mod修正的属性
	-- 3.这个table不全，请用DumpBattleAttr()之后的keys
	Weapon.Attrs = {
		'DEF',
		'CRI',
		'CRD',
		'AttackSpeed_Normal',
		'AttackSpeed_Reload',
		'AttackSpeed_FallAttack',
		'AttackSpeed_HeavyAttack',
		'AttackSpeed_SlideAttack',
		"AttackRange_Normal",
		"AttackRange_RayLength",
		'TriggerProbability',
		'MaxComboCount',
		'ComboHoldTime',
		'MultiShoot',
		'MagazineCapacity',
		'BulletMax',
		'MaxDistance',
		'ComboHoldTime',
	}

	function Weapon:GetDefaultAttrValue(AttrName)
		local BattleInfo = self:BattleData()
		if BattleInfo[AttrName] then
			return BattleInfo[AttrName]
		end

		if not self.BattleWeaponAttr then
			self.BattleWeaponAttr = DataMgr.BattleWeaponAttr
		end
		local AttrData = self.BattleWeaponAttr[AttrName]
		if not AttrData then
			return 0
		end

		return AttrData.DefaultValue or 0
	end

	function Weapon:CalcTotalValue(CardValues, BaseValues, ModRateValues, ModAddValues)
		local TotalValues = {}
		for AttrName, Value in pairs(BaseValues) do
			TotalValues[AttrName] = Value
		end

		-- 多乘区
		for AttrName, Rates in pairs(ModRateValues) do
			for _, Rate in pairs(Rates) do
				if not TotalValues[AttrName] then
					local DefaultValue = self:GetDefaultAttrValue(AttrName)
					CardValues[AttrName] = DefaultValue
					TotalValues[AttrName] = DefaultValue
				end
				TotalValues[AttrName] = TotalValues[AttrName] * (Rate + 1)
			end
		end


		-- 值加成只有一个，且在最后
		for AttrName, AddValue in pairs(ModAddValues) do
			if not TotalValues[AttrName] then
				local DefaultValue = self:GetDefaultAttrValue(AttrName)
				CardValues[AttrName] = DefaultValue
				TotalValues[AttrName] = DefaultValue
			end
			TotalValues[AttrName] = TotalValues[AttrName] + AddValue
		end

		for AttrName, _ in pairs(TotalValues) do
			if CommonUtils.AttrConvert[AttrName] then
				if TotalValues[AttrName] then
					TotalValues[AttrName] = CommonUtils.AttrConvert[AttrName](TotalValues[AttrName])
				end
			end
		end

		return TotalValues
	end

	function Weapon:CalcBaseValue(CardValues, CardLevelValues)
		local BaseValues = {}
		for AttrName, Value in pairs(CardValues) do
			BaseValues[AttrName] = Value * (CardLevelValues[AttrName] or 1)
		end
		return BaseValues
	end

	function Weapon:DumpDefaultBattleAttr(Avatar, ExtraInfo)
		ExtraInfo = ExtraInfo or {}
		ExtraInfo.ModSuit = self.ModSuitIndex
		AvatarUtils:InitModInfo(Avatar, ExtraInfo,self)
		local BattleAttrs = self:DumpBattleAttr(Avatar, ExtraInfo)
		return BattleAttrs
	end

	function Weapon:DumpBattleAttr(Avatar, ExtraInfo)
		ExtraInfo = ExtraInfo or {}
		local CardValues, CardLevelValues = self:DumpCardValues()
		local BaseValues = self:CalcBaseValue(CardValues, CardLevelValues)
		local ModRateValues = {}
		local ModAddValues = {}
		local ModMultiplier = {}
		local ModPolarityMap = {}

		local Mods = {}
		local ModUniteTypes = {}
		local Mods = ExtraInfo.ModData
		if Mods then
			for _, Mod in pairs(Mods) do
				local ModUniteType = Mod.ModUniteType
				if ModUniteType then
					ModUniteTypes[ModUniteType] = (ModUniteTypes[ModUniteType] or 0) + 1
				end
			end
			for _, Mod in pairs(Mods) do
				Mod:CalcMultiplier(ModMultiplier) -- 计算Mod的属性修正倍率
			end
			
			for _, Mod in pairs(Mods) do
				Mod:CountModPolarity(ModPolarityMap) -- 统计Mod的极性
			end
			
			for _, Mod in pairs(Mods) do
				Mod:CalcAttrs(BaseValues, ModRateValues, ModAddValues, ModUniteTypes, ModMultiplier, ModPolarityMap)
			end
		end

		self:CheckUnconstrainedMCByMod(ModRateValues, ModAddValues)
		self:CalcAddAttrs(Avatar, BaseValues, ModRateValues, ModAddValues)
		self:CalcExcelWeaponAttr(Avatar, ModRateValues, ExtraInfo.Char)

		local TotalValues = self:CalcTotalValue(CardValues, BaseValues, ModRateValues, ModAddValues)

		-- 限制属性最大值
		for _, Data in pairs(DataMgr.AttrLimit) do
			local AttachAttrName = Data.AttachAttrName
			if TotalValues[AttachAttrName] then
				if Data.LimitValue then
					TotalValues[AttachAttrName] = math.min(TotalValues[AttachAttrName], Data.LimitValue)
				end
				if Data.MinLimitValue then
					TotalValues[AttachAttrName] = math.max(TotalValues[AttachAttrName], Data.MinLimitValue)
				end
			end
		end
		
		local BattleAttrs = {
			CardValues = CardValues, -- 默认等级数据
			CardLevelValues = CardLevelValues, -- 成长系数
			-- BaseValues = BaseValues, -- 当前等级数据
			ModRateValues = ModRateValues, -- Mod百分比修正数据
			ModAddValues = ModAddValues, -- Mod固定值修正数据
			TotalValues = TotalValues, -- 总数据 --> 战斗内的BaseValues
		}
		-- PrintTable({WeaponId = self.WeaponId, BattleAttrs = BattleAttrs}, 4, 'WeaponBattleAttrs')
		return BattleAttrs
	end

	function Weapon:CalcAddAttrs(Avatar, BaseValues, ModRateValues, ModAddValues)
		-- 计算武器对自身的属性加成
		local AddData = self:BattleData()
		if not AddData.AddAttrs then
			return
		end

		for Index, AttrData in pairs(AddData.AddAttrs) do
			if not AttrData.IsCharAttr then
				local UniqueName = table.concat({"Weapon:[",self.WeaponId,"]AddAttrs:[",Index,"]"})
				self:CalcOneAttrData(BaseValues, ModRateValues, ModAddValues, AttrData, 1, UniqueName)
			end
		end
	end

	function Weapon:CalcCharAddAttrs(BaseValues, ModRateValue, ModAddValues)
		-- 计算武器给角色的属性加成
		local AddData = self:BattleData()
		if not AddData.AddAttrs then
			return
		end
		for Index, AttrData in pairs(AddData.AddAttrs) do
			if AttrData.IsCharAttr then
				local UniqueName = table.concat({"Weapon:[",self.WeaponId,"]AddAttrs:[",Index,"]"})
				self:CalcOneAttrData(BaseValues, ModRateValue, ModAddValues, AttrData, 1, UniqueName)
			end
		end
	end

	-- -- 计算单次属性加成
	function Weapon:CalcOneAttrData(BaseValues, ModRateValues, ModAddValues, AttrData, UniteNum, UniqueName)
		local AttrName = AvatarUtils:GetAttrNameFromAttrData(AttrData, UniqueName)

		if AttrName == 'ATK' then
			for _AttrName, _ in pairs(DataMgr.Attribute) do
				-- CommonConst.RateIndex.GlobalATK 总攻击力乘区
				self:CalcOneAttrs("ATK_" .. _AttrName, BaseValues, ModRateValues, CommonConst.RateIndex.GlobalATK, ModAddValues, AttrData, UniteNum)
			end
		else
			-- CommonConst.RateIndex.Default 默认乘区
			self:CalcOneAttrs(AttrName, BaseValues, ModRateValues, CommonConst.RateIndex.Default, ModAddValues, AttrData, UniteNum)
		end
	end

	function Weapon:CalcOneAttrs(AttrName, BaseValues, ModRateValues, RateIndex, ModAddValues, AttrData, UniteNum)
		if AttrData.Rate then
			if not ModRateValues[AttrName] then
				ModRateValues[AttrName] = {}
			end
			ModRateValues = ModRateValues[AttrName]
			--DebugPrint("@zyh CalcOneAttrs", type(AttrData.Rate), AttrData.Rate, self.WeaponId)
			-- 乘区
			if type(AttrData.Rate) == "number" then
				ModRateValues[RateIndex] = (ModRateValues[RateIndex] or 0) + (AttrData.Rate + (AttrData.LevelGrow or 0) * self.Level + (AttrData.GradeGrow or 0) * (self.GradeLevel + 1)) * (UniteNum or 1)
				-- PrintTable({Ratw=1,AttrName=AttrName,V=ModRateValues[AttrName],L=self.Level})
			else
				--DebugPrint(self.WeaponId, "号武器从SkillGrow表拿信息")
				local _AttrData = SkillUtils.GrowProxyBySkillLevel('BattleWeapon', self.WeaponId, self.GradeLevel + 1, AttrData)
				ModRateValues[RateIndex] = (ModRateValues[RateIndex] or 0) + _AttrData.Rate * (UniteNum or 1)
			end
		end
		if AttrData.Value then
			if type(AttrData.Value) == "number" then
				ModAddValues[AttrName] = (ModAddValues[AttrName] or 0) + (AttrData.Value + (AttrData.LevelGrow or 0) * self.Level + (AttrData.GradeGrow or 0) * (self.GradeLevel + 1)) * (UniteNum or 1)
			else
				local _AttrData = SkillUtils.GrowProxyBySkillLevel('BattleWeapon', self.WeaponId, self.GradeLevel + 1, AttrData)
				ModAddValues[AttrName] = (ModAddValues[AttrName] or 0) + _AttrData.Value * (UniteNum or 1)
			end 
		end
	end

	function Weapon:CalcExcelWeaponAttr(Avatar, ModRateValues, Char)
		-- 计算得意武器
		if not Char then
			return
		end
		local BattleInfo = Char:BattleData()
		local ExcelWeaponTags = BattleInfo.ExcelWeaponTags
		if not ExcelWeaponTags then
			return
		end

		for _, ExcelWeaponTag in pairs(ExcelWeaponTags) do
			if self:HasTag(ExcelWeaponTag) then
				local ExcelWeaponRate = BattleInfo.ExcelWeaponRate
				for _AttrName, _ in pairs(DataMgr.Attribute) do
					local AttrName = "ATK_" .. _AttrName
					if not ModRateValues[AttrName] then
						ModRateValues[AttrName] = {}
					end
					ModRateValues[AttrName][CommonConst.RateIndex.ExcelWeapon] = (ModRateValues[AttrName][CommonConst.RateIndex.ExcelWeapon] or 0) + ExcelWeaponRate
				end
				return
			end
		end
	end

	function Weapon:HasTag(_WeaponTag)
		local WeaponTags = self:GetTags()
		return WeaponTags and WeaponTags[_WeaponTag]
	end

	function Weapon:GetTags()
		if not self.WeaponTags then
			local BattleInfo = self:BattleData()
			if (not BattleInfo) then
				return false
			end
			local WeaponTag = BattleInfo.WeaponTag
			if not WeaponTag then
				return false
			end
			self.WeaponTags = {}
			for k,v in pairs(WeaponTag) do
				self.WeaponTags[v] = true
			end
		end
		return self.WeaponTags
	end

	function Weapon:FillCardValues(CardValues, CardLevelValues, AttrName, CardValue, LevelGrowAttrName)
		CardValue = CardValue or self:GetDefaultAttrValue(AttrName)
		if not CardValue then
			return
		end
		CardValues[AttrName] = CardValue
		CardLevelValues[AttrName] = self:GetAttrLevelGrow(LevelGrowAttrName)
	end

	function Weapon:DumpCardValues()
		local CardValues = {}
		local CardLevelValues = {}
		local BattleInfo = self:BattleData()


		local WeaponAttrDisplay = nil
		if self:HasTag("Melee") then
			WeaponAttrDisplay = "MeleeWeaponAttrDisplay"
		elseif self:HasTag("Ranged") then
			WeaponAttrDisplay = "RangedWeaponAttrDisplay"
		end
		if WeaponAttrDisplay then
			local DefaultInfo = self:BattleDefaultData()
			-- 如果这个属性是“永远显示”或是“修改后显示”那么就需要填值
			for AttrName, AttrData in pairs(DefaultInfo) do
				if AttrData[WeaponAttrDisplay] == "AlwaysTrue" or AttrData[WeaponAttrDisplay] == "OnlyModified" then
					self:FillCardValues(CardValues, CardLevelValues, AttrName, BattleInfo[AttrName], AttrName)
				end
			end
		end
		
		for _, AttrName in pairs(self.Attrs) do
			self:FillCardValues(CardValues, CardLevelValues, AttrName, BattleInfo[AttrName], AttrName)
		end

		for _AttrName, _ in pairs(DataMgr.Attribute) do
			local AttrName = "ATK_" .. _AttrName
			self:FillCardValues(CardValues, CardLevelValues, AttrName, BattleInfo[AttrName], "ATK")
		end

		local Attribute = BattleInfo.Attribute
		if Attribute then
			self:FillCardValues(CardValues, CardLevelValues, "ATK_" .. Attribute, BattleInfo["ATK"], "ATK")
		end

		return CardValues, CardLevelValues
	end

	function Weapon:GetAttrLevelGrow(AttrName)
		local BattleInfo = self:BattleData()
		local LevelGrow = BattleInfo[AttrName .. "LevelGrow"]
		if not LevelGrow then
			return
		end
		local LevelUpInfo = self:LevelUpData()
		local GrowFactor = LevelUpInfo[LevelGrow]
		return GrowFactor
	end

	function Weapon:HasApplicationType(ApplicationType)
		for _, value in ipairs(self.ModApplicationType) do
			if ApplicationType == value then
				return true
			end
		end
		return false
	end

	--计算武器升级所需狗粮数量，溢出经验和数量最少
	function Weapon:CalculateWeaponLevelUpResources(ExpNeed,ExpResources)
		table.sort(ExpResources, function(a, b)
			return a.UseParam > b.UseParam
		end)
		local Length=#ExpResources
		local ExpSum=0
		local Counts={}
		local Res = {ResourceUse = {},ExpConsume = 0}  --返回的计算结果
		for i=1,Length do
			Res.ResourceUse[i] = {}
			Res.ResourceUse[i].ResourceId = ExpResources[i].ResourceId
			Res.ResourceUse[i].Count = 0
			Counts[i] = 0
		end
		local MinOverflow = ExpResources[1].UseParam
		for i=1,Length do
			local num = ExpNeed // ExpResources[i].UseParam
			if(ExpResources[i].Count <= num)then
				ExpSum = ExpSum + ExpResources[i].Count * ExpResources[i].UseParam
				Counts[i] = ExpResources[i].Count
				ExpNeed = ExpNeed - ExpResources[i].Count * ExpResources[i].UseParam
			else
				ExpSum = ExpSum + (num + 1) * ExpResources[i].UseParam
				Counts[i] = (num + 1)
				ExpNeed = ExpNeed - (num + 1) * ExpResources[i].UseParam
			end
			if(ExpNeed < 0)then
				if(MinOverflow > -ExpNeed)then
					for i=1,Length do
						Res.ResourceUse[i].Count = Counts[i]
					end
					Res.ExpConsume = ExpSum
					MinOverflow = -ExpNeed
				end
				ExpNeed = ExpNeed + ExpResources[i].UseParam
				Counts[i] = Counts[i] - 1
				ExpSum = ExpSum - ExpResources[i].UseParam
			end
			if(ExpNeed == 0)then
				for j=1,Length do
					Res.ResourceUse[j].Count = Counts[j]
				end
				Res.ExpConsume = ExpSum
				return Res
			end
		end
		return Res
	end

	function Weapon:GetSimpleInfo(Avatar)
		local ModSlots = {}
		for ModSlotId, ModSlotEid in pairs(self:GetModSuit(self.ModSuitIndex)) do
			local ModSlotInfo = {
				SlotId = ModSlotId,
				Status = self.ModSlotStatus[ModSlotId],
				Polarity = self.ModSlotPolarity[ModSlotId],
			}
			local mod = Avatar.Mods[ModSlotEid]
			if mod then
				ModSlotInfo.ModId = mod.ModId
				ModSlotInfo.Level = mod.Level
			end
			ModSlots[ModSlotId] = ModSlotInfo
		end
		return {
			WeaponId = self.WeaponId,
			Level = self.Level,
			EnhanceLevel = self.EnhanceLevel,
			GradeLevel = self.GradeLevel,
			-- Skills = self.Skills:all_dump(self.Skills),
			ModSlots = ModSlots,
		}
	end

	function Weapon:ResetAssisterId()
		self.AssisterId = 0
	end

	-- 检查是否是MagazineCapacity属性 且表里填了不受影响
	function Weapon:CheckUnconstrainedMCByMod(ModRateValues, ModAddValues)
		local WeaponInfo = self:BattleData()
		if WeaponInfo.UnconstrainedMC then
			ModRateValues["MagazineCapacity"] = nil
			ModAddValues["MagazineCapacity"] = nil
		end
	end

	FormatProperties(Weapon)


local WeaponDict = Class("WeaponDict", CustomTypes.CustomDict)
	WeaponDict.KeyType = BaseTypes.ObjId
	WeaponDict.ValueType = Weapon
	WeaponDict.META_LIMIT = 50

	function WeaponDict:NewWeapon(Uuid, WeaponId, Level)
		local weapon = Weapon(Uuid, WeaponId, Level)
		return weapon
	end

	function WeaponDict:LoadWeapon(Value)
		local weapon = Weapon()
		return weapon:load(Value)
	end

---@class UWeapon:Weapon
local UWeapon = Class("UWeapon", Weapon)
	UWeapon.__Props__ = {
		-- uuid
		Uuid = prop.prop("ObjId", "client save"),
		-- 武器id
		WeaponId = prop.prop("Int", "client save"),
		-- 经验
		Exp = prop.prop("Int", "client"),
		-- 等级
		Level = prop.prop("Int", "client", 1),
		-- 状态
		Status = prop.prop("Int", "client", 0),  -- 0:解锁，1:锁定
		-- 突破等级
		EnhanceLevel = prop.prop("Int", "client", 0),
		-- 阶级
		GradeLevel = prop.prop("Int", "client", 0),
		-- Mod槽极性
		ModSlotPolarity = prop.prop("IntList", "client"),
		-- Mod槽状态
		ModSlotStatus = prop.prop("IntList", "client"),
		-- Mod配置
		ModSuit_1 = prop.prop("ObjectIdList", "client"),
		ModSuit_2 = prop.prop("ObjectIdList", "client"),
		ModSuit_3 = prop.prop("ObjectIdList", "client"),
		-- 生效的Mod配置Index
		ModSuitIndex = prop.prop("Int", "client", 1),
		
		-- Mod套装名
		ModSuitsName  = prop.prop("StrList", "client save"),
		-- Mod容量
		ModVolume = prop.getter("WeaponLevelData", "ModVolume"),

		-- 继承技能等级
		InheritSkillLevel = prop.prop("Int", "client", 1),
		-- 继承技能额外等级
		InheritSkillExtraLevel = prop.prop("Int", "client", 0),

		-- 武器名
		WeaponName = prop.getter("Data", "WeaponName"),
		-- 描述
		WeaponDescribe = prop.getter("Data", "WeaponDescribe"),
		-- 武器稀有度
		WeaponRarity = prop.getter("Data", "WeaponRarity"),
		-- 武器标签
		WeaponTag = prop.getter("BattleData", "WeaponTag"),
		-- Mod适用类型
		ModApplicationType = prop.getter("BattleData", "ModApplicationType"),

		--武器的最大等级
		MaxLevel = prop.getter("Data", "WeaponMaxLevel"),
	}

	function UWeapon:Data()
		local UWData = DataMgr.UWeapon[self.WeaponId]
		if not UWData then
			if self.Uuid == -1 then
				UWData = DataMgr.BattleWeapon[self.WeaponId]
			elseif not skynet then
				DebugPrint("ERROR::", string.format("显赫武器Id%s 无效，先更新，不要用老号，用新号重试，还有问题就找策划检查下UWeapon表修改是否同步双端",self.WeaponId))
			end
		end
		return UWData
	end
	--突破后解锁显赫武器mod槽位
	function UWeapon:UnlockModSlotAfterUWeaponBreakUp()
		local WeaponInfo = DataMgr.UWeapon[self.WeaponId]
		if WeaponInfo and WeaponInfo.ModSlotUnlock then
			for ModSlotId = 1, #WeaponInfo.ModSlotUnlock do
				if WeaponInfo.ModSlotUnlock[ModSlotId] <= self.EnhanceLevel then
					AvatarUtils:UnLockModSlot(self, ModSlotId)
				end
			end
		end
	end

	function UWeapon:WeaponSkillLevelInheritCharSkillLevel(Skill)
		local WeaponData = DataMgr.BattleWeapon[self.WeaponId]
		if WeaponData and WeaponData.InheritSkillId and Skill.SkillId == WeaponData.InheritSkillId then
			self.InheritSkillLevel = Skill.Level
			self.InheritSkillExtraLevel = Skill.ExtraLevel
		end
	end
	function UWeapon:BattleData()
		return DataMgr.BattleWeapon[self.WeaponId]
	end

	function UWeapon:GetSkillLevel()
		return self.InheritSkillLevel + self.InheritSkillExtraLevel
	end

	FormatProperties(UWeapon)


local UWeaponDict = Class("UWeaponDict", CustomTypes.CustomDict)
	UWeaponDict.KeyType = BaseTypes.ObjId
	UWeaponDict.ValueType = UWeapon
	UWeaponDict.META_LIMIT = 50

	function UWeaponDict:NewWeapon(Uuid, WeaponId, Level)
		local weapon = UWeapon(Uuid, WeaponId, Level)
		return weapon
	end


return {
	Weapon = Weapon,
	WeaponDict = WeaponDict,
	UWeapon = UWeapon,
	UWeaponDict = UWeaponDict
}

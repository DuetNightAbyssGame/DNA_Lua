local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties

---@class Char:CustomAttr
local Char = Class("Char", CustomTypes.CustomAttr)
	Char.__Props__ = {
		-- uuid
		Uuid = prop.prop("ObjId", "client save"),
		-- 角色id
		CharId = prop.prop("Int", "client save"),
		-- 经验
		Exp = prop.prop("Int", "client save"),
		-- 等级
		Level = prop.prop("Int", "client save", 1),
		-- 突破等级
		EnhanceLevel = prop.prop("Int", "client save", 0),
		-- 阶级
		GradeLevel = prop.prop("Int", "client save", 0),
		-- 额外阶级
		ExtraGradeLevel = prop.prop("Int", "client save", 0),
		-- Mod槽极性
		ModSlotPolarity = prop.prop("IntList", "client save"),
		-- Mod槽状态
		ModSlotStatus = prop.prop("IntList", "client save"),
		-- Mod配置
		ModSuit_1 = prop.prop("ObjectIdList", "client save"),
		ModSuit_2 = prop.prop("ObjectIdList", "client save"),
		ModSuit_3 = prop.prop("ObjectIdList", "client save"),
		-- 生效的Mod配置Index
		ModSuitIndex = prop.prop("Int", "client save", 1),
		-- Mod容量
		ModVolume = prop.getter("CharLevelData", "ModVolume"),
		-- Mod套装名
		ModSuitsName  = prop.prop("StrList", "client save", ""),
		-- 额外的Mod容量
		ExtralModVolumes = prop.prop("IntList", "client save"),
		-- 技能
		Skills = prop.prop("Skill.SkillList", "client save"),
		--技能树
		SkillTree = prop.prop("Skill.SkillTree","client save"),
		-- 显赫武器
		ProminentWeapon = prop.prop("ObjId", "client save"),
		-- 显赫武器新，迭代完后上面的可删除
		UWeaponEids = prop.prop("ObjectIdList", "client save"),
		-- 角色名
		CharName = prop.getter("Data", "CharName"),
		-- 角色模型编号
		ModelId = prop.getter("Data", "ModelId"),
		-- 战斗角色编号
		RoleId = prop.getter("Data", "RoleId"),
		-- 稀有度
		CharRarity = prop.getter("Data", "CharRarity"),
		-- Mod适用类型
		ModApplicationType = prop.getter("BattleData", "ModApplicationType"),
		-- 默认近战武器
		MeleeWeapon = prop.getter("Data", "MeleeWeapon"),
		-- 默认远程武器
		RangedWeapon = prop.getter("Data", "RangedWeapon"),
		-- 显赫武器WeaponId
		UltraWeapon = prop.getter("BattleData", "UltraWeapon"),
		-- 显赫武器新，迭代完后上面的可删除
		UWeapon = prop.getter("Data", "UWeapon"),  -- UWeaponId list
		-- 角色的最大等级
		MaxLevel = prop.getter("Data", "CharMaxLevel"),
		-- 当前外观
		CurrentAppearanceIndex = prop.prop("Int", "client save", 1),
		-- 外观配置
		AppearanceSuits = prop.prop("Appearance.AppearanceList", "client save"),
		-- 默认装备配饰
		CharAccessory = prop.getter("Data", "AccessoryId"),
		-- 派遣标签
		DispatchTag = prop.getter("Data", "DispatchTag"),
		-- 派遣解锁
		DispatchUnlock = prop.getter("Data", "DispatchUnlock"),
		-- 默认皮肤
		DefaultSkinId = prop.getter("Data", "DispatchUnlock"),
		-- 默认配饰
		DefaultAccessory = prop.getter("Data", "DefaultAccessory"),
	}

	function Char:Init(Uuid, CharId, Level)
		if not Uuid or not CharId then return end
		self.Uuid = Uuid
		self.CharId = CharId
		self:SetLevel(Level or 1)
		-- 初始化Mod配置
		self:InitModConfig()
		--如果是临时角色，直接使用CharId获取战斗信息
		self:HandleBattleCharInfo()
		self:InitSkillTree()
		if CharId then
			self:_Init()
		end
		self:InitAppearance()
	end

	function Char:HandleBattleCharInfo()
		local BattleCharInfo = DataMgr.BattleChar[self.RoleId]
		if BattleCharInfo and BattleCharInfo.SkillList then
			for index, SkillId in ipairs(BattleCharInfo.SkillList) do
				local skill = self.Skills:NewSkill(SkillId, 1,0)
				self.Skills:Append(skill)
			end
		end
	end

	function Char:GetModInitCount()
		local InitCount = 3
		if DataMgr.GlobalConstant.ModPlanMaxSuitCount then
			if DataMgr.GlobalConstant.ModPlanMaxSuitCount.ConstantValue ~= nil and DataMgr.GlobalConstant.ModPlanMaxSuitCount.ConstantValue > 0 then
				InitCount = DataMgr.GlobalConstant.ModPlanMaxSuitCount.ConstantValue
			end
		end
		return InitCount
	end


	function Char:InitModConfig()
		local CharInfo = self:Data()
		if not CharInfo then return end
		local ModSlot = CharInfo.ModSlot
		local ModSlotUnlock = CharInfo.ModSlotUnlock
		if not ModSlot or not ModSlotUnlock then return end
		local InitCount = self:GetModInitCount()
		for i = 1, InitCount, 1 do
			self.ModSuitsName:Append("")
			self.ExtralModVolumes:Append(0)
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
	function Char:GetCurrentExtralModVolume()
		return self.ExtralModVolumes[self.ModSuitIndex] or 0
	end

	function Char:GetModVolume()
		return self.ModVolume + (self.ExtralModVolumes[self.ModSuitIndex] or 0)
	end

	function Char:GetOriginlModVolume()
		return self.ModVolume
	end

	function Char:AddExtralModVolume(TargetVolume)
		if TargetVolume <= 0 then return end
		self.ExtralModVolumes[self.ModSuitIndex] = (self.ExtralModVolumes[self.ModSuitIndex] or 0)  + TargetVolume
	end

	function Char:SetExtralModVolume(TargetVolume, ModSuitIndex)
		if TargetVolume < 0 then return end
		self.ExtralModVolumes[ModSuitIndex]  = TargetVolume
	end

	function Char:ReduceExtralModVolume(TargetVolume, ModSuitIndex)
		if TargetVolume < 0 then return end
		self.ExtralModVolumes[ModSuitIndex]  = (self.ExtralModVolumes[ModSuitIndex] or 0) - math.min(TargetVolume, (self.ExtralModVolumes[ModSuitIndex] or 0) )
	end

	function Char:GetCurrentUnlockDispatchTag(CurrentUnlockDispatch)
		CurrentUnlockDispatch = CurrentUnlockDispatch or {}
		for i = 1, #self.DispatchUnlock do
			if self.EnhanceLevel >= self.DispatchUnlock[i] then
				if self.DispatchTag[i] then
					if not CurrentUnlockDispatch[self.DispatchTag[i]] then
						CurrentUnlockDispatch[self.DispatchTag[i]] = 0
					end
					CurrentUnlockDispatch[self.DispatchTag[i]] = CurrentUnlockDispatch[self.DispatchTag[i]] + 1
				end
			end
		end
		return CurrentUnlockDispatch
	end

	function Char:InitSkillTree()
		local TreeInfo = DataMgr.SkillTree[self.CharId]
		if not TreeInfo then return end
		for TreeIndex = 1, CommonConst.CharSkillTreeCount, 1 do
			if TreeInfo["Skill"..TreeIndex] then
				local SkillTreeNodes = self.SkillTree:NewSkillTreeNodes()
				for NodeId = 1, CommonConst.CharSkillTreeCount, 1 do
					if TreeInfo["Skill"..TreeIndex][NodeId] then
						local NodeData = TreeInfo["Skill"..TreeIndex][NodeId]
						local IsSkill = 0
						local IsLocked
						local Id = -1
						--表里有数据代表初始化时锁定，无数据代表解锁
						if DataMgr.SkillTreeNode2SkillTreeUnlock[self.CharId] 
						and DataMgr.SkillTreeNode2SkillTreeUnlock[self.CharId][TreeIndex]
						and DataMgr.SkillTreeNode2SkillTreeUnlock[self.CharId][TreeIndex][NodeId] then
							IsLocked = 1
						else
							IsLocked = 0
						end
						if NodeData['Skill'] then
							Id = NodeData['Skill']
						elseif NodeData['Attr'] then
							Id = NodeData['Attr']
							IsSkill = 1
						end
						if Id ~= -1 then
							local SkillTreeNode = SkillTreeNodes:NewSkillTreeNode(Id,IsSkill,IsLocked)
							SkillTreeNodes:Append(SkillTreeNode)
						end
					end
				end
				self.SkillTree:Append(SkillTreeNodes)
			end
		end
	end

	--获取节点是否已激活，三层，三节点；树下标，节点下标
	function Char:CheckSkillTreeNodeIsActive(TreeIndex,NodeIndex)
		if not TreeIndex or not NodeIndex then
			return false
		end
		local SkillTreeNode = self.SkillTree[TreeIndex][NodeIndex]
		if SkillTreeNode then
			return not SkillTreeNode:IsLocked()
		end
		return false
	end

	--激活技能树节点
	function Char:ActivateSkillTreeNode(TreeIndex,NodeIndex)
		if not TreeIndex or not NodeIndex then
			return
		end
		local SkillTreeNode = self.SkillTree[TreeIndex][NodeIndex]
		if SkillTreeNode and SkillTreeNode:IsLocked() then
			SkillTreeNode:UnLock()
		end
	end

	--检测技能树是否锁定，true-锁定，false-已解锁
	function Char:CheckSkillIsLocked(SkillId)
		for _, NodeList in ipairs(self.SkillTree) do
			for _, Node in ipairs(NodeList) do
				if Node:IsSkill() and SkillId == Node.TargetId then
					if Node:IsLocked() then --技能解锁依赖对应技能树节点是否解锁
						return true
					end
				end
			end
		end
		return false
	end

	function Char:InitAppearance()
		for i = 1, 3, 1 do
			self.AppearanceSuits:AddCharAppearance(self.CharId)
		end
	end

	function Char:_Init()
		AvatarUtils:RebuildModSuit(self)
		self:UpdateSkill()
	end

	function Char:GetName()
		return GText(self.CharName)
	end

	function Char:Data()
		local CData = DataMgr.Char[self.CharId]
		if not CData then
			--如果是临时角色，直接从BattleChar获取信息
			CData = DataMgr.BattleChar[self.CharId]
			if not CData and not skynet then
				DebugPrint("ERROR::", string.format("角色Id%s 无效，先更新，不要用老号，用新号重试，还有问题就找策划检查下Char表修改是否同步到双端", self.CharId))
			end
		end
		return CData
	end

	function Char:BattleData()
		return DataMgr.BattleChar[self.RoleId]
	end

	function Char:BattleDefaultData()
		return DataMgr.BattleCharAttr
	end

	function Char:CharAddonAttrData()
		return DataMgr.CharAddonAttr
	end

	function Char:CharLevelData()
		return DataMgr.LevelUp[self.Level]
	end

	function Char:LevelUpData(level)
		level = level or self.Level
		return DataMgr.LevelUp[level]
	end

	function Char:GetModSuit(SuitIndex)
		if not SuitIndex then 
			SuitIndex = self.ModSuitIndex
		end
		if skynet then
			return AvatarUtils:GetTargetModSuit(self, SuitIndex) 
		else
			return self.ModSuits[SuitIndex]
		end
	end

	function Char:GetModSuitCost(SuitIndex)
		if not SuitIndex then 
			SuitIndex = self.ModSuitIndex
		end
		return self.ModSuitsCostMap[SuitIndex] or 0
	end

	function Char:SetModSuitCost(Cost,SuitIndex)
		if not SuitIndex then 
			SuitIndex = self.ModSuitIndex
		end
		self.ModSuitsCostMap[SuitIndex] = Cost
	end

	function Char:AddExp(Count)
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
		while info and (_level + 1) <= #DataMgr.LevelUp and _exp >= info.CharLevelMaxExp and _level < current_max_level do
			_exp = _exp - info.CharLevelMaxExp
			_level = _level + 1
			info = self:LevelUpData(_level)
		end

		if _level >= self:GetCurrentMaxLevel() then
			_exp = 0
		end
		self.Exp = _exp
		self:SetLevel(_level)
		local Result = {}
		Result["LevelUp"] = {OldLevel, self.Level}
		return Result
	end
	function Char:SetLevel(Level)
		if Level <= self.Level then return false end
		local LevelUpInfo = self:LevelUpData(Level)
		if not LevelUpInfo then return false end
		self.Level = Level
		return true
	end

	-- 突破后解锁角色mod槽位
	function Char:UnlockModSlotAfterCharBreakUp()
		local CharInfo = DataMgr.Char[self.CharId]
		if CharInfo and CharInfo.ModSlotUnlock then
			for i=1,#CharInfo.ModSlotUnlock do
				if CharInfo.ModSlotUnlock[i] <= self.EnhanceLevel then
					AvatarUtils:UnLockModSlot(self, i)
				end
			end
		end
	end

	function Char:HandleSetLevel(Level, NeedEnhance)
		if NeedEnhance == nil or NeedEnhance == 1 then
			NeedEnhance = true
		else
			NeedEnhance = false
		end
		local LevelUpInfo = DataMgr.LevelUp[Level]
		if LevelUpInfo then
			self.Level = Level
			local BreakInfo = DataMgr.CharBreak[self.CharId]
			local NewEnhanceLevel = 0
			if BreakInfo then
				for key ,value in pairs(BreakInfo) do
					if NeedEnhance then
						if Level >= value.CharBreakLevel then
							NewEnhanceLevel = math.max(NewEnhanceLevel,key)
						end
					else
						if Level > value.CharBreakLevel then
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

	function Char:GMSetLevel(Level, NeedEnhance)
		return self:HandleSetLevel(Level, NeedEnhance)
	end

	function Char:SetEnhanceLevel(EnhanceLevel)
		local BreakInfo = DataMgr.CharBreak[self.CharId][EnhanceLevel]
		if BreakInfo or EnhanceLevel == 0 then
			self.EnhanceLevel = EnhanceLevel
			local CharInfo = DataMgr.Char[self.CharId]
			if CharInfo and CharInfo.ModSlotUnlock then
				for i=1,#CharInfo.ModSlotUnlock do
					if CharInfo.ModSlotUnlock[i] <= self.EnhanceLevel then
						AvatarUtils:UnLockModSlot(self, i)
					end
				end
			end
			self:UpdateSkill()
			return true
		end
		return false
	end

	function Char:GMSetSkillLevel(level)
		for _, skill in ipairs(self.Skills) do
			skill:GMSetLevel(level)
		end
	end

	function Char:GetSkin(SkinId,Avatar)
		local CommonChar = Avatar and Avatar.CommonChars[self.CharId] or {OwnedSkins = {}}
		return CommonChar.OwnedSkins[SkinId]
	end

	function Char:GetHair(HairId,Avatar)
		local CommonChar = Avatar and Avatar.CommonChars[self.CharId] or {OwnedHairs = {}}
		return CommonChar.OwnedHairs[HairId]
	end

	Char.CommunityAttrs = {
		'MaxHp',
		'MaxES',
		'DEF',
		'MaxSp',
		'SkillRange',
		'SkillSustain',
		'SkillEfficiency',
		'SkillIntensity',
		'StrongValue',
		'EnmityValue',
	}

	function Char:GetCommunityData(Avatar)
		local ExtraInfo = {}
		ExtraInfo.ModSuit = self.ModSuitIndex
		AvatarUtils:InitModInfo(Avatar, ExtraInfo, self)
		local ReplaceAttrs = self:DumpBattleAttr(Avatar)
		local TotalValues = ReplaceAttrs.TotalValues
		local BattleInfo = self:BattleData()
		local ATK_AttrName = "ATK_" .. BattleInfo.Attribute
		local CommunityData = {
			ATK =TotalValues[ATK_AttrName],
			ExcelWeaponTags = BattleInfo.ExcelWeaponTags,
		}
		for _, AttrName in pairs(Char.CommunityAttrs) do
			CommunityData[AttrName] = TotalValues[AttrName]
		end
		return CommunityData
	end

	-- 副本、区域里需要加的东西放这里(目前主要和肉鸽做区分)
	function Char:BattleDump(Avatar, ExtraInfo)
		local ExtraInfo = ExtraInfo or {}
		AvatarUtils:InitModInfo(Avatar, ExtraInfo, self)
		local Result = {
			RoleId = self.RoleId,
			Level = self.Level,
			Exp = self.Exp,
			GradeLevel = self.GradeLevel,
			EnhanceLevel = self.EnhanceLevel,
			SkillInfos = self:DumpSkillInfos(Avatar, ExtraInfo),
			SkillTreeInfos = self:DumpSkillTreeInfos(Avatar, ExtraInfo),
			ModPassives = self:DumpPassiveEffects(Avatar, ExtraInfo),
			ReplaceAttrs = self:DumpBattleAttr(Avatar, ExtraInfo),
			AppearanceSuit = self:DumpAppearanceSuit(Avatar),
			ModData = AvatarUtils:DumpModData(ExtraInfo),
			SlotData = ExtraInfo.SlotData,
			ModSuitIndex = ExtraInfo.ModSuit,
		}
		return Result
	end

	function Char:DumpSkillInfos(Avatar, ExtraInfo)
		local ModData = ExtraInfo.ModData
		local IsPhantom = ExtraInfo.IsPhantom
		local Skills = {}
		for _, Skill in ipairs(self.Skills) do
			-- if not Skill:IsLocked() then
			if self:CheckSkillIsLocked(Skill.SkillId) then
				goto continue
			end
			local bOnlyPhantom = false
			local SkillData = DataMgr.Skill[Skill.SkillId][Skill.Level][self.GradeLevel]
			if SkillData then
				bOnlyPhantom = SkillData.OnlyPhantom
			end
			if not IsPhantom and bOnlyPhantom then
				goto continue
			end
			if SkillData then
				if SkillData.SkillType == "UltraPassive" and self.ExtraGradeLevel <= 0 then
					goto continue
				end
			end
			local SkillInfo = {}
			local Level, ExtraLevel = Skill:GetRealSkill()
			if Level ~= 1 then
			SkillInfo.Level = Level
			end
			if ExtraLevel and ExtraLevel ~= 0 then
			SkillInfo.ExtraLevel = ExtraLevel
		end
		if self.GradeLevel ~= 0 then
		SkillInfo.Grade = self.GradeLevel -- 角色阶级，就是技能阶级
		end
		-- Skills[Skill.SkillId] = SkillInfo
		table.insert(Skills, {SkillId = Skill.SkillId, SkillInfo = SkillInfo})
			-- end
			::continue::
			end
		if ModData then
			for _, Mod in pairs(ModData) do
				local ModData = Mod:Data()
				if ModData.ModActivateSkills then
					for SkillId1,SkillId2 in pairs(ModData.ModActivateSkills) do
						for _, Data in ipairs(Skills)do
							if Data.SkillId == SkillId1 then
								Data.SkillId = SkillId2
								break
							end
						end
						--if Skills[SkillId1] then
						--	Skills[SkillId2] = Skills[SkillId1]
						--	Skills[SkillId1] = nil
						--end
					end
				end
			end
		end

		return Skills
	end 
	
	function Char:DumpSkillTreeInfos(Avatar, ExtraInfo)
		local SkillTreeInfos = {}
		for BranchIdx, SkillTreeNodes in ipairs(self.SkillTree) do
			SkillTreeInfos[BranchIdx] = {}
			for NodeIdx, SkillNode in ipairs(SkillTreeNodes) do
				if NodeIdx ~= 1 then
					SkillTreeInfos[BranchIdx][NodeIdx] = {TargetId = SkillNode.TargetId,LockState = SkillNode.LockState}
				end
			end
		end
		return SkillTreeInfos
	end

	function Char:DumpPassiveEffects(Avatar, ExtraInfo)
		local ModData = ExtraInfo.ModData
		if not ModData then
			return {}
		end

		local PassiveEffects = {}
		local ModPolarityMap = {}
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
					for i = 1, #ModData.PassiveEffects do
						table.insert(PassiveEffects, {ModData.PassiveEffects[i], Mod.Level, ModData.SummonInherit})
					end
				end
			end
		end
		return PassiveEffects
	end

	function Char:DumpAccessorySuit(AppearanceSuit)
		local Accessories = AppearanceSuit and AppearanceSuit.Accessory
		if(not Accessories)then
			return
		end
		local AccessorySuit = {}
		local EquipAccessoryId
		for _, AccessoryTypeIndex in pairs(CommonConst.NewCharAccessoryTypes) do
			EquipAccessoryId = Accessories[AccessoryTypeIndex]
			if( EquipAccessoryId and EquipAccessoryId > 0)then
				AccessorySuit[AccessoryTypeIndex] = EquipAccessoryId
			end
		end
		return AccessorySuit
	end

	function Char:DumpAccessoryCustomParams(AppearanceSuit)
		local CustomParams = AppearanceSuit and AppearanceSuit.AccessoryCustomParams
		if(not CustomParams)then
			return
		end
		local AccessoryCustomParams = {}
		for key, value in pairs(CustomParams) do
			AccessoryCustomParams[key] = value
		end
		return AccessoryCustomParams
	end

	function Char:DumpAppearanceSuit(Avatar,AppearanceIndex)
		local AppearanceSuit = self.AppearanceSuits[AppearanceIndex or self.CurrentAppearanceIndex]
		local SkinId = AppearanceSuit and AppearanceSuit.SkinId
		local HairId = AppearanceSuit and AppearanceSuit.HairId
		return {
			AccessorySuit = self:DumpAccessorySuit(AppearanceSuit),
			AccessoryCustomParams = self:DumpAccessoryCustomParams(AppearanceSuit),
			IsShowPartMesh = self:DumpIsShowPartMesh(Avatar,SkinId),
			IsCornerVisible = self:DumpIsCornerVisible(AppearanceSuit),
			SkinId = SkinId,
			SkinLevel = self:DumpSkinLevel(Avatar, SkinId),
			HairId = HairId,
			Colors = self:DumpColors(Avatar,SkinId),
			HairColors = self:DumpHairColors(Avatar,HairId),
			CharId = self.CharId,
		}
	end

	function Char:DumpSkinLevel(Avatar,SkinId)
		if(not Avatar or not Avatar.CommonChars)then
			return 1
		end
		local CommonChar = Avatar.CommonChars[self.CharId]
        local Skin = CommonChar and CommonChar.OwnedSkins[SkinId]
		if (not Skin) then
			return 1
		end
		return Skin.SelectedLevel
	end

	function Char:DumpColors(Avatar,SkinId)
		if(not Avatar or not Avatar.CommonChars)then
			return
		end
		local CommonChar = Avatar.CommonChars[self.CharId]
        local Skin = CommonChar and CommonChar.OwnedSkins[SkinId]
		if(not Skin)then
			return
		end
		local Colors = {}
		local CurrentColors = Skin:GetColors()
		for i, value in pairs(CurrentColors) do
			Colors[i] = value
		end
		return Colors
	end

	function Char:DumpHairColors(Avatar,HairId)
		if(not Avatar or not Avatar.CommonChars)then
			return
		end
		local CommonChar = Avatar.CommonChars[self.CharId]
        local Hair = CommonChar and CommonChar.OwnedHairs[HairId]
		if(not Hair)then
			return
		end
		local Colors = {}
		local CurrentColors = Hair:GetColors()
		for i, value in pairs(CurrentColors) do
			Colors[i] = value
		end
		return Colors
	end

	function Char:DumpIsShowPartMesh(Avatar,SkinId)
		if(not Avatar or not Avatar.CommonChars)then
			return
		end
		local CommonChar = Avatar.CommonChars[self.CharId]
        local Skin = CommonChar and CommonChar.OwnedSkins[SkinId]
		return Skin and Skin.IsShowPartMesh
	end

	function Char:DumpIsCornerVisible(AppearanceSuit)
		if(not AppearanceSuit or AppearanceSuit.IsCornerVisible == nil)then
			return true
		else
			return AppearanceSuit.IsCornerVisible
		end
	end

	function Char:SaLogDump(Avatar)
		local Mods = {}
		for ModSlotId, ModSlotEid in pairs(self:GetModSuit()) do
			local Mod = Avatar.Mods[ModSlotEid]
			if Mod then
				table.insert(Mods,{Mod.ModId,Mod.Level})
			end
		end
		local Skills = {}
		for _, Skill in ipairs(self.Skills) do
			table.insert(Skills,{Skill.SkillId,Skill.Level})
		end
		return Mods, Skills
	end

	Char.Attrs = {
		'MaxHp',
		'DEF',
		'MaxES',
		-- 'ATK',
		--'ESRecoverTime',
		--'ESSPD',
		--'CRI',
		--'CRD',
		--'SkillSpeed',
		--'Sp',
		'MaxSp',
		--'SpRecover',
		--'ESRates',
		--'HpRates',
		'SkillRange',
		'SkillSustain',
		'SkillEfficiency',
		'SkillIntensity',
		'SPD'
	}

	function Char:GetDefaultAttrValue(AttrName)
		local BattleInfo = self:BattleData()
		if BattleInfo[AttrName] then
			return BattleInfo[AttrName]
		end

		if not self.BattleCharAttr then
			self.BattleCharAttr = DataMgr.BattleCharAttr
		end
		local AttrData = self.BattleCharAttr[AttrName]
		if not AttrData then
			return 0
		end
		
		return AttrData.DefaultValue or 0
	end

	function Char:CalcTotalValue(CardValues, BaseValues, ModRateValues, ModAddValues)
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
				TotalValues[AttrName] = CommonUtils.AttrConvert[AttrName](TotalValues[AttrName])
			end
		end
		
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

		return TotalValues
	end

	function Char:CalcBaseValue(CardValues, CardLevelValues)
		local BaseValues = {}
		for AttrName, Value in pairs(CardValues) do
			BaseValues[AttrName] = Value * (CardLevelValues[AttrName] or 1)
		end
		return BaseValues
	end

	function Char:DumpDefaultBattleAttr(Avatar, ExtraInfo)
		ExtraInfo = ExtraInfo or {}
		ExtraInfo.ModSuit = self.ModSuitIndex
		AvatarUtils:InitModInfo(Avatar, ExtraInfo,self)
		local BattleAttrs = self:DumpBattleAttr(Avatar, ExtraInfo)
		return BattleAttrs
	end

	function Char:DumpBattleAttr(Avatar, ExtraInfo)
		local CardValues, CardLevelValues = self:DumpCardValues()
		local BaseValues = self:CalcBaseValue(CardValues, CardLevelValues)
		local ModRateValues = {}
		local ModAddValues = {}
		local ModPolarityMap = {}
		local ModMultiplier = {}
		
		ExtraInfo = ExtraInfo or {}
		local Mods = ExtraInfo.ModData or {}
		local ModUniteTypes = {}
		for _, Mod in pairs(Mods) do
			if Mod then
				local ModUniteType = Mod.ModUniteType
				if ModUniteType then
					ModUniteTypes[ModUniteType] = (ModUniteTypes[ModUniteType] or 0) + 1
				end
			end
		end
		
		-- 计算自身额外属性加成
		self:CalcAddonAttr(BaseValues, ModRateValues, ModAddValues)
		
		-- 计算宠物的属性修正倍率
		local Pet = ExtraInfo.Pet
		if Pet then
			Pet:CalcMultiplier(ModMultiplier)
		end

		-- 计算Mod的属性修正倍率
		for _, Mod in pairs(Mods) do
			Mod:CalcMultiplier(ModMultiplier)
		end

		-- 统计Mod的极性
		for _, Mod in pairs(Mods) do
			Mod:CountModPolarity(ModPolarityMap)
		end
		
		-- 计算宠物的属性加成
		if Pet then
			Pet:CalcAttrs(BaseValues, ModRateValues, ModAddValues, ModMultiplier)
		end
		
		-- 计算Mod的属性加成
		for _, Mod in pairs(Mods) do
			Mod:CalcAttrs(BaseValues, ModRateValues, ModAddValues, ModUniteTypes, ModMultiplier, ModPolarityMap)
		end

		-- 计算近战武器给角色的加成(如果有)
		local MeleeWeapon = ExtraInfo.MeleeWeapon
		if MeleeWeapon then
			MeleeWeapon:CalcCharAddAttrs(BaseValues, ModRateValues, ModAddValues)
		end
		-- 计算远程武器给角色的加成(如果有)
		local RangedWeapon = ExtraInfo.RangedWeapon
		if RangedWeapon then
			RangedWeapon:CalcCharAddAttrs(BaseValues, ModRateValues, ModAddValues)
		end
		local TotalValues = self:CalcTotalValue(CardValues, BaseValues, ModRateValues, ModAddValues)
		local BattleAttrs = {
			CardValues = CardValues, -- 默认等级数据
			CardLevelValues = CardLevelValues, -- 成长系数
			-- BaseValues = BaseValues, -- 当前等级数据
			ModRateValues = ModRateValues, -- Mod百分比修正数据
			ModAddValues = ModAddValues, -- Mod固定值修正数据
			TotalValues = TotalValues, -- 总数据 --> 战斗内的BaseValues
		}
		-- PrintTable(BattleAttrs, 3, 'CharacterBattleAttrs')
		return BattleAttrs
	end

	function Char:FillCardValues(CardValues, CardLevelValues, AttrName, CardValue, LevelGrowAttrName)
		CardValue = CardValue or self:GetDefaultAttrValue(AttrName)
		if not CardValue then
			return
		end
		CardValues[AttrName] = CardValue
		CardLevelValues[AttrName] = self:GetAttrLevelGrow(LevelGrowAttrName)
	end

	function Char:DumpCardValues()
		local CardValues = {}
		local CardLevelValues = {}
		local BattleInfo = self:BattleData()

		local DefaultInfo = self:BattleDefaultData()
		for AttrName, AttrData in pairs(DefaultInfo) do
			-- 如果这个属性是“永远显示”或是“修改后显示”且有默认值那么就需要FillCard
			if AttrData.RoleAttrDisplay == "AlwaysTrue" or AttrData.RoleAttrDisplay == "OnlyModified" then
				if DefaultInfo[AttrName].DefaultValue then
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

		self:FillCardValues(CardValues, CardLevelValues, "ATK_" .. BattleInfo.Attribute, BattleInfo["ATK"], "ATK")

		return CardValues, CardLevelValues
	end

	function Char:CalcAddonAttr(BaseValues, ModRateValues, ModAddValues)
		local BattleInfo = self:BattleData()
		local AddonAttrData = self:CharAddonAttrData()
		for _, NodeList in ipairs(self.SkillTree) do
			for _, Node in ipairs(NodeList) do
				if not Node:IsSkill() and not Node:IsLocked() then
					local AddonAttrId = Node.TargetId
					local OneAddonNode = AddonAttrData[AddonAttrId]
					if OneAddonNode and OneAddonNode.AddAttrs then
						local AttrData = OneAddonNode.AddAttrs
						local AttrName = AttrData.AttrName
						AttrName = AvatarUtils:GetAttrNameFromAttrData(AttrData)
						if AttrName == 'ATK' then
							for _AttrName, _ in pairs(DataMgr.Attribute) do
								if AttrData.Value then
									assert(nil, AddonAttrId .."号额外属性不允许使用Value增加ATK")
								end
								-- CommonConst.RateIndex.GlobalATK 总攻击力乘区
								self:CalcOneAttrs("ATK_" .. _AttrName, BaseValues, ModRateValues, CommonConst.RateIndex.GlobalATK, ModAddValues, AttrData)
							end
						else
							-- CommonConst.RateIndex.Default 默认乘区
							self:CalcOneAttrs(AttrName, BaseValues, ModRateValues, CommonConst.RateIndex.Default, ModAddValues, AttrData)
						end
					end
				end
			end
		end
	end
	
	function Char:CalcOneAttrs(AttrName, BaseValues, ModRateValues, RateIndex, ModAddValues, AttrData)
		if AttrData.Rate then
			if not ModRateValues[AttrName] then
				ModRateValues[AttrName] = {}
			end
			ModRateValues = ModRateValues[AttrName]
			-- 乘区
			local IncreaseRateValue
			if(type(AttrData.Rate) == "number") then
				IncreaseRateValue = AttrData.Rate
			else
				assert(nil, "额外属性不允许填写string")
				--local _AttrData = SkillUtils.GrowProxyBySkillLevel('Mod', self.ModId, self.Level, AttrData)
				--IncreaseRateValue = _AttrData.Rate * (UniteNum or 1)
			end
			
			ModRateValues[RateIndex] = (ModRateValues[RateIndex] or 0) + IncreaseRateValue
			-- PrintTable({Ratw=1,AttrName=AttrName,V=ModRateValues[AttrName],L=self.Level})
		end
		if AttrData.Value then
			local IncreaseValue
			if(type(AttrData.Value) == "number") then
				IncreaseValue = AttrData.Value
			else
				assert(nil, "额外属性不允许填写string")
				--local _AttrData = SkillUtils.GrowProxyBySkillLevel('Mod', self.ModId, self.Level, AttrData)
				--IncreaseValue = _AttrData.Value * (UniteNum or 1)
			end

			ModAddValues[AttrName] = (ModAddValues[AttrName] or 0) + IncreaseValue
		end
	end

	function Char:GetAttrLevelGrow(AttrName)
		local BattleInfo = self:BattleData()
		local LevelGrow = BattleInfo[AttrName .. "LevelGrow"]
		if not LevelGrow then
			return
		end
		local LevelUpInfo = self:LevelUpData()
		local GrowFactor = LevelUpInfo[LevelGrow]
		return GrowFactor
	end

	function Char:HasApplicationType(ApplicationType)
		for _, value in ipairs(self.ModApplicationType) do
			if ApplicationType == value then
				return true
			end
		end
		return false
	end

	function Char:UpdateSkill()
		for index, skill in ipairs(self.Skills) do
			skill:Update(self.GradeLevel, self.EnhanceLevel)
		end
	end

	function Char:GetSkill(SkillId)
		for index, skill in ipairs(self.Skills) do
			if skill.SkillId == SkillId then
				return skill
			end
		end
	end

	function Char:UpGradeLevel(TargetLevel)
		local MaxGradeLevel = DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue
		TargetLevel = TargetLevel or 1
		if self.GradeLevel == MaxGradeLevel or TargetLevel > MaxGradeLevel then
			return
		end
		self.GradeLevel = self.GradeLevel + TargetLevel
		self:UpdateSkill()
	end

	function Char:SetGradeLevel(TargetLevel)
		local MaxGradeLevel = DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue
		TargetLevel = TargetLevel or 1
		if TargetLevel > MaxGradeLevel or TargetLevel < 1 then
			return
		end
		self.GradeLevel = TargetLevel
		self:UpdateSkill()
	end

	-- 获取角色的有效阶级（含ExtraGradeLevel）
	function Char:GetEffectiveGradeLevel()
		local MaxGradeLevel = DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue
		if self.ExtraGradeLevel == 1 then
			return MaxGradeLevel + 1
		end
		return self.GradeLevel
	end

	-- 检查角色是否支持第7级
	function Char:HasUltraGradeLevel()
		return DataMgr.UltraCharCardLevelUp and DataMgr.UltraCharCardLevelUp[self.CharId] ~= nil
	end

	-- 检查ExtraGradeLevel是否已解锁
	function Char:IsExtraGradeLevelUnlocked()
		return self.ExtraGradeLevel == 1
	end

	-- 计算角色Ultra升阶（第7级）所需材料
	function Char:CalculateCharUltraGradeLevelUpResources()
		local Data = DataMgr.UltraCharCardLevelUp and DataMgr.UltraCharCardLevelUp[self.CharId]
		if not Data then return {} end
		local ResourceId = "ResourceId"
		local ResourceNum = "ResourceNum"
		local Idx = 1
		local Res = {}
		local Key = ResourceId..(tostring(Idx))
		local Value = ResourceNum..(tostring(Idx))
		while Data[Key] and Data[Value] do
			table.insert(Res, { Id = Data[Key], Num = Data[Value] })
			Idx = Idx + 1
			Key = ResourceId..(tostring(Idx))
			Value = ResourceNum..(tostring(Idx))
		end
		return Res
	end

	--判断角色是否满足突破等级
	function Char:CheckCurrentLevelOfBreakUpLevel()
		if self.Level == self:GetCurrentMaxLevel() then
			return true
		end
		return false
	end

	--获取当前阶段角色突破对应的最大等级
	function Char:GetCurrentMaxLevel()
		local CharBreakInfo = DataMgr.CharBreak[self.CharId]
		if not CharBreakInfo then
			return self.MaxLevel
		end
		local CharBreakLevelUpInfo = CharBreakInfo[self.EnhanceLevel + 1]
		if not CharBreakLevelUpInfo then
			return self.MaxLevel
		end
		return CharBreakLevelUpInfo.CharBreakLevel
	end

	--计算角色升级所需狗粮数量和经验消耗，溢出经验和数量最少
	function Char:CalculateCharLevelUpResources(ExpNeed,ExpResources)
		table.sort(ExpResources, function(a, b)
			return a.UseParam > b.UseParam
		end)
		local Length = #ExpResources
		local ExpSum = 0
		local Counts = {}
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

	function Char:GetSimpleInfo(Avatar)
		local ModSlots = {}
		for ModSlotId, ModSlotEid in pairs( AvatarUtils:GetTargetModSuit(self, self.ModSuitIndex)) do
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
			CharId = self.CharId,
			Level = self.Level,
			EnhanceLevel = self.EnhanceLevel,
			GradeLevel = self.GradeLevel,
			Skills = self.Skills:all_dump(self.Skills),
			ModSlots = ModSlots,
		}
	end

	--计算角色升阶所需材料
	function Char:CalculateCharGradeLevelUpResources(Data)
		local ResourceId = "ResourceId"
		local ResourceNum = "ResourceNum"
		local Idx = 1
		local Res = {}
		local Key = ResourceId..(tostring(Idx))
		local Value = ResourceNum..(tostring(Idx))
		while Data[Key] and Data[Value] do
			if Res[Key] == nil then
				Res[Data[Key]] = Data[Value]
			end
			Idx = Idx + 1
			Key = ResourceId..(tostring(Idx))
			Value = ResourceNum..(tostring(Idx))
		end
		return Res
	end

	function Char:GetAppearance(AppearanceIndex)
		return self.AppearanceSuits[AppearanceIndex or self.CurrentAppearanceIndex]
	end

	function Char:GetDefaultSkinId()
		return self:Data().DefaultSkinId or self.CharId
	end

	function Char:GetDefaultHairId()
		return self:Data().DefaultHairId or self.CharId
	end

	function Char:GetPartMeshAccessoryInfo(SkinId)
		local _SkinId = SkinId or self.CharId
		for AccessoryId, value in pairs(DataMgr.CharPartMesh) do
			if(value.PartName == "PartMesh")then
				local SkinIds = value.Skin or {}
				for _, Id in pairs(SkinIds) do
					if(Id == _SkinId)then
						return AccessoryId,value.AccessoryType
					end
				end
			end
		end
		return -1
	end

	FormatProperties(Char)

local CharDict = Class("CharDict", CustomTypes.CustomDict)
	CharDict.KeyType = BaseTypes.ObjId
	CharDict.ValueType = Char

	function CharDict:NewChar(Uuid, CharId, Level)
		local char = Char(Uuid, CharId, Level)
		return char
	end

	function CharDict:LoadChar(Value)
		local char = Char()
		return char:load(Value)
	end

return {Char = Char, CharDict = CharDict}

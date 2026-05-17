local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties
local SkillUtils = require "Utils.SkillUtils"

---@class Pet
local Pet = Class("Pet", CustomTypes.CustomAttr)
	---@type Pet
	Pet.__Props__ = {
		UniqueId = prop.prop("Int", "client save"),
		PetId = prop.prop("Int", "client save"),
		Level = prop.prop("Int", "client save",1),
		Exp = prop.prop("Int", "client save",0),
		BreakNum = prop.prop("Int", "client save",0),
		IsLock = prop.prop("Bool", "client save",false),
		Entry = prop.prop("IntList", "client save",{}),
		Name = prop.prop("Str", "client save",""),
	}
	function Pet:Init(PetId,UniqueId)
		self.PetId = PetId
        self.UniqueId = UniqueId
	end
	function Pet:Data()
		local Data = DataMgr.Pet[self.PetId]
		if not Data and not skynet then
			DebugPrint("ERROR::",  "宠物ID: "..self.PetId.."没有Pet配置，先更新，不要用老号，用新号重试，还有问题就找策划检查下Pet表修改是否同步到双端")
		end
		return Data
	end

	function Pet:GetName()
		return GText(self:Data().Name)
	end

	function Pet:BreakData()
		local BreakData = DataMgr.PetBreak[self.PetId]
		if not BreakData and not skynet then
			DebugPrint("ERROR::", "宠物ID: "..self.PetId.."没有PetBreak配置，先更新，不要用老号，用新号重试，还有问题就找策划检查下Pet表修改是否同步到双端")
		end
		return BreakData
	end

	function Pet:LevelUpData(Level)
		if Level == 0 then return {PetLevel=0, PetLevelMaxExp = 0} end
		local LevelUpData = DataMgr.PetLevelUp[Level and Level or self.Level]
		if not LevelUpData and not skynet then
			DebugPrint("ERROR::", "宠物等级: "..Level or self.Level.."没有PetLevelUp配置，先更新，不要用老号，用新号重试，还有问题就找策划检查下Pet表修改是否同步到双端")
		end
		return LevelUpData
	end

	---判断当前等级是否达到下个突破阶段的最大等级
	function Pet:IsMaxLevelBeforeBreak()
		return self.Level >= self:GetMaxLevel()
	end

	---是否达到最大突破
	function Pet:IsMaxBreak()
		local BreakConf = self:BreakData()
		return self.BreakNum >= #BreakConf
	end

	---是否达到最终的最大等级
	function Pet:IsFinalMaxLevel()
		local Data = self:Data()
		local BreakConf = self:BreakData()
		local NextBreak = BreakConf[self.BreakNum+1]
		if NextBreak then
			return false
		end
		return self.Level >= Data.PetMaxLevel
	end

	---获取下个突破阶段的最大等级
	function Pet:GetNextMaxLevel()
		local BreakConf = self:BreakData()
		local NextBreak = BreakConf[self.BreakNum+1]
		if NextBreak and NextBreak.PetBreakLevel then 
			return NextBreak.PetBreakLevel
		else 
			local Data = self:Data()
			return Data.PetMaxLevel
		end
	end

	---获取当前突破阶段的最大等级
	function Pet:GetMaxLevel()
		local BreakConf = self:BreakData()
		local NowBreak = BreakConf[self.BreakNum]
		if NowBreak and NowBreak.PetBreakLevel then 
			return NowBreak.PetBreakLevel
		else 
			local Data = self:Data()
			return Data.PetMaxLevel
		end
	end

	function Pet:GetMaxExp()
		local LevelUpData = self:LevelUpData()
		return LevelUpData.PetLevelMaxExp
	end

	function Pet:GetPreviewLevelByExp(PreviewExp)
		local TempPreview = PreviewExp
		local PreviewLevel = self.Level
		--@todo 可以考虑优化为二分查找
		for Level = self.Level, #DataMgr.PetLevelUp do
            if TempPreview < self:LevelUpData(Level).PetLevelMaxExp then break end
            PreviewLevel = PreviewLevel +1
			TempPreview = TempPreview - self:LevelUpData(Level).PetLevelMaxExp
        end
		return PreviewLevel
	end

	function Pet:GetSkillLevel(BreakNum)
		return (BreakNum or self.BreakNum) +1
	end

	-- 对应BattlePet表里的表头：宠物技能等级提升，代表计算SkillLevel时要加多少
	function Pet:GetSkillLevelUp()
		if self.SkillLevelUp then
			return self.SkillLevelUp
		else
			local SkillLevelUp = self:BattleData().PetSkillLevelUp or 0
			for _, EntryId in pairs(self.Entry) do
				if EntryId ~= 0 then
					local AffixData = self:BattleData(EntryId)
					SkillLevelUp = SkillLevelUp + (AffixData.PetSkillLevelUp or 0)
				end
			end
			self.SkillLevelUp = SkillLevelUp
			return self.SkillLevelUp
		end
	end

	function Pet:IsResourcePet()
		return self:Data().PetType == 2
	end

	function Pet:IsPremium()
		return not not self:Data().Premium
	end

	function Pet:BattleData(PetOrEntryId)
		PetOrEntryId = PetOrEntryId or self.PetId
		local BattlePetId
		if DataMgr.Pet[PetOrEntryId] then
			BattlePetId = DataMgr.Pet[PetOrEntryId] and DataMgr.Pet[PetOrEntryId].BattlePetId
		else
			BattlePetId = DataMgr.PetEntry[PetOrEntryId] and DataMgr.PetEntry[PetOrEntryId].BattlePetID
		end
		local Data = DataMgr.BattlePet[BattlePetId]
		if not Data then
			DebugPrint("ERROR::", "宠物ID: "..PetOrEntryId.."没有BattlePet配置，先更新，不要用老号，用新号重试，还有问题就找策划检查下Pet表修改是否同步到双端")
		end
		return Data
	end

	function Pet:EntryData(EntryId)
		local Data = DataMgr.PetEntry[EntryId]
		if not Data then
			DebugPrint("ERROR::", "词条ID: "..EntryId.."没有对应Data，先更新试试，还有问题就找策划检查下Pet表修改是否同步到双端")
		end
		return Data
	end

	function Pet:CalcProvideExp()
		local TotalValue =0
		local BreakData = self:BreakData()
		local PetLvExp = DataMgr.PetLvToExp
		for i=0, self.BreakNum do
			local MaxLevel = self.Level
			if i < self.BreakNum then
				MaxLevel = BreakData and BreakData[i] and BreakData[i].PetBreakLevel or MaxLevel
			end
			-- 满突破情况下 等级会自动置满，在算经验时直接算1级经验
			if not BreakData[i+1] then
				MaxLevel = 1
			end
			TotalValue = PetLvExp[MaxLevel] and (TotalValue + PetLvExp[MaxLevel]) or TotalValue
		end
		local ConsumePetBaseExpFix = self:PetConsumeExpFix()
		for _, EntryId in pairs(self.Entry) do
			if EntryId ~= 0 then
				local EntryConsumeExpFix = self:PetEntryConsumeExpFix(EntryId)
				ConsumePetBaseExpFix = ConsumePetBaseExpFix + EntryConsumeExpFix
			end
		end
		local Data = self:Data()
		return TotalValue +self.Exp+Data.PetExp * (1+ConsumePetBaseExpFix)
	end

	function Pet:PetConsumeExpFix()
		local BattleData = self:BattleData()
		local ConsumeExpFix = BattleData and BattleData.ConsumeExpFix
		if not ConsumeExpFix then
			return 0
		end
		local GrowData = SkillUtils.GetGrowData("BattlePet",self:Data().BattlePetId,self.BreakNum+1)
		if GrowData and string.sub(ConsumeExpFix, 1, 1) == '#' then
			ConsumeExpFix = tonumber(string.sub(ConsumeExpFix, 2, -1))
			return GrowData[ConsumeExpFix].Value
		end
		return 0
	end

	function Pet:PetEntryConsumeExpFix(EntryId)
		local BattlePetId = DataMgr.PetEntry[EntryId] and DataMgr.PetEntry[EntryId].BattlePetID
		if not BattlePetId then
			return 0
		end
		local BattlePetLevel = DataMgr.PetEntry[EntryId] and DataMgr.PetEntry[EntryId].BattlePetLevel
		if not BattlePetLevel then
			return 0
		end
		local ConsumeExpFix = DataMgr.BattlePet[BattlePetId] and DataMgr.BattlePet[BattlePetId].ConsumeExpFix
		if not ConsumeExpFix then
			return 0
		end
		local GrowData = SkillUtils.GetGrowData("BattlePet",BattlePetId,BattlePetLevel)
		if GrowData and string.sub(ConsumeExpFix, 1, 1) == '#' then
			ConsumeExpFix = tonumber(string.sub(ConsumeExpFix, 2, -1))
			return GrowData[ConsumeExpFix].Value
		end
		return 0
	end

	function Pet:BattleDump(Avatar)
		local Info = {
			PetId = self.PetId,
		}
		local PetLevel = self:GetSkillLevel()
		if PetLevel ~= 1 then
			Info.PetLevel = PetLevel
		end
		Info.EntryIds = {}
		for _, EntryId in pairs(self.Entry) do
			table.insert(Info.EntryIds, EntryId)
		end
		return Info
	end

	function Pet:CalcMultiplier(ModMultiplier)
		local PetData = self:BattleData()
		local PetId = PetData.PetId
		if PetData.AddModMultiplier then
			local PetLevel = self:GetSkillLevel() + self:GetSkillLevelUp()
			local _PetData = SkillUtils.GrowProxyBySkillLevel('BattlePet', PetId, PetLevel, PetData.AddModMultiplier)
			for AttrName, _ in pairs(PetData.AddModMultiplier) do
				ModMultiplier[AttrName] = (ModMultiplier[AttrName] or 0) + _PetData[AttrName]
			end
		end
		
		for _, EntryId in pairs(self.Entry) do
			if EntryId ~= 0 then
				local EntryData = self:EntryData(EntryId)
				local AffixData = self:BattleData(EntryId)
				if AffixData.AddModMultiplier then
					local PetLevel = EntryData.BattlePetLevel + self:GetSkillLevelUp()
					local _AffixData = SkillUtils.GrowProxyBySkillLevel("BattlePet", AffixData.PetId, PetLevel, AffixData.AddModMultiplier)
					for AttrName, _ in pairs(AffixData.AddModMultiplier) do
						ModMultiplier[AttrName] = (ModMultiplier[AttrName] or 0) + _AffixData[AttrName]
					end
				end
			end
		end
	end

	function Pet:CalcAttrs(BaseValues, ModRateValues, ModAddValues, ModMultiplier)
		local PetData = self:BattleData()
		local PetId = PetData.PetId
		if PetData.AddAttrs then
			for Index, AttrData in pairs(PetData.AddAttrs) do
				local UniqueName = table.concat({"Pet:[",PetId,"]AddAttrs:[",Index,"]"})
				self:CalcOneAttrData(BaseValues, ModRateValues, ModAddValues, AttrData, ModMultiplier, UniqueName)
			end
		end
		
		for _, EntryId in pairs(self.Entry) do
			if EntryId ~= 0 then
				local EntryData = self:EntryData(EntryId)
				local AffixData = self:BattleData(EntryId)
				if AffixData.AddAttrs then
					local AffixEnhanceLevel = EntryData.BattlePetLevel
					for Index, AttrData in pairs(AffixData.AddAttrs) do
						local UniqueName = table.concat({"Pet:[",AffixData.PetId,"]AddAttrs:[",Index,"]"})
						self:CalcOneAttrData(BaseValues, ModRateValues, ModAddValues, AttrData, ModMultiplier, UniqueName, EntryId, AffixEnhanceLevel)
					end
				end
			end
		end
	end

	function Pet:CalcOneAttrData(BaseValues, ModRateValues, ModAddValues, AttrData, ModMultiplier, UniqueName, PetId, AffixEnhanceLevel)
		local AttrName = AvatarUtils:GetAttrNameFromAttrData(AttrData, UniqueName)

		if AttrName == 'ATK' then
			for _AttrName, _ in pairs(DataMgr.Attribute) do
				if AttrData.Value then
					assert(nil, PetId or self.PetId.."号宠物不允许使用Value增加ATK")
				end
				-- CommonConst.RateIndex.GlobalATK 总攻击力乘区
				self:CalcOneAttrs("ATK_" .. _AttrName, BaseValues, ModRateValues, CommonConst.RateIndex.GlobalATK, ModAddValues, AttrData, ModMultiplier, PetId, AffixEnhanceLevel)
			end
		else
			-- CommonConst.RateIndex.Default 默认乘区
			self:CalcOneAttrs(AttrName, BaseValues, ModRateValues, CommonConst.RateIndex.Default, ModAddValues, AttrData, ModMultiplier, PetId, AffixEnhanceLevel)
		end
	end
	
	function Pet:CalcOneAttrs(AttrName, BaseValues, ModRateValues, RateIndex, ModAddValues, AttrData, ModMultiplier, PetId, AffixEnhanceLevel)
		PetId = PetId or self.PetId
		local PetData = self:BattleData(PetId)
		PetId = PetData.PetId --此处完成从PetId转变为BattlePetId
		local SkillLevel = (AffixEnhanceLevel or self:GetSkillLevel(self.BreakNum)) + self:GetSkillLevelUp()
		if AttrData.Rate then
			if not ModRateValues[AttrName] then
				ModRateValues[AttrName] = {}
			end
			ModRateValues = ModRateValues[AttrName]
			-- 乘区
			local IncreaseRateValue
			if(type(AttrData.Rate) == "number") then
				IncreaseRateValue = (AttrData.Rate + (AttrData.LevelGrow or 0) * SkillLevel)
			else
				AttrData = SkillUtils.GrowProxyBySkillLevel('BattlePet', PetId, SkillLevel, AttrData)
				IncreaseRateValue = AttrData.Rate
			end
			if AttrData.AllowModMultiplier then
				if AttrData.AllowModMultiplier == "All" then
					local TotalValue = 0
					for MultiplierName, Value in pairs(ModMultiplier) do
						if not CommonUtils.HasValue(CommonConst.IndependentModMultiplier, MultiplierName) then
							TotalValue = TotalValue + Value
						end
					end
					IncreaseRateValue = IncreaseRateValue * (1 + TotalValue)
				else
					if ModMultiplier[AttrData.AllowModMultiplier] then
						IncreaseRateValue = IncreaseRateValue * (1 + ModMultiplier[AttrData.AllowModMultiplier])
					end
				end
			end
			ModRateValues[RateIndex] = (ModRateValues[RateIndex] or 0) + IncreaseRateValue
			-- PrintTable({Ratw=1,AttrName=AttrName,V=ModRateValues[AttrName],L=self.Level})
		end
		if AttrData.Value then
			local IncreaseValue
			if(type(AttrData.Value) == "number") then
				IncreaseValue = (AttrData.Value + (AttrData.LevelGrow or 0) * SkillLevel)
			else
				AttrData = SkillUtils.GrowProxyBySkillLevel('BattlePet', PetId, SkillLevel, AttrData)
				IncreaseValue = AttrData.Value
			end
			if AttrData.AllowModMultiplier then
				if AttrData.AllowModMultiplier == "All" then
					local TotalValue = 0
					for MultiplierName, Value in pairs(ModMultiplier) do
						if not CommonUtils.HasValue(CommonConst.IndependentModMultiplier, MultiplierName) then
							TotalValue = TotalValue + Value
						end
					end
					IncreaseValue = IncreaseValue * (1 + TotalValue)
				else
					if ModMultiplier[AttrData.AllowModMultiplier] then
						IncreaseValue = IncreaseValue * (1 + ModMultiplier[AttrData.AllowModMultiplier])
					end
				end
			end
			ModAddValues[AttrName] = (ModAddValues[AttrName] or 0) + IncreaseValue
		end
	end

	FormatProperties(Pet)

---@class PetDict
local PetDict = Class("PetDict", CustomTypes.CustomDict)
	PetDict.KeyType = BaseTypes.Int
	PetDict.ValueType = Pet
	function PetDict:NewPet(PetId,UniqueId)
		self[UniqueId] = Pet(PetId,UniqueId)
		return self[UniqueId]
	end

	function PetDict:LoadPet(Value)
		local pet = Pet()
		return pet:load(Value)
	end

return {Pet = Pet, PetDict = PetDict}

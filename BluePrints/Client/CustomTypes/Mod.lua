local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties
local ItemUtils = require "Utils.ItemUtils"
local SkillUtils = require "Utils.SkillUtils"

---@class Mod:CustomAttr
local Mod = Class("Mod", CustomTypes.CustomAttr)
	---@type Mod
	Mod.__Props__ = {
		-- uuid
		Uuid = prop.prop("ObjId", "client save"),
		-- id
		ModId = prop.prop("Int", "client save"),
		-- 等级
		Level = prop.prop("Int", "client save", 0),
		-- 数量
		Count = prop.prop("Int", "client save", 1),
		-- 是否原始Mod
		IsOriginal = prop.prop("Bool", "client save", true),
		--判断是否上锁
		LockState = prop.prop("Int", "client save", 0),
		
		Cost = prop.getter("CostGetter", "Cost"),
		-- 装备的角色Uuid
		CharUuids = prop.prop("ObjectIdList", "client save"),
		-- 装备的武器Uuid
		WeaponUuids = prop.prop("ObjectIdList", "client save"),
		-- 适用类型
		ApplicationType = prop.getter("Data", "ApplicationType"),
		-- 初始Cost
		OriginalCost = prop.getter("Data", "Cost"),
		-- Cost 随等级的成长
		CostChange = prop.getter("Data", "CostChange"),
		-- 极性
		Polarity = prop.getter("Data", "Polarity"),
		-- 稀有度
		Rarity = prop.getter("Data", "Rarity"),
		-- 重复组
		RepeatGroup = prop.getter("Data", "RepeatGroup"),
		-- 提供属性修正
		AddAttrs = prop.getter("Data", "AddAttrs"),
		-- 提供被动效果
		PassiveEffects = prop.getter("Data", "PassiveEffects"),
		-- 最大等级
		MaxLevel = prop.getter("Data", "MaxLevel"),
		-- 图标
		Icon = prop.getter("Data", "Icon"),
		--基础分解值
		BreakDown = prop.getter("Data","BreakDown"),
		--套装组
		ModUniteType = prop.getter("Data","ModUniteType"),

		-- Mod强化
		-- Mod当前强化等级
		CurrentModCardLevel = prop.prop("Int", "client save"),
		-- Mod强化需要的Mod数量
		CardLevelNeedNum = prop.getter("Data","CardLevelNeedNum"),
		-- Mod强化需要的ModId
		CardLevelNeedModId = prop.getter("Data","CardLevelNeedModId"),
		-- Mod最大强化等级
		ModCardLevelMax = prop.getter("Data","ModCardLevelMax"),
		-- 消减效果
		ReducePolarityEffect = prop.getter("Data", "ReducePolarityEffect"),
		-- Mod应用槽位
		ApplySlot = prop.getter("Data", "ApplySlot"),
		-- 增加Cost上限
		AddCharModCost = prop.getter("Data", "AddCharModCost"),
		-- 是否允许重复装备
		RepeatModLevel = prop.getter("Data", "RepeatModLevel"),
		-- 筛选标签
		FilterTag = prop.getter("Data", "FilterTag"),
		-- Mod筛选用类型名
		TypeName = prop.getter("Data", "TypeName"),
		-- 允许作为增幅素材的ResourceId
		CardLevelNeedResourceId =prop.getter("Data","CardLevelNeedResourceId"),
	}

	function Mod:CostGetter()
		return {Cost = self:CalcCurrentCost()}
	end

	function Mod:_Init()
		if not skynet then
			self.ConflictUuids = CustomTypes.ObjectIdList()
		end
	end

	function Mod:IsCardLevelNeedModId(InModId)
		for _,ModId in ipairs(self.CardLevelNeedModId or {}) do
			if ModId == InModId then
				return true
			end
		end
		return false
	end

	function Mod:HasCardLevel()
		return self.CardLevelNeedNum and self.CardLevelNeedModId and self.ModCardLevelMax
	end

	function Mod:IsOriginalMaxLevel()
		return self.Level >= self.MaxLevel
	end

	function Mod:CalcExtralCharVolume(PreviewCost)
		if self.AddCharModCost and self.AddCharModCost ~= 0 then
			return math.floor((PreviewCost or self.Cost) * math.max(0,  self.AddCharModCost or 0))
		end
		return 0
	end

	function Mod:GetSkillLevel()
		return self.Level
	end

	function Mod:ExpectCost(SkillLevel)
		return self:CalcCurrentCost() + (SkillLevel - self.Level)* self.CostChange
	end

	function Mod:NextCost()
		return self:ExpectCost(self:GetSkillLevel()+1)
	end

	function Mod:Init(Uuid, ModId, Level)
		if not Uuid or not ModId then return end
		self.Uuid = Uuid
		self.ModId = ModId
		self:SetLevel(math.min(Level or 0,self:GetTotalMaxLevel()))
		self:_Init()
	end

	function Mod:IsMaxLevel()
		return self.Level == self:GetTotalMaxLevel()
	end

	function Mod:IsFinalMaxLevel()
		return self:IsMaxLevel()
	end

	function Mod:GetName()
		if CommonConst.SystemLanguage == CommonConst.SystemLanguages.FR then
			return string.format("%s %s",GText(self:Data().Name),GText(self:Data().TypeName))
		end
		return GText(self:Data().TypeName)..GText(self:Data().Name)
	end

	function Mod:IsAura()
		if not self.ApplySlot then
			return false
		end
		
		if type(self.ApplySlot) == "table" then
			for _, slot in ipairs(self.ApplySlot) do
				if slot == 9 then
					return true
				end
			end
		else
			return self.ApplySlot == 9
		end
		
		return false 
	end

	function Mod:Data()
		local Data = DataMgr.Mod[self.ModId]
		if not Data and not skynet then
			DebugPrint("ERROR::", "ModId:"..self.ModId.."不存在, 先更新，不要用老号，用新号重试，还有问题就找策划检查下Mod表修改是否同步双端")
			return
		end
		return Data
	end


	function Mod:CalcModCostData()
		local Data = DataMgr.Mod[self.ModId]
	end

	function Mod:LevelData()
		return DataMgr.ModLevel
	end

	function Mod:IsLock()
		return self.LockState == CommonConst.CommonStatus.Lock
	end

	function Mod:Lock()
		if not self:IsLock() then
			self.LockState = CommonConst.CommonStatus.Lock
			return true
		end
		return false
	end

	function Mod:UnLock()
		if not self:IsUnLock() then
			self.LockState = CommonConst.CommonStatus.UnLock
			return true
		end
		return false
	end
	function Mod:IsUnLock()
		return self.LockState == CommonConst.CommonStatus.UnLock
	end

	-- 计算mod额外乘区的值
	function Mod:CalcMultiplier(ModMultiplier)
		local ModData = self:Data()
		if not ModData.AddModMultiplier then
			return
		end
		for AttrName, Value in pairs(ModData.AddModMultiplier) do
			ModMultiplier[AttrName] = (ModMultiplier[AttrName] or 0) + Value
		end
	end

	function Mod:CountModPolarity(ModPolarityMap)
		if self.Polarity <= 0 then
			return
		end
		if not ModPolarityMap[self.Polarity] then
			ModPolarityMap[self.Polarity] = 0
		end
		ModPolarityMap[self.Polarity] = ModPolarityMap[self.Polarity] + 1
	end

	-- mod计算属性加成
	-- ModUniteTypes:套装信息
	function Mod:CalcAttrs(BaseValues, ModRateValues, ModAddValues, ModUniteTypes, ModMultiplier, ModPolarityMap)
		local ModData = self:Data()
		if not ModData.AddAttrs then
			return
		end
		if ModData.PolarityNeedNum then
			for Polarity, NeedNum in pairs(ModData.PolarityNeedNum) do
				if not ModPolarityMap[Polarity] or ModPolarityMap[Polarity] < NeedNum then
					return -- 如果身上所有mod的极性总数达不到NeedNum，则该Mod的属性不生效
				end
			end
		end

		for Index, AttrData in pairs(ModData.AddAttrs) do
			local UniqueName = table.concat({"Mod:[",self.ModId,"]AddAttrs:[",Index,"]"})
			self:CalcOneAttrData(BaseValues, ModRateValues, ModAddValues, AttrData, 1, ModMultiplier, UniqueName)
		end

		if self.ModUniteType then
			local UniteNum = ModUniteTypes[self.ModUniteType]
			for Index, AttrData in pairs(ModData.UniteAddAttrs) do
				local UniqueName = table.concat({"Mod:[",self.ModId,"]UniteAddAttrs:[",Index,"]"})
				self:CalcOneAttrData(BaseValues, ModRateValues, ModAddValues, AttrData, UniteNum, ModMultiplier, UniqueName)
			end
		end
	end

	-- 计算单次属性加成
	function Mod:CalcOneAttrData(BaseValues, ModRateValues, ModAddValues, AttrData, UniteNum, ModMultiplier, UniqueName)
		local AttrName = AvatarUtils:GetAttrNameFromAttrData(AttrData, UniqueName)

		if AttrName == 'ATK' then
			for _AttrName, _ in pairs(DataMgr.Attribute) do
				if AttrData.Value then
					assert(nil, self.ModId.."号Mod不允许使用Value增加ATK")
				end
				-- CommonConst.RateIndex.GlobalATK 总攻击力乘区
				self:CalcOneAttrs("ATK_" .. _AttrName, BaseValues, ModRateValues, CommonConst.RateIndex.GlobalATK, ModAddValues, AttrData, UniteNum, ModMultiplier)
			end
		else
			-- CommonConst.RateIndex.Default 默认乘区
			self:CalcOneAttrs(AttrName, BaseValues, ModRateValues, CommonConst.RateIndex.Default, ModAddValues, AttrData, UniteNum, ModMultiplier)
		end
	end

	function Mod:CalcOneAttrs(AttrName, BaseValues, ModRateValues, RateIndex, ModAddValues, AttrData, UniteNum, ModMultiplier)
		if AttrData.Rate then
			if not ModRateValues[AttrName] then
				ModRateValues[AttrName] = {}
			end
			ModRateValues = ModRateValues[AttrName]
			-- 乘区
			local IncreaseRateValue 
			if(type(AttrData.Rate) == "number") then
				IncreaseRateValue = (AttrData.Rate + (AttrData.LevelGrow or 0) * self.Level) * (UniteNum or 1)
			else
				local _AttrData = SkillUtils.GrowProxyBySkillLevel('Mod', self.ModId, self.Level, AttrData)
				IncreaseRateValue = _AttrData.Rate * (UniteNum or 1)
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
		end
		if AttrData.Value then
			local IncreaseValue
			if(type(AttrData.Value) == "number") then
				IncreaseValue = (AttrData.Value + (AttrData.LevelGrow or 0) * self.Level) * (UniteNum or 1)
			else
				local _AttrData = SkillUtils.GrowProxyBySkillLevel('Mod', self.ModId, self.Level, AttrData)
				IncreaseValue = _AttrData.Value * (UniteNum or 1)
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

	function Mod:GetLevelUpItems(CurrentLevel, TargetLevel)
		if TargetLevel <= CurrentLevel then
			return {}
		end
		local LevelInfo = self:LevelData()
		local result = {}
		local LevelConsume = nil
		for i = CurrentLevel+1, TargetLevel, 1 do
			LevelConsume = LevelInfo[i].ConsumeRarity[self.Rarity]
			if LevelConsume then
				ItemUtils:AddItemsToTarget(result, LevelConsume)
			end
		end
		return result
	end

	function Mod:GetTotalMaxLevel()
		return self.MaxLevel + (self.ModCardLevelMax or 0)
	end

	function Mod:CalcCurrentCost() 
		return math.max(0, self.OriginalCost + self.Level * (self.CostChange or 1))
	end

	function Mod:SetLevel(Level)
		if Level > self:GetTotalMaxLevel() then return false end
		self.Level = Level
		return true
	end

	function Mod:AppendCharUuid(CharUuid)
		self.CharUuids:Append(CharUuid)
	end

	function Mod:RemoveCharUuid(CharUuid)
		return self.CharUuids:Remove(CharUuid)
	end

	function Mod:AppendWeaponUuid(WeaponUuid)
		self.WeaponUuids:Append(WeaponUuid)
	end

	function Mod:RemoveAllTargetCharUuid(CharUuid)
		for Index = 1, self.CharUuids:Length() do
			if not self:RemoveCharUuid(CharUuid) then
				return
			end
		end
	end

	function Mod:RemoveAllTargetWeaponUuid(WeaponUuid)
		for Index = 1, self.WeaponUuids:Length() do
			if not self:RemoveWeaponUuid(WeaponUuid) then
				return
			end
		end
	end

	function Mod:RemoveWeaponUuid(WeaponUuid)
		return self.WeaponUuids:Remove(WeaponUuid)
	end

	--判断Mod是否被角色或武器装备了
	---@return boolean
	function Mod:IsEquipped()
		return (self.WeaponUuids:Length()>0) or (self.CharUuids:Length()>0)
	end

	function Mod:AddCount(Count)
		if type(Count) == "number" and Count > 0 then
			self.Count = self.Count + Count
			return true
		end
		return false
	end

	function Mod:ReduceCount(Count)
		if type(Count) == "number" and Count > 0 and self.Count >= Count then
			self.Count = self.Count - Count
			return true
		end
		return false
	end

	function Mod:IsValid()
		return self.Count > 0
	end

    function Mod:GetConvert()
        local ModConvert = DataMgr.Mod[self.ModId].ModConvert
		if ModConvert then
			if ModConvert[1] then
				return 1, ModConvert[1]
			elseif ModConvert[2] then
				return 2, ModConvert[2]
			end	
		end
    end

	FormatProperties(Mod)

---@class ModDict:CustomDict
local ModDict = Class("ModDict", CustomTypes.CustomDict)
	ModDict.KeyType = BaseTypes.ObjId
	ModDict.ValueType = Mod

	function ModDict:NewMod(Uuid, ModId, Level)
		Level = Level or 0
		local mod = Mod(Uuid, ModId, Level)
		return mod
	end
	function ModDict:GetNewMod(Uuid, ModId, Level)
		local Mod = self[Uuid]
		if not Mod then
			Mod = self:NewMod(Uuid, ModId, Level)
		end
		return Mod
	end


--region 以下类型仅客户端使用 @see AvatarUtils:RebuildModSuit
---@class ModSlot:CustomAttr
local ModSlot = Class("ModSlot", CustomTypes.CustomAttr)
	-- ModSlot.__Props__ = {
	-- 	-- Id
	-- 	SlotId = prop.prop("Int", "client"),

	-- 	-- 状态
	-- 	Status = prop.prop("Int", "client", 0),  -- 0:解锁，1:锁定

	-- 	-- 极性
	-- 	Polarity = prop.prop("Int", "client"),

	-- 	-- ModId
	-- 	ModEid = prop.prop("ObjId", "client"),
	-- }

	function ModSlot:Init(SlotId, Polarity, Status, ModEid)
		if not SlotId then
			return
		end
		self.SlotId = SlotId
		self.Polarity = Polarity or CommonConst.NonePolarity
		self.ModEid = ModEid
		self.Status = Status or CommonConst.CommonStatus.UnLock
	end

	function ModSlot:IsLock()
		return self.Status == CommonConst.CommonStatus.Lock
	end

	function ModSlot:IsUnLock()
		return self.Status == CommonConst.CommonStatus.UnLock
	end

	function ModSlot:UnLock()
		self.Status = CommonConst.CommonStatus.UnLock
	end

	function ModSlot:IsPolarity()
		return self.Polarity > 0
	end

	function ModSlot:GetModCost(Polarity, Cost, ExPolarity)
		if not ExPolarity then
			ExPolarity = self.Polarity
		end
		return AvatarUtils:GetModSlotCostImpl(Polarity, Cost, ExPolarity)
	end


	-- function ModSlot:client_dump(value)
	-- 	local client_value = self.Super.client_dump(self, value)
	-- 	local result = {}
	-- 	table.insert(result, client_value.SlotId)
	-- 	table.insert(result, client_value.Status)
	-- 	table.insert(result, client_value.Polarity)
	-- 	table.insert(result, client_value.ModEid)
	-- 	return result
	-- end

	-- function ModSlot:load(data)
	-- 	if #data > 0 then
	-- 		local client_value = {}
	-- 		client_value.SlotId = data[1]
	-- 		client_value.Status = data[2]
	-- 		client_value.Polarity = data[3]
	-- 		client_value.ModEid = data[4]
	-- 		return self.Super.load(self, client_value)
	-- 	else
	-- 		return self.Super.load(self, data)
	-- 	end
	-- end

	FormatProperties(ModSlot)

---@class ModSlots:CustomDict
local ModSlots = Class("ModSlots", CustomTypes.CustomDict)
	ModSlots.KeyType = BaseTypes.Int
	ModSlots.ValueType = ModSlot

	function ModSlots:Init(inner, PolarityList, StatusList, EnhanceLevel)
		self.Super.Init(self, inner)
		if PolarityList == nil then
			return
		end
		for SlotId = 1, PolarityList:Length() do
			local Status = StatusList[SlotId]
			self[SlotId] = ModSlot(SlotId, PolarityList[SlotId], Status)
		end
	end

	function ModSlots:AddModSlots(PolarityList,StatusList,EnhanceLevel)
		for SlotId = 1,PolarityList:Length() do
			local Status = CommonConst.CommonStatus.UnLock
			if StatusList ~=nil and EnhanceLevel~=nil and StatusList[SlotId] > EnhanceLevel then
				Status = CommonConst.CommonStatus.Lock
			end
			self[SlotId] = ModSlot(SlotId,PolarityList[SlotId] ,Status)
		end
	end

	function ModSlots:NewModSlot(SlotId, Polarity,Status)
		local mod_slot = ModSlot(SlotId, Polarity,Status)
		return mod_slot
	end

	function ModSlots:AddModSlot(SlotId,Polarity, Status)
		if self[SlotId] ~= nil then
			return
		end
		self[SlotId] = ModSlot(SlotId ,Polarity,Status)
	end

	---@return ModSlot
	function ModSlots:GetModSlotById(SlotId)
		return self[SlotId]
	end

	function ModSlots:GetModSlotByModEid(ModEid)
		for SlotId, ModSlot in pairs(self) do
			if ModSlot.ModEid == ModEid then
				return ModSlot
			end
		end
		return nil
	end

	function ModSlots:IsAllEmpty()
		for SlotId, ModSlot in pairs(self) do
			if ModSlot.ModEid and ModSlot.ModEid ~= "" then
				return false
			end
		end
		return true
	end

---@class ModSuits:CustomList
local ModSuits = Class("ModSuits", CustomTypes.CustomList)
	ModSuits.ValueType = ModSlots

	function ModSuits:AddModSuit(PolarityList, StatusList, EnhanceLevel)
		local mod_Slots = ModSlots(nil, PolarityList, StatusList, EnhanceLevel)
		self:Append(mod_Slots)
		return mod_Slots
	end
--endregion


local SimpleMod = Class("SimpleMod", CustomTypes.CustomAttr)
	SimpleMod.__Props__ = {
		-- id
		ModId = prop.prop("Int", "client save"),
		-- 等级
		Level = prop.prop("Int", "client save"),
	}
	function SimpleMod:Init(ModId, Level)
		self.ModId = ModId
		self.Level = Level or 0
	end

	FormatProperties(SimpleMod)

local SimpleModSlot = Class("SimpleModSlot", CustomTypes.CustomAttr)
	SimpleModSlot.__Props__ = {
		-- Id
		SlotId = prop.prop("Int", "client save"),
		-- 状态
		Status = prop.prop("Int", "client save"),
		-- 极性
		Polarity = prop.prop("Int", "client save"),
		-- id
		ModId = prop.prop("Int", "client save"),
		-- 等级
		Level = prop.prop("Int", "client save"),
	}
	FormatProperties(SimpleModSlot)

local SimpleModSlots = Class("SimpleModSlots", CustomTypes.CustomDict)
	SimpleModSlots.KeyType = BaseTypes.Int
	SimpleModSlots.ValueType = SimpleModSlot

return {
	Mod = Mod,
	ModDict = ModDict,
	ModSlot = ModSlot,
	ModSlots = ModSlots,
	ModSuits = ModSuits,
	SimpleMod = SimpleMod,
	SimpleModSlot = SimpleModSlot,
	SimpleModSlots = SimpleModSlots,
}

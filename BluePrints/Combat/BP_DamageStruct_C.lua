
require "UnLua"
local MiscUtils = require "Utils.MiscUtils"
local table_concat = table.concat
-- local NewRateStruct = function(DamageType)
-- 	local RateStruct = {
-- 		DamageType = DamageType,	-- 伤害类型
-- 		DamageRates = {},			-- 伤害倍率
-- 		BaseValue = 0,				-- 本次伤害的基础数值
-- 		ShieldValue = 0,			-- 本次伤害对护盾造成的数值
-- 		FinalValue = 0,				-- 本次伤害对血量造成的数值

-- 		ExtraDamage = nil,			-- 额外伤害（已经算到了FinalValue里面)
-- 		ExtraEffect = nil,			-- 额外效果（触发概率触发的）
-- 	}

-- 	function RateStruct:SetBaseValue(BaseValue)
-- 		self.BaseValue = BaseValue
-- 		self:CalcFinalValue()
-- 	end

-- 	function RateStruct:SetDamageRate(RateStr, Rate)
-- 		self.DamageRates[RateStr] = Rate
-- 		self:CalcFinalValue()
-- 	end

-- 	function RateStruct:CalcFinalValue()
-- 		local _FinalValue = self.BaseValue
-- 		for _, Rate in pairs(self.DamageRates) do
-- 			_FinalValue = _FinalValue * Rate
-- 		end
-- 		if _FinalValue ~= 0 then
-- 			_FinalValue = math.max(1, _FinalValue)
-- 		end
-- 		self.FinalValue = _FinalValue
-- 	end

-- 	return RateStruct
-- end

local BP_DamageStruct_C = Class({
	"BluePrints.Combat.Components.SkillLevelInterface",
})

-- BP_DamageStruct_C.__newindex = nil


-- function BP_DamageStruct_C:GetSource()
-- 	if not self._Source then
-- 		self._Source = Battle(self):GetEntity(self.SourceEid)
-- 	end
-- 	return self._Source
-- end

-- function BP_DamageStruct_C:GetTarget()
-- 	if not self._Target then
-- 		self._Target = Battle(self):GetEntity(self.TargetEid)
-- 	end
-- 	return self._Target
-- end

-- function BP_DamageStruct_C:SetSourceEid(SourceEid)
-- 	self.SourceEid = SourceEid
-- 	self.Overridden.SetSourceEid(self, SourceEid)
-- end

-- function BP_DamageStruct_C:SetTargetEid(TargetEid)
-- 	self.TargetEid = TargetEid
-- 	self.Overridden.SetTargetEid(self, TargetEid)
-- end

-- function BP_DamageStruct_C:SetSkill(Skill)
-- 	self.Skill = Skill
-- 	self.Overridden.SetSkill(self, Skill)
-- end

-- function BP_DamageStruct_C:SetSourceBuff(SourceBuff)
-- 	self.SourceBuff = SourceBuff
-- 	self.Overridden.SetSourceBuff(self, SourceBuff)
-- end

-- function BP_DamageStruct_C:Get_bIsCreatureDamage_Lua()
-- 	-- PrintTable({Get_bIsCreatureDamage_Lua=1})
-- 	if self._bIsCreatureDamage ~= nil then
-- 		return self._bIsCreatureDamage
-- 	end

-- 	-- PrintTable({Get_bIsCreatureDamage_Lua=2})
-- 	local Source = self:GetSource()
-- 	if Source then
-- 		self._bIsCreatureDamage = Source:IsSkillCreature()
-- 	else
-- 		self._bIsCreatureDamage = false
-- 	end
-- 	return self._bIsCreatureDamage
-- end

-- function BP_DamageStruct_C:Get_bIsRayCreatureDamage_Lua()
-- 	return self.bIsRayCreatureDamage or false
-- end
-- function BP_DamageStruct_C:Get_BaseValue_Lua()
-- 	return self.BaseValue
-- end
-- function BP_DamageStruct_C:Get_FinalValue_Lua()
-- 	return self.FinalValue
-- end
-- function BP_DamageStruct_C:Get_TrueValue_Lua()
-- 	return self.TrueValue
-- end
-- function BP_DamageStruct_C:Get_HpBefore_Lua()
-- 	return self.HpBefore
-- end
-- function BP_DamageStruct_C:Get_HpAfter_Lua()
-- 	return self.HpAfter
-- end


-- function BP_DamageStruct_C:Initialize()
-- 	self.EnergyShieldReduce = 0
-- 	self.OverShieldReduce = 0

-- 	-- 伤害额外效果，在 ExtraEffects 中被赋值，可以不用在初始化时候赋值
-- 	-- self.ExtraBuffs = {}
-- 	-- self.ExtraHpRates = {}
-- 	-- self.ExtraESRates = {}

--     -- 每个Type对应的详细伤害数据
-- 	self.DamageValues = {}

-- 	-- 是否可以触发被动
-- 	-- self.PassiveCanExecute = nil
-- end

-- function BP_DamageStruct_C:SetSkill(Skill)
-- 	if Skill then
-- 		self.SkillId = Skill.SkillId
-- 	end
-- 	self.Overridden.SetSkill(self, Skill)
-- end

-- function BP_DamageStruct_C:SetBaseValue(DamageType, BaseValue)
-- 	if BaseValue <= 0 then
-- 		PrintTable({Error='为DmageType:' .. DamageType .. '设置了错误的基础值BaseValue:' .. tostring(BaseValue)})
-- 	end

-- 	if not self.DamageType then
-- 		self.DamageType = DamageType
-- 	end
	
-- 	local RateStruct = self.DamageValues[DamageType]
-- 	if not RateStruct then
-- 		RateStruct = NewRateStruct(DamageType)
-- 		self.DamageValues[DamageType] = RateStruct
-- 	end
-- 	RateStruct:SetBaseValue(BaseValue)
-- 	self:CalcBaseValue()
-- end


-- function BP_DamageStruct_C:AddDamageRate(DamageType, Rate)
-- 	self.ExtraRateKey = (self.ExtraRateKey or 0) + 1
-- 	local Key = "Extra_" .. tostring(self.ExtraRateKey)
-- 	self:SetDamageRate(DamageType, Key, Rate)
-- end

-- function BP_DamageStruct_C:AddGlobalDamageRate(Rate)
-- 	for DamageType, _ in pairs(self.DamageValues) do
-- 		self:AddDamageRate(DamageType, Rate)
-- 	end
-- end

-- function BP_DamageStruct_C:AddGlobalDamageRate_Lua(Rate)
-- 	self:AddGlobalDamageRate(Rate)
-- end

-- function BP_DamageStruct_C:IsDamageCrit()
-- 	return self.IsCrit
-- end

-- function BP_DamageStruct_C:SetDamageRate(DamageType, RateStr, Rate)
-- 	if Rate < 0 then
-- 		PrintTable({Error='为DmageType:' .. DamageType .. '设置了错误的基础值RateStr' .. tostring(RateStr) .. ',Rate:' .. tostring(Rate)})
-- 		return
-- 	end

-- 	local RateStruct = self.DamageValues[DamageType]
-- 	if RateStruct then
-- 		RateStruct:SetDamageRate(RateStr, Rate)
-- 		self:CalcFinalValue()
-- 	end
-- end

-- function BP_DamageStruct_C:CalcBaseValue()
-- 	local BaseValue = 0
-- 	for _, RateStruct in pairs(self.DamageValues) do
-- 		BaseValue = BaseValue + RateStruct.BaseValue
-- 	end
-- 	self.BaseValue = BaseValue
-- 	self:CalcFinalValue()
-- end

-- function BP_DamageStruct_C:CalcFinalValue()
-- 	local FinalValue = 0
-- 	local TrueValue = 0
-- 	for _, RateStruct in pairs(self.DamageValues) do
-- 		FinalValue = FinalValue + RateStruct.FinalValue
-- 		TrueValue = TrueValue + RateStruct.FinalValue + RateStruct.ShieldValue
-- 	end
-- 	self.FinalValue = math.floor(FinalValue)
-- 	self.TrueValue = math.floor(TrueValue)
-- end

-- function BP_DamageStruct_C:GetDamageFinalValues()
-- 	local FinalValues = TMap("", 0.0)
-- 	for DamageType, RateStruct in pairs(self.DamageValues) do
-- 		FinalValues:Add(DamageType, RateStruct.FinalValue)
-- 	end
-- 	return FinalValues
-- end

-- function BP_DamageStruct_C:GetDamageTrueValues()
-- 	local TrueValues = TMap("", 0.0)
-- 	for DamageType, RateStruct in pairs(self.DamageValues) do 
-- 		TrueValues:Add(DamageType, RateStruct.FinalValue + RateStruct.ShieldValue)
-- 	end
-- 	return TrueValues
-- end

function BP_DamageStruct_C:ShowDetails()
	if Const.bStatDamage and not Const.StartTime then
		Const.StartTime = os.clock()
	end
	Const.EndTime = os.clock()
	DebugPrint('-----------------玩家详细属性------------------')
	local AttrStr = ""
	local GameInstance = GWorld.GameInstance
    self.Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    local ATK = self.Player:GetAttr("ATK")
    local ATK_Char = self.Player:GetAttr("ATK_Char")
    local ATK_Wepon = ATK - ATK_Char
    local SkillIntensity = self.Player:GetAttr("SkillIntensity")
	local SkillSustain = self.Player:GetAttr("SkillSustain")
    local SkillRange = self.Player:GetAttr("SkillRange")
    local SkillEfficiency = self.Player:GetAttr("SkillEfficiency")
    local StrongValue = string.format("%.3f", (1 + (self.Player:GetAttr("StrongValue") or 0)) * 100)
    local EnmityValue = string.format("%.3f", (1 + (self.Player:GetAttr("EnmityValue") or 0)) * 100)
    DebugPrint("背水："..EnmityValue.."%")
	AttrStr = AttrStr.." 背水："..(self.Player:GetAttr("EnmityValue") or 0)
    DebugPrint("昂扬："..StrongValue.."%")
	AttrStr = AttrStr.." 昂扬："..(self.Player:GetAttr("StrongValue") or 0)
    local Weapon = self.Player:GetCurrentWeapon()
    if Weapon then
        local CRI = string.format("%.3f", Weapon:GetAttr("CRI")*100)
        local CRD = string.format("%.3f", Weapon:GetAttr("CRD")*100)
        local TRI = string.format("%.3f", Weapon:GetAttr("TriggerProbability")*100)
		local MultiShoot = string.format("%.3f", Weapon:GetAttr("MultiShoot")*100)
        DebugPrint("多重射击："..MultiShoot.."%")
        DebugPrint("触发概率："..TRI.."%")
        DebugPrint("爆伤："..CRD.."%")
        DebugPrint("暴击："..CRI.."%")

		AttrStr = AttrStr.." 多重射击："..MultiShoot
		AttrStr = AttrStr.." 触发概率："..TRI
		AttrStr = AttrStr.." 爆伤："..CRD
		AttrStr = AttrStr.." 暴击："..CRI
    end
	DebugPrint("技能效益："..string.format("%.3f",SkillEfficiency*100).."%")
    DebugPrint("技能耐久："..string.format("%.3f",SkillSustain*100).."%")
    DebugPrint("技能范围："..string.format("%.3f",SkillRange*100).."%")
    DebugPrint("技能强度："..string.format("%.3f",SkillIntensity*100).."%")
    DebugPrint("武器攻击："..ATK_Wepon)
    DebugPrint("角色攻击："..ATK_Char)
    DebugPrint("总攻击："..ATK)

	AttrStr = AttrStr.." 技能效益："..SkillEfficiency
	AttrStr = AttrStr.." 技能耐久："..SkillSustain
	AttrStr = AttrStr.." 技能范围："..SkillRange
	AttrStr = AttrStr.." 技能强度："..SkillIntensity
	AttrStr = AttrStr.." 武器攻击："..ATK_Wepon
	AttrStr = AttrStr.." 角色攻击："..ATK_Char

	DebugPrint('-----------------伤害详细------------------')
	if Const.bStatDamage then
		Const.TotalDamage = Const.TotalDamage + self.TrueValue
	end
	DebugPrint(string.format("本次伤害的SkillId: %d", self.SkillId))
	DebugPrint(string.format("造成的总伤害: %d", self.TrueValue))
	DebugPrint(string.format("对护盾造成伤害: %d", self.TrueValue - self.FinalValue))
	DebugPrint(string.format("对血量造成伤害: %d", self.FinalValue))

	local DamageValues = {}
	for DamageType, RateStruct in pairs(self.DamageValues) do
		local BaseRate = self.DamageBaseRates:Find(DamageType) or 0
		local BaseParamRate = self.DamageBaseParamRates:Find(DamageType) or 0
		local BaseParamValue = self.DamageBaseParamValues:Find(DamageType) or 0
		local RealBaseValue = (RateStruct.BaseValue - BaseParamRate - BaseParamValue) / BaseRate
		local _Str ="BaseValue: " .. tostring(RateStruct.BaseValue) 
		if BaseRate ~= 0 then
			_Str = _Str.." (".. tostring(string.format("%.3f", RealBaseValue)).." × "..tostring(string.format("%.3f", BaseRate)) .. " + ".. tostring(string.format("%.3f", BaseParamValue))
			if BaseParamRate == 0 then
				_Str = _Str..") "
			end
		end
		if BaseParamRate ~= 0 then
			_Str = _Str.." + "..tostring(string.format("%.3f", BaseParamRate))..") "
		end
		_Str =_Str..",FinalValue: " .. tostring(RateStruct.FinalValue)
		if RateStruct.ShieldValue > 0 then
			_Str =_Str  .. ",ShieldValue: " .. tostring(RateStruct.ShieldValue)
		end
		local RateStr = nil
		for k, RateZoneInfo in pairs(RateStruct.DamageRates) do
			if not RateStr then
				RateStr = ",Rates:"
				_Str = _Str .. RateStr
			else
				_Str = _Str .. ","
			end

			local ZoneRatesStr = ''
			for Index = 1,RateZoneInfo.ZoneRates:Length() do
				local Rate = RateZoneInfo.ZoneRates:GetRef(Index)
				if Index ~= 1 then
					ZoneRatesStr = ZoneRatesStr .. '+'
				end
				ZoneRatesStr = ZoneRatesStr .. tostring(string.format("%.3f", Rate))
			end

			_Str = _Str .. tostring(k) .. ":" .. tostring(ZoneRatesStr)
		end
		DamageValues[DamageType] = _Str
	end

	local DamageTags = {}
	for k, v in pairs(self.DamageTag) do
		DamageTags[k] = v
	end
	local Result = {
		Attr = AttrStr,
		SourceEid = self.SourceEid,
		TargetEid = self.TargetEid,
		DamageValues = DamageValues,
		FinalValue = self.FinalValue,
		TrueValue = self.TrueValue,
		DamageTags = DamageTags,
	}

	local ct = { "PrintTable: ", tostring("DamageStrcutDetails"), tostring(Result), "\n"}
	MiscUtils.GetStrTable(ct, Result, 1, 10)
	local ret = table_concat(ct)
	print(LogTag, ret)

	return ret
end


-- function BP_DamageStruct_C:IsTargetKilled()
-- 	return self.KillTarget or false
-- end

function BP_DamageStruct_C:GetExtraEffectDamageTypes()
	local OutTypes = UE.TArray(FString)
	for DamageType, DamageRate in pairs(self.DamageValues) do
		if DamageRate.ExtraEffect then
			OutTypes:Add(DamageType)
		end
	end
	return OutTypes
end

function BP_DamageStruct_C:GetDamageTags()
	local OutDamageTags = UE.TArray(FString)
	if self.DamageTag then
		for _, v in pairs(self.DamageTag) do
			OutDamageTags:Add(v)
		end
	end
	return OutDamageTags
end

return BP_DamageStruct_C

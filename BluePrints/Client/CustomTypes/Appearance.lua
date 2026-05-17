local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties

local Skin = Class("Skin", CustomTypes.CustomAttr)
Skin.__Props__ = {
    SkinId = prop.prop("Int", "client save"),
    SkinType = prop.prop("Int", "client save"),-- 0角色，1武器,2,坐骑,3发型
	CurrentPlanIndex = prop.prop("Int", "client save",1),--当前生效的染色方案
	Colors = prop.prop("Int2IntListDict", "client save"), --皮肤染色信息
	SpecialColor = prop.prop("IntList","client save"),--武器特殊染色
	IsShowPartMesh = prop.prop("Bool", "client save", true),
	Level = prop.prop("Int", "client save", 1),--皮肤等级
	SelectedLevel = prop.prop("Int", "client save", 1),--玩家选中的皮肤等级
}

function Skin:Init(SkinId, SkinType)
	if (SkinId == nil) or (SkinType == nil) then return end
	self.SkinId = SkinId
	self.SkinType = SkinType
	self:InitColor()
end

function Skin:SetShowPartMesh(NewValue)
	self.IsShowPartMesh = NewValue
end

function Skin:GetShowPartMesh()
	return self.IsShowPartMesh
end

function Skin:InitColor()
	self.CurrentPlanIndex = 1
	local MaxPart
	local MaxPlan
	local DefaultColor
	if self.SkinType == CommonConst.SkinType.Char then
		MaxPart = DataMgr.GlobalConstant.CharColorPart.ConstantValue
		MaxPlan = DataMgr.GlobalConstant.CharColorPlan.ConstantValue
		DefaultColor = DataMgr.GlobalConstant.CharDefaultColor.ConstantValue
	elseif self.SkinType == CommonConst.SkinType.Weapon then
		MaxPart = DataMgr.GlobalConstant.WeaponColorPart.ConstantValue
		MaxPlan = DataMgr.GlobalConstant.WeaponColorPlan.ConstantValue
		DefaultColor = DataMgr.GlobalConstant.WeaponDefaultColor.ConstantValue
		for i = 1,MaxPlan do
			self.SpecialColor[i] = DefaultColor
		end
	elseif self.SkinType == CommonConst.SkinType.Mount then
		MaxPart = DataMgr.GlobalConstant.MountColorPart.ConstantValue
		MaxPlan = DataMgr.GlobalConstant.MountColorPlan.ConstantValue
		DefaultColor = DataMgr.GlobalConstant.MountDefaultColor.ConstantValue
	elseif self.SkinType == CommonConst.SkinType.Hair then
		MaxPart = DataMgr.GlobalConstant.HairColorPart.ConstantValue
		MaxPlan = DataMgr.GlobalConstant.HairColorPlan.ConstantValue
		DefaultColor = DataMgr.GlobalConstant.HairDefaultColor.ConstantValue
	else
		return
	end
	for i = 1,MaxPlan do
		self.Colors[i] = {}
		for j = 1,MaxPart do
			self.Colors[i]:Append(DefaultColor)
		end
	end
end

function Skin:GetCurrentPlanIndex()
	return self.CurrentPlanIndex
end

function Skin:GetColors(PlanIndex)
	if PlanIndex and self.Colors[PlanIndex] then
		return self.Colors[PlanIndex]
	end
	return self.Colors[self.CurrentPlanIndex]
end

function Skin:GetWeaponSpecialColor(PlanIndex)
	if PlanIndex and self.SpecialColor[PlanIndex] then
		return self.SpecialColor[PlanIndex]
	end
	return self.SpecialColor[self.CurrentPlanIndex]
end

FormatProperties(Skin)


local SkinDict = Class("SkinDict", CustomTypes.CustomDict)
	SkinDict.KeyType = BaseTypes.Int
	SkinDict.ValueType = Skin

	function SkinDict:NewSkin(SkinId,Type)
        return Skin(SkinId, Type)
    end

    function SkinDict:GetSkin(SkinId)
        return self[SkinId]
    end

	function SkinDict:GetNewSkin(SkinId, Type)
		if not self[SkinId] then
			self[SkinId] = self:NewSkin(SkinId, Type)
        end
		return self[SkinId]
	end


local Appearance = Class("Appearance", CustomTypes.CustomAttr)
Appearance.__Props__ = {
    TargetId = prop.prop("Int", "client save"), --CharId/WeaponId/MountId
    TargetType = prop.prop("Int", "client save"), -- 0角色，1武器, 2 坐骑
    SkinId = prop.prop("Int", "client save"),-- 当前皮肤Id
    HairId = prop.prop("Int", "client save"),-- 当前的发型Id,仅角色
    Accessory = prop.prop("IntList", "client save"),
	IsCornerVisible = prop.prop("Bool", "client save"),
	AppearanceName = prop.prop("Str", "client save", ""), -- 外观名
	AccessoryCustomParams = prop.prop("Int2StrDict", "client save"), --配饰自定义参数,配饰Id:str
}

function Appearance:Init(TargetId,TargetType)
	self.TargetId = TargetId
	self.TargetType = TargetType
	self:InitDefaultSkin()
	self:InitAccessory()
	self:InitDefaultCharHair()
end

function Appearance:InitDefaultSkin()
	local TargetInfo
	if self.TargetType == CommonConst.SkinType.Char then
		TargetInfo = DataMgr.Char[self.TargetId]
		self.IsCornerVisible = true
	elseif self.TargetType == CommonConst.SkinType.Weapon then
		self.SkinId = self.TargetId
	elseif self.TargetType == CommonConst.SkinType.Mount then
		self.SkinId = self.TargetId
	end
	if TargetInfo and TargetInfo.DefaultSkinId then
		self.SkinId = TargetInfo.DefaultSkinId
	end
end

function Appearance:InitDefaultCharHair()
	if self.TargetType == CommonConst.SkinType.Char then
		local CharInfo = DataMgr.Char[self.TargetId]
		if CharInfo and CharInfo.DefaultHairId then
			self.HairId = CharInfo.DefaultHairId
		end
	end
end

function Appearance:UnloadCharSkin(SkinId, DefaultSkinId)
	if self.SkinId == DefaultSkinId then
		return
	end
	if self.SkinId == SkinId then
		self.SkinId = DefaultSkinId
	end
end


function Appearance:InitAccessory()
	local InitCount = 11
	if DataMgr.GlobalConstant.CharAccessoryNum and InitCount <= DataMgr.GlobalConstant.CharAccessoryNum.ConstantValue then
		InitCount = DataMgr.GlobalConstant.CharAccessoryNum.ConstantValue
	end
	if self.TargetType == 0 then
		for i = 1, DataMgr.GlobalConstant.CharAccessoryNum.ConstantValue do
			self.Accessory:Append(-1)
		end
		self.IsShowPartMesh = true
	elseif self.TargetType == 1 then
		for i = 1, DataMgr.GlobalConstant.WeaponAccessoryNum.ConstantValue do
			self.Accessory:Append(-1)
		end
	elseif self.TargetType == 2 then
		for i = 1, 2 do
			self.Accessory:Append(-1)
		end
	end
end

FormatProperties(Appearance)

local AppearanceList = Class("AppearanceList", CustomTypes.CustomList)
    AppearanceList.ValueType = Appearance

	function AppearanceList:NewAppearance(TargetId, TargetType)
		local _Appearance = Appearance(TargetId, TargetType)
		return _Appearance
	end

	function AppearanceList:AddCharAppearance(TargetId)
		self:Append(self:NewAppearance(TargetId, CommonConst.SkinType.Char))
	end

	function AppearanceList:AddWeaponAppearance(TargetId)
		self:Append(self:NewAppearance(TargetId, CommonConst.SkinType.Weapon))
	end

	function AppearanceList:AddMountAppearance(TargetId)
		self:Append(self:NewAppearance(TargetId, CommonConst.SkinType.Mount))
	end

return {
	Skin = Skin,
	SkinDict = SkinDict,
    Appearance = Appearance,
    AppearanceList = AppearanceList,
}
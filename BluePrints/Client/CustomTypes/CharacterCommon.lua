local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local Appearance = require "BluePrints.Client.CustomTypes.Appearance"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties


local CommonChar = Class("CommonChar", CustomTypes.CustomAttr)
	CommonChar.__Props__ = {
		-- 角色编号
		CharId = prop.prop("Int", "client save"),
		-- 拥有的相同卡数量
		Count = prop.prop("Int", "client save", 1),
		-- 拥有的皮肤
		OwnedSkins = prop.prop("Appearance.SkinDict", "client save"),
		--拥有的发型
		OwnedHairs = prop.prop("Appearance.SkinDict", "client save"),
		-- 该角色的皮肤列表
		SkinIds = prop.getter("Data", "SkinId"),
		-- 转化道具
		RegainCharItemId = prop.getter("Data", "RegainCharItemId"),
		-- 转化道具数量
		RegainCharItemNum = prop.getter("Data", "RegainCharItemNum"),
		--看板娘每日放置对话计数
		DailySignBoardNpcTalkCount = prop.prop("Int", "client save", 0),
		--看板娘已对话记录
		SignBoardNpcAlreadyTalkList = prop.prop("IntList", "client save"),
	}

	function CommonChar:Init(CharId)
		if not CharId then return end
		self.CharId = CharId
		-- 初始化皮肤列表
		local CharInfo = DataMgr.Char[CharId] or DataMgr.BattleChar[self.CharId]
		if CharInfo.DefaultSkinId then
			self.OwnedSkins:GetNewSkin(CharInfo.DefaultSkinId, CommonConst.SkinType.Char)
		end
		local CharInfo = DataMgr.Char[CharId] or DataMgr.BattleChar[self.CharId]
		if CharInfo.DefaultHairId then
			self.OwnedHairs:GetNewSkin(CharInfo.DefaultHairId, CommonConst.SkinType.Hair)
		end
	end

	function CommonChar:AddSkin(SkinId)
		self.OwnedSkins:GetNewSkin(SkinId, CommonConst.SkinType.Char)
	end

	function CommonChar:GetSkin(SkinId)
		return self.OwnedSkins:GetSkin(SkinId)
	end
	function CommonChar:Data()
		return DataMgr.Char[self.CharId] or DataMgr.BattleChar[self.CharId]
	end

	function CommonChar:RemoveSkin(SkinId)
		self.OwnedSkins[SkinId] = nil
	end

	function CommonChar:AddHair(HairId)
		self.OwnedHairs:GetNewSkin(HairId, CommonConst.SkinType.Hair)
	end

	function CommonChar:GetHair(HairId)
		return self.OwnedHairs:GetSkin(HairId)
	end

	function CommonChar:AddOne()
		self.Count = self.Count + 1
	end

	function CommonChar:ReduceOne()
		if self.Count >= 1 then
			self.Count = self.Count - 1
		end
	end

	FormatProperties(CommonChar)


local CommonCharDict = Class("CommonCharDict", CustomTypes.CustomDict)
	CommonCharDict.KeyType = BaseTypes.Int
	CommonCharDict.ValueType = CommonChar

	function CommonCharDict:NewCommonChar(CharId)
		local _CommonChar = CommonChar(CharId)
		return _CommonChar
	end

	function CommonCharDict:GetCommonChar(CharId)
		return self[CharId]
	end

	function CommonCharDict:GetNewCommonChar(CharId)
		if not self[CharId] then
			self[CharId] = self:NewCommonChar(CharId)
		end
		return self[CharId]
	end

	function CommonCharDict:LoadCommonChar(Value)
		local common_char = CommonChar()
		return common_char:load(Value)
	end

return {CommonChar = CommonChar, CommonCharDict = CommonCharDict}

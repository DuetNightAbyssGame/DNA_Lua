local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties
local RewardUtils = require "Utils.RewardUtils"

local Item = Class("Item", CustomTypes.CustomAttr)
	Item.__Props__ = {
		ItemType = prop.prop("Str", "client save"),
		ItemID = prop.prop("Int", "client save"),
		ItemNum = prop.prop("Int", "client save"),
	}
	function Item:Init(ItemType,ItemID,ItemNum)
		self.ItemType = ItemType
		self.ItemID = ItemID
		self.ItemNum = ItemNum
	end
	FormatProperties(Item)

local ItemList = Class("ItemList", CustomTypes.CustomList)
	ItemList.ValueType = Item
	function ItemList:Add(item)
		self:Append(item)
	end

---@class Mail
---@field MailReaded number
---@field RewardGot number
local Mail = Class("Mail", CustomTypes.CustomAttr)
	Mail.__Props__ = {
        --唯一ID
		UniqueId = prop.prop("Int", "client save"),
		-- 邮件id
		MailId = prop.prop("Int", "client save"),
		-- 已读  -- 0:未读，1:已读
		MailReaded = prop.prop("Int", "client save", 0), 
		-- 日期
		MailDate = prop.prop("Int","client save"),
		-- 奖励已领取  -- 0:未领，1:已领取
		RewardGot = prop.prop("Int","client save",0),
		
		MailTimeLimit = prop.getter("Data", "MailTimeLimit"),
		
		-- ItemList
		ItemList = prop.prop("ItemList", "client save"),

		--多语言相关用Dict
		MailTitle = prop.prop("Str2StrDict", "client save"),
		MailContent = prop.prop("Str2StrDict", "client save"),
		MailSender = prop.prop("Int", "client save"),
		CtxId = prop.prop("Str", "client save"),
		FormatText = prop.prop("Str2StrDict", "client save"),
		Nickname = prop.prop("Str", "client save"),
		HeadIconId = prop.prop("Int", "client save"),
	}

	function Mail:Init(MailDate,MailId,MailTitle,MailContent,Items,MailSender)
        self.MailDate = MailDate

		self.MailId = MailId

		self.MailTitle = MailTitle
		self.MailContent =MailContent
		self.MailSender = MailSender
		
		for i,v in ipairs(Items or {}) do
			DebugPrint("Mail:Init",CommonUtils.TableToString(v))
			self.ItemList:Add(Item(v.Type,v.Id,v.Count))
		end

		if self.ItemList:Length() == 0 then
			self.RewardGot = 1
		else
			self.RewardGot = 0
		end
	end

	function Mail:Data()
		return DataMgr.Mail[self.MailId]
	end
	FormatProperties(Mail)

---@class MailDict
local MailDict = Class("MailDict", CustomTypes.CustomDict)
	MailDict.KeyType = BaseTypes.Int
	MailDict.ValueType = Mail

	function MailDict:NewMail(MailId,MailDate)
		local excel =  DataMgr.Mail[MailId]
		
		local Items = {}
		local Title = {}
		local Content = {}
		local MailSender = excel.MailSenderId

		local AllRewards = RewardUtils:GetRewards({excel.MailReward}, nil)
		for Type,IdCountKV in pairs(AllRewards:Dump()) do
			for ID, Count in pairs(IdCountKV) do
				local item = {Type = Type:sub(1, -2), Id = ID, Count = Count}
				table.insert(Items,item)
				skynet.error("[NewMail] <Reward>",Type:sub(1, -2),ID,Count)
			end
		end

        return Mail(MailDate,MailId,Title,Content,Items,MailSender)
	end

	function MailDict:NewCustomRewardMail(MailId,MailDate,Items)
		local excel =  DataMgr.Mail[MailId]
		local Title = {}
		local Content = {}
		local MailSender = excel.MailSenderId
        return Mail(MailDate,MailId,Title,Content,Items,MailSender)
	end

	function MailDict:NewTextMail(MailDate,Title,Content)
		local RealContent = {}
		local RealTitle = {}
		for lang,v in pairs(CommonConst.SystemLanguages) do
			RealContent[lang] = Content or ""
			RealTitle[lang] = Title or ""
		end
        return Mail(MailDate,-1,RealTitle,RealContent,nil,99999)
	end

	function MailDict:NewGMMail(MailDate,GmConf)
		local Items = {}
		local Title = {}
		local Content = {}
		
		for i,v in ipairs(GmConf.itemList or {}) do
			if v.rewardType.code == "Reward" then
				local RewardBox = RewardUtils:GetRewards({tonumber(v.id)}, nil)
				for Type,IdCountKV in pairs(RewardBox:Dump()) do
					for ID, Count in pairs(IdCountKV) do
						table.insert(Items,{Type = Type:sub(1, -2), Id = ID, Count = Count})
						DebugPrint("[NewGMMail] <Reward>",Type:sub(1, -2),ID,Count)
					end
				end
			else
				DebugPrint("[NewGMMail] <Reward>",v.rewardType.code,v.id,v.count)
				table.insert(Items,{Type = v.rewardType.code, Id = tonumber(v.id), Count = tonumber(v.count)})
			end
		end

		for i,v in ipairs(GmConf.content or {}) do
			Title[v.language] = v.title
			Content[v.language] = v.body
		end

        return Mail(MailDate,-1,Title,Content,Items,GmConf.From.code)
	end

	---@return Mail
	function MailDict:FindMail(UniqueId)
		return self[UniqueId]
	end

return {Mail = Mail, MailDict = MailDict, ItemList = ItemList, Item = Item}

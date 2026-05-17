---@module MonthlyCard
local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties
-- CommonConst = require "CommonConst"

---@class MonthlyCard
---@field CardId integer
---@field BuyTime integer[]
local MonthlyCard = Class("MonthlyCard", CustomTypes.CustomAttr)
	MonthlyCard.__Props__ = {
		-- 月卡id
		CardId = prop.prop("Int", "client save"),
		-- 购买时间戳
		BuyTime = prop.prop("IntList", "client save"),

		-- 上架时间
		BeginTime = prop.getter("Data", "BeginTime"),
		-- 下架时间
		EndTime = prop.getter("Data", "EndTime"),
		-- 购买奖励
		BuyReward = prop.getter("Data", "BuyReward"),
		-- 每日奖励
		DailyReward = prop.getter("Data", "DailyReward"),
		-- 唯一奖励
		UniqueReward = prop.getter("Data", "UniqueReward"),
	}

	function MonthlyCard:Init(CardId)
		self.CardId = CardId
	end

	function MonthlyCard:Data()
		return DataMgr.MonthlyCard[self.CardId]
	end


	FormatProperties(MonthlyCard)


---@class MonthlyCardDict
local MonthlyCardDict = Class("MonthlyCardDict", CustomTypes.CustomDict)
	MonthlyCardDict.KeyType = BaseTypes.Int
	MonthlyCardDict.ValueType = MonthlyCard

	function MonthlyCardDict:NewMonthlyCard(CardId)
		---@type MonthlyCard
		local MonthlyCard = MonthlyCard(CardId)
		return MonthlyCard
	end


---@class MonthlyCardDailyReward
local MonthlyCardDailyReward = Class("MonthlyCardDailyReward", CustomTypes.CustomAttr)
	MonthlyCardDailyReward.__Props__ = {
		-- 月卡id
		CardId = prop.prop("Int", "save"),
		-- 每日奖励id
		DailyRewardId = prop.prop("Int", "save"),
		-- 每日奖励剩余领取次数
		GotTimes = prop.prop("Int", "save"),
	}

	function MonthlyCardDailyReward:Init(CardId, DailyRewardId, GotTimes)
		self.CardId = CardId
		self.DailyRewardId = DailyRewardId
		self.GotTimes = GotTimes
	end

	FormatProperties(MonthlyCardDailyReward)


local MonthlyCardDailyRewardList = Class("MonthlyCardDailyRewardList", CustomTypes.CustomList)
	MonthlyCardDailyRewardList.ValueType = MonthlyCardDailyReward

	function MonthlyCardDailyRewardList:NewMonthlyCardDailyReward(CardId, DailyRewardId, GotTimes)
		---@type MonthlyCardDailyReward
		local MonthlyCardDailyReward = MonthlyCardDailyReward(CardId, DailyRewardId, GotTimes)
		return MonthlyCardDailyReward
	end


return {
	MonthlyCard = MonthlyCard,
	MonthlyCardDict = MonthlyCardDict,
	MonthlyCardDailyReward = MonthlyCardDailyReward,
	MonthlyCardDailyRewardList = MonthlyCardDailyRewardList,
}

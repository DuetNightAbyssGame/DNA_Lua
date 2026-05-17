local TimeUtils = require("Utils.TimeUtils")
--- 月卡Model
local MonthCardCommon = require "BluePrints.UI.WBP.Perk.MonthCard.MonthCardCommon"
local ItemUtil = require "Utils.ItemUtils"

--- @class MonthCardModel :Model
local M = Class("BluePrints.Common.MVC.Model")

---@class MonthCardReward @奖励信息
---@field ItemType string @Item类型
---@field ItemId number @ItemID
---@field Count number @Item数量

function M:Init()
    M.Super.Init(self)
    self._Avatar = nil
    self:GetAvatar()
    self.NowMonthCardId = nil
end

--- @return boolean
function M:IsMonthCardPurchased()
    local Avatar = self:GetAvatar()
    if Avatar then
        return Avatar.MonthlyCardExpireTime > TimeUtils.NowTime()
    else
        return false
    end
end

--- @return boolean
function M:IsMonthCardCanPurchase()
    local Avatar = self:GetAvatar()
    local MonthCardHoldMax = DataMgr.GlobalConstant.MonthlyCardHoldMax
    MonthCardHoldMax = (MonthCardHoldMax and MonthCardHoldMax.ConstantValue) or 0
    if Avatar then
        local NowTime = TimeUtils.NowTime()
        local LastTime = Avatar.MonthlyCardExpireTime - NowTime
        return (math.ceil(LastTime / CommonConst.DayTime) + CommonConst.MonthlyCardValidDay) <= MonthCardHoldMax
    else
        return false
    end
end

--- 月卡失效时间
--- @return number
function M:GetMonthCardLeftDays()
    local Avatar = self:GetAvatar()
    if Avatar then
        return Avatar.MonthlyCardExpireTime
    else
        return false
    end
end

--- 月卡剩余次数
--- @return number
function M:GetMonthCardLeftTimes()
    local Avatar = self:GetAvatar()
    if Avatar then
        local NowTime = TimeUtils.NowTime()
        local LastTime = Avatar.MonthlyCardExpireTime - NowTime
        return math.floor(LastTime / CommonConst.DayTime)
    else
        return 0
    end
end

--- 当前售卖月卡最后时间
--- @return number
function M:GetMonthCardCanPurchaseTime()
    local MonthCard = self:GetNowMonthCard()
    if MonthCard then
        return MonthCard.EndTime
    else
        return 0
    end
end

--- 当前售卖月卡奖励头像信息
--- @return MonthCardReward
function M:GetRewardHeadIconInfo()
    local MonthCard = self:GetNowMonthCard()
    if MonthCard then
        return self:GetRewardInfo(MonthCard.UniqueReward)
    else
        return nil
    end 
end

--- 当前售卖月卡奖励道具信息(特殊显示Icon，优先级高)
function M:GetRewardItemIcon()
    local MonthCard = self:GetNowMonthCard()
    if MonthCard then
        return MonthCard.BuyRewardIcon
    else
        return nil
    end 
end

--- 当前售卖月卡奖励道具信息
--- @return MonthCardReward
function M:GetRewardItem()
    local MonthCard = self:GetNowMonthCard()
    if MonthCard then
        return self:GetRewardInfo(MonthCard.BuyReward)
    else
        return nil
    end 
end

function M:GetRewardNameAndIcon(RewardInfos)
    if not RewardInfos then
        return 
    end
    local Results = {}
    for _, Reward in ipairs(RewardInfos) do
        table.insert(Results, GText(ItemUtil.GetItemName(Reward.ItemId, Reward.ItemType)))
        table.insert(Results, "*" )
        table.insert(Results, Reward.Count)
        table.insert(Results, "\n")
    end
    if #Results > 0 then
        Results[#Results] = nil
    end
    local Result = table.concat(Results)
    local Icon
    if #RewardInfos > 0 then
        local Reward = RewardInfos[1]
        Icon = ItemUtils.GetItemIcon(Reward.ItemId, Reward.ItemType)
    end
    return Result, Icon
end

--- 当前售卖月卡每日奖励道具信息(特殊显示Icon，优先级高)
function M:GetRewardEveryDayItemIcon()
    local MonthCard = self:GetNowMonthCard()
    if MonthCard then
        return MonthCard.DailyRewardIcon
    else
        return nil
    end 
end

--- 当前售卖月卡每日奖励道具信息
--- @return MonthCardReward
function M:GetRewardEveryDayItem()
    local MonthCard = self:GetNowMonthCard()
    if MonthCard then
        return self:GetRewardInfo(MonthCard.DailyReward)
    else
        return nil
    end 
end

--- @return number
function M:GetMonthCardPrice()
    local MonthCard = self:GetNowMonthCard()
    if MonthCard then
        local Goods = DataMgr.PayGoods[MonthCard.GoodsId]
        local PriceType = ShopUtils:GetCurrencyPrice()
        -- DebugPrint("PriceType", PriceType)
        local Price = Goods[PriceType]
        return Price or 0
    else
        return 30
    end
end

--- @return string
function M:GetPriceSymbol()
    --- @todo 获取当前币种符号
    local CurrencySymbol = ShopUtils:GetCurrencyType()
    -- DebugPrint("CurrencySymbol", CurrencySymbol)
    return CurrencySymbol
end

--- @return 获取当前售卖月卡
function M:GetNowMonthCard()
    local Avatar = self:GetAvatar()
    if not Avatar then
        return nil
    end
    local MonthlyCards = DataMgr.MonthlyCard
    local NowMonthCard = MonthlyCards[Avatar.NowMonthCardId]
    local Time = TimeUtils.NowTime()
    if NowMonthCard and Time >= NowMonthCard.BeginTime and Time < NowMonthCard.EndTime then
        return NowMonthCard
    else
        local CurrentCard= nil
        for k, v in pairs(MonthlyCards) do
            if Time >= v.BeginTime and Time < v.EndTime then
                CurrentCard = v
                self.NowMonthCardId = CurrentCard.CardId
                break
            end
        end
        return CurrentCard
    end
    return nil
end

--- @return MonthCardReward
function M:GetRewardInfo(RewardId)
    local Reward = DataMgr.Reward[RewardId]
    if not Reward then return end
    -- local RewardTypes = Reward.Type
    -- local RewardType = RewardTypes and RewardTypes[1]
    -- if (not RewardType) then return end
    -- local RewardItemIds = Reward.Id
    -- local RewardItemIdId = RewardItemIds and RewardItemIds[1]
    -- if (not RewardId) then return end
    -- local RewardCounts = Reward.Count
    -- local RewardCount = RewardCounts and RewardCounts[1]
    -- if (not RewardCount) then return end
    local Result = {}
    local RewardTypes = Reward.Type
    local RewardItemIds = Reward.Id
    local RewardCounts = Reward.Count
    local Count = (Reward.Type and #Reward.Type) or 0
    for i = 1, Count, 1 do
        local Type = RewardTypes and RewardTypes[i]
        local ItemId = RewardItemIds and RewardItemIds[i]
        local Count = RewardCounts and RewardCounts[i]
        local Item = {
            ItemType = Type,
            ItemId = ItemId,
            Count = Count[1]
        }
        table.insert(Result, Item)
    end
    return Result
end

function M:Destory()
    M.Super.Destory(self)
end

function M:SetDailyRewardCache(DailyReward)
    self.DailyRewardCache = DailyReward 
end

function M:SetPurchaseRewardCache(PurchaseReward)
    self.PurchaseRewardCache = PurchaseReward
end

function M:ClearPurchaseRewardCache()
    self.PurchaseRewardCache = nil
end

function M:ClearDailyRewardCache()
    self.DailyRewardCache = nil
end

return M

local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties
local TimeUtils
if GWorld:IsSkynetServer() then
	TimeUtils = require "src.utils.TimeUtils"
else
	TimeUtils = require "Utils.TimeUtils"
end

local ShopItemRefreshTimeType = {
	NOREFRESH = 0,
	HOUR = 1,
	DAY = 2,
	WEEK = 3,
	MONTH = 4,
}
---@class ShopItem
local ShopItem = Class("ShopItem",CustomTypes.CustomAttr)
    ShopItem.__Props__ = {
        --商品Id
        ItemId = prop.prop("Int","client save"),
        --累计购买次数
        AlreadyPurchaseTimes = prop.prop("Int","client save",0),
        --当前周期剩余限购次数
        RemainPurchaseTimes = prop.prop("Int","client save",-1),
        --增强红点是否已读
        EnhanceRedDotCleaned = prop.prop("Bool","client save",false),
        --商品类型
        ItemType = prop.getter("Data","ItemType"),
        --目标类型Id
        TypeId = prop.getter("Data","TypeId"),
        --目标类型数量
        TypeNum = prop.getter("Data","TypeNum"),
        --售卖货币类型
        PriceType = prop.getter("Data","PriceType"),
        --商品售价
        Price = prop.getter("Data","Price"),
        --所属商城子叶签Id
        SubTabId = prop.getter("Data","SubTabId"),
        --限购次数
        PurchaseLimit = prop.getter("Data","PurchaseLimit"),
        --上架时间
        StartTime = prop.getter("Data","StartTime"),
        --下架时间
        EndTime = prop.getter("Data","EndTime"),
        --上次刷新时间
        LastRefreshTime = prop.prop("Int","client save",0),
    }

    function ShopItem:Init(ItemId)
        if not ItemId then
            return
        end
        if not DataMgr.ShopItem[ItemId] then
            return
        end
        self.ItemId = ItemId
        local PurchaseLimit = DataMgr.ShopItem[ItemId].PurchaseLimit
        if PurchaseLimit ~= nil then
            self.RemainPurchaseTimes = PurchaseLimit
        end
        self:SetRefreshTime(ItemId)
    end

    function ShopItem:Data()
        return DataMgr.ShopItem[self.ItemId]
    end

    ---@Warning 迭代记得通知客户端一起迭代
    function ShopItem:SetRefreshTime(ItemId)
        local ShopItemInfo = DataMgr.ShopItem[ItemId]
        local RefreshTime = ShopItemInfo.RefreshTime
        local RefreshTimeType = ShopItemRefreshTimeType['NOREFRESH']
        if RefreshTime then
            for key,value in pairs(RefreshTime) do
                if ShopItemRefreshTimeType[key] then
                    RefreshTimeType = ShopItemRefreshTimeType[key]
                end
            end
        end
        local StartTime
        if ShopItemInfo.NewRefreshBeginTime then
            StartTime = TimeUtils.EastEightToLocalTimestamp(ShopItemInfo.NewRefreshBeginTime)
        else
            StartTime = TimeUtils.DataToTimestamp(CommonConst.ShopRefreshBeginTime[1],
                                                CommonConst.ShopRefreshBeginTime[2],
                                                CommonConst.ShopRefreshBeginTime[3],
                                                CommonConst.ShopRefreshBeginTime[4],
                                                CommonConst.ShopRefreshBeginTime[5],
                                                CommonConst.ShopRefreshBeginTime[6])
        end
        if RefreshTimeType == ShopItemRefreshTimeType['HOUR'] then
            local year, month, day, hour, min, sec = TimeUtils.TimestampToData(StartTime)
            self.LastRefreshTime = TimeUtils.DataToTimestamp(year, month, day, hour,0,0)
        elseif RefreshTimeType == ShopItemRefreshTimeType['DAY'] then
            local year, month, day, hour, min, sec = TimeUtils.TimestampToData(StartTime)
            local refresh_hms = CommonConst.GAME_REFRESH_HMS
            self.LastRefreshTime = TimeUtils.DataToTimestamp(year, month, day, table.unpack(refresh_hms))
        elseif RefreshTimeType == ShopItemRefreshTimeType['WEEK'] then
            StartTime = StartTime - CommonConst.SECOND_IN_WEEKDAY
            local refresh_hms = CommonConst.GAME_REFRESH_HMS
            self.LastRefreshTime = TimeUtils.NextWeeklyRefreshTime(StartTime,refresh_hms)
        elseif RefreshTimeType == ShopItemRefreshTimeType['MONTH'] then
            local year, month, day, hour, min, sec = TimeUtils.TimestampToData(StartTime)
            local refresh_hms = CommonConst.GAME_REFRESH_HMS
            self.LastRefreshTime = TimeUtils.DataToTimestamp(year, month, 1, table.unpack(refresh_hms))
        else
            self.LastRefreshTime = StartTime
        end
    end

    function ShopItem:IsPurchaseLimit()
        return self.PurchaseLimit ~= nil
    end

    function ShopItem:AddAlreadyPurchaseTimes(Count)
		if type(Count) == "number" and Count > 0 then
			self.AlreadyPurchaseTimes = self.AlreadyPurchaseTimes + Count
		end
	end

    function ShopItem:ReduceRemainPurchaseTimes(Count)
        if type(Count) == "number" and Count > 0 and self.RemainPurchaseTimes >= Count then
			self.RemainPurchaseTimes = self.RemainPurchaseTimes - Count
			return true
		end
        if self.RemainPurchaseTimes == -1 then
            return true
        end
		return false
    end

    function ShopItem:IsCanBeChased()
        return self.RemainPurchaseTimes ~= 0
    end

    function ShopItem:CleanEnhanceRedDot()
        if not self.EnhanceRedDotCleaned then
            self.EnhanceRedDotCleaned = true
        end
    end

    FormatProperties(ShopItem)

---@class ShopItemDict
local ShopItemDict = Class("ShopItemDict",CustomTypes.CustomDict)
    ShopItemDict.KeyType = BaseTypes.Int
    ShopItemDict.ValueType = ShopItem

    function ShopItemDict:NewShopItem(ItemId)
        return ShopItem(ItemId)
    end

    ---@return ShopItem
    function ShopItemDict:GetShopItem(ItemId)
        if self[ItemId] == nil then
            self[ItemId] = self:NewShopItem(ItemId)
        end
        return self[ItemId]
    end

return {ShopItem = ShopItem, ShopItemDict = ShopItemDict}
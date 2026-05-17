local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties

local ImpressionShopItem = Class("ImpressionShopItem",CustomTypes.CustomAttr)
    ImpressionShopItem.__Props__ = {
        -- 商品Id
        ImpressionShopId = prop.prop("Int","client save"),
        -- 当前够买次数
        AlreadyPurchaseTimes = prop.prop("Int","client save", 0),
        -- 解锁状态
        ImpressionShopState = prop.prop("Bool","client save"),
        -- 累计购买次数
        RegionId = prop.getter("Data","RegionId"),
        -- 商品类型
        ItemType = prop.getter("Data","ItemType"),
        -- 目标类型Id
        ItemId = prop.getter("Data","ItemId"),
        -- 目标类型数量
        TypeNum = prop.getter("Data","TypeNum"),
        -- 售卖货币类型
        PriceType = prop.getter("Data","PriceType"),
        -- 商品售价
        Price = prop.getter("Data","Price"),
        -- 限购次数
        PurchaseLimit = prop.getter("Data","PurchaseLimit"),
        -- 解锁条件
        UnlockCondition = prop.getter("Data","UnlockCondition"),
        -- 鉴定ID
        ImprCheckId = prop.getter("Data","ImprCheckId"),
    }

    function ImpressionShopItem:SetShopState(NewState)
        if NewState == self.ImpressionShopState then return false end
        self.ImpressionShopState = NewState
        return true
    end

    function ImpressionShopItem:AddAlreadyPurchaseTimes()
        self.AlreadyPurchaseTimes = self.AlreadyPurchaseTimes + 1
    end

    function ImpressionShopItem:Init(ImpressionShopId)
        self.ImpressionShopId = ImpressionShopId
    end

    function ImpressionShopItem:Data()
		return DataMgr.ImpressionShop[self.ImpressionShopId]
	end

    FormatProperties(ImpressionShopItem)

local ImpressionShopItemDict = Class("ImpressionShopItemDict",CustomTypes.CustomDict)
    ImpressionShopItemDict.KeyType = BaseTypes.Int
    ImpressionShopItemDict.ValueType = ImpressionShopItem

    function ImpressionShopItemDict:NewImpressionShopItem(ItemId)
        return ImpressionShopItem(ItemId)
    end

    function ImpressionShopItemDict:GetNewImpressionShopItem( ImpressionShopId)
        if not self[ImpressionShopId]  then
            self[ImpressionShopId] = self:NewImpressionShopItem(ImpressionShopId)
        end
        return self[ImpressionShopId]
    end

    function ImpressionShopItemDict:GetImpressionShopItem(ItemId)
        return self[ItemId]
    end
return {
    ImpressionShopItemDict = ImpressionShopItemDict,
    ImpressionShopItem = ImpressionShopItem,
}
local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties
local TimeUtils = require "Utils.TimeUtils"


---@class GiftOrder
local GiftOrder = Class("GiftOrder", CustomTypes.CustomAttr)
---@type GiftOrder
GiftOrder.__Props__ = {
    -- 订单号（PaymentMgr 返回的 gameOrder）
    OrderId = prop.prop("Str", "client save", ""),

    -- 收礼人
    Uid = prop.prop("Int", "client save", 0),

    -- 商品（PayGoodsId）
    GoodsId = prop.prop("Str", "client save", 0),

    -- 支付成功/已发放标志
    PaySucc = prop.prop("Bool", "client save", false),
    Sent    = prop.prop("Bool", "client save", false),

    -- 文本内容
    Content = prop.prop("Str", "client save", ""),

    -- 本单占用额度（用于支付回调 ConsumeGiftQuotaReal）
    NeedGiftQuota = prop.prop("Int", "client save", 0),
}
FormatProperties(GiftOrder)
---@class GiftOrderDict
local GiftOrderDict = Class("GiftOrderDict", CustomTypes.CustomDict)
GiftOrderDict.KeyType = BaseTypes.Str
GiftOrderDict.ValueType = GiftOrder
function GiftOrderDict:FindOrAdd(OrderId)
	if not self[OrderId] then
		self[OrderId] = GiftOrder()
		self[OrderId].OrderId = OrderId
	end
	return self[OrderId]
end

---@class GiftRecord
local GiftRecord = Class("GiftRecord", CustomTypes.CustomAttr)
---@type GiftRecord
GiftRecord.__Props__ = {
    Uid = prop.prop("Int", "client save"),
    Time = prop.prop("Int", "client save"),
	GoodsId = prop.prop("Str", "client save"),
	ShopItemId = prop.prop("Int", "client save"),
	Count = prop.prop("Int", "client save"),
	Content = prop.prop("Str", "client save"),
	MailUniqueId = prop.prop("Int", "client save"), -- 哪一封邮件 只有收礼记录需要
	RewardGot = prop.prop("Int", "client save"), -- 已领取会变成时间戳
	SaLogId = prop.prop("Int", "client save"), -- 发送方发送记录的Index
}

FormatProperties(GiftRecord)
---@class GiftRecordList
local GiftRecordList = Class("GiftRecordList", CustomTypes.CustomList)
GiftRecordList.ValueType = GiftRecord
function GiftRecordList.NewRecord()
	return GiftRecord()
end
-- =========================================================

return {
    GiftOrder = GiftOrder,
    GiftOrderDict = GiftOrderDict,
    GiftRecord = GiftRecord,
    GiftRecordList = GiftRecordList,
}

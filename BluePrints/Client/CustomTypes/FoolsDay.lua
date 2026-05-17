local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties
local TimeUtils = require "Utils.TimeUtils"

local FoolsDayLikeRecord = Class("FoolsDayLikeRecord", CustomTypes.CustomAttr)
FoolsDayLikeRecord.__Props__ = {
    Records = prop.prop("Int2IntDict", "client save"),
}
FormatProperties(FoolsDayLikeRecord)
local FoolsDayLikeRecordDict = Class("FoolsDayLikeRecordDict", CustomTypes.CustomDict)
FoolsDayLikeRecordDict.ValueType = FoolsDayLikeRecord
FoolsDayLikeRecordDict.KeyType = BaseTypes.Int

function FoolsDayLikeRecordDict:FindOrAdd(UniqueId)
	if not self[UniqueId] then
		self[UniqueId] = FoolsDayLikeRecord()
	end
	return self[UniqueId]
end
return {
    FoolsDayLikeRecord = FoolsDayLikeRecord,
    FoolsDayLikeRecordDict = FoolsDayLikeRecordDict,
}

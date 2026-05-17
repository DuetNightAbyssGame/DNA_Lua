local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties

---@class GuideBook
local GuideBook = Class("GuideBook", CustomTypes.CustomAttr)
	---@type GuideBook 方便智能提示
	GuideBook.__Props__ = {
		GuideNoteId = prop.prop("Int", "client save"),
		Reward = prop.prop("Int", "client save",1),
		Sort = prop.prop("Int", "client save"),
		IsGettingReward = prop.prop("Int", ""),
	}

	function GuideBook:Init(GuideNoteId,Sort)
        self.GuideNoteId = GuideNoteId
        self.Sort = Sort
	end

	FormatProperties(GuideBook)

---@class GuideBookDict
local GuideBookDict = Class("GuideBookDict", CustomTypes.CustomDict)
	GuideBookDict.KeyType = BaseTypes.Int
	GuideBookDict.ValueType = GuideBook

	function GuideBookDict:NewGuideBook(GuideNoteId)
		self[GuideNoteId] = GuideBook(GuideNoteId,self:Length()+1)
	end

return {
    GuideBook = GuideBook,
    GuideBookDict = GuideBookDict,
}

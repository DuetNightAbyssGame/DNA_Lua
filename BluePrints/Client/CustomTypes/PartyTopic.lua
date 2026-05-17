local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties

---@class PartyTopic
---@field PartyTopicId number
---@field IsRedDot boolean

local PartyTopic = Class("PartyTopic", CustomTypes.CustomAttr)
	PartyTopic.__Props__ = {
		--话题Id
		PartyTopicId = prop.prop("Int", "client save"),
		--话题聊天状态
        State = prop.prop("Int", "client save", 0), -- 0：未解锁，1：已解锁，2：已完成

		ConditionId = prop.getter("Data", "ConditionId"),
		PartyTopicConsume = prop.getter("Data", "PartyTopicConsume"),
		PartyTopicReward = prop.getter("Data", "PartyTopicReward"),
	}

	function PartyTopic:Init(PartyTopicId)
		if not PartyTopicId then
			return
		end
		self.PartyTopicId = PartyTopicId
	end

	function PartyTopic:Data()
		return DataMgr.PartyTopic[self.PartyTopicId]
	end

	function PartyTopic:IsLocked()
        return self.State == 0
    end

	function PartyTopic:IsUnLock()
		return self.State == 1
	end

	function PartyTopic:IsCompleted()
		return self.State == 2
	end

    function PartyTopic:UnLock()
        if self:IsLocked() then
            self.State = 1
        end
    end

	function PartyTopic:Complete()
		if self:IsUnLock() then
			self.State = 2
		end
	end

	FormatProperties(PartyTopic)

---@class PartyTopicList
local PartyTopicList = Class("PartyTopicList", CustomTypes.CustomList)
	PartyTopicList.ValueType = PartyTopic

	function PartyTopicList:NewPartyTopic(PartyTopicId)
        local _PartyTopic = PartyTopic(PartyTopicId)
        return _PartyTopic
	end


return {PartyTopic = PartyTopic, PartyTopicList = PartyTopicList}

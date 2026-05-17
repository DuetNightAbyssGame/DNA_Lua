local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties


---@class Message
---@field Sender AvatarInfo
---@field Receiver AvatarInfo
local Message = Class("Message", CustomTypes.CustomAttr)
	---@type Message
	Message.__Props__ = {
		-- 消息内容
		Content = prop.prop("Str", "client save"),
		-- 消息发送时间
		Time = prop.prop("Float", "client save"),
		-- 消息发送者
		Sender = prop.prop("AvatarInfo.AvatarInfo", "client save"),
		-- 消息接收者
		Receiver = prop.prop("ObjId", "client save"),
		-- 消息接收者 Uid
		ReceiverUid = prop.prop("Int", "client save"),
		-- 消息类型
		Type = prop.prop("Int", "client save"),
		-- 世界频道类型
		ChannelType = prop.prop("Int", "client save", 0),
	}


	function Message:Init(mtype)
		self.Type = mtype
	end

	function Message:Serialize()
		return self:all_dump(self)
	end

	FormatProperties(Message)


---@class Messages
local Messages = Class("Messages", CustomTypes.CustomList)
	Messages.ValueType = Message


return {
	Message = Message,
	Messages = Messages,
}

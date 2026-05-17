local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties
-- CommonConst = require "CommonConst"

---@class Chat
local Chat = Class("Chat", CustomTypes.CustomAttr)
	---@type Chat
	Chat.__Props__ = {
		-- 对方的Eid
		Uid = prop.prop("Int", "client save"),
		-- 对方信息
		PlayerInfo = prop.prop("AvatarInfo.AvatarInfo", "client save"),
		-- 聊天内容
		Messages = prop.prop("Message.Messages", "client save"),
		-- 最近的聊天时间
		LastTime = prop.prop("Float", "client save"),
		-- 最近的聊天内容
		LastMessage = prop.prop("Message.Message", "client save"),
		-- 未读的聊天数量
		UnreadCount = prop.prop("Int", "client save"),
	}

	function Chat:Init(player)
		if not player then
			return
		end
		self.Uid = player.Uid
		self.PlayerInfo = player
	end

	function Chat:AddMessage(message, by_myself)
		if self.Messages:Length() >= DataMgr.Channel[CommonConst.ChatChannel.Friend].MessageMax then
			self.Messages:Pop(1)
		end

		self.LastTime = math.max(self.LastTime, message.Time)
		self.LastMessage = message
		self.Messages:Append(message)
	end

	function Chat:AddUnreadCount()
		if self.UnreadCount >= DataMgr.Channel[CommonConst.ChatChannel.Friend].MessageMax then
			self.UnreadCount = self.UnreadCount - 1
		end
		self.UnreadCount = self.UnreadCount + 1
	end

	function Chat:ClearUnreadCount()
		self.UnreadCount = 0
	end

	function Chat:GetUnreadCount()
		local MaxUnreadCount = DataMgr.Channel[CommonConst.ChatChannel.Friend].MessageMax
		if self.UnreadCount>MaxUnreadCount then
			return MaxUnreadCount
		else return self.UnreadCount end
	end

--region for client
	function Chat:SetMsgCache(MsgText)
		self.MsgCache = MsgText
	end

	function Chat:GetMsgCache()
		if not self.MsgCache then
			return ""
		end
		return self.MsgCache
	end
--endregion


	FormatProperties(Chat)


---@class ChatDict
local ChatDict = Class("ChatDict", CustomTypes.CustomDict)
    ChatDict.KeyType = BaseTypes.Int
    ChatDict.ValueType = Chat

	function ChatDict:NewChat(player)
		local chat = Chat(player)
		return chat
	end



return {
	Chat = Chat,
	ChatDict = ChatDict,
}

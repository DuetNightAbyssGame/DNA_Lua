local Decorator = require "BluePrints.Client.Wrapper.Decorator"
local ChatController = require "BluePrints.UI.WBP.Chat.ChatController"
local MiscUtils = require "Utils.MiscUtils"
local Component = {}
Decorator:ApplyDecorator(Component)

local Trim = function (input)
	return (string.gsub(input, "^%s*(.-)%s*$", "%1"))
end


function Component:EnterWorld()
	ChatController:Init()
	self.InWorldChatChannel = {}
	self.InWorldChatChannel[CommonConst.ChatChannel.Help] = false
	self.InWorldChatChannel[CommonConst.ChatChannel.TeamUp] = false
	self.InWorldChatChannel[CommonConst.ChatChannel.RegionOnline] = false
end

function Component:LeaveWorld()
	ChatController:Destory()
end

function Component:OnReconnectSuccessChatComp()
	if not self.InWorldChatChannel then
		return
	end
	local st1 = self.InWorldChatChannel[CommonConst.ChatChannel.Help]
	local st2 = self.InWorldChatChannel[CommonConst.ChatChannel.TeamUp]
	if st1 or st2 then
		self.InWorldChatChannel = {}
		self.InWorldChatChannel[CommonConst.ChatChannel.Help] = false
		self.InWorldChatChannel[CommonConst.ChatChannel.TeamUp] = false
		self:RequestEnterWorldChannel(CommonConst.ChatChannel.Help, -1)
		self:RequestEnterWorldChannel(CommonConst.ChatChannel.TeamUp, -1)
	end
	self.InWorldChatChannel[CommonConst.ChatChannel.RegionOnline] = false
end

--region 世界频道聊天

--- 请求进入频道
---@param channel_type integer 频道类型
function Component:RequestEnterWorldChannel(channel_type)
	self.logger.debug("RequestEnterWorldChannel: ".. channel_type)
	if self.InWorldChatChannel[channel_type] then
		return
	end
	self:CallServerMethod("RequestEnterWorldChannel", channel_type, -1)
end

--- 收到请求进入世界频道的回复
---@param channel_type integer 频道类型
---@param ret integer 错误码
function Component:OnRequestEnterWorldChannel(channel_type, ret, channel_index)
	self.logger.debug("OnRequestEnterWorldChannel: ".. channel_type.. " ret: ".. ret)
	if ChatController:CheckError(ret, true) then
		self.InWorldChatChannel[channel_type] = true
	end
	ChatController:RecvRequestEnterChatChannel(ret, channel_type)
end

--- 请求离开世界频道
---@param channel_type integer 频道类型
function Component:RequestLeaveWorldChannel(channel_type)
	self.logger.debug("RequestLeaveWorldChannel: ".. channel_type)
	if not self.InWorldChatChannel[channel_type] then
		return
	end
	self:CallServerMethod("RequestLeaveWorldChannel", channel_type)
	self.InWorldChatChannel[channel_type] = false
end

function Component:OnRequestLeaveWorldChannel(channel_type, ret)
	self.logger.debug("OnRequestLeaveWorldChannel: ".. channel_type.. " ret: ".. ret)
end

function Component:GMGetMyChatChannelInfo()
	local function callback(channel_info)
		self.logger.debug("GMGetMyChatChannelInfo: channel_info: ")
		DebugPrintTable(channel_info)
	end
	self:CallServer("GMGetMyChatChannelInfo", callback)
end

function Component:GMGetAllChatChannelInfo(Callback)
	local function callback(channel_infos)
		self.logger.debug("GMGetAllChatChannelInfo: channel_infos: ")
		DebugPrintTable(channel_infos)
	end
	self:CallServer("GMGetAllChatChannelInfo", callback)
end


Component:LimitCall(CommonConst.CHAT_INTERVAL)
--- 发送世界聊天消息
---@param channel_type number 聊天频道类型
---@param content string 聊天内容
function Component:ChatToWorld(channel_type, content)
	self.logger.debug("Sending content to channel: ".. channel_type.. " content: ".. content)
	local ret = self:CheckChatToWorld(channel_type, content)
	if not ChatController:CheckError(ret, true) then
		return
	end

	local callback = function (Ret)
		if not ChatController:CheckError(Ret, true) then
			self.logger.debug("ChatToWorld: ErrorCode: ".. Ret)
			return
		end
		ChatController:RecvChatToWorld(channel_type, content)
	end
	self:CallServer("ChatToWorld", callback, channel_type, content)
end

function Component:CheckChatToWorld(channel_type, content)
	if not self.InWorldChatChannel[channel_type] then
		return ErrorCode.RET_CHAT_NOT_JOIN_CHANNEL
	end
	if not content then
		return ErrorCode.RET_CHAT_MESSAGE_EMPTY
	end
	local real_content = MiscUtils.Trim(content)
	if real_content == "" then
		return ErrorCode.RET_CHAT_MESSAGE_EMPTY
	end
	return ErrorCode.RET_SUCCESS
end

--- Server Call Client
function Component:WorldChatRequest(message)
	self:HandleChatRequest(message)
end

function Component:WorldChatRequests(messages)
	for i, message in ipairs(messages) do
		self:WorldChatRequest(message)
	end
end
--endregion


--region 私聊

--Component:LimitCall(CommonConst.CHAT_INTERVAL) @note 这个LimitCall会妨碍UI表现，不使用这里的LimitCall，在UI层面做限制
--- 发送私聊消息，目前只支持好友之间私聊
---@param uid integer 好友uid
---@param content string 聊天内容·
function Component:ChatToPlayer(uid, content)
	self.logger.debug("Sending content to player: ".. uid .. " content: ".. content)
	local ret = self:CheckChatToPlayer(uid, content)
	if not ChatController:CheckError(ret, true) then
		return
	end

	local callback = function (Ret)
		self.logger.debug("ChatToPlayer: ErrorCode: ".. Ret)
		if not ChatController:CheckError(Ret, true) then
			return
		end
		ChatController:RecvChatToPlayer(uid, content)
	end
	self:CallServer("ChatToPlayer", callback, uid, content)
end

function Component:CheckChatToPlayer(uid, content)
	if not content then
		return ErrorCode.RET_CHAT_MESSAGE_EMPTY
	end
	local real_content = MiscUtils.Trim(content)
	if real_content == "" then
		return ErrorCode.RET_CHAT_MESSAGE_EMPTY
	end
	if self.Blacklist[uid] then
		return ErrorCode.RET_CHAT_BLACKLISTED_PLAYER
	end
	return ErrorCode.RET_SUCCESS
end

--- 收到私聊消息请求
---@param message table 聊天消息
---@param by_myself boolean 是否是自己发的
function Component:PlayerChatRequest(message, by_myself)
	-- 对方的 eid，AvatarInfo 对象
	local other_uid, other
	if by_myself then
		other_uid = message.ReceiverUid
		other = self.Friends[other_uid]
		other = other.Info
	else
		other_uid = message.Sender.Uid
		other = message.Sender
	end

	if not other then
		self.logger.debug("PlayerChatRequest: other is nil")
		return
	end

	local chat = self.Chats[other_uid]
	if not chat then
		chat = self.Chats:NewChat(other)
	else
		chat.PlayerInfo = other
	end

	chat:AddMessage(message, by_myself)

	self.Chats[other_uid] = chat

	self:HandleChatRequest(message)
end

--- 客户端处理聊天消息
---@param message Message 聊天消息
function Component:HandleChatRequest(message)
	-- todo:客户端处理聊天消息
	self.logger.debug("HandleChatRequest: message: ".. message.Content)
	ChatController:HandleChatMessage(message)
end

--- 读取聊天记录
---@param uid integer 聊天对象uid
function Component:ReadChat(uid)
	local function callback(ret)
		if not ChatController:CheckError(ret, true) then
			return
		end
		ChatController:RecvChatNewMsgRead(uid)
	end
	self:CallServer("ReadChat", callback, uid)
end

--endregion

--region 快捷消息

--- 更改快捷消息
---@param index integer 快捷消息索引
---@param content string 快捷消息内容
function Component:ChangeQuickMessage(index, content)
	local function callback(Ret)
		if not ChatController:CheckError(Ret, true) then
			return
		end
		ChatController:RecvChangeQuickMessage(index)
	end

	self:CallServer("ChangeQuickMessage", callback, index, content)
end

function Component:InitQuickMessage(SystemLanguage)
	local QuickMessages = {}
	for Id, Data in ipairs(DataMgr.DefaultQuickMsg) do
		local TextMap = DataMgr["TextMap_" .. SystemLanguage][Data.Text]
		if TextMap then
			local Text = TextMap[SystemLanguage]
			if Text then
				QuickMessages[#QuickMessages + 1] = Text
			end
		end
	end
	local function callback(ret)
		
	end
	self:CallServer("InitQuickMessage", callback, table.concat(QuickMessages, "_"))
end

--endregion

--region 表情包

--- 增加表情包
---@param emotion_id integer 表情包ID
function Component:AddEmotion(emotion_id)
	local function callback(Ret)
		if Ret == ErrorCode.RET_EMOTION_ID_EXIST  then
			DebugPrint("表情包重复添加了，但是不影响。。。。。。。。。")
			return
		end
		if not ChatController:CheckError(Ret, true)then
			return
		end
		ChatController:RecvAddEmotion(emotion_id)
	end

	self:CallServer("AddEmotion", callback, emotion_id)
end

--- 删除表情包
---@param emotion_id integer 表情包ID
function Component:RemoveEmotion(emotion_id)
	local function callback(Ret)
		if not ChatController:CheckError(Ret, true) then
			return
		end
		ChatController:RecvRemoveEmotion(emotion_id)
	end

	self:CallServer("RemoveEmotion", callback, emotion_id)
end


--endregion


--region 组队聊天

function Component:ChatToTeam(content)
	self.logger.debug("ChatToTeam", content)
	local callback = function (Ret)
		self.logger.debug("ChatToTeam: ErrorCode: ".. Ret)
		if not ChatController:CheckError(Ret, true) then
			return
		end
		ChatController:RecvChatToTeam(content)
	end
	self:CallServer("ChatToTeam", callback, content)
end

--- Server Call Client
function Component:TeamChatRequest(message)
	self:HandleChatRequest(message)
end

--endregion

--region 组队聊天

function Component:ChatToSettlementOnline(content)
	self.logger.debug("ChatToSettlementOnline", content)
	local callback = function (Ret)
		self.logger.debug("ChatToSettlementOnline: ErrorCode: ".. Ret)
		if not ChatController:CheckError(Ret, true) then
			return
		end
		ChatController:RecvChatToSettlementOnline(content)
	end
	self:CallServer("ChatToSettlementOnline", callback, content)
end

--- Server Call Client
function Component:SettlementOnlineChatRequest(message)
	self:HandleChatRequest(message)
end

--endregion



--region 禁言

--- 禁言回调
---@param time number 禁言结束时间点
---@param reason string 禁言原因
---@param timeDelta number 距离禁言结束时间
function Component:OnForbidChat(time, reason,timeDelta)
	DebugPrint("OnForbidChat", time, reason)
	
	ChatController:OpenForbidChatDialog(time, reason,timeDelta)
	
end

--endregion


-- 举报聊天
function Component:ReportChat(reason, remark, chat_message,InCallBack)
	local callback = function (Ret)
		self.logger.debug("ReportChat: ErrorCode: ".. Ret)
		if InCallBack then
			InCallBack(Ret)
		end
		local IsError = ErrorCode:Check(Ret,UIConst.Tip_CommonToast)
		if not IsError then
			return
		end
		UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Chat_ReportSuccess"))
	end
	-- DebugPrint(TXTTag, "ReportChat", reason, remark, chat_message)
	-- PrintTable(chat_message, 2,TXTTag.."See message of ReportChat")
	self:CallServer("ReportChat", callback, reason, remark, chat_message)
end

-- 举报匹配
function Component:ReportMatch(Uid, Nickname, Level, reason, InCallBack)
	local callback = function (Ret)
		self.logger.debug("ReportMatch: ErrorCode: ".. Ret)
		if InCallBack then
			InCallBack(Ret)
		end
		local IsError = ErrorCode:Check(Ret,UIConst.Tip_CommonToast)
		if not IsError then
			return
		end
		UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Chat_ReportSuccess"))
	end
	
	local Info = {Nickname = Nickname, Level = Level, Reason = reason, Remark = "举报匹配"}
	self:CallServerMethod("ReportMatch",Uid,Info)
	callback(ErrorCode.RET_SUCCESS)
end

-- 举报违规照片
function Component:ReportPhoto(Uid, Nickname, Level, PictureUniqueId, Url, reason, InCallBack)
	local callback = function (Ret)
		self.logger.debug("ReportPhoto: ErrorCode: ".. Ret)
		if InCallBack then
			InCallBack(Ret)
		end
		local IsError = ErrorCode:Check(Ret,UIConst.Tip_CommonToast)
		if not IsError then
			return
		end
		UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Chat_ReportSuccess"))
	end
	local Info = {Nickname = Nickname, Level = Level, Reason = reason, Remark = "举报违规照片", PictureUniqueId = PictureUniqueId, Url = Url}
	self:CallServerMethod("ReportAfdayPhoto",Uid,Info)
	callback(ErrorCode.RET_SUCCESS)
end



-- 发送mod配置
function Component:SendModSuitToWorld(InCallbackInfo, channel_type, tag, eid, mod_suit_index)
	local callback = function (Ret)
		self.logger.debug("SendModSuitToWorld: ErrorCode: ".. Ret)
		InCallbackInfo.Func(InCallbackInfo.Obj, Ret, channel_type, tag, eid, mod_suit_index)
	end
	self:CallServer("SendModSuitToWorld", callback, channel_type, tag, eid, mod_suit_index)
end

-- 设置聊天频道免打扰
function Component:SetChatChannelMute(channel_type)
	self.logger.debug(string.format("SetChatChannelMute, channel_type:%s", channel_type))
	if not DataMgr.Channel[channel_type] then
		return
	end
	local function callback(ret)
		if not ChatController:CheckError(ret,true) then
			return false
		end
		ChatController:ClearChannelReddot(channel_type)
	end
	self:CallServer("SetChatChannelMute", callback, channel_type)
end


-- 解除聊天频道免打扰
function Component:CancelChatChannelMute(channel_type)
	self.logger.debug(string.format("CancelChatChannelMute, channel_type:%s", channel_type))
	if not DataMgr.Channel[channel_type] then
		return
	end
	local function callback(ret)
		
	end
	self:CallServer("CancelChatChannelMute", callback, channel_type)
end

-- 关闭频道
function Component:SetChatChannelClose(channel_type)
	self.logger.debug(string.format("SetChatChannelClose, channel_type:%s", channel_type))
	ChatController:RecvChatChannelSwitch(channel_type, true)
end

-- 打开频道
function Component:SetChatChannelOpen(channel_type)
	self.logger.debug(string.format("SetChatChannelOpen, channel_type:%s", channel_type))
	ChatController:RecvChatChannelSwitch(channel_type, false)
end

function Component:GMSetChatChannelClose(channel_type)
	self:CallServerMethod("GMSetChatChannelClose", channel_type)
end

function Component:GMSetChatChannelOpen(channel_type)
	self:CallServerMethod("GMSetChatChannelOpen", channel_type)
end

---进入指定频道
function Component:RequestEnterWorldOneChannel(channel_type, index)
	self:CallServerMethod("RequestEnterWorldChannel", channel_type, index)
end

---@param channel_index_list number[]
function Component:QueryChatChannelBusyInfo(channel_index_list)
	self:CallServerMethod("QueryChatChannelBusyInfo", CommonConst.ChatChannel.Help, channel_index_list)
end
function Component:OnQueryChatChannelBusyInfo(channel_type, channel_list)
	for k,v in pairs(channel_list) do
		self.logger.debug(string.format("OnQueryChatChannelBusyInfo, channel_type:%s, channel_index:%s, channel_membernum:%s", channel_type, tostring(k), tostring(v)))
	end
end

function Component:QueryAllChatChannelBusyInfo()
	self:CallServerMethod("QueryAllChatChannelBusyInfo", CommonConst.ChatChannel.Help)
end
function Component:OnQueryAllChatChannelBusyInfo(channel_type, channel_list)
	for k,v in pairs(channel_list) do
		self.logger.debug(string.format("OnQueryAllChatChannelBusyInfo, channel_type:%s, channel_index:%s, channel_membernum:%s", channel_type, tostring(k), tostring(v)))
	end
end


return Component
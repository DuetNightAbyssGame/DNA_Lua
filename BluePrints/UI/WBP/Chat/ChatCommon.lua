---@class ChatCommon
---@field MsgType table
local ChatCommon = {}

ChatCommon.ChannelDef = {
    ["TeamUp"] = CommonConst.ChatChannel.TeamUp,
    ["Public"] = CommonConst.ChatChannel.Help,
    --["League"] = CommonConst.ChatChannel.League,
    ["InTeam"] = CommonConst.ChatChannel.InTeam,
    ["Friend"] = CommonConst.ChatChannel.Friend,
    ["Region"] = CommonConst.ChatChannel.RegionOnline,
    ["SettlementOnline"] = CommonConst.ChatChannel.SettlementOnline,
}

ChatCommon.ChannelNames = {}
for K,V in pairs(ChatCommon.ChannelDef) do
    ChatCommon.ChannelNames[V] = K
end

ChatCommon.WorldChannels = {
    [CommonConst.ChatChannel.TeamUp] = true,
    [CommonConst.ChatChannel.Help] = true,
}

ChatCommon.UIName = "ChatMain"
ChatCommon.MainUIId = 17

ChatCommon.EventID = {
    OpenMainView = "OpenMainView",
    CloseMainView = "CloseMainView",
    EnterChatChannel = "EnterWorldChannel",
    ChatMsgSent = "ChatMsgSent",
    ChatMsgRecv = "ChatMsgRecv",
    QuickMsgChanged = "QuickMsgChanged",
    EmotionAdded = "EmotionAdded",
    EmotionRemoved = "EmotionRemoved",
    SelectPlayerToChat = "SelectPlayerToChat",
    SendCDTimerUpdate = "SendCDTimerUpdate",
    OnChatBtnListOpen = "OnChatBtnListOpen",
    RecvStickerInPubChannels = "RecvStickerInPubChannels",
}

ChatCommon.MsgType = {
    Other = 0, -- 自己发的消息
    Self = 1, -- 其他人发的消息
    System = 2, -- 系统消息
    --NewTip = 3, -- 新消息分界线
    Time = 4, -- 消息时间
}

ChatCommon.IgnoreSensitiveCheck = false
ChatCommon.DefaultCD = 1

ChatCommon.RichTextTag = {
    Friend= "C_Friend",
    Stranger = "C_Open",
    Self = "Default"
}

ChatCommon.QuickMsgEditDialog= 100091
ChatCommon.AccuseDialog = 100090
ChatCommon.ForbidChatDialog = 100111

ChatCommon.EmojiGroupId = 0

ChatCommon.ReddotMaxCount = 99

ChatCommon.ReddotNamePre = "Chat_"
ChatCommon.ReddotName = "ChatMainMenu"

ChatCommon.Spliter = ": "

ChatCommon.ModSuitCopyHeader = "ModSuitInfo:"
ChatCommon.DyePlanCopyHeader = "DyePlanInfo:"
ChatCommon.GiftCopyHeader = "ChatGift:"
ChatCommon.ChatFocusType = {
    Default = 0,
    PlayerList = 1,
    ScrollBox = 2,
    SelectChat = 3,
    InputField = 4,
    QuickReply = 5,
    ChatFace = 6
}
_G.ChatCommon = ChatCommon
return ChatCommon
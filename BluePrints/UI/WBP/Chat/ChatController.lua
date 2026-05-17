local ChatModel = require "BluePrints.UI.WBP.Chat.ChatModel"
local ChatCommon = require "BluePrints.UI.WBP.Chat.ChatCommon"
local TimeUtils = require "Utils.TimeUtils"
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"
local MiscUtils = require "Utils.MiscUtils"
local json = require "rapidjson"

---@class ChatController:Controller
---@field private _View WBP_Chat_Main_P_C
local M=Class("BluePrints.Common.MVC.Controller")

--region Override
function M:Init()
    M.Super.Init(self)
    EventManager:AddEvent(EventID.OnlineRegionChange, self, self.OnRegionChange)
    self.bTipIgnoreBattle = true
    -- for GroupId,Data in pairs(DataMgr.EmojiGroup) do
    --     if Data.bDefault then
    --         self:SendAddEmotion(GroupId)
    --     end
    -- end
    if ChatModel:GetQuickMsgDatas():Length() == 0 then
        self:SendInitQuickMessage(CommonConst.SystemLanguage)
    end
end

function M:Destory()
    EventManager:RemoveEvent(EventID.OnlineRegionChange, self)
    for _,ChannelType in pairs(ChatCommon.ChannelDef) do
        local CdTimer = self:GetModel():GetChannelCDTimerKey(ChannelType)
        self:SendRequestLeaveChatChannel(ChannelType)
        self:StopTimer(CdTimer)
    end
    M.Super.Destory(self) 
end

function M:OnRegionChange(OldState, NewState)
    if NewState == OldState then return end
    if NewState == false then
        ChatModel:ReadChannelMessage(ChatCommon.ChannelDef.Region)
    end
end

function M:GetModel()
    return ChatModel
end

function M:GetEventName()
    return EventID.ChatControllerEvent
end

function M:OpenView(WorldContex, bBattle)
    return M.Super.OpenView(self, WorldContex, ChatCommon.MainUIId, true, bBattle)
end

function M:GetView(WorldContex)
    return M.Super.GetView(self, WorldContex, ChatCommon.UIName)
end

--重写播放声音事件
function M:OverrideButtonSound(button, soundEvent, eventKey)
    button:TryOverrideSoundFunc(function()
        AudioManager(button):PlayUISound(button, soundEvent, eventKey, nil)
    end)
end
--endregion

--region 网络请求
function M:SendChatToPlayer(Uid, ContentText)
    local ModContent = self:TryParseMyModSuitInfo(ContentText)
    if ModContent then
        ContentText = ModContent
    end
    local DyeShareContent = self:TryParseMyDyePlanInfo(ContentText)
    if DyeShareContent and not ModContent then
        ContentText = DyeShareContent
    end
    local GiftContent = self:TryParseGiftInfo(ContentText)
    if GiftContent and not ModContent and not DyeShareContent then
        ContentText = GiftContent
    end
    self:GetAvatar():ChatToPlayer(Uid,ContentText)
end
---@note 私聊消息走HandleChatMessage，因此不需要创建FakeMessage
function M:RecvChatToPlayer(Uid, ContentText)
    if ChatModel:IsChannelExclude(ChatCommon.ChannelDef.Friend) then
        return
    end
    --@note 由于服务端未读的消息不会考虑发送者差异，所以这里直接将消息标为已读，让未读数量是正确的
    self:SendChatNewMsgRead()
end

function M:RecvChatChannelSwitch(ChannelType, bOff)
    local LastCurrChannel = ChatModel:GetCurrentChannel()
    ChatModel:UpdateCurrentChannel()
    local ChannelConf = DataMgr.Channel[ChannelType]
    local Msg = nil
    if bOff then
        self:SendRequestLeaveChatChannel(ChannelType)
        self:ClearChannelReddot(ChannelType)
        Msg = string.format(GText("UI_Chat_ChannelClose_Toast"),GText(ChannelConf.Name))
    else
        self:SendRequestEnterChatChannel(ChannelType)
        Msg = string.format(GText("UI_Chat_ChannelOpen_Toast"),GText(ChannelConf.Name))
    end
    if Msg then
        self:ShowToast(Msg)
    end
    if IsValid(self:GetView()) then
        self:GetView():Close()
    else
        local bCloseCurrentChannel = (ChannelType == LastCurrChannel)
        self:NotifyEvent(ChatCommon.EventID.CloseChatChannel, bCloseCurrentChannel)
    end
end

function M:SendRequestEnterChatChannel(ChannelType)
    if ChannelType == nil then 
        ChannelType = ChatModel:GetCurrentChannel()
    end
    if ChatModel:IsChannelExclude(ChannelType) then
        return
    end
    if not self:GetModel().EnteredChannels then
        DebugPrint(ErrorTag, "其他模块初始化失败导致聊天模块初始化进行不下去，这不是聊天的问题!!!!看看上边有没有trace!!!!!!!")
        return 
    end
    if not ChatCommon.WorldChannels[ChannelType] or self:GetModel().EnteredChannels[ChannelType] then
        self:RecvRequestEnterChatChannel(ErrorCode.RET_SUCCESS,ChannelType)
        return
    end
    --联机区域的聊天频道进出有服务端管理 ，客户端做一下假
    if ChannelType == ChatCommon.ChannelDef.Region then
        self:RecvRequestEnterChatChannel(ErrorCode.RET_SUCCESS,ChannelType)
        return
    end
    self:GetAvatar():RequestEnterWorldChannel(ChannelType)
end
function M:RecvRequestEnterChatChannel(ErrCode, ChannelType)
    self:GetModel().EnteredChannels[ChannelType] = 1
    self:NotifyEvent(ChatCommon.EventID.EnterChatChannel, ErrCode, ChannelType)
end

function M:SendRequestLeaveChatChannel(ChannelType)
    self:GetModel().EnteredChannels[ChannelType] = nil
    if ChannelType == nil then ChannelType = ChatModel:GetCurrentChannel() end
    if not ChatCommon.WorldChannels[ChannelType] then
        return 
    end
    if ChannelType ~= ChatCommon.ChannelDef.Region then
        self:GetAvatar():RequestLeaveWorldChannel(ChannelType)
    else
        self:GetModel():ClearReddotCount(ChannelType)
    end
end

function M:SendChatToWorld(ChannelType,ContentText)
    local ModContent = self:TryParseMyModSuitInfo(ContentText)
    if ModContent then
        ContentText = ModContent
    end
    local DyeShareContent = self:TryParseMyDyePlanInfo(ContentText)
    if DyeShareContent and not ModContent then
        ContentText = DyeShareContent
    end
    self:GetAvatar():ChatToWorld(ChannelType,ContentText)
end

function M:RecvChatToWorld(ChannelType, ContentText)
    if ChatModel:IsChannelExclude(ChannelType) then
        return
    end
    ---@type Message
    local FakeMessage = self:CreateFakeMsg(ContentText,CommonConst.MESSAGE_TYPE_SELF,ChannelType)
    self:_AddMessage(FakeMessage, false)
end

function M:SendChatToTeam(ContentText)
    local ModContent = self:TryParseMyModSuitInfo(ContentText)
    if ModContent then
        ContentText = ModContent
    end
    local DyeShareContent = self:TryParseMyDyePlanInfo(ContentText)
    if DyeShareContent and not ModContent then
        ContentText = DyeShareContent
    end
    --联机队伍频道使用ds聊天
    if not GWorld:IsStandAlone() then
        local PC = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
        if IsValid(PC) then
            local SinglePC = PC:Cast(UE4.ASinglePlayerController)
            if IsValid(SinglePC) then
                SinglePC:ChatAll(ContentText)
                return
            end
        end
    end 
    self:GetAvatar():ChatToTeam(ContentText)
end

function M:RecvChatToTeam(ContentText)
    if ChatModel:IsChannelExclude(ChatCommon.ChannelDef.InTeam) then
        return
    end
    ---@type Message
    local FakeMessage = self:CreateFakeMsg(ContentText,CommonConst.MESSAGE_TYPE_SELF, ChatCommon.ChannelDef.InTeam)
    self:_AddMessage(FakeMessage, false)
end

function M:SendChatToSettlementOnline(ContentText)
    local ModContent = self:TryParseMyModSuitInfo(ContentText)
    if ModContent then
        ContentText = ModContent
    end
    local DyeShareContent = self:TryParseMyDyePlanInfo(ContentText)
    if DyeShareContent and not ModContent then
        ContentText = DyeShareContent
    end
    self:GetAvatar():ChatToSettlementOnline(ContentText)
end

function M:RecvChatToSettlementOnline(ContentText)
    if ChatModel:IsChannelExclude(ChatCommon.ChannelDef.SettlementOnline) then
        return
    end
    ---@type Message
    local FakeMessage = self:CreateFakeMsg(ContentText,CommonConst.MESSAGE_TYPE_SELF, ChatCommon.ChannelDef.SettlementOnline)
    self:_AddMessage(FakeMessage, false)
end

---@param MemberInfo AvatarInfo 队友信息
---@param EventType string 操作类型
function M:SendMemberChangeTipsToTeam(MemberInfo, EventType)
    local TextMessage = nil
    if (EventType == TeamCommon.EventId.TeamOnAddPlayer) then
        TextMessage = string.format(GText("UI_Chat_SbJoin"), MemberInfo.Nickname)
    elseif (EventType == TeamCommon.EventId.TeamOnDelPlayer) then
        TextMessage = string.format(GText("UI_Chat_SbLeave"), MemberInfo.Nickname)
    end
    if (TextMessage ~= nil) then
        self:RecvSystemInfoToTeam(TextMessage) 
    end
end

function M:RecvSystemInfoToTeam(ContentText)
    ---@type Message
    local FakeMessage = self:CreateFakeMsg(ContentText, CommonConst.MESSAGE_TYPE_SYSTEM,ChatCommon.ChannelDef.InTeam)
    self:_AddMessage(FakeMessage, false)
end

function M:SendChangeQuickMessage(Index, ContentText)
    self:GetAvatar():ChangeQuickMessage(Index,ContentText)
end
function M:SendInitQuickMessage(SystemLanguage)
    self:GetAvatar():InitQuickMessage(SystemLanguage)
end
function M:RecvChangeQuickMessage(Index)
    self:NotifyEvent(ChatCommon.EventID.QuickMsgChanged, Index)
end

function M:SendAddEmotion(GroupId)
    self:GetAvatar():AddEmotion(GroupId)
end
function M:RecvAddEmotion(GroupId)
    self:NotifyEvent(ChatCommon.EventID.EmotionAdded, GroupId)
end

function M:SendRemoveEmotion(EmotionId)
    self:GetAvatar():RemoveEmotion(EmotionId)
end
function M:RecvRemoveEmotion(EmotionId)
    self:NotifyEvent(ChatCommon.EventID.EmotionRemoved, EmotionId)
end

function M:SendChatNewMsgRead(CurrFriendUid)
    -- if ChatModel:GetCurrentChannel() ~= ChatCommon.ChannelDef.Friend then
    --     ChatModel:ReadChannelMessage()
    --     return 
    -- end
    if self:GetModel():GetCurrentChannel() ~= ChatCommon.ChannelDef.Friend then
        ChatModel:ClearReddotCount(self.CurrChannel)
    end
    if not CurrFriendUid then
        CurrFriendUid = ChatModel:GetCurrentFriendUid()
        if CurrFriendUid == nil then return end
    end
    self:GetAvatar():ReadChat(CurrFriendUid)
end
function M:RecvChatNewMsgRead(Uid)
    if Uid ~= ChatModel:GetCurrentFriendUid() then return end
    ChatModel:ReadChannelMessage(ChatCommon.ChannelDef.Friend, Uid)
end

function M:TryParseMyModSuitInfo(MsgStr)
    local ModModel = ModController:GetModel()
    if ModModel:IsModSuitInfoMsg(MsgStr) then
        local ModModel = ModController:GetModel()
        local ModContent = ModModel:GenerateModSuitInfoMsg()
        return ModContent
    end
    return nil
end

function M:TryParseMyDyePlanInfo(MsgStr)
    local ModModel = ModController:GetModel()
    if ModModel:IsDyeShareInfoMsg(MsgStr) then
        local ModModel = ModController:GetModel()
        local DyeShareContent = ModModel:GenerateDyeShareMsg()
        return DyeShareContent
    end
    return nil
end

function M:TryParseGiftInfo(MsgStr)
    if MsgStr == ChatCommon.GiftCopyHeader then
        local GiftContent = self:GenerateGiftMessage()
        return GiftContent
    else
        return nil
    end
end
-- function M:SendMyModSuitInfo(ChannelType,Uid)
--     local ModModel = ModController:GetModel()
--     local ModContext = ModModel:GenerateModSuitInfoMsg()
--     if ChannelType == ChatCommon.ChannelDef.Friend then
--         self:GetAvatar():ChatToPlayer(Uid, ModContext)
--     else
--         if ChannelType == ChatCommon.ChannelDef.InTeam then
--             --联机队伍频道使用ds聊天
--             if not GWorld:IsStandAlone() then
--                 local PC = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
--                 if IsValid(PC) then
--                     local SinglePC = PC:Cast(UE4.ASinglePlayerController)
--                     if IsValid(SinglePC) then
--                         SinglePC:ChatAll(ContentText)
--                         return
--                     end
--                 end
--             end 
--             self:GetAvatar():ChatToTeam(Uid, ModContext)
--         else
--             self:GetAvatar():ChatToWorld(ChannelType,ModContext)
--         end
--     end
-- end

---@param Message Message
function M:HandleChatMessage(Message)
    if not self.bInited then return end
    --@note 私聊的情况下，自己发的消息会走这里收到，需要做些区分
    if Message.Type == CommonConst.MESSAGE_TYPE_PRIVATE then
        Message.ChannelType = ChatCommon.ChannelDef.Friend
        if Message.Sender.Uid == GWorld:GetAvatar().Uid then
            Message.Type = CommonConst.MESSAGE_TYPE_SELF
        end
    end
    if ChatModel:IsChannelExclude(Message.ChannelType) then
        return
    end
    self:_AddMessage(Message, true)
end

function M:SendGiftMessage(UID,Index)
    self.GiftInfo = {
        Index = Index or 1,
    }
    self:SendChatToPlayer(UID,ChatCommon.GiftCopyHeader)
end

function M:SendGiftReceivedMessage(UID,Index)
    self.GiftInfo = {
        bGiftReceived = true,
        Index = Index or 1,
    }
    self:SendChatToPlayer(UID,ChatCommon.GiftCopyHeader)
end

function M:GenerateGiftMessage()
    -- self.GiftInfo = {
    --     Index = 1,
    -- }
    if not self.GiftInfo then return nil end
    return ChatCommon.GiftCopyHeader..json.encode(self.GiftInfo)
end
--endregion

function M:_AddMessage(Message, bCalcUnread)
    local TimeWrap, MsgWrap = self:GetModel():AddMessage(Message, bCalcUnread)
    local Channel = Message.ChannelType
    if MsgWrap:IsSticker() and Channel~=ChatCommon.ChannelDef.Friend then
        local Uid = Message.Sender.Uid
        local GroupId = MsgWrap.EmojiInfos[1].GroupId
        local Id = MsgWrap.EmojiInfos[1].Id
        local StickerTexPath = DataMgr.ChatEmoji[GroupId][Id]
        self:NotifyEvent(ChatCommon.EventID.RecvStickerInPubChannels, Uid, StickerTexPath)
    end
    if Channel ~= ChatModel:GetCurrentChannel() then return end
    --@note 区分自己发的消息
    if Message.Type == CommonConst.MESSAGE_TYPE_SELF then
        self:NotifyEvent(ChatCommon.EventID.ChatMsgSent, TimeWrap, MsgWrap)
    else
        self:NotifyEvent(ChatCommon.EventID.ChatMsgRecv, TimeWrap, MsgWrap)
    end
end

--region 其他
function M:CreateFakeMsg(ContentText, MsgType, Channel)
    return {
        Content = ContentText,
        Time = TimeUtils.NowTime(),
        Sender = self:GetAvatar(),
        Type = MsgType,
        ChannelType = Channel,
    }
end

function M:SelectPlayerToChat(Uid)
    self:GetModel():SetCurrentFriendUid(Uid)
    self:NotifyEvent(ChatCommon.EventID.SelectPlayerToChat, Uid)
end

---@param WorldContext UObject
---@param AvatarInfo AvatarInfo
---@param FuncList table
function M:OpenPlayerBtnList(WorldContext, AvatarInfo, FuncList)
    ---@type WBP_Chat_HeadBtnList_C
    if table.isempty(FuncList) then return nil end
    local HeadOptionWidget = UIManager(WorldContext):_CreateWidgetNew(DataMgr.WidgetUI.ChatHeadOption.UIName)
    HeadOptionWidget:Init(AvatarInfo,FuncList)
    HeadOptionWidget.Owner = WorldContext
    return HeadOptionWidget
end

function M:OnMainClose(bBattle)
    ChatModel:SetCurrentFriendUid(nil)
    --ChatModel:ReadNewTip()
    self:NotifyEvent(ChatCommon.EventID.CloseMainView, bBattle)
end

function M:OnMainOpen(bBattle)
    self:NotifyEvent(ChatCommon.EventID.OpenMainView,bBattle)
end

function M:CheckTextValid(Text, Callback, ShowTipFunc, TextMap,bAllowEmpty)
    ---魔之楔套装分享消息不走敏感词检测
    if ModController:GetModel():IsModSuitInfoMsg(Text) then
        Callback(true, Text)
        return
    end
    --染色方案分享消息不走敏感词检测
    if ModController:GetModel():IsDyeShareInfoMsg(Text) then
        Callback(true, Text)
        return
    end
    local EmptyHint = GText("UI_Chat_NotEmptyText")
    local BannedHint = GText("UI_REGISTER_BANNEDINPUT")
    if TextMap then
        EmptyHint = TextMap.EmptyHint or EmptyHint
        BannedHint = TextMap.BannedHint or BannedHint
    end
    local OldText = Text
    local Trimmed = MiscUtils.Trim(Text)
    if Trimmed == "" then
        if bAllowEmpty then
            Text = OldText
        else
            ShowTipFunc(true,EmptyHint)
            return
        end
    else
        Text = Trimmed
    end
    if string.match(Text, "<(.-)>(.-)</>") then
        ShowTipFunc(false,BannedHint)
        Callback(false)
        return
    end
    ---@note 禁止手动输入表情包，Emoji除外
    for GroupId, Id in string.gmatch(Text, "%[(%d+)|([%w]+)%]") do
        GroupId = tonumber(GroupId) or nil
        if GroupId and not DataMgr.EmojiGroup[GroupId] then goto continue end
        if GroupId ~= ChatCommon.EmojiGroupId then
            ShowTipFunc(false,BannedHint)
            Callback(false)
            return 
        end
        ::continue::
    end
    if ChatCommon.IgnoreSensitiveCheck then
        Callback(true, Text)
        return
    end
    HeroUSDKUtils.CheckStringSensitive(GWorld.GameInstance,Text,
    function(self, ReplaceName, NewText, Words)
        ShowTipFunc(false,BannedHint)
        Callback(false)
    end,
    function(self, NewText)
        Callback(true, Text)
    end)
end

-- function M:GetSticker(Message)
--     local GroupId, Id = string.match(Message.Content, "^%[(%d+)|([%w]+)%]$")
--     GroupId = tonumber(GroupId)
--     if GroupId and DataMgr.EmojiGroup[GroupId] and DataMgr.ChatEmoji[GroupId][Id] and GroupId~=0 then
--         return GroupId, Id
--     end
--     return nil, nil
-- end

function M:OpenForbidChatDialog(Time, Reason,TimeDelta)
 
    local View = self:GetView()
    if not IsValid(View) then return end

    if Time == nil then Time = self:GetAvatar().ForbidChatTime end
    if Reason == nil then Reason = self:GetAvatar().ForbidChatReason end

    local timeDifference = TimeDelta and TimeDelta or Time - TimeUtils.NowTime()

    local days = math.floor(timeDifference / (60 * 60 * 24))  
    local hours = math.floor((timeDifference % (60 * 60 * 24)) / (60 * 60))
    local minutes = math.floor((timeDifference % (60 * 60)) / 60)
    local Params =
    {
        ShortText = string.format(GText("UI_COMMONPOP_TEXT_100111"),days, hours, minutes)
    }
    self:GetUIMgr(View):ShowCommonPopupUI(ChatCommon.ForbidChatDialog, Params,View)
end

--打开chatreport举报界面
function M:OpenChatReportDialog(Params)
    -- DebugPrint("OpenChatReportDialog")
    local View = self:GetView()
    -- if not IsValid(View) then return end
    self:GetUIMgr(View):ShowCommonPopupUI(ChatCommon.AccuseDialog, Params,View)
end

--endregion

--region 定时器
function M:SetUpSendCDTimer(ChannelType)
    local CdTimer = self:GetModel():GetChannelCDTimerKey(ChannelType)
    self:StopTimer(CdTimer)
    local RawCDRemainTime = DataMgr.Channel[ChannelType].MessageCD
    ---@note 由于聊天的rpc调用需要有间隔，所以一定会有cd
    if RawCDRemainTime == 0 then RawCDRemainTime = ChatCommon.DefaultCD end
    ChatModel:SetChannelCDRemainTime(RawCDRemainTime, ChannelType)
    local Interval = RawCDRemainTime < 1 and RawCDRemainTime or 1
    self:AddTimer(Interval, function()
        local CDRemianTime = ChatModel:GetChannelCDReaminTime(ChannelType) - Interval
        ChatModel:SetChannelCDRemainTime(CDRemianTime,ChannelType)
        if ChannelType == ChatModel:GetCurrentChannel() then 
            self:NotifyEvent(ChatCommon.EventID.SendCDTimerUpdate,CDRemianTime)
        end
        if CDRemianTime <= 0 then
            self:StopTimer(CdTimer)
        end
    end, true, 0, CdTimer)
    if ChannelType == ChatModel:GetCurrentChannel() then 
        self:NotifyEvent(ChatCommon.EventID.SendCDTimerUpdate, RawCDRemainTime)
    end
end

function M:IsSendCDTimerExist(ChannelType)
    local CdTimer = self:GetModel():GetChannelCDTimerKey(ChannelType)
    DebugPrint("ChatController :: IsSendCdTimerExist CdTimer = "..CdTimer)
    return self:IsExistTimer(CdTimer)
end
--endregion


function M:ParseEmojiToText(MsgWrap)
    local Content = MsgWrap.Message.Content
    if #MsgWrap.EmojiInfos>0 then
        if MsgWrap:IsSticker() then
            local GroupId = MsgWrap.EmojiInfos[1].GroupId
            local Id = MsgWrap.EmojiInfos[1].Id
            local Error = "Error!!!"
            local EmojiGroupName = DataMgr.EmojiGroup[GroupId].Name or Error
            local EmojiName = DataMgr.ChatEmoji[GroupId][Id].Name or Error
            Content = string.format("[%s|%s]",GText(EmojiGroupName), GText(EmojiName))
        else
            --处理Emoji表情的缩略显示
            local originalContent = Content
            for _, emojiInfo in ipairs(MsgWrap.EmojiInfos) do
                local GroupId = emojiInfo.GroupId
                local Id = emojiInfo.Id
                local EmojiName = DataMgr.ChatEmoji[GroupId][Id].Name or "Error!!!"
                local EmojiPattern = string.format("%%[%s|%s%%]",GroupId, GText(EmojiName))
                local EmojiReplacement = string.format("[%s]", GText(EmojiName))
                originalContent = originalContent:gsub(EmojiPattern, EmojiReplacement,1)
            end
            Content = originalContent
        end
    end 
    return Content
end

function M:ParseSpeakerHeader(MsgWrap)
    local Message = MsgWrap.Message
    local YouTo = ""
    local RichTextTag = ChatCommon.RichTextTag.Self
    local FriendName = GText("UI_Chat_You")
    if Message.ChannelType == ChatCommon.ChannelDef.Friend then
        YouTo = MsgWrap.MsgType == ChatCommon.MsgType.Self and GText("UI_Chat_YouTo") or ""
        RichTextTag = ChatCommon.RichTextTag.Friend
        local Uid = Message.Sender.Uid
        if MsgWrap.MsgType == ChatCommon.MsgType.Self then
            Uid = Message.ReceiverUid
        end
        FriendName = FriendController:GetModel():GetFriendDict()[Uid].Info.Nickname
    elseif MsgWrap.MsgType ~= ChatCommon.MsgType.Self then
        local Friend = FriendController:GetModel():GetFriendDict()[Message.Sender.Uid]
        RichTextTag = Friend and ChatCommon.RichTextTag.Friend or ChatCommon.RichTextTag.Stranger
        FriendName = Friend and Friend.Info.Nickname or Message.Sender.Nickname
    end
    local Spacker = string.format("%s<%s>%s</>%s", YouTo,RichTextTag, FriendName, ChatCommon.Spliter)
    local RawSpacker = table.concat({YouTo, FriendName,ChatCommon.Spliter})
    return Spacker, RawSpacker
end

function M:GetRawContent(MsgWrap)
    local Spacker, RawSpacker = self:ParseSpeakerHeader(MsgWrap)
    local Content = self:ParseEmojiToText(MsgWrap)
    return RawSpacker..Content
end

function M:ParseModSuitText(MsgWrap)
    local Content = MsgWrap.Message.Content
    if not MsgWrap.ModSuitInfo then return nil end
    local TargetType = MsgWrap.ModSuitInfo.TargetInfo[1]
    local TargetId = MsgWrap.ModSuitInfo.TargetInfo[2]
    local Name = "角色或武器被删除了!!!!"
    local Conf = DataMgr[TargetType][TargetId]
    if TargetType == "Char" then
        if Conf.GenderTag ~= nil then
            Name = MsgWrap.Message.Sender.Nickname
        else
            Name = Conf.CharName
        end
    else
        Name = Conf.WeaponName
    end
    if Name == MsgWrap.Message.Sender.Nickname then
        return string.format(GText("UI_Chat_ModSuitFormat"), Name)
    end
    return string.format(GText("UI_Chat_ModSuitFormat"), GText(Name))
end

function M:ParseDyePlanText(MsgWrap)
    local Content = MsgWrap.Message.Content
    if not MsgWrap.DyePlanInfo then return nil end
    if not MsgWrap.DyePlanInfo.TargetName then return nil end
    local Name = MsgWrap.DyePlanInfo.TargetName
    return string.format(GText("UI_Chat_DyeSuitFormat"), GText(Name))
end

function M:ClearChannelReddot(ChannelType)
    if ChannelType ~= ChatCommon.ChannelDef.Friend then
        self:GetModel():ClearReddotCount(ChannelType)
    else
        for _, Friend in pairs(FriendController:GetModel():GetFriendDict()) do
            self:GetModel():ClearReddotCount(ChannelType, Friend.Uid)
            self:SendChatNewMsgRead(Friend.Uid)
        end
    end
end

_G.ChatController = M
return M

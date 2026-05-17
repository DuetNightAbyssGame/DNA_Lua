local FriendController = require "BluePrints.UI.WBP.Friend.FriendController"
local FriendModel = FriendController:GetModel()
local ChatController = require "BluePrints.UI.WBP.Chat.ChatController"
local PersonInfoController = require "BluePrints.UI.WBP.PersonInfo.PersonInfoController"
---@type WBP_Chat_ChatItem_C|WBP_Chat_PlayerlistItem_C
local Component = {}

---@param Anchor UMenuAnchor
---@param Head WBP_Com_ItemHead_C
function Component:SetupAnchor(Anchor, Head, AvatarInfo,bSetUpEvent,MessageContent)
    ---@type UMenuAnchor
    self.HeadAnchor = Anchor
    self.Head = Head
    self._AvatarInfo = AvatarInfo
    self._bSetUpEvent = bSetUpEvent
    self._MessageContent = MessageContent
    if bSetUpEvent then
        self.HeadAnchor.OnGetMenuContentEvent:Bind(self, self.OnAnchorGetUserMenuContent)
        self.HeadAnchor.OnMenuOpenChanged:Add(self, self.HeadMenuOpenChanged)
    end
end

function Component:CleanUpAnchor()
    if self._bSetUpEvent then
        self.HeadAnchor.OnGetMenuContentEvent:Unbind()
        self.HeadAnchor.OnMenuOpenChanged:Remove(self, self.HeadMenuOpenChanged)
    end
    self.HeadAnchor = nil
    self.Head = nil
    self._bSetUpEvent = false
end

--region 菜单锚
function Component:OnAnchorGetUserMenuContent(Anchor)
    local InitShowRecordBtn = function(Content, AvatarInfo) --查看档案
        Content.Text = GText("UI_Chat_ShowRecord")
        Content.Callback = function()
            --等收到了信息回调再打开页面
            if AvatarInfo.Uid == GWorld:GetAvatar().Uid then
               -- GWorld:GetAvatar():CheckOtherPlayerPersonallInfo(AvatarInfo.Uid)
                PersonInfoController:OpenView( )
            else
                GWorld:GetAvatar():CheckOtherPlayerPersonallInfo(AvatarInfo.Uid)
            end
            --PersonInfoController:OpenView()
            self.HeadAnchor:Close()
        end
    end
    local AddFriend =  function(Content, AvatarInfo) --添加好友 or 发送消息
        if not FriendModel:GetFriendDict()[AvatarInfo.Uid] then
            Content.Text = GText("UI_Friend_AddFriend")
            Content.Callback = function()
                FriendController:OpenAddFriendDialog(self,AvatarInfo)
                self.HeadAnchor:Close()
            end
        else
            Content.Text = GText("UI_Chat_SendMsg")
            Content.Callback = function()
                ChatController:SelectPlayerToChat(AvatarInfo.Uid)
                self.HeadAnchor:Close()
            end
        end
    end
    local InviteTeam = function(Content, AvatarInfo) --邀请组队
        Content.Text = GText("UI_Chat_InviteTeam")
        Content.Callback = function()
            TeamController:SendTeamInvite(AvatarInfo.Uid)
            self.HeadAnchor:Close()
        end
    end
    -- local JoinLeague = function(Content, AvatarInfo) --邀请加入公会
    --     Content.Text = GText("UI_Chat_InviteLeague")
    --     Content.Callback = function()
    --         --@todo 邀请加入公会
    --         ChatController:ShowToast()
    --         self.HeadAnchor:Close()
    --     end
    -- end
    local AddBlackList = function(Content, AvatarInfo) --添加到黑名单
        if FriendModel:GetBlackListDict()[AvatarInfo.Uid] then
            Content.Text = GText("UI_Friend_DelBlackList")
            Content.Callback = function()
                FriendController:SendCancelBlackList(AvatarInfo.Uid)
                self.HeadAnchor:Close()
            end
        else
            Content.Text = GText("UI_Friend_AddBlackList")
            Content.Callback = function()
                FriendController:OpenAddBlacklistDialog(self,AvatarInfo)
                self.HeadAnchor:Close()
            end
        end
    end
    local Switch = {}
    local Avatar = ChatController:GetAvatar()
    local IsYourSelf = self._AvatarInfo.Uid == Avatar.Uid
    local InBounsScene = GWorld.GameInstance.IsInTempScene and GWorld.GameInstance:IsInTempScene() 
    local IsInDungeon = GWorld:GetAvatar():IsInDungeon() 
    local IsInHardBoss = GWorld:GetAvatar():IsInHardBoss()
    local bNotInvitable = TeamController:GetModel():GetInviteSendBox()[self._AvatarInfo.Uid] or Avatar:IsInMultiDungeon()
    local TeamData = TeamController:GetModel():GetTeam()
    bNotInvitable = bNotInvitable or (TeamData and #TeamData.Members)==4
    local Channel = ChatController:GetModel():GetCurrentChannel()
    local InviteTeamIdx = nil

    local AccusePlayer = function(Content, AvatarInfo) --举报用户
        Content.Text = GText("UI_Chat_Accuse")
        Content.Callback = function()
            -- 举报用户
            -- ChatController:ShowToast()
            -- DebugPrint(self._MessageContent)
            --打开report界面  -- DebugPrintTable(AvatarInfo)
            local Params = {
                Nickname = AvatarInfo.Nickname,
                UID = AvatarInfo.Uid,
                Level = AvatarInfo.Level,
                TextLenMax = 50,
                ChatMessage = self._MessageContent,
                ForbidRightBtn = true,
                DontCloseWhenRightBtnClicked = true,
            }
            Params.HideItemTips = function()
                self:BroadcastDialogEvent(DialogEvent.HideDialogItem,{bHideDialogItem = true, DialogItemIndex = 1, bShouldPlayAnim = false})
                self:BroadcastDialogEvent(DialogEvent.HideDialogItem,{bHideDialogItem = true, DialogItemIndex = 2, bShouldPlayAnim = false})
            end
            Params.EditTextConfig = {
                Owner = self,
                TextLimit = 50,
                Events = {
                    OnTextChanged = self.OnTextChange,
                    OnTextComposing = self.OnTextComposing,
                    -- OnCheckTextLegality = self.OnCheckTextLegality,
                    OnEditTextFocusReceived = function()
                        if self.bTipsShowed then
                            self.Owner:HideDialogTip(2, false)
                            self.bTipsShowed = false
                        end
                    end,
                }
            }
            Params.AllowNegativeAttitude = IsInDungeon or IsInHardBoss
            ChatController:OpenChatReportDialog(Params)
            
            self.HeadAnchor:Close()
        end
    end

    if IsInHardBoss then
        if InBounsScene then
            InviteTeamIdx = 2
            Switch = IsYourSelf and {} or {AddFriend, InviteTeam, AddBlackList}
        else
            InviteTeamIdx = 3
            Switch = IsYourSelf and {InitShowRecordBtn,} or  {AddFriend, InitShowRecordBtn, InviteTeam, AddBlackList}
        end
    elseif InBounsScene or IsInDungeon then
        InviteTeamIdx = 2
        Switch = IsYourSelf and {} or {AddFriend, InviteTeam, AddBlackList, AccusePlayer}
    else
        InviteTeamIdx = 3
        Switch = IsYourSelf and {InitShowRecordBtn,} or  {AddFriend, InitShowRecordBtn, InviteTeam, AddBlackList}
    end

    if not IsYourSelf and (not table.isempty(Switch)) then
        if self._MessageContent and (not IsInDungeon) and (not InBounsScene) then
            table.insert(Switch, AccusePlayer)
        end
        if bNotInvitable then
            table.remove(Switch, InviteTeamIdx)
        end
        if Channel == ChatCommon.ChannelDef.InTeam or Channel == ChatCommon.ChannelDef.Friend then
            if FriendModel:GetFriendDict()[self._AvatarInfo.Uid] then
                table.remove(Switch, 1)
            end
        end
    end
    -- [Temporary for Testing] Allow reporting self
    if IsYourSelf and self._MessageContent then
        table.insert(Switch, AccusePlayer)
    end
    return ChatController:OpenPlayerBtnList(self, self._AvatarInfo, Switch)
end


function Component:HeadMenuOpenChanged(bOpen)
    if self.OnHeadMenuOpenChanged then 
        self:OnHeadMenuOpenChanged(bOpen)
    end
    if bOpen then return end
    if self.Head then
        self.Head:PlayNormal()
    end
end
--endregion

return Component

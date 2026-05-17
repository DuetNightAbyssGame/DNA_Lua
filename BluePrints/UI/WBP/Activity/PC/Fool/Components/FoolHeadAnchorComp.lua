local FriendController = require "BluePrints.UI.WBP.Friend.FriendController"
local FriendModel = FriendController:GetModel()
local ChatController = require "BluePrints.UI.WBP.Chat.ChatController"
local PersonInfoController = require "BluePrints.UI.WBP.PersonInfo.PersonInfoController"
---@type WBP_Chat_ChatItem_C|WBP_Chat_PlayerlistItem_C
local Component = {}

---@param Anchor UMenuAnchor
---@param Head WBP_Com_ItemHead_C
function Component:SetupAnchor(Anchor, Head, AvatarInfo)
    ---@type UMenuAnchor
    self.HeadAnchor = Anchor
    self.HeadAnchor:Close()
    self.Head = Head
    self.bAnchorOpen = false
    self.Head:BindOnClickEvent(function()
        self.HeadAnchor:Open(true)
    end)
    self._AvatarInfo = AvatarInfo
    self.HeadAnchor.OnGetMenuContentEvent:Bind(self, self.OnAnchorGetUserMenuContent)
    self.HeadAnchor.OnMenuOpenChanged:Add(self, self.HeadMenuOpenChanged)
end

function Component:CleanUpAnchor()
    if self.HeadAnchor then
        self.HeadAnchor.OnGetMenuContentEvent:Unbind()
        self.HeadAnchor.OnMenuOpenChanged:Remove(self, self.HeadMenuOpenChanged)
        self.HeadAnchor:Close()
        self.HeadAnchor = nil
    end
    self.Head = nil
    self.bAnchorOpen = false
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
        Content.Text = GText("UI_Friend_AddFriend")
        Content.Callback = function()
            FriendController:OpenAddFriendDialog(self,AvatarInfo)
            self.HeadAnchor:Close()
        end
    end
    local Switch = {}
    local Avatar = ChatController:GetAvatar()
    local IsYourSelf = self._AvatarInfo.Uid == Avatar.Uid
    local InBounsScene = GWorld.GameInstance.IsInTempScene and GWorld.GameInstance:IsInTempScene() 
    local IsInDungeon = GWorld:GetAvatar():IsInDungeon() 
    local IsInHardBoss = GWorld:GetAvatar():IsInHardBoss()

    local AccusePlayer = function(Content, AvatarInfo) --举报用户
        Content.Text = GText("UI_Chat_Accuse")
        Content.Callback = function()
            -- 举报用户
            -- ChatController:ShowToast()
            --打开report界面  -- DebugPrintTable(AvatarInfo)
            local Params = {
                Nickname = AvatarInfo.Nickname,
                UID = AvatarInfo.Uid,
                Url = AvatarInfo.Url,
                Level = AvatarInfo.Level,
                PictureUniqueId = AvatarInfo.PictureUniqueId,
                TextLenMax = 50,
                ForbidRightBtn = true,
                DontCloseWhenRightBtnClicked = true,
                isPhotoReport = true,
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
                }
            }
            Params.AllowNegativeAttitude = IsInDungeon or IsInHardBoss
            ChatController:OpenChatReportDialog(Params)
            
            self.HeadAnchor:Close()
        end
    end

    if IsInHardBoss then
        if InBounsScene then
            Switch = IsYourSelf and {} or {AddFriend}
        else
            Switch = IsYourSelf and {InitShowRecordBtn} or  {AddFriend, InitShowRecordBtn}
        end
    elseif InBounsScene or IsInDungeon then
        Switch = IsYourSelf and {} or {AddFriend}
    else
        Switch = IsYourSelf and {InitShowRecordBtn,} or  {AddFriend, InitShowRecordBtn}
    end

    if not IsYourSelf and (not table.isempty(Switch)) then
        table.insert(Switch, AccusePlayer)
    end
    if not IsYourSelf and FriendModel:GetFriendDict()[self._AvatarInfo.Uid] then
        table.remove(Switch, 1)
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

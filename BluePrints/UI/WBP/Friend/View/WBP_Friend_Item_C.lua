--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local FriendCommon = require "BluePrints.UI.WBP.Friend.FriendCommon"
local FriendController = require "BluePrints.UI.WBP.Friend.FriendController"
local FriendModel = FriendController:GetModel()
local TimeUtils = require "Utils.TimeUtils"
local ChatController = require "BluePrints.UI.WBP.Chat.ChatController"
local TeamController = require "BluePrints.UI.WBP.Team.TeamController"
local TeamModel = TeamController:GetModel()
local UIUtils = require "Utils.UIUtils"
local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"

---@type WBP_Friend_Item_C|BP_UIState_C
local M = Class( "BluePrints.UI.BP_UIState_C")

function M:OnTeamMainFocusChanged(bFocused, bAddFocusRecv)
    if not bAddFocusRecv and not bFocused then return end
    local Visibility = bFocused and "Collapsed" or "SelfHitTestInvisible"
    local KeyWidgets = {
        self.Function_GamePad,
        self.Button_Funtion.Key_GamePad,
        self.Button_Talk.Key_GamePad,
        self.No_GamePad,
        self.Yes_GamePad,
    }
    for _, KeyWidget in ipairs(KeyWidgets) do
        KeyWidget:SetVisibility(UIConst.VisibilityOp[Visibility])
    end
end

function M:OnAnimationStarted(InAnim)
    if InAnim == self.In then
        self:SetVisibility(UIConst.VisibilityOp.Visible)
    end
end

function M:OnAddedToFocusPath(InFocusEvent) 
    if FriendController:IsGamepad() then
        self:OnTeamMainFocusChanged(false, true)
        self:OnItemSelectionChanged(true)
        local GameInstance = GWorld.GameInstance
        local UIManager = GameInstance:GetGameUIManager()
        local FriendMain = UIManager:GetUIObj("FriendMain")
        local FriendWindow = UIManager:GetUIObj("List_Friend")
        if FriendMain then
            FriendMain:ShowPlayerInfoBtn(true)
            FriendMain:ShowCheckBtn(false)
        end
        if FriendWindow then
            FriendWindow:ShowPlayerInfoBtn(true)
        end
    end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    if FriendController:IsGamepad() then
        self:OnItemSelectionChanged(false)
        local GameInstance = GWorld.GameInstance
        local UIManager = GameInstance:GetGameUIManager()
        local FriendMain = UIManager:GetUIObj("FriendMain")
        local FriendWindow = UIManager:GetUIObj("List_Friend")
        if FriendMain then
            FriendMain:ShowPlayerInfoBtn(false)
        end
        if FriendWindow then
            FriendWindow:ShowPlayerInfoBtn(false)
        end
    end
end

function M:Construct()
    M.Super.Construct(self)
    self.Button_Invite:BindEventOnReleased(self, self.OnBtnInviteReleased)
    FriendController:OverrideButtonSound(self.Button_Funtion, "event:/ui/common/click_btn_small", nil)
    self.Button_Funtion:BindEventOnReleased(self, self.OnBtnFunctionReleased)
    FriendController:OverrideButtonSound(self.Button_Yes, "event:/ui/common/click_btn_confirm", nil)
    self.Button_Yes:BindEventOnReleased(self, self.OnBtnYesOrNoRelease, true)
    FriendController:OverrideButtonSound(self.Button_No, "event:/ui/common/click_btn_cancel", nil)
    self.Button_No:BindEventOnReleased(self, self.OnBtnYesOrNoRelease, false)
    self.Head_Friend:BindOnClickEvent(function()
        self.Head_Anchor:Open(true)
    end)
    -- 礼物按钮点击改用通用接口，禁用态点击走 Forbid 逻辑
    self.Button_Gift:BindEventOnClicked(self, self.OnBtnGiftClick)
    self.Button_Gift:BindForbidStateExecuteEvent(self, self.OnGiftForbidClick)
    self.Head_Anchor.OnGetUserMenuContentEvent:Bind(self, self.OnAnchorGetUserMenuContent)
    self.Head_Anchor.OnMenuOpenChanged:Add(self, self.HeadMenuOpenChanged)
    self.Button_Invite:SetGamePadImg("A")
    self.Button_Talk:SetGamePadImg("X")
    self.Key_No:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "X",
            }
        },
    })
    self.Key_Yes:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "A",
            }
        },
    })
    self:SetGamepadIconVisibility(false)
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end

    self.Button_Gift:OverriddenSoundFunc()
    -- 设置左右方向为自定义导航边界，并选择对应处理函数
    self:SetNavigationRuleCustomBoundary(UE4.EUINavigation.Right, {self, self.OnNavagationRight})
    self:SetNavigationRuleCustomBoundary(UE4.EUINavigation.Left, {self, self.OnNavagationLeft})
end

function M:HeadMenuOpenChanged(bOpen)
    self.bMenuOpen = bOpen
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local FriendMain = UIManager:GetUIObj("FriendMain")
    local FriendWindow = UIManager:GetUIObj("List_Friend")
    if FriendMain and not ModController:IsMobile() then
        if bOpen then
            FriendMain:ShowCheckBtn(true)
            FriendMain:ShowPlayerInfoBtn(false)
            if FriendWindow then
                FriendWindow:ShowCheckBtn(true)
                FriendWindow:ShowPlayerInfoBtn(false)
            end
        else
            FriendMain:ShowCheckBtn(false)
            FriendMain:ShowPlayerInfoBtn(true)
            if FriendWindow then
                FriendWindow:ShowCheckBtn(false)
                FriendWindow:ShowPlayerInfoBtn(true)
            end
        end
    end
    if bOpen then return end
    self.Head_Friend:PlayNormal()
end

function M:ResetUI()
    self.HB_Loca:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.HB_Button_Request:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.HB_Button:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Button_Funtion:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Button_Funtion:ForbidBtn(false)
    self.Button_Invite:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Button_Invite:ForbidBtn(false)
    self.Text_Remark:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Split:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Split_1:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Head_Friend:SetHoldUp(false)
    self.HB_Gift:SetVisibility(UIConst.VisibilityOp.Collapsed)
    -- 重置称号控件状态
    if self.Title then
        self.Title:ClearChildren()
        self.Title:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:OnAnchorGetUserMenuContent()
    local FriendMainView = FriendController:GetView(self)
    local InviteTeam = function(Content, AvatarInfo) --邀请组队
        Content.Text = GText("UI_Chat_InviteTeam")
        Content.Callback = function()
            TeamController:SendTeamInvite(AvatarInfo.Uid)
            self.Head_Anchor:Close()
        end
    end
    local InitShowRecordBtn = function(Content, AvatarInfo) --查看档案  
        Content.Text = GText("UI_Chat_ShowRecord")
        Content.Callback = function()
            if TeamModel:IsYourself(AvatarInfo.Uid) then
                PersonInfoController:OpenView()
            else
                TeamController:GetAvatar():CheckOtherPlayerPersonallInfo(AvatarInfo.Uid)
            end
            self.Head_Anchor:Close()
            if FriendController:GetDialog(self) then
                FriendController:GetDialog(self):OnCloseBtnClicked()
        end
    end
    end
    local AddBlackList = function(Content, AvatarInfo) --添加到黑名单
        if FriendModel:GetBlackListDict()[AvatarInfo.Uid] then
            Content.Text = GText("UI_Friend_DelBlackList")
            Content.Callback = function()
                FriendController:SendCancelBlackList(AvatarInfo.Uid)
                self.Head_Anchor:Close()
            end
        else
            Content.Text = GText("UI_Friend_AddBlackList")
            Content.Callback = function()
                self.Head_Anchor:Close()
                local Dialog = FriendController:GetDialog(self)
                if Dialog then
                    Dialog:OnCloseBtnClicked()
                    FriendController:AddTimer(Dialog.Out:GetEndTime()+0.05, function()
                FriendController:OpenAddBlacklistDialog(self,AvatarInfo)
                    end)
                else
                    FriendController:OpenAddBlacklistDialog(self,AvatarInfo)
            end
        end
    end
    end
    local RemarkFriend = function(Content, AvatarInfo)
        Content.Text = GText("UI_Friend_Remark")
        Content.Callback = function()
            ---@type DialogInputParams
            local Params = {
                UseGenaral = true,
                MultilineType = 1,
                TextLenMax = DataMgr.GlobalConstant.NicknameMaxLen.ConstantValue,
                HintText = GText("UI_Friend_RemarkInputHint"),
                OnSDKChecked = function(bRes, InputWidget, ...)
                    if not bRes then return end
                    FriendController:SendRequest(FriendCommon.EventId.SetRemark,AvatarInfo.Uid, ...)
                end,
            }
            UIManager(self):ShowCommonPopupUI(FriendCommon.RemarkDialogNotInput, Params, FriendMainView)
            self.Head_Anchor:Close()
        end
    end
    local StarFriend = function(Content, AvatarInfo)
        if not self.FriendData.Star then
            Content.Text = GText("UI_Friend_AddStar")
        else 
            Content.Text = GText("UI_Friend_RemoveStar")
        end
        Content.Callback = function()
            FriendController:SendRequest(FriendCommon.EventId.SetStar,AvatarInfo.Uid, not self.FriendData.Star)
            self.Head_Anchor:Close()
        end
    end
    local RemoveFriend = function(Content, AvatarInfo)
        Content.Text = GText("UI_Friend_Remove")
        Content.Callback = function()
            local Params = {
                RightCallbackFunction = function()
                    FriendController:SendRequest(FriendCommon.EventId.DeleteFriend,AvatarInfo.Uid)
                end
            }
            UIManager(self):ShowCommonPopupUI(FriendCommon.DeleteDialog, Params, FriendMainView)
            self.Head_Anchor:Close()
        end
    end
    local AccusePlayer = function(Content, AvatarInfo) --举报用户
        Content.Text = GText("UI_Chat_Accuse")
        Content.Callback = function()
            local Params = {
                PlayerName = AvatarInfo.Nickname,
                UID = AvatarInfo.Uid,
                TextLenMax = 50,
                -- ChatMessage = {Text = "最近匹配"},
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
                    OnEditTextFocusReceived = function()
                        if self.bTipsShowed then
                            self.Owner:HideDialogTip(2, false)
                            self.bTipsShowed = false
                        end
                    end,
                }
            }
            Params.AllowNegativeAttitude = true
            ChatController:OpenChatReportDialog(Params)
            
            self.Head_Anchor:Close()
        end
    end
    local Switch = {}
    if self.Type == FriendCommon.FriendDialogType.BlackList then
        Switch = {AddBlackList}
    elseif self.Type == FriendCommon.FriendTabType.MyFriend then
        Switch = {InitShowRecordBtn, RemarkFriend, StarFriend, AddBlackList, RemoveFriend}
    else
        if self.Type == FriendCommon.FriendTabType.RecentMatch then
            Switch = {InviteTeam,InitShowRecordBtn, AddBlackList, AccusePlayer}
        else
            Switch = {InviteTeam,InitShowRecordBtn, AddBlackList}
        end
    end
    return ChatController:OpenPlayerBtnList(self, self.PersonData , Switch)
end

function M:OnBtnYesOrNoRelease(bYes)
    if bYes then
        FriendController:SendRequest(FriendCommon.EventId.AgreeAdd, self.RequestData.Uid)
    else 
        FriendController:SendRequest(FriendCommon.EventId.RefuseAdd, self.RequestData.Uid)
    end
end

function M:OnBtnFunctionReleased()
    local Switch = {
        [FriendCommon.FriendTabType.MyFriend] = self.OnBtnFunctionReleased_MyFriend,
        [FriendCommon.FriendTabType.AddFriend] = self.OnBtnFunctionReleased_AddFriend,
        [FriendCommon.FriendTabType.RecentMatch] = self.OnBtnFunctionReleased_AddFriend,
        [FriendCommon.FriendTabType.RegionFriend] = self.OnBtnFunctionReleased_AddFriend,
    }
    Switch[self.Type](self)
end

function M:OnBtnFunctionReleased_MyFriend()
    ChatController:OpenView(self)
    ChatController:SelectPlayerToChat(self.FriendData.Uid)
end

function M:OnBtnFunctionReleased_AddFriend()
    if self.Button_Funtion.IsForbidden then 
        FriendController:ShowToast(GText("UI_Toast_Friend_AlreadyRequest"))
        return 
    end
    local FriendMainView = FriendController:GetView(self)
    if not IsValid(FriendMainView) then return end
    FriendController:OpenAddFriendDialog(self, self.PersonData)
end

function M:OnBtnInviteReleased()
    local Switch = {
        [FriendCommon.FriendTabType.MyFriend] = self.OnBtnInviteReleased_MyFriend,
        [FriendCommon.FriendTabType.RecentMatch] = self.OnBtnInviteReleased_RecentMatch,
        [FriendCommon.FriendDialogType.BlackList] = self.OnBtnInviteReleased_BlackList,
    }
    Switch[self.Type](self)
end

function M:OnBtnInviteReleased_RecentMatch()
    self:_InviteCommon(self.PersonData)
end

function M:OnBtnInviteReleased_MyFriend()
    self:_InviteCommon(self.FriendData.Info)
    --进入选择按钮导航模式
end

function M:_InviteCommon(AvatarInfo)
    if self.Button_Invite.IsForbidden then 
        if TeamModel:GetInviteSendBox()[AvatarInfo.Uid] then
            TeamController:ShowToast(GText("UI_Team_InviteSend")) 
            return
        end
        if TeamModel:IsMemberExist(AvatarInfo.Uid) then
            TeamController:ShowToast(GText("UI_Team_FriendInTeam"))
            return
        end
        if not AvatarInfo.IsOnline then
            TeamController:ShowToast(string.format(GText("UI_Team_PlayerOffline"),AvatarInfo.Nickname))
            return
        end
        if AvatarInfo.IsInDungeon then
            TeamController:ShowToast(GText("UI_Team_PlayerInDungeon"))
            return
        end
        if AvatarInfo.IsInSpecialQuest then
            TeamController:ShowToast(GText("UI_Team_PlayerInSpecaiDungeon"))
            return
        end
        return
    end
    TeamController:SendTeamInvite(AvatarInfo.Uid)
end

function M:OnBtnInviteReleased_BlackList()
    if self.Button_Invite.IsForbidden then return end
    FriendController:SendRequest(FriendCommon.EventId.CancelBlackList,self.PersonData.Uid)
end

function M:OnListItemObjectSet(Content)
    self:ResetUI()
    Content.UI = self
    self.Type = Content.Type
    self:SetRenderOpacity(1)
    local Switch = {
        [FriendCommon.FriendTabType.MyFriend] = self.OnListItemObjectSet_MyFriend,
        [FriendCommon.FriendTabType.AddFriend] = self.OnListItemObjectSet_AddFriend,
        [FriendCommon.FriendTabType.RecentMatch] = self.OnListItemObjectSet_RecentMatch,
        [FriendCommon.FriendTabType.RegionFriend] = self.OnListItemObjectSet_AddFriend,
        [FriendCommon.FriendDialogType.BlackList] = self.OnListItemObjectSet_BlackList,
        [FriendCommon.FriendDialogType.FriendRequest] = self.OnListItemObjectSet_FriendRequest,
        [FriendCommon.EmptyItem] = self.OnListItemObjectSet_Empty,
    }
    Switch[self.Type](self, Content)
end

function M:OnAnimationFinished(Anim)
    if Anim == self.In then
        self:SetRenderOpacity(1)
    end
end

function M:_SetupBtnInvite()
    DebugPrint(DebugTag, LXYTag, "_SetupBtnInvite")
    self.Button_Invite:SetVisibility(UIConst.VisibilityOp.Visible)
    local Text, bForbid ="", false
    local AvatarInfo = nil
    if self.Type == FriendCommon.FriendTabType.MyFriend then
        AvatarInfo = self.FriendData.Info
    elseif self.Type == FriendCommon.FriendDialogType.BlackList then
        Text = GText("UI_Friend_DelBlackList")
    elseif self.Type == FriendCommon.FriendTabType.RecentMatch then
        AvatarInfo = self.PersonData
    end
    if AvatarInfo then
        if TeamModel:GetInviteSendBox()[AvatarInfo.Uid] then
            Text,bForbid = GText("UI_Team_Invited"), true
        elseif TeamModel:IsMemberExist(AvatarInfo.Uid) then
            Text, bForbid =  GText("UI_Team_InTeam"), true
        elseif not AvatarInfo.IsOnline then
            Text,bForbid = GText("UI_Friend_State_Offline"), true
        elseif AvatarInfo.IsInDungeon then
            Text,bForbid = GText("UI_Chat_InDungeon"), true
        elseif AvatarInfo.IsInSpecialQuest then
            Text,bForbid = GText("UI_Chat_InSpecialQuest"), true
        else
            Text = GText("UI_Friend_Invite")
        end
    end
    self.Button_Invite:SetText(Text)
    self.Button_Invite:ForbidBtn(bForbid)
end

function M:_SetupBtnFunction()
    if self.Type == FriendCommon.FriendTabType.MyFriend then
        self.Switcher_State:SetActiveWidgetIndex(0)
    elseif self.Type == FriendCommon.FriendTabType.AddFriend or self.Type == FriendCommon.FriendTabType.RegionFriend then
        ---@type FriendRequest  @note 已发送添加申请且申请还没过期的人不能再发送
        local SendInfo = FriendModel:GetRequestSendBox()[self.PersonData.Uid]
        ---@type Friend  @note 已添加的好友不能再发送
        local FriendInfo = FriendModel:GetFriendDict()[self.PersonData.Uid]
        if FriendInfo or (SendInfo and not SendInfo:IsExpired()) then
            self.Switcher_State:SetActiveWidgetIndex(3)
            self.Button_Funtion:ForbidBtn(true)
        else
            self.Switcher_State:SetActiveWidgetIndex(1)
        end
    elseif self.Type == FriendCommon.FriendTabType.RecentMatch then
        self.Switcher_State:SetActiveWidgetIndex(1)
    end
    self.Button_Funtion:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:_SetRemarkName(Remark)
    self.Text_Remark:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Split:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Split_1:SetVisibility(UIConst.VisibilityOp.Visible)
    if not Remark or Remark == "" then
        self.Text_Remark:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Split:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Split_1:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return
    end
    self.Text_Remark:SetText(Remark)
end

function M:_SetStar(bStar)
    local StarVisibilityTab = bStar and "Visible" or "Collapsed"
    self.Icon_Star:SetVisibility(UIConst.VisibilityOp[StarVisibilityTab])
end

function M:_SetHeadIcon(AvatarInfo)
    self.Head_Friend:SetHeadIconById(AvatarInfo.HeadIconId)
    self.Head_Friend:SetHeadFrame(AvatarInfo.HeadFrameId)
    self.Head_Friend:SetHoldUp(true)
end

function M:_SetOnlineState(IsOnline)
    self.HB_Loca:SetVisibility(UIConst.VisibilityOp.Visible)
    if not IsOnline then
        local OfflineDayMax = DataMgr.GlobalConstant.FriendOfflineDayMax.ConstantValue
        local Day = math.floor((TimeUtils.NowTime()-self.FriendData.Info.LastLogoutTime)/CommonConst.SECOND_IN_DAY)
        if Day <1 or self.FriendData.Info.LastLogoutTime == 0 then
            self.Text_Loca:SetText(GText("UI_Friend_OffLineToday"))
        elseif Day<= OfflineDayMax then
            self.Text_Loca:SetText(string.format(GText("UI_Friend_OfflineNDay"), Day))
        elseif Day > OfflineDayMax then
            self.Text_Loca:SetText(GText("UI_Friend_OfflineOver30Day"))
        end
        self:PlayAnimation(self.OffLine)
    else
        if not self.FriendData.Info.IsInDungeon then
            self.Text_Loca:SetText(GText("UI_Friend_Online"))
            self:PlayAnimation(self.OnLine)
        else
            self.Text_Loca:SetText(GText("UI_Chat_InDungeon"))
            self:PlayAnimation(self.OnMission)
        end
    end
end

function M:_SetSign(SignText)
    if self.Type == FriendCommon.FriendDialogType.FriendRequest then
        self.Icon_Message:SetVisibility(UIConst.VisibilityOp.Visible)
    else
        self.Icon_Message:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Type == FriendCommon.FriendDialogType.BlackList then
        self.Text_Intro:SetText(GText("UI_Friend_AlreadyBlacklist"))
        return
    end
    ---@note 签名为空的情况
    if not SignText or  SignText == "" then
        self.Text_Intro:SetText(GText("UI_Friend_NoSignature"))
        return
    end
    self.Text_Intro:SetText(SignText)
end

function M:OnListItemObjectSet_MyFriend(Content)
    ---@type Friend
    self.FriendData = Content.Data
    self.PersonData = self.FriendData.Info
    self.Text_Name:SetText(self.FriendData.Info.Nickname)
    self:_SetRemarkName(self.FriendData.Remark)
    self:_SetHeadIcon(self.FriendData.Info)
    UIUtils.SetTitle(self.Title, self.FriendData.Info)
    self.Num_Level:SetText(tostring(self.FriendData.Info.Level))
    self:_SetStar(self.FriendData.Star)
    self.HB_Button:SetVisibility(UIConst.VisibilityOp.Visible)
    self:_SetupBtnInvite()
    self:_SetupBtnFunction()
    self:_SetOnlineState(self.FriendData.Info.IsOnline)
    self:_SetSign(self.FriendData.Info.Signature)
    -- self.Key_Function:CreateCommonKey({
    --     KeyInfoList = {
    --         {
    --             Type = "Img",
    --             ImgShortPath = "X",
    --         }
    --     },
    -- })
    if Content.bShowGift then
        self.HB_Gift:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self:_UpdateGiftButtonState()
    end
end

-- 根据条件更新礼物按钮禁用/启用视觉与逻辑
function M:_UpdateGiftButtonState()
    local uid = self.FriendData and self.FriendData.Info and self.FriendData.Info.Uid
    if not uid then return end

    -- GM开启：按钮点亮并直接到商店
    if GMVariable and GMVariable.IgnoreGiftShopFriendLimit then
        self.Button_Gift:ForbidBtn(false)
        return
    end

    local canSend = GiftController:CheckCanSendGift(uid)
    self.Button_Gift:ForbidBtn(not canSend)
end

function M:OnListItemObjectSet_AddFriend(Content)
    ---@type AvatarInfo
    self.PersonData = Content.Data
    self.HB_Button:SetVisibility(UIConst.VisibilityOp.Visible)
    self:_SetupBtnFunction()
    self.Text_Name:SetText(self.PersonData.Nickname)
    self.Num_Level:SetText(tostring(self.PersonData.Level))
    self:_SetHeadIcon(self.PersonData)
    UIUtils.SetTitle(self.Title, self.PersonData)
    self:_SetSign(self.PersonData.Signature)
    self.Key_Function:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "A",
            }
        },
    })
end

function M:OnListItemObjectSet_RecentMatch(Content)
    ---@type AvatarInfo
    self.PersonData = Content.Data
    self.HB_Button:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Text_Name:SetText(self.PersonData.Nickname)
    self.Num_Level:SetText(tostring(self.PersonData.Level))
    self:_SetHeadIcon(self.PersonData)
    UIUtils.SetTitle(self.Title, self.PersonData)
    self:_SetupBtnInvite()
    self:_SetupBtnFunction()
    self:_SetSign(self.PersonData.Signature)
end

function M:OnListItemObjectSet_BlackList(Content)
    ---@type AvatarInfo
    self.PersonData = Content.Data
    self.Text_Name:SetText(self.PersonData.Nickname)
    self.Num_Level:SetText(self.PersonData.Level)
    self:_SetHeadIcon(self.PersonData)
    UIUtils.SetTitle(self.Title, self.PersonData)
    self:_SetSign()
    self.HB_Button:SetVisibility(UIConst.VisibilityOp.Visible)
    self:_SetupBtnInvite()
end

function M:OnListItemObjectSet_FriendRequest(Content)
    ---@type FriendRequest
    self.RequestData = Content.Data
    self.PersonData = self.RequestData.Info
    self.Text_Name:SetText(self.PersonData.Nickname)
    self.Num_Level:SetText(self.PersonData.Level)
    self:_SetHeadIcon(self.PersonData)
    UIUtils.SetTitle(self.Title, self.PersonData)
    self:_SetSign(self.RequestData.Remark)
    self.HB_Button_Request:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:OnListItemObjectSet_Empty()
    self.Panel_Portrait:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.HB_Name:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.HB_Button_Request:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.HB_Intro:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnBtnGiftClick()
    local uid = self.FriendData and self.FriendData.Info and self.FriendData.Info.Uid
    if not uid then return end

    --如果此时拿不到好友数据，说明好友突然被删除了
    local FriendData = FriendController:GetModel():GetFriendDict()[self.FriendData.Info.Uid]
    if not FriendData then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_SendGift_NoLongerFriend"))
        return
    end

    -- GM开启：忽略限制，直接进入商店
    if GMVariable and GMVariable.IgnoreGiftShopFriendLimit then
        GiftController:OpenGiftShopMain(uid)
        return
    end

    if GiftController:CheckCanSendGift(uid) then
        GiftController:OpenGiftShopMain(uid)
    else
        -- 兜底：不满足条件时弹出不可送礼提示
        GiftController:OpenCanNotSendPopup(uid)
    end
end

-- 禁用态点击：通用按钮接口会把禁用态点击分发到这里
function M:OnGiftForbidClick()
    local uid = self.FriendData and self.FriendData.Info and self.FriendData.Info.Uid
    if not uid then return end
    GiftController:OpenCanNotSendPopup(uid)
end

function M:Destruct()
    self.Button_Invite:UnBindEventOnReleased(self, self.OnBtnInviteReleased)
    self.Button_Funtion:UnBindEventOnReleased(self, self.OnBtnFunctionReleased)
    self.Button_Yes:UnBindEventOnReleased(self, self.OnBtnYesOrNoRelease)
    self.Button_No:UnBindEventOnReleased(self, self.OnBtnYesOrNoRelease)
    self.Head_Anchor.OnGetUserMenuContentEvent:Unbind()
    self.Head_Anchor.OnMenuOpenChanged:Remove(self, self.HeadMenuOpenChanged)
    self:PlayAnimation(self.Out)
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self,self.RefreshOpInfoByInputDevice)
    M.Super.Destruct(self)
end

--region 手柄相关
-- 单独抽取：根据禁用态更新按钮与头像的命中可见性（HitTestInvisible/Visible）手柄导航需要
function M:UpdateHitTestForDisabled(bEnable)
    if bEnable then
        -- local forbidInvite = self.Button_Invite:IsBtnForbidden()
        -- local forbidTalk = self.Button_Talk:IsBtnForbidden()
        -- local forbidFun = self.Button_Funtion:IsBtnForbidden()
        -- local forbidGift = self.Button_Gift:IsBtnForbidden()
        -- if forbidInvite then self.Button_Invite:SetVisibility(UIConst.VisibilityOp.HitTestInvisible) end
        -- if forbidTalk then self.Button_Talk:SetVisibility(UIConst.VisibilityOp.HitTestInvisible) end
        -- if forbidFun then self.Button_Funtion:SetVisibility(UIConst.VisibilityOp.HitTestInvisible) end
        -- if forbidGift then self.Button_Gift:SetVisibility(UIConst.VisibilityOp.HitTestInvisible) end
        self.Button_Gift:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Head_Friend:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        -- if self.Button_Invite:GetVisibility() == UIConst.VisibilityOp.HitTestInvisible then
        --     self.Button_Invite:SetVisibility(UIConst.VisibilityOp.Visible)
        -- end
        -- if self.Button_Talk:GetVisibility() == UIConst.VisibilityOp.HitTestInvisible then
        --     self.Button_Talk:SetVisibility(UIConst.VisibilityOp.Visible)
        -- end
        -- if self.Button_Funtion:GetVisibility() == UIConst.VisibilityOp.HitTestInvisible then
        --     self.Button_Funtion:SetVisibility(UIConst.VisibilityOp.Visible)
        -- end
        -- if self.Button_Gift:GetVisibility() == UIConst.VisibilityOp.HitTestInvisible then
        --     self.Button_Gift:SetVisibility(UIConst.VisibilityOp.Visible)
        -- end
        if self.Head_Friend:GetVisibility() == UIConst.VisibilityOp.HitTestInvisible then
            self.Head_Friend:SetVisibility(UIConst.VisibilityOp.Visible)
        end
    end
end

function M:SetGamepadIconVisibility(bShow)
    if bShow then
        self.No_GamePad:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Key_No:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Yes_GamePad:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Key_Yes:SetVisibility(UIConst.VisibilityOp.Visible)
        if (self.Type ~= FriendCommon.FriendDialogType.BlackList) and (self.Type ~= FriendCommon.FriendTabType.MyFriend) then
            self.Key_Function:SetVisibility(UIConst.VisibilityOp.Visible)
            self.Function_GamePad:SetVisibility(UIConst.VisibilityOp.Visible)
        else
            self.Key_Function:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.Function_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        if self.Type == FriendCommon.FriendTabType.MyFriend then
            self.Function_InviteGamePad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
            self.Key_Invite:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
            --隐藏邀请按钮的快捷键
            self.Button_Invite.bAutoButtonChange=false
            self.Button_Invite:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
        else
            self.Function_InviteGamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.Key_Invite:SetVisibility(UIConst.VisibilityOp.Collapsed)
            --恢复邀请按钮的快捷键
            self.Button_Invite.bAutoButtonChange=true
            self.Button_Invite:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
        end
        self.Button_Invite:SetGamepadIconVisibility(true)
        self.Button_Talk:SetGamepadIconVisibility(true)
        self:UpdateHitTestForDisabled(true)
    else
        self.No_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Key_No:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Yes_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Key_Yes:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Function_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Key_Function:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Button_Invite:SetGamepadIconVisibility(false)
        self.Button_Talk:SetGamepadIconVisibility(false)
        self:UpdateHitTestForDisabled(false)

        self.Function_InviteGamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Key_Invite:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:OnItemSelectionChanged(IsSelected)
    self.bIsSelected = IsSelected
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        if IsSelected then
            self:SetGamepadIconVisibility(true)
            -- 如果反向动画正在播放，先停止它
            if self:IsAnimationPlaying(self.GamePad_Hover) then
                self:StopAnimation(self.GamePad_Hover)
            end
            self:PlayAnimation(self.GamePad_Hover)
            DebugPrint(DebugTag, "jly", "BP_OnItemSelectionChanged Hover", self.GamePad_Hover)
        else
            self:SetGamepadIconVisibility(false)
            -- 如果正向动画正在播放，先停止它
            if self:IsAnimationPlaying(self.GamePad_Hover) then
                self:StopAnimation(self.GamePad_Hover)
            end
            self:PlayAnimationReverse(self.GamePad_Hover)
            DebugPrint(DebugTag, "jly", "BP_OnItemSelectionChanged UnHover", self.GamePad_Hover)
        end
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if CurInputDevice == ECommonInputType.MouseAndKeyboard then
        self:PlayAnimation(self.GamePad_Normal)
        self:SetGamepadIconVisibility(false)
        self.bIsSelected = false
    elseif CurInputDevice == ECommonInputType.Gamepad then
        if self.bIsSelected then
            self:SetGamepadIconVisibility(true)
            self:PlayAnimation(self.GamePad_Hover)
        end
    end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    M.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    if self.bMenuOpen then
        if(InKeyName == "Gamepad_FaceButton_Right") then
            self.Head_Anchor:Close()
            self:SetFocus()
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    if(InKeyName == "Gamepad_FaceButton_Left" and self.Type == FriendCommon.FriendTabType.MyFriend) then
        self:OnBtnFunctionReleased()
        IsHandled = true
    elseif(InKeyName == "Gamepad_FaceButton_Right" and self.Type == FriendCommon.FriendTabType.MyFriend) then
        if self:OnGamePadBDown() then
            IsHandled = true
        end
    elseif(InKeyName == "Gamepad_FaceButton_Bottom" and self.Type == FriendCommon.FriendTabType.AddFriend) then
        self:OnBtnFunctionReleased()
        IsHandled = true
    elseif(InKeyName == "Gamepad_FaceButton_Bottom" and self.Type == FriendCommon.FriendTabType.MyFriend) then
        self:OnGamePadADown_MyFriend()
        IsHandled = true
    elseif(InKeyName == "Gamepad_FaceButton_Bottom" and self.Type == FriendCommon.FriendTabType.RegionFriend) then
        self:OnBtnFunctionReleased()
        IsHandled = true
    elseif(InKeyName == "Gamepad_FaceButton_Bottom" and self.Type == FriendCommon.FriendDialogType.FriendRequest) then
        self:OnBtnYesOrNoRelease(true)
        IsHandled = true
    elseif(InKeyName == "Gamepad_FaceButton_Left" and self.Type == FriendCommon.FriendDialogType.FriendRequest) then
        self:OnBtnYesOrNoRelease(false)
        IsHandled = true
    elseif(InKeyName == "Gamepad_FaceButton_Bottom" and self.Type == FriendCommon.FriendDialogType.BlackList) then
        self:OnBtnInviteReleased()
        IsHandled = true
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local ParentHandled = M.Super.OnKeyUp(self, MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == UIConst.GamePadKey.SpecialLeft then
        if not IsValid(ChatController:GetView(self)) then
            self.Head_Anchor:Open(true)
        end
    end
    return ParentHandled
end
--endregion
function M:OnGamePadADown_MyFriend()
    self.Button_Invite:SetFocus()
    self.Function_InviteGamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Key_Invite:SetVisibility(UIConst.VisibilityOp.Collapsed)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance and GameInstance:GetGameUIManager()
    local FriendMain = UIManager and UIManager:GetUIObj("FriendMain")
    if FriendMain then
        FriendMain:ShowCheckBtn(true)
    end
end

function M:OnGamePadBDown()
    -- 聚焦回到整个item
    if self.HB_Button:HasFocusedDescendants() then
        self:SetFocus()
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local UIManager = GameInstance and GameInstance:GetGameUIManager()
        local FriendMain = UIManager and UIManager:GetUIObj("FriendMain")
        if FriendMain then
            FriendMain:ShowCheckBtn(false)
        end
        self.Function_InviteGamePad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Key_Invite:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        return true
    else
        return false
    end
end

return M

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_OnlineActionItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.UI.BP_EMUserWidgetUtils_C"})
local OnlineActionCommon=require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionCommon"
local OnlineActionModel=require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionModel"
---仅初始化lua变量时使用，千万不要有控件操作！！
-- function M:Initialize(Initializer)
-- end
local AKeyInfo=UIUtils:GatFastKeyInfo("A")
local XKeyInfo=UIUtils:GatFastKeyInfo("X")

function M:Construct()
    --self.Text_Invitation:SetText(GText("UI_RegionOnline_Invitation"))
    self.Text_Select:SetText(GText("UI_RegionOnline_Position"))
    self.Text_Invited:SetText(GText("UI_RegionOnline_Invited"))
    -- 绑定按钮
    self.Button_No.Button_Area.OnClicked:Add(self, self.OnClickReject)
    self.Button_Yes.Button_Area.OnClicked:Add(self, self.OnClickAccept)
    self.Btn_Invite.Button_Area.OnClicked:Add(self, self.OnClickInvitation)
    for i = 1, 4 do
        local Text=string.format(GText("UI_RegionOnline_PositionNum"), i)
        self["Option_" .. i].Parent=self
        self["Option_" .. i].Text_Option:SetText(Text)
        local Function = function()
            self.OnClickPosition(self, i, self["Option_" .. i])
        end
        self["Option_" .. i].Btn_Area.OnClicked:Add(self, Function)
    end

    --默认A似乎省略能节约下性能
    -- self.Key_Invite:CreateCommonKey(AKeyInfo)
    -- self.Key_Yes:CreateCommonKey(AKeyInfo)
    self.Key_No:CreateCommonKey(XKeyInfo)
    self.Key_Invite:SetVisibility(UIConst.VisibilityOp.Hidden)
    
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if (IsValid(GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(GameInputModeSubsystem:GetCurrentInputType())
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end

    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        self:InitKeyboardUI()
    end
    -- self:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    -- self:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
end

-- 数据结构参考
--[[
    Content={
        Kind = 1==申请列表 2=邀请列表 3=好友列表

        Uid = AvatarInfo.AvatarInfo.Uid,
        NickName = AvatarInfo.AvatarInfo.Nickname,
        ObjId = ObjId,
        Actor = OtherPlayer,

        Level = AvatarInfo.AvatarInfo.Level,
        TitleBefore=AvatarInfo.AvatarInfo.TitleBefore,
        TitleAfter=AvatarInfo.AvatarInfo.TitleAfter,
        TitleFrame=AvatarInfo.AvatarInfo.TitleFrame,
        HeadIconId=AvatarInfo.AvatarInfo.HeadIconId,
        HeadFrameId=AvatarInfo.AvatarInfo.HeadFrameId,

        ActionResourceId,

    }
        CallbackObj=Item.CallbackObj

        --申请和邀请的需要的回调
        AcceptCallback=Item.AcceptCallback
        RejectCallback=Item.RejectCallback

        --可邀请列表需要的回调
        InvitationCallback=Item.InvitationCallback
        MaxPlayerNum=Item.MaxPlayerNum
]]
function M:OnListItemObjectSet(Item)
    local Content=Item.Content
    self.Content = Content
    self.Kind = Item.Kind
    Item.UI=self
    self.Item=Item
    if not Content.HeadIconId then
        ScreenPrint("联机动作UI缺少 HeadIconId ")
        Content.HeadIconId = 10001
    end
    self.Head_Player:SetHeadIconById(Content.HeadIconId, false)
    if not Content.HeadFrameId then
        ScreenPrint("联机动作UI缺少 HeadFrameId ")
    end
    self.Head_Player:SetHeadFrame(Content.HeadFrameId)

    if not Content.Level then
        ScreenPrint("联机动作UI缺少 Level ")
    end
    self.Num_Level:SetText(Content.Level or 1 )

    if not Content.NickName then
        ScreenPrint("联机动作UI缺少 NickName ")
    end
    self.Text_Name:SetText(Content.NickName)

    if not Content.TitleBefore then
        ScreenPrint("联机动作UI缺少 TitleBefore ")
    end

    if Content.TitleBefore or Content.TitleAfter then
        if Content.TitleFrame then
            self:SetTitle(Content.TitleBefore, Content.TitleAfter, Content.TitleFrame)
        else
            ScreenPrint("联机动作UI缺少 TitleFrame ")
        end
    end

    if Content.bNew then
        self.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    self.Panel_Invite:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Option:SetVisibility(UIConst.VisibilityOp.Collapsed)

    if Item.Kind == 1 then
        --self.Btn_Apply:SetVisibility(ESlateVisibility.Collapsed)
        self.WS_Btn:SetActiveWidgetIndex(0)
        self:BindApplyCallback(Item.CallbackObj, Item.AcceptCallback, Item.RejectCallback)
    elseif Item.Kind == 2 then --邀请他人加入当前动作
       -- self.Btn_Invitation:SetVisibility(ESlateVisibility.Collapsed)
       	local FriendModel = require "BluePrints.UI.WBP.Friend.FriendModel"
        if FriendModel:IsFriend(Content.Uid) then
            local Text= Content.NickName .. " (" .. GText("MAIN_UI_FRIEND") .. ")" 
            self.Text_Name:SetText(Text) 
        end
        self:PlayAnimation(self.Fold_Normal)
        self:BindNearByPlayerCallback(Item.CallbackObj, Item.InvitationCallback, Item.MaxPlayerNum)
        local ifHaveSeatValid = OnlineActionModel:IfHaveSeatValid(self.Content.UniqueId)
        if ifHaveSeatValid then
            self.WS_Btn:SetActiveWidgetIndex(1)
            self.Text_Invited:SetText(GText("UI_RegionOnline_Invited"))
        else
            self.WS_Btn:SetActiveWidgetIndex(4)
            self.Text_Invited:SetText(GText("UI_RegionOnline_SitOccupied"))
        end
    elseif Item.Kind == 3 then
      --  self.Btn_NearByPlayer:SetVisibility(ESlateVisibility.Collapsed)
        self.WS_Btn:SetActiveWidgetIndex(0)
        self.Panel_Invite:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        if self.Content.UniqueId then
            local ActionName=OnlineActionModel:GetActionNameByUniqueId(self.Content.UniqueId)
            local InteractiveIdText="("..string.format(GText("UI_RegionOnline_PositionNum"), Item.Content.InteractiveId+1)..")"
            if OnlineActionModel:GetMaxInteractiveNum(self.Content.UniqueId) > 1 then
                self.Text_Name_Invite:SetText(GText(ActionName).." "..InteractiveIdText)
            else
                self.Text_Name_Invite:SetText(GText(ActionName))
            end
        end
        self:BindInvitationCallback(Item.CallbackObj, Item.AcceptCallback, Item.RejectCallback)
    end

    if self.Kind ~=2 then
        self.ProgressBar:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self:UpdataProgress()
    else
        self.ProgressBar:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    if Item.NeedAni then
        self:PlayAnimation(self.Invite_In)
        Item.NeedAni=false
    end
end

function M:SetTitle(TitleBefore, TitleAfter, TitleFrame)
    UIUtils.SetTitle(self.GroupTitle, {
        TitleBefore = TitleBefore,
        TitleAfter = TitleAfter,
        TitleFrame = TitleFrame
    })
    -- local TitleWidget=UIManager(self):LoadTitleFrameWidget(TitleFrame)
    -- if TitleWidget then
    --     TitleWidget:SetTitle(TitleBefore,TitleAfter)
    -- else

    --     ScreenPrint("联机动作UI SetTitle缺少 TitleFrame ")
    -- end
end

function M:BindInvitationCallback(CallbackObj, AcceptCallback, RejectCallback)
    self.CallbackObj = CallbackObj
    self.AcceptCallback = AcceptCallback
    self.RejectCallback = RejectCallback
end

function M:BindApplyCallback(CallbackObj, AcceptCallback, RejectCallback)
    self.CallbackObj = CallbackObj
    self.AcceptCallback = AcceptCallback
    self.RejectCallback = RejectCallback
end

function M:BindNearByPlayerCallback(CallbackObj, InvitationCallback, MaxPlayerNum)
    self.CallbackObj = CallbackObj
    self.InvitationNearByPlayerCallback = InvitationCallback
    self.MaxPlayerNum = MaxPlayerNum
end

-- 交互相关 点击邀请按钮回调，如果
function M:OnClickInvitation()
    if self.MaxPlayerNum and self.MaxPlayerNum > 1 then
        self:ShowPositionUI() 
        return true
    else
        if self.InvitationNearByPlayerCallback then 
            self.InvitationNearByPlayerCallback(self.CallbackObj, self.Content,1)
        end
        self.WS_Btn:SetActiveWidgetIndex(4)
        return false
    end
end
-- 绑定接受回调
function M:OnClickAccept()
    if self.AcceptCallback then
        self.AcceptCallback(self.CallbackObj, self.Content) 
    end
end
-- 绑定拒绝回调
function M:OnClickReject()
    if self.RejectCallback then
        self.RejectCallback(self.CallbackObj, self.Content)
    end
end
-- 绑定选择座位回调
function M:OnClickPosition(Index,Widget)
    AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", "OnlineActionpositionClick", nil)
    if self.InvitationNearByPlayerCallback then 
        self.InvitationNearByPlayerCallback(self.CallbackObj, self.Content,Index)
    end
    self.WS_Btn:SetActiveWidgetIndex(4)
    Widget.Text_Option:SetText(GText("UI_RegionOnline_Invited"))
    -- 改为：Click 播完再 Forbidden；无 Click 时直接 Forbidden
    Widget.Btn_Area:SetForbidden(true)
    if Widget.Click then
        Widget:UnbindAllFromAnimationFinished(Widget.Click)
        Widget:BindToAnimationFinished(Widget.Click, function()
            Widget:StopAllAnimations()
            Widget:PlayAnimation(Widget.Forbidden)
            Widget:UnbindAllFromAnimationFinished(Widget.Click)
        end)
        Widget:PlayAnimation(Widget.Click)
    else
        Widget:PlayAnimation(Widget.Forbidden)
    end
    Widget:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    --self["Option_" .. Index].IsInvited=true
    self["IsInvited_"..Index]=true
    self:CheckIsAllPositionInvited()
end

function M:CheckIsAllPositionInvited()
    for i = 1, self.Item.MaxPlayerNum do
        if not self["IsInvited_"..i] then
            return false
        end
    end
    self:PlayAnimation(self.Fold)
    if self.IsGamePad then
        self:SetFocus()
    end
    return true
end

function M:FreshPositionUI()
    for i = 1, 4 do
        local Text=string.format(GText("UI_RegionOnline_PositionNum"), i)
        self["Option_" .. i].Text_Option:SetText(Text)
        self["IsInvited_"..i]=false
    end 
end

function M:ShowPositionUI()
    self:FreshPositionUI()
    self.WS_Btn:SetActiveWidgetIndex(2)
    self.Panel_Option:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:PlayAnimation(self.Expand)
    local SeatVaildInfo = OnlineActionModel:GetSeatVaildInfo()
    for i = 1, 4 do
        if i <= self.MaxPlayerNum then
            self["Option_" .. i]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            if SeatVaildInfo[i - 1] and SeatVaildInfo[i - 1].Valid~=false then
                self["Option_" .. i].Btn_Area:SetForbidden(false)
            else
                self["Option_" .. i].Btn_Area:SetForbidden(true)
                local Text = string.format(GText("UI_RegionOnline_PositionNum"), i)
                Text = Text .. "(" .. GText("UI_RegionOnline_Occupied") .. ")"
                self["Option_" .. i].Text_Option:SetText(Text)
                self["Option_" .. i]:PlayAnimation(self["Option_" .. i].Forbidden)
                self["Option_" .. i]:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
            end
        else
            self["Option_" .. i]:SetVisibility(ESlateVisibility.Collapsed)
        end

        -- self["Option_" .. i]:PlayAnimation(self.Normal)
    end
end

function M:HidePositionUI()
    -- 收起位置选择面板：播放折叠动画、隐藏选项面板、还原按钮切页
    self:PlayAnimation(self.Fold)
    self.Panel_Option:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WS_Btn:SetActiveWidgetIndex(1)
    if self.IsGamePad then
        self:SetFocus()
    end
end

-- 根据当前输入方式更新界面的样式
function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    -- 根据当前输入方式更新界面的样式，子类重写该方法
    if CurInputType == ECommonInputType.MouseAndKeyboard then
        self:InitKeyboardUI()
    elseif CurInputType == ECommonInputType.Gamepad then
        self:InitGamepadUI()
    end
end

function M:InitGamepadUI()
    self.IsGamePad = true
end

function M:InitKeyboardUI()
    self.IsGamePad = false
    self.No_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Yes_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Key_Invite:SetVisibility(UIConst.VisibilityOp.Hidden)--collapsed有异常抖动
    for i = 1, 4 do
        self["Option_" .. i].Key_Option_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.Normal)
end

--设置邀请和申请UI的进度条
function M:UpdataProgress()
    if self.Kind ~=2 then
        local RemainTime=self.Content.RemainTime
        local Progress=RemainTime/OnlineActionCommon.AutoRejectTime
        self.ProgressBar:SetPercent(Progress)
    end
end
--
function M:NotifyTick( InDeltaTime)
    self:UpdataProgress()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    DebugPrint("OnlineAction Item Received OnKeyDown" .. InKeyName)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        self.IsGamePad = true
        --IsEventHandled = self.Tab_OnlineAction:Handle_KeyEventOnGamePad(InKeyName)
        if not IsEventHandled then
            IsEventHandled = self:OnGamePadDown(InKeyName)
        end
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnGamePadDown(InKeyName)
    if not self.GamePadInputMap then
    self.GamePadInputMap={
        [UIConst.GamePadKey.FaceButtonLeft]=self.OnGamePadReject,
        [UIConst.GamePadKey.FaceButtonBottom]=self.OnGamePadClick,
        [UIConst.GamePadKey.FaceButtonRight]=self.OnGamePadReturn,
    }
    end
    if self.GamePadInputMap[InKeyName] then
        local Result = self.GamePadInputMap[InKeyName](self)
        if Result then
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnGamePadClick()
    local NeedFocusNext = true
    if self.Kind == 2 then
        NeedFocusNext = false
        local IsHaveManySeat = self:OnClickInvitation(self.Content)
        self.Btn_Invite:PlayAnimation(self.Btn_Invite.Click)
        if IsHaveManySeat then
            self.Option_1.Btn_Area:SetFocus()
        end
    end
    if NeedFocusNext then
        self.Item.Parent:FocusNextItem(self.Item)
    end
    if self.AcceptCallback and self.Kind ~= 2 then
        self.AcceptCallback(self.CallbackObj, self.Content)
    end

end

function M:OnGamePadReject()
    self.Item.Parent:FocusNextItem(self.Item)
    self.Button_No:PlayAnimation(self.Button_No.Click)
    if self.RejectCallback then
        self.RejectCallback(self.CallbackObj, self.Content)
    end 
end

function M:OnGamePadReturn()
    if self.Kind==2 and  self.HB_Option:HasFocusedDescendants() then
        self:PlayAnimation(self.Fold)
        self:SetFocus()
        return true
    end
end

function M:OnRemovedFromFocusPath()
    self.No_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Yes_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Key_Invite:SetVisibility(UIConst.VisibilityOp.Hidden)--collesp有异常抖动
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.Normal)
end

function M:OnAddedToFocusPath()
    if not self.IsGamePad then
        return
    end
    self.No_GamePad:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Yes_GamePad:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Key_Invite:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:StopAnimation(self.Normal)
    self:PlayAnimation(self.Hover)
end

-- function M:Tick(MyGeometry, InDeltaTime)
-- end

-- function M:Destruct()
-- end

return M

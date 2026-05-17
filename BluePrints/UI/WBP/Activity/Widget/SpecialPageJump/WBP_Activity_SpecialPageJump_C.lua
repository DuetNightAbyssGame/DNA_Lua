--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_SpecialPageJump_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"
local DevServerList = require "BluePrints/UI/GameLogin/DevServerList"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

function M:Construct()
    self.Btn_Goto:BindEventOnClicked(self, self.OnBtn_GotoClicked)
    self.Btn_Reward:BindEventOnClicked(self, self.OnBtn_RewardClicked)
end


function M:InitPage(ActivityId, ParentTabId, AllActivityId, ParentWidget)
    self.ActivityId = ActivityId
    self.ParentTabId = ParentTabId
    self.AllActivityId = AllActivityId
    self.ParentWidget = ParentWidget
    self.Area = "China"
    local Avatar = GWorld:GetAvatar()
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.Hostnum then
        self.Area = DevServerList[Avatar.Hostnum].area
    end
    self:InitUI()
end

function M:RefreshButtonState()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local WebJumpList = Avatar.WebJumpList
    if not WebJumpList then
        return
    end
    local isDone = WebJumpList[self.ActivityId]
    if isDone == nil or isDone == 0 then
        self.WS_Btn:SetActiveWidgetIndex(0)
        self.Text_Progressing:SetText(GText("UI_GameEvent_ToBeFinished"))
    elseif isDone == 1 then
        self.WS_Btn:SetActiveWidgetIndex(1)
        self.Btn_Reward:SetText(GText("UI_GameEvent_ClaimReward"))
    elseif isDone == 2 then
        self.WS_Btn:SetActiveWidgetIndex(2)
        self.Text_Got:SetText(GText("UI_GameEvent_HasClaimed"))
    end
    self.isGetReward = isDone == 2
    self:InitRewardInfo()
end

function M:InitUI()
    self:RefreshButtonState()
    self.Btn_Goto:SetText(GText("UI_GameEvent_Goto"))
    self.Text_RewardTitle:SetText(GText("UI_GameEvent_EventPortal_RewardPreview"))
    self.CurActivityId = self.ActivityId

    local ActivityConfigData = DataMgr.EventMain[self.ActivityId]
    if (ActivityConfigData.EventNameBPPath) then
        self.Title:ClearChildren()
        local TitleWidget = UIManager(self):CreateWidget(ActivityConfigData.EventNameBPPath)
        TitleWidget.Text_Title:SetText(GText(ActivityConfigData.EventName))
        TitleWidget.Text_SubTitle:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Title:AddChildToOverlay(TitleWidget)
        self.Title:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Title:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end

    self.Text_Desc:SetText(GText(ActivityConfigData.EventDes))
    self.Text_Desc_White:SetText(GText(ActivityConfigData.EventDes))
    self.ActivityEndTime = ActivityConfigData.EventEndTime and ActivityConfigData.EventEndTime or ActivityConfigData.PermanenEventTime
    self.RewardEndTime = ActivityConfigData.RewardEndTime
    self:InitTimeInfo()
    self:InitRewardInfo()

    self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    if (IsValid(self.GameInputModeSubsystem)) then
        self:UpdateUIByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType())
    end
    if self.Key_RewardTitle then
        self.Key_RewardTitle:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "LS",
                },
            },
        })
    end
    self.Btn_Goto:SetDefaultGamePadImg("A")
    self.Btn_Reward:SetDefaultGamePadImg("X")
    self.IsSelectItem = false
    self.IsOpenTip = false
end

function M:InitRewardInfo()
    local PageConfigData = self:GetPageConfigData()
    local PreViewReward = PageConfigData[self.Area].Reward
    local RewardContentList = {}
    self.List_Reward.OnCreateEmptyContent:Unbind()
    self.List_Reward.OnCreateEmptyContent:Bind(self, function(self)
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Id = 0
        return Content
    end)
    self.List_Reward:ClearListItems()
    local RewardInfo = DataMgr.Reward[PreViewReward]
    if self.RewardList == nil then
        self.RewardList = {}
    end
    if RewardInfo then
        local RewardIds = RewardInfo.Id or {}
        local RewardCounts = RewardInfo.Count or {}
        local RewardTypes = RewardInfo.Type or {}
        for i = 1, #RewardIds do
            local ItemId = RewardIds[i]
            local Count = RewardUtils:GetCount(RewardCounts[i])
            local Rarity = ItemUtils.GetItemRarity(ItemId, RewardTypes[i])
            local ItemType = RewardTypes[i]
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.Id = ItemId
            Content.ItemType = ItemType
            Content.Count = Count
            Content.Rarity = Rarity
            Content.Icon = DataMgr[ItemType][ItemId].Icon
            Content.IsShowDetails = true
            Content.ParentWidget = self
            Content.bHasGot = self.isGetReward
            Content.OnMenuOpenChangedEvents = {
                Obj = self,
                Callback = self.MenuOpenChangedEvent
            }
            table.insert(RewardContentList, Content)
        end
        end

    for _, ItemContent in ipairs(RewardContentList) do
        self.List_Reward:AddItem(ItemContent)
    end
    self:AddTimer(0.1, function()
        self.List_Reward:RequestFillEmptyContent()
    end)
end

function M:InitTimeInfo()
    if (self.ActivityEndTime ~= nil or self.RewardEndTime ~= nil) and self.Activity_Time.Com_Time then
        ActivityUtils.RefreshLeftTime(self, self.Activity_Time.Com_Time)
        self:AddTimer(1.0, ActivityUtils.RefreshLeftTime, true, 0, "RefreshLeftTime", true, self.Activity_Time.Com_Time)
    else
        ActivityUtils.SetLeftTimeView(self.Activity_Time.Com_Time, true)
    end
end

function M:OnBtn_GotoClicked()
    local PageConfigData = self:GetPageConfigData()
    if not PageConfigData then
        return
    end
    local WebId = PageConfigData[self.Area].WebId
    if not WebId then
        DebugPrint("JLY WebId not found, Area:", self.Area)
        return
    end
    local WebList = DataMgr.WebList
    local WebInfo = WebList[WebId]
    if not WebInfo then
        DebugPrint("JLY WebInfo not found, WebId:", WebId)
        return
    end
    local JumpLink = WebInfo.PCJumpLink
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        if WebInfo.PhoneJumpLink and WebInfo.PhoneJumpLink ~= "" then
            JumpLink = WebInfo.PhoneJumpLink
        end
    end
    UE4.UKismetSystemLibrary.LaunchURL(JumpLink)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    Avatar:MarkWebJumped(self.ActivityId, function(ErrCode)
        if ErrCode ~= 0 then
            return
        end
        ActivityReddotHelper.TryAddReddotCount(ActivityUtils,self.ActivityId,"Red")
        self:RefreshButtonState()
    end)
end

function M:OnBtn_RewardClicked()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    Avatar:GetWebJumpReward(self.ActivityId, function(ErrCode, Rewards)
        if ErrCode ~= 0 then
            return
        end
        if Rewards then
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, nil, self, true, false, false, nil)
        end
        ActivityReddotHelper.TrySubReddotCount(ActivityUtils,self.ActivityId,"Red")
        self:RefreshButtonState()
    end)
end

function M:GetPageConfigData()
    return DataMgr.WebJumpEvent[self.ActivityId]
end

function M:PlayFadeIn()
    self:PlayAnimation(self.In)
    local TitleWidget = self.Title:GetChildAt(0)
    if (TitleWidget.In ~= nil) then
        TitleWidget:PlayAnimationForward(TitleWidget.In)
    end
end

function M:HidePage(IsNeedPlayOutAnim)
    if (IsNeedPlayOutAnim) then
        self:PlayFadeOut()
    end
    self:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:PlayFadeOut(IsRemoveFromParent)
    -- 播放退场动画
    self:PlayAnimation(self.Out)
end

function M:UpdatePage(OperateSrc)
end

function M:ShowPage(IsNeedPlayInAnim)
    if (IsNeedPlayInAnim) then
        self:PlayFadeIn()
    end
    self:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
end

function M:HandleKeyDownInPage(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadButtonDown(InKeyName)
    end
    return IsEventHandled
end


-- region 手柄
function M:OnGamePadButtonDown(InKeyName)
    local IsEventHandled = self:Handle_KeyDownOnGamePad(InKeyName)
    return IsEventHandled
end

function M:Handle_KeyDownOnGamePad(InKeyName)
    -- 处理手柄相关的交互事件
    local IsEventHandled = false
    if (InKeyName == UIConst.GamePadKey.LeftThumb) then
        self.IsSelectItem = true
        self.List_Reward:SetFocus()
        self.Btn_Goto:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Key_RewardTitle:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Btn_Reward:SetGamePadIconVisible(false)
        local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
        if ActivityMain then
            ActivityMain:UpdateActivityKeyTips("CheckRewardDetailView")
        end
        IsEventHandled = true
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonBottom and self.IsSelectItem == false) then
        self:OnBtn_GotoClicked()
        IsEventHandled = true
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonLeft and self.IsSelectItem == false) then
        self:OnBtn_RewardClicked()
        IsEventHandled = true
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonRight and self.IsSelectItem and self.IsOpenTip == false) then
        self.IsSelectItem = false
        local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
        if ActivityMain then
            ActivityMain.List_Tab:SetFocus()
            ActivityMain:UpdateActivityKeyTips("nil")
        end
        self.Btn_Goto:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Key_RewardTitle:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Btn_Reward:SetGamePadIconVisible(true)
        IsEventHandled = true
    end
    return IsEventHandled
end

function M:MenuOpenChangedEvent(IsOpened, Content)
    if ModController:IsMobile() then
        return
    end
    local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
    self.LastFocusWidget = Content.SelfWidget
    if IsOpened then
        self.IsOpenTip = true
        if ActivityMain then
            ActivityMain:UpdateActivityKeyTips("EmptyView")
        end
    else
        self.IsOpenTip = false
        if ActivityMain then
            ActivityMain:UpdateActivityKeyTips("CheckRewardDetailView")
        end
        self.LastFocusWidget:SetFocus()
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
        return
    end
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        DebugPrint("jly    已经显示的是该输入模式，不需要进行刷新")
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    self.IsSwitchDevice = true
    self:UpdateUIByInputDevice(self.CurInputDeviceType)
end

function M:UpdateUIByInputDevice(CurInputDeviceType)
    if(CurInputDeviceType == ECommonInputType.Gamepad) then
        self.Key_RewardTitle:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Btn_Goto:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Btn_Reward:SetGamePadIconVisible(true)
    else
        if(not ModController:IsMobile()) then
            local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
            if ActivityMain then
                ActivityMain:UpdateActivityKeyTips(self.FocusWidgetName)
            end
            self.Key_RewardTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Btn_Goto:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
            self.Btn_Reward:SetGamePadIconVisible(false)
            self.IsSelectItem = false
            self.IsOpenTip = false
        end
    end
end

function M:GetCurFocusWidgetInfo()
    self:UpdateUIByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType())
    return self.FocusWidgetName, self.FocusWidgetWidget
end

function M:GetDefaultBottomTips()
    local ResultKeyInfo = {
        {
            KeyInfoList = { { Type = "Img", ImgShortPath = "B", ClickCallback=self.OnReturnKeyDown, Owner=self} },
            Desc = GText("UI_Tips_Close")
        },
    }
    return ResultKeyInfo
end

function M:ReceiveEnterStateSelf(StackAction)
    if (StackAction == 1) then
        if self.IsSelectItem then
            self.IsSelectItem = true
            self.List_Reward:SetFocus()
            self.Btn_Goto:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
            self.Key_RewardTitle:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            self.Btn_Reward:SetGamePadIconVisible(false)
            local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
            if ActivityMain then
                ActivityMain:UpdateActivityKeyTips("CheckRewardDetailView")
            end
        end
    end
end

-- endregion

return M

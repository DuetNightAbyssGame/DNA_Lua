--
-- DESCRIPTION
-- 回归活动主界面
-- @COMPANY **
-- @AUTHOR ** lgc
-- @DATE ${date} ${time}
--
require "UnLua"

local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ReturnUtils = require "Blueprints.UI.WBP.Activity.Widget.Return.ReturnUtils"
local M = Class({
    "BluePrints.UI.BP_UIState_C",
    "BluePrints.Common.TimerMgr",
})

function M:Construct(...)

end

function M:OnLoaded(...)
    self.ParentTabId, self.TargetIndex = ...
    local EventTabConfigData = DataMgr.EventTab[self.ParentTabId]
    if EventTabConfigData and EventTabConfigData.EventId and EventTabConfigData.EventId[1] then
        self.CurActivityId = EventTabConfigData.EventId[1]
    end
    self.CurrentEventId = DataMgr.ComeBackEventConstant.CurrentEventId.ConstantValue
    self.CurrentEventSchemeId = DataMgr.ComeBackEventConstant.CurrentEventSchemeId.ConstantValue
    if self.CurrentEventSchemeId then
        self.EventSchemeData = DataMgr.ComeBackEvent[self.CurrentEventSchemeId]
    end
    self.CurSubTab = nil
    self.CurChildWidget = nil
    local bMobile = UIUtils.IsMobileInput()
    self.ComTab = nil
    if bMobile then
        self.Group_Tab:SetActiveWidgetIndex(1)
        self.ComTab = self.Com_Tab_M
    else
        self.Group_Tab:SetActiveWidgetIndex(0)
        self.ComTab = self.Com_Tab_P
    end
    self.ComTab:Init({
        DynamicNode = { "Back",},
        StyleName = "Text",
        TitleName = GText("UI_ComebackEvent_EventTitle"),
        OwnerPanel = self,
        BackCallback = self.CloseSelf}
    )
    self.ComTime = UIManager(self):CreateWidget('/Game/UI/WBP/Common/Time/WBP_Com_Time.WBP_Com_Time', true)
    if self.ComTime then
        self.ComTab.Pos_DayAndNight:AddChild(self.ComTime)
        self.ComTab.Pos_DayAndNight:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:InitTimeInfo()
    end

    self:InitTabItems()
    self:InitReddot()

    self:OnTabItemClicked(self.TargetIndex)
    self:PlayInAnimation()
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "OpenReturnMain", nil)
end

function M:InitReddot()
    ReturnUtils.ReturnAddReddotListener(self,"ComeBackSignIn",function(Obj, Count, ReddotType, Name)
        ReturnUtils.RefreshItemReddot(self, 1, Count)
    end)
    ReturnUtils.ReturnAddReddotListener(self,"ComeBackTask",function(Obj, Count, ReddotType, Name)
        ReturnUtils.RefreshItemReddot(self, 2, Count)
    end)
    ReturnUtils.ReturnAddReddotListener(self,"ComeBackReward",function(Obj, Count, ReddotType, Name)
        ReturnUtils.RefreshItemReddot(self, 4, Count)
    end)
    
end

function M:InitTabItems()
    local TabTitleList = {
        GText("UI_CombackEvent_EventLoginTitle"),
        GText("UI_CombackEvent_EventQuestTitle"),
        GText("UI_ComebackEvent_InviteWebJumpTitle"),
    }
    for i = 1, 3 do
        local TabItem = self["Tab_" .. i]
        if TabItem then
            TabItem.Text_TabTitle:SetText(TabTitleList[i])
            TabItem.Btn_Click.OnClicked:Add(self, function()
                if TabItem:IsAnimationPlaying(TabItem.Click) then
                    return
                end
                TabItem:StopAllAnimations()
                if TabItem == self.CurSubTab and UIUtils.IsGamepadInput() then
                    if self.OnSubTabNavigationRight then
                        self:OnSubTabNavigationRight()
                    end
                else
                    self:OnTabItemClicked(i)
                end
            end)
            TabItem.Btn_Click.OnPressed:Add(self, function()
                --TabItem:PlayAnimation(TabItem.Press)
            end)
            TabItem.Btn_Click.OnHovered:Add(self, function()
                if TabItem == self.CurSubTab then
                    return
                end
                TabItem:StopAnimation(TabItem.UnHover)
                TabItem:PlayAnimation(TabItem.Hover)
                if UIUtils.IsGamepadInput() then
                    TabItem:StopAllAnimations()
                    self:OnTabItemClicked(i)
                end
            end)
            TabItem.Btn_Click.OnUnHovered:Add(self, function()
                if TabItem == self.CurSubTab then
                    return
                end
                TabItem:StopAnimation(TabItem.Hover)
                TabItem:PlayAnimation(TabItem.UnHover)
            end)
        end
    end

    if ReturnUtils.CanParticipateInvite() then
        self.Tab_3:SetVisibility(UIConst.VisibilityOp["VisibilityOp"])
    else
        self.Tab_3:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:InitTimeInfo()
    local EventTabConfigData = DataMgr.EventTab[self.ParentTabId]
    if not EventTabConfigData or not EventTabConfigData.EventId then return end
    local ActivityConfigData = DataMgr.EventMain[EventTabConfigData.EventId[1]]
    if not ActivityConfigData then return end
    self.ActivityEndTime = ActivityConfigData.EventEndTime
    self.RewardEndTime = ActivityConfigData.RewardEndTime
    local Avatar = GWorld:GetAvatar()
    if self.ComTime and Avatar then
        local bCheckNextDayFiveStamp = false
        ActivityUtils.RefreshLeftTime(self, self.ComTime, bCheckNextDayFiveStamp, Avatar.ComeBackExpireTime)
        self:AddTimer(1.0, ActivityUtils.RefreshLeftTime, true, 0, "RefreshLeftTime", true, self.ComTime, bCheckNextDayFiveStamp, Avatar.ComeBackExpireTime)
    else
        ActivityUtils.SetLeftTimeView(self.ComTime, true)
    end
end

function M:PlayInAnimation()
    self:BindToAnimationFinished(self.In, {self, function()
        --self:SetFocus()
        self:BlockAllUIInput(false)
        self:UnbindAllFromAnimationFinished(self.In)
    end})
    self:StopAllAnimations()
    self:PlayAnimation(self.In)
end

local ChildWidgetPaths = {
    '/Game/UI/WBP/Activity/Widget/Return/WBP_Activity_Return_SevenDay.WBP_Activity_Return_SevenDay',
    {
        '/Game/UI/WBP/Activity/PC/Return/WBP_Activity_Return_Task_P.WBP_Activity_Return_Task_P',
        '/Game/UI/WBP/Activity/Mobile/Return/WBP_Activity_Return_Task_M.WBP_Activity_Return_Task_M',
    },
    '/Game/UI/WBP/Activity/Widget/Return/WBP_Activity_Return_InviteCode.WBP_Activity_Return_InviteCode',
}
function M:OnTabItemClicked(Index)
    if Index == self.CurIndex then return end
    for i = 1, 3 do
        local TabItem = self["Tab_" .. i]
        if TabItem and Index == i then
            TabItem:StopAnimation(TabItem.Normal)
            TabItem:PlayAnimation(TabItem.Click)
            self:AddTimer(0.1, function()
                TabItem:SetFocus()
            end, false, 0, "SetFocus", true)
            self.CurSubTab = TabItem
        elseif TabItem then
            TabItem:StopAnimation(TabItem.Click)
            TabItem:PlayAnimation(TabItem.Normal)
        end
    end
    self.CurIndex = Index
    local bMobile = UIUtils.IsMobileInput()
    local TargetPath = Index == 2 and ChildWidgetPaths[Index][bMobile and 2 or 1] or ChildWidgetPaths[Index]
    self.CurChildWidget = nil
    UIManager(self):CreateWidgetAsync(nil, function(Widget)
        if not Widget then return end
        self.CurChildWidget = Widget
        self.CurChildWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Group_Anchor:ClearChildren()
        local OverlaySlot = self.Group_Anchor:AddChildToOverlay(self.CurChildWidget)
        OverlaySlot:SetPadding(FMargin(0,0,0,0))
        OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
        OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
        if self.CurChildWidget.Init then
            local InitParams = {OwnerPanel = self}
            InitParams.CurActivityId = self.CurActivityId
            if Index == 1 then
                InitParams.PageConfigData = DataMgr.ComeBackLogin[self.EventSchemeData.EventLoginId]
                InitParams.PageConfigData = setmetatable({}, {__index = InitParams.PageConfigData})
                InitParams.PageConfigData.EventId = self.CurrentEventId
                InitParams.PageConfigData.EventReward = InitParams.PageConfigData.LoginReward
            else
            end
            self.CurChildWidget:Init(InitParams)
        end
    end, TargetPath)
    AudioManager(self):PlayUISound(self, "event:/ui/activity/feina_chapter_select_btn_click", nil, nil)
end

function M:UpdateParentActivityKeyTips()
    
end

function M:CloseSelf()
    self:StopAllAnimations()
    self:PlayAnimation(self.Out)
    self:BindToAnimationFinished(self.Out, {self, function()
        self:UnbindAllFromAnimationFinished(self.Out)
        self:Close()
        EventManager:FireEvent(EventID.OnReturnToActivityEntry)
    end})
    AudioManager(self):SetEventSoundParam(self, "OpenReturnMain", {ToEnd = 1})
end

function M:Close()
    ReturnUtils.ReturnRemoveReddotListener(self,"ComeBackSignIn")
    ReturnUtils.ReturnRemoveReddotListener(self,"ComeBackTask")
    ReturnUtils.ReturnRemoveReddotListener(self,"ComeBackReward")
    self:UnbindAllFromAnimationFinished(self.In)
    self:UnbindAllFromAnimationFinished(self.Out)
    self:StopAllAnimations()
    self:BlockAllUIInput(false)
    self.ComTab.Pos_DayAndNight:ClearChildren()
    self.ComTab.Pos_DayAndNight:SetVisibility(ESlateVisibility.Collapsed)
    for i = 1, 3 do
        local TabItem = self["Tab_" .. i]
        if TabItem then
            TabItem:PlayAnimation(TabItem.Normal)
        end
    end
    M.Super.Close(self)
end

function M:ReceiveEnterState(StackAction)
    M.Super.ReceiveEnterState(self, StackAction)
    if (StackAction == 1) then
        -- 跳转回来的时候进行一些操作
        self:PlayAnimation(self.Fade_In)
        if IsValid(self.CurChildWidget) and self.CurChildWidget.ReceiveEnterState then
            self.CurChildWidget:ReceiveEnterState()
        end
    end
end


function M:Destruct(...)

end

return M

--
-- DESCRIPTION
-- 累充活动主界面
-- @COMPANY **
-- @AUTHOR ** hy
-- @DATE ${date} ${time}
--
require "UnLua"

local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ActivityCommon = require "BluePrints.UI.WBP.Activity.ActivityCommon"

local M = Class({
    "BluePrints.Common.TimerMgr",
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.DelayFrameComponent"
})

M._components = {
    "BluePrints.UI.WBP.Activity.Widget.TotalRecharge.View.ActivityTotalRechargeView",
}

function M:Initialize(Initializer)
    self.OwnerPlayer = nil               -- 所属的Player
    self.CurActivityId = nil             -- 当前活动的EventId
    self.ParentTabId = nil               -- 父页面上的TabId
    self.ParentWidget = nil              -- 父页面对象
    self.AllSignInfo = {}                -- 所有的签到信息
    
end

function M:OnUpdateSubUIViewStyle(IsUseGamePad, bIsWithButton)
    --bIsWithButton是nil的话，说明是activityEntry传入的设备变化的时机，这时候要清空聚焦的情况
    --因为切换页面样式也用了这个函数，有点混乱，只能这样写了
    if bIsWithButton == nil then
        self.FocusWidgetName = nil
        self.FocusWidgetWidget = nil
    end
    -- 子页面切换输入设备逻辑
    IsUseGamePad = IsUseGamePad and self:IsCanChangeToGamePadViewMode()
    self.GrandPrize:UpdateUIStyleInPlatform(IsUseGamePad)

    if (bIsWithButton) then
        if (IsUseGamePad) then
            self.Btn_Confirm:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        else
            self.Btn_Confirm:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
            self.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    end

    if (IsUseGamePad) then
        self.WS_Btn:SetActiveWidgetIndex(1)
    else
        self.WS_Btn:SetActiveWidgetIndex(0)
    end
end

function M:OnRechargeFinished(Result, GoodsId, ShopItems)
    if Result == ErrorCode.RET_SUCCESS then
        if DataMgr.PayGoods[GoodsId] then
            local ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
            self.ActivityEndTime = ActivityConfigData.EventEndTime and ActivityConfigData.EventEndTime or ActivityConfigData.PermanenEventTime
            self.RewardEndTime = ActivityConfigData.RewardEndTime
            local PageConfigData = DataMgr.CumulativeTopUpEvent[self.CurActivityId]
            -- 刷新静态UI信息
            self:RefreshPageStaticView(ActivityConfigData, PageConfigData, self.ViewInfoBtnClick, self.JumpBtnClick, self.ClaimAllBtnClick)
            -- 刷新动态UI信息
            self:RefreshPageDynamicView(PageConfigData, self.AllSignInfo)
            -- 刷新剩余时间
            self:InitTimeInfo()
            self:InitNavigation()
        end
    end
end

function M:GetPageName()
    return DataMgr.EventTab[self.ParentTabId].EventTabName
end

function M:GetActivityId()
    return self.CurActivityId
end

function M:GetParentTabId()
    return self.ParentTabId
end

function M:ResetVariable()
    -- 重置一些变量
    self.FocusWidgetName = nil
end

function M:InitPage(ActivityId, ParentTabId, AllActivityId, ParentWidget)
    -- 初始化当前页面的信息
    self.CurActivityId = ActivityId
    self.ParentTabId = ParentTabId
    self.ParentWidget = ParentWidget

    local PlayerAvatar = GWorld:GetAvatar()
    if PlayerAvatar == nil then return end

    local ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
    self.ActivityEndTime = ActivityConfigData.EventEndTime and ActivityConfigData.EventEndTime or ActivityConfigData.PermanenEventTime
    self.RewardEndTime = ActivityConfigData.RewardEndTime
    local PageConfigData = DataMgr.CumulativeTopUpEvent[self.CurActivityId]

    -- 刷新静态UI信息
    self:RefreshPageStaticView(ActivityConfigData, PageConfigData, self.ViewInfoBtnClick, self.JumpBtnClick, self.ClaimAllBtnClick)
    -- 刷新动态UI信息
    self:RefreshPageDynamicView(PageConfigData, self.AllSignInfo)

    -- 刷新剩余时间
    self:InitTimeInfo()

    self:InitNavigation()
end

function M:InitTimeInfo()
    if (self.ActivityEndTime ~= nil or self.RewardEndTime ~= nil) and self.Activity_Time then
        local bCheckNextDayFiveStamp = true
        ActivityUtils.RefreshLeftTime(self, self.Activity_Time, bCheckNextDayFiveStamp)
        self:AddTimer(1.0, ActivityUtils.RefreshLeftTime, true, 0, "RefreshLeftTime", true, self.Activity_Time, bCheckNextDayFiveStamp)
    else
        ActivityUtils.SetLeftTimeView(self.Activity_Time, true)
    end
end

function M:UpdatePage(OperateSrc)
    local IsReBindClickFunction = false
    local IsRefreshCacheServerData = OperateSrc == ActivityCommon.AllUpdateTag.ActivityTab

    -- local DailyLoginConfigData = DataMgr.DailyLogin[self.CurActivityId]
    -- if (IsRefreshCacheServerData) then
    --     local PlayerAvatar = GWorld:GetAvatar()
    --     local DailyLoginServerData = PlayerAvatar.DailyLogin[self.CurActivityId]
    --     if DailyLoginServerData ~= nil then
    --         for idx = 1, DailyLoginConfigData.LoginDuration, 1 do
    --             self.AllSignInfo[idx] = ActivityUtils.GetCurSignRewardState(idx, DailyLoginServerData)
    --         end
    --     end
    -- end
    -- 重新绑定按钮事件
    -- if (IsReBindClickFunction) then
    --     self:BindAllClickFunction(self.JumpBtnClick, self.ClaimAllBtnClick)
    -- end

    self:ResetVariable()
    self:RefreshPageDynamicView()
end

function M:InitNavigation()
    self.List_Reward:SetNavigationRuleCustom(EUINavigation.Right, {self, function()
        return self.Reward_Btn
    end})
    self.Reward_Btn:SetNavigationRuleCustom(EUINavigation.Left, {self, function()
        return self.List_Reward
    end})
end

function M:GetPageConfigData()
    return DataMgr.CumulativeTopUpEvent[self.CurActivityId]
end

function M:CleanSelf(bIsRemoveSelf)
    self:RemoveTimer("RefreshLeftTime")
    if (bIsRemoveSelf) then
        self:RemoveFromParent()
    end
end

function M:GetCurFocusWidgetInfo()
    return self.FocusWidgetName, self.FocusWidgetWidget
end

function M:IsCanChangeToGamePadViewMode()
    -- 判断是否可以切换到手柄端
    return self.FocusWidgetName ~= "CheckRewardDetailView"-- and self.FocusWidgetName ~= "SelectView"
end

function M:EnterStuffViewMode()
    local Index = self:GetPriorityFocusIndex() or 1
    if Index < #self.SortedPoints - 1 then
        self.List_Reward:NavigateToIndex(Index - 1)
        local NewFocusItem=self.List_Reward:GetItemAt(Index - 1)
        self.List_Reward:SetSelectedIndex(Index - 1)
        self:AddTimer(0.01, function()
            self.List_Reward:SetFocus()
            self.FocusWidgetWidget = self.List_Reward
        end)
        if (self.ParentWidget) then
            self.ParentWidget:UpdateActivityKeyTips("CheckRewardDetailView", self.List_Reward)
        end
    else
        self.List_Reward:SetSelectedIndex(Index - 2)
        self.Reward_Btn:SetFocus()
        self.FocusWidgetWidget = self.Reward_Btn
        if (self.ParentWidget) then
            self.ParentWidget:UpdateActivityKeyTips("CheckRewardDetailView", self.Reward_Btn)
        end
    end
    self.FocusWidgetName = "CheckRewardDetailView"

    -- 切换回PC样式
    self:OnUpdateSubUIViewStyle(false, true)
    self.IsInStuffViewMode = true
    return true
end

function M:LeaveStuffViewMode()
    if (self.FocusWidgetName == nil) then
        return false
    end
    self.FocusWidgetName = nil
    self.FocusWidgetWidget = nil
    if (self.ParentWidget) then
        self.ParentWidget:UpdateActivityKeyTips("CheckRewardView", nil)
        self.ParentWidget:SetFocus()
    end
    
    -- 切换回手柄样式
    self:OnUpdateSubUIViewStyle(true, true)
    self.IsInStuffViewMode = false
    return true
end

function M:UpdateParentActivityKeyTips(FocusWidgetName, FocusWidgetWidget, bIsFocusToParent)
    self.FocusWidgetName = FocusWidgetName
    self.FocusWidgetWidget = FocusWidgetWidget
    if (self.ParentWidget) then
        self.ParentWidget:UpdateActivityKeyTips(FocusWidgetName, FocusWidgetWidget)
        if (bIsFocusToParent) then
            self.ParentWidget:SetFocus()
        end
    end
end

function M:GetDefaultBottomTips()
    local ResultKeyInfo = {
        {
            KeyInfoList = { { Type = "Img", ImgShortPath = "LS" } },
            Desc = GText("UI_Controller_CheckReward")
        },
        {
            KeyInfoList = { { Type = "Img", ImgShortPath = "B", ClickCallback=self.OnReturnKeyDown, Owner=self} },
            Desc = GText("UI_Tips_Close")
        },
    }
    return ResultKeyInfo
end

---------------------------------各种点击事件相关----------------------------------
function M:ViewInfoBtnClick()
    local Params = {}
    Params.Parent = self
    local Tabs = {}
    Tabs[1] = {
        Text = GText("UI_Event_CumulativeTopUpEvent_RuleDesTab"),
        TabId = 1,
    }
    Tabs[2] = {
        Text = GText("UI_Event_CumulativeTopUpEvent_CreditHistoryTab"),
        TabId = 2,
    }
    Params.TabConfigData  = {
        PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self),
        LeftKey = "A",
        RightKey = "D",
        Tabs = Tabs,
        SoundFunc = function ()
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil)
        end
    }
    Params.EventId = self.CurActivityId
    self.DetailPopupUI = UIManager(self):ShowCommonPopupUI(100306, Params, self)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
end

function M:JumpBtnClick()
    -- AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
    local PageConfigData = DataMgr.CumulativeTopUpEvent[self.CurActivityId]
    PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.JumpId)
end

function M:ClaimAllBtnClick()
    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar then
        return
    end

    PlayerAvatar:GetCumulativeRechargeReward(function(Ret, Rewards)
        if not ErrorCode:Check(Ret) then
            return
        end
        UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, Rewards.IsSpPopup)
        self:RefreshPageDynamicView()
        ActivityUtils.TrySubActivityReddotCommon("Red", self.CurActivityId)
    end, self.CurActivityId, 0)
end

---------------------------------各种输入事件相关----------------------------------
function M:HandlePreviewKeyDownInPage(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "SpaceBar" then
        self:ClaimAllBtnClick()
        IsEventHandled = true
    else
        IsEventHandled = false
    end
    return IsEventHandled
end

function M:HandleKeyDownInPage(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadButtonDown(InKeyName)
    else
        IsEventHandled = false
    end
    return IsEventHandled
end

function M:OnGamePadButtonDown(InKeyName)
    local IsEventHandled = self:Handle_KeyDownOnGamePad(InKeyName)
    return IsEventHandled
end

function M:Handle_KeyDownOnGamePad(InKeyName)
    -- 处理手柄相关的交互事件
    local IsEventHandled = false
    if (InKeyName == UIConst.GamePadKey.LeftThumb) then
        -- 左摇杆按下
        IsEventHandled = self:EnterStuffViewMode()
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonRight) then
        -- 按下返回按钮
        IsEventHandled = self:LeaveStuffViewMode()
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonTop) then
        -- 按下Y按钮
        if self.CanClaim and self.FocusWidgetName ~= "CheckRewardDetailView" then
            self:ClaimAllBtnClick()
            IsEventHandled = true
        end
    elseif (InKeyName == UIConst.GamePadKey.SpecialLeft) then
        if self.FocusWidgetName ~= "CheckRewardDetailView" then
            self:ViewInfoBtnClick()
        end
    elseif (InKeyName == UIConst.GamePadKey.SpecialRight) then
        if self.FocusWidgetName ~= "CheckRewardDetailView" then
            self.GrandPrize:OnBtnClicked()
        end
    end
    return IsEventHandled
end

-- function M:OnSubTabNavigationRight()
--     self:EnterRewardViewMode()
-- end

AssembleComponents(M)
return M

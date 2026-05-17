--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local ActivityUtils = require "BluePrints.UI.WBP.Activity.ActivityUtils"
local ActivityCommon = require "BluePrints.UI.WBP.Activity.ActivityCommon"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"
local EMCache = require "EMCache.EMCache"

---@type WBP_Activity_OnlineTime_P_C
local M = Class({
    "BluePrints.Common.TimerMgr",
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.DelayFrameComponent",
})

M._components = {
    "BluePrints.UI.WBP.Activity.Widget.View.ActivityAccumulateView",
}

---仅初始化lua变量时使用，千万不要有控件操作！！
function M:Initialize(Initializer)
    self.EventId = nil           -- 活动Id
    self.ParentTabId = nil          -- 父页面TabId
    self.ParentWidget = nil         -- 父页面对象
    self.QuestPhaseId = nil         -- 阶段Id
    self.Progress = 0             -- 当前进度
    self.RewardList = {}
    self.FocusWidgetName = nil      -- 当前聚焦的控件名称
    self.FocusWidgetWidget = nil    -- 当前聚焦的控件对象
end


function M:InitPage(EventId, ParentTabId, AllActivityId, ParentWidget)
    self.EventId = EventId
    self.CurActivityId = EventId
    self.ParentTabId = ParentTabId
    self.ParentWidget = ParentWidget
    self.QuestPhaseId = DataMgr.AccumulateTargetEvent[self.EventId].QuestPhaseId
    self.Btn_Reward.Button_Area.OnClicked:Clear()
    self.Btn_Reward.Button_Area.OnClicked:Add(self, self.GetAllReward)
    self.Btn_Goto:SetVisibility(UE4.ESlateVisibility.Visible)
    self.Btn_Goto.Button_Area.OnClicked:Clear()
    self.Btn_Goto.Button_Area.OnClicked:Add(self, self.GotoClick)
    self.Btn_Reward:SetGamePadIconVisible(true)

    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local CommonQuestDetail = DataMgr.CommonQuestDetail
    local SPTarget, SPQuestId = 0, 0
    for i, v in pairs(CommonQuestDetail) do
        if v.EventId == self.EventId and v.QuestPhaseId == self.QuestPhaseId then
            if v.Target > SPTarget then
                SPTarget = v.Target
                SPQuestId = i
            end
        end
    end
    self.Progress = Avatar.CommonQuestActivity[self.EventId][SPQuestId].Progress

    self:InitUIInfo()
    self:InitRewards()
    self:RefreshNavigation()
end

function M:GetPageConfigData()
    return DataMgr.AccumulateTargetEvent[self.EventId]
end

function M:UpdatePage(OperateSrc)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local CommonQuestDetail = DataMgr.CommonQuestDetail
    local SPTarget, SPQuestId = 0, 0
    for i, v in pairs(CommonQuestDetail) do
        if v.EventId == self.EventId and v.QuestPhaseId == self.QuestPhaseId then
            if v.Target > SPTarget then
                SPTarget = v.Target
                SPQuestId = i
            end
        end
    end
    self.Progress = Avatar.CommonQuestActivity[self.EventId][SPQuestId].Progress

    self:InitUIInfo()
    self:InitRewards()
    self:RefreshNavigation()
    ActivityReddotHelper.RefreshReddotNode(self.EventId)
end

function M:GetCurFocusWidgetInfo()
    return self.FocusWidgetName, self.FocusWidgetWidget
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
    if (bIsWithButton) then
        if (IsUseGamePad) then
            self.Btn_Goto:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        else
            self.Btn_Goto:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
            -- self.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    end
end

function M:IsCanChangeToGamePadViewMode()
    -- 判断是否可以切换到手柄端
    return self.FocusWidgetName ~= "CheckRewardDetailView"-- and self.FocusWidgetName ~= "SelectView"
end

function M:EnterStuffViewMode()
    -- self.List_Reward:SetFocus()
    self:AddDelayFrameFunc(function()
        self.List_Reward:SetFocus()
    end, 1)
    self.FocusWidgetName = "CheckRewardDetailView"
    self.FocusWidgetWidget = self.List_Reward
    if (self.ParentWidget) then
        self.ParentWidget:UpdateActivityKeyTips("CheckRewardDetailView", self.List_Reward)
    end
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
    self:OnUpdateSubUIViewStyle(true, true)
    self.IsInStuffViewMode = false
    return true
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
        local Visbility = self.Btn_Reward:GetVisibility()
        if Visbility == UE4.ESlateVisibility.Visible then
            IsEventHandled = self:GetAllReward()
        else
            IsEventHandled = false
        end
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonBottom) then
        -- 按下A按钮
        local Visbility = self.Btn_Goto:GetVisibility()
        if Visbility == UE4.ESlateVisibility.Visible then
            IsEventHandled = self:GotoClick()
        else
            IsEventHandled = false
        end
    end
    return IsEventHandled
end

function M:ItemMenuAnchorChanged(IsOpen)
    -- 处理一下手柄
end

function M:RefreshNavigation()
    self.List_Reward:SetNavigationRuleCustom(EUINavigation.Right, {self, function()
        return self.Reward_Sp
    end})
    self.Reward_Sp:SetNavigationRuleCustom(EUINavigation.Left, {self, function()
        return self.List_Reward
    end})
end

AssembleComponents(M)
return M

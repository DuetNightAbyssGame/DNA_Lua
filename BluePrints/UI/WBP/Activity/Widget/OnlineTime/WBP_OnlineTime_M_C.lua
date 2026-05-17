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
    ActivityReddotHelper.RefreshReddotNode(self.EventId)
end

function M:GetCurFocusWidgetInfo()
    return self.FocusWidgetName, self.FocusWidgetWidget
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
        self.ParentWidget:UpdateActivityKeyTips()
        self.ParentWidget:SetFocus()
    end
    -- 切换回手柄样式
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

function M:Handle_KeyDownOnGamePad(InKeyName)
    -- 处理手柄相关的交互事件
    local IsEventHandled = false
    if (InKeyName == UIConst.GamePadKey.LeftThumb) then
        -- 左摇杆按下
        IsEventHandled = self:EnterStuffViewMode()
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonRight) then
        -- 按下返回按钮
        IsEventHandled = self:LeaveStuffViewMode()
    end
    return IsEventHandled
end

function M:ItemMenuAnchorChanged(IsOpen)
    -- 处理一下手柄
end

AssembleComponents(M)
return M

--
-- DESCRIPTION
-- 跳转活动通用逻辑 （PC、移动端公用）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ReturnUtils = require "Blueprints.UI.WBP.Activity.Widget.Return.ReturnUtils"
local ReturnActivityController = require "BluePrints.UI.WBP.Activity.Widget.Return.ReturnActivityController"

local M = Class()

function M:GetPageName()
    return DataMgr.EventTab[self.ParentTabId].EventTabName
end

function M:GetActivityId()
    return self.CurActivityId
end

function M:GetParentTabId()
    return self.ParentTabId
end

function M:GetPageConfigData()
    return {}
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

    local ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
    self:InitReddot()
    -- 刷新静态UI信息
    self:RefreshPageStaticView(ActivityConfigData)
    -- 刷新动态UI信息
    self:RefreshPageDynamicView()

    -- 刷新剩余时间
    self:InitTimeInfo(ActivityConfigData)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    self:AddTimer(0.05,function()
        self:OnUserScrolled()
    end, false, 0, "RefreshScrollBoxArrow", true)
    local BackRewardGot = Avatar.ComeBacks[self.CurActivityId] and Avatar.ComeBacks[self.CurActivityId].BackRewardGot or nil
    local Params = {
        ClickCallback = self.OnBtnRewardClick,
        ClickCallbackObj = self,
        HasGetCurrentReward = BackRewardGot == 1,
    }
    self.Return_Reward:Init(Params)
    
    if ReturnActivityController.bRequestRewardOnInitPage and Avatar.ComeBacks[self.CurActivityId] and BackRewardGot == 0 then
        Avatar:ComeBackGetBackReward(function(ErrCode,Ret)
            self:OnComeBackGetBackReward(ErrCode,Ret)
        end, self)
        ReturnActivityController.bRequestRewardOnInitPage = false
    end
end

function M:InitReddot()
    ReturnUtils.ReturnAddReddotListener(self,"ComeBackSignIn",function(Obj, Count, ReddotType, Name)
        ReturnUtils.RefreshItemReddot(self, 3, Count)
    end)
    ReturnUtils.ReturnAddReddotListener(self,"ComeBackTask",function(Obj, Count, ReddotType, Name)
        ReturnUtils.RefreshItemReddot(self, 2, Count)
    end)
    ReturnUtils.ReturnAddReddotListener(self,"ComeBackReward",function(Obj, Count, ReddotType, Name)
        ReturnUtils.RefreshItemReddot(self, 4, Count)
    end)
    local SevenDayRewardValidIndex = ReturnUtils.GetSevenDayRewardValidIndex()
    local SignNode = ReddotManager.GetTreeNode("ComeBackSignIn")
    if SevenDayRewardValidIndex and next(SevenDayRewardValidIndex) then
        local CurCount = SignNode and SignNode.Count or 0
        if CurCount == 0 then
            ReddotManager.IncreaseLeafNodeCount("ComeBackSignIn", 1)
        elseif CurCount > 1 then
            ReddotManager.DecreaseLeafNodeCount("ComeBackSignIn", CurCount - 1)
        end
    else
        local CurCount = SignNode and SignNode.Count or 0
        if CurCount > 0 then
            ReddotManager.DecreaseLeafNodeCount("ComeBackSignIn", CurCount)
        end
    end
    ReturnUtils.RefreshComeBackTaskQuestReddot()
    local Avatar = GWorld:GetAvatar()
    local BackRewardGot = Avatar.ComeBacks[self.CurActivityId] and Avatar.ComeBacks[self.CurActivityId].BackRewardGot or nil
    if BackRewardGot and BackRewardGot == 0 then
        ReddotManager.IncreaseLeafNodeCount("ComeBackReward", 1)
    else
        local ComeBackRewardNode = ReddotManager.GetTreeNode("ComeBackReward")
        if ComeBackRewardNode and ComeBackRewardNode.Count > 0 then
            ReddotManager.DecreaseLeafNodeCount("ComeBackReward", ComeBackRewardNode.Count)
        end
    end
end

function M:UpdatePage(OperateSrc)
    -- 刷新动态UI信息
    self:RefreshPageDynamicView()
end

function M:RefreshPageStaticView(ActivityConfigData)
    -- 刷新静态UI信息
    self.WBP_Activity_Return_Title.Text_Title:SetText(GText(ActivityConfigData.EventName))
    self.WBP_Activity_Return_Title.Text_SubTitle:SetText(GText(ActivityConfigData.EventSName))
    self.Text_ActivityDesc:SetText(GText(ActivityConfigData.EventDes))
    self.Text_ActivityDesc_White:SetText(GText(ActivityConfigData.EventDes))
    if (ActivityConfigData.EventRule) then
        self.Text_ActivityDescTitle:SetText(GText("UI_Common_Rule"))
        self.Com_BtnExplanation:SetVisibility(UIConst.VisibilityOp["VisibilityOp"])
        self.Group_ActivityQa:SetVisibility(UIConst.VisibilityOp["VisibilityOp"])
    else
        self.Com_BtnExplanation:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Group_ActivityQa:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end

    self:BindAllClickFunction()
    if self.EntryItem_1 then
        self.EntryItem_1.Text_TitleEntry:SetText(GText("UI_ComebackEvent_InviteWebJump"))
        if ReturnUtils.CanParticipateInvite() then
            self.EntryItem_1:SetVisibility(UIConst.VisibilityOp["VisibilityOp"])
        else
            self.EntryItem_1:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    end
    if self.EntryItem_2 then
        self.EntryItem_2.Text_TitleEntry:SetText(GText("UI_CombackEvent_EventQuest"))
    end
    if self.EntryItem_3 then
        self.EntryItem_3.Text_TitleEntry:SetText(GText("UI_CombackEvent_EventLogin"))
    end
end

function M:RefreshPageDynamicView()
    -- 刷新动态UI信息
    self:RefreshEntryItemReddot(3,ReddotManager.GetTreeNode("ComeBackSignIn").Count)
    self:RefreshEntryItemReddot(2,ReddotManager.GetTreeNode("ComeBackTask").Count)
end

function M:RefreshEntryItemReddot(Index, ReddotCount)
    if not self or not IsValid(self) then return end
    local TargetEntry = self["EntryItem_"..Index]
    if not TargetEntry then return end
    local TargetReddot = TargetEntry.Reddot
    if ReddotCount > 0 then
        TargetReddot:SetVisibility(UIConst.VisibilityOp["VisibilityOp"])
    else
        TargetReddot:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end


function M:BindAllClickFunction()
    if self.EntryItem_1 then
        self.EntryItem_1.Btn_Click.OnClicked:Add(self, function()
            self:OnEntryItemClicked(1)
        end)
    end
    if self.EntryItem_2 then
        self.EntryItem_2.Btn_Click.OnClicked:Add(self, function()
            self:OnEntryItemClicked(2)
        end)
    end
    if self.EntryItem_3 then
        self.EntryItem_3.Btn_Click.OnClicked:Add(self, function()
            self:OnEntryItemClicked(3)
        end)
    end
    local BtnExplanationConfigData = {}
    BtnExplanationConfigData.ClickCallback = self.OnBtnExplanationClick
    BtnExplanationConfigData.OwnerWidget = self
    BtnExplanationConfigData.Desc = "UI_Common_Rule"
    BtnExplanationConfigData.SoundFunc = function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    end
    self.Com_BtnExplanation:Init(BtnExplanationConfigData)
end

function M:OnUserScrolled()
    UIUtils.UpdateScrollBoxArrow(self.ScrollBox_Desc, self.List_ArrowTop, self.List_ArrowBottom)
end

function M:CleanSelf(bIsRemoveSelf)
    ReturnUtils.ReturnRemoveReddotListener(self,"ComeBackSignIn")
    ReturnUtils.ReturnRemoveReddotListener(self,"ComeBackTask")
    ReturnUtils.ReturnRemoveReddotListener(self,"ComeBackReward")
    self:RemoveTimer("RefreshLeftTime")
    if (bIsRemoveSelf) then
        self:RemoveFromParent() 
    end
end

function M:InitTimeInfo(ActivityConfigData)
    if not ActivityConfigData then return end
    self.ActivityEndTime = ActivityConfigData.EventEndTime and ActivityConfigData.EventEndTime or ActivityConfigData.PermanenEventTime
    self.RewardEndTime = ActivityConfigData.RewardEndTime
    local Avatar = GWorld:GetAvatar()
    if Avatar and self.Activity_Time then
        local bCheckNextDayFiveStamp = false
        ActivityUtils.RefreshLeftTime(self, self.Activity_Time, bCheckNextDayFiveStamp, Avatar.ComeBackExpireTime)
        self:AddTimer(1.0, ActivityUtils.RefreshLeftTime, true, 0, "RefreshLeftTime", true, self.Activity_Time, bCheckNextDayFiveStamp, Avatar.ComeBackExpireTime)
    else
        ActivityUtils.SetLeftTimeView(self.Activity_Time, true)
    end
end

function M:PlayFadeIn()
    -- 播放入场动画
    self:PlayAnimation(self.In)
    -- 播放标题动画
    local TitleWidget = self.Group_TitleAnchor:GetChildAt(0)
    if (TitleWidget.In ~= nil) then
        TitleWidget:PlayAnimationForward(TitleWidget.In)
    end
end

function M:PlayFadeOut(IsRemoveFromParent)
    -- 播放退场动画
    self:PlayAnimation(self.Out)
    if (IsRemoveFromParent) then
        self:BindToAnimationFinished(self.Out, {self, function()
            self:CleanSelf(true)
        end})
    end
end

function M:HidePage(IsNeedPlayOutAnim)
    if (IsNeedPlayOutAnim) then
        self:PlayFadeOut()
    end
    self:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:ShowPage(IsNeedPlayInAnim)
    if (IsNeedPlayInAnim) then
        self:PlayFadeIn()
    end
    self:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
end

---------------------------------各种点击事件相关----------------------------------
function M:OnEntryItemClicked(Index)
    if Index == 1 then          -- 回归邀请
        local CurrentEventSchemeId = DataMgr.ComeBackEventConstant.CurrentEventSchemeId.ConstantValue
        if not ReturnUtils.CanParticipateInvite(CurrentEventSchemeId) then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("暂未开放(未配Textmap)"))
            return
        end
    elseif Index == 2 then      -- 回归任务
        
    elseif Index == 3 then      -- 回归七日签到
        
    end
    UIManager(self):LoadUINew("ActivityReturnMain", self.ParentTabId, 4 - Index, function()
        DebugPrint("lgc@OnEntryItemClicked Load Async Success, Index = " .. Index)
    end, "Async")
    AudioManager(self):PlayUISound(self, "event:/ui/activity/feina_chapter_select_btn_click", nil, nil)
end

function M:OnBtnExplanationClick()
    local ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
    if (not ActivityConfigData.EventRule) then
        DebugPrint("ViewInfoBtn Click, EventRule is nil, EventId is", self.CurActivityId)
        return
    end
    local Params = {
        LongText = GText(ActivityConfigData.EventRule),
        ShowBKeyClose = true,
    }
    UIManager(self):ShowCommonPopupUI(100192, Params, self)
end

function M:OnBtnRewardClick()
    DebugPrint("lgc@ActivityReturnBase OnBtnRewardClick")
    local Avatar = GWorld:GetAvatar()
    local BackRewardGot = Avatar.ComeBacks[self.CurActivityId] and Avatar.ComeBacks[self.CurActivityId].BackRewardGot or 0
    if Avatar and BackRewardGot == 0 then
        Avatar:ComeBackGetBackReward(function(ErrCode,Ret)
            self:OnComeBackGetBackReward(ErrCode,Ret)
        end, self)
    else
        local CurrentEventSchemeId = DataMgr.ComeBackEventConstant.CurrentEventSchemeId.ConstantValue
        assert(CurrentEventSchemeId, "lgc@CurrentEventSchemeId is nil, 需要策划检查下ComeBackEventConstant表中的CurrentEventSchemeId")
        local CurrentEventSchemeData = DataMgr.ComeBackEvent[CurrentEventSchemeId]
        if not CurrentEventSchemeData then return end
        local EventOneTimeReward = CurrentEventSchemeData.EventOneTimeReward
        if not EventOneTimeReward then return end
        local Params = {
            ActivityId = self.CurActivityId,
            EventOneTimeReward = EventOneTimeReward,
        }
        UIManager(self):ShowCommonPopupUI(100303, Params, self)
    end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/feina_tab_btn_click", nil, nil)
end

function M:OnComeBackGetBackReward(ErrCode,Ret)
    if ErrCode ~= ErrorCode.RET_SUCCESS then
        return
    end
    local CbAvatar = GWorld:GetAvatar()
    local BackRewardGot = CbAvatar and CbAvatar.ComeBacks[self.CurActivityId] and CbAvatar.ComeBacks[self.CurActivityId].BackRewardGot or 0
    if CbAvatar and CbAvatar.ComeBacks[self.CurActivityId] and BackRewardGot == 1 then
        local CurrentEventSchemeId = DataMgr.ComeBackEventConstant.CurrentEventSchemeId.ConstantValue
        local CurrentEventSchemeData = DataMgr.ComeBackEvent[CurrentEventSchemeId]
        if not CurrentEventSchemeData then return end
        local EventOneTimeReward = CurrentEventSchemeData.EventOneTimeReward
        if not EventOneTimeReward then return end
        self.Return_Reward:OnRewardReceived(EventOneTimeReward)
    end
end

return M

--
-- DESCRIPTION
-- 新手任务主界面
-- @COMPANY **
-- @AUTHOR ** hy
-- @DATE ${date} ${time}
--
require "UnLua"

local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ActivityCommon = require "BluePrints.UI.WBP.Activity.ActivityCommon"
local EMCache = require "EMCache.EMCache"

local M = Class({
    "BluePrints.Common.TimerMgr",
    "BluePrints.UI.BP_EMUserWidget_C"
})

M._components = {
    "BluePrints.UI.WBP.Activity.Widget.View.ActivityTryOutView",
}

function M:Initialize(Initializer)
    self.OwnerPlayer = nil               -- 所属的Player
    self.CurActivityId = nil             -- 当前活动的EventId
    self.CurSelectIndex = nil            -- 当前选中的活动索引
    self.OriginalActivityId = nil        -- 初始活动索引
    self.CurCharId = nil                 -- 当前的活动角色Id
    self.CurSkinId = nil                 -- 当前的活动皮肤Id
    self.AllActivityIds = nil            -- 当前所有活动Id
    self.ParentTabId = nil               -- 父页面上的TabId
    self.ParentWidget = nil              -- 父页面
    self.FocusWidgetName = nil           -- 当前Focus的Widget对象
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
    self.CurSelectIndex = 1
    self.CurActivityId = self.OriginalActivityId
    self.FocusWidgetName = nil
end

function M:InitPage(ActivityId, ParentTabId, AllActivityId, ParentWidget)
    -- 初始化当前页面的信息
    self.CurSelectIndex = 1
    self.CurActivityId = ActivityId
    self.OriginalActivityId = ActivityId
    self.ParentTabId = ParentTabId
    self.AllActivityIds = AllActivityId
    self.ParentWidget = ParentWidget

    self:UpdateSubPage()
end

function M:UpdateSubPage()
    local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
    -- 如果主页面存了需要自动跳转，就设置一下
    if ActivityMain and ActivityMain.TryOutActivityNeedJumpToTabIndex then
        local TabIndex = ActivityMain.TryOutActivityNeedJumpToTabIndex
        ActivityMain.NeedJumpToActivityId = nil
        ActivityMain.TryOutActivityNeedJumpToTabIndex = nil
        self.CurSelectIndex = TabIndex
    end

    local PlayerAvatar = GWorld:GetAvatar()

    local ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
    self.ActivityEndTime = ActivityConfigData.EventEndTime and ActivityConfigData.EventEndTime or ActivityConfigData.PermanenEventTime
    self.RewardEndTime = ActivityConfigData.RewardEndTime
    local PageConfigData = DataMgr.CharTrialEvent[self.CurActivityId]
    -- 刷新静态UI信息
    self.CurCharId = PageConfigData.CharId
    self.CurSkinId = PageConfigData.SkinId
    self:RefreshPageStaticView(ActivityConfigData, PageConfigData, PlayerAvatar.CharTrial, self.ViewInfoBtnClick, self.GoToGachaClick, self.GoToTargetPageClick,
                                self.TryToGetReward, self.TryToViewCharDetail, self.TryToSelectChar, self.OnStuffDetailOpenChanged)
    -- 刷新动态UI信息
    self:RefreshPageDynamicView(PlayerAvatar.CharTrial[self.CurActivityId])
    -- 刷新剩余时间
    self:InitTimeInfo()
end

function M:InitTimeInfo()
    if (self.ActivityEndTime ~= nil or self.RewardEndTime ~= nil) and self.Activity_Time.Com_Time then
        ActivityUtils.RefreshLeftTime(self, self.Activity_Time.Com_Time)
        self:AddTimer(1.0, ActivityUtils.RefreshLeftTime, true, 0, "RefreshLeftTime", true, self.Activity_Time.Com_Time)
    else
        ActivityUtils.SetLeftTimeView(self.Activity_Time.Com_Time, true)
    end
end

function M:IsCanChangeToGamePadViewMode()
    -- 判断是否可以切换到手柄端
    return self.FocusWidgetName ~= "CheckRewardDetailView"
end

function M:OnUpdateSubUIViewStyle(IsUseGamePad, bIsWithButton)
    IsUseGamePad = IsUseGamePad and self:IsCanChangeToGamePadViewMode()
    -- 子页面切换输入设备逻辑
    if (IsUseGamePad) then
        if (#self.AllActivityIds > 1) then
            self.Key_Left:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Key_Right:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        else
            self.Key_Left:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            self.Key_Right:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
        self.Key_RewardTitle:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.TryOutChar_Title.WS_DetailImg:SetActiveWidgetIndex(1)
        self.TryOutSkin_Title.WS_DetailImg:SetActiveWidgetIndex(1)
        self.Btn_Buy.Key_Shop:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        if self.ActivityTryOutAvatarNeedWidget then
            self.ActivityTryOutAvatarNeedWidget.Key_Click:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
    else
        self.Key_Left:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Key_Right:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Key_RewardTitle:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.TryOutChar_Title.WS_DetailImg:SetActiveWidgetIndex(0)
        self.TryOutSkin_Title.WS_DetailImg:SetActiveWidgetIndex(0)
        self.Btn_Buy.Key_Shop:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        if self.ActivityTryOutAvatarNeedWidget then
            self.ActivityTryOutAvatarNeedWidget.Key_Click:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    end

    if (bIsWithButton) then
        if (IsUseGamePad) then
            self.Btn_Gacha:SetGamepadIconVisibility(true)
            self.Btn_Goto:SetGamepadIconVisibility(true)
            self.Btn_Reward:SetGamePadIconVisible(true)
            if self.ActivityTryOutAvatarNeedWidget then
                self.ActivityTryOutAvatarNeedWidget.Key_Click:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            end
        else
            self.Btn_Gacha:SetGamepadIconVisibility(false)
            self.Btn_Goto:SetGamepadIconVisibility(false)
            self.Btn_Reward:SetGamePadIconVisible(false)
            if self.ActivityTryOutAvatarNeedWidget then
                self.ActivityTryOutAvatarNeedWidget.Key_Click:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            end
        end
    end
end

function M:UpdatePage(OperateSrc)
    local IsReBindClickFunction = false

    -- 重新绑定按钮事件
    if (IsReBindClickFunction) then
        self:BindAllClickFunction(self.ViewInfoBtnClick, self.GoToGachaClick, self.GoToTargetPageClick)
    end

    local PlayerAvatar = GWorld:GetAvatar()
    if (OperateSrc == ActivityCommon.AllUpdateTag.ActivityTab) then
        self:ResetVariable()
    end
    self:UpdateSubPage()
    self:RefreshPageDynamicView(PlayerAvatar.CharTrial[self.CurActivityId])
    if OperateSrc == "ActivityTab" or OperateSrc == "BackToPageWithJump" then
        if self.FocusWidgetWidget == self.Item_1 then
            self.FocusWidgetName = nil
            self:EnterStuffViewMode()
        end
    end
end

function M:GetPageConfigData()
    return DataMgr.CharTrialEvent[self.CurActivityId]
end

function M:RefreshItemStyleByAction(ActionName, ActivityID)
    local PlayerAvatar = GWorld:GetAvatar()

    if (ActionName == "TryOutGetReward") then
        self:RefreshItemStyleView(PlayerAvatar.CharTrial[ActivityID])
    end
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

function M:EnterStuffViewMode()
    if (self.FocusWidgetName == "CheckRewardDetailView") then
        return self:LeaveStuffViewMode()
    end
    self.Item_1:SetFocus()
    self.FocusWidgetName = "CheckRewardDetailView"
    self.FocusWidgetWidget = self.Item_1
    if (self.ParentWidget) then
        self.ParentWidget:UpdateActivityKeyTips("CheckRewardDetailView", self.Item_1)
    end
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
        self.ParentWidget:UpdateActivityKeyTips()
        self.ParentWidget:SetFocus()
    end
    -- 切换回手柄样式
    self:OnUpdateSubUIViewStyle(true, true)
    self.IsInStuffViewMode = false
    return true
end

function M:SelectOtherCharItem(bIsNext)
    local NextChooseIndex = nil
    if (bIsNext) then
        NextChooseIndex = math.min(ActivityCommon.MaxTryOutItemCount, self.CurSelectIndex + 1)
    else
        NextChooseIndex = math.max(0, self.CurSelectIndex - 1)
    end
    local CharItemWidget = self["CharacterItem_"..NextChooseIndex]
    if (CharItemWidget) then
        CharItemWidget:OnBtnStateChange(true)
    end
end

---------------------------------各种点击事件相关----------------------------------
function M:ViewInfoBtnClick()
    local ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
    if (not ActivityConfigData.EventRule) then
        DebugPrint("ViewInfoBtn Click, EventRule is nil, EventId is", self.CurActivityId)
        return
    end
    local Params = {
        ShortText = GText(ActivityConfigData.EventRule)
    }
    UIManager(self):ShowCommonPopupUI(100192, Params, self)
end

function M:GoToTargetPageClick()
    -- 添加弹窗确认
    local Params = {
        RightCallbackFunction = function(Obj, Result, PopUI)
            local PageConfigData = DataMgr.CharTrialEvent[self.CurActivityId]
            local CharTrialId = PageConfigData.CharTrialId
            local TrialDungeonId = DataMgr.CharTrial[CharTrialId].TrialDungeonId
            local PlayerAvatar = GWorld:GetAvatar()
            -- 确认后进入试玩
            PlayerAvatar:EnterCharTrialByEvent(nil, TrialDungeonId, self.CurActivityId)

            local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
            local CurTabIndex = 1
            if ActivityMain then
                CurTabIndex = ActivityMain.CurTabId
            end
            -- 进副本前缓存相关信息，用于退出副本时弹出此界面
            local ExitDungeonInfo = {
                Type = "TryOut",
                CurTabIndex = CurTabIndex,
                ActivityId = self.CurActivityId,
                CurSelectIndex = self.CurSelectIndex,
            }
            GWorld.GameInstance:SetExitDungeonData(ExitDungeonInfo)
        end,
        RightCallbackObj = self
    }
    
    UIManager(self):ShowCommonPopupUI(100214, Params, self)
end

function M:GoToGachaClick()
    if (self.ParentWidget and type(self.ParentWidget.CheckIsInCloseSelfState) == "function") then
        if (self.ParentWidget:CheckIsInCloseSelfState()) then
            DebugPrint("ActivityTryOut=GoToGachaClick, ParentWidget is in close self state, So return")
            return
        end
    end
    if (self.IsInStuffViewMode) then
        return
    end
    local PageConfigData = DataMgr.CharTrialEvent[self.CurActivityId]
    if PageConfigData.GachaTabId then
        PageJumpUtils:JumpToGachaPage(PageConfigData.GachaTabId)
    elseif PageConfigData.InterfaceJumpId then
        PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.InterfaceJumpId)
    end
end

function M:OnStuffDetailOpenChanged(bIsOpen, Stuff)
    if (not self.ParentWidget) then
        return
    end
    if (bIsOpen) then
        self.ParentWidget:UpdateActivityKeyTips("EmptyView", nil, false)
    else
        self.ParentWidget:UpdateActivityKeyTips(self.FocusWidgetName, self.FocusWidgetWidget, false)
    end
end

function M:TryToGetReward()
    local PlayerAvatar = GWorld:GetAvatar()
    if PlayerAvatar == nil then return end
    PlayerAvatar:GetCharTrialReward(ActivityUtils.OnGetTryOutActivityRewardBack, self.CurActivityId)
end

function M:TryToViewCharDetail()
    if (self.IsInStuffViewMode) then
        return
    end
    local PageConfigData = self:GetPageConfigData()
    local CharId = PageConfigData.CharId
    UIManager(self):LoadUINew("ArmoryDetail",{PreviewCharIds = {CharId},
                                                bHideCharAppearance = true,
                                                bHideWeaponAppearance = true,
                                                EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
                                                OnCloseDelegate = nil})
end

function M:TryToSelectChar(NewActivityId, Index, CharId)
    if (self.CurActivityId == NewActivityId) then
        return
    end
    self:CancelCharSelectView()
    self.CurSelectIndex = Index
    self.CurActivityId = NewActivityId
    self.CurCharId = CharId
    self:UnBindAllClickFunction()
    self:UpdateSubPage()
    -- 替换背景
    if (self.ParentWidget) then
        local ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
        self.ParentWidget:RefreshViewAfterPageDataSet(ActivityConfigData, self:GetPageConfigData())
        self.ParentWidget:UpdateTabRedInfoByActivityID(nil, NewActivityId)
    end
end
---------------------------------各种输入事件相关----------------------------------
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
    if (InKeyName == UIConst.GamePadKey.FaceButtonLeft) then
        -- 按下左边X按钮进行跳转抽卡
        IsEventHandled = true
        self:GoToGachaClick()
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonBottom) then
        -- 按下A确认按钮
        IsEventHandled = true
        self:GoToTargetPageClick()
    elseif (InKeyName == UIConst.GamePadKey.LeftThumb) then
        -- 按下左边的摇杆进入奖励选择
        IsEventHandled = self:EnterStuffViewMode()
    elseif (InKeyName == UIConst.GamePadKey.RightThumb) then
        -- 按下右边的摇杆进入奖励选择
        if self.ActivityTryOutAvatarNeedWidget and not self.IsInStuffViewMode then
            self.ActivityTryOutAvatarNeedWidget:OnClick()
            IsEventHandled = true
        end
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonRight) then
        -- 按下返回按钮
        IsEventHandled = self:LeaveStuffViewMode()
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonTop) then
        -- 按下Y领取奖励
        IsEventHandled = true
        self:TryToGetReward()
    elseif (InKeyName == UIConst.GamePadKey.SpecialLeft) then
        -- 查看试玩角色
        if self.CurSkinId then
            self.TryOutSkin_Title:BtnClicked()
            return true
        end
        IsEventHandled = true
        self:TryToViewCharDetail()
    elseif (InKeyName == UIConst.GamePadKey.SpecialRight) then
        -- 查看信息
        IsEventHandled = true
        self:ViewInfoBtnClick()
    elseif (InKeyName == UIConst.GamePadKey.LeftTriggerThreshold) then
        -- 向左切换选中角色
        self:SelectOtherCharItem(false)
    elseif (InKeyName == UIConst.GamePadKey.RightTriggerThreshold) then
        -- 向右切换选中角色
        self:SelectOtherCharItem(true)
    end
    return IsEventHandled
end

AssembleComponents(M)
return M

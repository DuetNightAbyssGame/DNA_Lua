--
-- DESCRIPTION
-- 新手任务主界面
-- @COMPANY **
-- @AUTHOR ** hy
-- @DATE ${date} ${time}
--
require "UnLua"

local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"

local M = Class({
    "BluePrints.Common.TimerMgr",
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.UI.WBP.Activity.Widget.JumpToOtherPage.ActivityJumpPageBase",
})

M._components = {
    "BluePrints.UI.WBP.Activity.Widget.View.ActivityJumpPageView",
}

function M:Initialize(Initializer)
    self.OwnerPlayer = nil               -- 所属的Player
    self.ParentWidget = nil              -- 父页面对象
    self.CurActivityId = nil             -- 当前活动的EventId
    self.ParentTabId = nil               -- 父页面上的TabId
    self.FocusWidgetName = nil           -- 当前Focus的Widget对象
end

function M:UpdatePage(OperateSrc)
    local IsReBindClickFunction = false

    -- 重新绑定按钮事件
    if (IsReBindClickFunction) then
        self:BindAllClickFunction(self.ViewInfoBtnClick, self.GoToShopClick, self.GoToTargetPageClick)
    end

    self:ResetVariable()
    self:RefreshPageDynamicView()
    self:UpdatePageDynamicView()
    self.FocusWidgetName = "BackToPageWithJump"
end

function M:IsCanChangeToGamePadViewMode()
    -- 判断是否可以切换到手柄端（如果有bug可以考虑判断小部件上是否有聚焦）
    return self.FocusWidgetName ~= "CheckRewardDetailView"-- and self.FocusWidgetName ~= "SelectView"
end

function M:OnUpdateSubUIViewStyle(IsUseGamePad, bIsWithButton)
    --bIsWithButton是nil的话，说明是activityEntry传入的设备变化的时机，这时候要清空聚焦的情况
    --因为切换页面样式也用了这个函数，有点混乱，只能这样写了
    if bIsWithButton == nil then
        self.FocusWidgetName = nil
        self.FocusWidgetWidget = nil
    end
    -- 子页面切换输入设备逻辑
    DebugPrint("JLY OnUpdateSubUIViewStyle, IsUseGamePad:", IsUseGamePad)
    DebugPrint("JLY OnUpdateSubUIViewStyle, self:IsCanChangeToGamePadViewMode():", self:IsCanChangeToGamePadViewMode())
    IsUseGamePad = IsUseGamePad and self:IsCanChangeToGamePadViewMode()
    self.Com_BtnExplanation:UpdateUIStyleInPlatform(IsUseGamePad)

    local ChildItemSubWidget = self:GetSupportsKeyDownSubWidget()
    if (ChildItemSubWidget and type(ChildItemSubWidget.OnUpdateSubUIViewStyle) == "function") then
        ChildItemSubWidget:OnUpdateSubUIViewStyle(IsUseGamePad)
    end

    local SupportCommonSubItemWidget =self:GetSupportCommonSubItemWidget()
    if SupportCommonSubItemWidget and SupportCommonSubItemWidget.OnUpdateSubUIViewStyle then
        SupportCommonSubItemWidget:OnUpdateSubUIViewStyle(IsUseGamePad)
    end

    if (bIsWithButton) then
        if (IsUseGamePad) then
            self.Btn_Confirm:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        else
            self.Btn_Confirm:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    end

    if (IsUseGamePad) then
        self.Key_RewardTitle:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Btn_Buy.Key_Shop:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Key_Task:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Key_More:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Key_RewardTitle:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Btn_Buy.Key_Shop:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Key_Task:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Key_More:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end

    local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
    if ActivityMain then
        local JumpPageBG = ActivityMain.WidgetBGAnchor:GetChildAt(0)
        if JumpPageBG and JumpPageBG.UpdateUIStyleInPlatform then
            JumpPageBG:UpdateUIStyleInPlatform(IsUseGamePad)
        end
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
    
    if self.ParentWidget.CurrentActiveBg and self.ParentWidget.CurrentActiveBg.OnStuffDetailOpenChanged then
        self.ParentWidget.CurrentActiveBg:OnStuffDetailOpenChanged(bIsOpen)
    end
end

function M:GetCurFocusWidgetInfo()
    return self.FocusWidgetName, self.FocusWidgetWidget
end

function M:EnterStuffViewMode()
    if (self.IsHideReward) then
        return false
    end
    if (self.FocusWidgetName == "CheckRewardDetailView") then
        return self:LeaveStuffViewMode()
    end
    self.List_Reward:SetFocus()
    self.FocusWidgetName = "CheckRewardDetailView"
    self.FocusWidgetWidget = self.List_Reward
    if (self.ParentWidget) then
        self.ParentWidget:UpdateActivityKeyTips(self.FocusWidgetName, self.FocusWidgetWidget)
    end
    -- 切换回PC样式
    self:OnUpdateSubUIViewStyle(false, true)
    local ChildItemSubWidget = self:GetSupportsFocusSubWidget()
    local SupportCommonSubItemWidget =self:GetSupportCommonSubItemWidget()
    if SupportCommonSubItemWidget and SupportCommonSubItemWidget.OnUpdateSubUIViewStyle then
        SupportCommonSubItemWidget:OnUpdateSubUIViewStyle(false)
    end
    if (ChildItemSubWidget) then
        ChildItemSubWidget:OnUpdateSubUIViewStyle(false)
    end
    return true
end

function M:LeaveStuffViewMode()
    if (self.FocusWidgetName == nil or self.FocusWidgetName == "BackToPageWithJump") then
        return false
    end
    self.FocusWidgetName = nil
    self.FocusWidgetWidget = nil
    self.List_Reward:BP_ClearSelection()
    if (self.ParentWidget) then
        self.ParentWidget:UpdateActivityKeyTips()
        self.ParentWidget:SetFocus()
    end
    -- 切换回手柄样式
    self:OnUpdateSubUIViewStyle(true, true)
    local ChildItemSubWidget = self:GetSupportsFocusSubWidget()
    if (ChildItemSubWidget) then
        ChildItemSubWidget:OnUpdateSubUIViewStyle(true)
    end
    local SupportCommonSubItemWidget =self:GetSupportCommonSubItemWidget()
    if SupportCommonSubItemWidget and SupportCommonSubItemWidget.OnUpdateSubUIViewStyle then
        SupportCommonSubItemWidget:OnUpdateSubUIViewStyle(true)
    end
    return true
end

function M:GetSupportsFocusSubWidget()
    local ChildItemSubWidget = self.Group_Task:GetChildAt(0)
    -- if (not ChildItemSubWidget) then
    --     ChildItemSubWidget = self.Group_TaskProgress:GetChildAt(0)
    -- end
    return ChildItemSubWidget
end

function M:GetSupportCommonSubItemWidget()
    local CommonSubItemWidget=self.Group_LimitTimeReward:GetChildAt(0)
    return CommonSubItemWidget
end


function M:GetSupportsKeyDownSubWidget()
    local ChildItemSubWidget = self.Group_Task:GetChildAt(0)
    if (not ChildItemSubWidget) then
        ChildItemSubWidget = self.Group_TaskProgress:GetChildAt(0)
    end
    if (not ChildItemSubWidget) then
        ChildItemSubWidget = self.Group_Common_SubItem:GetChildAt(0) --无前置的情况
    end
    return ChildItemSubWidget
end

function M:GetCurFocusWidgetInfo()
    local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
    if ActivityMain then
        local GoToBtnWidgetIndex = self.WS:GetActiveWidgetIndex()
        if (GoToBtnWidgetIndex == 1) then
            return self.FocusWidgetName, self.FocusWidgetWidget
        end
        local JumpPageBG = ActivityMain.WidgetBGAnchor:GetChildAt(0)
        if JumpPageBG then
            return JumpPageBG.FocusWidgetName, JumpPageBG.FocusWidgetWidget
        end
    end
    return self.FocusWidgetName, self.FocusWidgetWidget
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
    if (InKeyName == UIConst.GamePadKey.SpecialLeft) then
        -- 聚焦任务
        local ChildItemSubWidget = self:GetSupportsFocusSubWidget()
        if (ChildItemSubWidget and type(ChildItemSubWidget.OnSubWidgetReceivedFocus) == "function") then
            IsEventHandled = true
            -- 切换回PC样式
            self:OnUpdateSubUIViewStyle(false, true)
            self.FocusWidgetName, self.FocusWidgetWidget = ChildItemSubWidget:OnSubWidgetReceivedFocus()
            if (self.ParentWidget) then
                self.ParentWidget:UpdateActivityKeyTips(self.FocusWidgetName, self.FocusWidgetWidget)
            end
            self.IsFocusInSpecialLeft = true
        end
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonLeft) then
        local PageConfigData = DataMgr.EventPortal[self.CurActivityId]
        if (PageConfigData.TaskId) then
            IsEventHandled = true
            self:GoToTaskClick()
        elseif (not PageConfigData.EventShop) then
            IsEventHandled = false
        elseif ActivityUtils.IsAccessoryDropActivity(self.CurActivityId) then
            IsEventHandled = false
        else
            IsEventHandled = true
            if self.RewardWidget and self.RewardWidget.GoToShopClick then
                self.RewardWidget:GoToShopClick()
            else
                self:GoToShopClick()
            end
        end
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonBottom) then
        local PageConfigData = DataMgr.EventPortal[self.CurActivityId]
        if (PageConfigData.IsUseTabJumpBtn ~= nil and PageConfigData.IsUseTabJumpBtn == false) then
            IsEventHandled = false
        else
            -- 按下A确认按钮
            local GoToBtnWidgetIndex = self.WS:GetActiveWidgetIndex()
            if (GoToBtnWidgetIndex == 0) then
                IsEventHandled = true
                self:GoToTargetPageClick()
            end
        end
    elseif (InKeyName == UIConst.GamePadKey.LeftThumb) then
        -- 按下左边的摇杆进入商品选择
        IsEventHandled = self:EnterStuffViewMode()
    elseif (InKeyName == UIConst.GamePadKey.RightThumb) then
        -- RightThumb子控件也可能使用，根据配置来决定
        IsEventHandled = self:GoToMoreClick()
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonRight) then
        -- 按下返回按钮
        local ChildItemSubWidget = self:GetSupportsFocusSubWidget()
        local PlayerController = self:GetOwningPlayer()
        if (ChildItemSubWidget and ChildItemSubWidget:HasUserFocusedDescendants(PlayerController) and type(ChildItemSubWidget.OnSubWidgetLostFocus) == "function") then
            IsEventHandled = true
            -- 切换回普通手柄样式
            self:OnUpdateSubUIViewStyle(true, true)
            self.FocusWidgetName, self.FocusWidgetWidget = ChildItemSubWidget:OnSubWidgetLostFocus()
            ChildItemSubWidget:OnUpdateSubUIViewStyle(true)
            if (self.ParentWidget) then
                self.ParentWidget:UpdateActivityKeyTips()
                self.ParentWidget:SetFocus()
            end
            self.IsFocusInSpecialLeft = false
        else
            IsEventHandled = self:LeaveStuffViewMode()
        end
    elseif (InKeyName == UIConst.GamePadKey.SpecialRight) then
        -- 按下右边菜单键打开弹窗
        IsEventHandled = true
        self:ViewInfoBtnClick()
    end

    if not IsEventHandled then
        local ChildItemSubWidget = self:GetSupportsKeyDownSubWidget()
        if ChildItemSubWidget then
            if type(ChildItemSubWidget.HandleKeyDownOnGamePad) == "function" then
                IsEventHandled = ChildItemSubWidget:HandleKeyDownOnGamePad(InKeyName)
            end
        end
    end

    if not IsEventHandled then
        local ChildItemSubWidget = self:GetSupportCommonSubItemWidget()
        if ChildItemSubWidget then
            if type(ChildItemSubWidget.HandleKeyDownOnGamePad) == "function" then
                IsEventHandled = ChildItemSubWidget:HandleKeyDownOnGamePad(InKeyName)
            end
        end
    end

    if not IsEventHandled then
        local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
        if ActivityMain then
            local JumpPageBG = ActivityMain.WidgetBGAnchor:GetChildAt(0)
            if JumpPageBG and type(JumpPageBG.HandleKeyDownOnGamePad) == "function" then
                IsEventHandled = JumpPageBG:HandleKeyDownOnGamePad(InKeyName)
            end
        end
    end
    return IsEventHandled
end

function M:Destruct()
    if self.CurActivityId then
        ActivityReddotHelper.RemoveReddotListenByEventId(self.CurActivityId, self)
    end
end

function M:ReceiveEnterStateSelf(StackAction)
    if (StackAction == 1) then
        if self.FocusWidgetName ~= nil and self.FocusWidgetWidget == self.List_Reward then
            self:EnterStuffViewMode()
        end
        if self.IsFocusInSpecialLeft then
            self.FocusWidgetWidget:SetFocus()
        end
    end
end

AssembleComponents(M)
return M

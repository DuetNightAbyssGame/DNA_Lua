--
-- DESCRIPTION
-- 活动主界面(移动平台)
-- @COMPANY **
-- @AUTHOR ** hy
-- @DATE ${date} ${time}
--

require "UnLua"

local M = Class({
    "BluePrints.UI.BP_UIState_C", 
    "BluePrints.UI.WBP.Activity.WBP_Activity_EntryBase_C",
    "BluePrints.Common.DelayFrameComponent"
})

M._components = {
    "BluePrints.UI.WBP.Activity.Widget.View.ActivityEntryBaseView",
}

function M:Initialize(Initializer)
    self.Super.Initialize(self)
    self.OwnerPlayer = nil              -- 所属的Player
    self.CurTabId = nil                 -- 当前的TabId
    self.CurTabIndex = nil              -- 当前的TabIndex
    self.IsNotFirstOpenSystem = false   -- 是否第一次打开
    self.AllCurrentActivityID = {}      -- 所有的活动ID
    self.AllCurrentActivityPage = {}    -- 所有活动Page
end

-- self.TryOutActivityNeedJumpToTabIndex是专门给试玩活动用的，作用是跳转到试玩活动页面的指定Tab
function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self.OwnerPlayer, self.NeedJumpToTabId, self.NeedJumpToActivityId, self.TryOutActivityNeedJumpToTabIndex = ...
    if (self.OwnerPlayer == nil or not UE4.UKismetSystemLibrary.IsValid(self.OwnerPlayer)) then
        self.OwnerPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    end
    local Info = {}
    Info.OwnerPanel = self
    self.EventTypeTab:Init(Info)
    self:InitListenEvent()
    self:GenerateAllDataInfo()
    self:PlayInAnim()
    self.EventTypeTab:InitReddotTreeInfo()
    self:AddTimer(0.05,function()
        if (not self) or (not self.EventTypeTab) then return end
        if not self.NeedJumpToTabId then 
            self.EventTypeTab:ResetPos()
            self.NeedJumpToTabId = nil
        end
    end)
    self.OpenKey = CommonUtils:GetActionMappingKeyName("OpenEvent")
    EventManager:AddEvent(EventID.OnReturnToActivityEntry, self, self.OnReturnToActivityEntry)
    EventManager:AddEvent(EventID.OnLeaveActivityEntry, self, self.OnLeaveActivityEntry)
    EventManager:AddEvent(EventID.OnActivityEntryShowVisible, self, self.OnActivityEntryShowVisible)
    EventManager:AddEvent(EventID.OnActivityComplete, self, self.OnActivityComplete)
end

function M:InitListenEvent()
    self:AddDispatcher(EventID.OnUpdateActivityEvent, self, self.OnUpdateActivityByAction)
    self:AddDispatcher(EventID.ActivityControllerEvent, self, self.OnUpdateActivityByControllerEvent)
end

function M:ReceiveEnterState(StackAction)
    if (StackAction == 1) then
        self:OnRefreshCurrentPageAfterJump()
        self:UpdateTabRedInfoByActivityID(self.CurTabIndex)
        self:PlayAnimationForward(self.In)
    end
    self.Super.ReceiveEnterState(self, StackAction)
end

function M:Close()

    self.Super.Close(self)
end

function M:Destruct()
    self.WidgetBGAnchor:ClearChildren()
    self.Group_Anchor:ClearChildren()
    self.List_Tab.OnCreateEmptyContent:Unbind()
    EventManager:RemoveEvent(EventID.OnReturnToActivityEntry, self)
    EventManager:RemoveEvent(EventID.OnLeaveActivityEntry, self)
    EventManager:RemoveEvent(EventID.OnActivityComplete, self)
    self.Super.Destruct(self)
end

-- function M:Hide(HideTag)
--     if HideTag == "UIStackChange" then
--         self:AddTimer(0.2,function()
--             self:SetUIVisibilityTag(UIConst.CommonHideTagName.UIStackChange, true)
--         end)
--     else
--         M.Super.Hide(self, HideTag)
--     end
-- end

function M:RefreshBaseInfo(TopTabInfo, SubTabItems, BtnClickFunction, VirtualClickFunction, SelectTabIndex)
    -- 刷新一些基础的UI信息
    local SubTabInfo = {Tabs = SubTabItems, SoundFunc = function() AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil) end}
    self:InitTabView(TopTabInfo, SubTabInfo, BtnClickFunction, VirtualClickFunction, SelectTabIndex)
    self:ShowContentView(SubTabItems == nil or #SubTabItems == 0, true)
end

function M:GetTopTabInfo()
    local TopTabInfo = {Tabs=self.AllTabInfo, DynamicNode={"ResourceBar",},
                        StyleName="Image", OwnerPanel=self, TitleName=GText("MAIN_UI_GAMEEVENT"), BackCallback=self.OnReturnKeyDown, InfoCallback="NotShow",
                    }
    return TopTabInfo
end

function M:UpdateUIStyleInPlatform(IsUseGamePad)
    -- 手机暂不实现
end

--------------------------输入交互--------------------------------
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        IsEventHandled = self.Activity_Tab:Handle_KeyEventOnPC(InKeyName) 
    end

    if (not IsEventHandled) then
        -- IsEventHandled = self.Sub_Tab:Handle_KeyEventOnPC(InKeyName)
        if (not IsEventHandled) then
            local CurrentActivePage = self.AllCurrentActivityPage[self.CurTabId]
            if (CurrentActivePage ~= nil) then
                IsEventHandled = CurrentActivePage:HandleKeyDownInPage(MyGeometry, InKeyEvent)
            end
        end
    end

    if (InKeyName == self.OpenKey) then
        IsEventHandled = true
        self:OnReturnKeyDown()
    end

    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:HandleVirtualClickInGamePad(TabWidget)
    if (self.GameInputModeSubsystem:GetCurrentInputType() ~= ECommonInputType.Gamepad) then
        return
    end
    -- 处理A键相关
    local CurrentActivePage = self.AllCurrentActivityPage[self.CurTabId]
    if (CurrentActivePage ~= nil) then
         CurrentActivePage:OnGamePadButtonDown(UIConst.GamePadKey.FaceButtonBottom)
    end
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if (InKeyName == "Gamepad_FaceButton_Left") then
        IsEventHandled = self:Handle_KeyDownOnGamePad()
    else
        IsEventHandled = self.Activity_Tab:Handle_KeyEventOnGamePad(InKeyName)
    end
    return IsEventHandled
end

function M:Handle_KeyDownOnGamePad()
    -- 处理手柄相关的交互事件
    return true
end

function M:OnReturnToActivityEntry()
    if self:IsPlayingAnimation(self.In) then
        DebugPrint("OnReturnToActivityEntry IsPlayingAnimation In")
        return
    end
    self:StopAllAnimations()
    self:PlayAnimationForward(self.In)
end

function M:OnLeaveActivityEntry()
    if self:IsPlayingAnimation(self.Out) then
        DebugPrint("OnLeaveActivityEntry IsPlayingAnimation Out")
        return
    end
    self:StopAllAnimations()
    self:PlayAnimationForward(self.Out)
end

function M:OnActivityComplete(EventID)
    self:SetActivityComplete(EventID)
end

function M:OnActivityEntryShowVisible()
    self:SetUIVisibilityTag(UIConst.CommonHideTagName.UIStackChange, false)
end

AssembleComponents(M)
return M
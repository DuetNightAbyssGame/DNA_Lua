--
-- DESCRIPTION
-- 活动系统入口View （PC、移动端公用）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local ActivityCommon = require "BluePrints.UI.WBP.Activity.ActivityCommon"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"
local ActivityUtils = require "BluePrints.UI.WBP.Activity.ActivityUtils"

local M = {}

function M:PlayInAnim()
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "Activity", nil)
    self:BindToAnimationFinished(self.In, {self, function()
        self.IsNotFirstOpenSystem = true
    end})
    self:PlayAnimationForward(self.In)
end

function M:PlayOutAnim()
    AudioManager(self):SetEventSoundParam(self, "Activity", {ToEnd=1})
    -- 关闭的时候释放掉背景资源
    self.CurrentActiveBg = nil
    self.WidgetBGAnchor:ClearChildren()
    self:BindToAnimationFinished(self.Out, {self, self.Close})
    self:PlayAnimationForward(self.Out)
end

function M:CheckIsCanCloseSelf()
    if (self:IsAnimationPlaying(self.In)) then
        return false
    end
    return true
end

function M:CheckIsInCloseSelfState()
    if (self:IsAnimationPlaying(self.Out)) then
        return true
    end
    return false
end

function M:CreateEmptyContent()
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.IsEmpty = true
    return Obj
end

function M:InitTabView(TopTabInfo, SubTabInfo, BtnClickFunction, VirtualClickCallback, SelectTabIndex)
    -- 初始化Tab的信息
    -- self.Com_Tab:Init(TopTabInfo)
    self.Activity_Tab:Init(TopTabInfo)

    -- self.Sub_Tab:Init(SubTabInfo)
    self.List_Tab:ClearListItems()
    local LimitStartIndex, NormalStartIndex = 1,1
    local LimitCount, UnLimitCount = 0,0
    for _, TabInfo in ipairs(SubTabInfo.Tabs) do
        local ItemObject = NewObject(UIUtils.GetCommonItemContentClass())
        ItemObject.TabId = TabInfo.TabId
        ItemObject.EventId = TabInfo.EventId
        ItemObject.Name = TabInfo.Text
        ItemObject.IconPath = TabInfo.IconPath
        ItemObject.BgPath = TabInfo.EventBgPath
        ItemObject.TabIconPath = TabInfo.EventTabIconPath
        ItemObject.ClickCallback = BtnClickFunction
        ItemObject.VirtualClickCallback = VirtualClickCallback
        ItemObject.ParentWidget = self
        ItemObject.bLimit = TabInfo.bLimit
        if TabInfo.bLimit then
            ItemObject.Index = LimitStartIndex
            LimitStartIndex = LimitStartIndex + 1
            LimitCount = LimitCount + 1
        else
            ItemObject.Index = NormalStartIndex
            NormalStartIndex = NormalStartIndex + 1
            UnLimitCount = UnLimitCount + 1
        end
        ItemObject.IsSelected = ItemObject.Index == SelectTabIndex

        -- --由于活动没有框架层统一的初始化逻辑，只能在这里写这种东西.....
        -- for _, ActivityId in ipairs(DataMgr.EventTab[TabInfo.TabId].EventId) do
        --     ActivityReddotHelper.RefreshReddotNode(ActivityId)
        -- end

        self.List_Tab:AddItem(ItemObject)
        if ItemObject.IsSelected then
            self:AddTimer(0.1, function()
                self.List_Tab:BP_ScrollItemIntoView(ItemObject)
                self.LastIndex = self.List_Tab:GetNumItems()
                local DisplayedWidgets = self.List_Tab:GetDisplayedEntryWidgets():ToTable()
                self.DisplayedWidgetsCount = #DisplayedWidgets
            end)
        end
    end

    local IsEmpty = self.List_Tab:GetNumItems() == 0
    if IsEmpty then
        self.List_Tab:AddItem(self:CreateEmptyContent())
    end

    if (self:IsExistTimer(self.NextFrameListEmpty)) then
        self:RemoveTimer(self.NextFrameListEmpty)
    end
    self.NextFrameListEmpty = self:AddTimer(0.01, function()
        if self.ListTabMaxCount == nil then
            self.ListTabMaxCount = UIUtils.GetListViewContentMaxCount(self.List_Tab)
        end
        local RestCount = 0
        if self.EventTypeTab.bLimitTime or self.EventTypeTab.bLimitTime == nil then
            RestCount = self.ListTabMaxCount - LimitCount
        else
            RestCount = self.ListTabMaxCount - UnLimitCount
        end
        DebugPrint("jly@ RestCount: " .. RestCount)
        for i = 1, RestCount do
            self.List_Tab:AddItem(self:CreateEmptyContent())
            DebugPrint("jly@ Add: " .. i)
        end
    end)
    -- self.Sub_Tab:BindEventOnTabSelected(self, BtnClickFunction)
    -- self:JumpToTargetTab(SelectTabIndex)
    if (SelectTabIndex ~= nil) then
        self.List_Tab:SetSelectedIndex(SelectTabIndex - 1)
    end

    if (#SubTabInfo.Tabs > 0) then
        self.List_Tab:SetRenderOpacity(1.0)
        self.List_Tab:SetVisibility(UIConst.VisibilityOp["Visible"])
    else
        self.List_Tab:SetRenderOpacity(0.0)
        self.List_Tab:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
    end

    self.List_Tab.OnListViewScrolled:Add(self, self.OnList_TabScrolled)
    self:AddTimer(0.2, function()
        if not self then return end
        self:OnList_TabScrolled()
    end)
    if self.InitEventTypeTabReddot == nil then
        self.InitEventTypeTabReddot = true
        self.EventTypeTab:UpdateEventTypeTabReddot(true)
    else
        self.EventTypeTab:UpdateEventTypeTabReddot()
    end
    for _, Content in pairs(self.List_Tab:GetListItems()) do
        if Content.bLimit ~= nil then
            local CanShowInList = (Content.bLimit and self.EventTypeTab:IsLimitTime()) or ((not Content.bLimit) and (not self.EventTypeTab:IsLimitTime()))
            if not CanShowInList then
                self.List_Tab:RemoveItem(Content)
            end
        end
    end
    self.List_Tab:RequestFillEmptyContent()

    UIUtils.BindListViewReddotAndNewClickEvent(
        self.List_Tab,
        self.List_RedDotTop,
        self.List_RedDotBottom,
        nil,
        nil,
        function(...)
            local Content = ...
            if not Content then
                return false
            end
            if Content.ShowRedDot then
                return true
            end
            if Content.TabId == nil then
                return false
            end
            local NodeName = ActivityReddotHelper.GetEventTabNodeName(Content.TabId)
            local ReddotNode = ReddotManager.GetTreeNode(NodeName)
            ---@param Node ReddotTreeNode
            if ReddotNode == nil or ReddotNode.Count == nil then
                return false
            else
                return ReddotNode.Count > 0 and ReddotNode.ReddotType == EReddotType.Normal
            end
        end
    )
end

function M:OnList_TabScrolled()
    self:AddTimer(0.033, function()
        if not self then return end
        UIUtils.UpdateListArrowAndReddot(
            self.List_Tab,
            self.List_RedDotTop,
            self.List_RedDotBottom,
            self.List_ArrowTop,
            self.List_ArrowBottom,
            function(...)
               local Content = ...
                if not Content then
                    return false
                end
                if Content.ShowRedDot then
                    return true
                end
                if Content.TabId == nil then
                    return false
                end
                local NodeName = ActivityReddotHelper.GetEventTabNodeName(Content.TabId)
                local ReddotNode = ReddotManager.GetTreeNode(NodeName)
                ---@param Node ReddotTreeNode
                if ReddotNode == nil or ReddotNode.Count == nil then
                    return false
                else
                    return ReddotNode.Count > 0 and ReddotNode.ReddotType == EReddotType.Normal
                end
            end
        )
    end)
end

function M:JumpToTargetTab(SelectTabIndex)
    if (SelectTabIndex == nil) then
        return
    end
    -- self.Sub_Tab:SelectTab(SelectTabIndex) 
    local AllItemCount = self.List_Tab:GetNumItems()
    for i = 0, AllItemCount - 1, 1 do
        local ItemObj = self.List_Tab:GetItemAt(i)
        if (ItemObj) then
            if (ItemObj.UI) then
                ItemObj.UI:SetIsSelected(i == SelectTabIndex - 1)
            else
                ItemObj.IsSelected = i == SelectTabIndex - 1
            end
        end
    end
end

function M:ShowContentView(IsEmpty, IsInMobileMode)
    -- 设置节点显隐
    if (IsInMobileMode) then
        if (IsEmpty) then
            self.Text_Activity_Empry:SetText(GText("Text_Activity_Empty"))
            self.Group_Empty:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Group_Normal:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            self.Panel_Component:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        else
            self.Group_Empty:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            self.Group_Normal:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Panel_Component:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
    else
        if (IsEmpty) then
            self.Text_Activity_Empry:SetText(GText("Text_Activity_Empty"))
            self.Group_Empty:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Group_Normal:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            self:UpdateActivityKeyTips()
        else
            self.Group_Empty:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            self.Group_Normal:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
    end
end

function M:RefreshViewAfterPageDataSet(ActivityConfigData, PageConfigData)
    if (not ActivityConfigData) then
        return
    end
    -- 刷新背景样式
    local EventBgBPPath = nil
    if (CommonUtils.GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.MOBILE) then
        EventBgBPPath = ActivityConfigData.EventBgBPPathMobile or ActivityConfigData.EventBgBPPathPC
    else
        EventBgBPPath = ActivityConfigData.EventBgBPPathPC
    end

    if (EventBgBPPath ~= nil) then
        self.Image_MainBG:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.CurrentActiveBg = nil
        self.WidgetBGAnchor:ClearChildren()
        local NewBgWidget = UIManager(self):CreateWidget(EventBgBPPath)
        if NewBgWidget.InitUI then
            NewBgWidget:InitUI(ActivityConfigData, PageConfigData, self.CurTabId, self)
        end
        if NewBgWidget.PlayBGVideo then
            self:AddTimer(0.01, function()
                NewBgWidget:PlayBGVideo(ActivityConfigData, PageConfigData)
            end)
        end
        if (NewBgWidget ~= nil) then
            local NeedHideNodeList = PageConfigData.HideBPNode
            if (NeedHideNodeList) then
                for _, value in ipairs(NeedHideNodeList) do
                    if NewBgWidget[value] then
                        NewBgWidget[value]:SetVisibility(UIConst.VisibilityOp["Collapsed"])
                    end
                end
            end
            self.CurrentActiveBg = NewBgWidget
            local OverSlot = self.WidgetBGAnchor:AddChildToOverlay(NewBgWidget)
            OverSlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
            OverSlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
            local IsLock = ActivityUtils.CheckIsActivityLock(PageConfigData)
            if (IsLock and NewBgWidget.Lock_In ~= nil) then
                NewBgWidget:PlayAnimationForward(NewBgWidget.Lock_In)
            elseif (NewBgWidget.In ~= nil) then
                NewBgWidget:PlayAnimationForward(NewBgWidget.In)
            end
            if (NewBgWidget.Spine_Char ~= nil) then
                NewBgWidget.Spine_Char:SetAnimation(0,"In",false)
                NewBgWidget.Spine_Char:AddAnimation(0,"Loop",true,0)
            end
            if (NewBgWidget.PlaySplineAnimation ~= nil) then
                NewBgWidget:PlaySplineAnimation()
            end
        end
        self.WidgetBGAnchor:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    elseif (PageConfigData and PageConfigData.EventBg) then
        self.WidgetBGAnchor:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Image_MainBG:SetBrushResourceObject(LoadObject(PageConfigData.EventBg))
        self.Image_MainBG:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.WidgetBGAnchor:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Image_MainBG:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end

    if (ActivityConfigData.EventBgSound) then
        local FinalEventBgSound = "event:"..ActivityConfigData.EventBgSound
        AudioManager(self):PlayUISound(self, FinalEventBgSound, ActivityCommon.MainUIName, nil)
    end
end


function M:CreateActivityPage(EventConfigData)
    local PageMain = nil
    if (CommonUtils.GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.PC) then
        PageMain = UIManager(self):CreateWidget(EventConfigData.PCBluePrint)
    else
        PageMain = UIManager(self):CreateWidget(EventConfigData.MobileBluePrint or EventConfigData.PCBluePrint)
    end
    if (PageMain == nil) then
        return
    end

    self.Group_Anchor:AddChildToOverlay(PageMain)
    local ContentOverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(PageMain)
    ContentOverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    ContentOverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    return PageMain
end

function M:AddActivityPageToNewNode(PageMain)
    if (PageMain ~= nil) then
        self.Group_Anchor:AddChildToOverlay(PageMain)
        local ContentOverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(PageMain)
        ContentOverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
        ContentOverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    end
end


return M





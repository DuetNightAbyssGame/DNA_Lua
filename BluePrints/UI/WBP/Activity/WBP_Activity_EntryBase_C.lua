--
-- DESCRIPTION
-- 活动基类（PC和移动端共用）
-- @COMPANY **
-- @AUTHOR ** hy
-- @DATE ${date} ${time}
--

require "UnLua"

local ActivityCommon = require "BluePrints.UI.WBP.Activity.ActivityCommon"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

local M = Class()

function M:GenerateAllDataInfo()
    EventManager:FireEvent(EventID.RefreshWuyoushengLevelReddot)
    -- 打开后重新刷新一遍红点信息
    ActivityUtils.RefreshActivityReddotNode()

    local SubTabItems = self:GenerateCurrentSubTabItems()
    local TopTabInfo = self:GetTopTabInfo()
    self.LimitStateCurActivityId = self.bLimit and self.LimitStateCurActivityId or self.CurActivityId
    local LimitStateCurTabIndex = self.bLimit and self:GetCurTabIndexByActivityId(self.LimitStateCurActivityId) or 1
    self.NormalStateCurActivityId = self.bLimit and self.CurActivityId or self.NormalStateCurActivityId
    local NormalStateCurTabIndex = self.bLimit and 1 or self:GetCurTabIndexByActivityId(self.NormalStateCurActivityId)
    if not self.NeedJumpToTabIndex or self.NeedJumpToTabIndex == 1 then
        self.NeedJumpToTabIndex = self.bLimit and LimitStateCurTabIndex or NormalStateCurTabIndex
    end
    if self.NeedJumpToTabId then
        self.NeedJumpToTabInfo = self:GetCurTabIndexByTabId(self.NeedJumpToTabId)
        if self.NeedJumpToTabInfo.TargetTabType == "Normal" and self.EventTypeTab:IsLimitTime() then
            self.EventTypeTab:SwitchTab(self.NeedJumpToTabInfo.TargetTabType)
            return
        elseif self.NeedJumpToTabInfo.TargetTabType == "LimitTime" and not self.EventTypeTab:IsLimitTime() then
            self.EventTypeTab:SwitchTab(self.NeedJumpToTabInfo.TargetTabType)
            return
        end
        if self.NeedJumpToTabInfo.TargetTabIndex ~= -1 then
            self.NeedJumpToTabIndex = self.NeedJumpToTabInfo.TargetTabIndex
        end
        self.NeedJumpToTabId = nil
    end
    self:RefreshBaseInfo(TopTabInfo, SubTabItems, self.ActivityItemClick, self.HandleVirtualClickInGamePad, self.NeedJumpToTabIndex or 1)
    self:RefreshDynamicInfo()
    self:AddTimer(0.15,function()
        if (not self) then return end
        if not self.NeedJumpToTabIndex then 
            --self:ResetListTab()
        else
            self.NeedJumpToTabIndex = nil
        end
    end)
    self.List_Tab.BP_OnItemSelectionChanged:Add(self, self.OnSelectActivityPageChanged)
end

function M:GetCurTabIndexByActivityId(ActivityId)
    local CurIdx = 0
    local ResetIdx = false
    for Idx, v in ipairs(self.SubTabItems) do
        if not v.bLimit and not ResetIdx then
            CurIdx = 0
            ResetIdx = true
        end
        CurIdx = CurIdx + 1
        for _, EventId in ipairs(v.EventId) do
            if EventId == ActivityId then
                return CurIdx
            end
        end
    end
    return 1
end

function M:GetCurTabIndexByTabId(TabId)
    local TargetTabInfo = {TargetTabType = nil, TargetTabIndex = -1}
    local CurIdx = 0
    local ResetIdx = false
    for Idx, v in ipairs(self.SubTabItems) do
        if not v.bLimit and not ResetIdx then
            CurIdx = 0
            ResetIdx = true
        end
        CurIdx = CurIdx + 1
        if v.TabId == TabId then
            TargetTabInfo.TargetTabType = v.bLimit and "LimitTime" or "Normal"
            TargetTabInfo.TargetTabIndex = CurIdx
            break
        end
    end
    return TargetTabInfo
end

function M:GenerateCurrentSubTabItems()
    self.AllCurrentActivityInfo, self.AllAllActivityTabIdx = ActivityUtils.GetCurrentAllActivityWithoutSystemCheck()
    self.SubTabItems = {}

    local Avatar = GWorld:GetAvatar()

    -- 限时/常驻分别拆分为“未完成/已完成”
    local LimitUndone, LimitDone = {}, {}
    local NormalUndone, NormalDone = {}, {}

    local ActivityInfo = {}
    local LimitCount, NormalCount = 0, 0

    for _, v in ipairs(self.AllAllActivityTabIdx) do
        local TabConfigInfo = DataMgr.EventTab[v]
        local MainConfigInfo = TabConfigInfo and DataMgr.EventMain[TabConfigInfo.EventId[1]]
        if not MainConfigInfo then
            goto continue
        end

        -- 判定是否常驻
        local bPermanentEvent = ActivityUtils.CheckIsPermanentEvent(TabConfigInfo.EventId[1])

        -- 生成条目
        local Item = {
            Text = GText(TabConfigInfo.EventTabName),
            IconPath = TabConfigInfo.EventIcon,
            bLimit = not bPermanentEvent,
            TabId = TabConfigInfo.EventTabId,
            EventId = TabConfigInfo.EventId,
            EventBgPath = TabConfigInfo.EventTabBg,
            EventTabIconPath = TabConfigInfo.EventTabIcon,
        }

         -- 判定是否完成
        local isDone = false
        if Avatar and Item.EventId and Item.EventId[1] then
            local doneFlag = Avatar.CompletedActivity and Avatar.CompletedActivity[Item.EventId[1]]
            isDone = (doneFlag == true or doneFlag == 1)
        end

        if bPermanentEvent then
            NormalCount = NormalCount + 1
            if isDone then
                table.insert(NormalDone, Item)
            else
                table.insert(NormalUndone, Item)
            end
        else
            LimitCount = LimitCount + 1
            if isDone then
                table.insert(LimitDone, Item)
            else
                table.insert(LimitUndone, Item)
            end
        end

        ::continue::
    end

    -- 合并顺序：限时未完成 -> 限时已完成 -> 常驻未完成 -> 常驻已完成
    local ordered = {}
    for _, t in ipairs(LimitUndone)  do table.insert(ordered, t) end
    for _, t in ipairs(LimitDone)    do table.insert(ordered, t) end
    for _, t in ipairs(NormalUndone) do table.insert(ordered, t) end
    for _, t in ipairs(NormalDone)   do table.insert(ordered, t) end

    self.ActivityInfoIdxOffset = 100
    ActivityInfo = {}
    -- 先统计限时总数，便于分段
    local limitTotal = #LimitUndone + #LimitDone

    local idx = 0
    local function fillLimit(list)
        for _, value in ipairs(list) do
            idx = idx + 1
            ActivityInfo[idx] = value.EventId
        end
    end
    fillLimit(LimitUndone)
    fillLimit(LimitDone)

    local normalIdx = 0
    local function fillNormal(list)
        for _, value in ipairs(list) do
            normalIdx = normalIdx + 1
            ActivityInfo[self.ActivityInfoIdxOffset + normalIdx] = value.EventId
        end
    end
    fillNormal(NormalUndone)
    fillNormal(NormalDone)

    -- 更新限时/常驻开关显示
    if LimitCount <= 0 then
        self.EventTypeTab:SetIsLimitTime(false)
        self.EventTypeTab:SetForbidden(true)
        self.Group_EventType:SetVisibility(UIConst.VisibilityOp.Collapsed)
    elseif NormalCount <= 0 then
        self.EventTypeTab:SetIsLimitTime(true)
        self.EventTypeTab:SetForbidden(true)
        self.Group_EventType:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.EventTypeTab:SetForbidden(false)
        self.Group_EventType:SetVisibility(UIConst.VisibilityOp.Visible)
    end

    self.bLimit = self.EventTypeTab:IsLimitTime()
    self.SubTabItems = ordered
    self.AllCurrentActivityInfo = ActivityInfo
    return self.SubTabItems
end

function M:BP_GetDesiredFocusTarget()
    return self.CurFocusWidgetItem or self.List_Tab
end

function M:ActivityItemClick(TabWidget)
    if (not TabWidget) then
        return
    end
    local TabId = TabWidget:GetTabId()
    if (self.CurTabId == TabId) then
        return
    end
    if (self.CurTabId ~= nil) then
        local LastActivityPageName = DataMgr.EventTab[self.CurTabId].EventTabName
        if (LastActivityPageName) then
            ForceStopAsyncTask(self, LastActivityPageName)
        end
    end

    local TabIndex = TabWidget:GetTabIndex()
    local ActivityInfoIndex = TabIndex
    if self.EventTypeTab and (not self.EventTypeTab:IsLimitTime()) then
        ActivityInfoIndex = TabIndex + self.ActivityInfoIdxOffset
    end
    local ActivityInfo = self.AllCurrentActivityInfo[ActivityInfoIndex]
    local ActivityId = nil
    if (#ActivityInfo > 0) then
        ActivityId = ActivityInfo[1]
    end
    if self.NeedJumpToActivityId ~= nil then
        ActivityId = self.NeedJumpToActivityId
    end
    if (ActivityId == nil) then
        DebugPrint("ActivityItemClick error ActivityId is nil!!!")
        return
    end
    local ActivityConfigData = DataMgr.EventMain[ActivityId]
    local IsInActiveTime = ActivityUtils.CheckEventIsInActiveTime(ActivityId, ActivityConfigData)
    if (not IsInActiveTime) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_GameEvent_EventEnd"))
        self:JumpToTargetTab(self.CurTabIndex)
        return
    end

    if (self.CurTabId ~= nil) then
        local LastShowPage = self.AllCurrentActivityPage[self.CurTabId]
        if (LastShowPage ~= nil) then
            LastShowPage:HidePage()
        end
    end

    if (self.CurTabIndex ~= nil and self.CurTabIndex ~= TabIndex) then
        local LastTabObject = self.List_Tab:GetItemAt(self.CurTabIndex - 1)
        if (LastTabObject) then
            if (LastTabObject.UI) then
                LastTabObject.UI:SetIsSelected(false)
            else
                LastTabObject.IsSelected = false
            end
        end
    end
    self.CurTabId = TabId
    self.CurActivityId = ActivityId
    self.CurTabIndex = TabIndex
    self.List_Tab:SetSelectedIndex(self.CurTabIndex - 1)

    -- 生成活动玩法界面
    self:GenerateActivityPage(ActivityId, ActivityInfo, ActivityConfigData, TabId)
    ActivityUtils.TrySubActivityReddotCommon("New", ActivityId)
    self:UpdateTabRedInfoByActivityID(ActivityInfoIndex, ActivityId)
    -- 根据活动Id重新设置一下Tab
    self.Activity_Tab:Init(self:GetTopTabInfoByActivityId(ActivityId))
end

function M:GenerateActivityPage(ActivityId, ActivityInfo, ActivityConfigData, TabId)
    if (ActivityConfigData == nil) then
        return
    end

    local ActivityPage = self.AllCurrentActivityPage[TabId]
    if (ActivityCommon.IsLoadAsync and self.IsNotFirstOpenSystem) then
        if (ActivityPage == nil) then
            local ActivityPageName = DataMgr.EventTab[TabId].EventTabName

            RunAsyncTask(self, ActivityPageName, function(CoroutineObj)
                local ActivityPage = nil
                if (CommonUtils.GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.PC) then
                    ActivityPage = UIManager(self):CreateWidgetAsync(ActivityPageName, CoroutineObj, ActivityConfigData.PCBluePrint)
                else
                    ActivityPage = UIManager(self):CreateWidgetAsync(ActivityPageName, CoroutineObj, ActivityConfigData.MobileBluePrint or ActivityConfigData.PCBluePrint)
                end
                if (ActivityPage ~= nil) then
                    self:AddActivityPageToNewNode(ActivityPage)
                    ActivityPage:InitPage(ActivityId, TabId, ActivityInfo, self)
                    local PageConfigData = ActivityPage:GetPageConfigData()
                    self:RefreshViewAfterPageDataSet(ActivityConfigData, PageConfigData)
                    ActivityPage:PlayFadeIn()
                    self:SetDescTextType(ActivityPage)
                    self:SetDescTextAlign(ActivityPage)
                    self.AllCurrentActivityPage[TabId] = ActivityPage
                    -- 刷新一下平台相关UI样式
                    self:RefreshUIStyleAfterPageChange()
                end
            end)
        else
            ActivityPage:UpdatePage("ActivityTab")
            local PageConfigData = ActivityPage:GetPageConfigData()
            self:RefreshViewAfterPageDataSet(ActivityConfigData, PageConfigData)
            self:RefreshUIStyleAfterPageChange()
            ActivityPage:ShowPage(true)
        end
    else
        if (ActivityPage == nil) then
            ActivityPage = self:CreateActivityPage(ActivityConfigData)
            ActivityPage:InitPage(ActivityId, TabId, ActivityInfo, self)
            ActivityPage:PlayFadeIn()
            self.AllCurrentActivityPage[TabId] = ActivityPage
        else
            ActivityPage:UpdatePage("ActivityTab")
            ActivityPage:ShowPage(true)
        end
        local PageConfigData = ActivityPage:GetPageConfigData()
        self:RefreshViewAfterPageDataSet(ActivityConfigData, PageConfigData)
        self:RefreshUIStyleAfterPageChange()
    end
    self:SetDescTextType(ActivityPage)
    self:SetDescTextAlign(ActivityPage)
end

-- 给每个活动页面加一个根据背景改字号的逻辑
function M:SetDescTextType(ActivityPage)
    if ActivityPage then
        local index = 0
        local JumpPageBG = self.WidgetBGAnchor:GetChildAt(0)
        if JumpPageBG and JumpPageBG.WS_DescIndex then
            -- 确保获取到的是整数，并且只能是0或1
            local descIndex = tonumber(JumpPageBG.WS_DescIndex)
            if descIndex and descIndex >= 0 and descIndex <= 1 then
                index = math.floor(descIndex)
            end
            if ActivityPage.WS_TextDesc ~= nil then
                ActivityPage.WS_TextDesc:SetActiveWidgetIndex(index)
            elseif ActivityPage.Text_ActivityDesc and ActivityPage.Text_ActivityDesc_White then
                if descIndex == 0 then
                    ActivityPage.Text_ActivityDesc:SetVisibility(UIConst.VisibilityOp.Visible)
                    ActivityPage.Text_ActivityDesc_White:SetVisibility(UIConst.VisibilityOp.Collapsed)
                else
                    ActivityPage.Text_ActivityDesc:SetVisibility(UIConst.VisibilityOp.Collapsed)
                    ActivityPage.Text_ActivityDesc_White:SetVisibility(UIConst.VisibilityOp.Visible)
                end
            end
        end
    end
end

-- 给每个活动页面加一个根据背景改对齐的逻辑
function M:SetDescTextAlign(ActivityPage)
    if ActivityPage then
        local index = ETextJustify.Left
        local JumpPageBG = self.WidgetBGAnchor:GetChildAt(0)
        if JumpPageBG and JumpPageBG.DescText_IsLeft then
            -- 确保获取到的是整数，并且只能是0或1
            if JumpPageBG.DescText_IsLeft == 1 then
                index = ETextJustify.Right
            end
        end

        if CommonConst.SystemLanguage == CommonConst.SystemLanguages.JP then
            index = ETextJustify.Left
        end

        if ActivityPage.Text_Desc ~= nil then
            ActivityPage.Text_Desc:SetJustification(index)
        end
        if ActivityPage.Text_Desc_White ~= nil then
            ActivityPage.Text_Desc_White:SetJustification(index)
        end

        if ActivityPage.Text_ActivityDesc ~= nil then
            ActivityPage.Text_ActivityDesc:SetJustification(index)
        end
        if ActivityPage.Text_ActivityDesc_White ~= nil then
            ActivityPage.Text_ActivityDesc_White:SetJustification(index)
        end
    end
end

function M:RefreshDynamicInfo()
    local CurActivityPage = self.AllCurrentActivityPage[self.CurTabId]
    if (CurActivityPage ~= nil) then
        local CurPageConfigData = CurActivityPage:GetPageConfigData()
        local CurActivityId = nil
        if CurActivityPage.GetActivityId and type(CurActivityPage.GetActivityId) == "function" then
            CurActivityId = CurActivityPage:GetActivityId()
        end
        local ActivityId = CurActivityId or CurPageConfigData.EventId
        local ActivityConfigData = DataMgr.EventMain[ActivityId]
        self:RefreshViewAfterPageDataSet(ActivityConfigData, CurPageConfigData)
    end
end

function M:ResetListTab()
    if (not self.List_Tab) then return end
    local EntryItems = self.List_Tab:GetListItems()
    local isLimitTime = self.EventTypeTab and self.EventTypeTab:IsLimitTime() -- 判断当前是限时还是常驻
    local selected = false
    for _, Item in pairs(EntryItems or {}) do
        if not Item then goto continue end
        if not selected and ((isLimitTime and Item.bLimit) or (not isLimitTime and not Item.bLimit)) then
            --Item.UI:SetIsSelected(true)
            selected = true
        elseif Item.UI then
            --Item.UI:SetIsSelected(false)
        end
        ::continue::
    end
end

function M:RefreshUIStyleAfterPageChange()
    -- 根据当前平台刷新一下子UI样式
    self:UpdateUIStyleInPlatform(self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad)
    -- PC端刷新一下下方的快捷键
    if (CommonUtils.GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.PC) then
        local CurrentActivePage, CurFocusWidgetName, CurFocusWidgetItem = self.AllCurrentActivityPage[self.CurTabId], nil, nil
        if (CurrentActivePage ~= nil) then
            if (type(CurrentActivePage.GetCurFocusWidgetInfo) == "function") then
                CurFocusWidgetName, CurFocusWidgetItem = CurrentActivePage:GetCurFocusWidgetInfo()
            end
            self:UpdateActivityKeyTips(CurFocusWidgetName, CurFocusWidgetItem)
        else
            self:UpdateActivityKeyTips()
        end
    end
end

function M:OnReturnKeyDown()
    -- 返回上一级
    if (not self:CheckIsCanCloseSelf()) then
        return
    end
    for k, v in pairs(self.AllCurrentActivityPage) do
        if (type(v.CleanSelf) == "function") then
            v:CleanSelf(k ~= self.CurTabId) 
        end
        if (k == self.CurTabId) then
            v:PlayFadeOut(true)
        end
    end

    if (self.CurTabId ~= nil) then
        local CurActivityPageName = DataMgr.EventTab[self.CurTabId].EventTabName
        if (CurActivityPageName) then
            ForceStopAsyncTask(self, CurActivityPageName)
        end
    end
    -- UIUtils.PlayCommonBtnSe(self)
    self:PlayOutAnim()
end

function M:OnSpaceBarKeyDown()
    local CurActivityPage = self.AllCurrentActivityPage[self.CurTabId]
    if (CurActivityPage ~= nil and type(CurActivityPage.OnSpaceBarKeyDown) == "function") then
        CurActivityPage:OnSpaceBarKeyDown()
    end
end
function M:OnRefreshCurrentPageAfterJump()
    local ActivityPage = self.AllCurrentActivityPage[self.CurTabId]
    if (ActivityPage ~= nil) then
        ActivityPage:UpdatePage("BackToPageWithJump")
    end
end

function M:UpdateActivityKeyTips(FocusTypeName, FocusWidgetItem)
    FocusTypeName = FocusTypeName or "DefaultWidget"
    FocusWidgetItem = FocusWidgetItem or self.List_Tab
    local BottomKeyInfo = {}

    if (self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.MouseAndKeyboard) then
        if (FocusTypeName == "GetAllReward") then
            BottomKeyInfo = {
                {
                    KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback=self.OnReturnKeyDown, Owner=self} },
                    Desc = GText("UI_BACK")
                },
                {
                    KeyInfoList = { { Type = "Text", Text = "SpaceBar", ClickCallback=self.OnSpaceBarKeyDown, Owner=self } },
                    Desc = GText("UI_Achievement_GetAllReward")
                },
            }
        else
            BottomKeyInfo = {
                {
                    KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback=self.OnReturnKeyDown, Owner=self} },
                    Desc = GText("UI_BACK")
                },
            }
        end
    elseif (FocusTypeName == "CheckRewardView") then
        BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "LS" } },
                Desc = GText("UI_Controller_CheckReward")
            },
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "B", ClickCallback=self.OnReturnKeyDown, Owner=self} },
                Desc = GText("UI_Tips_Close")
            },
        }
    elseif (FocusTypeName == "SelectView") then
        BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "A" } },
                Desc = GText("UI_CTL_Select")
            },
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "B", ClickCallback=self.OnReturnKeyDown, Owner=self} },
                Desc = GText("UI_Tips_Close")
            },
        }
    elseif (FocusTypeName == "ACheckRewardView") then
        BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "A" } },
                Desc = GText("UI_Controller_CheckReward")
            },
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "B", ClickCallback=self.OnReturnKeyDown, Owner=self} },
                Desc = GText("UI_Tips_Close")
            },
        }
    elseif (FocusTypeName == "CheckRewardDetailView") then
        BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "A" } },
                Desc = GText("UI_Controller_CheckDetails")
            },
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "B", ClickCallback=self.OnReturnKeyDown, Owner=self} },
                Desc = GText("UI_Tips_Close")
            },
        }
    elseif (FocusTypeName == "CheckMultiRewardDetailView") then
        BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "A" } },
                Desc = GText("UI_Tips_Ensure")
            },
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "B", ClickCallback=self.OnReturnKeyDown, Owner=self} },
                Desc = GText("UI_Tips_Close")
            },
        }
    elseif (FocusTypeName == "ReceiveRewardView") then
        BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "A" } },
                Desc = GText("UI_CTL_Claim")
            },
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "B", ClickCallback=self.OnReturnKeyDown, Owner=self} },
                Desc = GText("UI_Tips_Close")
            },
        }
    elseif (FocusTypeName == "SelectRewardView") then
        BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "A" } },
                Desc = GText("UI_Controller_SelectReward")
            },
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "B", ClickCallback=self.OnReturnKeyDown, Owner=self} },
                Desc = GText("UI_Tips_Close")
            },
        }
    elseif (FocusTypeName == "EmptyView") then
        BottomKeyInfo = {}
    else
        BottomKeyInfo = self:GetDefaultTipsWithCurTab()

        if (BottomKeyInfo == nil) then
            BottomKeyInfo = {
                {
                    KeyInfoList = { { Type = "Img", ImgShortPath = "B", ClickCallback=self.OnReturnKeyDown, Owner=self} },
                    Desc = GText("UI_Tips_Close")
                },
            }
        end
    end

    -- 判断描述是否可以滚动
    local isCanScroll = self:IsScrollBoxDescCanScroll()
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad and isCanScroll and #BottomKeyInfo > 0 then
        -- 在BottomKeyInfo最后加一个滚动的图标
        BottomKeyInfo[#BottomKeyInfo + 1] = {
            KeyInfoList = { { Type = "Img", ImgShortPath = "RV" } },
            Desc = GText("UI_Controller_Slide")
        }
    end

    self.CurFocusWidgetName = FocusTypeName
    self.CurFocusWidgetItem = FocusWidgetItem
    if self.Com_KeyTips then
        self.Com_KeyTips:UpdateKeyInfo(BottomKeyInfo)
    end
    if self.Com_KeyTipsEmpty then
        self.Com_KeyTipsEmpty:UpdateKeyInfo(BottomKeyInfo)
    end
end

function M:IsScrollBoxDescCanScroll()
    local CurActivityPage = self.AllCurrentActivityPage[self.CurTabId]
    if CurActivityPage == nil then
        return false
    end
    local ScrollBox_Desc = CurActivityPage.ScrollBox_Desc
    if ScrollBox_Desc == nil then
        return false
    end

    local EndOffset = ScrollBox_Desc:GetScrollOffsetOfEnd()

    if EndOffset > 1.0 then
        return true
    end
    return false
end

function M:GetDefaultTipsWithCurTab()
    local ResultKeyInfo = nil

    local CurActivityPage = self.AllCurrentActivityPage[self.CurTabId]
    if (CurActivityPage ~= nil and type(CurActivityPage.GetDefaultBottomTips) == "function") then
        ResultKeyInfo = CurActivityPage:GetDefaultBottomTips()
    end

    return ResultKeyInfo
end

function M:IsCanChangeToGamePadViewMode()
    return true
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Gamepad_RightY") then
        local CurActivityPage = self.AllCurrentActivityPage[self.CurTabId]
        if CurActivityPage == nil then
            return UWidgetBlueprintLibrary.Unhandled()
        end
        local ScrollBox_Desc = CurActivityPage.ScrollBox_Desc
        if ScrollBox_Desc == nil then
            return UWidgetBlueprintLibrary.Unhandled()
        end
        local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 30
        local CurScrollOffset = ScrollBox_Desc:GetScrollOffset()
        local ScrollOffset = math.clamp(CurScrollOffset - a,0, ScrollBox_Desc:GetScrollOffsetOfEnd())
        ScrollBox_Desc:SetScrollOffset(ScrollOffset)
        if CurActivityPage.OnUserScrolled then
            CurActivityPage:OnUserScrolled()
        end
    end
    return UWidgetBlueprintLibrary.Unhandled()
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    local IsUseGamePad = CurInputType == ECommonInputType.Gamepad and self:IsCanChangeToGamePadViewMode()
    -- 一些公共组件切换显示模式
    self:UpdateUIStyleInPlatform(IsUseGamePad)
end

---------------------------RPC的回调-------------------
function M:OnUpdateActivityByAction(OpAction, ...)
    -- 所有RPC的回调
    if (OpAction == "SignGetReward") then
        -- 签到奖励获取
        local ActivityID, RewardIndex = ...
        local CurPageWidget = self.AllCurrentActivityPage[self.CurTabId]
        if (CurPageWidget ~= nil and CurPageWidget:GetActivityId() == ActivityID and CurPageWidget:IsPageInVisible()) then
            CurPageWidget:RefreshItemStyleByAction("SignGetReward", ActivityID, RewardIndex)
        end
        self:UpdateTabRedInfoByActivityID(nil, ActivityID)
    elseif (OpAction == "TryOutGetReward") then
        -- 试玩活动奖励领取
        local ActivityID = ...
        local CurPageWidget = self.AllCurrentActivityPage[self.CurTabId]
        if (CurPageWidget ~= nil and CurPageWidget:GetActivityId() == ActivityID and CurPageWidget:IsPageInVisible()) then
            CurPageWidget:RefreshItemStyleByAction("TryOutGetReward", ActivityID)
        end
        self:UpdateTabRedInfoByActivityID(nil, ActivityID)
    elseif (OpAction == "TrainingLevelReward") then
        -- 历练等级奖励获取
        local ActivityID = ...
        self:UpdateTabRedInfoByActivityID(nil, ActivityID)
    end
end

function M:OnUpdateActivityByControllerEvent(ActivityEventId, ...)
    if (ActivityEventId == ActivityCommon.EventId.OnRefreshInNextDay) then
        -- 隔天刷新
        local CurActivityPage = self.AllCurrentActivityPage[self.CurTabId]
        if (CurActivityPage ~= nil) then
            CurActivityPage:UpdatePage(ActivityCommon.AllUpdateTag.ActivityTab)
        end
    end
end

function M:OnSelectActivityPageChanged(SelectActivityItem, bIsSelect)
    -- 手柄模式下自动打开详情面版
    if (not SelectActivityItem) then
        return
    end
    if (self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad) then
        local isLimitTime = self.EventTypeTab and self.EventTypeTab:IsLimitTime()
        local bCanSelect = (isLimitTime and SelectActivityItem.bLimit) or ((not isLimitTime) and (not SelectActivityItem.bLimit))
        if bCanSelect then
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
            self:JumpToTargetTab(SelectActivityItem.Index)
            self.List_Tab:BP_NavigateToItem(SelectActivityItem)
            self:AddTimer(0.25,function()
                self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
            end,false,0,nil,true)
        end
    end
    if not self.LastIndex or not self.DisplayedWidgetsCount then return end
    if self.LastIndex == SelectActivityItem.Index then
        -- 只有当LastIndex超过列表实际项数时才滚动到底部
        -- 如果列表项数少于可显示的数量，就不需要滚动
        if self.DisplayedWidgetsCount > 0 and self.LastIndex >= self.DisplayedWidgetsCount then
            self:AddTimer(0.3,function()
                local NextOffset = self.List_Tab:GetScrollOffsetOfEnd()
                self.List_Tab:SetScrollOffset(NextOffset)
            end,false,0,nil,true)
        end
    elseif (self.GameInputModeSubsystem:GetCurrentInputType() ~= ECommonInputType.Gamepad) and self.LastIndex >= self.DisplayedWidgetsCount then
        self:ScrollToItemWithPadding(SelectActivityItem.Index, 0.05)
    end
end


-- 这个函数就是为了解决，SubTab选中时候会播一个动效，导致滚动过去显示不全的情况
function M:ScrollToItemWithPadding(Index, Padding)
    DebugPrint("JLYScrollToItemWithPadding", Index, Padding)
    if not self.List_Tab then return end

    if Index == nil or Index < 0 then return end

    local NumLiveWidgets = self:GetListViewContentMaxCount() - 1
    if NumLiveWidgets <= 0 then return end
    
    -- 获取当前滚动偏移量
    local CurrentScrollOffset = self.List_Tab:GetScrollOffset()
    if not CurrentScrollOffset then return end
    
    -- 计算可见区域的起始和结束位置
    local ViewStart = CurrentScrollOffset
    local ViewEnd = ViewStart + NumLiveWidgets - 1
    
    DebugPrint("JLYViewStart, ViewEnd", ViewStart, ViewEnd)
    -- 计算Padding对应的项目偏移量
    local PaddingOffset = Padding
    
    -- 计算新的滚动偏移量（IntoView模式）
    local NewScrollOffset = CurrentScrollOffset
    
    -- 如果目标Item在可见区域之外，需要滚动
    if Index - 1 < ViewStart then
        -- Item在可见区域上方，滚动到Item位置减去Padding
        NewScrollOffset = Index - 1
    elseif Index >= ViewEnd then
        -- Item在可见区域下方，滚动到Item位置减去可见区域大小再加上Padding
        NewScrollOffset = Index - NumLiveWidgets + PaddingOffset
    end
    -- 如果Item已经在可见区域内，不需要滚动
    DebugPrint("JLYNumLiveWidgets", NumLiveWidgets)
    DebugPrint("JLYNewScrollOffset", NewScrollOffset)
    -- 限制偏移量在有效范围内
    local TotalItems = self.List_Tab:GetNumItems()
    local MaxScrollOffset = math.max(0.0, TotalItems - NumLiveWidgets)
    NewScrollOffset = math.max(0.0, math.min(NewScrollOffset, MaxScrollOffset))
    -- 设置滚动偏移量
    self.List_Tab:SetScrollOffset(NewScrollOffset)
end

-- 为什么不用UIUtils.GetListViewContentMaxCount呢？
-- 因为这个函数会选中第一个Item来计算他的ItemSize，但是播了动效之后这个ItemSize是有问题的，只能自己实现一个简单版本得了
function M:GetListViewContentMaxCount()
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local ListSize = UIManager:GetWidgetRenderSize(self.List_Tab)
    local Parent = self.List_Tab:GetParent()
    if Parent:Cast(UScrollBox) then
        ListSize = UIManager:GetWidgetRenderSize(Parent)
    end
    local ItemWidget = nil
    -- 遍历self.List_Tab:GetDisplayedEntryWidgets()
    for _, Widget in pairs(self.List_Tab:GetDisplayedEntryWidgets()) do
        local index = Widget.Index or 0
        if Widget and Widget.IsTabSelected == false and index > 1 then
            ItemWidget = Widget
            break
        end
    end
    if ItemWidget == nil then
        return 10
    end
    local ItemSize = UIManager:GetWidgetRenderSize(ItemWidget.WidgetTree.RootWidget)
    if self.List_Tab.Orientation == EOrientation.Orient_Horizontal then 
        ListSize,ItemSize = ListSize.X,ItemSize.X + self.List_Tab.EntrySpacing
    elseif self.List_Tab.Orientation == EOrientation.Orient_Vertical then 
        ListSize,ItemSize = ListSize.Y,ItemSize.Y + self.List_Tab.EntrySpacing
    end
    local RawCount = (ListSize/ItemSize)-(self.List_Tab.EntrySpacing/ItemSize)
    local Count = math.ceil(RawCount-0.01)

    return Count
end


function M:UpdateTabRedInfoByActivityID(TabIndex, ActivityId)
    if (TabIndex == nil) then
        for k, v in pairs(self.AllCurrentActivityInfo) do
            for _, AId in ipairs(v) do
                if (AId == ActivityId) then
                    TabIndex = k
                    break
                end
            end
        end
    end
    if TabIndex == nil then
        return
    end
    local AllActivityInfo = self.AllCurrentActivityInfo[TabIndex]
    local IsShowNew, IsHaveReddotInTab = false, false
    for index, value in ipairs(AllActivityInfo) do
        local NewInfo = ActivityUtils.GetReddotCachInfoByKey("New", value)
        IsHaveReddotInTab = ActivityUtils.GetReddotCachInfoByKey("Red", value) == 1
        IsShowNew = NewInfo == 1 and not IsHaveReddotInTab
        if (IsShowNew or IsHaveReddotInTab) then
            break
        end
    end
    if TabIndex >= self.ActivityInfoIdxOffset then TabIndex = TabIndex - self.ActivityInfoIdxOffset end
end

function M:SetActivityComplete(EventID)
    for _, Widget in pairs(self.List_Tab:GetDisplayedEntryWidgets()) do
        if Widget and Widget.Content.EventId and Widget.Content.EventId[1] == EventID then
            Widget.Group_Done:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            break
        end
    end
    return true
end

-- 根据活动id拿代币栏信息
function M:GetActivityCoinBarInfoByActivityId(ActivityId)
    if ActivityId == nil then
        return nil
    end
    local EventConfig = DataMgr.EventMain[ActivityId]
    if EventConfig == nil then
        return nil
    end
    if EventConfig.EventCoinId == nil then
        return nil
    end
    if EventConfig.EventCoinCondition then
        local Avatar = GWorld:GetAvatar()
        if (ConditionUtils.CheckCondition(Avatar, EventConfig.EventCoinCondition) == false) then
            return nil
        end
    end
    return EventConfig.EventCoinId
end

function M:GetTopTabInfoByActivityId(ActivityId)
    local TopTabInfo = self:GetTopTabInfo()
    local CoinBarInfo = self:GetActivityCoinBarInfoByActivityId(ActivityId)
    if CoinBarInfo then
        TopTabInfo.OverridenTopResouces = CoinBarInfo
    end
    return TopTabInfo
end

return M

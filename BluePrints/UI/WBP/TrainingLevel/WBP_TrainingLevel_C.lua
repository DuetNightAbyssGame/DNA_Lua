--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local TimeUtils = require "Utils.TimeUtils"
---@type WBP_Activity_TrainingLevel_P_C
local M = Class({
    "BluePrints.UI.BP_UIState_C",
    "BluePrints.Common.TimerMgr",
})

local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

function M:InitUI()
    self.FocusWidgetName = "GetAllReward"
    self.FocusWidgetWidget = nil
    self.TrainingLevel_RewardBtn.Btn_TrainingLevelGetAll.OnClicked:Add(self, self.OnGetAllReward)
    self.TrainingLevel_RewardBtn.Text_TrainingLevelGetAll:SetText(GText("UI_Mail_Recieveall"))
    self:InitData()
    self:InitRewardList()
    self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    if (IsValid(self.GameInputModeSubsystem)) then
        self:UpdateUIByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType())
    end
    self.TrainingLevel_RewardBtn.Key_GetAll:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "A"
            }
        }
    })
    self.IsGettingRewards = false
end

function M:InitData()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.CurrentLevel = Avatar.Level
    self.eventData = DataMgr.PlayerLvEvent[self.CurActivityId]
    self.levels = {}
    for level, _ in pairs(self.eventData) do
        table.insert(self.levels, level)
    end
    table.sort(self.levels)
end

function M:InitRewardList()
    self.IsBtnForbidden = true
    if(not ModController:IsMobile()) then
        self.TrainingLevel_RewardBtn.Key_GetAll:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.FocusWidgetName = nil
        local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
        if ActivityMain then
            ActivityMain:UpdateActivityKeyTips()
        end
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local formattedLevel = "LV." .. tostring(self.CurrentLevel)
    self.TrainingLevel_LevelItem.Text_LevelNum:SetText(formattedLevel)
    self.TrainingLevel_LevelItem.Text_LevelTitle:SetText(GText("PlayerLv_Now"))
    local maxItems = math.min(#self.levels, 5)
    for i = 1, maxItems do
        local levelValue = self.levels[i]
        local textComponent = self["TrainingLevel_NumItem_" .. i].Text_LvNum
        -- 设置等级文本
        textComponent:SetText(tostring(levelValue))

        local TrainingLevelIconItem = self["TrainingLevel_IconItems_" .. i]
        local TrainingLevel_Point = self["TrainingLevel_Point_" .. i]
        local TrainingLevel_NumItem = self["TrainingLevel_NumItem_" .. i]
        local RewardInfo = DataMgr.Reward[self.eventData[levelValue].PlayerLvReward]
        local isGot = Avatar.ActivityPlayerLvRewardsGot:HasElement(self.CurActivityId,levelValue)
        local isSatisLevel = levelValue <= self.CurrentLevel
        local IsCanGet = isSatisLevel and not isGot
        if isSatisLevel then
            if isGot then
                TrainingLevel_Point:PlayAnimation(TrainingLevel_Point.Received)
                TrainingLevel_NumItem:PlayAnimation(TrainingLevel_NumItem.Received)
            else
                TrainingLevel_Point:PlayAnimation(TrainingLevel_Point.Complete)
                TrainingLevel_NumItem:PlayAnimation(TrainingLevel_NumItem.Complete)
                self.IsBtnForbidden = false
                self.FocusWidgetName = "GetAllReward"
                local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
                if ActivityMain then
                    ActivityMain:UpdateActivityKeyTips("GetAllReward")
                end
                if(not ModController:IsMobile() and self.CurInputDeviceType == ECommonInputType.Gamepad) then
                    self.TrainingLevel_RewardBtn.Key_GetAll:SetVisibility(UE4.ESlateVisibility.Visible)
                end
            end
        else
            TrainingLevel_Point:PlayAnimation(TrainingLevel_Point.Normal)
            TrainingLevel_NumItem:PlayAnimation(TrainingLevel_NumItem.Normal)
        end
        for j = 1, 2 do
            local RewardItem = TrainingLevelIconItem["TrainingLevel_IconItem_" .. j]
            local Content = {
                Count = RewardInfo.Count[j][1],
                Id = RewardInfo.Id[j],
                Icon = DataMgr[RewardInfo.Type[j]][RewardInfo.Id[j]].Icon,
                ItemType = RewardInfo.Type[j],
                Rarity = ItemUtils.GetItemRarity(RewardInfo.Id[j], RewardInfo.Type[j]),
                -- Uuid = RewardInfo.Id[j],
                bHasGot = isGot,
                IsShowDetails = true,
                OnMenuOpenChangedEvents = {
                    Obj = self,
                    Callback = self.MenuOpenChangedEvent
                }
            }
            if (ModController:IsMobile()) then
                RewardItem.WS_Item:SetActiveWidgetIndex(1)
                RewardItem.Com_Item_Universal_S.WidgetMap = nil
                RewardItem.Com_Item_Universal_S:Init(Content)
                if IsCanGet then
                    RewardItem.Com_Item_Universal_S:SetIsCanGet(true)
                end
            else
                RewardItem.WS_Item:SetActiveWidgetIndex(0)
                RewardItem.Com_Item_Universal_M.WidgetMap = nil
                RewardItem.Com_Item_Universal_M:Init(Content)
                if IsCanGet then
                    RewardItem.Com_Item_Universal_M:SetIsCanGet(true)
                end
            end

        end
    end
    if self.IsBtnForbidden then
        self.TrainingLevel_RewardBtn.Btn_TrainingLevelGetAll:SetForbidden(true)
    end
end

function M:OnGetAllReward()
    if self.IsBtnForbidden then
        return
    end
    if self.IsGettingRewards then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/confirm_click", nil, nil)
    local maxItems = math.min(#self.levels, 5)
    local allRewards = { Resources = {} }  -- 初始化合并后的奖励结构
    local pendingRequests = 0  -- 跟踪待处理的请求数量
    local hasRewardsToGet = false  -- 标记是否有奖励需要领取
    -- 先检查有多少奖励需要领取
    for i = 1, maxItems do
        local levelValue = self.levels[i]
        local isGot = Avatar.ActivityPlayerLvRewardsGot:HasElement(self.CurActivityId,levelValue)
        local isSatisLevel = levelValue <= self.CurrentLevel
        if isSatisLevel and not isGot then
            hasRewardsToGet = true
            pendingRequests = pendingRequests + 1
        end
    end
    -- 如果没有奖励需要领取，直接返回
    if not hasRewardsToGet then
        return
    end
    self.IsGettingRewards = true
    -- 领取所有奖励
    for i = 1, maxItems do
        local levelValue = self.levels[i]
        local isGot = Avatar.ActivityPlayerLvRewardsGot:HasElement(self.CurActivityId,levelValue)
        local isSatisLevel = levelValue <= self.CurrentLevel
        if isSatisLevel and not isGot then
            local function Callback(Ret, Rewards)
                if Ret ~= 0 then
                    self.IsGettingRewards = false
                    return
                end
                self:InitRewardList()
                -- 合并奖励
                if Rewards then
                    -- 遍历 Rewards 中的所有类别（Resources, Weapons 等）
                    for categoryName, categoryItems in pairs(Rewards) do
                        -- 确保 allRewards 中有这个类别
                        if not allRewards[categoryName] then
                            allRewards[categoryName] = {}
                        end
                        -- 遍历该类别中的所有项目
                        for itemId, itemInfo in pairs(categoryItems) do
                            -- 确保 allRewards 中该类别下有这个项目 ID
                            if not allRewards[categoryName][itemId] then
                                allRewards[categoryName][itemId] = {}
                            end
                            -- 如果 itemInfo 是表，则遍历其中的键值对
                            if type(itemInfo) == "table" then
                                for key, amount in pairs(itemInfo) do
                                    if allRewards[categoryName][itemId][key] then
                                        -- 如果这个键已经存在，增加数量
                                        allRewards[categoryName][itemId][key] = allRewards[categoryName][itemId][key] + amount
                                    else
                                        -- 如果这个键不存在，创建新条目
                                        allRewards[categoryName][itemId][key] = amount
                                    end
                                end
                            else
                                -- 如果 itemInfo 不是表（直接是数值），直接累加
                                if allRewards[categoryName][itemId] then
                                    if type(allRewards[categoryName][itemId]) == "table" then
                                        -- 如果已存在的是表，需要特殊处理
                                        -- 可能需要根据你的具体数据结构调整这部分逻辑
                                        DebugPrint("警告：尝试将数值与表合并：" .. categoryName .. "[" .. itemId .. "]")
                                    else
                                        allRewards[categoryName][itemId] = allRewards[categoryName][itemId] + itemInfo
                                    end
                                else
                                    allRewards[categoryName][itemId] = itemInfo
                                end
                            end
                        end
                    end
                end
                -- 减少待处理的请求数量
                pendingRequests = pendingRequests - 1
                -- 当所有请求都处理完毕时，显示奖励界面
                if pendingRequests == 0 then
                    self.IsGettingRewards = false
                    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, allRewards, false, nil, self)
                    ActivityUtils.TrySubActivityReddotCommon("Red", self.CurActivityId)
                    EventManager:FireEvent(EventID.OnUpdateActivityEvent, "TrainingLevelReward", self.CurActivityId)
                end
            end
            Avatar:CallServer("RpcActivityPlayerLvGetReward", Callback, self.CurActivityId, levelValue)
        end
    end
end

function M:HandlePreviewKeyDownInPage(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Gamepad_FaceButton_Right" and self.IsSelectItem and self.IsOpenTip == false) then
        self:SetFocus()
        self.IsSelectItem = false
        IsEventHandled = true
        local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
        if ActivityMain then
            ActivityMain:UpdateActivityKeyTips("CheckRewardView")
        end
        self.TrainingLevel_RewardBtn.Key_GetAll:SetVisibility(UE4.ESlateVisibility.Visible)
        IsEventHandled = true
    elseif (InKeyName == "SpaceBar") then
        self:OnGetAllReward()
        IsEventHandled = true
    end
    return IsEventHandled
end


function M:CleanSelf(bIsRemoveSelf)
    if (bIsRemoveSelf) then
        self:RemoveFromParent() 
    end
end

function M:HidePage(IsNeedPlayOutAnim)
    if (IsNeedPlayOutAnim) then
        self:PlayFadeOut()
    end
    self:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:PlayFadeOut(IsRemoveFromParent)
    -- 播放退场动画
    self:PlayAnimation(self.Out)
    if (IsRemoveFromParent) then
        self:BindToAnimationFinished(self.Out, {self, self.RemoveFromParent})
    end
end

function M:InitPage(ActivityId, ParentTabId, AllActivityId, ParentWidget)
    self.IsSelectItem = false
    self.IsOpenTip = false
    -- 初始化当前页面的信息
    self.CurSelectIndex = 1
    self.CurActivityId = ActivityId
    self.ParentTabId = ParentTabId
    self.AllActivityIds = AllActivityId
    self.ParentWidget = ParentWidget
    local ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
    if ModController:IsMobile() then
        self.ScrollBox_Desc:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.Text_ActivityDesc:SetText(GText(ActivityConfigData.EventDes))
    self.Text_ActivityDesc_White:SetText(GText(ActivityConfigData.EventDes))
    self.WBP_Activity_TrainingLevel_Title.Text_Title:SetText(GText(ActivityConfigData.EventName))
    self.WBP_Activity_TrainingLevel_Title.Text_SubTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:InitUI()

    for i = 1, 5 do
        local item = self["TrainingLevel_IconItems_" .. i]
        if item then
            -- 为每个项目的两个图标设置相同的导航规则
            for j = 1, 2 do
                local iconItem = item["TrainingLevel_IconItem_" .. j]
                -- 同时设置上下导航规则
                for _, direction in ipairs({EUINavigation.Up, EUINavigation.Down}) do
                    iconItem:SetNavigationRuleCustom(direction, {self, function()
                        return self:OnUINavigationItem(i, j, direction)
                    end})
                end

                if(j == 1) then
                    iconItem:SetNavigationRuleCustom(EUINavigation.Left, {self, function()
                        if (self.IsSelectItem and self.IsOpenTip == false) then
                            self:SetFocus()
                            self.IsSelectItem = false
                            local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
                            if ActivityMain then
                                ActivityMain:UpdateActivityKeyTips("CheckRewardView")
                            end
                            self.TrainingLevel_RewardBtn.Key_GetAll:SetVisibility(UE4.ESlateVisibility.Visible)
                        end
                    end})
                end
            end
        end
    end

    -- 刷新剩余时间
    local Avatar = GWorld:GetAvatar()
    local IsComplete = false
    if Avatar and self.FinishCondition then
        IsComplete = ConditionUtils.CheckCondition(Avatar, self.FinishCondition)
    end
    if IsComplete then
        local NextDayFiveStamp = TimeUtils.TimestampNextClock(5)
        local RemainActivityTimeDict = UIUtils.GetLeftTimeStrStyle2(NextDayFiveStamp)
        self.Activity_Time:SetTimeText(GText("UI_Event_RemoveRemainTime"), RemainActivityTimeDict)
    else
        self.Activity_Time:SetForeverTimeText(GText("UI_GameEvent_EventTimeRemain"))
    end
end

function M:OnUINavigationItem(index, iconIndex, direction)
    -- 根据方向调整索引
    local newIndex = index + (direction == EUINavigation.Up and 1 or -1)
    -- 检查索引是否在有效范围内
    if newIndex >= 1 and newIndex <= 5 then
        return self["TrainingLevel_IconItems_" .. newIndex]["TrainingLevel_IconItem_" .. iconIndex]
    end
    return nil
end


function M:GetPageConfigData()
    return DataMgr.PlayerLvEvent[self.CurActivityId]
end

function M:PlayFadeIn()
    self:PlayAnimation(self.In)
end

function M:UpdatePage(OperateSrc)
end

function M:ShowPage(IsNeedPlayInAnim)
    if (IsNeedPlayInAnim) then
        self:PlayFadeIn()
    end
    self:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    self:InitUI()
end

function M:HandleKeyDownInPage(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadButtonDown(InKeyName)
    else

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
        self:SetFocusToFirstAvailableReward()
        IsEventHandled = true
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonBottom and self.IsSelectItem == false) then
        self:OnGetAllReward()
        IsEventHandled = true
    end
    return IsEventHandled
end

function M:MenuOpenChangedEvent(IsOpened, Content)
    if ModController:IsMobile() then
        return
    end
    local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
    self.LastFocusWidget = Content.SelfWidget
    if IsOpened then
        self.IsOpenTip = true
        if ActivityMain then
            ActivityMain:UpdateActivityKeyTips("EmptyView")
        end
    else
        self.IsOpenTip = false
        if ActivityMain then
            ActivityMain:UpdateActivityKeyTips("SelectView")
        end
        self.LastFocusWidget:SetFocus()
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
        return
    end
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        DebugPrint("thy    已经显示的是该输入模式，不需要进行刷新")
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    self.IsSwitchDevice = true
    self:UpdateUIByInputDevice(self.CurInputDeviceType)
end

function M:UpdateUIByInputDevice(CurInputDeviceType)
    if(CurInputDeviceType == ECommonInputType.Gamepad) then
        self.TrainingLevel_RewardBtn.Key_GetAll:SetVisibility(UE4.ESlateVisibility.Visible)
    else
        if(not ModController:IsMobile()) then
            local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
            if ActivityMain then
                ActivityMain:UpdateActivityKeyTips(self.FocusWidgetName)
            end
            self.TrainingLevel_RewardBtn.Key_GetAll:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
end

function M:GetCurFocusWidgetInfo()
    self:UpdateUIByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType())
    return self.FocusWidgetName, self.FocusWidgetWidget
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

function M:OnSubTabNavigationRight()
    self:SetFocusToFirstAvailableReward()
end

function M:SetFocusToFirstAvailableReward()
    local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
    if ActivityMain then
        ActivityMain:UpdateActivityKeyTips("SelectView")
    end
    self.TrainingLevel_RewardBtn.Key_GetAll:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.IsSelectItem = true
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        -- 如果无法获取Avatar，默认聚焦第一项
        self.TrainingLevel_IconItems_1.TrainingLevel_IconItem_1:SetFocus()
        return true
    end
    -- 查找第一个未领取且等级满足的奖励项
    local maxItems = math.min(#self.levels, 5)
    local focusIndex = nil
    for i = 1, maxItems do
        local levelValue = self.levels[i]
        local isGot = Avatar.ActivityPlayerLvRewardsGot:HasElement(self.CurActivityId, levelValue)
        local isSatisLevel = levelValue <= self.CurrentLevel
        -- 如果等级满足且未领取，记录这个索引
        if isSatisLevel and not isGot then
            focusIndex = i
            break  -- 找到第一个就停止循环
        end
    end
    -- 设置焦点
    if focusIndex then
        -- 找到了未领取的奖励，聚焦到对应项
        self["TrainingLevel_IconItems_" .. focusIndex].TrainingLevel_IconItem_1:SetFocus()
    else
        -- 没有找到未领取的奖励，默认聚焦第一项
        self.TrainingLevel_IconItems_5.TrainingLevel_IconItem_1:SetFocus()
    end
end

function M:OnSpaceBarKeyDown()
    self:OnGetAllReward()
end

return M

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local RegionFameController = require("BluePrints.UI.WBP.Fame.RegionFameController")
local RegionFameModel = RegionFameController:GetModel()
---@type WBP_Fame_Main_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
local FameTaskType = {
    ["RecurringTask"] = 1,          -- 副本类型任务
    ["ReputationEntrust"] = 2,      -- 委托类型任务
}
---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
--     M.Super.Construct(self)
    
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    M.Super.Destruct(self)
    EventManager:RemoveEvent(EventID.RegionReputationsChange, self, self.RefreshUI)
    self:RemoveTimer("UpdateRefreshRemainingTime",true)
    
end
function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    -- local SceneId = ...
    -- self.CurRegionTabId

    --self.CurRegionTabId = tonumber(self.CurRegionTabId)
    self.UIName = "FameMain"
    self.Btn_Conquer.TextName:SetText(GText("RecurringTask_Title"))
    self.Btn_Gift.TextName:SetText(GText("ReputationEntrust_Title"))

    self.Btn_Conquer_Huaxu.TextName:SetText(GText("RecurringTask_Title"))
    self.Btn_Gift_Huaxu.TextName:SetText(GText("ReputationEntrust_Title"))

    self.Btn_Conquer:BindEventOnClicked(self, self.OnConquer)
    self.Btn_Gift:BindEventOnClicked(self, self.OnGift)

    self.Btn_Conquer_Huaxu:BindEventOnClicked(self, self.OnConquer)
    self.Btn_Gift_Huaxu:BindEventOnClicked(self, self.OnGift)

    self.Fame_Progress:BindEventOnClicked(self, self.OnOpenReward)

    self.Btn_Conquer.SoundFunc = self.ButtonClickSoundFunc
    self.Btn_Gift.SoundFunc = self.ButtonClickSoundFunc

    self.Btn_Conquer_Huaxu.SoundFunc = self.ButtonClickSoundFunc
    self.Btn_Gift_Huaxu.SoundFunc = self.ButtonClickSoundFunc

    self:InitRegionTab()
    --self:PlayAnimation(self.In)
    ReddotManager.AddListenerEx(self.UIName, self, self.OnFameMainReddotChange)
    ReddotManager.AddListenerEx(self.UIName, self, self.FameMainTabReddotChange)  
    ReddotManager.AddListenerEx("RecurringFameTask", self, self.OnFameMainReddotChange)
    ReddotManager.AddListenerEx("RecurringFameTask", self, self.FameMainTabReddotChange)
    ReddotManager.AddListenerEx("EntrustFameTask", self, self.OnFameMainReddotChange)
    ReddotManager.AddListenerEx("EntrustFameTask", self, self.FameMainTabReddotChange)
    EventManager:AddEvent(EventID.RegionReputationsChange, self, self.RefreshUI)

    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "Fame_Main", nil)

    -- self.Btn_Conquer:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    -- self.Btn_Conquer:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    -- self.Btn_Conquer:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    -- self.Btn_Conquer:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)

    
    -- self.Btn_Gift:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    -- self.Btn_Gift:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    -- self.Btn_Gift:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    -- self.Btn_Gift:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
end

function M:UpdateRefreshTime(RegionTabId)
    local EntrustTaskRefreshTimestamp = RegionFameModel:GetEntrustTaskRefreshTime(RegionTabId)
    if not EntrustTaskRefreshTimestamp then
        return
    end
    local RecurringTaskRefreshTimestamp = RegionFameModel:GetRecurringTaskRefreshTime(RegionTabId)
    rawset(self, "EntrustTaskRefreshTimestamp", EntrustTaskRefreshTimestamp)
    rawset(self, "RecurringTaskRefreshTimestamp", RecurringTaskRefreshTimestamp)

    self:AddTimer(0.01, function()
        self:UpdateRefreshRemainingTime()
    end)
    self:AddTimer(1, self.UpdateRefreshRemainingTime, true, 0, "UpdateRefreshRemainingTime", true)
end

function M:UpdateRefreshRemainingTime()

    if self.EntrustTaskRefreshTimestamp and self.RecurringTaskRefreshTimestamp then
        local RemainingTimeText1 = UIUtils.GetRemainingTimeByTimestamp(self.RecurringTaskRefreshTimestamp)
        local RemainingTimeText2 = UIUtils.GetRemainingTimeByTimestamp(self.EntrustTaskRefreshTimestamp)
        self.Btn_Conquer:SetTextRefresTime(RemainingTimeText1)
        self.Btn_Gift:SetTextRefresTime(RemainingTimeText2)

        self.Btn_Conquer_Huaxu:SetTextRefresTime(RemainingTimeText1)
        self.Btn_Gift_Huaxu:SetTextRefresTime(RemainingTimeText2)
    end
end

function M:InitRegionTabInfo()
    local AllRegionTabInfo = {}
    for key, TabData in pairs(DataMgr.RegionReputation) do
        local Locked = not RegionFameModel:CheckTabCondition(TabData.Condition)
        local LockToast = TabData.LockToast
        table.insert(AllRegionTabInfo, {Text=GText(TabData.RegionName), IconPath=TabData.RegionIconPath, TabId=key, IsLocked = Locked, LockReasonText = LockToast})
    end
    rawset(self, "AllRegionTabInfo", AllRegionTabInfo)
end

function M:FindRegionReputationIndexByRegionId()
    local TargetRegionId = WorldTravelSubsystem():GetCurrentSceneId()
    for repKey, repData in pairs(DataMgr.RegionReputation) do
        local regionList = repData.RegionId
        if regionList then
            for _, regionId in ipairs(regionList) do
                if regionId == TargetRegionId then
                    return repKey 
                end
            end
        end
    end
    return nil
end

function M:InitRegionTab()
    self:InitRegionTabInfo()
    self.Com_Tab:Init({
        LeftKey = "Q", RightKey = "E", Tabs = self.AllRegionTabInfo,
        DynamicNode={"Back", "ResourceBar", "BottomKey",},
        BottomKeyInfo = {
            {
                GamePadInfoList = {{Type="Img", ImgShortPath="A", Owner=self}}, Desc=GText("UI_Tips_Ensure")
            },
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf, Owner=self}}, Desc=GText("UI_BACK")
            }
        },
        StyleName = "Text",
        TitleName = GText("RegionReputation_Title"),
        OwnerPanel = self,
        BackCallback = self.CloseSelf
    })
    self.Com_Tab:BindEventOnTabSelected(self, self.OnRegionTabItemClick)

    local RegionTabId = self:FindRegionReputationIndexByRegionId()
    local SelectId = nil

    if RegionTabId and DataMgr.RegionReputation[RegionTabId] then
        local data = DataMgr.RegionReputation[RegionTabId]
        if RegionFameModel:CheckTabCondition(data.Condition) then
            SelectId = RegionTabId
        end
    end

    -- 如果没选到有效、已解锁的，就退回第一个
    if not SelectId then
        if self.AllRegionTabInfo[1] then
            SelectId = self.AllRegionTabInfo[1].TabId
        else
            -- 连 tab 都没有，直接返回
            return
        end
    end
    self:TrySelectRegionTabById(SelectId)

    if  CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        self.Com_Tab:Play_Com_Tab_M_In()
    else
        self.Com_Tab:Play_WBP_Com_Tab_P_In()
    end  
end


function M:TrySelectRegionTabById(targetTabId)
    if not targetTabId then return end

    local NewData = DataMgr.RegionReputation[targetTabId]
    if not NewData then
        return
    end

    -- 解锁判断
    if not RegionFameModel:CheckTabCondition(NewData.Condition) then
        -- UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(NewData.LockToast))

        --未解锁回退到当前 tab 或第一个 tab
        local FallbackId = self.CurRegionTabId or (self.AllRegionTabInfo[1] and self.AllRegionTabInfo[1].TabId)
        if FallbackId and FallbackId ~= targetTabId then
            self.Com_Tab:SelectTabById(FallbackId)
        end
        return
    end

    self.Com_Tab:SelectTabById(targetTabId)
end

function M:OnRegionTabItemClick(TabWidget)
    if not TabWidget then return end

    local NewTabId = TabWidget:GetTabId()
    local NewData = DataMgr.RegionReputation[NewTabId]
    if not NewData then
        return
    end

    rawset(self, "CurRegionTabId", NewTabId)
    rawset(self, "CurRegionData", NewData)

    -- 刷新 UI
    self:RefreshUI()
end


function M:RefreshUI()
    self:RefreshReputationData()
    self:RefreshUIBG()
    self:PlayAnimation(self.In)
    -- 切 Tab 时立即刷新
    self:RefreshCurRewardReddot()
    self:RefreshAllTabReddots()
end

function M:RefreshReputationData()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local AvatarReputation = Avatar.RegionReputations[self.CurRegionTabId]
    if not AvatarReputation then
        DebugPrint("[RefreshReputationData] AvatarReputation is Null")
        return
    end
    self.Fame_Progress:Init(self.CurRegionTabId,AvatarReputation)
    self:RemoveTimer("UpdateRefreshRemainingTime",true)
    self:UpdateRefreshTime(self.CurRegionTabId)
end

function M:RefreshUIBG()
    local RegionUIBG = self.CurRegionData and self.CurRegionData.RegionUIBG
    if self.RegionUIBG then
        if self.RegionUIBG == RegionUIBG then
            return
        end
    end
    self.RegionUIBG = RegionUIBG
    local Item = UIManager(self):CreateWidget(RegionUIBG)
    self.Bg0:ClearChildren()

    if Item then
        self.Bg0:AddChild(Item)

        -- 播放动画
        if Item.Loop then
            Item:PlayAnimation(Item.Loop, 0, 0)
        end

        -- Item.Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
        -- Item.Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
        if Item.In then
            Item:PlayAnimation(Item.In)
        end
    else
        DebugPrint("SL RegionTabUIBG Create Failed")
    end

    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:UpdateUIStyleInPlatform(false)
    else
        self:UpdateUIStyleInPlatform(true)
    end

    --刷新按钮样式
    local RegionUIButtonBGIndex = self.CurRegionData.RegionUIButtonBGIndex or 0
    self.Ws_BtnConquer:SetActiveWidgetIndex(RegionUIButtonBGIndex)
    self.Ws_BtnGift:SetActiveWidgetIndex(RegionUIButtonBGIndex)

end

function M:ButtonClickSoundFunc()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
end

function M:OnConquer()
    DebugPrint("SL OnConquer")
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    return UIManager:LoadUINew("FameTask", self.CurRegionTabId, FameTaskType.RecurringTask)
end

function M:OnGift()
    DebugPrint("SL OnGift")
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    return UIManager:LoadUINew("FameTask", self.CurRegionTabId, FameTaskType.ReputationEntrust)
end

function M:OnOpenReward()
    DebugPrint("SL OpenReward")
    --AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    return UIManager:LoadUINew("FameReward", self.CurRegionTabId)
end

function M:CloseSelf()
    if self:IsAnimationPlaying(self.Out) or self:IsAnimationPlaying(self.In) then
        return
    end
    AudioManager(self):SetEventSoundParam(self, "Fame_Main", {ToEnd = 1})
    -- AudioManager(self):SetEventSoundParam(self, "OpenShopMain", {ToEnd = 1})
    self:PlayAnimation(self.Out)
end

function M:OnFameMainReddotChange()
    self:RefreshCurRewardReddot()
end

function M:FameMainTabReddotChange()
    self:RefreshAllTabReddots()
end

function M:RefreshCurRewardReddot()
    local Show = false

    local Avatar = GWorld:GetAvatar()
    if Avatar and self.CurRegionTabId then
        local TreeNode = ReddotManager.GetTreeNode(self.UIName)
        if TreeNode and TreeNode.Count > 0 then
            Show = Avatar:HasAnyRewardUpToCurLevel(self.CurRegionTabId)
        end
    end

    if self.Fame_Progress and self.Fame_Progress.Reddot then
        self.Fame_Progress.Reddot:SetVisibility(
            Show and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed
        )
    end

    -- 刷新副本任务红点
    self:RefreshRecurringTaskReddot()
    -- 刷新委托任务红点
    self:RefreshEntrustTaskReddot()
end

-- 刷新副本任务红点
function M:RefreshRecurringTaskReddot()
    local bHasCanClaim = false
    local AllCanClaimTasks = RegionFameModel:GetTargetRegionAllCanClaimRecurringTasks(self.CurRegionTabId)
    if AllCanClaimTasks and #AllCanClaimTasks > 0 then
        bHasCanClaim = true
    end

    if self.Btn_Conquer and self.Btn_Conquer.Reddot then
        self.Btn_Conquer.Reddot:SetVisibility(
            bHasCanClaim and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed
        )
    end

    if self.Btn_Conquer_Huaxu and self.Btn_Conquer_Huaxu.Reddot then
        self.Btn_Conquer_Huaxu.Reddot:SetVisibility(
            bHasCanClaim and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed
        )
    end
end

-- 刷新委托任务红点
function M:RefreshEntrustTaskReddot()
    local bHasCanClaim = RegionFameModel:GetTargetRegionEntrustTaskCanSubmit(self.CurRegionTabId)

    if self.Btn_Gift and self.Btn_Gift.Reddot then
        self.Btn_Gift.Reddot:SetVisibility(
            bHasCanClaim and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed
        )
    end

    if self.Btn_Gift_Huaxu and self.Btn_Gift_Huaxu.Reddot then
        self.Btn_Gift_Huaxu.Reddot:SetVisibility(
            bHasCanClaim and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed
        )
    end
end

-- 刷新上方页签红点
function M:RefreshAllTabReddots()
    if not self.Com_Tab then return end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        for _, RegionCfg in pairs(DataMgr.RegionReputation) do
            self.Com_Tab:ShowTabRedDotByTabId(RegionCfg.ReputationID, false, false, false)
        end
        return
    end

    local TreeNode = ReddotManager.GetTreeNode(self.UIName)
    local HasAny = (TreeNode and TreeNode.Count > 0)

    if not HasAny then
        -- 没有任何奖励一次性清掉所有 Tab 红点
        for _, RegionCfg in pairs(DataMgr.RegionReputation) do
            self.Com_Tab:ShowTabRedDotByTabId(RegionCfg.ReputationID, false, false, false)
        end
        -- return
    end

    -- 有奖励逐个 Tab 判断
    for _, RegionCfg in pairs(DataMgr.RegionReputation) do
        local TabRed, _ = Avatar:HasAnyRewardUpToCurLevel(RegionCfg.ReputationID)
        -- 进一步判断副本任务奖励红点
        local AllCanClaimTasks = RegionFameModel:GetTargetRegionAllCanClaimRecurringTasks(RegionCfg.ReputationID)
        -- 进一步判断委托任务奖励红点
        local CanSubmitEntrustTask = RegionFameModel:GetTargetRegionEntrustTaskCanSubmit(RegionCfg.ReputationID)
        
        TabRed = TabRed or (AllCanClaimTasks and #AllCanClaimTasks > 0) or CanSubmitEntrustTask
        self.Com_Tab:ShowTabRedDotByTabId(RegionCfg.ReputationID, false, TabRed, false)
    end
end



function M:Close()
    self.Super.Close(self)
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Out then
        self:Close()
    elseif InAnimation == self.In then
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        if (InKeyName == "Escape") then
            IsEventHandled = true
            self:CloseSelf()
        elseif InKeyName == "Q" then
            if self.Com_Tab then
                self.Com_Tab:TabToLeft()
                IsEventHandled = true
            end
        elseif InKeyName == "E" then
            if self.Com_Tab then
                self.Com_Tab:TabToRight()
                IsEventHandled = true
            end
        end
    end
   
    if IsEventHandled then
        return UWidgetBlueprintLibrary.Handled()
    else
        return UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnGamePadDown(InKeyName)
    DebugPrint("SL OnGamePadDown is InKeyName Detail", InKeyName)
    local IsEventHandled = false
    if InKeyName == "Gamepad_FaceButton_Right" then
        self:CloseSelf()
        IsEventHandled = true
    end

    if InKeyName == "Gamepad_LeftShoulder" or InKeyName == "Gamepad_RightShoulder" then
        if self.Com_Tab then
            self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
            IsEventHandled = true
        end
        ---左边菜单键打开奖励
    elseif InKeyName == "Gamepad_Special_Left" then
        self.Fame_Progress:OnClicked()
        IsEventHandled = true
        ---X按键打开副本类任务
    elseif InKeyName == "Gamepad_FaceButton_Left" then
        self.Btn_Conquer:OnClicked()
        IsEventHandled = true
        ---Y按键提交类任务
    elseif InKeyName == "Gamepad_FaceButton_Top" then
        self.Btn_Gift:OnClicked()
        IsEventHandled = true
    end
    return IsEventHandled
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if not IsUseKeyAndMouse and (self:HasFocusedDescendants() or self:HasAnyUserFocus()) then
        self:SetFocus()
    end
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)

    --self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        self.Btn_Conquer.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Gift.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)

        self.Btn_Conquer_Huaxu.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Gift_Huaxu.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)

        self.Fame_Progress.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end
    --如果是pc或者特殊原因需要显示为pc时
    if (IsUseKeyAndMouse) then
        self.Fame_Progress.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Conquer.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Gift.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)

        self.Btn_Conquer_Huaxu.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Gift_Huaxu.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        
        self.Fame_Progress.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Fame_Progress.WBP_Com_KeyImg:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "View",
                }
            },
        })

        self.Btn_Conquer.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Conquer.WBP_Com_KeyImg:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "X",
                }
            },
        })

        self.Btn_Gift.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Gift.WBP_Com_KeyImg:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "Y",
                }
            },
        })

        self.Btn_Conquer_Huaxu.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Conquer_Huaxu.WBP_Com_KeyImg:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "X",
                }
            },
        })

        self.Btn_Gift_Huaxu.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Gift_Huaxu.WBP_Com_KeyImg:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "Y",
                }
            },
        })
    end
end

-- function M:OnFocusReceived(MyGeometry, InFocusEvent)
--     if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
--         if self:HasFocusedDescendants() or self:HasAnyUserFocus() then
--             self:SetFocus()
--         end
--     end
--     return UE4.UWidgetBlueprintLibrary.Unhandled()
-- end

return M

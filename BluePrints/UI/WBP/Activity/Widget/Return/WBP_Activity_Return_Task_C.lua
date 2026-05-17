--
-- DESCRIPTION
--
-- @COMPANY ** 回归活动——任务界面
-- @AUTHOR ** lhr
--
require "UnLua"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"
local ReturnUtils = require "BluePrints.UI.WBP.Activity.Widget.Return.ReturnUtils"
local ReturnModel = require "BluePrints.UI.WBP.Activity.Widget.Return.Activity_Return_TaskReward_Model"

---@type WBP_Activity_Return_Task_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.TimerMgr"})

function M:Construct()
    self.CurrTabIdx = -1
    self.QuestPhasedIds = {}
    self.ListItemNum = 0
    self:ConstructProgressReward()
    self.List_Item.BP_OnEntryInitialized:Add(self,self.OnTaskItemInited)

    EventManager:AddEvent(EventID.OnComeBackNewPhaseUnlocked, self, self.OnNewPhaseUnlocked)

    self:InitGamepadKey()
end

function M:ConstructProgressReward()
    self.RewardCanReceive = {}
    self.ProgressRewardItems = {}
    for i = 1, 5, 1 do
        local ProgressRewardItem = self.RewardContent_OneClick["ProgressItem_"..i]
        if IsValid(ProgressRewardItem) then
            ProgressRewardItem:StopAllAnimations()
            ProgressRewardItem:PlayAnimation(ProgressRewardItem.Normal)
            ProgressRewardItem.Reddot:SetVisibility(ESlateVisibility.Collapsed)
            ProgressRewardItem.ProgressBarReward:SetPercent(0.0)
            ProgressRewardItem.Btn_Click.OnClicked:Add(self, function()
                self:OnRewardItemClicked(i)
            end)
            table.insert(self.ProgressRewardItems, ProgressRewardItem)
        end
    end
    self.ProgressText = self.RewardContent_OneClick.Text_RewardNum
    self.Btn_ReceiveAll = self.RewardContent_OneClick.Btn_OneClick
    self.Btn_ReceiveAll:SetText(GText("UI_Archive_CollectionClaimAll"))
    self.Btn_ReceiveAll.AudioEventPath = "event:/ui/activity/feina_tab_btn_click"
end

function M:Destruct()
    EventManager:RemoveEvent(EventID.OnComeBackNewPhaseUnlocked, self)

    self:CleanTimer()
    self:RefreshWidgetReddot()
    if IsValid(self.ParentWidget) then
        self.ParentWidget:BlockAllUIInput(false)
    end
    self:StopAllAnimations()
    self.InitParams = nil
    self.ParentWidget = nil
end

function M:Init(InitParams)
    self.InitParams = InitParams
    self.CurActivityId = InitParams.CurActivityId
    self.ParentWidget = InitParams.OwnerPanel
    self:InitBtnEvents()
    self:InitQuestInfo()
    
    self:PlayAnimation(self.In)
    self.IsGamepad = UIUtils.IsGamepadInput()
    self:SwitchUIType(self.IsGamepad)

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        GWorld.logger.error("Activity_Return_Task: Avatar is nil")
        return
    end
    Avatar:RequestSyncNowTime(function()
        if IsValid(self) then
            self:InitTable()
            self:InitWidgetReddot()
        end
    end)
end

function M:ReceiveEnterState()
    self:RefreshList()
end

function M:OnTaskItemInited(Content, Widget)
    if not IsValid(Content) or not Content.ConfigData then return end
    if not IsValid(Widget) then return end
    local ConfigData = Content.ConfigData
    local ReceriveBtn = Widget.Btn_Reward
    if IsValid(ReceriveBtn) then
        ReceriveBtn.AudioEventPath = "event:/ui/activity/feina_tab_btn_click"
    end
    local GotoBtn = Widget.Btn_Goto
    if IsValid(GotoBtn) then
        GotoBtn:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        GotoBtn:UnBindEventOnClickedByObj(self)
        if ConfigData.JumpUIId then
            GotoBtn:BindEventOnClicked(self, function()
                PageJumpUtils:JumpToTargetPageByJumpId(ConfigData.JumpUIId)
            end)
        end
    end
    if ConfigData.RewardsGot then
        Widget:PlayAnimation(Widget.Received)
    elseif ConfigData.CanReceive then
        Widget:PlayAnimation(Widget.Finish)
    else
        Widget:PlayAnimation(Widget.Normal)
    end
end

function M:InitBtnEvents()
    self.Btn_ReceiveAll:UnBindEventOnClickedByObj(self)
    self.Btn_ReceiveAll:BindEventOnClicked(self, self.OnReceiveAllClicked)
end

function M:InitGamepadKey()
    self.Btn_ReceiveAll:SetDefaultGamePadImg("Y")
    self.Btn_ReceiveAll:SetGamePadIconVisible(true)
    self.KeyReceive = self.RewardContent_OneClick.Com_KeyTextDesc
    self.KeyReceive:CreateCommonKey({
        KeyInfoList = {
            {
                ImgShortPath = "X",
                Type = "Img",
            }
        },
        Desc = ""
    })
end

function M:UpdateKeyDesc(Desc)
    self.KeyReceive:CreateCommonKey({
        KeyInfoList = {
            {
                ImgShortPath = "X",
                Type = "Img",
            }
        },
        Desc = Desc
    })
end

function M:InitTable()
    local SubTabList  = {}
    local Avatar = GWorld:GetAvatar()
    local PhaseUnlockInterval = self.QuestConfig and self.QuestConfig.PhaseUnlockInterval
    for Index = 1, 3, 1 do
        table.insert(SubTabList,{
            Text = GText("UI_Char_Data_Step_"..Index),
            TabId = Index,
            IsLocked = Avatar and not Avatar:IsComeBackPhaseUnlocked(self.CurActivityId, Index, PhaseUnlockInterval), 
            LockReasonText = self:GetTabUnlockTime(Index),
        })
    end
    self.SubTabList = SubTabList
    self.Com_TabSub:Init( { 
            LeftKey = "Q", 
            RightKey = "E",
            LeftGamePadKey = "LeftShoulder",
            RightGamePadKey = "RightShoulder",
            PlatformName = self.Platform,
            ChildWidgetName = "ActivityReturnTabSubItem01",
            Tabs = self.SubTabList 
        } )
    self.Com_TabSub:BindEventOnTabSelected(self, self.OnTabSelected)
    self.bIniting = true
    self.Com_TabSub:SelectTab(1)
    self.bIniting = false

    self:AddTimer(60, self.RefreshTabUnlockTime, true, nil, "RefreshTabUnlockTime", true)
end

function M:OnNewPhaseUnlocked()
    if not self.SubTabList then return end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local PhaseUnlockInterval = self.QuestConfig and self.QuestConfig.PhaseUnlockInterval
    for Index = 1, 3, 1 do
        local TabInfo = self.SubTabList[Index]
        if TabInfo then
            if TabInfo.IsLocked and Avatar:IsComeBackPhaseUnlocked(self.CurActivityId, Index, PhaseUnlockInterval) then
                TabInfo.IsLocked = false
                self.Com_TabSub:UnLockTabByIndex(true, Index)
                self.Com_TabSub:ShowTabRedDot(Index, true, false, false)
            end
        end
    end
    self:RefreshTabUnlockTime()
end

function M:RefreshTabUnlockTime()
    if not self.SubTabList then return end
    for Index = 1, 3, 1 do
        local TabInfo = self.SubTabList[Index]
        if TabInfo and TabInfo.IsLocked then
            TabInfo.LockReasonText = self:GetTabUnlockTime(Index)
        end
    end
end

function M:GetTabUnlockTime(Index)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return "" end
    local PhaseUnlockInterval = self.QuestConfig and self.QuestConfig.PhaseUnlockInterval
    return string.format(GText("UI_ComeBackEvent_Toast_QuestPhaseUnlockTime"), Avatar:GetPhaseUnlockTime(Index, PhaseUnlockInterval))
end

function M:OnTabSelected(TabWidget)
    local Index = TabWidget.Idx
    self:TryDecreaseTabReddot(Index)
    self.CurrTabIdx = Index
    self:RefreshList()
end

function M:InitQuestInfo()
    if not self.CurActivityId then
        GWorld.logger.error("Activity_Return_Task: CurActivityId is nil")
        return
    end
    local ComeBackQuestConf = ReturnUtils.GetCurrentComeBackQuestInfo(self.CurActivityId)
    if not ComeBackQuestConf then
        GWorld.logger.error("Activity_Return_Task: ComeBackQuestConf is nil")
        return
    end
    self.QuestConfig = ComeBackQuestConf
    self.QuestPhasedIds = ComeBackQuestConf.QuestPhase

    self:InitResourceIcon()
    self:RefreshRewardItems()
end

function M:InitResourceIcon()
    local ResourceIcon = self.RewardContent_OneClick.Icon_Reward
    local ProgressResourceId = self.QuestConfig.QuestProgressResource
    local ResourceData = DataMgr.Resource[ProgressResourceId]
    local Texture = LoadObject(ResourceData and ResourceData.Icon)
    if IsValid(Texture) then
       ResourceIcon:SetBrushResourceObject(Texture)
    end
end

function M:RefreshRewardItems()
    if not self.CurActivityId then return end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    if not self.QuestConfig then return end
    self.ComeBackData = Avatar:GetCurrentComeBackData(self.CurActivityId)
    if not self.ComeBackData then
        GWorld.logger.error("Activity_Return_Task: ComeBackData is nil，EventId:"..self.CurActivityId)
        return
    end
    local RewardProgressConfig = self.QuestConfig.QuestRewardProgress
    local ProgressNum = self.ComeBackData.QuestProgress
    self.ProgressText:SetText(ProgressNum)
    local LastItem = nil
    local LastProgress = 0
    local LastProgressReached = true
    for Idx, Progress in ipairs(RewardProgressConfig) do
        local RewardItem = self.ProgressRewardItems[Idx]
        RewardItem.Text_ProgressNum:SetText(Progress)
        if ProgressNum >= Progress then
            if not self.ComeBackData:HasGotProgressReward(Idx) then
                RewardItem:StopAllAnimations()
                RewardItem:PlayAnimation(RewardItem.Reward)
                RewardItem.Reddot:SetVisibility(ESlateVisibility.HitTestInvisible)
                self.RewardCanReceive[Idx] = true
            else
                RewardItem:StopAllAnimations()
                RewardItem:PlayAnimation(RewardItem.Received)
                RewardItem.Reddot:SetVisibility(ESlateVisibility.Collapsed)
                self.RewardCanReceive[Idx] = nil
            end
            if LastItem then
                LastItem.ProgressBarReward:SetPercent(1.0)
            end
        else
            RewardItem:StopAllAnimations()
            RewardItem:PlayAnimation(RewardItem.Normal)
            RewardItem.Reddot:SetVisibility(ESlateVisibility.Collapsed)
            self.RewardCanReceive[Idx] = nil

            if LastItem then
                local ProgressPercent = 0.0
                if LastProgressReached then
                    LastProgressReached = false
                    local Capacity = Progress - LastProgress
                    local Filled = ProgressNum - LastProgress
                    ProgressPercent = Filled / Capacity
                end
                LastItem.ProgressBarReward:SetPercent(ProgressPercent)
            end
        end
        LastItem = RewardItem
        LastProgress = Progress
    end
    local Desc = ""
    if next(self.RewardCanReceive) ~= nil then
        Desc = GText("UI_Disptach_TakeReward")
    else
        Desc = GText("UI_Controller_CheckDetails")
    end
    self:UpdateKeyDesc(Desc)
end

function M:RefreshList()
    self.List_Item:ClearListItems()
    local CurQuestList = ReturnModel:GetReturnQuestContents(self.CurActivityId, self.CurrTabIdx, self) or {}
    local Count=0
    local Contents = {}
    for _, Item in ipairs(CurQuestList) do
        local NewContent = NewObject(UIUtils.GetCommonItemContentClass())
        NewContent.Owner = self
        NewContent.ConfigData = Item
        NewContent.OnGetReward = function(bReceived)
            if bReceived then
                self:RefreshRewardItems()
                self:OnQuestRewardRecvd(NewContent)
                self:RefreshItems()
            end
        end
        if Item.CanReceive then
            Count=Count+1
        end
        table.insert(Contents, NewContent)
    end
    self:SortList(Contents)
    for Idx, Content in ipairs(Contents) do
        self.List_Item:AddItem(Content)
    end

    if Count>0 or ReturnModel:CheckHaveProgressRewardToGet() then
        self:RefreshButton(true)
    else
        self:RefreshButton(false)
    end

    if self.IsGamepad then
        if not self.bIniting then
            self:DelaySetFocusTarget(true)
        end
    end

    self.ListItemNum = #CurQuestList
end

function M:SortList(InOutItems)
    if not InOutItems then
        return
    end
    table.sort(InOutItems, function(a,b)
        return self:CompareItem(a,b)
    end)
end

function M:CompareItem(ItemA, ItemB)
    local a, b = ItemA.ConfigData, ItemB.ConfigData
    if a.CanReceive and not b.CanReceive then
        return true
    elseif not a.CanReceive and  b.CanReceive then
        return false
    elseif a.RewardsGot and not b.RewardsGot then
        return false
    elseif not a.RewardsGot and b.RewardsGot then
        return true
    end
    if a.SourceNum and b.SourceNum then
        return a.SourceNum<b.SourceNum
    else
        return false
    end
end

function M:RefreshItems()
    local Items = self.List_Item:GetListItems()
    ULowEntryExtendedStandardLibrary.SortObjectArrayDirectly(Items, {self, self.CompareItem}, false)
    self.List_Item:BP_SetListItems(Items)
end

function M:OnQuestRewardRecvd(Content)
    if not IsValid(Content) or not IsValid(Content.SelfWidget) then return end
    local ItemUIs = Content.SelfWidget.UsedList:GetDisplayedEntryWidgets()
    for _, RewardIcon in pairs(ItemUIs) do
        if IsValid(RewardIcon) then
            RewardIcon:SetIsGot(true)
        end
    end
    if not Content.ConfigData then return end
    local Rewards = Content.ConfigData.Rewards or {}
    for _, Reward in pairs(Rewards) do
        Reward.bHasGot = true
    end
end

function M:InitWidgetReddot()
    if not ReddotManager.GetTreeNode(ReturnUtils.ReddotTaskQuestKey) then
        ReddotManager.AddNodeEx(ReturnUtils.ReddotTaskQuestKey)
    end
    if not ReddotManager.GetTreeNode(ReturnUtils.ReddotTaskNewKey) then
        ReddotManager.AddNodeEx(ReturnUtils.ReddotTaskNewKey)
    end
    ReturnUtils.ReturnAddReddotListener(self,"ComeBackTask",function(Obj, Count, ReddotType, Name)
        local QuestCacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReturnUtils.ReddotTaskQuestKey)
        local NewCacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReturnUtils.ReddotTaskNewKey)
        -- local Node1 = ReddotManager.GetTreeNode(ReturnUtils.ReddotTaskQuestKey)
        -- local Node2 = ReddotManager.GetTreeNode(ReturnUtils.ReddotTaskNewKey)
        -- local Node3 = ReddotManager.GetTreeNode(ReturnUtils.ReddotTaskRewardKey)
        -- DebugPrint("lhr1@ReddotListener", Count, Node1.Count, Node2.Count, Node3.Count)
        for Index = 1, 3, 1 do
            local IsLocked = self.SubTabList[Index].IsLocked
            if not IsLocked and Count > 0 then
                local QuestPhaseId = self.QuestPhasedIds[Index]
                if QuestCacheDetail[QuestPhaseId] then
                    self.Com_TabSub:ShowTabRedDot(Index, false, true, false)
                    goto continue
                end
                if NewCacheDetail[Index] == false then
                    self.Com_TabSub:ShowTabRedDot(Index, true, false, false)
                    goto continue
                end
            end
            self.Com_TabSub:ShowTabRedDot(Index, false, false, false)
            ::continue::
        end
    end)
end

function M:RefreshWidgetReddot()
    ReturnUtils.ReturnRemoveReddotListener(self, "ComeBackTask")
    ReturnUtils.RefreshComeBackTaskNewReddot()
    ReturnUtils.RefreshComeBackTaskQuestReddot()
    ReturnUtils.RefreshComeBackTaskRewardReddot()
end

function M:TryDecreaseTabReddot(Index)
    if ReddotManager.GetTreeNode(ReturnUtils.ReddotTaskNewKey) then
        local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReturnUtils.ReddotTaskNewKey)
        if CacheDetail[Index] == false then
            CacheDetail[Index] = true
            local Node = ReddotManager.GetTreeNode("ComeBackTask")
            -- DebugPrint("lhr1@TryDecreaseTabReddot", Node.Count, CacheDetail.Count)
            ReddotManager.DecreaseLeafNodeCount(ReturnUtils.ReddotTaskNewKey, 1)
            ActivityReddotHelper.RefreshReddotNode(self.CurActivityId)
            Node:TryFireOnCountChange(Node.Count, true)
            -- DebugPrint("lhr1@TryDecreaseTabReddot1", Node.Count, CacheDetail.Count)
        end
    end
end

function M:RefreshButton(CanReceiveAll)
    if not CanReceiveAll then
        self.Btn_ReceiveAll:ForbidBtn(true)
    else
        self.Btn_ReceiveAll:ForbidBtn(false)
    end
end

function M:OnReceiveAllClicked()
    self.ParentWidget:BlockAllUIInput(true)
    local Params = {
        Callback = function()
            self.ParentWidget:BlockAllUIInput(false)
            self:RefreshItems()
            self:RefreshRewardItems()
            self.IsGettingReward = false
        end,
        OnGetReward = function(Content)
            self:OnQuestRewardRecvd(Content)
        end,
        EventId = self.CurActivityId,
        QuestPhaseId = self.QuestPhasedIds[self.CurrTabIdx],
    }
    if not self.IsGettingReward then
        self.IsGettingReward = true
        ReturnModel:GetAllRewards(self, Params)
    end
end

function M:OnRewardItemClicked(Index)
    AudioManager(self):PlayUISound(self, "event:/ui/activity/feina_gift_day_sort_btn_click", nil, nil)
    if not self.RewardCanReceive then return end
    if Index and self.RewardCanReceive[Index] then
        self.ParentWidget:BlockAllUIInput(true)
        local Params = {
            Callback = function()
                self.ParentWidget:BlockAllUIInput(false)
                self:RefreshRewardItems()
                self.IsGettingReward = false
            end,
            EventId = self.CurActivityId,
            QuestPhasedId = self.QuestPhasedIds[self.CurrTabIdx],
        }
        if not self.IsGettingReward then
            self.IsGettingReward = true
            ReturnModel:GetProgressReward(self, Params)
        end
    else
        self:ShowRewardPreviewPopup()
    end
end

local TypeSort = {
    Char = 1,
    Weapon = 2,
    Mod = 3,
    Draft = 4,
    Reward = 5,
    Resource = 6,
}

function M:ShowRewardPreviewPopup()
    if not self.QuestConfig then return end
    local Progresses = self.QuestConfig.QuestRewardProgress
    local ProgressRewards = self.QuestConfig.QuestReward

    local SortFunc = function(A, B)
        if A.Rarity == B.Rarity then
            if TypeSort[A.ItemType] and TypeSort[B.ItemType] then
                if TypeSort[A.ItemType] == TypeSort[B.ItemType] then
                    return A.ItemId < B.ItemId
                end
                return TypeSort[A.ItemType] < TypeSort[B.ItemType]
            end
            return A.ItemId < B.ItemId
        end
        return A.Rarity > B.Rarity
    end

    local DataMap = {}
    for Idx, Progress in ipairs(Progresses) do
        local RewardId = ProgressRewards[Idx]
        local RewardInfo = DataMgr.Reward[RewardId]
        if RewardInfo then
            local Ids = RewardInfo.Id
            local RewardCount = RewardInfo.Count
            local TableName = RewardInfo.Type
            local RewardList = {}
            for i = 1, #Ids do
                local ItemData = {}
                ItemData.ItemId = Ids[i]
                ItemData.Count = RewardUtils:GetCount(RewardCount[i])
                ItemData.Icon = ItemUtils.GetItemIconPath(ItemData.ItemId, TableName[i])
                ItemData.Rarity = ItemUtils.GetItemRarity(ItemData.ItemId, TableName[i])
                ItemData.ItemType = TableName[i]
                table.insert(RewardList, ItemData)
            end
            table.sort(RewardList, SortFunc)
            DataMap[Progress] = RewardList
        end
    end

    local Params = {}
    Params.DataMap = DataMap
    Params.OnCloseCallbackObj = self
    Params.OnCloseCallbackFunction = function()
        self.PreviewPopup = nil
    end
    self.PreviewPopup = UIManager(self):ShowCommonPopupUI(100181, Params, self)
end

function M:OnSubTabNavigationRight()
    self:UpdateUIStyle(true)
    self:SetFocusTarget()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.IsGamepad then
        self:SetFocusTarget()
    end
    return UIUtils.Handled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        if InKeyName == "Q" or InKeyName == "E" then
            IsEventHandled = self.Com_TabSub:Handle_KeyEventOnPC(InKeyName)
        else

        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == "Gamepad_LeftShoulder" or InKeyName == "Gamepad_RightShoulder"  then
        IsEventHandled = self.Com_TabSub:Handle_KeyEventOnGamePad(InKeyName)
    elseif InKeyName == "Gamepad_FaceButton_Left" then
        if not self.PreviewPopup then
            local Index = next(self.RewardCanReceive)
            self:OnRewardItemClicked(Index)
        end
    elseif (InKeyName == "Gamepad_FaceButton_Right") then
        if (self.ParentWidget and (self:HasAnyUserFocus() or self:HasFocusedDescendants())) then
            IsEventHandled = true
            self.ParentWidget:OnReturnKeyDown()
            self.HandleFocus = false
        end
    end   
    return IsEventHandled
end

function M:ShowGamepadViewBtn(bShow)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if bShow then
        self.ParentWidget.Com_Tab_P:UpdateBottomKeyInfo({
            {
                GamePadInfoList =  {{ Type="Img", ImgShortPath="LS", Owner=self }},
                Desc = GText("UI_Controller_CheckReward"),
                bLongPress = false,
            },
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}}, 
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnReturnKeyDown, Owner=self}},
                Desc = GText("UI_BACK"),
                bLongPress = false,
            },
        })
    else 
       self.ParentWidget.Com_Tab_P:UpdateBottomKeyInfo({
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}}, 
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnReturnKeyDown, Owner=self}},
                Desc = GText("UI_BACK"),
                bLongPress = false,
            },
        })
    end
end

function M:ShowGamepadViewSingleBtn(bShow)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if bShow then
        self.ParentWidget.Com_Tab_P:UpdateBottomKeyInfo({
            {
                GamePadInfoList =  {{ Type="Img", ImgShortPath="A", Owner=self }},
                Desc = GText("UI_Controller_CheckDetails"),
                bLongPress = false,
            },
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}}, 
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnReturnKeyDown, Owner=self}},
                Desc = GText("UI_BACK"),
                bLongPress = false,
            },
        })
    else 
        self.ParentWidget.Com_Tab_P:UpdateBottomKeyInfo({
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}}, 
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnReturnKeyDown, Owner=self}},
                Desc = GText("UI_BACK"),
                bLongPress = false,
            },
        })
    end
end

function M:RefreshOpInfoByInputDevice()
    if UIUtils.IsGamepadInput() then
        if not self.IsMenuOpen then
            self:SwitchUIType(true)
            self:SetFocusTarget()
        end
        self.IsGamepad = true
    else
        self:SwitchUIType(false)
        self.IsGamepad = false
    end
end

function M:OnMenuOpenChanged(bIsOpen)
    if UIUtils.IsGamepadInput() then
        if bIsOpen then
            self:SwitchUIType(false)
            self:UpdateUIStyle(false)
        else
            self:SwitchUIType(true)
            self:UpdateUIStyle(true)
        end
    end
    self.IsMenuOpen = bIsOpen
end

-- 切换手柄图标显示
function M:SwitchUIType(IsGamepad)
    if IsGamepad then
        self.KeyReceive:SetVisibility(ESlateVisibility.HitTestInvisible)
    else
        self.KeyReceive:SetVisibility(ESlateVisibility.Collapsed)
    end
end

-- 更改底部Tab快捷键样式
function M:UpdateUIStyle(IsGamepad)
    if IsGamepad then
        if self.IsInViewMode then
            self:ShowGamepadViewSingleBtn(true)
        else
            self:ShowGamepadViewBtn(true)
        end
    else
        self:ShowGamepadViewBtn(false)
    end
end

function M:SetFocusTarget(bForce)
    if bForce or self.ParentWidget.IsInFocusPath and self.ListItemNum > 0 and not self.List_Item:HasAnyUserFocus() and not self.List_Item:HasFocusedDescendants() then
        self.List_Item:SetFocus()
        self.List_Item:NavigateToIndex(0)
        self.HandleFocus = true
        self.ParentWidget.bIsSubWidgetFocused = true
    end
end

function M:DelaySetFocusTarget(bForce)
    if self.IsGamepad then
        self:AddTimer(0.01, function()
            self:SetFocusTarget(bForce)
        end, nil, nil, "DelaySetFocusTarget", true)
    end
end

-- 见 WBP_Com_Activity_RewardItem_C
function M:OnNavigateUp(Content)
    local Idx = self.List_Item:GetIndexForItem(Content)
    if Idx>=1 then
        local Item = self.List_Item:GetItemAt(Idx-1)
        self.List_Item:NavigateToIndex(Idx-1)
        return Item.SelfWidget:FocusToRewardItem()
    end
    return Content.SelfWidget:FocusToRewardItem()
end

-- 见 WBP_Com_Activity_RewardItem_C
function M:OnNavigateDown(Content)
    local Idx = self.List_Item:GetIndexForItem(Content)
    local AllItemCount = self.List_Item:GetNumItems()-1
    if Idx<=AllItemCount-1 then
        local Item = self.List_Item:GetItemAt(Idx+1)
        self.List_Item:NavigateToIndex(Idx+1)
        return Item.SelfWidget:FocusToRewardItem()
    end
    return Content.SelfWidget:FocusToRewardItem()
end


return M

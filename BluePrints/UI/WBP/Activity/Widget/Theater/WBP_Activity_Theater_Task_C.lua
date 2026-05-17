--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@class WBP_Activity_Teater_Task_P_C : BluePrints.UI.BP_UIState_C
---@field PreConsumeList table
---@field ListWidgets table
---@field SelectedCount number
---@field PreConsumeCount number
---@field MinusPressed boolean
---@field MinusPressTime number
---@field MinusContent table
---@field MinusTimer any
---@field CurrentWidget table
---@field PlusPressed boolean
---@field PlusPressTime number
---@field PlusContent table
---@field PlusTimer any
---@field ContentMap table
---@field FilteredContents table
---@field LastSelectedListContent table
---@field SelectedIndex number
---@field bListExpand boolean
---@field IsClosingUi boolean
---@field bAutoSelecting boolean

local M = Class("BluePrints.UI.BP_UIState_C")
local TheaterTaskEventId = DataMgr.TheaterConstant.EventId.ConstantValue


M._components = {
    "BluePrints.UI.UI_PC.Common.SelectItemToSubListComponent",
    "BluePrints.UI.WBP.Activity.Widget.Theater.TheaterActivityGamepadComponent"
}

function M:Construct()
    self.Tab:Init({
        DynamicNode={"Back"},
        StyleName="Text",
        TitleName=GText("TheaterOnline_Donate_Name"),
        OwnerPanel=self,
        BackCallback=self.CloseSelf
    })
    self.NeedNum = {}
    self:GetActivityProgress()
    self.PreConsumeCount = 5
    self.Super.Construct(self)
    self:PlayAnimation(self.In)
    self.ListView_Task.OnListViewScrolled:Add(self, self.OnListViewTaskScrolled)
    self.List_Delivery.BP_OnEntryInitialized:Add(self,self.OnListDeliveryItemInited)
    self.View_left_btns.BP_OnEntryInitialized:Add(self,self.OnViewLeftBtnInited)
    self.Btn_Auto:BindEventOnClicked(self, self.OnBtnAutoClicked)
    self.Btn_AutoText = GText("TheaterOnline_Donate_AutoPut")
    self.Btn_Auto:SetText(GText("TheaterOnline_Donate_AutoPut"))
    self.Btn_Delivery:ForbidBtn(true)
    self.Btn_Delivery:BindEventOnClicked(self, self.OnBtnDeliveryClicked)
    self.Btn_Delivery:SetText(GText("TheaterOnline_Donate_Confirm"))
    self.Tip_Refresh:BindEventOnClicked(self, self.OnTipRefreshClicked)
    self.Tip_Refresh:SetText(GText("UI_Friend_RefreshBtn"))
    self.Button_Hit.OnClicked:Add(self, self.OnButtonHitClicked)
    self.Panel_Bag:SetVisibility(ESlateVisibility.Collapsed)
    self.View_left_btns:SetVisibility(ESlateVisibility.Visible)
    self.bListExpand = false
    self:InitListView(self.List_Item, self.List_Delivery, self.Filter)
    self:InitPreConsumeList()
    self.List_Item.OnCreateEmptyContent:Bind(self, function()
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.IsEmpty = true
        return Obj
    end)
    self.List_Reward.OnCreateEmptyContent:Bind(self, function()
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.Id = 0
        return Obj
    end)

    self:InitGamepadIcon()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    end
    self.SelectedIndex = 1
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    self.Text_Empty_Search:SetText(GText("TheaterOnline_Donate_NoMatch"))
    EventManager:FireEvent(EventID.OnLeaveActivityEntry)
    self.Text_Lable:SetText(GText("UI_Theater_Mail_Sent"))
    AudioManager(self):PlayUISound(self, "event:/ui/activity/theater_online_entrance_loop", "TheaterLoop", nil)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open","Theater",nil)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.CurInputDevice = CurInputDevice
    self.CurGamepadName = CurGamepadName
    self:UpdateGamepadUI(CurInputDevice, CurGamepadName)
    if CurInputDevice == ECommonInputType.Gamepad then
        self:SetDefaultFocus()
    else
        self:UpdateBottomKeyInfo()
        self.IsSpecialFocus = false
    end
end


function M:Destruct()
    self.List_Item.OnCreateEmptyContent:Unbind()
    self.List_Reward.OnCreateEmptyContent:Unbind()
    self.Super.Destruct(self)
end

function M:OnListDeliveryItemInited(Content, EntryUI)
    self:OnPreConsumeListGenerated(Content, EntryUI)

    Content.SelfWidget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    if Content.Index == 1 then
        Content.SelfWidget:SetNavigationRuleCustom(EUINavigation.Left, {self, function()
            return self:SetDefaultFocus()
        end})
    end
end

function M:OnViewLeftBtnInited(Content, EntryUI)
    Content.UI:SetNavigationRuleExplicit(EUINavigation.Right, self.List_Delivery)
end

function M:OnButtonHitClicked()
    self:OnExpandList(false, false)
end

function M:OnBtnAutoClicked()
    local bAutoSelect = true
    local Content = self.ListWidgets[1].Content
    if Content and Content.Count and Content.Count > 0 then
        bAutoSelect = false
    end
    if bAutoSelect then
        self:OnAutoSelectClick()
    else
        self:ClearListItems()
    end
    self:UpdateAddProgress()
end

function M:PreviewLevelMax(Id)
    local Content = self:FindSelectedContent(Id)
    local NeedNum = self.NeedNum[Id]
    -- 彩蛋材料或者第三阶段的材料，可以无限提交
    if NeedNum == nil or (self.CurStep == 3 and self.SelectedIndex == 3) then
        return false
    end
    if NeedNum == 0 then
        return true
    end
    if Content then
        return Content.Count >= NeedNum
    end
    return false
end

function M:OnAutoSelectClick()
    local canSelect = false
    for _,Content in pairs(self.FilteredContents) do
        local Id = Content.Id
        local NeedNum = self.NeedNum[Id]
        local Rarity = Content.Rarity
        local RarityAutoPutMax = DataMgr.TheaterConstant["AutoPutMax_" .. Rarity]
        RarityAutoPutMax = RarityAutoPutMax and RarityAutoPutMax.ConstantValue or 0
        if NeedNum and NeedNum > 0 and RarityAutoPutMax > 0 then
            canSelect = true
            local num = math.min(NeedNum, Content.Count)
            num = math.min(num, RarityAutoPutMax)
            self:CopyItemToConsumeList(Content, num)
            Content.SelectNeedCount = num
            self:SetResourceCount(Content.Id, num)
            local CurContent = self:FindSelectedContent(Content.Id)
            CurContent.Count = num
        end
    end
    if not canSelect then
        UIManager(self):ShowUITip("CommonToastMain", GText("TheaterOnline_Donate_Nothing"))
    end
end

function M:OnBtnDeliveryClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
    local Avatar = GWorld:GetAvatar()
    local DonateList = {}
    for _,Content in pairs(self.PreConsumeList) do
        if Content.Count and Content.Count > 0 then
            DonateList[Content.UnitId] = Content.Count
        end
    end
    Avatar:TheaterDonate(self.SelectedIndex, DonateList, function(ErrCode,Ret)
        if ErrCode == 0 then
            AudioManager(self):PlayUISound(self, "event:/ui/common/combat_bag_hide_use_item", nil, nil)
            UIManager(self):ShowUITip("CommonToastMain", GText("UI_Theater_Donate_Success"))
            local bStifyAll = true
            for UnitId,Count in pairs(DonateList) do
                if not self.NeedNum[UnitId] then
                    goto continue
                end
                if self.NeedNum[UnitId] ~= DonateList[UnitId] then
                    bStifyAll = false
                end
                self.NeedNum[UnitId] = self.NeedNum[UnitId] - Count
                self.DonateProgress[UnitId] = (self.DonateProgress[UnitId] or 0) + Count
                ::continue::
            end
            for _,Num in pairs(self.NeedNum) do
                if Num > 0 then
                    bStifyAll = false
                    break
                end
            end
            if bStifyAll and self.CurStep < #DataMgr.TheaterDonateStep[TheaterTaskEventId] then
                self.CurStep = self.CurStep + 1
                if self.DonateProgress then
                    for k, v in pairs(self.DonateProgress) do
                        self.DonateProgress[k] = nil
                    end
                else
                    self.DonateProgress = {}
                end
                self:RefreshViewLeftBtns()
                self:PlayBGAnimation(self.CurStep)
                self.WBP_Activity_Theater_BG:PlayAnimation(self.WBP_Activity_Theater_BG.Change)
                self:OnBtnItemClicked(self.CurStep)
            end
            self:ClearListItems()
            self:UpdatePage(self.SelectedIndex, true)
            self:ShowItemDetails(false, nil)
            self:UpdateAddProgress()
        end
    end)
end

function M:OnTipRefreshClicked()
    -- 记录时间，如果这一次按键的时间和上一次按键的时间差小于5秒，则不刷新
    if self.LastRefreshTime and UE4.UGameplayStatics.GetRealTimeSeconds(self) - self.LastRefreshTime < 5 then
        UIManager(self):ShowUITip("CommonToastMain", GText("TheaterOnline_Donate_RefreshCD"))
        return
    end
    self.LastRefreshTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
    self:GetActivityProgress(true)
end

function M:OnListViewTaskScrolled()
    UIUtils.UpdateListArrow(self.ListView_Task, self.Arrow_UP, self.Arrow_Down)
end

function M:InitUI()
    self.Text_Title01:SetText(GText("TheaterOnline_Donate_Reward"))
    self.Text_Title02:SetText(GText("TheaterOnline_Donate_Progress"))
    self.Text_Title03:SetText(GText("TheaterOnline_Donate_Puy"))
    self:UpdateBottomKeyInfo()

    local ConfigData={}
    ConfigData.OwnerWidget=self
    ConfigData.MenuPlacement = EMenuPlacement.MenuPlacement_CenteredAboveAnchor
    ConfigData.SoundFunc= function ()
        AudioManager(self):PlayUISound(nil,"event:/ui/common/click_btn_small", nil, nil)
    end
    ConfigData.TextContent=GText("TheaterOnline_Donate_Explain")
    self.Tip_Award:Init(ConfigData)
end

function M:InitViewLeftBtns()
    self.View_left_btns:ClearListItems()
    for i = 1, 3 do
        local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
        ItemContent.Index = i
        ItemContent.ParentWidget = self
        ItemContent.IsLock = i > self.CurStep
        ItemContent.IsSelected = self.CurStep == i
        ItemContent.IsDone = i < self.CurStep
        if self.CurStep == 3 and i == 3 then
            ItemContent.IsDone = self.IsFinished
        end
        self.View_left_btns:AddItem(ItemContent)
    end
end

function M:OnBtnItemClicked(Index)
    if self.SelectedIndex == Index then
        return
    end
    self:UpdatePage(Index)
    self:InitRewardListView(Index)
    if self.SelectedIndex then
        local Item = self.View_left_btns:GetItemAt(self.SelectedIndex - 1)
        if Item == nil or Item.UI == nil then
            return
        end
        Item.UI:StopAllRegularAnimations()
        Item.UI:PlayAnimation(Item.UI.Normal)
    end
    self.SelectedIndex = Index
    local Item = self.View_left_btns:GetItemAt(Index - 1)
    Item.UI:StopAllRegularAnimations()
    Item.UI:PlayAnimation(Item.UI.Click)
    self:UpdateAutoBtnText()
    self:PlayAnimation(self.Change)
    AudioManager(self):PlayUISound(self, "event:/ui/activity/theater_online_level_change", nil, nil)
    -- 遍历List_Delivery的每个Item，PlayAnimation(Item.Normal)
    self:AddTimer(0.1, function()
        for i = 1, self.List_Delivery:GetNumItems() do
            local Content = self.List_Delivery:GetItemAt(i - 1)
            if Content and Content.SelfWidget and Content.SelfWidget.Item then
                Content.SelfWidget.Item:PlayAnimation(Content.SelfWidget.Item.Normal)
            end
        end
    end)
end

function M:UpdatePage(Index, bRefreshTaskListView)
    if bRefreshTaskListView then
        self:UpdateTaskListView(Index)
    else
        self:SetupTaskListView(Index)
    end
    self:InitFilteredContents(Index)
    self:FillListItem()
    self:InitPreConsumeList()
end

function M:InitRewardListView(Index)
    if not IsValid(self.List_Reward) then
        return
    end
    self.List_Reward:ClearListItems()
    local RewardId = DataMgr.TheaterDonateStep[TheaterTaskEventId][Index].RewardViewId
    local RewardInfo = DataMgr.RewardView[RewardId]
    if RewardInfo then
        local Ids = RewardInfo.Id or {}
        local RewardCount = RewardInfo.Quantity or {}
        local TableName = RewardInfo.Type or {}
        for i = 1, #Ids do
            local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
            ItemContent.ParentWidget = self
            local ItemId = Ids[i]
            local Count = RewardUtils:GetCount(RewardCount[i])
            local ItemType = TableName[i]
            local Rarity = ItemUtils.GetItemRarity(ItemId, ItemType)
            ItemContent.ItemType = ItemType
            ItemContent.Id = ItemId
            ItemContent.Count = Count
            ItemContent.Rarity = Rarity
            ItemContent.Icon = ItemUtils.GetItemIconPath(ItemId, ItemType)
            ItemContent.IsShowDetails = true
            ItemContent.OnMenuOpenChangedEvents = {Obj = self, Callback = self.ItemMenuAnchorChanged}
            self.List_Reward:AddItem(ItemContent)
        end
    end
    self.List_Reward:RequestFillEmptyContent()
end

function M:SetupTaskListView(Index)
    self.Text_Right_Title:SetText(string.format(GText("TheaterOnline_Donate_Step"), Index))

    -- 初始化任务进度Item
    local bShowLable = true
    self.ListView_Task:ClearListItems()
    local TaskList = DataMgr.TheaterDonateStep[TheaterTaskEventId][Index]
    for i = 1, #TaskList.Resource do
        local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
        ItemContent.ParentWidget = self
        ItemContent.Resource = TaskList.Resource[i]
        if self.CurStep > Index then
            ItemContent.Progress = TaskList.Num[i]
        elseif self.CurStep == Index then
            ItemContent.Progress = self.DonateProgress[TaskList.Resource[i]] or 0
        else
            ItemContent.Progress = 0
        end
        ItemContent.Index = i
        ItemContent.Target = TaskList.Num[i]
        self.ListView_Task:AddItem(ItemContent)
        if ItemContent.Progress < ItemContent.Target then
            bShowLable = false
        end
        self.NeedNum[TaskList.Resource[i]] = ItemContent.Target - ItemContent.Progress
    end

    self:AddTimer(0.3, function()
        self:OnListViewTaskScrolled()
    end)

    if self.CurStep ~= Index then
        self.Switch_Delivery:SetActiveWidgetIndex(0)
        if self.CurStep > Index then
            self.Text_Lock:SetText(GText("UI_Theater_Donate_End"))
            self.Image_Lock:SetVisibility(ESlateVisibility.Collapsed)
        elseif self.CurStep < Index then
            self.Text_Lock:SetText(GText("UI_Theater_Donate_NotStart"))
            self.Image_Lock:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    else
        self.Switch_Delivery:SetActiveWidgetIndex(1)
    end
    self.Overlay_Lable:SetVisibility(bShowLable and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
end

function M:UpdateTaskListView(Index)
    for i = 1, self.ListView_Task:GetNumItems() do
        local Item = self.ListView_Task:GetItemAt(i - 1)
        if self.CurStep == Index then
            if Item.Progress ~= self.DonateProgress[Item.Resource] and self.DonateProgress[Item.Resource] ~= nil then
                Item.Progress = self.DonateProgress[Item.Resource] or 0
                Item.UI:InitUI()
                if Item.Progress >= Item.Target then
                    Item.UI:PlayAnimation(Item.UI.Finish)
                else
                    Item.UI:PlayAnimation(Item.UI.Flash)
                end
            end
        end
    end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    if self.IsClosingUi then
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end

    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if KeyName == "Escape" then
        self:CloseSelf()
        IsEventHandled = true
    elseif KeyName == "Gamepad_FaceButton_Bottom" then
        if self.View_left_btns:HasFocusedDescendants() or self.View_left_btns:HasAnyUserFocus() then
            self.List_Delivery:NavigateToIndex(0)
            self.List_Delivery:SetFocus()
            IsEventHandled = true
        end
    elseif KeyName == "Gamepad_FaceButton_Right" then
        if self.Filter.Btn_Filter_List:HasFocusedDescendants() or self.Filter.Btn_Filter_List:HasAnyUserFocus() then
            DebugPrint("JLy OnPreviewKeyDown: Gamepad_FaceButton_Right")
            local ItemNum = #self.FilteredContents
            if ItemNum > 0 then
                self.List_Item:SetFocus()
            else
                self.List_Delivery:NavigateToIndex(0)
                self:OnExpandList(false, false)
            end
            self.bIsFocusInFilter = false
            IsEventHandled = true
        end
    end
    if IsEventHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    if self.IsClosingUi then
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end

    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:Handle_OnGamePadDown(KeyName)
    end
    if IsEventHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:CloseSelf()
    if self.bListExpand then
        self:OnExpandList(false, false)
    else
        -- 清理背景组件
        self.IsClosingUi = true
        self:PlayAnimation(self.Out)
        AudioManager(self):SetEventSoundParam(self, "Theater", {ToEnd = 1})
        AudioManager(self):StopSound(self, "TheaterLoop")
        EventManager:FireEvent(EventID.OnReturnToActivityEntry)
    end
end

function M:OnAnimationFinished(Animation)
    if Animation == self.Out then
        self.Super.Close(self)
    end
end

function M:OnExpandList(bExpandList, bRefreshList)
    if self.bListExpand == bExpandList then
        return
    end
    self.bListExpand = bExpandList
    if bExpandList then
        self:PlayAnimation(self.Bag_In)
        self.View_left_btns:SetVisibility(ESlateVisibility.Collapsed)
        self.List_Item:NavigateToIndex(0)
        self:SetGamepadImgVisibility(self.CurInputDevice == ECommonInputType.Gamepad, true)
        self:ShowItemDetails(false, nil)
    else
        self:PlayAnimation(self.Bag_Out)
        self.View_left_btns:SetVisibility(ESlateVisibility.Visible)
        self:SetGamepadImgVisibility(self.CurInputDevice == ECommonInputType.Gamepad, false)
    end
end

function M:InitFilteredContents(Index)
    self.ContentMap = {}
    self.FilteredContents = {}
    local TaskList = DataMgr.TheaterDonateStep[TheaterTaskEventId][Index]
    local Avatar = GWorld:GetAvatar()
    if not Avatar or not Avatar.Resources then
        return
    end
    
    -- 先复制基础资源列表
    local ResourceList = {}
    for i = 1, #TaskList.Resource do
        table.insert(ResourceList, TaskList.Resource[i])
    end
    
    -- 遍历添加UniqueResource（彩蛋材料），从1到n直到没有为止
    local uniqueIdx = 1
    while true do
        local uniqueKey = "UniqueResource" .. uniqueIdx
        local uniqueResource = DataMgr.TheaterConstant[uniqueKey]
        if uniqueResource and uniqueResource.ConstantValue then
            table.insert(ResourceList, uniqueResource.ConstantValue)
            uniqueIdx = uniqueIdx + 1
        else
            break
        end
    end
    
    -- 遍历所有资源（包括基础资源和彩蛋材料）
    for i = 1, #ResourceList do
        local Resource = Avatar.Resources[ResourceList[i]]
        if Resource then
            local Obj = NewObject(UIUtils.GetCommonItemContentClass())
            Obj.ParentWidget = self
            Obj.Id = Resource.ResourceId
            Obj.ItemType = "Resource"
            Obj.Count = Resource.Count
            Obj.Icon = Resource.Icon
            Obj.Rarity = Resource.Rarity
            Obj.OnMouseButtonDownEvent = {Obj = self, Callback = function()
                if not self:PreviewLevelMax(Obj.Id) then
                    self:OnPlusStart(Obj)
                else
                    UIManager(self):ShowUITip(UIConst.Tip_CommonToast,GText("Max_Level_Achieved"),1.5)
                end
                self:ShowItemDetails(true, Obj)
            end,
            Params = {bIgnoreRightMouseDown = true}}
            local function HandlePlusEnd()
                self:OnPlusEnd()
                local CurContent = self:FindSelectedContent(Resource.ResourceId)
                self:OnRightListSelectedChanged(CurContent)
            end
            Obj.OnMouseButtonUpEvents = {Obj = self, Callback = function()
                HandlePlusEnd()
            end}
            Obj.OnMouseLeaveEvent = {Obj = self, Callback = function()
                HandlePlusEnd()
            end}
            table.insert(self.FilteredContents, Obj)
            self.ContentMap[Resource.ResourceId] = Obj
        end
    end
end

function M:GetActivityProgress(bSkipInitViewLeftBtns)
    local Avatar = GWorld:GetAvatar()
    Avatar:TheaterDonationGet(function(ErrCode,Ret)
        if Ret then
            self.CurStep = Ret.CurStep
            self.IsFinished = Ret.IsFinished
            self.DonateProgress = Ret.DonateProgress
            self:InitUI()
            if not bSkipInitViewLeftBtns then
                self:InitViewLeftBtns()
                self.SelectedIndex = self.CurStep
                self:UpdatePage(self.SelectedIndex)
                self:InitRewardListView(self.SelectedIndex)
                self:UpdateAutoBtnText()
                self:PlayBGAnimation(self.CurStep)
                self.View_left_btns:SetSelectedIndex(self.SelectedIndex - 1)
            else
                self:RefreshViewLeftBtns()
                self:UpdatePage(self.SelectedIndex)
            end
        end
    end)
end


function M:RefreshViewLeftBtns()
    for i = 1, 3 do
        local Item = self.View_left_btns:GetItemAt(i - 1)
        if i > self.CurStep then
            Item.UI:PlayAnimation(Item.UI.Lock)
        else
            Item.UI:PlayAnimation(Item.UI.Lock_Normal)
        end
        local IsDone = i < self.CurStep
        if self.CurStep == 3 and i == 3 then
            IsDone = self.IsFinished
        end
        if IsDone then
            Item.UI.panel_check:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            Item.UI.panel_check:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end

function M:PlayBGAnimation(index)
    if (index == #DataMgr.TheaterDonateStep[TheaterTaskEventId] and self.IsFinished) then
        index = index + 1
    end
    local spineChar = self.WBP_Activity_Theater_BG.Spine_Char
    local inAnimName = "In" .. index
    local loopAnimName = "Loop" .. index
    spineChar:SetAnimation(0, inAnimName, false)
    spineChar:AddAnimation(0, loopAnimName, true, 0)
end

function M:UpdateAddProgress()
    local DonateList = {}
    for _,Content in pairs(self.PreConsumeList) do
        if Content.Count and Content.Count > 0 then
            DonateList[Content.UnitId] = Content.Count
        end
    end
    for i = 1, self.ListView_Task:GetNumItems() do
        local Item = self.ListView_Task:GetItemAt(i - 1)
        local Num = DonateList[Item.Resource] or 0
        Item.UI:SetAddProgress(Num)
    end
end

function M:ReceiveEnterState(StackAction)
    M.Super.ReceiveEnterState(self, StackAction)
    if (StackAction == 1) then
        if self.LastFocusItem and self.IsSpecialFocus then
            self.LastFocusItem:SetFocus()
        end
    end
end

AssembleComponents(M)
return M

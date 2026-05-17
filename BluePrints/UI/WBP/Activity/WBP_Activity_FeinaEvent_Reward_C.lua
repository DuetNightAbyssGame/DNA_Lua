--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local NumberModel = require "BluePrints.UI.UI_PC.Archive.WBP_Archive_Number_Model"

local WBP_Activity_FeinaEvent_Reward_C = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

function WBP_Activity_FeinaEvent_Reward_C:Construct()
    self.Super.Construct(self)
    self:Init()
    if not ReddotManager.GetTreeNode("FeinaEventReward") then
		ReddotManager.AddNode("FeinaEventReward")
	end
	ReddotManager.AddListener("FeinaEventReward",self,self.RefreshBtnGetAll)
    self.Btn_GetAll:SetVisibility(ESlateVisibility.Collapsed)
end

function  WBP_Activity_FeinaEvent_Reward_C:UpdateFeinaEventRewardReddot()
   UIUtils.RefreshFeinaRewardReddot()
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function WBP_Activity_FeinaEvent_Reward_C:Destruct()
    self.Super.Destruct(self)
    ReddotManager.RemoveListener("FeinaEventReward",self)
    self:ClearListenEvent()
    self.List_Tab:ClearListItems()
    self.List_Item:ClearListItems()
end

function WBP_Activity_FeinaEvent_Reward_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self.Type,self.DataModel = ...
    self.SelectIndex = nil
    if self.Type then
        self.SelectIndex = self.Type2Index[self.Type]
    end
    if not self.SelectIndex then
        self.SelectIndex = 1
    end
    self.List_Item:SetControlScrollbarInside(true)
    self.List_Tab:ScrollIndexIntoView(self.SelectIndex-1)
    self:AddTimer(0.01, function()
        self.List_Tab:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        local Item = self.List_Tab:GetItemAt(self.SelectIndex-1)
        self.Btn_GetAll:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if Item then
            Item.Entry:OnCellClicked()
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(Item.Entry)
        end
    end, false, 0, "SelectRewardTab", true)
    self:UpdateFeinaEventRewardReddot()
    self:PlayAnimation(self.In)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        self.Key_Tip:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function WBP_Activity_FeinaEvent_Reward_C:Init()
    self:InitNormalInfo()
	self:InitListTabInfo()
    self:InitBtnInfo()

    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
    self:InitListenEvent()
    self:InitWidgetInfoInGamePad()
end

function WBP_Activity_FeinaEvent_Reward_C:InitNormalInfo()
    self.Btn_GetAll:SetText(GText("UI_Archive_CollectionClaimAll"))
end

function WBP_Activity_FeinaEvent_Reward_C:InitBtnInfo()
	self.Btn_GetAll:BindEventOnClicked(self,self.GetAllRewards)
    self.Btn_Close:Init("Close",self,self.OnClickClose)
    self.Btn_Close.AudioEventPath="event:/ui/common/click_btn_return"
end

function WBP_Activity_FeinaEvent_Reward_C:InitListTabInfo()
    self.List_Tab.BP_OnItemSelectionChanged:Add(self, self.OnSelectItemChanged)
    self.List_Tab:SetNavigationRuleCustom(EUINavigation.Right,{self,self.OnUINavigation})
    self.List_Tab:SetVisibility(ESlateVisibility.HitTestInvisible)
    self.List_Item:SetNavigationRuleCustom(EUINavigation.Left,{self,self.OnUINavigation})
    self.List_Item:SetControlScrollbarInside(true)
    self.Type2Index = {}
    -- local DungeonIdInfo = {}
    -- for _,Data in pairs(DataMgr.FeinaEvent) do
    --     local DungeonIdList=Data.DungeonId
    --     for _, DungeonId in pairs(DungeonIdList) do
    --         table.insert(DungeonIdInfo,DungeonId)
    --     end
    -- end
    local ClassPath = '/Game/UI/UI_PC/Common/Common_Item_subsize_PC_Content.Common_Item_subsize_PC_Content_C'
    self.List_Tab:ClearListItems()
    for Index,EventInfo in ipairs(DataMgr.FeinaEvent) do
        local Obj = NewObject(UE4.LoadClass(ClassPath))
        Obj.Root = self
        Obj.TabIndex = Index
        Obj.Type = Index
        --Obj.RewardId = EventInfo .RewardId
        self.List_Tab:AddItem(Obj)
        self.Type2Index[Obj.Type] = Index
    end
end

function WBP_Activity_FeinaEvent_Reward_C:RefreshListRewardInfo(Item)
    if self.SelectedContent then
        self.SelectedContent.Entry:UnSelected()
    end
    self.Type=Item.Content.Type
    self.SelectedContent = Item.Content
    self.SelectedContent.Entry:Selected()
    self:RealRefreshListRewardInfo(self.SelectedContent.Type)
    local InputType=self.GameInputModeSubsystem:GetCurrentInputType()
    if InputType == ECommonInputType.MouseAndKeyboard then
        self.List_Item:SetFocus()
    end
    self:RemoveTimer(self.FramingKey)
    self.FramingKey=self:AddTimer(0.01,function ()
        self.List_Item:SetScrollOffset(0)
		UIUtils.PlayListViewFramingInAnimation(self, self.List_Item, {
			AnimName="In"})
        local AllItemCount = self.List_Item:GetNumItems()
        for i = 0, AllItemCount - 1, 1 do
            local TargetItem = self.List_Item:GetItemAt(i)
            if TargetItem and TargetItem.Entry then
                UIUtils.PlayListViewFramingInAnimation(self, TargetItem.Entry.List_Item, {
                AnimName="In"})
            end
        end
		end,false,0,nil,true)
end

function WBP_Activity_FeinaEvent_Reward_C:RealRefreshListRewardInfo(Type)
    --NumberModel["Get"..self.ArchiveType2Name[ArchiveType].."SumNumber"](NumberModel)
    self:AddListReward(Type)
    --self:RefreshProgressInfo(ArchiveType)
    self:RefreshBtnGetAll()
end

function WBP_Activity_FeinaEvent_Reward_C:AddListReward(Type)
    local EventInfo = DataMgr.FeinaEvent[Type]
    local ClassPath = '/Game/UI/UI_PC/Common/Common_Item_subsize_PC_Content.Common_Item_subsize_PC_Content_C'
    self.List_Item:ClearListItems()
    for Index,DungeonId in pairs(EventInfo.DungeonId) do
        local Obj = NewObject(UE4.LoadClass(ClassPath))
        Obj.Root = self
        Obj.Index = Index
        Obj.DungeonId= DungeonId
        Obj.Title = DataMgr.FeinaEventDungeon[DungeonId].DungeonName
        self.List_Item:AddItem(Obj)
    end
end

-- function WBP_Activity_FeinaEvent_Reward_C:RefreshProgressInfo(ArchiveType, SumNum)
--     self.CurrentNum = self.DataModel:GetUnlockedItemNum(ArchiveType)
--     self.SumNum = SumNum
--     self.Text_Progress:SetText(string.format(GText("UI_Archive_CollectionProgress"), self.CurrentNum, self.SumNum))
-- end

-- function WBP_Activity_FeinaEvent_Reward_C:RefreshCurrentNum(ArchiveType)
--     self.CurrentNum = self.DataModel:GetUnlockedItemNum(ArchiveType)
--     self.Text_Progress:SetText(string.format(GText("UI_Archive_CollectionProgress"), self.CurrentNum, self.SumNum))
-- end

function WBP_Activity_FeinaEvent_Reward_C:TryGetAllRewards()
    if self.Btn_GetAll:GetVisibility() ~= UIConst.VisibilityOp["Collapsed"] then
        self:GetAllRewards()
    end
end

function WBP_Activity_FeinaEvent_Reward_C:GetAllRewards()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local Callback = function (Errorcode,Rewards)
            self:RefreshItemState()
            self:RefreshReddotInfo()
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function ()
                self:SetFocus()
            end, self)
            EventManager:FireEvent(EventID.OnGetFeiNaReward)
        end
        Avatar:GetAllFeiNaProgressRewerd(self.Type2Index[self.SelectedContent.Type],Callback)
    end
end

function WBP_Activity_FeinaEvent_Reward_C:RefreshItemState()
    local TargetListItems = self.List_Item:GetDisplayedEntryWidgets()
    for i=1,TargetListItems:Length() do
        local TargetListItem = TargetListItems:GetRef(i)
        if TargetListItem then
            local Items=TargetListItem.List_Item:GetDisplayedEntryWidgets()
            for j=1,Items:Length() do
                local Item=Items:GetRef(j)
                Item:RefreshState()
                Item:RefreshRewardsList()
            end
        end
    end
end

function WBP_Activity_FeinaEvent_Reward_C:RefreshReddotInfo()
    DebugPrint("Ljh Try RefreshReddotInfo")
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("FeinaEventReward")
    if CacheDetail[self.SelectedContent.Type] then
        local Num = 0
        for _,DungeonData in pairs(CacheDetail[self.SelectedContent.Type]) do
            for _,_ in pairs(DungeonData) do
                        Num = Num + 1
            end
        end
        CacheDetail[self.SelectedContent.Type] = nil
        ReddotManager.DecreaseLeafNodeCount("FeinaEventReward", Num)
        DebugPrint("Ljh CacheDetail"..tostring(self.SelectedContent.Type).."Cleared,ClearedNums:"..tostring(Num))
    end
end

function WBP_Activity_FeinaEvent_Reward_C:RefreshBtnGetAll()
    DebugPrint("Ljh Try RefreshBtnGetAll")
    if not self.SelectedContent then
        self.Btn_GetAll:SetVisibility(ESlateVisibility.Collapsed)
        return
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("FeinaEventReward")
    if CacheDetail and CacheDetail[self.SelectedContent.Type] then
        DebugPrint("Ljh CacheDetail Not Empty,Type:"..tostring(self.SelectedContent.Type))
        local CurInputDevice = self.GameInputModeSubsystem:GetCurrentInputType()
        if CurInputDevice ~= ECommonInputType.Touch and CurInputDevice ~= ECommonInputType.MouseAndKeyboard then
            self.Btn_GetAll:SetVisibility(ESlateVisibility.HitTestInvisible)
        else
            self.Btn_GetAll:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" and self.GameInputModeSubsystem:GetCurrentInputType() ~= ECommonInputType.Gamepad then
                self.Key_Tip:UpdateKeyInfo({
                {
                    KeyInfoList = {{Type = "Text", Text = "Space",bEnableEvent=true,ClickCallback=self.TryGetAllRewards,Owner=self}},
                    Desc = GText("UI_Archive_CollectionClaimAll")
                },
                {
                    KeyInfoList = {{Type = "Text", Text = "Esc",bEnableEvent=true,ClickCallback=self.OnClickClose,Owner=self}},
                    Desc = GText("UI_Tips_Close")
                },
                })
            end
        end
    else
        if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" and self.GameInputModeSubsystem:GetCurrentInputType() ~= ECommonInputType.Gamepad then
            self.Key_Tip:UpdateKeyInfo({
                {
                    KeyInfoList = {{Type = "Text", Text = "Esc",bEnableEvent=true,ClickCallback=self.OnClickClose,Owner=self}},
                    Desc = GText("UI_Tips_Close")
                },
            })
        end
        self.Btn_GetAll:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_Activity_FeinaEvent_Reward_C:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        -- if (InKeyName == "Gamepad_LeftThumbstick") then
        --     IsEventHandled = true
        --     self:EnterSelectMode()
        -- else
        if (InKeyName == "Gamepad_FaceButton_Top") then
            IsEventHandled = true
            self:TryGetAllRewards()
        elseif (InKeyName == "Gamepad_FaceButton_Right") then  
            IsEventHandled = true
            self:OnReturnKeyDown()
		end
    else
        if (InKeyName == "Escape") then
            IsEventHandled = true
            self:OnReturnKeyDown()
        elseif(InKeyName == "SpaceBar") then
            IsEventHandled = true
            self:TryGetAllRewards()
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end


function WBP_Activity_FeinaEvent_Reward_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)
   local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
    else
        if (InKeyName == "Escape") then
            IsEventHandled = true
            self:OnReturnKeyDown()
        elseif(InKeyName == "SpaceBar") then
            IsEventHandled = true
            self:TryGetAllRewards()
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function WBP_Activity_FeinaEvent_Reward_C:OnReturnKeyDown()
    --UIUtils.PlayCommonBtnSe(self)
    self:OnClickClose()
end

function WBP_Activity_FeinaEvent_Reward_C:OnClickClose()
    --AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", nil, nil)
    self:Close()
end

function WBP_Activity_FeinaEvent_Reward_C:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function WBP_Activity_FeinaEvent_Reward_C:ClearListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

function WBP_Activity_FeinaEvent_Reward_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function WBP_Activity_FeinaEvent_Reward_C:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if IsUseKeyAndMouse then
		self:InitKeyboardView()
	else
		self:InitGamepadView()
	end
end

function WBP_Activity_FeinaEvent_Reward_C:InitGamepadView()

    if self.Btn_GetAll:GetVisibility() == UE4.ESlateVisibility.SelfHitTestInvisible then
        self.Btn_GetAll:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    end
    self.Btn_Close:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
        self.Key_Tip:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Key_Tip:UpdateKeyInfo({
                {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "B"}},
                    Desc = GText("UI_Tips_Close")
                },
            })
    end
    local ItemViews = self.List_Item:GetDisplayedEntryWidgets()
    for _, ItemView in pairs(ItemViews) do 
        ItemView:InitGamepadView()
    end
    self.IsInSelectState = false
    -- self.List_Tab:NavigateToIndex(0)
    self.Btn_GetAll:SetGamePadIconVisible(true)
    if self.SelectedContent then
        if UIUtils.HasAnyFocus(self) then
            self.List_Tab:BP_NavigateToItem(self.SelectedContent)
        end
    end
     self:AddTimer(0.01,function ()
        if self.Type then
        self.SelectIndex = self.Type2Index[self.Type]
        end
        if not self.SelectIndex then
            self.SelectIndex = 1
        end
        local Item=self.List_Tab:GetItemAt(self.SelectIndex)
        if Item and Item.Entry then
            Item.Entry:SetFocus()
        end
        self.List_Tab:SetSelectedIndex(self.SelectIndex)
    end,false,0,nil,true)
end

function WBP_Activity_FeinaEvent_Reward_C:InitKeyboardView()

    if self.Btn_GetAll:GetVisibility() == UE4.ESlateVisibility.HitTestInvisible then
        self.Btn_GetAll:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    self.Btn_Close:SetVisibility(UE4.ESlateVisibility.Visible)
    if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
        self.Key_Tip:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Key_Tip:UpdateKeyInfo({
                {
                    KeyInfoList = {{Type = "Text", Text = "Esc", bEnableEvent=true,ClickCallback=self.OnClickClose,Owner=self}},
                    Desc = GText("UI_Tips_Close"),
                },
            })
    end
    local ItemViews = self.List_Item:GetDisplayedEntryWidgets()
    for _, ItemView in pairs(ItemViews) do 
        ItemView:InitKeyboardView()
    end
end

function WBP_Activity_FeinaEvent_Reward_C:InitWidgetInfoInGamePad()
    -- self.Key_02:SetVisibility(UIConst.VisibilityOp.Collapsed)
	-- self.Key_01:CreateCommonKey(
    --     {
    --         KeyInfoList = {{Type = "Img",ImgShortPath = "LS"}},
    --         Desc = GText("UI_Controller_CheckDetails")
    --     }
    -- )
    -- self.Key_02:CreateCommonKey(
    --     {
    --         KeyInfoList = {{Type = "Img",ImgShortPath = "RV"}},
    --         Desc = GText("UI_Controller_Slide")
    --     }
    -- )
    -- self.Key_03:CreateCommonKey(
    --     {
    --         KeyInfoList = {{Type = "Img",ImgShortPath = "B"}},
    --         Desc = GText("UI_Controller_Close")
    --     }
    -- )
    self.Btn_GetAll:SetDefaultGamePadImg("Y")
end

function WBP_Activity_FeinaEvent_Reward_C:OnSelectItemChanged(SelectItem)
    if (not SelectItem) then
        return
    end
    if (self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad) then
        self:ClickListItemWhenSelectItemChanged(SelectItem)
    end
end

function WBP_Activity_FeinaEvent_Reward_C:ClickListItemWhenSelectItemChanged(Content)
    if Content and Content.Entry then
        Content.Entry:OnCellClicked()
    end
end

function WBP_Activity_FeinaEvent_Reward_C:OnUINavigation(NavigationDirection)
    if(NavigationDirection == EUINavigation.Left) then
        self:NavigateToLeftTab()
        return self.SelectedContent.Entry
    elseif(NavigationDirection == EUINavigation.Right) then
        self.List_Item:SetSelectedIndex(0)
        if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
            self.Key_Tip:UpdateKeyInfo({
                {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "B"}},
                    Desc = GText("UI_Tips_Close")
                },
            })
        end
        return self:NavigateToFirstDisplayedItem(self.List_Item)
    end
end

function WBP_Activity_FeinaEvent_Reward_C:NavigateToLeftTab(NeedFocus)
    if self.CurFocusedRewardItem then
            self.CurFocusedRewardItem:StopHover()
            self.CurFocusedRewardItem = nil
        end
        if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
            self.Key_Tip:UpdateKeyInfo({
                {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "B"}},
                    Desc = GText("UI_Tips_Close")
                },
            })
        end
        if NeedFocus then
            self.SelectedContent.Entry:SetFocus()
        end
end

function WBP_Activity_FeinaEvent_Reward_C:TryChangeCurFocusedRewardItem(RewardItem)
    if self.CurFocusedRewardItem then
        self.CurFocusedRewardItem:StopHover()
    end
    self.CurFocusedRewardItem = RewardItem
    self.CurFocusedRewardItem:BeginHover()
end

function WBP_Activity_FeinaEvent_Reward_C:NavigateToFirstDisplayedItem(List)
    local ItemUIs = List:GetDisplayedEntryWidgets()
    if ItemUIs:Length() > 0 then
        local TargetWidget = nil
        for i=1,ItemUIs:Length() do
            local Widget = ItemUIs:GetRef(i)
            local Index = Widget.Content.Index
            if Index then
                if (not TargetWidget) or (Index < TargetWidget.Content.Index) then
                    TargetWidget = Widget
                end
            end
        end
        if TargetWidget then
            List:BP_NavigateToItem(TargetWidget.Content)
            return TargetWidget:NavigateToFirstDisplayedItem()
        end
    end
    return List
end

function WBP_Activity_FeinaEvent_Reward_C:NavigateToNextDisplayedItem() 
    local Item=self.List_Item:BP_GetSelectedItem()
    local NextIdx=self.List_Item:GetIndexForItem(Item)+1
    local NextItem=self.List_Item:GetItemAt(NextIdx)
    if NextItem then
        self.List_Item:SetSelectedIndex(NextIdx)
        self.List_Item:ScrollIndexIntoView(NextIdx)
    end
      self:AddTimer(0.01,function ()
        if NextItem then
            return NextItem.Entry:NavigateToFirstDisplayedItem()
        end
    end,false,0,nil,true)
    -- if NextItem then
    --     return NextItem.Entry:NavigateToFirstDisplayedItem()
    -- end
    --return Item.Content.Entry:NavigateToFirstDisplayedItem()
end

function WBP_Activity_FeinaEvent_Reward_C:NavigateToPreviousDisplayedItem() 
    local Item=self.List_Item:BP_GetSelectedItem()
    local NextIdx=self.List_Item:GetIndexForItem(Item)-1
    local NextItem=self.List_Item:GetItemAt(NextIdx)
    if NextItem then
        self.List_Item:SetSelectedIndex(NextIdx)
        self.List_Item:ScrollIndexIntoView(NextIdx)
    end
      self:AddTimer(0.01,function ()
        if NextItem then
            return NextItem.Entry:NavigateToFirstDisplayedItem()
        end
    end,false,0,nil,true)
    -- if NextItem then
    --     return NextItem.Entry:NavigateToFirstDisplayedItem()
    -- end
    -- return Item.Entry:NavigateToFirstDisplayedItem()
end

function WBP_Activity_FeinaEvent_Reward_C:OnMenuOpenChanged(bIsOpen)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        if bIsOpen then
            self:UpdateUIStyle(false)
        else
                -- body
            self:UpdateUIStyle(true)
        end
    end
end

function WBP_Activity_FeinaEvent_Reward_C:UpdateUIStyle(IsVisible)
    if IsVisible then
        self.CantGetAll = false
        if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
            self.Key_Tip:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
        --  self.Key_Tip:UpdateKeyInfo({
        --     {
        --         KeyInfoList = {{Type = "Img", ImgShortPath = "B"}},
        --         Desc = GText("UI_Tips_Close")
        --     },
        -- })
    else
        self.CantGetAll = true
        if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
            self.Key_Tip:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        -- self.Key_Tip:UpdateKeyInfo({
        --     {
        --         KeyInfoList = {{Type = "Img", ImgShortPath = "A"}},
        --         Desc = GText("UI_Controller_CheckDetails")
        --     },
        --     {
        --         KeyInfoList = {{Type = "Img", ImgShortPath = "B"}},
        --         Desc = GText("UI_Tips_Close")
        --     },
        -- })
    end
end

function WBP_Activity_FeinaEvent_Reward_C:BP_GetDesiredFocusTarget()
    if self.SelectedContent then
        self.List_Tab:BP_NavigateToItem(self.SelectedContent)
        return self.SelectedContent.Entry
    else
        return self.List_Tab
    end
end

return WBP_Activity_FeinaEvent_Reward_C

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Abyss_Dialog
local M = Class("Blueprints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()

end

function M:Init(Content)
    -- ConfigData({
    --      Text = "任务"   Tab文本
    --      ItemId = 1, Tab的Id
    --      CanReceive=false, 是否可领取
    --      RewardsGot=false,是否已领取
    --      HasGoto=false,是否需要显示跳转
    --      NotShowNum ,不显示数量
    --      ReddotName,红点树名称
    --      TextProgress,进度
    --      通用小道具框的InitData
    --      Rewards={
    --              Content1={},
    --              Content2={},
    --              Content3={},
    --              },
    --      Nums=1，Item的数量提示
    --      NotreachText=""，未达成数量
    --      Hint="",获得条件提示文本
    --      ReceiveCallBack,点击领取后调用的RPC
    --      ReceiveBtnSoundPath="",
    --      RefreshReddotFunc,刷新红点的方法
    --      LeftAligned=true  奖励是否左对齐，false时为右对齐
    --      SourceNum=1，图标对应的资源数量
    --      ReceiveParm={},领奖所需的参数
    --      ReceiveButtonText="",领取按钮Text
    --      HideProgressAfterGot 领取后隐藏进度信息
    -- })
    self:OnListItemObjectSet(Content)
end

function M:OnListItemObjectSet(Content)
    Content.SelfWidget=self
    self:SetVisibility(UIConst.VisibilityOp.Visible)
    self.WS_Type:SetActiveWidgetIndex(0)
    if Content.IsEmpty then
        self.WS_Type:SetActiveWidgetIndex(1)
       return
    end
    self:PlayAnimation(self.Normal)
    self.Type=Content.ConfigData.Type
    self.ItemId=Content.ConfigData.ItemId
    self.Mobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
    if not self.GameInputModeSubsystem then
        self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    end
    self.Owner=Content.Owner
    self.Content=Content
    self.Btn_Reward:UnBindEventOnClickedByObj(self)
    self.CanReceive=Content.ConfigData.CanReceive
    self.RewardsGot=Content.ConfigData.RewardsGot
    self.NotShowNum=Content.ConfigData.NotShowNum
    self.ReddotName=Content.ConfigData.ReddotName
    self.TextProgress=Content.ConfigData.TextProgress
    self.Text_Progress:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if self.TextProgress then
        self.Text_Progress:SetText(self.TextProgress)
        self.Text_Progress:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.RewardsGot and Content.ConfigData.HideProgressAfterGot then
        self.Text_Progress:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.HasGoto=Content.ConfigData.HasGoto
    if self.NotShowNum then
        self.Text_Num:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.RewardsGot then
        self.WS_State:SetActiveWidgetIndex(1)
        self:PlayAnimation(self.Forbidden)
    elseif self.CanReceive then
        self.WS_State:SetActiveWidgetIndex(0)
    else
        if self.HasGoto then
            self.WS_State:SetActiveWidgetIndex(3)
        else
            self.WS_State:SetActiveWidgetIndex(2)
        end
    end
    self.Rewards=Content.ConfigData.Rewards
    self.ReceiveCallBack=Content.ConfigData.ReceiveCallBack
    self.Btn_Reward:SetText(GText(Content.ConfigData.ReceiveButtonText) or GText("UI_Archive_CollectionClaim"))
    if Content.ConfigData.ReceiveBtnSoundPath then
        self.Btn_Reward.AudioEventPath=Content.ConfigData.ReceiveBtnSoundPath
    end
    self.Btn_Goto:SetText(GText(Content.ConfigData.GotoButtonText) or GText("UI_BattlePass_QuestJump"))
    self.Btn_Goto:SetGamepadIconVisibility(false)
    if Content.ConfigData.ReceiveCallBack then
        self.Btn_Reward:BindEventOnClicked(self,function()
                Content.ConfigData.ReceiveCallBack(self,Content)
        end)
    end
    self.Text_Content:SetText(GText(Content.ConfigData.Hint))
    self.Text_Ing:SetText(GText(Content.ConfigData.NotreachText))
    if Content.ConfigData.LeftAligned then
        self.List_Item_R:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.List_Item_L:SetVisibility(UIConst.VisibilityOp.Visible)
        self.UsedList=self.List_Item_L
    else
        self.List_Item_L:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.List_Item_R:SetVisibility(UIConst.VisibilityOp.Visible)
        self.UsedList=self.List_Item_R
    end
    self.Text_Num:SetText(Content.ConfigData.SourceNum)
    self.SourceNum=Content.ConfigData.SourceNum
    self.UsedList:ClearListItems()
    if not self.IsListened then
        self:AddInputMethodChangedListen()
    end
    self.IsListened=true
    self:InitRewards(Content.ConfigData)
    if self.Key_Item then
        self.Key_Item:CreateGamepadKey(UIConst.GamePadImgKey.LeftThumb)
    end
    self.Btn_Reward:SetDefaultGamePadImg("A")
end

function M:SetIcon(IconPath)
    if IconPath then
        local Icon = LoadObject(IconPath)
        self.Icon:SetBrushResourceObject(Icon)
    end
end

function M:FocusToRewardItem()
    self.UsedList:SetVisibility(UIConst.VisibilityOp.Visible)
    local ItemUIs = self.UsedList:GetDisplayedEntryWidgets()
    self.SelectedIndex=0
    if ItemUIs:Length() > 0 then
        local TargetWidget = nil
        for i=1,ItemUIs:Length() do
            local Widget = ItemUIs:GetRef(i)
            if Widget then
               --Widget:SetFocus()
               self.UsedList:SetSelectedIndex(i-1)
               self.UsedList:NavigateToIndex(i-1)
                if self.Owner.NeedOpenMenuWhenResoureFocused then
                    self:AddTimer(0.1,
                        function()
                        Widget:OnMouseButtonDown()
                        Widget:OnMouseButtonUp()
                        end
                ,false,0,nil,true)
                end
                return Widget
            end
        end
    end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if  self.GameInputModeSubsystem and UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
        if self.Owner.IsInViewMode then
            self:AddTimer(0.001,
                function()
                    self:FocusToRewardItem()
                end
            ,false,0,nil,true)
        else
            self.UsedList:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
            if not self.Owner then
                return self.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
            end
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(self)
            self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
        end
        if not self.Owner.IsInViewMode then
            self.Owner:ShowGamepadViewBtn(true)
            if self.Key_Item then
                self.Key_Item:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            end
            self.Btn_Reward:SetGamePadIconVisible(true)
            self.Btn_Goto:SetGamepadIconVisibility(true)
            self:AddTimer(0.1,function ()
                if not self:IsAnimationPlaying(self.In) then
                    self:StopAllAnimations()
                end
                self:PlayAnimation(self.Hover)
            end,false,0,nil,true)
        end
    end
    return self.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
end

function M:RefreshItems()
    if self.Owner.HasTab then
        self.Owner:Refresh(self.Owner.ConfigData.Datas[self.Type])
    else
        self.Owner:Refresh(self.Owner.ConfigData)
    end
end


function  M:InitRewards(Config)
    if not Config.Rewards then
        return
    end
    for _, Reward in pairs(Config.Rewards) do
       local Item=self:NewItemContent(Reward.ItemType, Reward.ItemId, Reward.Count, Reward.bHasGot)
       if Config.LeftAligned then
            self.List_Item_L:AddItem(Item)
       else
            self.List_Item_R:AddItem(Item)
       end
    end
    self.UsedList.OnCreateEmptyContent:Bind(self, function(self)
        local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
        ItemContent.IsEmpty = true
        return ItemContent
    end)
    self.UsedList.BP_OnEntryGenerated:Add(self, function(self, Widget)
        if IsValid(Widget) then
            -- Widget:ItemSetNavigationRuleCustom(self,self.OnUINavigation)
            -- Widget:SetNavigationRuleCustom(UE4.EUINavigation.Left, {self, self.OnNavigateLeft})
            -- Widget:SetNavigationRuleCustom(UE4.EUINavigation.Right, {self, self.OnNavigateRight})
            Widget:SetNavigationRuleCustom(UE4.EUINavigation.Up, {self, self.OnNavigateUp})
            Widget:SetNavigationRuleCustom(UE4.EUINavigation.Down, {self, self.OnNavigateDown})
        end
    end)
    self.UsedList:RequestFillEmptyContent()
    self:AddTimer(0.01,
        function()
            self.UsedList:SetScrollOffset(0)
        end
    ,false,0,nil,true)
end


function  M:RefreshBtn(IsGot)
    if IsGot then
        self.WS_State:SetActiveWidgetIndex(1)
         if self.Content.ConfigData.HideProgressAfterGot then
            self.Text_Progress:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        self:PlayAnimation(self.Forbidden)
    elseif self.Content.ConfigData.CanReceive then
        self.WS_State:SetActiveWidgetIndex(0)
    else
        if self.HasGoto then
            self.WS_State:SetActiveWidgetIndex(3)
        else
            self.WS_State:SetActiveWidgetIndex(2)
        end
    end
--    if self.ConfigData.RefreshReddotFunc then
--         self.ConfigData.RefreshReddotFunc(self,Content)
--    end
end

function M:RefreshReddotInfo()
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(self.ReddotName)
    if CacheDetail[self.Type] and CacheDetail[self.Type][self.ItemId] then
        CacheDetail[self.Type][self.ItemId] = nil
        if next(CacheDetail[self.Type]) == nil then
            CacheDetail[self.Type] = nil
        end
        ReddotManager.DecreaseLeafNodeCount(self.ReddotName)
    end
end


function M:RefreshBaseInfo()
    -- 刷新设备热键信息
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if (IsValid(GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(GameInputModeSubsystem:GetCurrentInputType())
        GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice) 
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self:InitKeyBoardView()
    else
        self:InitGamepadView()
    end
    
end

function M:AddInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:RemoveInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:InitGamepadView()
    self.UsedList:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    if self:HasAnyUserFocus() and not self.Owner.IsInViewMode then
        if self.Key_Item then
            self.Key_Item:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end 
    end
    if self:IsAnimationPlaying() then
        self:StopAllAnimations()
    end
    self:PlayAnimation(self.Normal)
end

function M:InitKeyBoardView()
    if self.Owner.IsInViewMode then
        self.Owner:UpdateUIStyle(true)
        self:SwitchSelectedMode()
    end
    if self.UsedList then
        self.UsedList:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    if self.Key_Item then
        self.Key_Item:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if not self:IsAnimationPlaying(self.In) then
        self:StopAllAnimations()
    end
    self:PlayAnimation(self.Normal)
end

function M:InitBreakStartCount(BreakStarCount)
    for i = 1, 6 do
        local Star = self["Star_"..i]
        if Star then
            Star.Main:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            if i <= BreakStarCount then
                Star.Switcher_Star:SetActiveWidgetIndex(0)
            end
        end
    end
end

function M:Destruct()
    self:RemoveInputMethodChangedListen()
    self.Super.Destruct(self)
end


--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:NewItemContent(ItemType, ItemId, Count, HasGot)
    if ItemId == 0 then
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        return Obj
    end
    local ItemData = DataMgr[ItemType][ItemId]
    if not ItemData then
        print(_G.LogTag, "Error: Item Data is nil, ItemType:", ItemType, "ItemId", ItemId)
        return nil
    end
    --新建一个列表数据对象
    local NewObj = NewObject(UIUtils.GetCommonItemContentClass())
    NewObj.ItemType = ItemType:gsub("^%l",string.upper)
    NewObj.Id = ItemId
    NewObj.Rarity = ItemData.Rarity or ItemData.WeaponRarity or 1
    NewObj.Icon = ItemData.Icon
    NewObj.Count = Count
    NewObj.IsShowDetails = true
    NewObj.ParentWidget=self
    NewObj.bHasGot = HasGot
    NewObj.OnMenuOpenChangedEvents = {
        Obj = self,
        Callback = self.OnMenuOpenChanged
    }
    --Obj.UIName = "Reward"
    return NewObj
end

function M:OnMenuOpenChanged(bIsOpen,Obj)
    if Obj.SelfWidget then
        if bIsOpen==false and UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
            Obj.SelfWidget.Item:PlayAnimation( Obj.SelfWidget.Item.Hover)
        end
    end
    self.Owner:OnMenuOpenChanged(bIsOpen)
end

function M:OnNavigateLeft()
    if  self.SelectedIndex-1>=0 then
        return self:UpdateSelectedWidget(self.SelectedIndex-1)
    end
    local CurItem = self.UsedList:GetItemAt(self.SelectedIndex)
    return CurItem.SelfWidget
end
function M:UpdateSelectedWidget(SelectedIndex)
    self.Owner.NeedOpenMenuWhenResoureFocused=false
    local CurItem = self.UsedList:GetItemAt(self.SelectedIndex)
    if CurItem and CurItem.SelfWidget then
        local CurWdiget = CurItem.SelfWidget
        self.Owner.NeedOpenMenuWhenResoureFocused =CurWdiget.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen()
        if  self.Owner.NeedOpenMenuWhenResoureFocused  then
            -- CurWdiget:OnMouseButtonDown()
            -- CurWdiget:OnMouseButtonUp()
        end
    end
    self.SelectedIndex=SelectedIndex
    self.UsedList:NavigateToIndex(self.SelectedIndex)
    local NewFocusItem=self.UsedList:GetItemAt(self.SelectedIndex)
    self.UsedList:SetSelectedIndex(self.SelectedIndex)
    if NewFocusItem and NewFocusItem.SelfWidget then
        if  self.Owner.NeedOpenMenuWhenResoureFocused  then
            self:AddTimer(0.01,
            function()
                NewFocusItem.SelfWidget:OnMouseButtonDown()
                NewFocusItem.SelfWidget:OnMouseButtonUp()
           end
        ,false,0,nil,true)
            -- NewFocusItem.SelfWidget:OnMouseButtonDown()
            -- NewFocusItem.SelfWidget:OnMouseButtonUp()
        end
        return NewFocusItem.SelfWidget
    end
    return
end
function M:OnNavigateRight()
    local ItemsCount=self.UsedList:GetNumItems()
    if  self.SelectedIndex+1<ItemsCount then
        return self:UpdateSelectedWidget(self.SelectedIndex+1)
    end
    local CurItem = self.UsedList:GetItemAt(self.SelectedIndex)
    return CurItem.SelfWidget
end

function M:OnNavigateDown()
    local CurItem = self.UsedList:GetItemAt(self.SelectedIndex)
    if CurItem and CurItem.SelfWidget then
        local CurWdiget = CurItem.SelfWidget
        self.Owner.NeedOpenMenuWhenResoureFocused = CurWdiget.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen()
        if self.Owner.NeedOpenMenuWhenResoureFocused then
            CurWdiget:OnMouseButtonDown()
            CurWdiget:OnMouseButtonUp()
        end
    end
    return self.Owner:OnNavigateDown(self.Content)
end

function M:OnNavigateUp()
    local CurItem = self.UsedList:GetItemAt(self.SelectedIndex)
    if CurItem and CurItem.SelfWidget then
        local CurWdiget = CurItem.SelfWidget
        self.Owner.NeedOpenMenuWhenResoureFocused = CurWdiget.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen()
        if self.Owner.NeedOpenMenuWhenResoureFocused then
            CurWdiget:OnMouseButtonDown()
            CurWdiget:OnMouseButtonUp()
        end
    end
    return self.Owner:OnNavigateUp(self.Content)
end



function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled=false
    -- 处理手柄相关的交互事件
    if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
        if (InKeyName == UIConst.GamePadKey.LeftThumb) then
            IsEventHandled=true
           self:SwitchSelectedMode()
        elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
            if self.Owner.IsInViewMode then
                IsEventHandled=true
                self:SwitchSelectedMode()
                self:SetFocus()
            end
        elseif  InKeyName == UIConst.GamePadKey.FaceButtonBottom then
            IsEventHandled=true
            if self.WS_State:GetActiveWidgetIndex() == 0 then
                self.Owner.RewardContent_OneClick.Btn_OneClick:OnBtnClicked()
            end
        elseif (InKeyName== UIConst.GamePadKey.FaceButtonTop and  not self.Owner.IsInViewMode)  then
            IsEventHandled=true
            self.Owner.RewardContent_OneClick.Btn_OneClick:OnBtnClicked()
        end
    elseif InKeyName=="SpaceBar" then
            IsEventHandled=true
            self.Owner.RewardContent_OneClick.Btn_OneClick:OnBtnClicked()
    end
    if IsEventHandled then
        return UWidgetBlueprintLibrary.Handled()
    else
        return UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled=false
    -- 处理手柄相关的交互事件
    if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
       if  InKeyName == UIConst.GamePadKey.FaceButtonBottom and not self.Owner.IsInViewMode then
            IsEventHandled=true
            if self.WS_State:GetActiveWidgetIndex() == 0 then
                self.Btn_Reward:OnBtnClicked()
            elseif self.WS_State:GetActiveWidgetIndex() == 3 then
                self.Btn_Goto:OnBtnClicked()
            end
        end
    end
    if IsEventHandled then
        return UWidgetBlueprintLibrary.Handled()
    else
        return UWidgetBlueprintLibrary.UnHandled()
    end
end

--切换奖励查看模式
function M:SwitchSelectedMode()
    if self.Owner.IsInViewMode then
        self.Owner.RewardContent_OneClick.Btn_OneClick:SetGamePadIconVisible(true)
        self.Owner.IsInViewMode=false
        self:SetFocus()
        self.Owner:ShowGamepadViewBtn(true)
        if self.Key_Item then
            self.Key_Item:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
        --self.Owner:ShowGamepadViewSingleBtn(false)
        if self.Owner.Key_Check then
            self.Owner.Key_Check:SetVisibility(UIConst.VisibilityOp.Visible)
        end
    else
        self.Owner.RewardContent_OneClick.Btn_OneClick:SetGamePadIconVisible(false)
        self.UsedList:SetVisibility(UIConst.VisibilityOp.Visible)
        if self.Key_Item then
            self.Key_Item:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        self.Owner.IsInViewMode=true
        self.SelectedIndex = 0
        self:FocusToRewardItem()
        self.Owner:ShowGamepadViewBtn(false)
        self.Owner:ShowGamepadViewSingleBtn(true)
        if self.Owner.Key_Check then
            self.Owner.Key_Check:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    self.IsEnter = true
    local IsGamePad=UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad
    if self.Mobile or self:IsAnimationPlaying(self.In) or not IsGamePad then
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    -- if not self:IsAnimationPlaying(self.In) then
    --     self:StopAllAnimations()
    -- end
    -- self:PlayAnimation(self.Hover)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    self.IsEnter = false
     local IsGamePad=UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad
    if self.Mobile or self:IsAnimationPlaying(self.In) or not IsGamePad then
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    if not self:IsAnimationPlaying(self.In) then
        self:StopAllAnimations()
    end
    self:PlayAnimationReverse(self.Hover)
end

function M:OnFocusLost(InFocusEvent)
    self.Btn_Reward:SetGamePadIconVisible(false)
    self.Btn_Goto:SetGamepadIconVisibility(false)
    if self.Key_Item then
        self.Key_Item:SetVisibility(UIConst.VisibilityOp.Collapsed)
end
    -- if self.Owner.HasTab then
    --     self.Owner:ShowGamepadViewBtn(false)
    -- end
end

return M

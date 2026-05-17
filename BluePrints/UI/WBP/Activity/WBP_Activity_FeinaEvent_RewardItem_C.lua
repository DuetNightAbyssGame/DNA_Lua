--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local WBP_Activity_FeinaEvent_RewardItem_C = Class({"Blueprints.UI.BP_UIState_C"})

--function M:Initialize(Initializer)
--end

function WBP_Activity_FeinaEvent_RewardItem_C:Construct()
    self.Btn_Reward:BindEventOnClicked(self, self.OnClicked)
    self.Text_Ing:SetText(GText("UI_EventReward_NotAchieved"))
    self.Btn_Reward:SetText(GText("UI_Archive_CollectionClaim"))
    self.LeastRewardNum=3
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
        self.List_Item.OnCreateEmptyContent:Bind(self, function()
        local NewContent = NewObject(UIUtils.GetCommonItemContentClass())
        NewContent.ParentWidget = self
        return NewContent
    end)
    self:InitListenEvent()
    self:InitWidgetInfoInGamePad()
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function WBP_Activity_FeinaEvent_RewardItem_C:Destruct()
    self:ClearListenEvent()
    self.List_Item.OnCreateEmptyContent:Unbind()
end

function WBP_Activity_FeinaEvent_RewardItem_C:OnListItemObjectSet(Content)
    self.Content = Content
    self.Content.Entry = self
    self.ItemIndex=Content.Index
    self.DungeonId=Content.DungeonId
    self.Num = Content.Num
    self.Text_Content:SetText(string.format(GText("FeinaEvent_DungeonTask_1"),Content.Num))
    self:RefreshState()
    self:RefreshRewardsList()
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self.List_Item:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
end

function WBP_Activity_FeinaEvent_RewardItem_C:RefreshState()
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.FeiNaDungeonData[self.DungeonId] then
        local IsGot=Avatar.FeiNaDungeonData[self.DungeonId].RewardsGot[self.ItemIndex]==CommonConst.FeiNaState.GetReward
        local CanGet= Avatar.FeiNaDungeonData[self.DungeonId]:IsComplete(self.ItemIndex)
        DebugPrint("Ljh RefreshState DungeonId:"..tostring(self.DungeonId).." ItemIndex:"..tostring(self.ItemIndex).." IsGot:"..tostring(IsGot).." CanGet:"..tostring(CanGet))
        if  CanGet then
            self.WS_State:SetActiveWidgetIndex(0)
        else
            if IsGot then
                self.WS_State:SetActiveWidgetIndex(1)
            else
                self.WS_State:SetActiveWidgetIndex(2)
            end
        end
    else
        self.WS_State:SetActiveWidgetIndex(2)
    end
end

function WBP_Activity_FeinaEvent_RewardItem_C:TryOnClicked()
    if self.WS_State:GetActiveWidgetIndex() == 1 then
        self:OnClicked()
    end
end

function WBP_Activity_FeinaEvent_RewardItem_C:OnClicked()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local Callback = function (Errorcode,Rewards)
            self:RefreshState()
            self:RefreshRewardsList()
            self:RefreshReddotInfo()
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function ()
                self:SetFocus()
            end, self)
            EventManager:FireEvent(EventID.OnGetFeiNaReward)
        end
        Avatar:GetFeiNaProgressRewerd(Callback,self.Content.DungeonId, self.ItemIndex)
    end
end

function WBP_Activity_FeinaEvent_RewardItem_C:RefreshReddotInfo()
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("FeinaEventReward")
    if CacheDetail[self.Content.Type] and CacheDetail[self.Content.Type][self.Content.DungeonId][self.Content.Index] then
        CacheDetail[self.Content.Type][self.Content.DungeonId][self.Content.Index] = nil
        if next(CacheDetail[self.Content.Type][self.Content.DungeonId]) == nil then
            CacheDetail[self.Content.Type] = nil
        end
        ReddotManager.DecreaseLeafNodeCount("FeinaEventReward")
    end
end

function WBP_Activity_FeinaEvent_RewardItem_C:RefreshRewardsList()
    local Rewards = {self.Content.RewardId}
    self.List_Item:ClearListItems()
    self.List_Item:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    local IsGot = self.WS_State:GetActiveWidgetIndex() == 1
    for _, RewardId in pairs(Rewards) do
        local RewardInfo = DataMgr.Reward[RewardId]
        if RewardInfo then
            local Ids = RewardInfo.Id or {}
            local RewardCount = RewardInfo.Count or {}
            local TableName = RewardInfo.Type or {}
            for i = 1, #Ids do
                local Content = NewObject(UIUtils.GetCommonItemContentClass())
                local ItemId = Ids[i]
                --Content.UIName = "RougeDifficultySelection"
                Content.IsShowDetails = true
                Content.Id = ItemId
                Content.Count = RewardUtils:GetCount(RewardCount[i])
                Content.Icon = ItemUtils.GetItemIconPath(ItemId, TableName[i])
                Content.Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
                Content.ItemType = TableName[i]
                Content.Parent = self
                Content.bHasGot = IsGot
                Content.OnMenuOpenChangedEvents = {
                    Obj = self,
                    Callback = self.OnMenuOpenChanged
                }
                self.List_Item:AddItem(Content)
            end
            for i=#Ids,self.LeastRewardNum-1 do
                local Content = NewObject(UIUtils.GetCommonItemContentClass())
                Content.ParentWidget = self
                self.List_Item:AddEmptyGridItemCount(1)
                self.List_Item:AddItem(Content)
            end
        end
    end
    self.List_Item:RequestFillEmptyContent()
end

function WBP_Activity_FeinaEvent_RewardItem_C:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function WBP_Activity_FeinaEvent_RewardItem_C:ClearListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

function WBP_Activity_FeinaEvent_RewardItem_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function WBP_Activity_FeinaEvent_RewardItem_C:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if IsUseKeyAndMouse then
		self:InitKeyboardView()
	else
		self:InitGamepadView()
	end
end

function WBP_Activity_FeinaEvent_RewardItem_C:InitWidgetInfoInGamePad()
	-- if self.Btn_Reward then
	-- 	self.Btn_Reward:CreateCommonKey({
	-- 		KeyInfoList={
	-- 			{
	-- 				Type = "Img",
	-- 				ImgShortPath = "A",
	-- 			},
	-- 		},
	-- 	})
	-- end
    self.Controller_Reward:CreateCommonKey({
			KeyInfoList={
				{
					Type = "Img",
					ImgShortPath = "LS",
				},
			},
		})
end

function WBP_Activity_FeinaEvent_RewardItem_C:InitKeyboardView()
    self.Btn_Reward:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.List_Item:SetVisibility(UIConst.VisibilityOp.Visible)
    self:PlayAnimation(self.Normal)
    self.Controller_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function WBP_Activity_FeinaEvent_RewardItem_C:InitGamepadView()
    self.Btn_Reward:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    self.List_Item:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function WBP_Activity_FeinaEvent_RewardItem_C:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == "Gamepad_LeftThumbstick") then
            IsEventHandled = true
            self:EnterOrLeaveSelectMode(self.Content.Index)
        elseif (InKeyName == "Gamepad_FaceButton_Right") then
            if self.Content.Root.IsInSelectState then
                IsEventHandled = true
                self:LeaveSelectMode(self.Content.Index)
            else
                IsEventHandled=true
                self.Content.Root:NavigateToLeftTab(true)
            end
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end


function WBP_Activity_FeinaEvent_RewardItem_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled=false
    -- 处理手柄相关的交互事件
    if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
       if  InKeyName == UIConst.GamePadKey.FaceButtonBottom and not self.Content.Root.IsInViewMode then
            IsEventHandled=true
            if self.WS_State:GetActiveWidgetIndex() == 0 then
                self.Btn_Reward:OnBtnClicked()
            end
        end
    end
    if IsEventHandled then
        return UWidgetBlueprintLibrary.Handled()
    else
        return UWidgetBlueprintLibrary.UnHandled()
    end
end

function WBP_Activity_FeinaEvent_RewardItem_C:OnFocusReceived(MyGeometry, InFocusEvent)
    if  self.GameInputModeSubsystem and UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad  then
        if not self.Content.Root.IsInSelectState then
            self.Btn_Reward:SetGamePadIconVisible(true)
            self.List_Item:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
            self.Controller_Reward:SetVisibility(UIConst.VisibilityOp.Visible)
            if not self.Content.Root then
                return self.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
            end
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(self)
            self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
        else
            self:AddTimer(0.001,
            function()
                self:FocusToRewardItem()
            end
        ,false,0,nil,true)
        end
    end
    return UIUtils.Handled
end

function WBP_Activity_FeinaEvent_RewardItem_C:OnFocusLost(InFocusEvent)
    if  self.GameInputModeSubsystem and UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad  then
        if not self.Content.Root.IsInSelectState then
            self.Btn_Reward:SetGamePadIconVisible(false)
            self.Controller_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
end

function WBP_Activity_FeinaEvent_RewardItem_C:EnterOrLeaveSelectMode(Index)
    if self.Content.Root.IsInSelectState then
        self:LeaveSelectMode(Index)
    else
        self:EnterSelectMode(Index)
    end
end

function  WBP_Activity_FeinaEvent_RewardItem_C:EnterSelectMode(Index)
    if (self.Content.Root.IsInSelectState) then
        return
    end
    if (IsValid(self.GameInputModeSubsystem)) then
        self.Content.Root.Btn_GetAll:SetGamePadIconVisible(false)
        self.List_Item:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Controller_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
        if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
            self.Content.Root.Key_Tip:UpdateKeyInfo({
                {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "A"}},
                    Desc = GText("UI_Controller_CheckDetails")
                },
                {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "B"}},
                    Desc = GText("UI_Tips_Close")
                },
            })
        end
        self.Btn_Reward:SetGamePadIconVisible(false)
        local Item = self.List_Item:GetItemAt(0)
        if Item.SelfWidget then
            Item.SelfWidget:SetFocus()
        end
        self.Content.Root.IsInSelectState = true
    end
end

function WBP_Activity_FeinaEvent_RewardItem_C:OnMouseEnter(MyGeometry, MouseEvent)
    self.IsEnter = true
    local IsGamePad=UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad
    if self.Mobile or self:IsAnimationPlaying(self.In) or not IsGamePad then
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    self:StopAllAnimations()
      self:PlayAnimation(self.Hover)
end

function WBP_Activity_FeinaEvent_RewardItem_C:OnMouseLeave(MyGeometry, MouseEvent)
    self.IsEnter = false
     local IsGamePad=UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad
    if self.Mobile or self:IsAnimationPlaying(self.In) or not IsGamePad then
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    self:StopAllAnimations()
    self:PlayAnimationReverse(self.Hover)
end

function WBP_Activity_FeinaEvent_RewardItem_C:FocusToRewardItem()
    self.List_Item:SetVisibility(UIConst.VisibilityOp.Visible)
    local ItemUIs = self.List_Item:GetDisplayedEntryWidgets()
    self.SelectedIndex=0
    if ItemUIs:Length() > 0 then
        local TargetWidget = nil
        for i=1,ItemUIs:Length() do
            local Widget = ItemUIs:GetRef(i)
            if Widget then
               Widget:SetFocus()
                -- if self.Owner.NeedOpenMenuWhenResoureFocused then
                --     self:AddTimer(0.1,
                --         function()
                --         Widget:OnMouseButtonDown()
                --         Widget:OnMouseButtonUp()
                --         end
                -- ,false,0,nil,true)
                -- end
                return Widget
            end
        end
    end
end


function  WBP_Activity_FeinaEvent_RewardItem_C:LeaveSelectMode()
    if (not self.Content.Root.IsInSelectState) then
        return
    end
    if (IsValid(self.GameInputModeSubsystem)) then
        self.Content.Root.Btn_GetAll:SetGamePadIconVisible(true)
        self.Controller_Reward:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Btn_Reward:SetGamePadIconVisible(true)
        self.List_Item:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
            self.Content.Root.Key_Tip:UpdateKeyInfo({
                {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "B"}},
                    Desc = GText("UI_Tips_Close")
                },
            })
        end
        self.Content.Root.IsInSelectState = false
        self:SetFocus()
    end
end

function  WBP_Activity_FeinaEvent_RewardItem_C:LeaveSelectModeOrClose(Index)
    if (not self.Content.Root.IsInSelectState) then
        self:OnReturnKeyDown()
    end
    self:LeaveSelectMode(Index)
end

function WBP_Activity_FeinaEvent_RewardItem_C:UpdateUIStyle(IsVisible)
    if IsVisible then
        self.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function WBP_Activity_FeinaEvent_RewardItem_C:OnMenuOpenChanged(bIsOpen,Obj)
    if not bIsOpen then
        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            Obj.SelfWidget.Item:PlayAnimation(Obj.SelfWidget.Item.Hover)
        end
    end
    self.Content.Root:OnMenuOpenChanged(bIsOpen)
end

return WBP_Activity_FeinaEvent_RewardItem_C

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_BattlePass_RewardItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

function M:Construct()
    -- self.Btn_Click.OnClicked:Add(self, self.OnCellClicked)
    -- self.Btn_Click.OnHovered:Add(self, self.OnCellHovered)
    -- self.Btn_Click.OnUnhovered:Add(self, self.OnCellUnhovered)
    if self.Btn_Qa then
        local ConfigData={}
        ConfigData.OwnerWidget=self
        ConfigData.MenuPlacement = EMenuPlacement.MenuPlacement_CenteredAboveAnchor
        ConfigData.SoundFunc= function ()
            AudioManager(self):PlayUISound(nil,"event:/ui/common/click_btn_small", nil, nil)
        end
        ConfigData.TextContent=GText("UI_BattlePass_RewardExpandRule")
        self.Btn_Qa:Init(ConfigData)
    end

    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
    self:InitListenEvent()
	self:InitWidgetInfoInGamePad()
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self:ClearListenEvent()
end

function M:SetSp()
    self.IsSp = true
end

function M:Init(Content)
    self:OnListItemObjectSet(Content)
end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.Content.Entry = self
    self.Reward_Normal:SetNavigationRuleCustom(EUINavigation.Up,{self,self.OnUINavigation})
    self.Reward_Normal:SetNavigationRuleCustom(EUINavigation.Down,{self,self.OnUINavigation})
    self.Reward_Sp:SetNavigationRuleCustom(EUINavigation.Up,{self,self.OnUINavigation})
    self.Reward_Sp:SetNavigationRuleCustom(EUINavigation.Down,{self,self.OnUINavigation})
    self.Reward_Sp_1:SetNavigationRuleCustom(EUINavigation.Up,{self,self.OnUINavigation})
    self.Reward_Sp_1:SetNavigationRuleCustom(EUINavigation.Down,{self,self.OnUINavigation})
    if self.Reward_Normal_Loop then
        self.Reward_Normal_Loop:SetNavigationRuleCustom(EUINavigation.Up,{self,self.OnUINavigation})
        self.Reward_Normal_Loop:SetNavigationRuleCustom(EUINavigation.Down,{self,self.OnUINavigation})
        self.Reward_Sp_Loop:SetNavigationRuleCustom(EUINavigation.Up,{self,self.OnUINavigation})
        self.Reward_Sp_Loop:SetNavigationRuleCustom(EUINavigation.Down,{self,self.OnUINavigation})
        self.Reward_Sp_Loop_1:SetNavigationRuleCustom(EUINavigation.Up,{self,self.OnUINavigation})
        self.Reward_Sp_Loop_1:SetNavigationRuleCustom(EUINavigation.Down,{self,self.OnUINavigation})
    end
    if self.IsSp then
        self.Reward_Normal:SetNavigationRuleCustom(EUINavigation.Left,{self,self.OnUINavigation})
        self.Reward_Normal:SetNavigationRuleCustom(EUINavigation.Right,{self,self.OnUINavigation})
        self.Reward_Sp:SetNavigationRuleCustom(EUINavigation.Left,{self,self.OnUINavigation})
        self.Reward_Sp:SetNavigationRuleCustom(EUINavigation.Right,{self,self.OnUINavigation})
        self.Reward_Sp_1:SetNavigationRuleCustom(EUINavigation.Left,{self,self.OnUINavigation})
        self.Reward_Sp_1:SetNavigationRuleCustom(EUINavigation.Right,{self,self.OnUINavigation})
    end
    self:Refresh()
end

function M:Refresh()
    self:RefreshState()
    self:RefreshLevel()
    self.Content.MaxIndex = 0
    if self.Content.IsLoop and not self.IsSp then
        if self.Content.IsLoopEmpty then
            self.WS_Loop:SetActiveWidgetIndex(1)
        else
            self.WS_Loop:SetActiveWidgetIndex(0)
            self:RefreshReward(self.Reward_Normal_Loop, self.Content.Rank1Reward, 1, self.Content.IsGotState_Rank1, false)
            self:RefreshReward(self.Reward_Sp_Loop, self.Content.Rank2Reward, 1, self.Content.IsGotState_Rank2, true)
            self:RefreshReward(self.Reward_Sp_Loop_1, self.Content.Rank2Reward, 2, self.Content.IsGotState_Rank2, true)
        end
    else
        self:RefreshReward(self.Reward_Normal, self.Content.Rank1Reward, 1, self.Content.IsGotState_Rank1, false)
        self:RefreshReward(self.Reward_Sp, self.Content.Rank2Reward, 1, self.Content.IsGotState_Rank2, true)
        self:RefreshReward(self.Reward_Sp_1, self.Content.Rank2Reward, 2, self.Content.IsGotState_Rank2, true)
    end
    -- if self.Content.IsLoopEmpty then
    --     self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    -- elseif not self.IsSp then
    --     self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    -- end
end

function M:RefreshState()
    -- if self.Content.IsGotState then
    -- else
    -- end
    if not self.IsSp then
        if self.Content.IsLoop then
            self.WS_State:SetActiveWidgetIndex(1)
        else
            self.WS_State:SetActiveWidgetIndex(0)
        end
    end
end

function M:RefreshLevel()
    if self.Content.IsLoopEmpty then
        if self.Content.Index and self.Content.LevelLimit and self.Content.Index > self.Content.LevelLimit then
            self.Text_Empty:SetText(GText("UI_BattlePass_ExpandMaximum"))
        else
            self.Text_Empty:SetText(GText("UI_BattlePass_ToBeExpand"))
        end
    else
        local Text_Level = self.Text_Level
        if self.Content.IsLoop and not self.IsSp then
            Text_Level = self.Text_Level_Loop
        end
        if Text_Level and self.Content.BattlePassLevel then
            if self.Content.BattlePassLevel >= 0 and self.Content.BattlePassLevel < 10 then
                Text_Level:SetText('0'..tostring(self.Content.BattlePassLevel))
            else
                Text_Level:SetText(self.Content.BattlePassLevel)
            end
        end
    end
end

function M:RefreshReward(CommonItem, RewardId, Index, IsGotState, IsRank2)
    local RewardInfo = DataMgr.Reward[RewardId]
    if RewardInfo and RewardInfo.Id and RewardInfo.Id[Index] then
        CommonItem:SetVisibility(UIConst.VisibilityOp.Visible)
        local RewardContent = {}
        local ItemId = RewardInfo.Id[Index]
        RewardContent.Id = ItemId
        RewardContent.UnitId = ItemId
        RewardContent.Count = RewardUtils:GetCount(RewardInfo.Count[Index])
        --RewardContent.Icon = ItemUtils.GetItemIcon(ItemId, RewardInfo.Type[Index])
        RewardContent.Icon = ItemUtils.GetItemIconPath(ItemId, RewardInfo.Type[Index])
        RewardContent.Rarity = ItemUtils.GetItemRarity(ItemId, RewardInfo.Type[Index])
        RewardContent.UnitName = ItemUtils:GetDropName(ItemId, RewardInfo.Type[Index])
        RewardContent.ItemType = RewardInfo.Type[Index]
        RewardContent.HandleMouseDown = true
        RewardContent.Parent = self
        if IsGotState == 1 then
            RewardContent.bCanGet = true
            RewardContent.CanGetStyle = "White"
            RewardContent.bHasGot = false
            if not self.IsSp then
                RewardContent.OnMouseButtonUpEvents = {
                    Obj = self.Content.Root,
                    Callback = self.Content.Root.GetReward,
                    Params = {
                        self.Content.BattlePassLevel,
                        IsRank2,
                    }
                }
                RewardContent.IsShowDetails = false
            else
                RewardContent.IsShowDetails = true
            end
        elseif IsGotState == 2 then
            RewardContent.bCanGet = false
            RewardContent.bHasGot = true
            RewardContent.IsShowDetails = true
        else
            RewardContent.bCanGet = false
            RewardContent.bHasGot = false
            RewardContent.IsShowDetails = true
        end
        if IsRank2 and not self.Content.IsUnlocked then
            RewardContent.LockType = 1
        end
        RewardContent.OnAddedToFocusPathEvent = {Obj = self, Callback = self.OnFocusItemChanged, Params = RewardContent}
        CommonItem:Init(RewardContent)
        self.Content.MaxIndex = self.Content.MaxIndex + 1
    else
        CommonItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:OnUINavigation(NavigationDirection)
    if(NavigationDirection == EUINavigation.Up)then
        return self:OnNavigationToIndex(self.SelectedIndex-1)
    elseif(NavigationDirection == EUINavigation.Down) then
        return self:OnNavigationToIndex(self.SelectedIndex+1)
    elseif(NavigationDirection == EUINavigation.Left) then
        if self.IsSp then
            self.Content.Root:TryLeaveSpecialMode()
        end
    elseif(NavigationDirection == EUINavigation.Right) then
        if self.IsSp then
            self.Content.Root:TryLeaveSpecialMode()
        end
    end
    return self.FocusedReward
end

function M:OnNavigationToIndex(Index)
    if Index <= 0 or (self.Content.MaxIndex and Index > self.Content.MaxIndex) then
        if self.IsSp then
            self.Content.Root:TryLeaveSpecialMode()
        end
        return self.FocusedReward
    end
    if Index == 1 then
        if self.Content.IsLoop and not self.IsSp then
            if self.Reward_Normal_Loop:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
                self.FocusedReward = self.Reward_Normal_Loop
            end
        else
            if self.Reward_Normal:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
                self.FocusedReward = self.Reward_Normal
            end
        end
    elseif Index == 2 then
        if self.Content.IsLoop and not self.IsSp then
            if self.Reward_Sp_Loop:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
                self.FocusedReward = self.Reward_Sp_Loop
            end
        else
            if self.Reward_Sp:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
                self.FocusedReward = self.Reward_Sp
            end
        end
    elseif Index == 3 then
        if self.Content.IsLoop and not self.IsSp then
            if self.Reward_Sp_Loop_1:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
                self.FocusedReward = self.Reward_Sp_Loop_1
            end
        else
            if self.Reward_Sp_1:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
                self.FocusedReward = self.Reward_Sp_1
            end
        end
    else
        return self.FocusedReward
    end
    self.SelectedIndex = Index
    if not self.IsSp then
        self.Content.Root:SetCurFocusedRewardIndex(self,self.SelectedIndex)
    end
    return self.FocusedReward
end

function M:GetTargetIndexAndReward(Index)
    if not Index or Index == 1 then
        if self.Content.IsLoop then
            return 1,self.Reward_Normal_Loop
        else
            return 1,self.Reward_Normal
        end
    elseif Index == 2 then
        if self.Content.IsLoop then
            return 2,self.Reward_Sp_Loop
        else
            return 2,self.Reward_Sp
        end
    else
        if self.Content.IsLoop then
            if self.Reward_Sp_Loop:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
                return 3,self.Reward_Sp_Loop_1
            else
                return 2,self.Reward_Sp_Loop
            end
        else
            if self.Reward_Sp_1:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
                return 3,self.Reward_Sp_1
            else
                return 2,self.Reward_Sp
            end
        end
    end
end

function M:BP_GetDesiredFocusTarget()
    if self.IsSp then
        self.SelectedIndex,self.FocusedReward = self:GetTargetIndexAndReward()
        return self.Reward_Normal
    elseif self.Content.IsLoopEmpty then
        --self.Btn_Qa:OnViewInfoClick(true)
        self.SelectedIndex,self.FocusedReward = 1,nil
        self.Content.Root:SetCurFocusedRewardIndex(self,1)
        return self
    else
        local FocusedIndex = self.Content.Root:GetCurFocusedRewardIndex()
        self.SelectedIndex,self.FocusedReward = self:GetTargetIndexAndReward(FocusedIndex)
        self.Content.Root:SetCurFocusedRewardIndex(self,self.SelectedIndex)
        return self.FocusedReward
    end
end

function M:OnFocusItemChanged(RewardContent)
    self.Content.Root:OnFocusItemChanged(RewardContent.bCanGet, RewardContent.IsLoopEmpty)
end

function M:HideIcon()
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        if self.Key_Qa then
            self.Key_Qa:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
end

function M:ShowIcon()
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        if self.Key_Qa then
            self.Key_Qa:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        end
    end
end

function M:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:ClearListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if IsUseKeyAndMouse then
		self:InitKeyboardView()
	else
		self:InitGamepadView()
	end
end

function M:InitGamepadView()
    if self.Btn_Qa then
        self.Btn_Qa:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
end

function M:InitKeyboardView()
    if self.Btn_Qa then
        self.Btn_Qa:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.Key_Qa then
        self.Key_Qa:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:InitWidgetInfoInGamePad()
    if self.Key_Qa then
        self.Key_Qa:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "A",
                },
            },
        })
    end
end

function M:OpenTips()
    self.Btn_Qa:OnViewInfoClick(true)
end

function M:CloseTips()
    self.Btn_Qa:OnViewInfoClick(false)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == UIConst.GamePadKey.FaceButtonBottom) then
            if self.Content and self.Content.IsLoopEmpty then
                IsEventHandled = true
                self.Content.Root:OpenTips(self)
            end
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnAddedToFocusPath(InFocusEvent)
    if self.Content and self.Content.IsLoopEmpty then
        self:OnFocusItemChanged({bCanGet = false, IsLoopEmpty = true})
    end
end

return M

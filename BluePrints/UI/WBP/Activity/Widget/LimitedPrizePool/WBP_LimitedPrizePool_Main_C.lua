---@type WBP_LimitedPrizePool_JumpBG_P_C
local M = Class({ "BluePrints.UI.BP_EMUserWidget_C" })

function M:Construct()
    self.FadeInAnimation = self.In
    self.FadeOutAnimation = self.Out

    self.Title = self.Title
    self.Round = self.RewardWave
    self.Rewards = self.List_Item
    self.HistoryButton = self.Btn_History
    self.PrizeButton = self.Btn_Gacha

    self.HistoryButton:SetText(GText("UI_LimitedPrizePool_History"))
    self.HistoryButton:BindEventOnClicked(self, self.OpenHistory)
    self.HistoryButton:SetGamePadImg("X")

    self.ParentWidget = nil
    self.EventId = nil
    self.EventEndTime = nil

    self.PrizeButton:BindForbiddenPrizeDraw({ self, self.PromptSelectableRewards })
    self.PrizeButton:BindUpdateReward({ self, self.UpdateReward })
    self.PrizeButton:SetGamePadImg("Y")

    self.Round:BindOnMenuOpenChanged({ self, self.OnMenuOpenChangedEvent })

    self.Rewards:SetNavigationRuleCustom(EUINavigation.Left, {self,self.LeaveRewardViewMode})

    self:SetInputType(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())
    self:ListenInputTypeChanged()
end

function M:Destruct()
    self.PrizeButton:UnbindForbiddenPrizeDraw()
    self.PrizeButton:UnbindUpdateReward()
    self.Round:UnbindindOnMenuOpenChanged()
    self.HistoryButton:UnBindEventOnClicked(self, self.OpenHistory)

    self:UnlistenInputTypeChanged()
end

function M:ListenInputTypeChanged()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UE4.UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.SetInputType)
    end
end

function M:UnlistenInputTypeChanged()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UE4.UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.SetInputType)
    end
end

function M:SetInputType(NewInputType, NewGamepadName)
    if (NewInputType == ECommonInputType.Touch) then
    elseif NewInputType == ECommonInputType.Gamepad then
    else
    end
end

function M:InitPage(ActivityId, TabId, ActivityInfo, ParentWidget)
    local EventData = DataMgr.EventMain[ActivityId]
    if (not EventData) then
        return
    end

    self.ParentWidget = ParentWidget
    self.EventId = ActivityId
    self.EventEndTime = EventData.EventEndTime

    self.PrizeButton:SetEventId(self.EventId)

    self.Title:SetTitle(GText(EventData.EventName))
    self.Title:SetDesc(GText(EventData.EventDes), false)

    self:SetEndTime(EventData.EventEndTime)
    self:SetPool(ActivityId)
end

function M:UpdatePage()
    self:SetEndTime(self.EventEndTime)
end

function M:OnGamePadButtonDown(InKeyName)
end

function M:HandleKeyDownInPage(MyGeometry, InKeyEvent)
    local bHandled = false

    local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(Key)) then
        if self:IsInCheckDetailMode() and KeyName ~= UIConst.GamePadKey.FaceButtonRight and KeyName ~= UIConst.GamePadKey.SpecialLeft then
            bHandled = true
        elseif (KeyName == UIConst.GamePadKey.SpecialLeft) then
            bHandled = true
            self.Round:SetQAChecked(not self.Round:IsQAChecked())
        elseif (KeyName == UIConst.GamePadKey.FaceButtonBottom) then
            bHandled = true
            self:EnterRewardViewMode()
        elseif (KeyName == UIConst.GamePadKey.FaceButtonRight) then
            if self.Round:IsQAChecked() then
                bHandled = true
                self.Round:SetQAChecked(false)
                if self.FocusWidget then
                    self.FocusWidget:SetFocus()
                else
                    self:EnterRewardViewMode()
                end
            end
        elseif (KeyName == UIConst.GamePadKey.FaceButtonLeft) then
            if self.WS:GetActiveWidgetIndex() == 0 then
                bHandled = true
                self.HistoryButton:OnBtnClicked()
            end
        elseif (KeyName == UIConst.GamePadKey.FaceButtonTop) then
            if self.WS:GetActiveWidgetIndex() == 0 then
                bHandled = true
                self.PrizeButton:PrizeDraw()
            end
        end
    end

    return bHandled
end

function M:ShowPage()
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function M:HidePage()
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:PlayFadeIn()
    self:PlayAnimation(self.FadeInAnimation)
end

function M:PlayFadeOut()
    self:PlayAnimation(self.FadeOutAnimation)
end

function M:GetPageConfigData()
    return {}
end

function M:GetDefaultBottomTips()
    local ResultKeyInfo = {
        {
            KeyInfoList = { { Type = "Img", ImgShortPath = "A" } },
            Desc = GText("UI_CTL_Select")
        },
        {
            KeyInfoList = { { Type = "Img", ImgShortPath = "B", ClickCallback = self.OnReturnKeyDown, Owner = self } },
            Desc = GText("UI_Tips_Close")
        },
    }
    return ResultKeyInfo
end

function M:SetEndTime(EndTime)
    self.Title:SetTime(EndTime)

    if (self.Title:IsTimeOut()) then
        self:SetIsEnabled(false)
    else
        self:SetIsEnabled(true)
    end
end

function M:SetPool(PoolId)
    local PoolData = DataMgr.LimitedPrizePool[PoolId]
    if (not PoolData) then
        return
    end

    local CurrentRound = 1
    local NextDrawCount = 1
    local Avatar = GWorld:GetAvatar()
    if (Avatar) then
        local LimitPrizeData = Avatar.LimitPrize[PoolId]
        if (LimitPrizeData) then
            local Round = LimitPrizeData.Round
            if Round > #PoolData.LimitedPrizePoolId then
                Round = #PoolData.LimitedPrizePoolId
            end
            CurrentRound = Round
            if LimitPrizeData.DrawCounts then
                NextDrawCount = LimitPrizeData.DrawCounts + 1
            end
        end
    end

    self.Round:SetCurrentRound(CurrentRound)
    self.Round:SetTotalRound(#PoolData.LimitedPrizePoolId)
    self:SetRound(PoolId, CurrentRound, PoolData.LimitedPrizePoolId[CurrentRound], NextDrawCount)
end

function M:SetRound(PoolId, Round, RoundId, NextDrawCount)
    local RoundData = DataMgr.LimitedPrizeItem[RoundId]
    if (not RoundData) then
        return
    end

    self.Rewards:ClearListItems()
    local RewardNumber = #RoundData.Id
    for i = 1, RewardNumber do
        self:AddReward(PoolId, i, RoundData.Id[i], RoundData.Type[i], RoundData.Count[i], RoundData.Probability[i])
    end

    self.PrizeButton:SetCost(RoundData.CostRuleId, Round, NextDrawCount)
    self:UpdatePrizeButtonState()
end

function M:UpdatePrizeButtonState()
    local bAllSelected = true
    local bAllGot = true
    local Items = self.Rewards:GetListItems()
    for _, Item in pairs(Items) do
        if IsValid(Item) then
            if bAllSelected and Item.Id == nil then
                bAllSelected = false
            end
            if bAllGot and not Item.bGot then
                bAllGot = false
            end
        end
    end
    if bAllGot then
        self.WS:SetActiveWidgetIndex(2)
    else
        self.WS:SetActiveWidgetIndex(0)
    end
    self.PrizeButton:SetForbidden(not bAllSelected)
end

function M:AddReward(PoolId, Number, Ids, Type, Count, Probability)
    local Content = UE4.NewObject(UIUtils.GetCommonItemContentClass())
    Content.EventId = self.EventId
    Content.Number = Number
    Content.Ids = Ids
    Content.Type = ItemUtils.GetItemType(Type)
    Content.Count = Count
    Content.SelectedIndex = 0
    Content.Probability = Probability

    Content.Id = #Ids == 1 and Ids[1] or nil
    Content.bLocked = false
    Content.bGot = false

    local Avatar = GWorld:GetAvatar()
    if (Avatar) then
        local LimitPrizeData = Avatar.LimitPrize[PoolId]
        if (LimitPrizeData) then
            Content.bLocked = LimitPrizeData.DrawCounts > 0

            local SelfSelectData = LimitPrizeData.SelfSelect
            if SelfSelectData and SelfSelectData[Number] then
                local Index = SelfSelectData[Number]
                Content.SelectedIndex = Index
                Content.Id = Ids[Index] or nil
            end

            for _, GotNumber in pairs(LimitPrizeData.HasDrawPrizes) do
                if (GotNumber == Number) then
                    Content.bGot = true
                    break
                end
            end
        end
    end

    Content.OnSetSelectableReward = { self, self.HandleSetSelectableReward }
    Content.OnFocusWidget = { self, self.UpdateParentActivityKeyTips }
    Content.OnMenuOpenChangedEvent = { self, self.OnMenuOpenChangedEvent }

    self.Rewards:AddItem(Content)
end

function M:PromptSelectableRewards()
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_LimitedPrizePool_SelectToast"))

    local EntryWidgets = self.Rewards:GetDisplayedEntryWidgets()
    for _, EntryWidget in pairs(EntryWidgets) do
        if (IsValid(EntryWidget)) then
            EntryWidget:TryPromptSelectableReward()
        end
    end
end

function M:HandleSetSelectableReward()
    self:UpdatePrizeButtonState()
end

function M:UpdateReward()
    self:SetPool(self.EventId)
end

function M:OpenHistory()
    if self.EventId then
        UIManager(self):ShowCommonPopupUI(100334, {
            PoolId = self.EventId
        })
    end
end

function M:GetCurFocusWidgetInfo()
    return self.FocusWidgetName, self.FocusWidget
end

-- function M:OnUpdateSubUIViewStyle(IsUseGamePad, bIsWithButton)
--     UE.UKismetSystemLibrary.PrintString(self,"OnUpdateSubUIViewStyle")
--     IsUseGamePad = IsUseGamePad and self:IsCanChangeToGamePadViewMode()
-- end

function M:OnSubTabNavigationRight()
    self:EnterRewardViewMode()
end

function M:EnterRewardViewMode()
    self.Rewards:NavigateToIndex(0)
end

function M:LeaveRewardViewMode()
    if (self.ParentWidget) then
        self.ParentWidget:UpdateActivityKeyTips()
        self.ParentWidget:SetFocus()
    end
end

function M:UpdateParentActivityKeyTips(FocusWidgetName, FocusWidget, bIsFocusToParent)
    self.FocusWidgetName = FocusWidgetName
    self.FocusWidget = FocusWidget
    if (self.ParentWidget) then
        self.ParentWidget:UpdateActivityKeyTips(FocusWidgetName, FocusWidget)
        if (bIsFocusToParent) then
            self.ParentWidget:SetFocus()
        end
    end
end

function M:EnterCheckDetailMode()
    self.bInCheckDetailMode = true
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self.HistoryButton:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
        self.PrizeButton:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
        if not self.Round:IsQAChecked() then
            self.Round:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
        end
        self.ParentWidget:UpdateActivityKeyTips("EmptyView")
        self.ParentWidget.Activity_Tab.WBP_Com_Tab_ResourceBar:HideGamePadKey(true)
    end
end

function M:LeaveCheckDetailMode()
    self.bInCheckDetailMode = false
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self.HistoryButton:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.PrizeButton:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Round:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.ParentWidget.Activity_Tab.WBP_Com_Tab_ResourceBar:HideGamePadKey(false)
    end
    if self.FocusWidget then
        self.FocusWidget:SetFocus()
    else
        self:EnterRewardViewMode()
    end
end

function M:IsInCheckDetailMode()
    return self.bInCheckDetailMode
end

function M:OnMenuOpenChangedEvent(IsOpen)
    if IsOpen then
        self:EnterCheckDetailMode()
    else
        self:LeaveCheckDetailMode()
    end
end

return M

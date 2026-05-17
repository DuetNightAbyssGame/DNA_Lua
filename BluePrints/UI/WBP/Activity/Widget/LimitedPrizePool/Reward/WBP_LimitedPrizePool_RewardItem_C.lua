---@type WBP_LimitedPrizePool_RewardItem_C
local M = Class({ "BluePrints.UI.BP_EMUserWidget_C" })

function M:Construct()
    self.RewardSwitcher = self.WS_Type
end

function M:Destruct()
end

function M:OnListItemObjectSet(Content)
    if (Content.Number == 1) then
        self.RewardSwitcher:SetActiveWidgetIndex(2)
    else
        if (#Content.Ids == 1) then
            self.RewardSwitcher:SetActiveWidgetIndex(0)
        else
            self.RewardSwitcher:SetActiveWidgetIndex(1)
        end
    end

    local RewardItemWidget = self.RewardSwitcher:GetActiveWidget()
    if (not IsValid(RewardItemWidget)) then
        return
    end

    RewardItemWidget:Init(Content)
end

function M:TryPromptSelectableReward()
    local ActiveWidget = self.RewardSwitcher:GetActiveWidget()
    if (not IsValid(ActiveWidget)) then
        return
    end

    ActiveWidget:TryPromptSelectableReward()
end

function M:PlayGachaInAnimation()
    local ActiveWidget = self.RewardSwitcher:GetActiveWidget()
    if (not IsValid(ActiveWidget)) then
        return
    end

    if ActiveWidget.PlayGachaInAnimation then
        ActiveWidget:PlayGachaInAnimation()
    end
end

function M:PlayGachaOutAnimation()
    local ActiveWidget = self.RewardSwitcher:GetActiveWidget()
    if (not IsValid(ActiveWidget)) then
        return
    end

    if ActiveWidget.PlayGachaOutAnimation then
        ActiveWidget:PlayGachaOutAnimation()
    end
end

function M:PlayGachaGetAnimation(CallbackFunc)
    local ActiveWidget = self.RewardSwitcher:GetActiveWidget()
    if (not IsValid(ActiveWidget)) then
        if CallbackFunc then
            CallbackFunc()
        end
        return
    end

    if ActiveWidget.PlayGachaGetAnimation then
        ActiveWidget:PlayGachaGetAnimation(CallbackFunc)
    else
        if CallbackFunc then
            CallbackFunc()
        end
    end
end

function M:BP_GetDesiredFocusTarget()
    local RewardItemWidget = self.RewardSwitcher:GetActiveWidget()
    if (not IsValid(RewardItemWidget)) then
        return self
    end
    if (RewardItemWidget.Content.OnFocusWidget and RewardItemWidget.Content.OnFocusWidget[1] and RewardItemWidget.Content.OnFocusWidget[2]) then
        local FocusWidgetName = "CheckRewardDetailView"
        if not RewardItemWidget.Content.bLocked and #RewardItemWidget.Content.Ids > 1 then
            FocusWidgetName = "SelectRewardView"
        end
        RewardItemWidget.Content.OnFocusWidget[2](RewardItemWidget.Content.OnFocusWidget[1], FocusWidgetName, RewardItemWidget)
    end
    return RewardItemWidget
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == UIConst.GamePadKey.FaceButtonBottom) then
            local RewardItemWidget = self.RewardSwitcher:GetActiveWidget()
            if IsValid(RewardItemWidget) then
                if not RewardItemWidget.Content.bLocked and #RewardItemWidget.Content.Ids > 1 then
                    IsEventHandled = true
                    RewardItemWidget:OpenSelectWidget()
                else
                    IsEventHandled = true
                    RewardItemWidget.Item:OnMouseButtonDown()
                    RewardItemWidget.Item:OnMouseButtonUp()
                end
            end
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

return M

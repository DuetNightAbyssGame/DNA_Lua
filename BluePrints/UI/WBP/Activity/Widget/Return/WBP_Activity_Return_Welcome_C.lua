--
-- DESCRIPTION
-- 回归活动拍脸banner
-- @COMPANY **
-- @AUTHOR ** lgc
-- @DATE ${date} ${time}
--
require "UnLua"
local ReturnActivityController = require "BluePrints.UI.WBP.Activity.Widget.Return.ReturnActivityController"

local M = Class({
    "BluePrints.UI.BP_UIState_C",
    "BluePrints.Common.TimerMgr",
})

function M:Construct(...)

end

function M:OnLoaded(...)
    self.Text_WelcomeDesc:SetText(GText("UI_ComebackEvent_EventRewardText"))
    self.Text_Title:SetText(GText("UI_CombackEvent_EventQuest_WelcomeTitle"))
    self.Text_RewardTitle:SetText(GText("UI_ComebackEvent_EventRewardDes"))
    self:PlayInAnimation()
    self:InitRewardList()
    self:InitGoToEventBtn()
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    self:AddTimer(2, function()
        self:BlockAllUIInput(false)
    end)

    self.Btn_Content:SetDefaultGamePadImg("A")
    self.KeyReward:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "LS",
            }
        },
    })
    local BottomKeyInfo = {
        {
            KeyInfoList = { { Type = "Img", ImgShortPath = "A"} },
            Desc = GText("UI_Controller_CheckDetails")
        },
        {
            KeyInfoList = { { Type = "Img", ImgShortPath = "B"} },
            Desc = GText("UI_BACK")
        },
    }
    self.Com_KeyTips:UpdateKeyInfo(BottomKeyInfo)
    if UIUtils.IsMobileInput() then
        self.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.KeyReward:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/back_welcome_in", nil, nil)
end

function M:InitRewardList()
    self.CurrentEventSchemeId = DataMgr.ComeBackEventConstant.CurrentEventSchemeId.ConstantValue
    assert(self.CurrentEventSchemeId, "lgc@CurrentEventSchemeId is nil, 需要策划检查下ComeBackEventConstant表中的CurrentEventSchemeId")
    self.CurrentEventSchemeData = DataMgr.ComeBackEvent[self.CurrentEventSchemeId]
    if not self.CurrentEventSchemeData then return end
    local EventOneTimeReward = self.CurrentEventSchemeData.EventOneTimeReward
    if not EventOneTimeReward then return end

    if not self.List_Reward then return end
    self.List_Reward:ClearListItems()

    local Rewards = DataMgr.Reward[EventOneTimeReward]
    if not Rewards then return end

    self.RewardList = {}
    local RewardIds = Rewards.Id
    local RewardCounts = Rewards.Count
    local RewardTypes = Rewards.Type
    for i = 1, #RewardIds do
        local ItemId = RewardIds[i]
        local Count = RewardUtils and RewardUtils.GetCount and RewardUtils:GetCount(RewardCounts[i]) or RewardCounts[i]
        local ItemData = DataMgr[RewardTypes[i]][ItemId]
        local bHasIcon = ItemData and ItemData.Icon
        local Icon = (bHasIcon and ItemUtils and ItemUtils.GetItemIcon) and ItemUtils.GetItemIcon(ItemId, RewardTypes[i]) or nil
        local Rarity = ItemUtils and ItemUtils.GetItemRarity and ItemUtils.GetItemRarity(ItemId, RewardTypes[i])
        local ItemType = RewardTypes[i]
        local RewardContent = {
            Id = ItemId,
            Type = ItemType,
            ItemCount = Count,
            Icon = Icon,
            Rarity = Rarity,
        }
        table.insert(self.RewardList, RewardContent)
    end

    for _, ItemInfo in pairs(self.RewardList) do
        local Content = NewObject(UIUtils and UIUtils.GetCommonItemContentClass and UIUtils.GetCommonItemContentClass())
        if Content then
            Content.Id = ItemInfo.Id
            Content.Icon = ItemUtils and ItemUtils.GetItemIconPath and ItemUtils.GetItemIconPath(ItemInfo.Id, ItemInfo.Type)
            Content.ParentWidget = self
            Content.ItemType = ItemInfo.Type
            Content.Count = ItemInfo.ItemCount
            Content.Rarity = ItemInfo.Rarity or 1
            Content.IsShowDetails = true
            Content.AfterInitCallback = function(Widget)
                if Widget and Widget.BindEvents then
                    Widget:BindEvents(self, {OnMenuOpenChanged = function(Obj, bIsOpen)
                        
                    end})
                end
            end
            self.List_Reward:AddItem(Content)
        end
    end
end

function M:InitGoToEventBtn()
    self.Btn_Content:SetText(GText("UI_ComebackEvent_EventRewardJumpButton"))
    self.EventId = DataMgr.ComeBackEventConstant.CurrentEventId.ConstantValue
    assert(self.EventId, "lgc@EventId is nil, 需要策划检查下ComeBackEventConstant表中的CurrentEventId")
    self.CurrentEventTabId = DataMgr.ComeBackEventConstant.CurrentEventTabId.ConstantValue
    assert(self.CurrentEventTabId, "lgc@CurrentEventTabId is nil, 需要策划检查下ComeBackEventConstant表中的CurrentEventTabId")
    self.Btn_Content.Button_Area.OnClicked:Add(self, self.OnBtnContentClicked)
end

function M:OnBtnContentClicked()
    self:Close()
    ReturnActivityController.bRequestRewardOnInitPage = true
    PageJumpUtils:JumpToEventPage(self.CurrentEventTabId)  
end

function M:PlayInAnimation()
    self:BindToAnimationFinished(self.In, {self, function()
        self:SetFocus()
        self:BlockAllUIInput(false)
        self:UnbindAllFromAnimationFinished(self.In)
    end})
    self:StopAllAnimations()
    self:PlayAnimation(self.In)
end

function M:CloseSelf(CloseCb)
    self:StopAllAnimations()
    self:PlayAnimation(self.Out)
    self:BindToAnimationFinished(self.Out, {self, function()
        self:UnbindAllFromAnimationFinished(self.Out)
        self:Close()
        if CloseCb then
            CloseCb()
        end
    end})
end

function M:Close()
    self:UnbindAllFromAnimationFinished(self.In)
    self:UnbindAllFromAnimationFinished(self.Out)
    self:StopAllAnimations()
    self:BlockAllUIInput(false)
    M.Super.Close(self)
end


function M:Destruct(...)

end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == Const.GamepadFaceButtonDown and self:HasAnyUserFocus()) then
            IsEventHandled = true
            self:OnBtnContentClicked()
		end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    DebugPrint("lgc@WBP_Activity_Return_Welcome_C OnKeyDown ", InKeyName)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == Const.GamepadLeftThumbstick) then  
            IsEventHandled = true
            self.bListRewardFocused = true
            self.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.List_Reward:SetFocus()
            self.List_Reward:NavigateToIndex(0)
            self.Btn_Content:SetGamePadIconVisible(false)
            self.KeyReward:SetVisibility(UE4.ESlateVisibility.Collapsed)
        elseif (InKeyName == Const.GamepadFaceButtonRight) then
            IsEventHandled = true
            self.bListRewardFocused = false
            self.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self:SetFocus()
            self.Btn_Content:SetGamePadIconVisible(true)
            self.KeyReward:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
		end
    else
        if (InKeyName == "Escape") then
            IsEventHandled = true
            self:SetFocus()
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        if self.bListRewardFocused then
            self.Btn_Content:SetGamePadIconVisible(false)
            self.KeyReward:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.List_Reward:SetFocus()
            
            self.List_Reward:BP_NavigateToItem(self.List_Reward:BP_GetSelectedItem())
            self.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            self.Btn_Content:SetGamePadIconVisible(true)
            self.KeyReward:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    elseif UIUtils.UtilsGetCurrentInputType() == ECommonInputType.MouseAndKeyboard then
        self.Btn_Content:SetGamePadIconVisible(false)
        self.KeyReward:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Btn_Content:SetGamePadIconVisible(false)
        self.KeyReward:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    DebugPrint("lgc@WBP_Activity_Return_Welcome_C OnFocusReceived ", UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad)
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if CurInputDevice == ECommonInputType.Gamepad then
        if self.List_Reward:HasAnyUserFocus() or self.List_Reward:HasFocusedDescendants() or self.bListRewardFocused then
            self.Btn_Content:SetGamePadIconVisible(false)
            self.KeyReward:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            self.Btn_Content:SetGamePadIconVisible(true)
            self.KeyReward:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        self.Btn_Content:SetGamePadIconVisible(false)
        self.KeyReward:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

end


return M

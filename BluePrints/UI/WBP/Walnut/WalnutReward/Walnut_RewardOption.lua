--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Walnut_RewardOption_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:OnMouseEnter(MyGeometry,MouseEvent)
    if self.SelectDone then
        return
    end
    if self.IsSelected then
        if UIManager(self):GetUIObj("WalnutReward") then
            local WalnutReward = UIManager(self):GetUIObj("WalnutReward")
            WalnutReward.State = 0
            WalnutReward:UpdateCommonKeys("LS", GText("UI_Controller_CheckDetails"))
            if WalnutReward.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
                if WalnutReward.IsStandAlone == false then
                    WalnutReward.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                end
                WalnutReward.Btn_Confirm:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            end
        end
        return
    end
    self:PlayAnimation(self.Hover)
    AudioManager(self):PlayUISound(self, "event:/ui/common/mihan_level_finish_choice_btn_hover", "WalnutRewardOptionHover", nil)
    if UIManager(self):GetUIObj("WalnutReward") then 
        local WalnutReward = UIManager(self):GetUIObj("WalnutReward")
        if WalnutReward.CurrentSelectIndex == 1 and (not WalnutReward.Reward_1st:HasAnyUserFocus()) then
            WalnutReward.State = 1
            WalnutReward:UpdateCommonKeys("A", GText("UI_Tips_Ensure"), "LS", GText("UI_Controller_CheckDetails"))
        elseif WalnutReward.CurrentSelectIndex == 2 and (not WalnutReward.Reward_2nd:HasAnyUserFocus()) then
            WalnutReward.State = 1
            WalnutReward:UpdateCommonKeys("A", GText("UI_Tips_Ensure"), "LS", GText("UI_Controller_CheckDetails"))
        elseif WalnutReward.CurrentSelectIndex == 3 and (not WalnutReward.Reward_3rd:HasAnyUserFocus()) then
            WalnutReward.State = 1
            WalnutReward:UpdateCommonKeys("A", GText("UI_Tips_Ensure"), "LS", GText("UI_Controller_CheckDetails"))
        end
        if WalnutReward.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
            if WalnutReward.IsStandAlone == false then
                WalnutReward.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            end
            WalnutReward.Btn_Confirm:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
    end
end

function M:OnMouseLeave(MyGeometry,MouseEvent)
    if self.SelectDone then
        return
    end
    if self.IsSelected then
        return
    end
    self:PlayAnimation(self.UnHover)
    -- local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    -- self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    -- if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
    --     local WalnutReward = UIManager(self):GetUIObj("WalnutReward")
    --     WalnutReward.Panel_Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- end
end

function M:PlayGoldFlipAudio()
    AudioManager(self):PlayUISound(self, "event:/ui/common/mihan_level_finish_choose_gold_flip", nil, nil)
end

return M

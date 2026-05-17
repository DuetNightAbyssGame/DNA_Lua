require "UnLua"
local WBP_Forging_EntranceConvert_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_Forging_EntranceConvert_C:Init(Object, ClickCallback)
    local GameInputMdoeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    if IsValid(GameInputMdoeSubsystem) then 
        GameInputMdoeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
        self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())
    end
    self.Text_Convert:SetText(GText("UI_Convert"))
    self.Btn_Click.OnPressed:Add(self, function()
        AudioManager(self):PlayFMODSound(self, nil, "event:/ui/common/click_btn_large")
    end)
    self.Btn_Click.OnClicked:Add(Object, ClickCallback)

end

-- function WBP_Forging_EntranceConvert_C:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
--     if UIUtils.IsGamepadInput() and not self.bIsHideGamepadKey then
--         self.Controller:CreateGamepadKey(UIConst.GamePadImgKey.SpecialRight)
--         self.Controller:SetVisibility(UE4.ESlateVisibility.Visible)
--     else
--         self.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     end
-- end

-- function WBP_Forging_EntranceConvert_C:HideGamepadKeyTip(bIsHide)
--     if bIsHide then
--         self.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         self.bIsHideGamepadKey = true
--     else
--         self.Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         self.bIsHideGamepadKey = nil
--     end
-- end


return WBP_Forging_EntranceConvert_C


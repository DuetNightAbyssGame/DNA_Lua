require "UnLua"
local UIUtils = require "Utils.UIUtils"
local M = Class({
    "BluePrints.UI.BP_UIState_C",
})

function M:OnLoaded(...)
    self.Super.OnLoaded(self,...)
    self.Owner = ...
    self.Com_Bg:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Text_Tip:SetText(GText("UI_RougeLike_End__ClickEmpty"))
    self:InitPresets()
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self:SetFocus()
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    self:InitButtonNavigation()
    self.Key01:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonBottom)
    self.Key01:CreateSubKeyDesc({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "B",
            },
        },
        Type = "Img",
        Desc = GText("UI_Controller_Close")
    })
    --self.Key01:SetDescription(GText("UI_RougeLike_End__ClickEmpty"))
    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(nil,"event:/ui/activity/auto_chess_team_preset_in", "AutoChessPresetPage_InSound", nil)
end

function M:InitButtonNavigation()
    self.Preset_01.Btn_Add:SetNavigationRuleCustom(UE4.EUINavigation.Right, {self, function ()
        if self.Preset_02.WS_Type:GetActiveWidgetIndex() == 0 then
            --return self.Preset_02.Btn_Click
            if not self.Preset_02.IsSelected then
                self.Preset_02:OnClickPreset()
            end
            return self.Preset_02.Btn_Click
        else
            if not self.Preset_02:OnClickAdd() then
                return self.Preset_02.Btn_Add
            else
                return self.Preset_02.Btn_Click
            end
        end
    end})
    self.Preset_02.Btn_Add:SetNavigationRuleCustom(UE4.EUINavigation.Left, {self, function ()
        if self.Preset_01.WS_Type:GetActiveWidgetIndex() == 0 then
            if not self.Preset_01.IsSelected then
                self.Preset_01:OnClickPreset()
            end
            return self.Preset_01.Btn_Click
        else
             if not self.Preset_01:OnClickAdd() then
                return self.Preset_01.Btn_Add
            else
                return self.Preset_01.Btn_Click
            end
        end
    end})
    self.Preset_02.Btn_Add:SetNavigationRuleCustom(UE4.EUINavigation.Right, {self, function ()
        if self.Preset_03.WS_Type:GetActiveWidgetIndex() == 0 then
            if not self.Preset_03.IsSelected then
                self.Preset_03:OnClickPreset()
            end
            return self.Preset_03.Btn_Click
        else
            if not self.Preset_03:OnClickAdd() then
                return self.Preset_03.Btn_Add
            else
                return self.Preset_03.Btn_Click
            end
        end
    end})
    self.Preset_03.Btn_Add:SetNavigationRuleCustom(UE4.EUINavigation.Left, {self, function ()
        if self.Preset_02.WS_Type:GetActiveWidgetIndex() == 0 then
            if not self.Preset_02.IsSelected then
                self.Preset_02:OnClickPreset()
            end
            return self.Preset_02.Btn_Click
        else
            if not self.Preset_02:OnClickAdd() then
                return self.Preset_02.Btn_Add
            else
                return self.Preset_02.Btn_Click
            end
        end
    end})
    self.Preset_01.Btn_Add:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self.Preset_02.Btn_Add:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self.Preset_03.Btn_Add:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)

    self.Preset_01.Btn_Click:SetNavigationRuleCustom(UE4.EUINavigation.Right, {self, function ()
        if self.Preset_02.WS_Type:GetActiveWidgetIndex() == 0 then
            if not self.Preset_02.IsSelected then
                self.Preset_02:OnClickPreset()
            end
            return self.Preset_02.Btn_Click
        else
            if not self.Preset_02:OnClickAdd() then
                return self.Preset_02.Btn_Add
            else
                return self.Preset_02.Btn_Click
            end
        end
    end})
    self.Preset_02.Btn_Click:SetNavigationRuleCustom(UE4.EUINavigation.Left, {self, function ()
        if self.Preset_01.WS_Type:GetActiveWidgetIndex() == 0 then
            if not self.Preset_01.IsSelected then
                self.Preset_01:OnClickPreset()
            end
            return self.Preset_01.Btn_Click
        else
             if not self.Preset_01:OnClickAdd() then
                return self.Preset_01.Btn_Add
            else
                return self.Preset_01.Btn_Click
            end
        end
    end})
    self.Preset_02.Btn_Click:SetNavigationRuleCustom(UE4.EUINavigation.Right, {self, function ()
        if self.Preset_03.WS_Type:GetActiveWidgetIndex() == 0 then
            if not self.Preset_03.IsSelected then
                self.Preset_03:OnClickPreset()
            end
            return self.Preset_03.Btn_Click
        else
             if not self.Preset_03:OnClickAdd() then
                return self.Preset_03.Btn_Add
            else
                return self.Preset_03.Btn_Click
            end
        end
    end})
    self.Preset_03.Btn_Click:SetNavigationRuleCustom(UE4.EUINavigation.Left, {self, function ()
        if self.Preset_02.WS_Type:GetActiveWidgetIndex() == 0 then
            if not self.Preset_02.IsSelected then
                self.Preset_02:OnClickPreset()
            end
            return self.Preset_02.Btn_Click
        else
             if not self.Preset_02:OnClickAdd() then
                return self.Preset_02.Btn_Add
            else
                return self.Preset_02.Btn_Click
            end
        end
    end})
    self.Preset_01.Btn_Click:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self.Preset_02.Btn_Click:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self.Preset_03.Btn_Click:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
end

function M:InitPresets()
    self:InitButton()
    self.Preset_01:InitContent({
        IsSet = false,
        Owner = self,
        PresetIndex = 1,
    })
    self.Preset_02:InitContent({
        IsSet = false,
        Owner = self,
        PresetIndex = 2,
    })
    self.Preset_03:InitContent({
        IsSet = false,
        Owner = self,
        PresetIndex = 3,
    })
end

function M:InitButton()
    -- body
    self.Btn_Close.OnClicked:Add(self,self.CloseSelf)
end

function M:CloseSelf()
    AudioManager(self):SetEventSoundParam(nil, "AutoChessPresetPage_InSound", {ToEnd = 1})
    --AudioManager(self):PlayUISound(nil,"event:/ui/activity/auto_chess_team_preset_in", "AutoChessPresetPage_InSound", nil)
    self:Close()
end

function M:RefreshSelect(PresetIndex)
    self.Preset_01:RefreshSelect(PresetIndex)
    self.Preset_02:RefreshSelect(PresetIndex)
    self.Preset_03:RefreshSelect(PresetIndex)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == "Gamepad_FaceButton_Right") then  
            IsEventHandled = true
            self:CloseSelf()
		end
    else
        if (InKeyName == "Escape") then
            IsEventHandled = true
            self:CloseSelf()
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:InitKeyboardView()
    self.Btn_Close:SetVisibility(UE4.ESlateVisibility.Visible)
    self.Preset_01:InitKeyboardView()
    self.Preset_02:InitKeyboardView()
    self.Preset_03:InitKeyboardView()
     self.WS_Type:SetActiveWidgetIndex(0)
end

function M:InitGamepadView()
    if self:HasFocusedDescendants() or self:HasAnyUserFocus() then
        self.Preset_01:SetFocus()
        self.Preset_01:InitGamepadView()
        self.Preset_02:InitGamepadView()
        self.Preset_03:InitGamepadView()
        self.WS_Type:SetActiveWidgetIndex(1)
    end 
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
    if CurInputType == ECommonInputType.Gamepad then
        self:InitGamepadView()
    elseif CurInputType == ECommonInputType.MouseAndKeyboard then
        self:InitKeyboardView()
    end
end


return M
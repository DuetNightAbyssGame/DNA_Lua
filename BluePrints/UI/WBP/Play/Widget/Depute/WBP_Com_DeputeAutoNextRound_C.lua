--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--控件名：WBP_Com_AutoNextRound
require "UnLua"

---@type WBP_Com_AutoNextRound_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.UI.BP_EMUserWidgetUtils_C",})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self:InitCommonWidget()
    self.SwitchCheckBox:AddEventOnCheckStateChanged(self, self.OnSwitchPreview)
    self.Btn_Qa:Init({ 
        OwnerWidget = self,
        PopupID = 100297,
        ClickCallback = function()
            UIManager(self):ShowCommonPopupUI(100297)
        end
    })
    self.SwitchCheckBox:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self.SwitchCheckBox:SetNavigationRuleBase(EUINavigation.Up,EUINavigationRule.Stop)
    --self.SwitchCheckBox:SetNavigationRuleBase(EUINavigation.Left,EUINavigationRule.Stop)
    self.SwitchCheckBox:SetNavigationRuleBase(EUINavigation.Right,EUINavigationRule.Stop)
    self.SwitchCheckBox:SetNavigationRuleExplicit(EUINavigation.Left, self.Btn_Qa)
    self.Btn_Qa:SetNavigationRuleExplicit(EUINavigation.Right, self.SwitchCheckBox)
    self.Btn_Qa:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.Btn_Qa:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self.Btn_Qa:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)

    self:AddInputMethodChangedListen()

    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.CurGamepadName = self.GameInputModeSubsystem:GetCurrentGamepadName()
       -- self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:Init(DungeonData)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    self.CurrentCount = Avatar.Dungeons[DungeonData.DungeonID] and Avatar.Dungeons[DungeonData.DungeonID].AutoProgress or 0
    self.SelectCount = self.CurrentCount
    self:RefreshCommonWidget()
end

function M:InitCommonWidget()
    self.Text_Title:SetText(GText("UI_Auto_Round_Title"))
    self.Text_Wave:SetText(GText("UI_Auto_Round"))
    self.MaxAutoRounds = DataMgr.GlobalConstant.MaxAutoRounds.ConstantValue
    local ConfigData = {
        InitValue = 1,
        ClickInterval = 1,
        MinValue = 1,
        MaxValue = self.MaxAutoRounds,
        OwnerPanel = self,
        MinusBtnCallback = self.SliderChangeCallback,
        AddBtnCallback = self.SliderChangeCallback,
        SliderChangeCallback = self.SliderChangeCallback,
        EnableMiniBtn = true,
        EnableMaxBtn = true,
        bDisableAutoHandleInputDeviceChange = true,
    }
    self.Slider:Init(ConfigData)
end

function M:RefreshCommonWidget()
    self.Text_Num:SetText(self.CurrentCount == 0 and "1/" .. self.MaxAutoRounds or
    self.CurrentCount .. "/" .. self.MaxAutoRounds)
    self.Slider:OverrideValueLimit(self.CurrentCount == 0 and 1 or self.CurrentCount,self.MaxAutoRounds,1,true)
    local IsChecked = self.CurrentCount > 0
    self.SwitchCheckBox:SetChecked(IsChecked,true)
    if IsChecked then
        self:StopAllAnimations()
        self:PlayAnimation(self.Expand_Normal)
    else
        self:StopAllAnimations()
        self:PlayAnimation(self.Fold_Normal)
    end
    -- self.Mobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
    -- if self.Mobile then
    --     return
    -- end
    self.Slider:UpdateUIStyleInPlatform(false, self.CurGamepadName)
end


function M:MinusBtnCallback(NewValue)
    DebugPrint("SliderChangeCallback   MinusBtnCallback",NewValue)
end

function M:AddBtnCallback(NewValue)
    DebugPrint("SliderChangeCallback   AddBtnCallback",NewValue)
end

function M:SliderChangeCallback(NewValue)
    self.SelectCount = NewValue
    self.Text_Num:SetText(self.SelectCount.."/"..self.MaxAutoRounds)
end

function M:GetSelectCount()
    if self.IsExpand then
        return self.SelectCount ~= 0 and self.SelectCount or 1
    else
        return 0
    end
    
end

function M:OnSwitchPreview(IsChecked)
    self.IsExpand = IsChecked
    if IsChecked then
        self:StopAllAnimations()
        self:PlayAnimation(self.Expand)
    else
        self:StopAllAnimations()
        self:PlayAnimation(self.Fold)
    end
end


function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then return end
    --如果是pc或者特殊原因需要显示为pc时
    if (IsUseKeyAndMouse) then
        self.Key_Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)

    else
        self.Key_Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Key_Controller:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "Up",
                },
                {
                    Type = "Img",
                    ImgShortPath = "RS",
                }
            },
        })
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self.Slider:Handle_KeyDownEventOnGamePad(InKeyName)
    end
    if IsEventHandled then
        return UWidgetBlueprintLibrary.Handled()
    else
        return UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self.Slider:Handle_KeyUpEventOnGamePad(InKeyName)
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
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == "Gamepad_DPad_Right"  then
            self.Slider:OnMaxKeyDown()
        elseif InKeyName == "Gamepad_DPad_Left" then
            self.Slider:OnMiniKeyDown()
            IsEventHandled = true
        end
    end
    if (IsEventHandled) then
        return UWidgetBlueprintLibrary.Handled()
    else
        return UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard

    if IsUseKeyAndMouse and (self:HasFocusedDescendants() or self:HasAnyUserFocus()) then
        self:PlayAnimation(self.Focus_Out)
        self.Slider:UpdateUIStyleInPlatform(false,self.CurGamepadName)
    end

end

function M:SetAutoNextRoundFocus(bFocus)
    if bFocus then
        self.SwitchCheckBox:SetFocus()
        self:PlayAnimation(self.Focus)
        self.Slider:UpdateUIStyleInPlatform(true, self.CurGamepadName)
    else
        self:PlayAnimation(self.Focus_Out)
        self.Slider:UpdateUIStyleInPlatform(false, self.CurGamepadName)
    end
end


return M

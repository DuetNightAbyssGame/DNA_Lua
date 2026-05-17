--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Task_Fullfill_Popup_SubItem_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Super.Construct(self)
    self.EMScrollBox_73:SetControlScrollbarInside(true)
    self.Btn_Click.OnHovered:Add(self, self.OnBtnHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnBtnUnhovered)
    self.Btn_Click.OnPressed:Add(self, self.OnBtnPressed)
    self.Btn_Click.OnReleased:Add(self, self.OnBtnReleased)
    self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
    self.IsHovering = false
    self.IsPressing = false
    self.IsPressing_Gamepad = false

    self:PlayAnimation(self.Normal)
    self:PlayAnimation(self.GamePad_Normal)

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
    self.Super.Destruct(self)
end

function M:Init(Parent, Content, ConfirmFullfill)
    self.Parent = Parent
    self.Text_Desc:SetText(GText(Content))
    self.Text_Go:SetText(GText("UI_SPECIALPOP_COMMON_CONFIRM"))
    if ConfirmFullfill then
        self.Text_Title:SetText(GText("UI_SPECIALPOP_COMMON_CONTENT_1"))
        self.Text_TipsDesc:SetText(GText("UI_SPECIALPOP_COMMON_TIPS_1"))
    else
        self.Text_Title:SetText(GText("UI_SPECIALPOP_COMMON_CONTENT_2"))
        self.Text_TipsDesc:SetText(GText("UI_SPECIALPOP_COMMON_TIPS_2"))
    end
    self:AddDelayFrameFunc(function()
        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and self:HasAnyFocus() then
            if UIUtils.CheckScrollBoxCanScroll(self.EMScrollBox_73) then
                self.Parent.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
            else
                self.Parent.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
        self.EMScrollBox_73:ScrollToStart()
    end,2)
end

function M:BindEventOnClicked(Obj, Func, Params)
    if not Obj or not Func then
        return
    end
    self.Obj = Obj
    self.Func = Func
    self.Params = Params
end

function M:UnBindEventOnClicked()
    self.Obj = nil
    self.Func = nil
    self.Params = nil
end

function M:OnBtnHovered()
	self.IsHovering = true
	if self.IsPressing then
        return
    end
	self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnBtnUnhovered()
	self.IsHovering = false
	if not self.IsPressing then
		self:StopAllAnimations()
		self:PlayAnimation(self.Unhover)
	end
end

function M:OnBtnPressed()
	self.IsPressing = true
	self:StopAllAnimations()
    self:PlayAnimation(self.Press)
end

function M:OnBtnReleased()
    self.IsPressing = false
    if not self.IsHovering then
        self:StopAllAnimations()
        self:PlayAnimationReverse(self.Normal)
    else
        self:StopAllAnimations()
        self:PlayAnimationReverse(self.Hover)
    end
end

function M:OnBtnClicked()
	self:StopAllAnimations()
	self:PlayAnimation(self.Click)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
    if self.Obj and self.Func then
        if self.Params then
            self.Func(self.Obj, table.unpack(self.Params))
        else
            self.Func(self.Obj)
        end
    end
end

function M:OnBtnClicked_Gamepad()
	self:StopAllAnimations()
	self:PlayAnimation(self.GamePad_Click)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
    if self.Obj and self.Func then
        if self.Params then
            self.Func(self.Obj, table.unpack(self.Params))
        else
            self.Func(self.Obj)
        end
    end
end

function M:BP_GetDesiredFocusTarget()
    if self.Parent then
        self.Parent:TryChangeCurFocusedItem(self)
    end
    return self
end

function M:OnFocusLost(InFocusEvent)
    self.IsPressing_Gamepad = false
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.CurInputDeviceType = CurInputDevice
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    --self:PlayAnimation(self.Normal)
    --self:PlayAnimation(self.GamePad_Normal)
    if IsUseKeyAndMouse then
		self:InitKeyboardView()
	else
		self:InitGamepadView()
	end
end

function M:InitGamepadView()
    self.Panel_Button:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.EMScrollBox_73:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:InitKeyboardView()
    self.Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Button:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.EMScrollBox_73:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:InitWidgetInfoInGamePad()
    
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

function M:BeginHover()
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:PlayAnimation(self.Gamepad_Hover)
        self.Controller:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        self:UpdateComKeyTipsVisibility()
    end
end

function M:StopHover(InSwitch)
    if InSwitch or UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:PlayAnimation(self.Gamepad_Unhover)
        self.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Parent.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == UIConst.GamePadKey.FaceButtonBottom) then
            IsEventHandled = true
            --self:OnBtnClicked_Gamepad()
            self.IsPressing_Gamepad = true
            self:PlayAnimation(self.GamePad_Press)
		end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == UIConst.GamePadKey.FaceButtonBottom) then
            if self.IsPressing_Gamepad then
                IsEventHandled = true
                self.IsPressing_Gamepad = false
                self:OnBtnClicked_Gamepad()
            end
		end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == UIConst.GamePadKey.RightAnalogY) then
        local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
        local CurScrollOffset = self.EMScrollBox_73:GetScrollOffset()
        local ScrollOffset = math.clamp(CurScrollOffset - a,0, self.EMScrollBox_73:GetScrollOffsetOfEnd())
        self.EMScrollBox_73:SetScrollOffset(ScrollOffset)
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:UpdateComKeyTipsVisibility()
    if UIUtils.CheckScrollBoxCanScroll(self.EMScrollBox_73) then
        self.Parent.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    else
        self.Parent.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

return M

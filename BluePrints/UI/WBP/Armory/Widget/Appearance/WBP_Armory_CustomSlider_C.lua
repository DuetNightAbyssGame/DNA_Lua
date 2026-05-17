--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_CustomSlider_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
M._components = {
    "BluePrints.UI.BP_EMUserWidgetUtils_C",
    "BluePrints.UI.KeyInputComponent"
}
function M:Construct()
    self.Btn_Reset:BindEventOnClicked(self,self.OnResetBtnClicked)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    rawset(self,"IsGamepadInput",CurInputDevice == ECommonInputType.Gamepad)
    if(self.bInFocusPath)then
        if(not self:HasAnyUserFocus())then
            self:SetFocus()
        end
    end
    self:UpdateResetBtnVisibility()
    self:UpdateSeletState()
end

function M:GetDesiredFocusTarget()
    return self
end

function M:UpdateResetBtnVisibility()
    if(rawget(self,"bShowResetBtn"))then
        if(self:IsValueChanged())then
            self.Btn_Reset:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            if(self.IsGamepadInput and self.bInFocusPath)then
                self.Key_Reset:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            else
                self.Key_Reset:SetVisibility(UIConst.VisibilityOp.Collapsed)
            end
        else
            self.Btn_Reset:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.Key_Reset:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    else
        self.Btn_Reset:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Key_Reset:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if(rawget(self,"_OnResetBtnVisibilityChanged"))then
        self._OnResetBtnVisibilityChanged.Func(self._OnResetBtnVisibilityChanged.Obj)
    end
end

function M:BindEventOnResetBtnVisibilityChanged(Obj,Func)
    if(Func)then
        rawset(self,"_OnResetBtnVisibilityChanged",{Func = Func,Obj = Obj})
    else
        rawset(self,"_OnResetBtnVisibilityChanged",nil)
    end
end

---判断当前值是否等于默认值
function M:IsValueChanged()
    local Diff = self.CurrentValue - self.DefaultValue
    return Diff * Diff > 0.001
end

function M:OnListItemObjectSet(Params)
    Params = Params or {
        --         Owner = table,      --回调接受者
        --         Text = string,      --条目名称
        --         MaxValue = number,  --最大值，默认1
        --         MinValue = number,  --最小值，默认0
        --         DefaultValue = number,  --默认值，点击重置会设置到这个值,不传则用MinValue
        --         CurrentValue = number,  --当前值，不传则用DefaultValue
        --         MaxFractionalDigits = 2, 保留小数点后几位
        --         StepSize = numer, --滑动条步长
        --         bShowResetBtn = false,
        --         OnResetBtnClicked = function(Item), --重置按钮回调
        --         OnValueChanged = function(Value,Item), --滑条数值改变回调
        --         GamepedLeftKey = KeyName --向左手柄键,UIConst.GamePadImgKey的key
        --         GamepedRightKey = KeyName --向右手柄键,UIConst.GamePadImgKey的key
        --         GamepadResetKey = KeyName -- 手柄重置键,UIConst.GamePadImgKey的key
    }
    rawset(self,"Params",Params)
    rawset(self,"Owner",Params.Owner)
    rawset(self,"_OnValueChanged",Params.OnValueChanged)
    rawset(self,"_OnResetBtnClicked",Params.OnResetBtnClicked)
    rawset(self,"bShowResetBtn",Params.bShowResetBtn)
    rawset(self,"MaxFractionalDigits",Params.MaxFractionalDigits  or 2)
    self.Text_Position:SetText(Params.Text)
    rawset(self,"MaxValue",Params.MaxValue or 1)
    self.Slider:SetMaxValue(self.MaxValue + 0.001)
    rawset(self,"MinValue",Params.MinValue or 0)
    self.Slider:SetMinValue(self.MinValue)
    rawset(self,"DefaultValue",Params.DefaultValue or self.MinValue)
    rawset(self,"StepSize",Params.StepSize or 1)
    self.Slider:SetStepSize(self.StepSize)

    self:SetValue(Params.CurrentValue,false)
    self:SetDefaultValue(Params.DefaultValue)

    self:RemoveInputMethodChangedListen()
    self:AddInputMethodChangedListen()
    if(self.GameInputModeSubsystem)then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end

    self:InitKeySetting(Params)
end

function M:InitKeySetting(Params)
    self:ClearKeyDownEvents()
    local GamepedLeftKey = Params.GamepedLeftKey or "LeftTriggerThreshold"
    local GamepedRightKey = Params.GamepedLeftKey or "RightTriggerThreshold"
    self.Key_LT:CreateGamepadKey(UIConst.GamePadImgKey[GamepedLeftKey])
    self:AddKeyDownEvent(UIConst.GamePadKey[GamepedLeftKey],self.OnSlideLeftKeyDown)
    self.Key_RT:CreateGamepadKey(UIConst.GamePadImgKey[GamepedRightKey])
    self:AddKeyDownEvent(UIConst.GamePadKey[GamepedRightKey],self.OnSlideRightKeyDown)
    local GamepadResetKey = Params.GamepadResetKey or "LeftThumb"
    self.Key_Reset:CreateGamepadKey(UIConst.GamePadImgKey[GamepadResetKey])
    self:AddKeyDownEvent(UIConst.GamePadKey[GamepadResetKey],self.OnResetKeyDown)
end

function M:OnSlideLeftKeyDown()
    local Value = self.CurrentValue - self.StepSize
    self:SetValue(Value,true)
    return UIUtils.Handled,true
end

function M:OnSlideRightKeyDown()
    local Value = self.CurrentValue + self.StepSize
    self:SetValue(Value,true)
    return UIUtils.Handled,true
end

function M:OnResetKeyDown()
    if(rawget(self,"bShowResetBtn"))then
        self:ResetValue()
        return UIUtils.Handled,true
    end
end

function M:SetValue(Value,bNeedCallback)
    self:OnSliderValueChanged_Internal(Value,not bNeedCallback)
end

function M:GetValue()
    return self.CurrentValue
end

function M:ResetValue()
    self:SetValue(self.DefaultValue,true)
end

function M:SetDefaultValue(DefaultValue)
    if(not DefaultValue)then
        return
    end
    local ParentSizeX = self.ProgressBar.Slot:GetSize().X
    local X = (DefaultValue - self.MinValue) / (self.MaxValue - self.MinValue) * ParentSizeX
    self.WS_DefaultPosition.Slot:SetPosition(FVector2D(X,0))
    if(DefaultValue <= self.CurrentValue)then
        self.WS_DefaultPosition:SetActiveWidgetIndex(1)
    else
        self.WS_DefaultPosition:SetActiveWidgetIndex(0)
    end
end

function M:OnSliderValueChanged(Value)
    local ValueBefore = self.CurrentValue or 0
    self:OnSliderValueChanged_Internal(Value)
    if(ValueBefore ~= self.CurrentValue)then
	    AudioManager(self):PlayUISound(self, "event:/ui/common/slider_value_change", nil, nil)
    end
end

function M:OnSliderValueChanged_Internal(Value,NoCallback)
    Value = math.floor(Value/self.StepSize + 0.5) * self.StepSize
    Value = math.clamp(Value,self.MinValue, self.MaxValue)
    local Text = UKismetTextLibrary.Conv_FloatToText(Value,0,false,true,1,324,0,self.MaxFractionalDigits)
    Value = tonumber(Text)
    local LastValue = self.CurrentValue or 0
    self.CurrentValue = Value
    self.Slider:SetValue(Value)
    self.Text_Num:SetText(Text)
    self.ProgressBar:SetPercent(self.Slider:GetNormalizedValue())
    if(self.DefaultValue <= self.CurrentValue)then
        self.WS_DefaultPosition:SetActiveWidgetIndex(1)
    else
        self.WS_DefaultPosition:SetActiveWidgetIndex(0)
    end
    self:UpdateResetBtnVisibility()
    if(self.CurrentValue ~= LastValue and not NoCallback and rawget(self,"_OnValueChanged"))then
        self._OnValueChanged(self.Owner,Value,self.Params)
    end
end

function M:OnResetBtnClicked()
    local DontReset = false
    if(rawget(self,"_OnResetBtnClicked"))then
        DontReset = self._OnResetBtnClicked(self.Owner,self.Params)
    end
    if(not DontReset)then
        self:ResetValue()
    end
end

function M:OnRepeatKeyDown(MyGeometry, InKeyEvent)
    local Reply,IsHandled = self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
    if(IsHandled)then
        return Reply
    end
    return UIUtils.Unhandled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local Reply,IsHandled = self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
    if(IsHandled)then
        return Reply
    end
    return UIUtils.Unhandled
end


function M:OnAddedToFocusPath(InFocusEvent)
    rawset(self,"bInFocusPath",true)
    self:UpdateResetBtnVisibility()
    self:UpdateSeletState()
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    rawset(self,"bInFocusPath",false)
    self:UpdateResetBtnVisibility()
    self:UpdateSeletState()
end

function M:UpdateSeletState()
    if(self.IsGamepadInput and rawget(self,"bInFocusPath"))then
        self:StopAnimation(self.GamePad_Normal)
        self:PlayAnimation(self.GamePad_Select)
        self.Key_LT:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Key_RT:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self:StopAnimation(self.GamePad_Select)
        self:PlayAnimation(self.GamePad_Normal)
        self.Key_LT:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Key_RT:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

AssembleComponents(M)

return M

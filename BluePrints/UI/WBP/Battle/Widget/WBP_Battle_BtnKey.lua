--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---HUD界面上带键位UI的按钮
---@type WBP_Battle_BtnKey_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--region private
function M:Construct()
    self.Button_Area.OnClicked:Add(self, self.OnBtnAreaClick)
    -- self.Button_Forbid.OnClicked:Add(self, self.OnBtnForbidClick)
    -- self.Button_Forbid:SetVisibility(UIConst.VisibilityOp.Collapsed)

    -- local Platform = CommonUtils.GetRealDevicePlatformName(self)
    -- if Platform == "Mobile" and self:IsVisible() then
    --     assert(false, LXYTag.."WBP_Battle_BtnKey::Error:  这个按钮不能用在移动端!!!!，蓝图改改")
    -- end
    
    local CurMode =  UIUtils.UtilsGetCurrentInputType()
    self.KeyWidget = nil
    if CurMode == ECommonInputType.Gamepad then
        self.WidgetSwitcher_MP:SetActiveWidgetIndex(1)
        self.KeyWidget = self.Key_GamePad
    else
        self.WidgetSwitcher_MP:SetActiveWidgetIndex(0)
        self.KeyWidget = self.Key_PC
    end
	self:StopAllAnimations()
	self:PlayAnimation(self.Normal)

    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
end

function M:OnBtnAreaClick()
    if self.BtnAreaCb then
        self.BtnAreaCb()
    end
end

-- function M:OnBtnForbidClick()
--     if self.BtnForbidCb then
--         self.BtnForbidCb()
--     end
-- end

function M:Destruct()
    self.Button_Area.OnClicked:Remove(self, self.OnBtnAreaClick)
    --self.Button_Forbid.OnClicked:Remove(self, self.OnBtnForbidClick)
    self.BtnAreaCb = nil
    --self.BtnForbidCb = nil
end
--endregion


--region public
function M:SetBtnNormalCallback(Cb)
    self.BtnAreaCb = Cb
end

-- function M:SetBtnForbidCallback(Cb)
--     self.BtnForbidCb = Cb
-- end

function M:SetForbid(bOn)
    -- if bOn then
    --     self.Button_Forbid:SetVisibility(UIConst.VisibilityOp.Visible)
    --     self.Button_Area:SetVisibility(UIConst.VisibilityOp.Collapsed)
    --     self:UnbindAllFromAnimationFinished(self.UnHover)
    --     self:StopAllAnimations()
    --     self:PlayAnimation(self.Forbidden)
    -- else 
    --     self.Button_Forbid:SetVisibility(UIConst.VisibilityOp.Collapsed)
    --     self:BindToAnimationFinished(self.UnHover, {self.Button_Area, self.Button_Area.BackToNormalAnim})
    --     self:StopAllAnimations()
    --     self:PlayAnimation(self.Normal)
    -- end
    self.Button_Area:SetForbidden(bOn)
end

function M:SetText(Text)
    self.Text_Button:SetText(Text)
end

function M:SetImg(GamepadPath, KeyboardPath)
    if GamepadPath then
        self.Key_GamePad:SetImage("Image",GamepadPath)
    end
    if KeyboardPath then
        self.Key_PC:SetImage("Text",KeyboardPath)
    end
end

---这里不提供键位UI的设置接口，仅提供引用，需要设置的自己去里边调接口
function M:GetKeyWidget()
    return self.KeyWidget
end
--endregion

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        return
    end
    self.CurInputDeviceType = CurInputDevice

    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end

    --- 切换手柄端相关图标显隐
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if IsUseKeyAndMouse then
        self.WidgetSwitcher_MP:SetActiveWidgetIndex(0)
        self.KeyWidget = self.Key_PC
    else
        self.WidgetSwitcher_MP:SetActiveWidgetIndex(1)
        self.KeyWidget = self.Key_GamePad
    end
end

return M

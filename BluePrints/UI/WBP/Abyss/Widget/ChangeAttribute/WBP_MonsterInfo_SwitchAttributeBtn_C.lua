
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
    self:BindButtonPerformances()
    self:InitGamepadKeys()
    self.OnClickEvent = nil
end

function M:Destruct()
    self.OnClickEvent = nil
    self:UnBindButtonPerformances()
end

-- @param Params table 包含以下参数
-- @param Params.Parent UserWidget 按钮的父控件
-- @param Params.ShowText string 按钮显示的文本
-- @param Params.GamepadKey string 手柄按键
-- @param Params.BtnClickCallback function 按钮点击回调函数
function M:Init(Params)
    local TargetText = GText(Params.ShowText) or GText("UI_Switch_Attribute")
    if self.Text_Attribute then
        self.Text_Attribute:SetText(TargetText)
    end
    if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
        self.GamePadKey = Params.GamepadKey or "X"
        self:InitGamepadKeys()
    end
    if Params.BtnClickCallback then
        self:BindEventOnClicked(Params.BtnClickCallback)
    end
    if Params.AttributeIcon then
        local AttributeIcon = LoadObject(Params.AttributeIcon)
        self.Attribute:SetBrushFromTexture(AttributeIcon)
    end

    self:OnUpdateUIStyleByInputTypeChange(UIUtils.UtilsGetCurrentInputType())
end

function M:InitGamepadKeys()
    self.Key_Controller:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = self.GamePadKey,
            },
        },
    })
end

function M:BindEventOnClicked(Event)
    if type(Event) ~= "function" then
        return
    end
    self.OnClickEvent = Event
end

function M:OnClicked()
    if self.OnClickEvent then
        self.OnClickEvent()
    end
end

function M:SwitchUIType(IsGamePad)
    if IsGamePad then
        self.Key_Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Key_Controller:SetVisibility(ESlateVisibility.Collapsed)
    end
end

-------------------------------- 按钮 绑定/解绑 相关 -----------------------------------
function M:BindButtonPerformances()
    self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
    self.Btn_Click.OnPressed:Add(self, self.OnBtnPressed)
    self.Btn_Click.OnReleased:Add(self, self.OnBtnReleased)
    self:BindToAnimationFinished(self.Click, {self, self.OnClickAnimationFinished})
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Btn_Click.OnHovered:Add(self, self.OnBtnHovered)
        self.Btn_Click.OnUnhovered:Add(self, self.OnBtnUnhovered)
    end
end

function M:UnBindButtonPerformances()
    self.Btn_Click.OnClicked:Clear()
    self.Btn_Click.OnPressed:Clear()
    self.Btn_Click.OnReleased:Clear()
    self:UnbindFromAnimationFinished(self.Click, {self, self.OnClickAnimationFinished})
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Btn_Click.OnHovered:Clear()
        self.Btn_Click.OnUnhovered:Clear()
    end
end
-------------------------------- 按钮 Click Press Release Hover UnHover 相关表现 -----------------------------------

----------------------------------------- 按钮 Normal -----------------------------------------------
function M:SwitchNormalAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
end

----------------------------------------- 按钮 Click -----------------------------------------------
function M:PlayButtonClickSound()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid",nil,nil)
    --UIUtils.PlayCommonBtnSe(self)
end

function M:PlayButtonClickAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
    self:PlayAnimation(self.Click)
end

function M:OnBtnClicked()
    self:PlayButtonClickSound()
    self:PlayButtonClickAnimation()
    self:OnClicked()
end

function M:OnClickAnimationFinished()
    if not self.IsHovering then
        self:PlayButtonReleaseAndUnHoverAnim()
    else
        self:PlayButtonReleaseButHoverAnim()
    end
end
----------------------------------------- 按钮 Click -----------------------------------------------

----------------------------------------- 按钮 Press -----------------------------------------------
function M:PlayButtonPressAnim()
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
    self:PlayAnimation(self.Press)
end

function M:OnBtnPressed()
    --self:PlayButtonClickSound()
    self.IsPressing = true
    self:PlayButtonPressAnim()
end
----------------------------------------- 按钮 Press -----------------------------------------------

----------------------------------------- 按钮 Hover -----------------------------------------------
function M:PlayButtonHoverAnim()
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
    self:PlayAnimation(self.Hover)
end

function M:OnBtnHovered()
    self.IsHovering = true
    self:PlayButtonHoverAnim()
end

function M:SetBtnHovered(IsHovered)
    if IsHovered then 
        self:OnBtnHovered()
    else 
        self:OnBtnUnhovered()
    end
end 

----------------------------------------- 按钮 Hover -----------------------------------------------

----------------------------------------- 按钮 Release -----------------------------------------------
function M:PlayButtonReleaseButHoverAnim()
    self:StopAllAnimations()
    self:PlayButtonHoverAnim()
end

function M:PlayButtonReleaseAndUnHoverAnim()
    self:StopAllAnimations()
    self:PlayButtonUnHoverAnim()
end

function M:OnBtnReleased()
    self.IsPressing = false
end
----------------------------------------- 按钮 Release -----------------------------------------------

----------------------------------------- 按钮 UnHover -----------------------------------------------
function M:PlayButtonUnHoverAnim()
    self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
end

function M:OnBtnUnhovered()
    self.IsHovering = false
    if not self.IsPressing then
        self:PlayButtonUnHoverAnim()
    end
end
----------------------------------------- 按钮  UnHover -----------------------------------------------

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, GamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end

    --- 切换手柄端相关图标显隐
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if IsUseKeyAndMouse then
        self.WS_Controller:SetActiveWidgetIndex(0)
    else
        self.WS_Controller:SetActiveWidgetIndex(1)
    end
end

function M:OnGamePadUp(InKeyName)
    if InKeyName == Const.GamepadFaceButtonLeft then
        self:OnClicked()
        return true
    end
    return false
end

return M
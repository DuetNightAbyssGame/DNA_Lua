
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
    self.Text_Confirm:SetText(GText("UI_Ticket_Choose"))
    self:BindButtonPerformances()
    self:InitGamepadKeys()
    self.OnClickEvent = nil
end

function M:Destruct()
    self.OnClickEvent = nil
    self:UnBindButtonPerformances()
end

function M:InitGamepadKeys()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    self.Key_Confirm:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "X",
            },
        },
    })
end

function M:BindEventOnClicked(Obj, Event)
    if type(Event) ~= "function" then
        return
    end
    self.OnClickObj = Obj
    self.OnClickEvent = Event
end

function M:OnClicked()
    if self.OnClickEvent then
        self.OnClickEvent(self.OnClickObj)
    end
end

function M:SwitchUIType(IsGamePad)
    if IsGamePad then
        self.Key_Confirm:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Key_Confirm:SetVisibility(ESlateVisibility.Collapsed)
    end
end

-------------------------------- 按钮 绑定/解绑 相关 -----------------------------------
function M:BindButtonPerformances()
    self.Btn_Confirm.OnClicked:Add(self, self.OnBtnClicked)
    self.Btn_Confirm.OnPressed:Add(self, self.OnBtnPressed)
    self.Btn_Confirm.OnReleased:Add(self, self.OnBtnReleased)
    self:BindToAnimationFinished(self.Click, {self, self.OnClickAnimationFinished})
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Btn_Confirm.OnHovered:Add(self, self.OnBtnHovered)
        self.Btn_Confirm.OnUnhovered:Add(self, self.OnBtnUnhovered)
    end
end

function M:UnBindButtonPerformances()
    self.Btn_Confirm.OnClicked:Clear()
    self.Btn_Confirm.OnPressed:Clear()
    self.Btn_Confirm.OnReleased:Clear()
    self:UnbindFromAnimationFinished(self.Click, {self, self.OnClickAnimationFinished})
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Btn_Confirm.OnHovered:Clear()
        self.Btn_Confirm.OnUnhovered:Clear()
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
    AudioManager(self):PlayUISound(self, "event:/ui/activity/confirm_click",nil,nil)
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

return M
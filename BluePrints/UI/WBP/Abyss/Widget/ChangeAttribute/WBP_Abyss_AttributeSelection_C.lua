
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
    self:BindButtonPerformances()
    self.OnClickEvent = nil
    self.Checked = false
end

function M:Destruct()
    self.OnClickEvent = nil
    self:UnBindButtonPerformances()
end

function M:Init(AttrIndex, AttrIcon, ChangeAttrPage)
    if not ChangeAttrPage then
        GWorld.logger.error("WBP_Abyss_AttributeSelection_C@Init, ChangeAttrPage is nil!")
        return
    end
    self.Checked = false
    self.AttrIndex = AttrIndex
    self.ChangeAttrPage = ChangeAttrPage
    if IsValid(AttrIcon) then
        self.Attribute:SetBrushResourceObject(AttrIcon)
    end
end

function M:OnClicked()
    if self.ChangeAttrPage then
        self.ChangeAttrPage:AttrSelectionChanged(self.AttrIndex)
    else
        GWorld.logger.error("WBP_Abyss_AttributeSelection_C@OnClicked, ChangeAttrPage is nil!")
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
    AudioManager(self):PlayUISound(self, "event:/ui/activity/drama_challenge_type_select_btn_click", nil, nil)
end

function M:PlayButtonClickAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
end

function M:OnBtnClicked()
    if self.Checked == false then
        self:SetIsChecked(true, true)
        self:OnClicked()
    end
end
----------------------------------------- 按钮 Click -----------------------------------------------

----------------------------------------- 按钮 Press -----------------------------------------------
function M:PlayButtonPressAnim()
    self:StopAllAnimations()
    self:PlayAnimation(self.Press)
end

function M:OnBtnPressed()
    if self.Checked == true then
        return
    end
    self:PlayButtonClickSound()
    self.IsPressing = true
    self:PlayButtonPressAnim()
end
----------------------------------------- 按钮 Press -----------------------------------------------

----------------------------------------- 按钮 Hover -----------------------------------------------
function M:PlayButtonHoverAnim()
    if self.ChangeAttrPage.UsingGamepad then
        self:OnBtnClicked()
        return
    end
    self:StopAllAnimations()
    self:SwitchNormalAnimation()
    self:PlayAnimation(self.Hover)
end

function M:OnBtnHovered()
    if self.Checked == true then
        return
    end
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
    self:SwitchNormalAnimation()
end

function M:OnBtnReleased()
    self.IsPressing = false
    if self.Checked == true then
        return
    end
    if not self.IsHovering then
        self:PlayButtonReleaseAndUnHoverAnim()
    else
        self:PlayButtonReleaseButHoverAnim()
    end
end
----------------------------------------- 按钮 Release -----------------------------------------------

----------------------------------------- 按钮 UnHover -----------------------------------------------
function M:PlayButtonUnHoverAnim()
    self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
end

function M:OnBtnUnhovered()
    self.IsHovering = false
    if self.Checked == true then
        return
    end
    if not self.IsPressing then
        self:PlayButtonUnHoverAnim()
    end
end
----------------------------------------- 按钮  UnHover -----------------------------------------------

----------------------------------------- 按钮 Checked -----------------------------------------------

function M:SetIsChecked(IsChecked,IsPlaySound)
    if self.Checked == false and IsChecked == true then
        self.Checked = true
        if IsPlaySound then
            self:PlayCheckSound(true)
        end
        self:PlayButtonCheckAnimation()
    elseif self.Checked == true and IsChecked == false then
        self.Checked = false
        if IsPlaySound then
            self:PlayCheckSound(false)
        end
        self:PlayButtonUnCheckAnimation()
    end
end

function M:PlayButtonCheckAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Select)
end

function M:PlayButtonUnCheckAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.UnSelect)
end

function M:PlayCheckSound(IsChecked)
    if IsChecked then
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
    else
        -- AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_uncheck", nil, nil)
    end
end

----------------------------------------- 按钮 Checked -----------------------------------------------

return M

local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
    self.Checked = false
    self:BindButtonPerformances()
end

function M:Destruct()
    self:UnBindButtonPerformances()
end
local ModModel = ModController:GetModel()
function M:Init(Index, ImportPanel)
    self.Checked = false
    self.Index = Index
    self.ImportPanel = ImportPanel
    local SuitName = ModModel:GetSuitName(Index)
    self.Text_Plan:SetText(SuitName)
    self:SwitchNormalAnimation()
end

function M:OnClicked()
    if self.ImportPanel then
        self.ImportPanel:ImportItemChanged(self.Index)
    else
        DebugPrint("lhr@Armory_Mod_ImportItem:OnClicked，方案导入面板失效")
    end
end

-------------------------------- 按钮 绑定/解绑 相关 -----------------------------------
function M:BindButtonPerformances()
    self.Button_Area.OnClicked:Add(self, self.OnBtnClicked)
    self.Button_Area.OnPressed:Add(self, self.OnBtnPressed)
    self.Button_Area.OnReleased:Add(self, self.OnBtnReleased)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Button_Area.OnHovered:Add(self, self.OnBtnHovered)
        self.Button_Area.OnUnhovered:Add(self, self.OnBtnUnhovered)
    end
end

function M:UnBindButtonPerformances()
    if not self.Button_Area then
        return
    end
    self.Button_Area.OnClicked:Clear()
    self.Button_Area.OnPressed:Clear()
    self.Button_Area.OnReleased:Clear()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Button_Area.OnHovered:Clear()
        self.Button_Area.OnUnhovered:Clear()
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
    UIUtils.PlayCommonBtnSe(self)
end

function M:PlayButtonClickAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
end

function M:OnBtnClicked()
    if self.Checked == false then
        self:PlayCheckSound(true)
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
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
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
    self:SwitchNormalAnimation()
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
        self:PlayButtonClickAnimation()
    elseif self.Checked == true and IsChecked == false then
        self.Checked = false
        if IsPlaySound then
            self:PlayCheckSound(false)
        end
        self:SwitchNormalAnimation()
    end
end

function M:PlayCheckSound(IsChecked)
    if IsChecked then
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
    else
        -- AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_uncheck", nil, nil)
    end
end

return M
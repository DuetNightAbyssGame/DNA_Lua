--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_SoloTreasure_BuildBag_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

local DefaultSoundPath = "event:/ui/common/click_mid"

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Checked = false
    self.IsForbidden = false
    self.IsEmpty = true
    self:BindButtonPerformances()
end

function M:Destruct()
    self:UnBindButtonPerformances()
end

-------------------------------- 按钮 绑定/解绑 相关 -----------------------------------
function M:BindButtonPerformances()
    local Btn = self.Btn_Click
    if not Btn then
        return
    end

    Btn.OnClicked:Add(self, self.OnBtnClicked)
    Btn.OnPressed:Add(self, self.OnBtnPressed)
    Btn.OnReleased:Add(self, self.OnBtnReleased)

    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        Btn.OnHovered:Add(self, self.OnBtnHovered)
        Btn.OnUnhovered:Add(self, self.OnBtnUnhovered)
    end
end

function M:UnBindButtonPerformances()
    local Btn = self.Btn_Click
    if not Btn then
        return
    end

    Btn.OnClicked:Clear()
    Btn.OnPressed:Clear()
    Btn.OnReleased:Clear()

    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        Btn.OnHovered:Clear()
        Btn.OnUnhovered:Clear()
    end
end

-------------------------------- 按钮动画相关 -----------------------------------
function M:SwitchNormalAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
end

function M:PlayButtonClickSound()
    if self.IsEmpty then
        AudioManager(self):PlayUISound(self, DefaultSoundPath, nil, nil)
    else
        AudioManager(self):PlayUISound(self, self.SoundPath or DefaultSoundPath, nil, nil)
    end
end

function M:PlayButtonClickAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
end

function M:OnBtnClicked(bNotPlaySound)
    if self.IsForbidden == true then
        self:OnForbiddenClicked()
    else
        if self.Checked == false then
            if not bNotPlaySound then
                self:PlayButtonClickSound()
            end
            self:PlayButtonClickAnimation()
        end
    end
end

function M:PlayButtonPressAnim()
    self:StopAllAnimations()
    self:PlayAnimation(self.Press)
end

function M:OnBtnPressed()
    if self.Checked == true then
        return
    end

    self.IsPressing = true
    self:PlayButtonPressAnim()
end

function M:PlayButtonHoverAnim()
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnBtnHovered()
    if self.Checked == true then
        return
    end

    self.IsHovering = true
    self:PlayButtonHoverAnim()
end

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

function M:PlayButtonUnHoverAnim()
    self:StopAllAnimations()
    -- 有 Unhover 动画则播 Unhover，否则播 Normal
    if self.Unhover then
        self:PlayAnimation(self.Unhover)
    end
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

function M:PlayButtonSelectAnim()
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
end

-- 设置选中状态
function M:SetIsChecked(IsChecked)
    if self.Checked == IsChecked then
        return
    end

    self.Checked = IsChecked
    if IsChecked then
        self:PlayButtonSelectAnim()
    else
        self:SwitchNormalAnimation()
        if self.IsForbidden then
            self:PlayButtonForbidAnim()
        end
    end
end

return M

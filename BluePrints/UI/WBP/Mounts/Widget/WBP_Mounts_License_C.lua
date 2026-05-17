--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Mounts_License_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self:BindLicenseBtnEvent()
end

function M:BindLicenseBtnEvent()
    self:UnBindLicenseBtnEvent()
    self.Btn_Area.OnClicked:Add(self, self.OnLicenseBtn_OnClicked)
    self.Btn_Area.OnHovered:Add(self, self.OnLicenseBtn_OnHovered)
    self.Btn_Area.OnUnhovered:Add(self, self.OnLicenseBtn_OnUnhovered)
    self.Btn_Area.OnPressed:Add(self, self.OnLicenseBtn_OnPressed)
end

function M:OnLicenseBtn_OnClicked()
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
end

function M:OnLicenseBtn_OnHovered()
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnLicenseBtn_OnUnhovered()
    self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
end

function M:OnLicenseBtn_OnPressed()
    self:StopAllAnimations()
    self:PlayAnimation(self.Press)
end

function M:OnAnimationFinished(Animation)
    if Animation == self.UnHover then
        self:PlayAnimation(self.Normal)
    end
end

function M:Destruct()
    self:UnBindLicenseBtnEvent()
end

function M:UnBindLicenseBtnEvent()
    self.Btn_Area.OnClicked:Clear()
    self.Btn_Area.OnHovered:Clear()
    self.Btn_Area.OnUnhovered:Clear()
    self.Btn_Area.OnPressed:Clear()
    self.Btn_Area.OnReleased:Clear()
end

return M

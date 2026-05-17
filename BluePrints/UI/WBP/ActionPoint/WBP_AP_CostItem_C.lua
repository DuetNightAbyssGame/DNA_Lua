--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local M = Class("BluePrints.UI.BP_UIState_C")


function M:Construct()

end

--Overriden
function M:OnLoaded()
    
end

function M:Init(Content)
    self.Item_Cost:Init(Content)
    self.Parent=Content.Parent
    self.IsMoonStone=Content.IsMoonStone
    -- self.Btn_Area.OnClicked:Add(self, self.OnBtnClicked)
    -- self.Btn_Area.OnPressed:Add(self, self.OnBtnPressed)
    -- self.Btn_Area.OnReleased:Add(self, self.OnBtnReleased)
    self.Btn_Area.OnHovered:Add(self, self.OnBtnHovered)
    -- self.Btn_Area.OnUnhovered:Add(self, self.OnBtnUnhovered)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
        if self.Parent then
            if self.IsMoonStone then
                self.Parent:OnClickMoonStone()
                self:PlayAnimation(self.Click)
            else
                self.Parent:OnClickResource()
                self:PlayAnimation(self.Click)
            end
        end
    end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled=false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName==UIConst.GamePadKey.FaceButtonBottom then
            if self.Parent then
                self.Parent:BtnConfirmClicked()
            end
        end
    end
    return IsEventHandled
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
    self:PlayButtonClickAnimation()
end
----------------------------------------- 按钮 Click -----------------------------------------------

----------------------------------------- 按钮 Press -----------------------------------------------
function M:PlayButtonPressAnim()
    self:StopAllAnimations()
    self:PlayAnimation(self.Press)
end

function M:OnBtnPressed()
    self.IsPressing = true
    self:PlayButtonPressAnim()
end
----------------------------------------- 按钮 Press -----------------------------------------------

----------------------------------------- 按钮 Hover -----------------------------------------------
function M:PlayButtonHoverAnim()
    --self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnBtnHovered()
    self.IsHovering = true
    self:PlayButtonHoverAnim()
    if UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
        self:SetFocus()
    end
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
    if  not self.IsHovering then
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
    if not self.IsPressing then
        self:PlayButtonUnHoverAnim()
    end
end
----------------------------------------- 按钮  UnHover -----------------------------------------------

function M:SwitchNormalAnimation()
    self:PlayAnimation(self.UnHover)
    self:PlayAnimation(self.Normal)
end

return M

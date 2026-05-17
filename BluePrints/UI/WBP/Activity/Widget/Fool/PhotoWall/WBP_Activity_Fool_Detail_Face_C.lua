local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr",
})

function M:Construct()
    self.FaceWidget = nil
    self.OnClickEvent = nil
    self.Checked = false
    self:BindButtonPerformances()
end

function M:Destruct()
    self.FaceWidget = nil
    self.OnClickEvent = nil
    self:UnBindButtonPerformances()
end

function M:Init(FaceWidget, GamepadKey, Callback, bSettlement)
    self.Checked = false
    self.bSettlement = bSettlement
    self:InitKeyInfo(GamepadKey)
    self:InitFaceWidget(FaceWidget)
    self:BindEventOnFaceClicked(Callback)
end

function M:InitKeyInfo(KeyName)
    if not KeyName then
        self.Key_Face:SetRenderOpacity(0)
        return
    end
    self.Key_Face:SetRenderOpacity(1)
    self.Key_Face:CreateCommonKey({
        KeyInfoList = {
            {
                ImgShortPath = KeyName,
                Type = "Img",
            }
        },
        bLongPress = false,
    })
end

function M:InitFaceWidget(Widget)
    if not IsValid(Widget) then
        return
    end
    self.FaceWidget = Widget
end

function M:BindEventOnFaceClicked(Callback)
    if Callback then
        self.OnClickEvent = Callback
        self:SetIsForbidden(false)
    else
        self:SetIsForbidden(true)
    end
end

function M:SetIsForbidden(bForbidden)
    if bForbidden then
        self:Disable()
        self:PlayAnimation(self.Forbbiden)
        if IsValid(self.FaceWidget) then
            self.FaceWidget:StopAllAnimations()
            self.FaceWidget:PlayAnimation(self.FaceWidget.Forbbiden)
        end
    else
        self:Enable()
        self:SwitchNormalAnimation()
        if IsValid(self.FaceWidget) then
            self.FaceWidget:StopAllAnimations()
            if self.bSettlement then
                self.FaceWidget:PlayAnimation(self.FaceWidget.SettleMent_Normal)
            else
                self.FaceWidget:PlayAnimation(self.FaceWidget.Normal)
            end
        end
    end
end

function M:Enable()
    self.bEnabled = true
    self.Btn_Face:SetVisibility(ESlateVisibility.Visible)
    self:SwitchUIType(self.bGamepad)
end

function M:Disable()
    self.bEnabled = false
    self.Btn_Face:SetVisibility(ESlateVisibility.HitTestInvisible)
    self.Key_Face:SetVisibility(ESlateVisibility.Collapsed)
end

function M:SetIsLoading(bLoading)
    self.bLoading = bLoading
    if bLoading then
        self.Key_Face:SetVisibility(ESlateVisibility.Collapsed)
        if IsValid(self.FaceWidget) then
            self.FaceWidget:SetVisibility(ESlateVisibility.Collapsed)
        end
    else
        self:SwitchUIType(self.bGamepad)
        if IsValid(self.FaceWidget) then
            self.FaceWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        self:SwitchNormalAnimation()
    end
end

function M:SetLikeNum(Number)
    if not Number then return end
    if not IsValid(self.FaceWidget) or not IsValid(self.FaceWidget.Text_FaceSlotNum) then
        return
    end
    self.FaceWidget.Text_FaceSlotNum:SetText(Number)
end

function M:GetLikeNum()
    if not IsValid(self.FaceWidget) or not IsValid(self.FaceWidget.Text_FaceSlotNum) then
        return
    end
    return tonumber(self.FaceWidget.Text_FaceSlotNum:GetText())
end

function M:SwitchUIType(bGamepad)
    if bGamepad then
        if(self.bEnabled and not self.bLoading) then
            self.Key_Face:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    else
        self.Key_Face:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.bGamepad = bGamepad
end

function M:OnClicked()
    if self.OnClickEvent then
        ---@param bool 此次点击是选中还是取消选中
        self.OnClickEvent(not self.Checked)
    end
end

-------------------------------- 按钮 绑定/解绑 相关 -----------------------------------
function M:BindButtonPerformances()
    self.Btn_Face.OnClicked:Add(self, self.OnBtnClicked)
    self.Btn_Face.OnPressed:Add(self, self.OnBtnPressed)
    self.Btn_Face.OnReleased:Add(self, self.OnBtnReleased)
    self:BindToAnimationFinished(self.Click, {self, self.OnClickAnimationFinished})
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Btn_Face.OnHovered:Add(self, self.OnBtnHovered)
        self.Btn_Face.OnUnhovered:Add(self, self.OnBtnUnhovered)
    end
end

function M:UnBindButtonPerformances()
    self.Btn_Face.OnClicked:Clear()
    self.Btn_Face.OnPressed:Clear()
    self.Btn_Face.OnReleased:Clear()
    self:UnbindFromAnimationFinished(self.Click, {self, self.OnClickAnimationFinished})
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Btn_Face.OnHovered:Clear()
        self.Btn_Face.OnUnhovered:Clear()
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
    AudioManager(self):PlayUISound(self, "event:/ui/activity/fools_day_emoj_click", nil, nil)
end

function M:PlayButtonClickAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
end

function M:OnBtnClicked()
    if self.Checked == false then
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

function M:SetIsChecked(IsChecked,IsPlaySound,bPlayInAnim)
    if IsChecked == true then
        self.Checked = true
        if IsPlaySound then
            self:PlayCheckSound(true)
        end
        self:DelayPlayCheckAnim(true, bPlayInAnim)
    elseif IsChecked == false then
        self.Checked = false
        if IsPlaySound then
            self:PlayCheckSound(false)
        end
        self:DelayPlayCheckAnim(false, bPlayInAnim)
    end
end

function M:DelayPlayCheckAnim(IsChecked, bPlayInAnim)
    self.PlayChecked = IsChecked
    self.PlayInAnim = bPlayInAnim
    if self.DelayTimer then return end
    self.DelayTimer = self:AddTimer(0.01, function()
        if self.PlayChecked then
            if self.PlayInAnim then
                self:PlayButtonCheckInAnimation()
            else
                self:PlayButtonCheckAnimation()
            end
        else
            self:PlayButtonUnCheckAnimation()
        end
        self.DelayTimer = nil
    end, nil, nil, nil, true)
end

function M:PlayButtonCheckAnimation()
    local FaceWidget = self.FaceWidget
    if IsValid(FaceWidget) then
        FaceWidget:StopAllAnimations()
        FaceWidget:PlayAnimation(FaceWidget.Select)
        FaceWidget:StopAllAnimations()
    end
end

function M:PlayButtonCheckInAnimation()
    local FaceWidget = self.FaceWidget
    if IsValid(FaceWidget) then
        FaceWidget:StopAllAnimations()
        FaceWidget:PlayAnimation(FaceWidget.Select_In)
    end
end

function M:PlayButtonUnCheckAnimation()
    local FaceWidget = self.FaceWidget
    if IsValid(FaceWidget) then
        FaceWidget:StopAllAnimations()
        if not self.bSettlement then
            -- 将控件恢复至Normal第一帧
            FaceWidget:PlayAnimation(FaceWidget.Normal)
        else
            FaceWidget:PlayAnimation(FaceWidget.SettleMent_Normal)
        end
        FaceWidget:StopAllAnimations()
    end
end

function M:PlayCheckSound(IsChecked)
    if IsChecked then
        -- AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
    else
        -- AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_uncheck", nil, nil)
    end
end

----------------------------------------- 按钮 Checked -----------------------------------------------

return M
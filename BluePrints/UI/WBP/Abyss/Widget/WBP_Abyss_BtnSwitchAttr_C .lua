
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
    self:BindButtonPerformances()
    self:InitGamepadKeys()
    self.AttributeIcons = {
        [1] = self.Attribute_L,
        [2] = self.Attribute_R
    }
    self.Attribute2Idx = {}
    self.CurrentAttrIdx = -1
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
    self.Key_Controller:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Up",
            },
        },
    })
end

function M:Init(Attributes)
    local Attributes = Attributes or {}
    local Attribute2Idx = {}
    for i = 1,2,1 do
        local Attribute = Attributes[i]
        local CounterAttr = DataMgr.Attribute[Attribute].CounterType
        local IconPath = DataMgr.Attribute[CounterAttr].Icon
        self.AttributeIcons[i]:SetBrushResourceObject(LoadObject(IconPath))
        Attribute2Idx[CounterAttr] = i
    end
    self.Attribute2Idx = Attribute2Idx
    self.CurrentAttrIdx = -1
end

function M:ChooseAttribute(AttributeName)
    if not AttributeName then return -1 end
    local AttrIdx = self.Attribute2Idx[AttributeName]
    if not AttrIdx then return -1 end
    if self.CurrentAttrIdx == AttrIdx then return -1 end
    if AttrIdx == 1 then
        if self.CurrentAttrIdx ~= -1 then
            self:PlayAnimationReverse(self.Switch_LtoR)
        else
            self:PlayAnimation(self.Select_L)
        end
    else
        if self.CurrentAttrIdx ~= -1 then
            self:PlayAnimation(self.Switch_LtoR)
        else
            self:PlayAnimation(self.Select_R)
        end
    end
    self:PlayAnimation(self.Remind)
    self.CurrentAttrIdx = AttrIdx
    return AttrIdx
end

-- function M:SwitchAttribute()
--     local AttrIdx = self.CurrentAttrIdx
--     if AttrIdx == -1 then return end
--     if AttrIdx == 1 then
--         self:PlayAnimation(self.Switch_LtoR)
--     else
--         self:PlayAnimationReverse(self.Switch_LtoR)
--     end
--     self:PlayAnimation(self.Remind)
--     self.CurrentAttrIdx = 2 - AttrIdx
-- end

function M:BindEventOnClicked(Event, Obj)
    if type(Event) ~= "function" then
        return
    end
    self.OnClickEvent = Event
    self.OnClickObj = Obj
end

function M:OnClicked()
    if self.OnClickEvent then
        self.OnClickEvent(self.OnClickObj, self.CurrentAttrIdx)
    end
end

function M:SwitchUIType(IsGamePad)
    if IsGamePad then
        self.WS_Controller:SetActiveWidgetIndex(1)
    else
        self.WS_Controller:SetActiveWidgetIndex(0)
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

return M
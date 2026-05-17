--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SoloTreasure_ChoiceBtn_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Btn_Area.OnClicked:Add(self, self.OnBtnClick)
    self.Btn_Area.OnPressed:Add(self, self.OnBtnPress)
    self.Btn_Area.OnHovered:Add(self, self.OnBtnHover)
    self.Btn_Area.OnUnhovered:Add(self, self.OnBtnUnhovered)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self:AddInputMethodChangedListen()
    if  UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
        self:InitGamePadView()
    end
end

function M:InitButton(ButtonInfo)
    self.Text_Button:SetText(ButtonInfo.Text)
    --self.Key_GamePad:CreateCommonKey({ KeyInfoList = {{Type = "Img", ImgShortPath = ButtonInfo.KeyName}} })
end

function M:SetForbid(IsForbid)
    self.IsForbid = IsForbid
    if self.IsForbid then
        self:StopAnimation(self.Click)
        self:StopAnimation(self.Normal)
        self:PlayAnimation(self.Forbidden)
    else
        self:StopAnimation(self.Forbidden)
        self:PlayAnimation(self.Normal)
    end
end

function M:OnBtnClick()
    if self.IsForbid then
        return
    end
    self:PlayAnimation(self.Click)
end

function M:OnBtnPress()
    if self.IsForbid then
        return
    end
    self:PlayAnimation(self.Press)
    
end

function M:OnBtnHover()
    if self.IsForbid then
        return
    end
    self:PlayAnimation(self.Hover)
    
end

function M:OnBtnUnhovered()
    if self.IsForbid then
        return
    end
    self:PlayAnimation(self.UnHover)
    
end

function M:AddInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if(CurInputDevice == ECommonInputType.Gamepad) then
        self:InitGamePadView()
    else
        self:InitKeyboardView()
    end
end

function M:InitGamePadView()
    self.Key_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function M:InitKeyboardView()
    self.Key_GamePad:SetVisibility(ESlateVisibility.Collapsed)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M

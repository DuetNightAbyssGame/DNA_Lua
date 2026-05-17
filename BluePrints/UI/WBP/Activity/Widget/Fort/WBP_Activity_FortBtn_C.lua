--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_FortBtn_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Button_Area.OnHovered:Add(self, self.OnBtnHovered)
    self.Button_Area.OnUnhovered:Add(self, self.OnBtnUnhovered)
    self.Button_Area.OnPressed:Add(self, self.OnBtnPressed)
    self.Button_Area.OnReleased:Add(self, self.OnBtnReleased)
    self.Button_Area.OnClicked:Add(self, self.OnBtnClicked)

    self:InitGamePadKey()
    self:InitListenEvent()
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self:ClearListenEvent()
end

function M:SetText(Text)
    self.Text_Button:SetText(Text)
end

function M:BindEventOnClicked(Obj, Func, Params)
    if not Obj or not Func then
        return
    end
    self.Obj = Obj
    self.Func = Func
    self.Params = Params
end

function M:OnBtnHovered()
	self.IsHovering = true
	if self.IsPressing then
        return
    end
	self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnBtnUnhovered()
	self.IsHovering = false
	if not self.IsPressing then
		self:StopAllAnimations()
		self:PlayAnimation(self.Unhover)
	end
end

function M:OnBtnPressed()
	self.IsPressing = true
	self:StopAllAnimations()
    self:PlayAnimation(self.Press)
end

function M:OnBtnReleased()
    self.IsPressing = false
    if not self.IsHovering then
        self:StopAllAnimations()
        self:PlayAnimationReverse(self.Normal)
    else
        self:StopAllAnimations()
        self:PlayAnimationReverse(self.Hover)
    end
end

function M:OnBtnClicked()
	self:StopAllAnimations()
	self:PlayAnimation(self.Click)
    AudioManager(self):PlayUISound(self, "event:/ui/common/map_click_enter_level", nil, nil)
    if self.Obj and self.Func then
        if self.Params then
            self.Func(self.Obj, table.unpack(self.Params))
        else
            self.Func(self.Obj)
        end
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if IsUseKeyAndMouse then
		self:InitKeyboardView()
	else
		self:InitGamepadView()
	end
end

function M:InitGamepadView()
    self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:InitKeyboardView()
    self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:InitListenEvent()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end

    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:ClearListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

function M:InitGamePadKey()
    self.Key_GamePad:CreateCommonKey(
        {
            KeyInfoList = {{Type = "Img",ImgShortPath = "X"}},
        }
    )
end

return M

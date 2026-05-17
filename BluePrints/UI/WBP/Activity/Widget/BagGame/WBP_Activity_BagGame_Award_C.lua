--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local RewardModel = require "BluePrints.UI.WBP.Activity.Widget.BagGame.WBP_Activity_BagGame_Reward_Model"
---@type WBP_Activity_BagGame_Award_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Init()
    self:SetText(GText("UI_BackpackPuzzle_RewardBtn"))
    self:BindEventOnClicked(self,self.OpenReward)
end

function M:Construct()
    self.Button_Area.OnHovered:Add(self, self.OnBtnHovered)
    self.Button_Area.OnUnhovered:Add(self, self.OnBtnUnhovered)
    self.Button_Area.OnPressed:Add(self, self.OnBtnPressed)
    self.Button_Area.OnReleased:Add(self, self.OnBtnReleased)
    self.Button_Area.OnClicked:Add(self, self.OnBtnClicked)

    self:InitGamePadKey()
    self:InitListenEvent()

    ReddotManager.AddListenerEx("BagGameAward", self, self.RefreshReddot)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self:ClearListenEvent()
    ReddotManager.RemoveListener("BagGameAward", self)
end

function M:SetText(Text)
    self.Text_RewardProgress:SetText(Text)
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
    AudioManager(self):PlayUISound(self, "event:/ui/activity/shop_small_btn_click", nil, nil)
    if self.Obj and self.Func then
        if self.Params then
            self.Func(self.Obj, table.unpack(self.Params))
        else
            self.Func(self.Obj)
        end
    end
end

function M:OpenReward()
    RewardModel:OpenReward(self)
end

function M:HandleKeyDownOnGamePad(InKeyName)
    local IsEventHandled = false
    if (InKeyName == Const.GamepadFaceButtonUp) then
        self:OnBtnClicked()
    end
    return IsEventHandled
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    local IsUseGamepad = CurInputDevice == ECommonInputType.Gamepad
    if (IsUseGamepad) then
        --手柄
        self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
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
            KeyInfoList = {{Type = "Img",ImgShortPath = "Y"}},
        }
    )
end

function M:RefreshReddot(Count, RdType, Name)
    if Count and Count > 0 then
		self.Reddot:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	else
		self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
	end
end

return M

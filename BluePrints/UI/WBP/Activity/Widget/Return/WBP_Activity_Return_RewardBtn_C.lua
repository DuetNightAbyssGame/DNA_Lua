--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
---@type WBP_Activity_Return_Reward_C
local M = Class({"Blueprints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- Params({
--     ClickCallback = function,   按钮点击时的回调
--     ClickCallbackObj = Obj,     按钮点击时的回调接收对象
--     HasGetCurrentReward = bool, 是否已领取奖励
-- })
---@param Params table 配置信息
function M:Init(Params)
    self.ClickCallback = Params.ClickCallback
    self.ClickCallbackObj = Params.ClickCallbackObj
    self.HasGetCurrentReward = Params.HasGetCurrentReward
    self:SetText(GText("UI_ComebackEvent_EventReward"))
    self:BindEventOnClicked(self,self.OnBtnClicked)
    self.Key_Controller:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "LS"
            }
        }
    })
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
     if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self:AddInputMethodChangedListen()
    end
    if not ReddotManager.GetTreeNode("FeinaEventReward") then
        ReddotManager.AddNode("FeinaEventReward")
    end

    if self.HasGetCurrentReward then
        self:OnRewardReceived()
    end
end

function M:Construct()
    self.Btn_Click.OnHovered:Add(self, self.OnBtnHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnBtnUnhovered)
    self.Btn_Click.OnPressed:Add(self, self.OnBtnPressed)
    self.Btn_Click.OnReleased:Add(self, self.OnBtnReleased)
    self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:AddInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:RemoveInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice) 
    end
end


function M:Destruct()
    self:RemoveInputMethodChangedListen()
    ReddotManager.RemoveListener("FeinaEventReward", self)
    self.Super.Destruct(self)
end

function M:SetText(Text)
    self.Text_Reward:SetText(Text)
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
end

function M:OnBtnClicked()
	self:StopAllAnimations()
	self:PlayAnimation(self.Click)
    AudioManager(self):PlayUISound(self, "event:/ui/activity/gift_entrance_btn_click", nil, nil)
    if self.Obj and self.Func then
        if self.Params then
            self.Func(self.Obj, table.unpack(self.Params))
        else
            self.Func(self.Obj)
        end
    end
end

function M:OnBtnClicked()
    DebugPrint("lgc@WBP_Activity_Return_Reward OnBtnClicked")
    if self.ClickCallback then
        if self.ClickCallbackObj then
            self.ClickCallback(self.ClickCallbackObj)
        end
    end
end

function M:OnRewardReceived(RewardId)
    if not self.HasGetCurrentReward then
        self.HasGetCurrentReward = true
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Received)
    if not RewardId then
        return
    end
    local AllRewards = RewardUtils:GetRewards(RewardId, nil)
	UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, AllRewards, false, nil, self, false)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self:InitKeyBoardView()
    elseif CurInputDevice==ECommonInputType.Gamepad then
        self:InitGamepadView()
    end
    -- 更新当前输入设备类型
    self.CurInputDeviceType = CurInputDevice
end

function M:InitKeyBoardView()
    self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:InitGamepadView()
     self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:HandleKeyDownOnGamePad(InKeyName)
    local IsEventHandled=false
    if InKeyName== UIConst.GamePadKey.FaceButtonTop then
        IsEventHandled=true
        self:OnBtnClicked()
    end
    return IsEventHandled
end

function M:OnUpdateSubUIViewStyle(IsEnter)
    if IsEnter then
        self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Visible)
    else
        self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end
return M

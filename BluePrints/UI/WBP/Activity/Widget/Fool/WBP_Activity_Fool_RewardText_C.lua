--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local RewardModel = require "BluePrints.UI.WBP.Activity.Widget.Fool.WBP_AprilFoolDay_Reward_Model"

---@type WBP_Activity_Fool_RewardText_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.IsHovering = false
    self.IsPressing = false
    self.Btn_Click.OnHovered:Add(self, self.OnBtnHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnBtnUnhovered)
    self.Btn_Click.OnPressed:Add(self, self.OnBtnPressed)
    self.Btn_Click.OnReleased:Add(self, self.OnBtnReleased)
    self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
    self.Text_Reward:SetText(GText("PermanenEventReward"))
    self:BindEventOnClicked(self, self.OpenReward)

    self:InitGamePadKey()
    self:InitListenEvent()

    if not ReddotManager.GetTreeNode("AprilFoolDayRewardNew") then
		ReddotManager.AddNodeEx("AprilFoolDayRewardNew")
	end
	ReddotManager.AddListenerEx("AprilFoolDayRewardNew",self,self.RefreshReddot)
    if not ReddotManager.GetTreeNode("AprilFoolDayReward") then
		ReddotManager.AddNodeEx("AprilFoolDayReward")
	end
	ReddotManager.AddListenerEx("AprilFoolDayReward",self,self.RefreshReddot)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self:ClearListenEvent()
    ReddotManager.RemoveListener("AprilFoolDayRewardNew",self)
    ReddotManager.RemoveListener("AprilFoolDayReward",self)
end

function M:Init()
    self:PlayAnimation(self.In)
    self:PlayAnimation(self.Normal)
end

function M:OpenReward()
    local Node = ReddotManager.GetTreeNode("AprilFoolDayRewardNew")
    if Node and Node.Count > 0 then
        ReddotManager.DecreaseLeafNodeCount("AprilFoolDayRewardNew", Node.Count)
        local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AprilFoolDayRewardNew")
        CacheDetail.DoNotShowNew = 1
    end
    RewardModel:OpenReward()
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
	self:StopAllBtnAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnBtnUnhovered()
	self.IsHovering = false
	if not self.IsPressing then
		self:StopAllBtnAnimations()
		self:PlayAnimation(self.Unhover)
	end
end

function M:OnBtnPressed()
	self.IsPressing = true
	self:StopAllBtnAnimations()
    self:PlayAnimation(self.Press)
end

function M:OnBtnReleased()
    self.IsPressing = false
    if not self.IsHovering then
        self:StopAllBtnAnimations()
        self:PlayAnimationReverse(self.Normal)
    else
        self:StopAllBtnAnimations()
        self:PlayAnimationReverse(self.Hover)
    end
end

function M:OnBtnClicked()
	self:StopAllBtnAnimations()
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

function M:RefreshReddot()
    local RedNode = ReddotManager.GetTreeNode("AprilFoolDayReward")
    local NewNode = ReddotManager.GetTreeNode("AprilFoolDayRewardNew")
    if RedNode and RedNode.Count and RedNode.Count > 0 then
        self.Reddot:SetVisibility(ESlateVisibility.HitTestInvisible)
        self.New:SetVisibility(ESlateVisibility.Collapsed)
    elseif NewNode and NewNode.Count and NewNode.Count > 0 then
        self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
        self.New:SetVisibility(ESlateVisibility.HitTestInvisible)
    else
        self.New:SetVisibility(ESlateVisibility.Collapsed)
        self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:HandleKeyDownOnGamePad(InKeyName)
    local IsEventHandled = false
    if (InKeyName == Const.GamepadFaceButtonUp) then
        self:OnBtnClicked()
    end
    return IsEventHandled
end

function M:InitGamePadKey()
    self.Key_Controller:CreateCommonKey(
        {
            KeyInfoList = {{Type = "Img",ImgShortPath = "Y"}},
        }
    )
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

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    local IsUseGamepad = CurInputDevice == ECommonInputType.Gamepad
    self:OnUpdateSubUIViewStyle(IsUseGamepad)
end

function M:StopAllBtnAnimations()
    if self:IsAnimationPlaying(self.Normal) then
        self:StopAnimation(self.Normal)
    end
    if self:IsAnimationPlaying(self.Hover) then
        self:StopAnimation(self.Hover)
    end
    if self:IsAnimationPlaying(self.Unhover) then
        self:StopAnimation(self.Unhover)
    end
    if self:IsAnimationPlaying(self.Press) then
        self:StopAnimation(self.Press)
    end
    if self:IsAnimationPlaying(self.Click) then
        self:StopAnimation(self.Click)
    end
end

function M:OnUpdateSubUIViewStyle(IsUseGamepad)
    if IsUseGamepad then
        self.Key_Controller:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

return M

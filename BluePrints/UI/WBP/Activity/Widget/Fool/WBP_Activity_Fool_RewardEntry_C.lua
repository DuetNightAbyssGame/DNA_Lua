--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.EventId = DataMgr.EventConstant.AFDayEvent2026ID.ConstantValue
    self.ResourceId = DataMgr.EventConstant.TransformResourceID.ConstantValue
    self.IsHovering = false
    self.IsPressing = false
    self.Btn_Click.OnHovered:Add(self, self.OnBtnHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnBtnUnhovered)
    self.Btn_Click.OnPressed:Add(self, self.OnBtnPressed)
    self.Btn_Click.OnReleased:Add(self, self.OnBtnReleased)
    self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
    self.Text_Get:SetText(GText("AFDayEvent_ClaimItem"))
    self.Text_Jump:SetText(GText("AFDayEvent_JumpTransformList"))
    self:RefreshText()
    self:BindEventOnClicked(self, self.GetTransformationItemOrCheckDetail)

    self:InitGamePadKey()
    self:InitListenEvent()

    if not ReddotManager.GetTreeNode("AprilFoolDayTransformResource") then
		ReddotManager.AddNode("AprilFoolDayTransformResource")
	end
	ReddotManager.AddListener("AprilFoolDayTransformResource",self,self.RefreshReddot)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self:ClearListenEvent()
    ReddotManager.RemoveListener("AprilFoolDayTransformResource",self)
end

function M:Init()
    self:PlayAnimation(self.In)
    self:PlayAnimation(self.Normal)
end

function M:RefreshText()
    if self:CheckItemIsGot() then
        self.WS_RewardEntry:SetActiveWidgetIndex(0)
    else
        self.WS_RewardEntry:SetActiveWidgetIndex(1)
    end
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
    AudioManager(self):PlayUISound(self, "event:/ui/activity/fools_day_large_btn_click", nil, nil)
    if self.Obj and self.Func then
        if self.Params then
            self.Func(self.Obj, table.unpack(self.Params))
        else
            self.Func(self.Obj)
        end
    end
end

function M:GetTransformationItemOrCheckDetail()
    if self:CheckItemIsGot() then
        self:OpenCheckDetail()
    else
        local Callback = function (Ret,Rewards)
            if not ErrorCode:Check(Ret) then
                return
            end
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function ()
                self:RefreshText()
                self:OpenCheckDetail()
            end, self, false)
        end
        self:GetTransformationItem(Callback)
    end
end

function M:OpenCheckDetail()
    UIManager(self):LoadUINew("ActivityFoolArchive")
end

function M:GetTransformationItem(Callback)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    Avatar:FoolsDayGetTransformResource()

    local Node = ReddotManager.GetTreeNode("AprilFoolDayTransformResource")
    if Node.Count > 0 then
        ReddotManager.DecreaseLeafNodeCount("AprilFoolDayTransformResource", Node.Count)
    end

    local Rewards = {}
    Rewards["Resources"] = {}
    Rewards["Resources"][self.ResourceId] = 1
    Callback(0, Rewards)
end

function M:CheckItemIsGot()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    return Avatar:CheckTransformResourceIsGot()
end

function M:RefreshReddot()
    local Node = ReddotManager.GetTreeNode("AprilFoolDayTransformResource")
	if not Node then
        self:PlayAnimation(self.UnAct)
		self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
		return
	end
    if Node.Count > 0 then
        self:PlayAnimation(self.Act)
        self.Reddot:SetVisibility(ESlateVisibility.HitTestInvisible)
    else
        self:PlayAnimation(self.UnAct)
        self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:HandleKeyDownOnGamePad(InKeyName)
    local IsEventHandled = false
    if (InKeyName == Const.GamepadFaceButtonLeft) then
        self:OnBtnClicked()
    end
    return IsEventHandled
end

function M:InitGamePadKey()
    self.Key_Jump:CreateCommonKey(
        {
            KeyInfoList = {{Type = "Img",ImgShortPath = "X"}},
        }
    )
    self.Key_Get:CreateCommonKey(
        {
            KeyInfoList = {{Type = "Img",ImgShortPath = "X"}},
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
        self.Key_Jump:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Key_Get:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.WS_Key:SetActiveWidgetIndex(1)
    else
        self.Key_Jump:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Key_Get:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.WS_Key:SetActiveWidgetIndex(0)
    end
end

return M

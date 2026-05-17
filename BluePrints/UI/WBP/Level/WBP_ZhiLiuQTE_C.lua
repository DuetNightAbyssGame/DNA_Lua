--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Level_QTE_Zhiliu_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:Construct()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        self.Btn_Click.OnPressed:Add(self, self.PressedSelectAction)
        self.Btn_Click.OnReleased:Add(self, self.ReleasedSelectAction)
    end
end

function M:OnLoaded(...)
    self.Owner, self.InteractiveNum, self.InteractiveTime, self.DownTime = ...
    self.Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    self.FirstInteractive = false
    self.InPress = false
    self.Complete = false
    self.CurInteractiveNum = 0
    self.CurInteractivePercent = 0.0
    self.Material = self.Progress_Bar_LongPress:GetDynamicMaterial()
    if not self:IsListeningForInputAction("Interactive") then
        self:ListenForInputAction("Interactive", EInputEvent.IE_Pressed, true, {self, self.PressedSelectAction})
        self:ListenForInputAction("Interactive", EInputEvent.IE_Released, true, {self, self.ReleasedSelectAction})
    end
    self.CanInteract = false
    self:StopAllAnimations()
    self:PlayAnimation(self.In)
    self:BindToAnimationFinished(self.In, {self, function()
        self.CanInteract = true
        self:PlayAnimation(self.Remind)
    end})
    self:BindToAnimationFinished(self.Out, {self, function()
        self:Close()
    end})
    self:BindToAnimationFinished(self.Success, {self, self.OnFirstSuccess})
    self:SetBarPercent(0.0)
    DebugPrint("zwkkk WBP_ZhiLiuQTE_C OnLoaded ", self.InteractiveNum, self.InteractiveTime, self.DownTime)
    self.Panel_LongPress:SetVisibility(UE4.ESlateVisibility.Collapsed)

    self:InitImage()
    AudioManager(self):PlayUISound(self, "event:/ui/common/qte_show","QTEShow",nil)
end

function M:Tick(MyGeometry, InDeltaTime)
    if self.Complete then return end
    if not self.CanInteract then return end
    if self.Owner and self.Owner.CurStage ~= 2 then return end
    if self.InPress then
        -- 按住中，持续增长进度条
        self.CurInteractivePercent = math.min(1.0, self.CurInteractivePercent + InDeltaTime / self.InteractiveTime)
    elseif self.DownTime > 0 then
        -- 松开了按键，如果有回退速度的话需要慢慢降回去
        self.CurInteractivePercent = math.max(0.0, self.CurInteractivePercent - InDeltaTime / self.DownTime)
    end
    self:SetBarPercent(self.CurInteractivePercent)
    if self.CurInteractivePercent >= 1.0 then
        -- 交互完成
        self.Complete = true
        self.Owner:SecondStageComplete()
    end
end

function M:OnFirstSuccess()
    self:UnbindAllFromAnimationFinished(self.In)
    self:BindToAnimationFinished(self.In, function()
        self.CanInteract = true
    end)
    self:AddTimer(0.5, function()
        self:PlayAnimation(self.In)
    end, false, 0)
end

function M:PressedSelectAction()
    if not self.CanInteract then return end
    if not self.Owner then return end
    if not self.FirstInteractive and self.Owner.CurStage == 1 then
        self.FirstInteractive = true
        -- 第一下按下时让玩家进入交互状态
        self.Owner:OnEnterInteractive()
    end
    if self.Owner.CurStage == 1 then
        self.CurInteractiveNum = self.CurInteractiveNum + 1
        self:PlayAnimation(self.FeedBack)
        if self.CurInteractiveNum >= self.InteractiveNum then
            self.Owner:FirstStageComplete()
            -- self:StopAllAnimations()
            self.Panel_LongPress:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self:PlayAnimation(self.LongPress)
            self:PlayAnimationReverse(self.Remind)
            self.CanInteract = false
            AudioManager(self):PlayUISound(self, "event:/ui/common/qte_success", "",nil)
            self:PlayAnimation(self.Success)
        end
    elseif self.Owner.CurStage == 2 then
        self.InPress = true
        AudioManager(self):PlayUISound(self, "event:/ui/common/qte_press_loop", "QTEPress",nil)
        self.Owner:LongPressEnter()
    end
end

function M:ReleasedSelectAction()
    if not self.CanInteract then return end
    if not self.Owner then return end
    self.InPress = false
    if self.Owner.CurStage == 2 then
        AudioManager(self):StopSound(self, "QTEPress")
        self.Owner:LongPressLeave()
    end
end

function M:SetBarPercent(Percent)
    if self.Material then
        self.Material:SetScalarParameterValue("Percent", Percent)
    end
end

function M:OnOut()
    self:StopAllAnimations()
    AudioManager(self):StopSound(self, "QTEShow")
    self:PlayAnimation(self.Out)
end

function M:OnEnd()
    self:UnbindAllFromAnimationFinished(self.Success)
    self:BindToAnimationFinished(self.Success, {self, function()
        AudioManager(self):StopSound(self, "QTEShow")
        self:Close()
    end})
    AudioManager(self):PlayUISound(self, "event:/ui/common/qte_success","",nil)
    self:PlayAnimation(self.Success)
end

function M:InitImage()
    if self.CurInputDeviceType == ECommonInputType.GamePad then
        -- 手柄
        self:InitGamepadView()
    elseif CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        -- 移动
        self:InitMobileView()
    else
        -- PC 键盘
        self:InitKeyBoardView()
    end
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
    self.CurInputDeviceType = CurInputType
    if self.CurInputDeviceType == ECommonInputType.GamePad then
        -- 手柄
        self:InitGamepadView()
    elseif CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        -- 移动
        self:InitMobileView()
    else
        -- PC 键盘
        self:InitKeyBoardView()
    end
    M.Super.RefreshOpInfoByInputDevice(self, CurInputType, CurGamepadName)
end

function M:InitGamepadView()
    self.Key_Handle:CreateCommonKey({
       KeyInfoList={
           {
               Type = "Img",
               ImgShortPath = "Y",
               bLargeSize=true
           }
       }
   })
end

function M:InitKeyBoardView()
    --self.Switch_Type:SetActiveWidgetIndex(0)
    local KeyName = CommonUtils:GetActionMappingKeyName("Interactive", false)
    DebugPrint("zwkkk Key ", KeyName)
    self.Key_Handle:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Text",
                Text = KeyName,
                bLargeSize=true
            }
        }
    })
end

function M:InitMobileView()

end






-- 监听PC/手柄按键
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

-- 手柄按键按下
function M:Handle_OnGamePadDown(InKeyName)
    if (InKeyName == "Gamepad_FaceButton_Top") then
        self:PressedSelectAction()
        return true
    end
    return false
end

-- 监听松开按键
function M:OnKeyUp(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:Handle_OnGamePadUp(InKeyName)
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

-- 手柄按键松开
function M:Handle_OnGamePadUp(InKeyName)
    if (InKeyName == "Gamepad_FaceButton_Top") then
        self:ReleasedSelectAction()
        return true
    end
    return false
end

return M

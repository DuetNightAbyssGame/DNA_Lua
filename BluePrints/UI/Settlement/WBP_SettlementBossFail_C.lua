--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Settlement_BossFail_P_C
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Construct()
    self.Btn_Retry:SetText(GText("UI_MISSION_AGAIN"))
    self.Btn_Retry:BindEventOnClicked(self, self.Retry)
    self.Btn_Retry:SetDefaultGamePadImg("X")
    self.Btn_Exit:SetText(GText("UI_Rouge_ESC_HalfwayOut"))
    self.Btn_Exit:BindEventOnClicked(self, self.Exit)
    self.Btn_Exit:SetDefaultGamePadImg("B")
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
end

function M:OnLoaded(...)
    M.Super.OnLoaded(self, ...)
    self.GuideCombinationId = ...
    self.GuideCombinationInfo = DataMgr.FailureGuidanceCombination[self.GuideCombinationId]

    self.Text01:SetText(GText(self.GuideCombinationInfo.GuidanceTitle1))
    self.Text02:SetText(GText(self.GuideCombinationInfo.GuidanceTitle2))

    self.List_Tips:SetFocus()
    self.List_Tips:ClearListItems()
    local Index = 0
    for _, v in ipairs(self.GuideCombinationInfo.GuidanceModuleId) do
        Index = Index + 1
        local GuidanceInfo = DataMgr.FailureGuidance[v]
        local Content =  NewObject(UIUtils.GetCommonItemContentClass())
        Content.Index = Index
        Content.Title = GuidanceInfo.GuidanceTitle
        Content.Text = GuidanceInfo.GuidanceText
        Content.Icon = LoadObject(GuidanceInfo.GuidanceIcon)
        Content.JumpId = GuidanceInfo.JumpId
        Content.Owner = self
        self.List_Tips:AddItem(Content)
    end


    self:PlayAnimation(self.In)
end

function M:BindEventOnRetry(Obj, Func, ...)
    if not Obj or not Func then
        return
    end
    self.RetryObj = Obj
    self.RetryCallback = Func
    self.RetryParams = { ... }
end

function M:BindEventOnExit(Obj, Func, ...)
    if not Obj or not Func then
        return
    end
    self.ExitObj = Obj
    self.ExitCallback = Func
    self.ExitParams = { ... }
end


function M:Retry()
    if self.RetryObj and self.RetryCallback then
        self.RetryCallback(self.RetryObj, table.unpack(self.RetryParams))
    end
    self:Close()
end

function M:Exit()
    if self.ExitObj and self.ExitCallback then
        self.ExitCallback(self.ExitObj, table.unpack(self.ExitParams))
    end
    self:Close()
end

function M:ReceiveEnterState(StackAction)
    M.Super.ReceiveEnterState(self, StackAction)
    if self.CurTips then
        self.CurTips:SetFocus()
    end
end

-- 监听PC/手柄按键
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
    else
        -- IsEventHandled = self:Handle_OnPCDown(InKeyName) 
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

-- 手柄按键按下
function M:Handle_OnGamePadDown(InKeyName)
    if (InKeyName == "Gamepad_FaceButton_Right") then -- 返回
        self:Exit()
        return true
    elseif (InKeyName == "Gamepad_FaceButton_Left") then  -- X键再次挑战
        self:Retry()
        return true
    elseif (InKeyName == "Gamepad_FaceButton_Top") then  -- Y前往
        local CurTips = self.List_Tips:BP_GetSelectedItem()
        if CurTips and CurTips.SelfWidget then
            CurTips.SelfWidget:OnClicked()
            self.CurTips = CurTips.SelfWidget
        end
        return true
    end
    return false
end


function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName

    self:UpdateOnInputDeviceTypeChange()
end

function M:UpdateOnInputDeviceTypeChange()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        local CurTips = self.List_Tips:GetItemAt(0)
        if CurTips and CurTips.SelfWidget then
            CurTips.SelfWidget:SetFocus()
        end
    end
end

return M

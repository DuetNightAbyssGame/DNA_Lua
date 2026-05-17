--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_TabBtn_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
-- function M:Initialize(Initializer)
-- end

function M:Construct()
    self.Btn_Area.OnClicked:Add(self, self.OnButtonClicked)
    self:BindInputMethodChangedDelegate()
    -- 获取当前InputType
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    -- 获取当前GamepadName
    self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()

    -- 默认隐藏
    self:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
    self.IsGamePadIconVisible = false
end

function M:SetGamePadIconVisible(IsVisible)
    self.IsGamePadIconVisible = IsVisible
    self:RefreshIconAndGamePadVisibility()
end

function M:SetData(Data)
    self.Data = Data
end

-- function M:Tick(MyGeometry, InDeltaTime)
-- end

-- function M:SetData(Params)
--     self.Params = Params
-- end

function M:SetClickCallback(CallbackInfo)
    self.ClickCallbackInfo = CallbackInfo
end

function M:SetText(text)
    self.Text_Btn:SetText(text)
end

function M:SetGamePad(Params)
    self.Key_Gamepad:CreateCommonKey(Params)
end

function M:ShowGamePad()
    self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Visible)
end

function M:HideGamePad()
    self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnButtonClicked()
    if self.ClickCallbackInfo then
        self.ClickCallbackInfo.Func(self.ClickCallbackInfo.Obj)
    end
end

function M:Destruct()
    self.Btn_Area.OnClicked:Remove(self, self.OnButtonClicked)
    self.ClickCallbackInfo = nil
    self:UnBindInputMethodChangedDelegate()
end

-- 绑定输入设备切换的委托
function M:BindInputMethodChangedDelegate()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
    end
end

function M:UnBindInputMethodChangedDelegate()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
    end
end

-- 输入设备切换触发的委托
function M:OnInputMethodChanged(NewGameInputType, NewGamepadName)
    self.CurInputDeviceType = NewGameInputType
    self.CurGamepadName = NewGamepadName
    -- self:SetFocus() -- 重新聚焦游戏场景(注释这行后，使用gm呼唤出引导窗口时游戏窗口的聚焦会丢失，需要选中游戏窗口后才能重新聚焦)
    self:RefreshIconAndGamePadVisibility()
end

-- 根据当前输入设备刷新Icon和GamePad的显示
function M:RefreshIconAndGamePadVisibility()
    if not self.IsGamePadIconVisible then
        self:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        return
    end
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

-- 设置手柄图标显示
function M:SetGamePadVisibility(Op)
    self.Key_GamePad:SetVisibility(Op)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
        return UIUtils.Handled
    end

    return UIUtils.UnHandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
        self:OnButtonClicked()
        return UIUtils.Handled
    end

    return UIUtils.UnHandled
end

function M:OnAddedToFocusPath(InFocusEvent)
    self:SetGamePadIconVisible(false)
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    local OnFocusLeaveCallback = self.Data and self.Data.OnFocusLeaveCallback
    if OnFocusLeaveCallback then
        OnFocusLeaveCallback.Func(OnFocusLeaveCallback.Obj)
    end
end

return M

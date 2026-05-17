--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_TryOut_Victory_C
local M = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

----------------------------------------------------------手柄相关---------------------------------------------------

function M:InitBaseInfo()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    DebugPrint("thy    CurInputDeviceType is", self.CurInputDeviceType)
    --更新UI
    self:UpdateUIVisibility()
end

-- 设置手柄Icon样式
function M:SetGamePadImg(ImgShortPath, ImgLongPath)
    local ImgPath, Img = nil, nil
    if ImgShortPath and ImgShortPath~="None" then
        ImgPath = UIUtils.UtilsGetKeyIconPathInGamepad(ImgShortPath, "XBOX")
        Img = LoadObject(ImgPath)
    elseif ImgLongPath then
        Img = LoadObject(ImgLongPath)
    end
    if (not IsValid(Img)) then
        DebugPrint("缺少图片资源: ImgPath = ", ImgPath, ImgShortPath, ImgLongPath)
        return Img
    end
    --self.Img_GamePad:SetBrushResourceObject(Img)
    return Img
end

function M:UpdateUIVisibility()
    if self.CurInputDeviceType == 1 then
        self.Switcher_Text:SetActiveWidgetIndex(1)
        self.Gamepad_Shortcut01:CreateCommonKey({
                            KeyInfoList = {
                                {
                                    Type = "Img",
                                    ImgShortPath = "B"
                                }
                            },
                            Desc = GText("UI_CharTrial_ClosePop")
                        })
        self.Gamepad_Shortcut02:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Switcher_Text:SetActiveWidgetIndex(0)
        self.Text_Tips:SetText(self.Tips)
    end
end

--手柄监听
function M:Handle_OnGamePadDown(InKeyName)
    DebugPrint("thy    Handle_OnGamePadDown", InKeyName)
    if (InKeyName == "Gamepad_FaceButton_Right") then
        self:Exit()
        return true
    end
    return false
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    DebugPrint("thy   InKeyName ", InKeyName)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        DebugPrint("thy    Key_IsGamepadKey", InKeyName)
        IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

----------------------------------------------------------手柄相关---------------------------------------------------

function M:Exit()
    --self:SetInputUIOnly(false)
    self:Close()
end

function M:InitContent()
    self.Text_Title:SetText(self.Title)
    self.Text_Describe:SetText(self.Describe)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
    self.Btn_FullScreen.OnClicked:Add(self, self.Exit)
    self.Title, self.Describe, self.Tips = ...
    self:InitContent()
    self:InitBaseInfo()
    self:InitListenEvent()
end
    

function M:OnLoaded(...)

end

return M

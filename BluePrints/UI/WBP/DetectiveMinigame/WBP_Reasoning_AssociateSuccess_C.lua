--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Reasoning_AssociateSuccess_C
local M = Class("BluePrints.UI.BP_UIState_C")

function M:OnLoaded(...)
	M.Super:OnLoaded(...)
    self.AnswerId = ...
    self:InitUI()

    self.Btn_Close.OnClicked:Add(self,self.BtnClickClose)
    self:SetFocus()
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
end

function M:InitUI()
    local DetectiveAnswerData = DataMgr["DetectiveAnswer"][self.AnswerId]
    self.Icon_Clue:SetBrushResourceObject(LoadObject(DetectiveAnswerData.Icon))
    self.Text_Name:SetText(GText(DetectiveAnswerData.Name))
    self.Text_Tip:SetText(GText("Minigame_Textmap_100311"))
    self.Key01:CreateCommonKey({
		KeyInfoList = {
			{
				ImgShortPath = "B",
				Type = "Img",
			}
		},
		bLongPress = false,
		Desc = GText("UI_AntiAliasing_Close")
	})
end

function M:BtnClickClose()
    self:Close()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        DebugPrint("thy    已经显示的是该输入模式，不需要进行刷新")
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    self.IsSwitchDevice = true
    --更新UI
    if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
        DebugPrint("thy   IsPC")
        self.WS_Type:SetActiveWidgetIndex(0)
    else
        DebugPrint("thy   IsGamePad")
        self.WS_Type:SetActiveWidgetIndex(1)
        self:SetFocus()
    end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "Gamepad_FaceButton_Right" then -- B键
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
        self:Close()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

return M

require "UnLua"

local M = Class("BluePrints.UI.WBP.Activity.PC.Fool.WBP_Activity_Fool_BattleMain_Base")
local ROTATE_SENSITIVITY  = 0.1
local GAMEPAD_SENSITIVITY = 0.05
local GAMEPAD_VELOCITY = 20
local GAMEPAD_DEAD_ZONE = 5

function M:Construct()
    self.Super.Construct(self)
    self.Handled = UE4.UWidgetBlueprintLibrary.Handled()
    self.Image_ForClick.OnMouseButtonDownEvent:Bind(self, self.ImageClickButtonDown)

    -- 输入设备切换绑
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if (IsValid(self.GameInputModeSubsystem))then
        local CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
        rawset(self,"IsGamepadInput",CurInputDeviceType == ECommonInputType.Gamepad)
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
        self:RefreshOpInfoByInputDevice(CurInputDeviceType, "")
    end
end

function M:Destruct()
    self.Super.Destruct(self)
end

function M:InitTransformButtons()
    self.Battle_Skill_1.Text_Skill:SetText(GText("AFDayEvent_Transform_Random"))  -- 再次随机
    self.Battle_Skill_2.Text_Skill:SetText(GText("AFDayEvent_Transform_Switch"))    -- 切换变身
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    rawset(self,"IsGamepadInput", CurInputDevice == ECommonInputType.Gamepad)
    self.Battle_Skill_1.Common_Key_PC.IsButton = false
    self.Battle_Skill_2.Common_Key_PC.IsButton = false

    if self.IsGamepadInput then  -- 手柄
        -- 相机按钮
        self.Btn_Camera.Common_Key_Hud_Gamepad:CreateCommonKey({
                KeyInfoList={
                    {
                        Type = "Img",
                        ImgShortPath = "RS"
                    }
                },
            })
        self.Btn_Camera.Switcher:SetActiveWidgetIndex(1)
        self.Btn_Camera.Common_Key_Hud_Gamepad:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        -- 再次随机按钮
        self.Battle_Skill_1.Common_Key_PC:CreateGamepadKey("X")
        -- 切换变身按钮
        self.Battle_Skill_2.Common_Key_PC:CreateGamepadKey("Y")
    else  -- PC
        -- 相机按钮
        self.Btn_Camera.Switcher:SetActiveWidgetIndex(0)
        -- 再次随机按钮
        self.Battle_Skill_1.Common_Key_PC:CreateCommonKey({ KeyInfoList={ { Type = "Text", ImgShortPath = "X",} } })
        -- 切换变身按钮
        self.Battle_Skill_2.Common_Key_PC:CreateCommonKey({ KeyInfoList={ { Type = "Text", ImgShortPath = "R",} } })
    end
end

--- Begin 输入处理
-- 按键处理
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == UIConst.GamePadKey.FaceButtonRight then  -- 关闭界面
            self:CloseSelf()
        elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then  -- 再次随机
            self:Randomransform()
        elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then  -- 切换变身
            self:SwitchTransform()
        elseif InKeyName == UIConst.GamePadKey.RightThumb then  -- 打开相机
            self:OpenCamera()
        end
    else
        if InKeyName == "Escape" then   -- 关闭界面
            self:CloseSelf()
        elseif InKeyName == "X" then  -- 再次随机
            self:Randomransform()
        elseif InKeyName == "R" then  -- 切换变身
            self:SwitchTransform()
        end
    end
    return UIUtils.Handled
end

-- 开启镜头移动
function M:ImageClickButtonDown(MyGeometry, MouseEvent)
    self.CanMove = true
    UE4.UWidgetBlueprintLibrary.LockMouse(self.Handled, self)
    UE4.UWidgetBlueprintLibrary.CaptureMouse(self.Handled, self)
    return self.Handled
end

-- 关闭镜头移动
function M:StopCameraMove()
    self.CanMove = false
    UE4.UWidgetBlueprintLibrary.UnlockMouse(self.Handled, self)
    UE4.UWidgetBlueprintLibrary.ReleaseMouseCapture(self.Handled, self)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    self:StopCameraMove()
    return self.Handled
end

function M:OnMouseCaptureLost()
    self:StopCameraMove()
end

-- 拖动鼠标移动镜头
function M:OnMouseMove(MyGeometry, MouseEvent)
    local CursorDelta = UE4.UKismetInputLibrary.PointerEvent_GetCursorDelta(MouseEvent)
    if not self.CanMove then
        return UIUtils.Handled
    end

    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if PlayerCharacter and IsValid(PlayerCharacter) then
        PlayerCharacter:AddCharacterYawInput(CursorDelta.X * ROTATE_SENSITIVITY)
        PlayerCharacter:AddCharacterPitchInput(-CursorDelta.Y * ROTATE_SENSITIVITY)
    end

    return UIUtils.Handled
end

-- 摇杆移动镜头
function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if not (InKeyName == UIConst.GamePadKey.RightAnalogX or InKeyName == UIConst.GamePadKey.RightAnalogY) then
       return UIUtils.Handled
    end

    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local DeltaOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * GAMEPAD_VELOCITY
    if PlayerCharacter and math.abs(DeltaOffset) > GAMEPAD_DEAD_ZONE then
        if InKeyName == UIConst.GamePadKey.RightAnalogX then
            PlayerCharacter:AddCharacterYawInput(DeltaOffset * GAMEPAD_SENSITIVITY)
        else
            PlayerCharacter:AddCharacterPitchInput(DeltaOffset * GAMEPAD_SENSITIVITY)
        end
    end
    return UIUtils.Handled
end

--- End 输入处理

return M
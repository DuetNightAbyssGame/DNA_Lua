--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_BattlePass_BtnBuy_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

--function M:Construct()
--end

function M:InitBtnInfo(State, Label, Callback, KeyShortPath, bLongPress)
    DebugPrint("gmy@WBP_BattlePass_BtnBuy_C M:InitBtnInfo", State, Label, Callback, KeyShortPath, os.time())
    self.KeyShortPath = KeyShortPath
    self.State = State
    self.bLongPress = bLongPress
    self.Text_Button:SetText(GText(Label))
    self:InitInputSettings()

    
    self.Button_Area.OnPressed:Clear()
    self.Button_Area.OnReleased:Clear()
    self.Button_Area.OnHovered:Clear()
    self.Button_Area.OnUnhovered:Clear()
    self.Button_Area.OnClicked:Clear()
    if State == "Forbidden" then
        self.Button_Area:SetForbidden(true)
        self:PlayAnimation(self.Forbidden)
    elseif State == "UnlockForbidden" then
        self.Button_Area:SetForbidden(true)
        self:PlayAnimation(self.UnlockForbidden)
    else
        self.Button_Area:SetForbidden(false)
        self:PlayAnimation(self.Normal)
        self.Button_Area.OnClicked:Add(self, Callback)
    end

    if State ~= "Forbidden" and State ~= "UnlockForbidden" then
        self.Button_Area.OnHovered:Add(self, function()
            self:PlayAnimation(self.Hover)
        end)
        self.Button_Area.OnUnhovered:Add(self, function()
            self:PlayAnimation(self.UnHover)
        end)
        self.Button_Area.OnPressed:Add(self, function()
            self:PlayAnimation(self.Press)
        end)
    end
    
end

function M:InitInputSettings()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)

    DebugPrint("gmy@WBP_BattlePass_BtnBuy_C M:InitInputSettings", self.KeyShortPath)
    self.Key_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = self.KeyShortPath,
            },
        },
        bLongPress = self.bLongPress,
    })

    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end


function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    DebugPrint("gmy@WBP_BattlePass_BtnBuy_C M:RefreshOpInfoByInputDevice", CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    
    --更新UI
    local bIsForbidden = self.State == "Forbidden"
    if bIsForbidden or self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
        self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    elseif self.CurInputDeviceType == ECommonInputType.Gamepad then
        self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Visible)
    elseif self.CurInputDeviceType == ECommonInputType.Touch then
        self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        -- 
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self.Button_Area.OnClicked:Clear()
end
return M

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_DayAndNight_P_C
local M = Class("BluePrints.UI.BP_UIState_C")
M._components = {"BluePrints.UI.WBP.DayAndNight.DayAndNightPageBaseView"}
local Unhandled=UE4.UWidgetBlueprintLibrary.Handled()
---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self:InitTab()
    self.AnalogControlSpeed=20
    self.AnalogControlProgress=0
end
function M:InitTab()
    local TabInfo = {
        Tabs = self.AllTabInfo,
        DynamicNode = {"Back", "Tip", "BottomKey"},
        BottomKeyInfo = {{
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "LV",
                Owner = self
            }},
            Desc = GText("UI_CTL_Adjust")
        },
        {
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "LH",
                Owner = self
            }},
            Desc = GText("UI_SWITCH")
        },  {
            KeyInfoList = {{
                Type = "Text",
                Text = "Esc",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "B",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            Desc = GText("UI_BACK")

        }},
        StyleName = "Text",
        OwnerPanel = self,
        TitleName = GText("UI_SetTime_Title"),
        BackCallback = self.OnReturnKeyDown
    }

    self.Tab:Init(TabInfo)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    DebugPrint("DayAndNightPage Received OnKeyDown" .. InKeyName)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        self.IsGamePad = true
        IsEventHandled = self:OnGamePadDown(InKeyName)
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        self.IsGamePad = false
        if (InKeyName == "Escape") then
            self:OnReturnKeyDown()
            IsEventHandled = true
        end
    end
    return UE4.UWidgetBlueprintLibrary.Handled()

end
function M:Close()
    M.Super.Close(self)
end

-- 手柄相关逻辑
function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    DebugPrint("OnGamePadDown" .. InKeyName)
    if (InKeyName == UIConst.GamePadKey.FaceButtonRight) then
        self:OnReturnKeyDown()
        IsEventHandled = true
    elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
        self:OnClickChangeTime()
    end

    return IsEventHandled
end
function M:OnAnalogAccumulate(Delta)
    self.AnalogControlProgress=self.AnalogControlProgress+Delta
    if  self.AnalogControlProgress<-100 then
        self.AnalogControlProgress=100+self.AnalogControlProgress
        if UIUtils.HasAnyFocus(self.Slider_Day) then
            self:OnScrollDay(self.DayUIWheelSpeed)
        else
            self:OnScrollHour(self.HourUIWheelSpeed)
        end
    elseif  self.AnalogControlProgress>100 then
        self.AnalogControlProgress=-100+self.AnalogControlProgress
        if UIUtils.HasAnyFocus(self.Slider_Day) then
            self:OnScrollDay(-self.DayUIWheelSpeed)
        else
            self:OnScrollHour(-self.HourUIWheelSpeed)
        end
    end
end
function M:ClearnAnalogAccumulate()
    self.AnalogControlProgress=0
end
--处理摇杆输入
function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == UIConst.GamePadKey.LeftAnalogY) then
        local DeltaOffset =UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
        --ScreenPrint("手柄=滚动中DeltaOffset:" .. DeltaOffset)
        self:OnAnalogAccumulate(DeltaOffset * self.AnalogControlSpeed)
    elseif (InKeyName == UIConst.GamePadKey.LeftAnalogX) then
        local DeltaOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
        if DeltaOffset <= -1 then
            self:ClearnAnalogAccumulate()
            self:GamepadFocusLeft()
        elseif DeltaOffset >= 1 then
            self:ClearnAnalogAccumulate()
            self:GamepadFocusRight()
        end
    end
    return Unhandled
end
function  M:GamepadFocusLeft()
    if UIUtils.HasAnyFocus(self.Slider_Day) then
        return
    end
    self.Slider_Day:SetFocus()
    self.Btn_KeyDay:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Btn_KeyTime:SetVisibility(UIConst.VisibilityOp.Collapsed)
end
function  M:GamepadFocusRight()
    if UIUtils.HasAnyFocus(self.Slider_Time) then
        return
    end
    self.Slider_Time:SetFocus()
    self.Btn_KeyDay:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_KeyTime:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end
--输入设备变更通知，子类可以重写该方法
---@param CurInputDevice number 枚举ECommonInputType
---@param CurGamepadName string 手柄的名称
function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.CurInputDevice = CurInputDevice
    self:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
end
function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
        if (CurInputDevice == ECommonInputType.Gamepad) then
        self:InitGamepadView()
    elseif (CurInputDevice == ECommonInputType.MouseAndKeyboard) then
        self:InitKeyboardView()
    end
end
function M:InitKeyboardView()
    self.Btn_KeyDay:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_KeyTime:SetVisibility(UIConst.VisibilityOp.Collapsed)
end
function M:InitGamepadView()
    self:SetFocus_Lua()
end
function M:SetFocus_Lua()
    self.Slider_Day:SetFocus()
    self.Btn_KeyDay:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Btn_KeyTime:SetVisibility(UIConst.VisibilityOp.Collapsed)
end
--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end
AssembleComponents(M)

return M

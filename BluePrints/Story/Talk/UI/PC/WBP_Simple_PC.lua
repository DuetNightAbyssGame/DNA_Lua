--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@class WBP_Simple_PC : BP_TalkBaseUINew_C
local WBP_Simple_PC = Class("BluePrints.Story.Talk.UI.Common.WBP_Simple_Common")

function WBP_Simple_PC:OnLoaded(...)
    WBP_Simple_PC.Super.OnLoaded(self, ...)
    self:RefreshBaseInfo()
end

function WBP_Simple_PC:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    DebugPrint("WBP_Simple_PC:RefreshOpInfoByInputDevice", CurInputDevice, CurGamepadName)
    local IsGamePad = CurInputDevice == ECommonInputType.Gamepad
    self.IsGamePad = IsGamePad
    if self.DialogueButtonListView then
        self.DialogueButtonListView:UpdateKeyImg(IsGamePad, CurGamepadName)
    end
    if (IsGamePad) then
        self:SetFocus()
    else
        --do nothing
    end
    self.WBP_Story_PlayKey_P:UpdateKeyImg(IsGamePad)
end

function WBP_Simple_PC:ClearOptions()
    WBP_Simple_PC.Super.ClearOptions(self)
    self:RefreshBaseInfo()
end

function WBP_Simple_PC:ShowOptions(TalkTask, OptionTexts, OptionData, OnOptionItemClicked)
    WBP_Simple_PC.Super.ShowOptions(self, TalkTask, OptionTexts, OptionData, OnOptionItemClicked)
    self:RefreshBaseInfo()
end

function WBP_Simple_PC:InitPlayKey()
    self.WBP_Story_PlayKey_P:Init(self.IsGamePad)
end

function WBP_Simple_PC:InitAutoPlay()
end

--监听左摇杆的轴体偏移
function WBP_Simple_PC:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    if not self.DialogueButtonListView then
        return UIUtils.Unhandled
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if(InKeyName == "Gamepad_LeftX")then
        self.MoveDeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    elseif(InKeyName == "Gamepad_LeftY")then
        self.MoveDeltaY = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    end
    local InKeyName = nil
    if self.MoveDeltaY and self.MoveDeltaY ~= 0 then
        if self.MoveDeltaY > 0.5 then
            InKeyName = "Gamepad_LeftStick_Up"
        elseif self.MoveDeltaY < -0.5 then
            InKeyName = "Gamepad_LeftStick_Down"
        end
    end
    if InKeyName == "Gamepad_LeftStick_Up" then --左摇杆上方向键
        if self.CdTimer then
            return UIUtils.Unhandled
        else
            self:CreateCDTimer()
        end
        self.DialogueButtonListView:UpSelectAction()
    elseif InKeyName == "Gamepad_LeftStick_Down" then --左摇杆下方向键
        if self.CdTimer then
            return UIUtils.Unhandled
        else
            self:CreateCDTimer()
        end
        self.DialogueButtonListView:DownSelectAction()
    end
    return UIUtils.Handled
end

function WBP_Simple_PC:PreExitTalkTask(TalkTask, TalkData, OnPreExitTalkTaskFinished)
    WBP_Simple_PC.Super.PreExitTalkTask(self, TalkTask, TalkData, OnPreExitTalkTaskFinished)
    self.WBP_Story_PlayKey_P:StopAllAnimations()
end

function WBP_Simple_PC:CreateCDTimer()
    self.CdTimer = self:AddTimer(0.2, function()
        self.CdTimer = nil
    end, nil, nil, nil, true)
end

function WBP_Simple_PC:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    if not self.DialogueButtonListView then
        return UIUtils.Unhandled
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local Handled = true
    if InKeyName == "Gamepad_DPad_Up" then --左边上方向键
        self.DialogueButtonListView:UpSelectAction()
    elseif InKeyName == "Gamepad_DPad_Down" then --左边下方向键
        self.DialogueButtonListView:DownSelectAction()
    end
    return UIUtils.Unhandled
end

return WBP_Simple_PC
--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_Dialog_CombatData_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"})

--function M:Initialize(Initializer)
--end

function M:OnLoaded(...)
    M.Super.OnLoaded(self, ...)
    self.NavigateWidget:SetVisibility(ESlateVisibility.Collapsed)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Gamepad_RightY") then
        local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 30
        local CurScrollOffset = self.EMScrollBox_31:GetScrollOffset()
        local ScrollOffset = math.clamp(CurScrollOffset - a,0, self.EMScrollBox_31:GetScrollOffsetOfEnd())
        self.EMScrollBox_31:SetScrollOffset(ScrollOffset)
    end
    return UWidgetBlueprintLibrary.Unhandled()
end

return M

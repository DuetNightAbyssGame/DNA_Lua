--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_CameraGame_M_C
local M = Class({"BluePrints.UI.WBP.Activity.PC.CameraGame.WBP_Activity_CameraGame_Base_C"})

function M:Initialize(Initializer)
    rawset(self, "TabConfigData", {
        DynamicNode = {"Back", "Tip", "BottomKey"},
        TitleName = GText("Event_Title_103017"),
        StyleName = "TextImage",
        OwnerPanel = self,
        BackCallback = self.CloseSelf,
    })
end

function M:Construct()
    self.Super.Construct(self)
end

function M:Destruct()
    self.Super:Destruct(self)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Escape" or InKeyName == "Gamepad_FaceButton_Right") then
        self:CloseSelf()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

return M

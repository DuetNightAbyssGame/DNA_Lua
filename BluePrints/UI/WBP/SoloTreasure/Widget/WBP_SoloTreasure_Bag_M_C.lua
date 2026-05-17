require "UnLua"
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")

--- @type WBP_SoloTreasure_Bag_M_C
local M = Class("BluePrints.UI.WBP.SoloTreasure.Widget.WBP_SoloTreasure_Bag")

function M:Construct()
    self.Super.Construct(self)
end


function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
end

----------------------- 输入相关 -----------------------------

function M:OnTouchMoved(MyGeometry, InTouchEvent)
    if not self.InventoryController or not self.InventoryController.bInit or not self.InventoryController.bDraging then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    local ScreenSpacePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InTouchEvent)
    self.CurTouchPos = ScreenSpacePosition
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
    self.CurTouchPos = nil
    if self.InventoryController.DragWidget and self.InventoryController.bDraging then
        if self.Btn_Recycle and self.Btn_Recycle.CurState == InventoryCommonConst.RecycleBtnState.DragingOver then
            return
        end
        self.InventoryController:CustomOnDragCancelled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

return M

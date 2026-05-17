--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_Dye_M_C|WBP_Armory_Dye_Base_C
local M = Class("BluePrints.UI.WBP.Armory.WBP_Armory_Dye_Base_C")

--function M:Initialize(Initializer)
--end

function M:Construct()
    self.TabConfig = {
        TitleName= GText("UI_Dye_Name"),
        DynamicNode={
            "Back",
            "ResourceBar",
            "BottomKey",
        },
        BottomKeyInfo = {},
        OverridenTopResouces = {DataMgr.GlobalConstant.AdvanceColorId.ConstantValue},
        StyleName = "Armory",
        BackCallback = self.OnBackKeyDown,
        OwnerPanel = self,
        OnResourceBarAddedToFocusPath = self.OnResourceBarAddedToFocusPath,
        OnResourceBarRemovedFromFocusPath = self.OnResourceBarRemovedFromFocusPath,
    }
    M.Super.Construct(self)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M

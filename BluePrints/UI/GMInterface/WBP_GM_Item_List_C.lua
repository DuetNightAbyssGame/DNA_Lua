--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local WBP_GM_Item_List_C = Class("BluePrints.UI.GMInterface.WBP_GM_Item_Base_C")

function WBP_GM_Item_List_C:SetItem()
    self.Super.SetItem(self)
end

function WBP_GM_Item_List_C:Exec(...)
    self.Super.Exec(self,...)
end

--在lua拦截蓝图的按压事件，不然PC包会卡死
function WBP_GM_Item_List_C:BndEvt__GM_Item_List_Button_Exec_K2Node_ComponentBoundEvent_2_OnButtonPressedEvent__DelegateSignature()
    self.Super.Exec(self)
end

return WBP_GM_Item_List_C

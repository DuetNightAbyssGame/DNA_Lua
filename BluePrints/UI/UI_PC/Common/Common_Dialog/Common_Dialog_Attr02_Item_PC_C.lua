--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Common_Dialog_Attr02_Item_PC_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

function M:OnListItemObjectSet(Obj)
    self.Content = Obj
    self.Text_Attribute:SetText(Obj.AttrName)
    self.Text_Num:SetText(Obj.AttrValue)
    if(Obj.Idx % 2 == 1)then
        self.Bg01:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Bg01:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

return M

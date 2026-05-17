--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Shop_Item_Attribute_PC_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

function M:UpdateAttr(AttrInfo1, AttrInfo2)
    if AttrInfo1 then
        self.Text_Attribute01:SetText(GText(AttrInfo1.Config.Name))
        self.Text_Num01:SetText(AttrInfo1.Value)
    end
    if AttrInfo2 then
        self.Text_Attribute02:SetText(GText(AttrInfo2.Config.Name))
        self.Text_Num02:SetText(AttrInfo2.Value)
        self.Attribute02:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Attribute02:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

return M

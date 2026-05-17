--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Shop_ItemStar_PC_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:SetLight(bLight)
    self.Img_StarLight:SetVisibility(bLight and UIConst.VisibilityOp["SelfHitTestInvisible"] or UIConst.VisibilityOp["Collapsed"])
    self.Img_StarUnLight:SetVisibility(bLight and UIConst.VisibilityOp["Collapsed"] or UIConst.VisibilityOp["SelfHitTestInvisible"])
end

return M

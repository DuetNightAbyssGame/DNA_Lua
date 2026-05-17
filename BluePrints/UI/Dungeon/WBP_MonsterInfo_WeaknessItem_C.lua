require "UnLua"

---@type MonsterInfo_Weakness_Icon_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:OnListItemObjectSet(Obj)
    local IconObj = LoadObject(string.format("Texture2D'%s'", Obj.WeaknessIcon))
    self.Img_Level:SetBrushFromTexture(IconObj)
    Obj.ViewWidget = self
end

return M

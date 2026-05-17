--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_Dye_ColorLump_Sp_C
local M = Class({"BluePrints.UI.WBP.Armory.Widget.Dye.WBP_Armory_Dye_ColorLump_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:SetColor(Content)
    local Data = DataMgr.SpecialSwatch[Content.ColorId]
    if(Data)then
        self.Color_Lump_Sp:SetBrushResourceObject(LoadObject(Data.MaterialPath))
    else
        self.Color_Lump_Sp:SetBrushResourceObject(LoadObject('/Game/UI/Texture/Dynamic/Atlas/Armory/Btn_Mosaic.Btn_Mosaic'))
    end
end

return M

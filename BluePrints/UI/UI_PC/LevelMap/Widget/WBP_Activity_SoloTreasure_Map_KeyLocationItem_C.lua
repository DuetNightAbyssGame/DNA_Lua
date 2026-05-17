--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_SoloTreasure_Map_KeyLocationItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnListItemObjectSet(Content)
    if Content.Data then
        if Content.Data.SoloTreasureIconType then
            self.Icon_Location:SetBrushFromTexture(LoadObject(Content.Data.SoloTreasureIconType))
        end
        self.Text_Name:SetText(GText(Content.Data.SoloTreasureIconText))
    end
end


return M

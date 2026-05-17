--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Rouge_GameCurrency_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

--function M:Construct()
--end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:InitInfo(ImgPath,Num)
    local Img = LoadObject(ImgPath)
    self.Img_Currency:SetBrushResourceObject(Img)
    self.Text_Num:SetText(Num)
end

return M

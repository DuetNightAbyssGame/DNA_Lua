--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Map_Select_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
function M:Initialize(Initializer)
    self.IsPlay = true
end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnAnimationStarted(Animation)
    if Animation == self.Click and self.IsPlay then
        AudioManager(self):PlayUISound(self, "event:/ui/common/map_click_gold_mark", "", nil) 
    end
    self.IsPlay = true
end


return M

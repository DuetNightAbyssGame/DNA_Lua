--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_FeinaEvent_HudButton_M_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Btn_Click.OnReleased:Add(self, self.OnReleased)
    self.Btn_Click.OnPressed:Add(self, self.OnPressed)
end

function M:OnPressed()
    self:PlayAnimation(self.Press)
end

function M:OnReleased()
    self:PlayAnimation(self.Click)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M

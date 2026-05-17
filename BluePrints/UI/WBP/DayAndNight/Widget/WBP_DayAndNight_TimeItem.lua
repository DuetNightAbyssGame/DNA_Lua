--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_DayAndNight_TimeItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Init(Index,Hour,bInDay)
    self.Index = Index
    self.Night = bInDay
    self.Text_Before:SetText(Hour..":00")
    self.Text_Now:SetText(Hour..":00")
    self.Text_After:SetText(Hour..":00")
    self:SetDayAndNight(bInDay)
end
---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M

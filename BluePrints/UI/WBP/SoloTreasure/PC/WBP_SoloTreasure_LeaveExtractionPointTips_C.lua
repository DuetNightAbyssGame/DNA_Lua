--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SoloTreasure_HudTips05_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
    self.Text_Task02:SetText(GText("UI_Extraction_TM_24"))
    self:UnbindAllFromAnimationFinished(self.In)
    self:BindToAnimationFinished(self.In, {self, function()
        self:AddTimer(0.5, function()
            self:Close()
        end, false, 0, "LeaveExtractionPointTips", true)
    end})
end

function M:OnLoaded(...)
    self:InitUI()
    self:PlayAnimation(self.In)
end

function M:InitUI()

end

function M:CloseUI()
    self:RemoveTimer("LeaveExtractionPointTips")
    self:Close()
end

return M

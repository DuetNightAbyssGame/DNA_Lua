--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SoloTreasure_HudTips04_C
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

function M:OnLoaded(...)
    self:InitUI()
end

function M:InitUI()
    self:InitData()
    self:PlayAnimation(self.In)
end

function M:InitData()
    self.EvacuationTime = DataMgr.SoloTreasure.EvacuationTime or 10
    self.Text_Task:SetText(self.EvacuationTime)
    self.Text_Task02:SetText(GText("UI_Extraction_TM_23"))
end

function M:SetCountDownTime(Time, IsPlayAnimation)
    self.Text_Task:SetText(Time)
    self.PreNum = self.PreNum or self.EvacuationTime
    if IsPlayAnimation and (not self:IsPlayingAnimation(self.Num_Refresh)) and self.PreNum ~= Time then
        self.PreNum = Time
        self:PlayAnimation(self.Num_Refresh)
    end
end

function M:CloseUI()
    --self:PlayAnimation(self.Out)
    self:RemoveTimer("EvacuationTime")
    self:Close()
end

return M

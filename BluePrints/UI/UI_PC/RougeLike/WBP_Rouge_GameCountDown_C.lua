--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Rouge_GameCountDown_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:InitRougeGameCountDown()
    self.CurScore = 0
    self.Text_ScoreTitle:SetText(GText("RougeMiniGamePoints"))
    self.Text_ScoreNum:SetText(0)
end

function M:AddScore(TotalScore, Score)
    if Score > 0 then
        self.Text_ScoreNum:SetText(TotalScore)
        self.Text_ScoreNumChange:SetText("+" .. Score)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Point_Add)
    end
end

function M:RefreshTime(Time)
    if Time >= 0 then
        local TimeStr = self:GetTimeStr(math.floor(Time))
        self.TextBlock_LeftTime:SetText(TimeStr)
    end
end

return M

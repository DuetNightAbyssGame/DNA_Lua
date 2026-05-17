--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Dungeon_TempleItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:SetTargetInfo(Text)
    self.Text_ScoreDesc:SetText(Text)
end

function M:PlayStarAnimation(IsHardMode)
    if IsHardMode then
        self:PlayAnimation(self.Gain_1)
    else
        self:PlayAnimation(self.Gain)
    end
end

function M:PlayNormalAnimation()
    self:PlayAnimation(self.Normal)
end

function M:PlayLossAnimation(IsHardMode)
    if IsHardMode then
        self:PlayAnimation(self.Loss_1)
    else
        self:PlayAnimation(self.Loss)
    end
end

function M:PlayFullAnimation()
    self:PlayAnimation(self.Full)
end

function M:ShowStarLight()
    self.StarSlot:GetChildAt(0).WS_Type:SetActiveWidgetIndex(1)
end

function M:ShowStarGrey()
    self.StarSlot:GetChildAt(0).WS_Type:SetActiveWidgetIndex(0)
end

return M

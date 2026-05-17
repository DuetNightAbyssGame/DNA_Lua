--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Team_PlayerBubble_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Init(PlayerLevel, PlayerName, bVoteContinue)
    self.Text_Level:SetText(PlayerLevel)
    self.Text_Name:SetText(PlayerName)
    if bVoteContinue then
        self:PlayAnimation(self.Bubble_Right_In)
    elseif bVoteContinue == nil then
        self:PlayAnimation(self.Bubble_Middle_In)
    else
        self:PlayAnimation(self.Bubble_Left_In)
    end
end

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M

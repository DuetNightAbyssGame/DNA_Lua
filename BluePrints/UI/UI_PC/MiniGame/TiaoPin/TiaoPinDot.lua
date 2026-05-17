--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_MiniGame_Tiaopin_Dot_C
local WBP_MiniGame_Tiaopin_Dot_C = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function WBP_MiniGame_Tiaopin_Dot_C:OnListItemObjectSet(TiaoPinDot)
    self.Owner = TiaoPinDot.Owner 
    self.Index = TiaoPinDot.Index

    self.Owner:AddItemInTiaoPinList(self.Index, self)
end

function WBP_MiniGame_Tiaopin_Dot_C:OpenLoopState()
    self:PlayAnimation(self.Loop)
end

function WBP_MiniGame_Tiaopin_Dot_C:StopLoopState()
    self.VX_Loop:SetVisibility(ESlateVisibility.Collapsed)
end

return WBP_MiniGame_Tiaopin_Dot_C

---@type WBP_Battle_ReadIcon_C
local M = Class({ "BluePrints.UI.BP_UIState_C" })

function M:Construct()
end

function M:Destruct()
end

function M:SetAccessibility(bNewAccessed)
    self:StopAllAnimations()
    if (bNewAccessed) then
        self:PlayAnimation(self.After_Reading_In)
        self:PlayAnimation(self.After_Reading)
    else
        self:PlayAnimation(self.Halo_in)
        self:PlayAnimation(self.Halo_loop, 0, 0)
    end
end

return M

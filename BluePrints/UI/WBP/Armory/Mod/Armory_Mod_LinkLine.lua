--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_Mod_Effect_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})


function M:Init(bGolden)
    local VPScale = UWidgetLayoutLibrary.GetViewportScale(self)
    local MainSlot = self.Main.Slot
    self.MinDis = math.abs(MainSlot:GetSize().X*VPScale*2)
    DebugPrint(LXYTag, "linkline, ",self.MinDis)
    self:SetGolden(bGolden)
    self:SetRenderOpacity(0)
end

function M:SetPosture(Dist, Angle)
    self:SetRenderTransformAngle(Angle-3)
    if Dist <= self.MinDis and self.RenderOpacity == 1 then
        self:SetRenderOpacity(0)
    elseif Dist > self.MinDis and self.RenderOpacity == 0 then
        self:SetRenderOpacity(1)
    end
end

function M:SetGolden(bGolden)
    if bGolden then
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Golden)
    else
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Gray)
    end
end

return M

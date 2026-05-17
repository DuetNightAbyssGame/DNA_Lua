require "UnLua"

---@type Common_Item_SubSize_XSmall_PC_C
local M = Class("BluePrints.UI.UI_PC.Common.Common_Item_Subsize_Small_Base_C")

--- 播放In动画
function M:PlayInAnimation()
    if self.Rarity then
        if self.Rarity == 1 then
            self:PlayAnimation(self.Reward_In_White)
        elseif self.Rarity == 2 then
            self:PlayAnimation(self.Reward_In_Green)
        elseif self.Rarity == 3 then
            self:PlayAnimation(self.Reward_In_Blue)
        elseif self.Rarity == 4 then
            self:PlayAnimation(self.Reward_In_Purple)
        elseif self.Rarity == 5 then
            self:PlayAnimation(self.Reward_In_Orange)
        else
            DebugPrint("ZDX_道具框的稀有度不符合要求")
            return
        end
    end
end

function M:IsInAnimationPlaying()
    if self:IsAnimationPlaying(self.Reward_In_Orange) or
    self:IsAnimationPlaying(self.Reward_In_Purple) or
    self:IsAnimationPlaying(self.Reward_In_Blue) or
    self:IsAnimationPlaying(self.Reward_In_Green) or
    self:IsAnimationPlaying(self.Reward_In_White) then
        return true
    end
    return false
end

return M

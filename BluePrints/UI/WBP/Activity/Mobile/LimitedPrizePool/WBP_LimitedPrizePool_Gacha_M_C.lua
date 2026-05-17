---@type WBP_LimitedPrizePool_Gacha_M_C
local M = Class({ "BluePrints.UI.WBP.Activity.Widget.LimitedPrizePool.WBP_LimitedPrizePool_Gacha_Base_C" })

function M:Init(RewardPool, WonIndex, bIsBigPrize, AcquiredList, DrawCount, ConvertFlags, InCallback)
    M.Super.Init(self, RewardPool, WonIndex, bIsBigPrize, AcquiredList, DrawCount, ConvertFlags, InCallback)
end

return M

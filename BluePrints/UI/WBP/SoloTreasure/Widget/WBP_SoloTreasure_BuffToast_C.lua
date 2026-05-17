--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SoloTreasure_ChoiceBuffTip_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
    self.LotteryId = ...
    local LotteryData = DataMgr.ExtractionLottery[self.LotteryId]
    if not LotteryData then
        DebugPrint("@zyh 没有该Id的彩票" .. self.LotteryId)
    end
    DebugPrint("彩票的品质为".. LotteryData.Quality)
    self.ChoiceBuff:SetBuffQuality(LotteryData.Quality - 1)
    self:SetTipQuality(LotteryData.Quality - 1)
    self.Text_GetBuff:SetText(GText("UI_WhenGetLottery"))
    self:BindToAnimationFinished(self.Auto_In, {self, self.Close})
end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M

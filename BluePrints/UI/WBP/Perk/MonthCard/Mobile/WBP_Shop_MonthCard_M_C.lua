--
-- DESCRIPTION
-- 月卡界面 Mobile
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local MonthCardModel = require "BluePrints.UI.WBP.Perk.MonthCard.MonthCardModel"
local MonthCardCommon = require "BluePrints.UI.WBP.Perk.MonthCard.MonthCardCommon"

local M = Class({
    -- "BluePrints.Common.TimerMgr",
    "BluePrints.UI.WBP.Perk.MonthCard.View.MonthCardBaseView"
})

-- M._components = {
--     "BluePrints.UI.WBP.Perk.MonthCard.View.MonthCardBaseView",
-- }

-- 界面初始化逻辑
function M:Construct()
    --self.Super.Construct(self)
    self:InitBaseView()
end

-- 外部刷新界面的接口
function M:InitBannerPage(BannerId)
    self.BannerId = BannerId
    self:StopAllAnimations()
    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/ui/common/shop_gift_pack_page_in", nil, nil)
    self:RefreshPageView()
end

function M:Close()
    self:PlayAnimation(self.Out)
    M.Super.Close(self)
    self:OnViewClose()
end

-- function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
--     M.Super.RefreshOpInfoByInputDevice(self, CurInputType, CurGamepadName)
--     self:UpdateFocus()
-- end

-- function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
--     M.Super.OnUpdateUIStyleByInputTypeChange(self, CurInputType, CurGamepadName)
--     self:UpdateGamePadIcon(CurInputType)
-- end

-- AssembleComponents(M)
return M

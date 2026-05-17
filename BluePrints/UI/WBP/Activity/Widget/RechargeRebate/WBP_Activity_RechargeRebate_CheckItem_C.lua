--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_RechargeRebate_CheckItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

-- Level 1 2 3
-- ChargeFund 充值总额
function M:InitCheckItem(Level, ChargeFund)
    self.Level = Level
    self.ChargeFund = ChargeFund
    self["InitNumInfo"..Level](self)
end

function M:InitNumInfo1()
    self.WS:SetActiveWidgetIndex(0)
    local StageMaxFund = self:GetStateMaxFundByLevel()
    self.Text_ValueNum:SetText(StageMaxFund)
    if self.ChargeFund>StageMaxFund then
        self:PlayAnimation(self.Finish)
    else
        self:PlayAnimation(self.Normal)
    end
end

function M:InitNumInfo2()
    self.WS:SetActiveWidgetIndex(0)
    local StageMaxFund = self:GetStateMaxFundByLevel()
    self.Text_ValueNum:SetText(StageMaxFund)
    if self.ChargeFund>StageMaxFund then
        self:PlayAnimation(self.Finish)
    else
        self:PlayAnimation(self.Normal)
    end
end

function M:InitNumInfo3()
    self.WS:SetActiveWidgetIndex(1)
    self:PlayAnimation(self.Normal)
end

function M:GetStateMaxFundByLevel()
    if self.Level==1 then
        return DataMgr.FeeRefund[1].PayLevel2
    elseif self.Level==2 then
        return DataMgr.FeeRefund[1].PayLevel3
    elseif self.Level==3 then
        return DataMgr.FeeRefund[1].ProgressMax
    end
    return -1
end

return M

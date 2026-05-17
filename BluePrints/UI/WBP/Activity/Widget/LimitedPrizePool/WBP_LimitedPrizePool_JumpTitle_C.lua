local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

---@type WBP_LimitedPrizePool_JumpTitle_C
local M = Class({ "BluePrints.UI.BP_EMUserWidget_C" })

function M:Construct()
    self.Title = self.Text_Title
    self.Time = self.Activity_Time.Com_Time
    self.DescSwitcher = self.WS_TextDesc
    self.BlackDesc = self.Text_ActivityDesc
    self.WhiteDesc = self.Text_ActivityDesc_White

    self.bTimeOut = false
end

function M:Destruct()
end

function M:SetTitle(Text)
    self.Title:SetText(Text)
end

function M:SetTime(Time)
    local TimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(Time)

    self.bTimeOut = TimeCount == 0 and Time
    if Time then
        self.HB_Time:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        ActivityUtils.SetLeftTimeView(self.Time, false, self.bTimeOut, TimeDict, self.bTimeOut)
    else
        self.HB_Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:SetDesc(Text, bBlack)
    bBlack = bBlack or false

    if (bBlack) then
        self.DescSwitcher:SetActiveWidgetIndex(0)
        self.BlackDesc:SetText(Text)
    else
        self.DescSwitcher:SetActiveWidgetIndex(1)
        self.WhiteDesc:SetText(Text)
    end
end

function M:IsTimeOut()
    return self.bTimeOut
end

return M

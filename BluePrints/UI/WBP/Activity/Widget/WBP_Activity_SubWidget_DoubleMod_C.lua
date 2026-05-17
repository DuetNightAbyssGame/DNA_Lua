--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_DoubleMod_Content_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:Init(ActivityConfigData, PageConfigData, PlayerAvatar)
    self.EventId = ActivityConfigData.EventId
    self:UpdatePage()
end

function M:UpdatePage()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local Rate = math.floor((DataMgr.ModDropConstant.EventBonus.ConstantValue or 0) / 100)
    local DropTotalTimes = DataMgr.ModDropConstant.DailyModDungeonAmount.ConstantValue or 0
    local EliteRushTotalTimes = DataMgr.ModDropConstant.DailyFreeTicketAmount.ConstantValue or 0
    local RemainDropTimes = DropTotalTimes - (Avatar.DoubleModDrop[self.EventId] and Avatar.DoubleModDrop[self.EventId].DropTimes or 0)
    local RemainEliteRushTimes = EliteRushTotalTimes - (Avatar.DoubleModDrop[self.EventId] and Avatar.DoubleModDrop[self.EventId].EliteRushTimes or 0)
    local Text_DoubleModDrop = nil
    local Text_EliteRush = nil
    if RemainDropTimes == 0 then
        Text_DoubleModDrop = (GText("UI_Event_ModDrop_DropRemain").."<Warning>"..RemainDropTimes.."</>".."/"..DropTotalTimes)
    else
        Text_DoubleModDrop = (GText("UI_Event_ModDrop_DropRemain")..RemainDropTimes.."/"..DropTotalTimes)
    end
    if RemainEliteRushTimes == 0 then
        Text_EliteRush = (GText("UI_Event_ModDrop_ChallengeRemain").."<Warning>"..RemainEliteRushTimes.."</>".."/"..EliteRushTotalTimes)
    else
        Text_EliteRush = (GText("UI_Event_ModDrop_ChallengeRemain")..RemainEliteRushTimes.."/"..EliteRushTotalTimes)
    end
    self.Text_ModUpTitle:SetText(GText("UI_Event_ModDrop_Title2_1"))
    self.Text_NewModView:SetText(GText("UI_Event_ModDrop_Title2_2"))
    self.Text_DoubleModTitle:SetText(GText("UI_Event_ModDrop_ChallengeName"))
    self.Text_ModUpTodayTimes:SetText(Text_DoubleModDrop)
    self.Text_NewModTodayTimes:SetText(Text_EliteRush)
    self.Text_TimesTips:SetText(GText("UI_Event_ModDrop_Reset"))
    self.Text_ModUpNum:SetText("+"..Rate.."%")
end

return M

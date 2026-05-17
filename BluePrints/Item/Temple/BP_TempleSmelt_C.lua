--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_TempleSmelt_C
local M = Class("BluePrints.Item.MiniGame.BP_MiniGame_C")

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self, Info)
    EventManager:AddEvent(EventID.OnTempleCageEnterDown, self, self.OnTempleCageEnterDown)
end

function M:ResetInfo()
    self.Overridden.ResetInfo(self)
    self:ChangeState("Manual", 0, self.GreyStateId)
end

function M:OnTempleCageEnterDown(ManualId, IsEnterDown)
    if ManualId ~= self.CageId then
        return
    end
    if IsEnterDown then
        self:ChangeState("Manual", 0, self.OrangeStateId)
    else
        self:ChangeState("Manual", 0, self.GreyStateId)
    end
end

function M:OnEnterState(NowStateId)
    self.Overridden.OnEnterState(self, NowStateId)
    self:RemoveTimer("ChangeGrey")
    self:RemoveTimer("NoticeCage")
    if NowStateId == self.OrangeStateId then

    elseif NowStateId == self.BlueStateId then
        EventManager:FireEvent(EventID.OnTempleSmeltChangeBlue, self.ManualItemId)
        self:AddTimer(self.DelayTime1, function()
            self:ChangeState("Manual", 0, self.GreyStateId)
        end, false, 0, "ChangeGrey")
    elseif NowStateId == self.GreyStateId then
        self:AddTimer(self.DelayTime2, function()
            EventManager:FireEvent(EventID.OnNoticeCageUp, self.ManualItemId)
        end, false, 0, "NoticeCage")
    end
end

return M

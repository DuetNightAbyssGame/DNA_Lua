require "UnLua"

local M = Class({"BluePrints.Item.CombatProp.BP_CombatPropBase_C", "BluePrints.Common.TimerMgr"})

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    self:SetCamp(self.Data.Camp)
    if self.UnitParams then
        self.DelayTime = self.UnitParams["DelayTime"] or 0
        self.FilterName = self.UnitParams["FilterName"] or ""
        self.BuffTime = self.UnitParams["BuffTime"] or 0
        self.PoisonSmokeTime = self.UnitParams["PoisonSmokeTime"] or 1
        self.BuffId = self.UnitParams["BuffId"] or 0
    end
    self.CanOpen = true
end

function M:OpenMechanism(PlayerId)
    self:AddTimer(self.DelayTime, self.StartPoison)
    self:AddTimer(self.DelayTime+self.PoisonSmokeTime, self.EndPoison)
end

function M:StartPoison()
    self:PlayPoisonFX()
    self:AddTimer(0.1, self.PoisonPlayer, true, 0, "PoisonPlayer")
end

function M:EndPoison()
    self:RemoveTimer("PoisonPlayer")
    self:StopPoisonFX()
end

return M
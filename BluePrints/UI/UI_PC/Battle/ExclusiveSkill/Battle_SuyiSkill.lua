require "UnLua"

---@type WBP_Battle_SuyiSkill_C
local M = Class("BluePrints.UI.UI_PC.Battle.ExclusiveSkill.Base.Battle_Skill_UI_Base")

--function M:Initialize(Initializer)
--end

function M:Construct()
    self:InitListenEvent()

    self.Progress_L:SetPercent(0)
    self.Progress_R:SetPercent(0)
    self.LastSSpPercent = 0
    self.bWarning = false
    self.bFalling = false
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
end

function M:OnLoaded(OwnerPlayer, Params)
    DebugPrint("lgc@Battle_SuyiSkill M:OnLoaded", OwnerPlayer, Params)

    self.OwnerPlayer = OwnerPlayer
    
    self.SSp = OwnerPlayer:GetAttr("SecondSp")
    self.MaxSSp = OwnerPlayer:GetAttr("MaxSecondSp")
    self:PlayAnimation(self.Normal)
    self:UpdateSSp()
end

--function M:Tick(MyGeometry, InDeltaTime)
--    
--end

function M:InitListenEvent()
    self:AddDispatcher(EventID.UpdateMainPlayerSecondSp, self, self.OnUpdateSSp)
    self:AddDispatcher(EventID.UpdateMainPlayerMaxSecondSp, self, self.OnUpdateMaxSSp)
end

function M:OnUpdateSSp(SSp, OwnerActor)
    if OwnerActor == self.OwnerPlayer then
        self.SSp = SSp
        self:UpdateSSp()
    end
end

function M:OnUpdateMaxSSp(MaxSSp, OwnerActor)
    if OwnerActor == self.OwnerPlayer then
        self.MaxSSp = MaxSSp
        self:UpdateSSp()
    end
end

function M:UpdateSSp()
    if self.SSp and self.MaxSSp then
        local SSpPercent = self.SSp / self.MaxSSp
        self.Progress_L:SetPercent(SSpPercent)
        self.Progress_R:SetPercent(SSpPercent)

        if SSpPercent < self.LastSSpPercent then
            if not self.bFalling then
                self:PlayAnimation(self.Fall_Loop)
                self.bFalling = true
                DebugPrint("lgc@Battle_SuyiSkill M:UpdateSSp SSpPercent ", SSpPercent, " bFalling ", self.bFalling)
            end
        else
            if self.bFalling then
                self:PlayAnimation(self.Fall_Loop, 0 , 1, EUMGSequencePlayMode.Reverse)
                self.bFalling = false
                DebugPrint("lgc@Battle_SuyiSkill M:UpdateSSp SSpPercent ", SSpPercent, " bFalling ", self.bFalling)
            end
        end
        self.LastSSpPercent = SSpPercent
        
        if SSpPercent <=  self.WarningSSpThreshold then
            if not self.bWarning then
                self:PlayAnimation(self.Warning, 0 , 0)
                self.bWarning = true
                DebugPrint("lgc@Battle_SuyiSkill M:UpdateSSp SSpPercent ", SSpPercent, " bWarning ", self.bWarning)
            end
        else
            if self.bWarning then
                self:StopAnimation(self.Warning)
                self:StopAnimation(self.Normal)
                self:PlayAnimation(self.Normal)
                self.bWarning = false
                DebugPrint("lgc@Battle_SuyiSkill M:UpdateSSp SSpPercent ", SSpPercent, " bWarning ", self.bWarning)
            end
        end
        local PercentText = string.format("%.0f%%", SSpPercent * 100)
        self.Num_Suyi:SetText(PercentText)
    end
end

return M

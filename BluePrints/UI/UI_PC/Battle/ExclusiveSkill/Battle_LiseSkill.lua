require "UnLua"

---@type WBP_Battle_LiseSkill_C
local M = Class("BluePrints.UI.UI_PC.Battle.ExclusiveSkill.Base.Battle_Skill_UI_Base")

--function M:Initialize(Initializer)
--end

function M:Construct()
    self:InitListenEvent()

    --self.Num_Now:SetText("0")
    --self.Num_Max:SetText("0")
    self.Progress_Lise:SetPercent(0)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
end

function M:OnLoaded(OwnerPlayer, Params)
    DebugPrint("gmy@Battle_LiseSkill M:OnLoaded", OwnerPlayer, Params)

    self.OwnerPlayer = OwnerPlayer
    
    self.SSp = OwnerPlayer:GetAttr("SecondSp")
    self.MaxSSp = OwnerPlayer:GetAttr("MaxSecondSp")
    
    self:PlayAnimation(self.In)
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
    --DebugPrint("gmy@Battle_LiseSkill M:UpdateSSp", self.SSp, self.MaxSSp)
    if self.SSp and self.MaxSSp then
        -- self.SSp转为整数文本
        local SSpText = string.format("%.0f", self.SSp)
        local MaxSSpText = string.format("%.0f", self.MaxSSp)
        
        self.Num_Now:SetText(SSpText)
        self.Num_Max:SetText(MaxSSpText)
        
        local SSpPercent = self.SSp / self.MaxSSp
        self.Progress_Lise:SetPercent(SSpPercent)
    end
end

return M

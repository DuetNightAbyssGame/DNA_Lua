local SuyiUltiWeapons = {
    Melee = "Melee",
    Range1 = "Range1",
    Range2 = "Range2",
}

--- @class AimSuyiModel :Model
local AimSuyiModel = Class("BluePrints.Common.MVC.Model")
function AimSuyiModel:Init()
    DebugPrint("lgc@AimSuyiModel Init")
    AimSuyiModel.Super.Init(self)
    self.bInit = true
end

function AimSuyiModel:Destory()
    DebugPrint("lgc@AimSuyiModel Destory")
    AimSuyiModel.Super.Destory(self)
    self.bInit = false
end

--- @class AimSuyiController :Controller
local M = Class({"BluePrints.Common.MVC.Controller", "BluePrints.UI.BP_EMUserWidgetUtils_C"})
function M:Init(AimView)
    DebugPrint("lgc@AimSuyiController Init  bInit =", self.bInit)
    if self.bInit then return end
    M.Super.Init(self)
    self.bInit = true
    AimSuyiModel:Init()
    self.AimView = AimView
    if not self.AimView then return end
    self.Root = self.AimView.Root
    if not self.Root then return end
    self.bAccelerating = false
    self.LastbAccelerating = false
    self.CurPanel = nil
    self.LastPanel = nil
    self.Player = UE4.UGameplayStatics.GetPlayerCharacter(self.AimView, 0)
    self.CurState = nil
    self.LastState = nil
    self.SuyiUltiWeapons = SuyiUltiWeapons
    self.bIgnoreEnemyMarks = true
end

function M:OnCharTagChange(PlayerEid, OldTag, NewTag)
    DebugPrint("lgc@AimSuyiController OnCharTagChange", PlayerEid, OldTag, "==>", NewTag)
    local Player = Battle(self):GetEntity(PlayerEid)
    if IsValid(Player) == false then
        return
    end
    if NewTag == "Shooting" then
        self:OnFirePressed()
    elseif NewTag == "Skill" then
        if self:IsUsingAttackSkill() then
            self:OnAttackPressed()
        elseif self:IsUsingESkill() and self.CurState == SuyiUltiWeapons.Range1 then
            self:OnAttackPressed()
        end
    end
end

function M:IsUsingAttackSkill()
    if not self.Player then return false end
    local AttackSkillIds = { "150441" }
    local CurSkill = self.Player:GetCurrentSkill()
    if CurSkill and CurSkill.SkillId then
        local Sid = tostring(CurSkill.SkillId)
        for i = 1, #AttackSkillIds do
            if Sid == AttackSkillIds[i] then
                return true
            end
        end
    end
    return false
end

function M:IsUsingESkill()
    if not self.Player then return false end
    local ESkillIds = { "150401", "150411" }
    local CurSkill = self.Player:GetCurrentSkill()
    if CurSkill and CurSkill.SkillId then
        local Sid = tostring(CurSkill.SkillId)
        for i = 1, #ESkillIds do
            if Sid == ESkillIds[i] then
                return true
            end
        end
    end
    return false
end

function M:InitEvents()
    if self.Player and self.Player.CharFSMComp and self.Player.CharFSMComp.OnAfterTagChanged then
        self.Player.CharFSMComp.OnAfterTagChanged:Add(self.AimView,self.AimView.OnCharTagChange)
    end
end

function M:RemoveEvents()
    if self.Player and self.Player.CharFSMComp and self.Player.CharFSMComp.OnAfterTagChanged then
        self.Player.CharFSMComp.OnAfterTagChanged:Remove(self.AimView,self.AimView.OnCharTagChange)
    end
end

function M:Destory()
    DebugPrint("lgc@AimSuyiController Destory  bInit =", self.bInit)
    if not self.bInit then return end
    M.Super.Destory(self)
    self:RemoveEvents()
    self.bInit = false
    self.CurState = nil
    self.LastState = nil
    self.bAccelerating = false
    self.LastbAccelerating = false
    self.AimView = nil
    self.Root = nil
    self.CurPanel = nil
    self.LastPanel = nil
    AimSuyiModel:Destory()
end

function M:OnAttackPressed()
    self:ChangeToTargetState(SuyiUltiWeapons.Melee)
end

function M:OnFirePressed()
    if self.AimView.bSwitchIning then return end
	local bHasRange2Buff = self:IsEuipRange2()
    local TargetState = nil
    if bHasRange2Buff then
        TargetState = SuyiUltiWeapons.Range2
    else
        TargetState = SuyiUltiWeapons.Range1
    end
    self:ChangeToTargetState(TargetState)
end

function M:ChangeToTargetState(TargetState)
    if not self.AimView then return end
    self.CurState = TargetState
    if self.LastState and self.CurState == self.LastState then return end
    DebugPrint("lgc@AimSuyiController ChangeToTargetState", self.LastState, "==>", TargetState)
    if self.LastState == SuyiUltiWeapons.Range2 then
        self.AimView:SwitchOutRange2()
    end
    if self.CurState == SuyiUltiWeapons.Range2 then
        self.AimView:SwitchInRange2()
    end
    if TargetState == SuyiUltiWeapons.Melee then
        self:SwitchAimStar("Melee")
    elseif TargetState == SuyiUltiWeapons.Range1 then
        local CurWeaponStyleNode = self.Root.CurWeaponStyleNode
        self.Root.CurWeaponStyleNode = "Crossbow"
        self:SwitchAimStar("Crossbow")
        self.Root.CurWeaponStyleNode = CurWeaponStyleNode
    elseif TargetState == SuyiUltiWeapons.Range2 then
        self:SwitchAimStar(self.Root and self.Root.SightUI or "Suyi")
    end
    self.LastState = self.CurState
end

function M:SwitchAimStar(StyleNode)
    if not self.Root then return end
    local Widget = self.Root["Panel_Aim_"..StyleNode]
    if not Widget then
        Widget = UIManager(self.Root):_CreateWidgetNew("BattleAim"..StyleNode)
        Widget:Init(self.Root)
        self.Root["Panel_Aim_"..StyleNode] = Widget
        self.Root.Aim_Ranged:AddChild(Widget)
    end
    if self.CurPanel then
        self.LastPanel = self.CurPanel
    end
    self.CurPanel = Widget
    if self.LastPanel then
        self.LastPanel:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if self.CurPanel then
        self.CurPanel:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    if StyleNode == "Melee" then
        self.Root.Panel_Target:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Root.Panel_Kill:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Root.Panel_Target:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Root.Panel_Kill:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:IsEuipRange2()
    if not self.Player then return false end
	local bHasRange2Buff = self.Player.BuffManager:HasBuff(150405, false)
    return bHasRange2Buff
end

function M:GetModel()
    return AimSuyiModel
end

function M:GetEventName()
    return "AimSuyi"
end

--region 界面操作
-- function M:OpenView(WorldContex, Param)
--     return M.Super.OpenView(self, WorldContex, GText("BattlePassMain"), Param)
-- end

-- function M:GetView(WorldContex)
--     return M.Super.GetView(self, WorldContex, GText("BattlePassMain"))
-- end
--endregion
return M


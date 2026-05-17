--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local AimSuyiController = require "BluePrints.UI.Indicator.AimSuyi.AimSuyiController"
local EnemyMarkWidgetPath = "WidgetBlueprint'/Game/UI/WBP/Battle/Widget/Aim/WBP_Battle_Aim_SuyiItem.WBP_Battle_Aim_SuyiItem'"

---@type WBP_Battle_Aim_Suyi_C
local M = Class({"BluePrints.UI.Indicator.WBP_BattleAim_C"})

function M:Construct()
    M.Super.Construct(self)
end

function M:Init(Root)
    self.Root = Root
    self.CurSightUI = Root.SightUI
    self:SetAccumulateInfo()
    self.AimSuyiController = AimSuyiController
    self.CurTrackingActorRelation = "Default"
end

function M:RealRefreshAimColor(ColorIntensty)
    
end

function M:SetAccumulateInfo()
    DebugPrint("lgc@WBP_BattleAimSuyi_C SetAccumulateInfo WeaponId", self.Root.CurrentWeapon.WeaponId)
    local BattleWeaponConfigData = DataMgr.BattleWeapon[self.Root.CurrentWeapon.WeaponId]
    if BattleWeaponConfigData.FrontSight then
        local FrontSightInfo = BattleWeaponConfigData.FrontSight
        if FrontSightInfo.Variable then
            self.Variable = FrontSightInfo.Variable
        end
    end
end

function M:BeginAccumulate(Skill)
    DebugPrint("lgc@WBP_BattleAimSuyi_C BeginAccumulate SkillId", Skill.SkillId)
    self.ClientSkillLogicId = DataMgr.Skill[Skill.SkillId][Skill.SkillLevel][Skill.SkillGrade].ClientSkillLogicId
    if not self.ClientSkillLogicId then
        return
    end
    self.ClientSkillLogicComp = self.Root.OwnerPlayer:GetClientSkillLogicComponent(self.ClientSkillLogicId)
    if not IsValid(self.ClientSkillLogicComp) then
        return
    end
    self.AccumulateNodeId = Skill.NodeId
    if not self.LeaveNodeEventFlag then
        self.Root:RegisterLeaveNodeEvent()
        self.LeaveNodeEventFlag = true
    end
    self:SetAccumulateInfo()
    self.Root.IsAccumulateState = true
    self:PlayAnimation(self.Aim_Shoot, 0, 0)
    self:StopAnimation(self.Aim_Gray)
    self:PlayAnimation(self.Aim_Gray, 0, 1, EUMGSequencePlayMode.Reverse)
    self:StopAnimation(self.Text_Switch)
    self:PlayAnimation(self.Text_Switch, 0, 1, EUMGSequencePlayMode.Reverse)
    self:StopAnimation(self.LIne_Switch)
    self:PlayAnimation(self.LIne_Switch)
end

function M:EndAccumulateOnLeaveNode(Owner, NodeId, SkillNode)
    DebugPrint("lgc@WBP_BattleAimSuyi_C EndAccumulateOnLeaveNode NodeId IsAccumulateState", NodeId, self.Root.IsAccumulateState)
    if self.AccumulateNodeId and self.AccumulateNodeId ~= NodeId then
        return
    end
    if not SkillNode then
        return
    end
    if (not self.Root.CurPanel) or (self.Root.CurPanel ~= self) then
        return
    end
    if (not IsValid(Owner)) or (self.Root.OwnerPlayer ~= Owner) then
        return
    end
    if self.Root.IsAccumulateState then
        self.Root.IsAccumulateState = false
        if self.bTargeting then
            self:AddTimer(0.2, function()
                if IsValid(self) and self.bTargeting then
                    self:UpdateTrackingAimColor("Default")
                end
            end, false, 0, "EndAccumulateDefaultAimColor")
        end
        self.Root:UnregisterLeaveNodeEvent()
        self.LeaveNodeEventFlag = false
        self:StopAnimation(self.Aim_Shoot)
        self:PlayAnimation(self.Aim_Shoot, 0, 1, EUMGSequencePlayMode.Reverse, 5)
        self:StopAnimation(self.Aim_Gray)
        self:PlayAnimation(self.Aim_Gray)
        self:StopAnimation(self.Text_Switch)
        self:PlayAnimation(self.Text_Switch)
        self:StopAnimation(self.LIne_Switch)
        self:PlayAnimation(self.LIne_Switch, 0, 1, EUMGSequencePlayMode.Reverse)
        self.AimChangeReversing = true
        --self:RefreshEnemyMarks(nil)
    end
end

function M:TryToPlayAimDiffusionStartAnim()
    DebugPrint("lgc@WBP_BattleAimSuyi_C TryToPlayAimDiffusionStartAnim IsAccumulateState", self.Root.IsAccumulateState)
    if self.AimSuyiController.CurPanel and self.AimSuyiController.CurPanel.TryToPlayAimDiffusionStartAnim then
        self.AimSuyiController.CurPanel:TryToPlayAimDiffusionStartAnim()
    end
end

function M:RealRefreshAimColor(ColorIntensty)
    if not self.AimSuyiController or not self.AimSuyiController.CurPanel then return end
    if self.AimSuyiController
        and self.AimSuyiController.CurState == self.AimSuyiController.SuyiUltiWeapons.Range1
        and self.AimSuyiController.CurPanel then

        if self.AimSuyiController.CurPanel.RealRefreshAimColor then
            self.AimSuyiController.CurPanel:RealRefreshAimColor(ColorIntensty)
            DebugPrint("lgc@WBP_BattleAimSuyi_C RealRefreshAimColor ColorIntensty")
        end

    end
end

function M:RefreshHitEffectEnhanceVisibility()
    if not self.AimSuyiController or not self.AimSuyiController.CurPanel or not self.AimSuyiController.CurPanel.Panel_Aim_Glow then return end
    if self.AimSuyiController
        and self.AimSuyiController.CurState == self.AimSuyiController.SuyiUltiWeapons.Range1
        and self.AimSuyiController.CurPanel then

        if self.CurActorRelation == "Enemy" then
            self.AimSuyiController.CurPanel.Panel_Aim_Glow:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        else
            self.AimSuyiController.CurPanel.Panel_Aim_Glow:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        
    end
end

function M:PlayHitFeedbackAnim()
    if not self.AimSuyiController or not self.AimSuyiController.CurPanel or not self.Root then return end
    if self.AimSuyiController
        and self.AimSuyiController.CurState == self.AimSuyiController.SuyiUltiWeapons.Range1
        and self.AimSuyiController.CurPanel then

        if self.CurActorRelation == "Enemy" and not EMUIAnimationSubsystem:EMAnimationIsPlaying(self.Root, self.Root.Aim_Critical) then
            EMUIAnimationSubsystem:EMStopAnimation(self.Root, self.Root.Aim_Hit)
            EMUIAnimationSubsystem:EMPlayAnimation(self.Root, self.Root.Aim_Critical)
        elseif self.Root.bPlayAnim and not EMUIAnimationSubsystem:EMAnimationIsPlaying(self.Root, self.Root.Aim_Hit) then
            EMUIAnimationSubsystem:EMStopAnimation(self.Root, self.Root.Aim_Critical)
            EMUIAnimationSubsystem:EMPlayAnimation(self.Root, self.Root.Aim_Hit)
        end

    end
end

function M:UpdateTrackingAimColor(ForceTrackingActorRelation)
    if not self.ClientSkillLogicComp then return end
    local NextTrackingActorRelation = "Default"
    if ForceTrackingActorRelation then
        NextTrackingActorRelation = ForceTrackingActorRelation
    else
        self.TargetEids = self.ClientSkillLogicComp[self.Variable]
        if self.TargetEids and self.TargetEids:Length() > 0 then
            NextTrackingActorRelation = "Enemy"
        end
    end
    if self.CurTrackingActorRelation ~= NextTrackingActorRelation then
        self.CurTrackingActorRelation = NextTrackingActorRelation
        if self.CurTrackingActorRelation == "Enemy" and not self.bTargeting then
            self:StopAnimation(self.Target)
            self:PlayAnimation(self.Target)
            self.bTargeting = true
        elseif self.CurTrackingActorRelation == "Default" and self.bTargeting then
            self:PlayAnimation(self.Target)
            self:StopAnimation(self.Target)
            self.bTargeting = false
        end
    end
end

function M:Tick(Geometry, DeltaTime)
    -- if self.Root.IsAccumulateState then 
    --     self:RefreshEnemyMarks(self.TargetEids)
    -- else
    --     self:RefreshEnemyMarks(nil)
    -- end
    if not self.Player or not IsValid(self.Player) then
        self.Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    end
    if not self.LastbHasAccelerateBuff then
        self.LastbHasAccelerateBuff = false
    end
    local bHasAccelerateBuff = self.Player.BuffManager and self.Player.BuffManager:HasBuff(150407, false)
    if self.LastbHasAccelerateBuff ~= bHasAccelerateBuff then
        self.LastbHasAccelerateBuff = bHasAccelerateBuff
        self:HandleAccelerate(bHasAccelerateBuff)
    end

    if self.Root and self.Root.IsAccumulateState and self.AimSuyiController and self.AimSuyiController:IsEuipRange2() then
        self:UpdateTrackingAimColor()
    end
end

function M:RefreshEnemyMarks(TargetEids)
    if self.AimSuyiController.bIgnoreEnemyMarks then return end
    self.EnemyMarkWidgets = self.EnemyMarkWidgets or {}
    self.EnemyMarkWidgetPool = self.EnemyMarkWidgetPool or {}
    local Controller = self.Root.OwnerPlayer and self.Root.OwnerPlayer:GetController() or nil
    local EnemyMarkClass = self.EnemyMarkClass
    if not EnemyMarkClass then
        EnemyMarkClass = UE4.UClass.Load(EnemyMarkWidgetPath)
        self.EnemyMarkClass = EnemyMarkClass
    end
    local CurrentSet = {}
    if TargetEids then
        for Index = 1, TargetEids:Length() do
            local TargetEid = TargetEids:GetRef(Index)
            if (TargetEid) and Controller and EnemyMarkClass and self.EnemyMarks then
                CurrentSet[TargetEid] = true
                local Widget = self.EnemyMarkWidgets[TargetEid]
                if not Widget then
                    if #self.EnemyMarkWidgetPool > 0 then
                        Widget = table.remove(self.EnemyMarkWidgetPool)
                        self.EnemyMarkWidgets[TargetEid] = Widget
                        Widget:Init(self)
                    else
                        Widget = UIManager(self):CreateWidget(EnemyMarkWidgetPath, true)
                        if Widget then
                            self.EnemyMarks:AddChild(Widget)
                            self.EnemyMarkWidgets[TargetEid] = Widget
                            Widget:Init(self)
                        end
                    end
                end
                if Widget then
                    Widget:UpdateScreenPositionAndScale(TargetEid)
                end
            end
        end
    end
    local ToRemove = {}
    for Key, WidgetInstance in pairs(self.EnemyMarkWidgets) do
        if not CurrentSet[Key] then
            if WidgetInstance then
                WidgetInstance:DeInit()
                table.insert(self.EnemyMarkWidgetPool, WidgetInstance)
                table.insert(ToRemove, Key)
            end
        end
    end
    for Index = 1, #ToRemove do
        self.EnemyMarkWidgets[ToRemove[Index]] = nil
    end
end

function M:SwitchIn()
    DebugPrint("lgc@WBP_BattleAimSuyi_C RealSwitchIn")
    if not self.AimSuyiController.bInit then
        self.bSwitchIning = true
        self.AimSuyiController:Init(self)
        self:AddTimer(0.5, function()
            self.AimSuyiController:InitEvents()
            self:SwitchOutRange2()
        end, false, 0, "InitEvents")
        self:AddTimer(1.6, function()
            DebugPrint("lgc@WBP_BattleAimSuyi_C OnFirePressed")
            self.bSwitchIning = false
            if self.AimSuyiController:IsEuipRange2() then
                self.AimSuyiController:OnFirePressed()
            else
                self.AimSuyiController:OnAttackPressed()
            end
        end, false, 0, "OnFirePressed")
    end
end

function M:SwitchInRange2()
    DebugPrint("lgc@WBP_BattleAimSuyi_C SwitchInRange2")
    M.Super.SwitchIn(self)
    self.Root.IsAccumulateState = false
    self.Root:UnregisterLeaveNodeEvent()
    self.LeaveNodeEventFlag = false
    self:StopAnimation(self.In)
    self:PlayAnimation(self.In)
end

function M:SwitchOut()
    M.Super.SwitchOut(self)
    DebugPrint("lgc@WBP_BattleAimSuyi_C SwitchOut")
    self:StopAnimation(self.Aim_Shoot)
    self:PlayAnimation(self.Aim_Shoot, 0, 1, EUMGSequencePlayMode.Reverse)
    self.AimSuyiController:SwitchAimStar("Melee")
    self.AimSuyiController:Destory()
    if self.EnemyMarkWidgets then
        for _, WidgetInstance in pairs(self.EnemyMarkWidgets) do
            if WidgetInstance then
                WidgetInstance:SetVisibility(UE4.ESlateVisibility.Collapsed)
                if self.EnemyMarks then
                    self.EnemyMarks:RemoveChild(WidgetInstance)
                end
                WidgetInstance:RemoveFromParent()
            end
        end
        self.EnemyMarkWidgets = {}
    end
    if self.EnemyMarkWidgetPool then
        for _, WidgetInstance in ipairs(self.EnemyMarkWidgetPool) do
            if WidgetInstance then
                if self.EnemyMarks then
                    self.EnemyMarks:RemoveChild(WidgetInstance)
                end
                WidgetInstance:RemoveFromParent()
            end
        end
        self.EnemyMarkWidgetPool = {}
    end
    self.EnemyMarkClass = nil
    --self:RefreshEnemyMarks(nil)
end

function M:SwitchOutRange2()
    DebugPrint("lgc@WBP_BattleAimSuyi_C SwitchOutRange2")
    if self:GetVisibility() == UE4.ESlateVisibility.Collapsed then return end
    M.Super.SwitchOut(self)
    self.Root.IsAccumulateState = false
    self.Root:UnregisterLeaveNodeEvent()
    self.LeaveNodeEventFlag = false
    if self.bTargeting then
        self:AddTimer(0.2, function()
            if IsValid(self) and self.bTargeting then
                self:UpdateTrackingAimColor("Default")
            end
        end, false, 0, "SwitchOutRange2DefaultAimColor")
    end
end

function M:HandleAccelerate(IsAccelerating)
    if not self.Accelerate then return end
    local EndTime = self.Accelerate:GetEndTime()
    local CurrentTime = self.AccelerateCurrentTime or 0
    if self:IsAnimationPlaying(self.Accelerate) then
        local CurrentTimeValue = self:GetAnimationCurrentTime(self.Accelerate)
        if CurrentTimeValue then CurrentTime = CurrentTimeValue end
    else
        if self.IsAccelerating then
            CurrentTime = EndTime or CurrentTime
        else
            CurrentTime = 0
        end
    end
    if CurrentTime < 0 then CurrentTime = 0 end
    if EndTime and CurrentTime > EndTime then CurrentTime = EndTime end
    local Epsilon = 0.001
    self:StopAnimation(self.Accelerate)
    if IsAccelerating then
        if EndTime and CurrentTime >= EndTime then CurrentTime = math.max(EndTime - Epsilon, 0) end
        self.AccelerateCurrentTime = CurrentTime
        self.IsAccelerating = true
        self:PlayAnimation(self.Accelerate, CurrentTime, 1, EUMGSequencePlayMode.Forward)
    else
        if CurrentTime <= 0 then CurrentTime = Epsilon end
        self.AccelerateCurrentTime = CurrentTime
        self.IsAccelerating = false
        self:PlayAnimation(self.Accelerate, EndTime - CurrentTime, 1, EUMGSequencePlayMode.Reverse, 3.0)
    end
end

function M:OnCharTagChange(PlayerEid, OldTag, NewTag)
    if not self.AimSuyiController then return end
    self.AimSuyiController:OnCharTagChange(PlayerEid, OldTag, NewTag)
end

return M

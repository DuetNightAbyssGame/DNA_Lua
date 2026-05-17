--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local WBP_BattleAimTrackingBow_C = Class({"BluePrints.UI.Indicator.WBP_BattleAim_C"})

function WBP_BattleAimTrackingBow_C:Construct()
    WBP_BattleAimTrackingBow_C.Super.Construct(self)
    self.Aim_Bow:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function WBP_BattleAimTrackingBow_C:Init(Root)
    self.Root = Root
    self.CurSightUI = Root.SightUI

    self.TrackibgAimStarTable = {
        self.Img_Bow,
        self.VX_BowGlow,
        self.Img_Bow_1,
        self.VX_BowGlow_1,
        self.Img_Bow_2,
        self.VX_BowGlow_2,
        self.Img_Bow_3,
        self.VX_BowGlow_3,
    }

    self:BindToAnimationFinished(self.Aim_Change,{self,function()
        if self.AimChangeReversing then
            self.AimChangeReversing = false
            return
        end
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Loop, EUMGSequencePlayMode.Forward, true)
    end})

    self.Aim_Bow:Init(Root)
end

function WBP_BattleAimTrackingBow_C:RealRefreshAimColor(ColorIntensty)
    self.Aim_Bow:RealRefreshAimColor(ColorIntensty)
end

function WBP_BattleAimTrackingBow_C:SetAccumulateInfo()
    local BattleWeaponConfigData = DataMgr.BattleWeapon[self.Root.CurrentWeapon.WeaponId]
    if BattleWeaponConfigData.FrontSight then
        local FrontSightInfo = BattleWeaponConfigData.FrontSight
        if FrontSightInfo.Variable then
            self.Variable = FrontSightInfo.Variable
        end
        if FrontSightInfo.TargetFilter then
            self.TargetFilter = FrontSightInfo.TargetFilter
        end
    end

    if self.TargetFilter and self.Root.OwnerPlayer and self.Root.OwnerPlayer.CharCameraComponent then
        local TargetFilterParaments = DataMgr.TargetFilter[self.TargetFilter].LuaFilterParaments
        local ConeAngle = TargetFilterParaments.ConeAngle

        local PlayerCameraComp = self.Root.OwnerPlayer.CharCameraComponent
        local AspectRatio = PlayerCameraComp.AspectRatio
        local HorizontalFOV = PlayerCameraComp.FieldOfView
        local halfHFOV = HorizontalFOV / 2
        local tan_halfVFOVrad = math.tan(math.rad(halfHFOV)) / AspectRatio
        local ViewportSize = UWidgetLayoutLibrary.GetViewportSize(self)
        local ViewportScale = UWidgetLayoutLibrary.GetViewportScale(self)
        local HalfStandardSizeY = ViewportSize.Y / ViewportScale / 2
        local TargetImageRadius = HalfStandardSizeY * math.tan(math.rad(ConeAngle)) / tan_halfVFOVrad

        local ImageRadius = self.Img_Bow.Brush.ImageSize.X/2
        local Scale = TargetImageRadius/ImageRadius
        self.VB_Bow:SetRenderScale(FVector2D(Scale,Scale))
    end
end

function WBP_BattleAimTrackingBow_C:BeginAccumulate(Skill)
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
    if not self.Root.UpdateTrackingBowAimColorTimer then
        self.Root.UpdateTrackingBowAimColorTimer = self.Root:AddTimer(0.1, self.Root.UpdateTrackingBowAimColor, true, 0, "UpdateTrackingBowAimColorTimer", false)
    end

    self.VB_Bow:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.VB_Bow:SetRenderTransformAngle(0)
    self.AimChangeReversing = false
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Aim_Change)
end

function WBP_BattleAimTrackingBow_C:EndAccumulateOnLeaveNode(Owner, NodeId, SkillNode)
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
        self.Root:RemoveTimer(self.Root.UpdateTrackingBowAimColorTimer)
        self.Root.UpdateTrackingBowAimColorTimer = nil
        self.Root:UnregisterLeaveNodeEvent()
        self.LeaveNodeEventFlag = false
        if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Aim_Change) then
            EMUIAnimationSubsystem:EMStopAnimation(self, self.Aim_Change)
        end
        if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Loop) then
            EMUIAnimationSubsystem:EMStopAnimation(self, self.Loop)
        end
        self.AimChangeReversing = true
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Aim_Change, EUMGSequencePlayMode.Reverse)
    end
end

function WBP_BattleAimTrackingBow_C:TryToPlayAimDiffusionStartAnim()
    if self.Root.IsAccumulateState then
        self.Root.IsAccumulateState = false
        self.Root:RemoveTimer(self.Root.UpdateTrackingBowAimColorTimer)
        self.Root.UpdateTrackingBowAimColorTimer = nil
        self.Root:UnregisterLeaveNodeEvent()
        self.LeaveNodeEventFlag = false
        if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Aim_Change) then
            EMUIAnimationSubsystem:EMStopAnimation(self, self.Aim_Change)
        end
        if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Loop) then
            EMUIAnimationSubsystem:EMStopAnimation(self, self.Loop)
        end
        self.AimChangeReversing = true
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Aim_Change, EUMGSequencePlayMode.Reverse)
    else
        EMUIAnimationSubsystem:EMPlayAnimation(self.Aim_Bow, self.Aim_Bow.Bow_NormalAttack)
    end
end

function WBP_BattleAimTrackingBow_C:UpdateTrackingBowAimColor()
    local NextTrackingActorRelation = "Default"
    if self.ClientSkillLogicComp[self.Variable]:Length() > 0 then
        NextTrackingActorRelation = "Enemy"
    end
    if self.CurTrackingActorRelation ~= NextTrackingActorRelation then
        self.CurTrackingActorRelation = NextTrackingActorRelation
        local ColorIntensty = self.Root.AllColorIntensty[self.CurTrackingActorRelation]
        self:RefreshHitEffectEnhanceVisibility()
        self:RealRefreshTrackingAimColor(ColorIntensty)
    end
end

function WBP_BattleAimTrackingBow_C:RealRefreshTrackingAimColor(ColorIntensty)
    for _, AimNode in ipairs(self.TrackibgAimStarTable) do
        AimNode:SetColorAndOpacity(ColorIntensty)
    end
end

function WBP_BattleAimTrackingBow_C:SwitchIn()
    WBP_BattleAimTrackingBow_C.Super.SwitchIn(self)
    self.Root.IsAccumulateState = false
    self.Root:RemoveTimer(self.Root.UpdateTrackingBowAimColorTimer)
    self.Root.UpdateTrackingBowAimColorTimer = nil
    self.Root:UnregisterLeaveNodeEvent()
    self.LeaveNodeEventFlag = false
end

function WBP_BattleAimTrackingBow_C:SwitchOut()
    WBP_BattleAimTrackingBow_C.Super.SwitchOut(self)
    self.Root.IsAccumulateState = false
    self.Root:RemoveTimer(self.Root.UpdateTrackingBowAimColorTimer)
    self.Root.UpdateTrackingBowAimColorTimer = nil
    self.Root:UnregisterLeaveNodeEvent()
    self.LeaveNodeEventFlag = false
end

return WBP_BattleAimTrackingBow_C


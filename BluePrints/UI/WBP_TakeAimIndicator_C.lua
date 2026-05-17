--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
require "DataMgr"

local FrontSightUtils = require "Utils.FrontSightUtils"

local WBP_TakeAimIndicator_C = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.TimerMgr"})

WBP_TakeAimIndicator_C._components = {
    "BluePrints.UI.WBP_TakeAimIndicatorAimStarComponent_C",
    "BluePrints.UI.WBP_TakeAimIndicatorAmmoBarComponent_C",
}

function WBP_TakeAimIndicator_C:Initialize(Initializer)
    self.BordSize = FVector2D(30, 30)
    self.AllShootingTargets = nil
    self.LastShootTargetEid = {}                -- 用于多目标武器上

    self.OwnerPlayer = nil
	self.OwnerPlayerCameraComponent = nil
    self.CurrentWeapon = nil
    self.CurWeaponStyle = nil
    self.CurWeaponStyleNode = nil
    self.SightUI = nil
    self.AmmoBarStyle = nil

	self.InBulletJumpMode = false

    self.ChangeAimStarColorAndShowBillboardTimer = nil
    self.UpdateDiffusionStateTimer = nil
    self.UpdateAccumulateStateTimer = nil
    self.PlayReloadAnimTimer = nil
    self.LerpSetAmmoBarPercentTimer = nil

    self.CurState = "Normal"
    self.AllCurWeaponStyle = {"Melee", "Ranged", "NoWeapon"}
    self.AllWeaponStyleNode = {"Funnel", "Melee", "AimStarButterfly", "Crossbow", "Shotgun", "Cannon", "Thunder", "Fire", "Rifle", "Bow", "Archer", "TrackingBow"}
    self.AllAmmoBarStyle = {"BarFunnel", "Single", "UnlimitedSingle", "Bar"}
    self.AllCurState = {"Normal", "Reload"}
    self.BarColor = nil
    self.CurMagazineCapacity = nil
    self.AllColorIntensty = {}
    self.NextActorRelation = nil
end

function WBP_TakeAimIndicator_C:InitListenEvent()
    EventManager:AddEvent(EventID.ReloadStart, self, self.TryToEnterReloadState)
    EventManager:AddEvent(EventID.ReloadEnd, self, self.TryToLeaveReloadState_End)
    EventManager:AddEvent(EventID.ReloadStop, self, self.TryToLeaveReloadState_Stop)
    EventManager:AddEvent(EventID.OutOfBullet, self, self.ShowOutOfBulletTip)
    EventManager:AddEvent(EventID.FullOfMagazine, self, self.ShowFullOfMagazineTip)
    EventManager:AddEvent(EventID.OnCharForbidWeapon, self, self.HideOrShowTargetAim)
    EventManager:AddEvent(EventID.OnEnterBulletJumpAim, self, self.ShowBulletJumpAim)
    EventManager:AddEvent(EventID.OnQuitBulletJumpAim, self, self.HideBulletJumpAim)
end

function WBP_TakeAimIndicator_C:Init(Player)
    self.OwnerPlayer = Player
    if (not IsValid(self.OwnerPlayer)) then
        self:Close()
        return
    end
    self.OwnerPlayerCameraComponent = self.OwnerPlayer.CharCameraComponent
    self.Panel_Aim_Melee = self.Aim_Melee
    self.Panel_Aim_BulletReload = self.Panel_Reload
    self.OwnerPlayer.TakeAimIndicator = self
    -- TODO后续根据平台来加载
    -- if (CommonUtils.GetDeviceTypeByPlatformName(self) == "PC") then
    --     self.FunnelAimItem = LoadClass("/Game/UI/UI_PC/Battle/Battle_Take_Aim_Funnel.Battle_Take_Aim_Funnel_C")
    -- end
    self:InitListenEvent()
    self:InitAllColorIntensty()
    --self:BindToAnimationFinished(self.No_Bullets,{self,self.OnOutOfBulletAnimEnd})
    self:RefreshUIShowPage()
    -- （60帧下6帧刷新一次，30帧下3帧刷新一次）
    self.ChangeAimStarColorAndShowBillboardTimer = self:AddTimer(0.1, self.ChangeAimStarColorAndShowBillboard, true, 0.5, "ChangeAimStarColorAndShowBillboardTimer")
    UIManager(self).TakeAimIndicator = self
    --self:AddTimer(0.033, self.UpdateAimDiffusionAndBarPercentInTick, true, 0, "UpdateAimDiffusionAndBarPercentInTick", false, 0.033)
end

function WBP_TakeAimIndicator_C:InitAllColorIntensty()
    self.AllColorIntensty["Default"] = UE4.UUIFunctionLibrary.StringToLinearColor(self.AimColorDefault)
    self.AllColorIntensty["ForceDefault"] = UE4.UUIFunctionLibrary.StringToLinearColor(self.AimColorForceDefault)
    self.AllColorIntensty["Enemy"] = UE4.UUIFunctionLibrary.StringToLinearColor(self.AimColorEnemy)
    self.AllColorIntensty["Friend"] = UE.UUIFunctionLibrary.StringToLinearColor(self.AimColorFriend)
end

function WBP_TakeAimIndicator_C:RefreshUIShowPage()
    if (not IsValid(self.OwnerPlayer)) then
        self.OwnerPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        if (not IsValid(self.OwnerPlayer)) then
            return
        end
        self.OwnerPlayer.TakeAimIndicator = self
        self.OwnerPlayerCameraComponent = self.OwnerPlayer.CharCameraComponent
    end
    self.CurrentWeapon ="NeedUpdate"
    self.CurWeaponStyle = "NeedUpdate"
    self.CurWeaponStyleNode ="NeedUpdate"
    self.SightUI = "NeedUpdate"
    self.AmmoBarStyle = "NeedUpdate"
    self:UpdateWeaponInfo(self.OwnerPlayer)
end

-- function WBP_TakeAimIndicator_C:ChangeAimStarColorAndShowBillboard()
--     if (not IsValid(self.OwnerPlayer)) then
--         return
--     end
--     --追踪和准星变色
--     if (self.OwnerPlayer.CharCameraComponent ~= nil) then
--         -- local ForwardVector = CameraComponent:GetForwardVector()
--         -- self:TryToRayTraceMonster(self.OwnerPlayer, self.OwnerPlayer.CharCameraComponent:K2_GetComponentLocation())
--         self:TryToRayTraceMonster(self.OwnerPlayer, self.OwnerPlayer.CharCameraComponent.LastComponentLocation)
--     else
--         -- self:TryToRayTraceMonster(self.OwnerPlayer, self.OwnerPlayer:K2_GetActorLocation())
--         self:TryToRayTraceMonster(self.OwnerPlayer, self.OwnerPlayer.CurrentLocation)
--     end
--     --显示血条
--     self:DoCheckAfterRayTrace()
-- end

function WBP_TakeAimIndicator_C:UpdateWeaponInfo(Owner, LastWeapon, NewWeapon)
    if self.ForceLockMelee then
        return
    end
    if self.OwnerPlayer ~= Owner then
        return
    end
    if not NewWeapon then
        local IgnoreWeaponChangeSkillIds = { "150401", "150411" }
        local CurSkill = nil
        if IsValid(self.OwnerPlayer) then
            CurSkill = self.OwnerPlayer:GetCurrentSkill()
        end
        if CurSkill and CurSkill.SkillId then
            local Sid = tostring(CurSkill.SkillId)
            for i = 1, #IgnoreWeaponChangeSkillIds do
                if Sid == IgnoreWeaponChangeSkillIds[i] then
                    return
                end
            end
        end
    end
    if not IsValid(NewWeapon) and IsValid(self.OwnerPlayer) then
        NewWeapon = self.OwnerPlayer:GetCurrentWeapon()
    end
    local NewMagazineCapacity = nil
    if (IsValid(NewWeapon)) then
        NewMagazineCapacity = NewWeapon:GetAttr("MagazineCapacity")
    end
    self:RealUpdateWeaponInfo(NewWeapon, NewMagazineCapacity, Owner.ModelId)
end

function WBP_TakeAimIndicator_C:RealUpdateWeaponInfo(NewWeapon, NewMagazineCapacity, ModelId)
    if self.CurrentWeapon ~= NewWeapon or self.CurMagazineCapacity ~= NewMagazineCapacity then
        self.CurrentWeapon = NewWeapon
        self.CurMagazineCapacity = NewMagazineCapacity
        --决定是否刷新准星
        local NewSightUI = FrontSightUtils:GetWeaponSightUI(self.CurrentWeapon, ModelId)
        if self.SightUI ~= NewSightUI then
            self.SightUI = NewSightUI
            --决定是否切换准星，切换包含刷新
            local NewWeaponStyleNode = FrontSightUtils:GetWeaponStyleNode(NewSightUI)
            if NewWeaponStyleNode and self.CurWeaponStyleNode ~= NewWeaponStyleNode then
                self.CurWeaponStyleNode = NewWeaponStyleNode
                self.CurWeaponStyle = FrontSightUtils:GetWeaponStyle(self.CurWeaponStyleNode)
                self:SwitchAimStar()
            else
                self:RefreshAimStar()
            end
        end
        local NewAmmoBarStyle = FrontSightUtils:GetAmmoBarStyle(self.CurrentWeapon, self.CurWeaponStyleNode, self.CurMagazineCapacity, self.SightUI)
        if self.AmmoBarStyle ~= NewAmmoBarStyle then
            self.AmmoBarStyle = NewAmmoBarStyle
            self:SwitchAmmoBar()
        else
            self:RefreshAmmoBar()
        end
    end
end

-- function WBP_TakeAimIndicator_C:UpdateAimDiffusionAndBarPercentInTick(InDeltaTime)
--     -- if self.IsDiffuseState then
--     --     self:UpdateDiffusionStateInTick(InDeltaTime)
--     -- end
--     -- if self.IsAccumulateState then
--     --     self:UpdateAccumulateStateInTick(InDeltaTime)
--     -- end
--     -- if self.IsReloadingBar then
--     --     self:PlayReloadAnimInTick(InDeltaTime)
--     -- end
--     -- if self.IsLerpSetAmmo then
--     --     self:LerpSetAmmoBarPercentInTick(InDeltaTime)
--     -- end
-- end

function WBP_TakeAimIndicator_C:GetIsHideMagazineBar(Weapon)
    if (not IsValid(Weapon)) then
        return nil
    end
    local BattleWeaponConfigData = DataMgr.BattleWeapon[Weapon.WeaponId]
    local HideMagazineBar = nil
    if BattleWeaponConfigData.FrontSight and BattleWeaponConfigData.FrontSight.HideMagazineBar then
        HideMagazineBar = BattleWeaponConfigData.FrontSight.HideMagazineBar
    end
    return HideMagazineBar
end

function WBP_TakeAimIndicator_C:ForceLockMeleeAimIndicator(IsLock)
    if IsLock then
        self.ForceLockMelee = true
        self:RealUpdateWeaponInfo(nil, nil)
    else
        self.ForceLockMelee = false
        self:RefreshUIShowPage()
    end
end

------锁定
function WBP_TakeAimIndicator_C:SetInPressShootingBtn(IsPress)
    self.IsInPressMouseRight = IsPress
end

-- function WBP_TakeAimIndicator_C:Tick(MyGeometry, InDeltaTime)
--     self:UpdateCameraLockOnMark()
-- end

-- function WBP_TakeAimIndicator_C:UpdateCameraLockOnMark()
--     if(not IsValid(self.OwnerPlayer))then
--         return
--     end
--     local PreLockOnInfo = self.OwnerPlayer.CameraRotationComponent.PreLockOnInfo
--     if(not IsValid(PreLockOnInfo) or self.OwnerPlayer:CharacterInTag("Shooting"))then
--         --射击时隐藏所有标记
--         if(self.LockOnMark)then
--             self.LockOnMark:SetVisibility(UE4.ESlateVisibility.Collapsed)
--             self.LockOnMark:SetIsShow(false)
--             if( self.CurWeaponStyleNode == "Melee")then
--                 self.Panel_Aim_Melee:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--             end
--         end
--         return
--     end
--     local Controller = self.OwnerPlayer:GetController()
--     local ViewPortScale = UE4.UWidgetLayoutLibrary.GetViewportScale(self)
--     if(not self.LockOnMark)then
--         self.LockOnMark = UIManager(self):_CreateWidgetNew("AimLock")
--         --self.LockOnMark = self:CreateWidgetNew("AimLock")
--         self.Root:AddChild(self.LockOnMark)
--         self.LockOnMark:SetIsLocked(false)
--         self.LockOnMark:BindAnim()
--         local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.LockOnMark)
--         CanvasSlot:SetSize(FVector2D(0, 0))
--         self.LockOnMark:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     end
--     local LockOnInfo = self.OwnerPlayer.CameraRotationComponent.CurLockOnInfo or PreLockOnInfo
--     local BoneLoc
--     local Condition
--     local ScreenPosition = FVector2D(0,0)
--     if IsValid(LockOnInfo) and IsValid(LockOnInfo.Actor) and LockOnInfo.Actor.Mesh and LockOnInfo.Actor.Mesh:DoesSocketExist(LockOnInfo.Bone) then
--         BoneLoc = LockOnInfo.Actor.Mesh:GetSocketLocation(LockOnInfo.Bone)
--         Condition = UE4.UGameplayStatics.ProjectWorldToScreen(Controller,BoneLoc,ScreenPosition)
--     end
--     if(Condition)then
--         local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.LockOnMark)
--         ScreenPosition.X = ScreenPosition.X / ViewPortScale
--         ScreenPosition.Y = ScreenPosition.Y / ViewPortScale
--         CanvasSlot:SetPosition(ScreenPosition)
--         self.LockOnMark:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         if(self.OwnerPlayer.CameraRotationComponent.CurLockOnInfo)then
--             self.LockOnMark:SetIsLocked(true)
--             if( self.CurWeaponStyleNode == "Melee")then
--                 self.Panel_Aim_Melee:SetVisibility(UE4.ESlateVisibility.Collapsed)
--             end
--         else
--             self.LockOnMark:SetIsLocked(false)
--             if( self.CurWeaponStyleNode == "Melee")then
--                 self.Panel_Aim_Melee:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--             end
--         end
--         self.LockOnMark:SetIsShow(true)
--     else
--         self.LockOnMark:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         self.LockOnMark:SetIsShow(false)
--     end
-- end

--------显隐准星
function WBP_TakeAimIndicator_C:HideOrShowTargetAim(WeaponTag, IsHide)
    if (not IsValid(self.OwnerPlayer)) then
        return
    end
    -- 一些功能会临时隐藏一下准星
    local Widget = nil
    if (WeaponTag == "Ranged") then
        -- 远程比较特殊（需要）禁用当前远程武器对应的准星
        local RangedWeapon = self.OwnerPlayer.RangedWeapon
        if (IsValid(RangedWeapon)) then
            local AllWeaponTags = RangedWeapon:GetWeaponTags()
            for i = 1, AllWeaponTags:Length() do
                local WeaponTagStr = AllWeaponTags:GetRef(i)
                if (self["Panel_Aim_"..WeaponTagStr] ~= nil) then
                    Widget = self["Panel_Aim_"..WeaponTagStr]
                    break
                end
            end
        end
    else
        Widget = self["Panel_Aim_"..WeaponTag]
    end
    if (Widget ~= nil) then
        if (IsHide) then
            Widget:SetRenderOpacity(0.0)
            -- 连同弹夹一起隐藏
            if (WeaponTag == "Ranged" and self.AmmoBarPanel ~= nil) then
                self.AmmoBarPanel:SetRenderOpacity(0.0) 
            end
        else
            Widget:SetRenderOpacity(1.0)
            if (WeaponTag == "Ranged" and self.AmmoBarPanel ~= nil) then
                self.AmmoBarPanel:SetRenderOpacity(1.0)
            end
        end
    end
end

---------浮游炮相关
function WBP_TakeAimIndicator_C:GetMeshLocationByShootTarget(ShootTarget)
    local Skill = nil
    if self.OwnerPlayer then
        local SkillId = self.OwnerPlayer:GetSkillByType(UE.ESkillType.Shooting)
        Skill = self.OwnerPlayer:GetSkill(SkillId)
    end
    if not Skill then
        return ShootTarget:K2_GetActorLocation()
    end
    local TargetLocation = nil
    local SkillNodeId = Skill.BeginNodeId
    local SkillNodeConfig = DataMgr.SkillNode[SkillNodeId]
    if not SkillNodeConfig then
        return ShootTarget:K2_GetActorLocation()
    end

    local AllSkillTaskIds = SkillNodeConfig.SkillNodeEffects
    if not AllSkillTaskIds then
        return ShootTarget:K2_GetActorLocation()
    end
    local AimSkeletal = nil
    for _, SkillTaskId in pairs(AllSkillTaskIds) do
        local SkillEffectConfig = DataMgr.SkillEffects[SkillTaskId]
        if (SkillEffectConfig["TaskEffects"] and SkillEffectConfig["TaskEffects"][1] and SkillEffectConfig["TaskEffects"][1].AimSkeletal) then
            AimSkeletal = SkillEffectConfig["TaskEffects"][1].AimSkeletal
            break
        end
    end
    if ShootTarget.Mesh and AimSkeletal then
        TargetLocation = ShootTarget.Mesh:GetSocketLocation(AimSkeletal)
    else
        TargetLocation = ShootTarget:K2_GetActorLocation()
    end
    return TargetLocation
end

function WBP_TakeAimIndicator_C:AddAndUpdateFilterShootingTarget(Index, MiniAimWidget, ShootingTarget)
    -- local TargetHalfHeight = ShootingTarget.CapsuleComponent:GetUnscaledCapsuleHalfHeight()
    local TargetLocation = self:GetMeshLocationByShootTarget(ShootingTarget)
    local TargetScreenLocation = FVector2D(0, 0)
    local Controller = self.OwnerPlayer:GetController()
    local IndicatorAngle, PointDistance, IsTargetPointNotInScreen = UE4.UUIFunctionLibrary.ProjectWorldToScreenAsIndicator(Controller, TargetLocation, 
                                                                                self.BordSize, TargetScreenLocation, 0, 0)
    local DesignedSize = UIManager(self):GetDesignedScreenSize()
    local ScreenCenterPos = FVector2D(DesignedSize.X * 0.5, DesignedSize.Y * 0.5)
    local ViewPortScale = UE4.UWidgetLayoutLibrary.GetViewportScale(self)
    local RealTargetScreenLocation = FVector2D(TargetScreenLocation.X / ViewPortScale, TargetScreenLocation.Y / ViewPortScale)
    local PointDistance = UE4.UKismetMathLibrary.Distance2D(RealTargetScreenLocation, ScreenCenterPos)
    if (PointDistance < 280) then
        -- 位于半径280像素内的圆形区域
        local DestCircleDeltaVec = FVector2D(RealTargetScreenLocation.X - ScreenCenterPos.X, RealTargetScreenLocation.Y - ScreenCenterPos.Y)
        -- local DestCircleDeltaVec = FVector2D(TargetScreenLocation.X - ScreenCenterPos.X, TargetScreenLocation.Y - ScreenCenterPos.Y)
        local NowCirclePosVec = MiniAimWidget:GetFilterShootingTargetCurPos()
        local ToDestDistance = UE4.UKismetMathLibrary.Distance2D(DestCircleDeltaVec, NowCirclePosVec)
        if (ToDestDistance <= 50 or self.LastShootTargetEid[Index] == ShootingTarget.Eid) then
            MiniAimWidget:UpdateFilterShootingTargetToPos(DestCircleDeltaVec)
        else
            MiniAimWidget:UpdateFilterShootingTargetTweenToPos(MiniAimWidget.Aim_Node, DestCircleDeltaVec)
        end
    end
    self.LastShootTargetEid[Index] = ShootingTarget.Eid
end

function WBP_TakeAimIndicator_C:UpdateFunnelWeapon()
    self.AllShootingTargets = self.OwnerPlayer:GetShootingTargets()
    if (self.AllShootingTargets == nil or self.FunnelAimItem == nil) then
        self:ResetFunnelWeaponState()
        return
    end
	local TargetCount = self.AllShootingTargets:Length()
    local IsOpenNormalAir = self.OwnerPlayer:IsOpenNormalAim()
    local IsInShooting = self.OwnerPlayer:CharacterInTag("Shooting")

    if (IsInShooting) then
        if (TargetCount == 0 or not IsOpenNormalAir) then
            self:ChangeFunnelWeaponNoTargetState()
            return
        end
    else
        self:ResetFunnelWeaponState()
        return
    end
    self:ChangeFunnelWeaponFireState()
    -- 选择N个目标进行射击
    local AllMiniAimChildren = self.Mini_Aim_Parent:GetAllChildren()
    local MiniAimCount = AllMiniAimChildren:Length()
    for index = 1, TargetCount, 1 do
        local ShootingTarget = self.AllShootingTargets:GetRef(index)
        local MiniWidget = nil
        if (index <= MiniAimCount) then
            MiniWidget = AllMiniAimChildren:GetRef(index) 
        end
        -- local TryToRemoveSubItem = function(Widget)
        --     self.Mini_Aim_Parent:RemoveChild(Widget)
        -- end
        if (MiniWidget == nil) then
            MiniWidget = UE4.UWidgetBlueprintLibrary.Create(self, self.FunnelAimItem)
            MiniWidget:Init(index, ShootingTarget)
            self.Mini_Aim_Parent:AddChildToCanvas(MiniWidget)
        else
            MiniWidget:ReShow(index, ShootingTarget)
        end
        self:AddAndUpdateFilterShootingTarget(index, MiniWidget, ShootingTarget)
    end

    for i = TargetCount + 1, MiniAimCount, 1 do
        local NotUseMiniWidget = AllMiniAimChildren:GetRef(i) 
        NotUseMiniWidget:StopAllAnimations()
        NotUseMiniWidget.Aim_Node:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    -- self.Mini_Aim_Parent:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function WBP_TakeAimIndicator_C:ChangeFunnelWeaponNoTargetState()
    local AllMiniAimChildren = self.Mini_Aim_Parent:GetAllChildren()
    local MiniAimCount = AllMiniAimChildren:Length()
    for index = 1, MiniAimCount, 1 do
        local MiniWidget = AllMiniAimChildren:GetRef(index) 
        MiniWidget:HideAim()
    end
end

function WBP_TakeAimIndicator_C:ChangeFunnelWeaponFireState()
    if (not self:IsAnimationPlaying(self.Funnel_Change) and not self.Mini_Aim_Parent:IsVisible()) then
        local function PlayAnimFinished()
            self.Mini_Aim_Parent:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            -- self.Battle_Aim_Funnel07:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
        self:BindToAnimationFinished(self.Funnel_Change, {self, PlayAnimFinished})
        self:PlayAnimationForward(self.Funnel_Change)
    end
end

function WBP_TakeAimIndicator_C:ResetFunnelWeaponState()
    if (self.Mini_Aim_Parent:IsVisible() and not self:IsAnimationPlaying(self.Funnel_Change)) then
        local function PlayAnimFinished()
            self.Mini_Aim_Parent:SetVisibility(UE4.ESlateVisibility.Collapsed)
            -- self.Battle_Aim_Funnel07:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        self:BindToAnimationFinished(self.Funnel_Change, {self, PlayAnimFinished})
        self:PlayAnimationReverse(self.Funnel_Change)
    end
end

function WBP_TakeAimIndicator_C:Destruct()
    EventManager:RemoveEvent(EventID.ReloadStart, self)
    EventManager:RemoveEvent(EventID.ReloadEnd, self)
    EventManager:RemoveEvent(EventID.ReloadStop, self)
    EventManager:RemoveEvent(EventID.OutOfBullet, self)
    EventManager:RemoveEvent(EventID.FullOfMagazine, self)
    EventManager:RemoveEvent(EventID.OnCharForbidWeapon, self)
    EventManager:RemoveEvent(EventID.OnEnterBulletJumpAim, self)
    EventManager:RemoveEvent(EventID.OnQuitBulletJumpAim, self)
    self:RemoveTimer(self.ChangeAimStarColorAndShowBillboardTimer)
    self:RemoveTimer(self.UpdateDiffusionStateTimer)
    self:RemoveTimer(self.UpdateAccumulateStateTimer)
    self:RemoveTimer(self.PlayReloadAnimTimer)
    self:RemoveTimer(self.LerpSetAmmoBarPercentTimer)
    self.ChangeAimStarColorAndShowBillboardTimer = nil
    self.UpdateDiffusionStateTimer = nil
    self.UpdateAccumulateStateTimer = nil
    self.PlayReloadAnimTimer = nil
    self.LerpSetAmmoBarPercentTimer = nil
end

function WBP_TakeAimIndicator_C:ShowBulletJumpAim()
    self.InBulletJumpMode = true
    if self.CurPanel then
        self.CurPanel:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.AmmoBarPanel then
        self.AmmoBarPanel:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if not self.Aim_BulletJump then
        self.Aim_BulletJump = UIManager(self):_CreateWidgetNew("BattleAimBulletJump")
        self.Aim_Ranged:AddChild(self.Aim_BulletJump)
    end
    self.Aim_BulletJump:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function WBP_TakeAimIndicator_C:HideBulletJumpAim()
    self.InBulletJumpMode = false
    if self.Aim_BulletJump then
        self.Aim_BulletJump:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.CurPanel then
        self.CurPanel:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
    if self.AmmoBarPanel then
        self.AmmoBarPanel:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
end

AssembleComponents(WBP_TakeAimIndicator_C)
return WBP_TakeAimIndicator_C

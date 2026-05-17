--
-- DESCRIPTION
-- 手机端射击按钮
-- @COMPANY **
-- @AUTHOR Zhu Yuhao
-- @DATE ${date} ${time}
--
require "UnLua"
local EMCache = require "EMCache.EMCache"

---@type Atk_Ranged_Phone_C
local M = Class("BluePrints.UI.BP_UIState_C")

M._components = {
    "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent",
}

function M:Initialize(Initializer)
    self.CircleLimitArea = 55
    self.LocalTurnSpeed_Horizontal = 4.5
    self.LocalTurnSpeed_Vertical = 2
    self.DefaultEdgeWidth = 60
    self.LerpTime = 1.5
    self.YawRotateSpeed = 30
    self.BtnHoldCD = 3 -- 长按3秒就锁定射击
    self.OccupiedTag = "Right"
    self.EdgeWidth = 60
end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self.CurButtonState = "Normal" 
    self.ImageMat = self.Image_Main:GetDynamicMaterial()
    self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
    local LockShooting = EMCache:Get("LongPressLockShooting")
    if LockShooting == nil then
        local DefaultValue = DataMgr.Option["LongPressLockShooting"].DefaultValueM
        local ToBool = DefaultValue == "True" and true or false
        EMCache:Set("LongPressLockShooting", ToBool)
    end
    
end

function M:Tick(MyGeometry, InDeltaTime)
    if (self.AutoYawRotate and self.YawDirection) then
        local YawSpeed = self.YawRotateSpeed
        if (self.YawDirection < 0) then
            YawSpeed = -self.YawRotateSpeed
        end
        if(self.PassedTime < self.LerpTime) then
            self.PassedTime = self.PassedTime + InDeltaTime
            local Alpha = self.PassedTime / self.LerpTime
            Alpha = math.clamp(Alpha, 0, 1)
            YawSpeed = UE4.UKismetMathLibrary.Ease(self.LastYawSpeed, YawSpeed, Alpha, UE4.EEasingFunc.EaseOut)
        end
        self.OwnerPlayer:AddControllerYawInput(YawSpeed * InDeltaTime)
    end
end

function M.ButtonFireDown(Battle_Button_Phone, Index, StartPos)
    local FireBtn = Battle_Button_Phone.AtkRanged -- 由于在Battle_Button_Phone挂的回调，因此self是Battle_Button_Phone,需要再取FireBtn,下同
    -- 逻辑层
    if not FireBtn.OwnerPanel.FireOccupied then
        FireBtn.OwnerPanel.FireOccupied = FireBtn.OccupiedTag
        FireBtn.OwnerPanel:TryToPlayTargetCommand("Fire", true)
        FireBtn.LockShooting = EMCache:Get("LongPressLockShooting")
        if FireBtn.LockShooting and not FireBtn.HasHeavyShooting then
            FireBtn.StartTime = UE4.UGameplayStatics.GetRealTimeSeconds(FireBtn)
        end
    end
    FireBtn.IsFireDown = true
    FireBtn.ViewPortSize = UWidgetLayoutLibrary.GetViewportSize(Battle_Button_Phone)
    -- 表现层
    if FireBtn.CurButtonState == "Ban" then
        UIManager(FireBtn):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_RANGED_FORBIDDEN"))
        return
    elseif FireBtn.OwnerPlayer:CheckSkillInActive(ESkillName.Fire) then
        return
    end
    FireBtn.Joystick:SetRenderOpacity(1.0)
    FireBtn.Joystick_Border:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    if (not EMUIAnimationSubsystem:EMAnimationIsPlaying(FireBtn, FireBtn.Press)) and FireBtn.CurButtonState ~= "Forbidden" then
        EMUIAnimationSubsystem:EMPlayAnimation(FireBtn, FireBtn.Press)
        
    end
end

function M.ButtonFireMove(Battle_Button_Phone, TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos)
    local FireBtn = Battle_Button_Phone.AtkRanged
    -- 逻辑层
    local WorldDeltaTime = UE4.UGameplayStatics.GetWorldDeltaSeconds(FireBtn)
    -- Pitch轴旋转
    FireBtn.OwnerPlayer:AddCharacterPitchInput(-FireBtn.LocalTurnSpeed_Vertical * LastDeltaDis.Y * WorldDeltaTime)
    -- Yaw轴旋转特别处理
    if (TouchLocalPos.X > FireBtn.EdgeWidth and TouchLocalPos.X < FireBtn.ViewPortSize.X - FireBtn.EdgeWidth) then
        FireBtn.AutoYawRotate = false
        FireBtn.LastYawSpeed = FireBtn.LocalTurnSpeed_Horizontal * LastDeltaDis.X
        FireBtn.OwnerPlayer:AddCharacterYawInput(FireBtn.LastYawSpeed * WorldDeltaTime)
        FireBtn.PassedTime = 0
        FireBtn.YawDirection = TotalDeltaDis.X
    else
        FireBtn.AutoYawRotate = true
    end
    -- 表现层
    if FireBtn.CurButtonState == "Forbidden" or FireBtn.CurButtonState == "Ban" or FireBtn.CurButtonState == "Empty" then
        return
    end
    if FireBtn.CurButtonState ~= "Forbidden" and FireBtn.LastButtonState == "Forbidden" then
        if (not EMUIAnimationSubsystem:EMAnimationIsPlaying(FireBtn, FireBtn.Press)) then
            EMUIAnimationSubsystem:EMPlayAnimation(FireBtn, FireBtn.Press)
            FireBtn.Joystick:SetRenderOpacity(1.0)
            FireBtn.Joystick_Border:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
    end
    if FireBtn.CurButtonState ~= "ChangeMagazine" and FireBtn.LastButtonState == "ChangeMagazine" then
        if (not EMUIAnimationSubsystem:EMAnimationIsPlaying(FireBtn, FireBtn.Press)) then
            EMUIAnimationSubsystem:EMPlayAnimation(FireBtn, FireBtn.Press)
            FireBtn.Joystick:SetRenderOpacity(1.0)
            FireBtn.Joystick_Border:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
    end
    FireBtn.LastButtonState = FireBtn.CurButtonState
    local FinalAngle = FireBtn:CalcFinalAngle(LastPos)
    FireBtn.Joystick_Border:SetRenderTransformAngle(FinalAngle)
end

function M.ButtonFireUp(Battle_Button_Phone, Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis)
    local FireBtn = Battle_Button_Phone.AtkRanged
    -- 逻辑层
    if FireBtn.OwnerPanel.FireOccupied == FireBtn.OccupiedTag then
        FireBtn.OwnerPanel.FireOccupied = nil
        if FireBtn.LockShooting and FireBtn.OwnerPlayer:CharacterInTag("Shooting") and not FireBtn.HasHeavyShooting then
            FireBtn.CurrentTime = UE4.UGameplayStatics.GetRealTimeSeconds(FireBtn)
            if FireBtn.CurrentTime - FireBtn.StartTime >  FireBtn.BtnHoldCD then
                FireBtn.IsLockingShoot = true
                UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText('UI_Toast_FireLocked'))
                return
            end
        end
        FireBtn.OwnerPanel:TryToStopTargetCommand("Fire", true)
    end
    
    FireBtn.AutoYawRotate = false
    FireBtn.IsFireDown = false
    FireBtn.IsLockingShoot = false
    -- 表现层
    FireBtn.Joystick:SetRenderOpacity(0)
    FireBtn.Joystick_Border:SetVisibility(UIConst.VisibilityOp["Hidden"])
    if (FireBtn.CurButtonState ~= "Forbidden" and FireBtn.CurButtonState ~= "Ban" and FireBtn.CurButtonState ~= "Empty") then
        if EMUIAnimationSubsystem:EMAnimationIsPlaying(FireBtn, FireBtn.Press) then
            EMUIAnimationSubsystem:EMStopAnimation(FireBtn,FireBtn.Press)
        end
        EMUIAnimationSubsystem:EMPlayAnimation(FireBtn, FireBtn.Click)
        FireBtn:AddTimer(FireBtn.Click:GetEndTime(), function()
            EMUIAnimationSubsystem:EMPlayAnimation(FireBtn, FireBtn.Normal)
        end)
    end
end

-- 用于更换武器icon
function M:UpdateWeaponIcon()
    local RangedWeapon
    local WeaponId
    local IsUltra = false
    -- 判断是否在用远程的显赫武器
    if (self.OwnerPlayer.BuffManager.UseSummonWeapon ~= -1) then
        WeaponId = self.OwnerPlayer.UltraWeapon.WeaponId
        local WeaponTags = DataMgr.BattleWeapon[WeaponId].WeaponTag
        if (CommonUtils.HasValue(WeaponTags, "Ranged")) then
            RangedWeapon = self.OwnerPlayer.UltraWeapon
            IsUltra = true
        else
            RangedWeapon = self.OwnerPlayer.RangedWeapon
        end
    else
        RangedWeapon = self.OwnerPlayer.RangedWeapon
    end
    if (not IsValid(RangedWeapon)) then
        self.RangedWeapon = nil
        return
    end
    self.RangedWeapon = RangedWeapon
    self.WeaponId = RangedWeapon.WeaponId
    local BattleWeaponConfig = DataMgr.BattleWeapon[self.WeaponId]
    local WeaponHUDIcon = nil
    if (BattleWeaponConfig ~= nil and BattleWeaponConfig.WeaponHUDIcon ~= nil) then
        WeaponHUDIcon = "/Game/UI/Texture/Dynamic/Atlas/Battle/Weapon/T_"..BattleWeaponConfig.WeaponHUDIcon
    else
        WeaponHUDIcon = "/Game/UI/Texture/Dynamic/Atlas/Battle/Weapon/T_Crossbow_Chixing.T_Crossbow_Chixing"
    end
    self.WeaponHUDIcon = WeaponHUDIcon
    if self.OwnerPlayer.ActivePropEffectId ~= -1 then --如果当前还在使用道具,则延迟替换Icon
        return
    end
    self.LoadResourceID = nil
    local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self,WeaponHUDIcon,{self,M.OnWeaponHUDIconLoadFinish})
    if Handle then
        self.LoadResourceID = Handle.ResourceID
    end
    --self.Image_Main:SetBrushResourceObject(LoadObject(WeaponHUDIcon))
    self:GetCurrentWeaponHeavyShooting(IsUltra)
end

function M:GetCurrentWeaponHeavyShooting(IsUltra)
    local SkillId
    if IsUltra then
        SkillId = self.OwnerPlayer:GetSkillByTypeAndOwner(ESkillType.HeavyShooting, "UltraWeapon")
    else
        SkillId = self.OwnerPlayer:GetSkillByTypeAndOwner(ESkillType.HeavyShooting, "RangedWeapon")
    end
    if SkillId ~= 0 then
        self.HasHeavyShooting = true
    else
        self.HasHeavyShooting = false
    end
end

function M:OnWeaponHUDIconLoadFinish(Object,ResourceID)
    if not IsValid(self) or not Object or self.LoadResourceID ~= ResourceID then
        return
    end
    
    -- 更新左侧射击键
    self.OwnerPanel.AtkRangedLeft:OnWeaponHUDIconLoadFinish(Object)
    --
    
    self:WeaponIcon() -- 这个函数是蓝图实现的
    self.ImageMat = self.Image_Main:GetDynamicMaterial()
    if self.ImageMat then
        self.ImageMat:SetTextureParameterValue("Icon_Ranged", Object)
    end
    self:UpdateRangeWeaponButton()
end

function M:OnPropIconLoadFinish(Object,ResourceID)
    if not IsValid(self) or not Object or self.LoadPropResourceID ~= ResourceID then
        return
    end
    self:OrganIcon(Object) -- 这个函数是蓝图实现的
    self.ImageMat = self.Image_Main:GetDynamicMaterial()
    -- 更新左侧射击键
    self.OwnerPanel.AtkRangedLeft:OnPropIconLoadFinish(Object)
end

function M:OnPropEffectReplaceFire(PropEffectId)
    local ReplaceIconPath = DataMgr.PropEffect[PropEffectId].ReplaceShootIconPath
    if not ReplaceIconPath then
        return
    end
    local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self,ReplaceIconPath,{self,M.OnPropIconLoadFinish})
    if Handle then
        self.LoadPropResourceID = Handle.ResourceID
    end
end

function M:OnPropEffectEndReplaceFire()
    if self.WeaponHUDIcon then
        local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self, self.WeaponHUDIcon,{self,M.OnWeaponHUDIconLoadFinish})
        if Handle then
            self.LoadResourceID = Handle.ResourceID
        end
    end
end

function M:UpdateButtonInTimer()
    if self.IsLockingShoot and self.OwnerPlayer:GetCharacterTag() ~= 'Shooting' then
        self.ButtonFireUp(self.OwnerPanel)
    end
end

-- 用于根据子弹数切换按钮状态
function M:UpdateRangeWeaponButton()
    DebugPrint("射击键当前状态", self.CurButtonState)
    if (not self.RangedWeapon) then
        return
    end
    if self.CurButtonState == "Empty" then
        self.ImageMat:SetScalarParameterValue("IconState", 0)
        self:ChangeLeftShootState()
        return
    end
    local MagazineBulletNum = self.RangedWeapon:GetAttr("MagazineBulletNum")
    local BulletNum = self.RangedWeapon:GetAttr("BulletNum")
    if (MagazineBulletNum == 0 and BulletNum == 0) then
        self.CurButtonState = "Forbidden"
        self:ChangeLeftShootState()
        if (not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Forbidden)) then
            self.Joystick:SetRenderOpacity(0)
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Forbidden)
        end
    elseif (MagazineBulletNum == 0) then
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
        self.CurButtonState = "ChangeMagazine"
        self:ChangeLeftShootState()
        self.ImageMat:SetScalarParameterValue("IconState", 1)
    else
        self.ImageMat:SetScalarParameterValue("IconState", 2)
        self.CurButtonState = "Normal"
        self:ChangeLeftShootState()
        self:StopAllAnimations()
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
        self.Image_Main:SetRenderOpacity(1.0)
        if self.IsFireDown then
            self.Joystick:SetRenderOpacity(1)
        end
    end
end

function M:ChangeLeftShootState()
    if not self.OwnerPanel.HasLeftShoot then
        return
    end
    self.OwnerPanel.AtkRangedLeft:UpdateRangeWeaponButtonByState(self.CurButtonState)
end

function M:CalcFinalAngle(LastPos)
    local DirectionVec = FVector2D(LastPos.X, -LastPos.Y)
    DirectionVec:Normalize()
    local SinValue = DirectionVec.X / 1.0
    local Angle, FinalAngle = math.asin(SinValue) / math.pi, 0
    if (DirectionVec.Y < 0) then
        if (DirectionVec.X < 0) then
            FinalAngle = -180 - Angle * 180
        else
            FinalAngle = 180 - Angle * 180
        end
    else
        FinalAngle = Angle * 180
    end
    return FinalAngle
end

AssembleComponents(M)

return M

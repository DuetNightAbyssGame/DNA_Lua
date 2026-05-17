--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local EMCache = require "EMCache.EMCache"

---@type WBP_Battle_Btn_Shoot_M_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.TimerMgr"})

---仅初始化lua变量时使用，千万不要有控件操作！！
function M:Initialize(Initializer)
    self.CircleLimitArea = 55
    self.LocalTurnSpeed_Horizontal = 4.5
    self.LocalTurnSpeed_Vertical = 2
    self.EdgeWidth = 60
    self.LerpTime = 1.5
    self.YawRotateSpeed = 30
    self.BtnHoldCD = 3 -- 长按3秒就锁定射击
end

-- function M:Construct()
-- end

function M:Tick(MyGeometry, InDeltaTime)
    if (self.AutoYawRotate) then
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
    local FireBtn = Battle_Button_Phone.Btn_Shoot -- 由于在Battle_Button_Phone挂的回调，因此self是Battle_Button_Phone,需要再取FireBtn,下同
    -- 逻辑层
    FireBtn.LockShooting = EMCache:Get("LongPressLockShooting")
    if FireBtn.LockShooting then
        FireBtn.StartTime = UE4.UGameplayStatics.GetRealTimeSeconds(FireBtn)
    end
    FireBtn.IsFireDown = true
    FireBtn.OwnerPanel:TryToPlayTargetCommand("Fire", true)
    FireBtn.ViewPortSize = UWidgetLayoutLibrary.GetViewportSize(Battle_Button_Phone)
    -- 表现层
    --if FireBtn.CurButtonState == "Ban" then
    --    UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_RANGED_FORBIDDEN"))
    --    return
    --elseif FireBtn.OwnerPlayer:CheckSkillInActive(ESkillName.Fire) then
    --    return
    --end
    if (not EMUIAnimationSubsystem:EMAnimationIsPlaying(FireBtn, FireBtn.Press)) then
        EMUIAnimationSubsystem:EMPlayAnimation(FireBtn, FireBtn.Press)
        FireBtn.Joystick:SetRenderOpacity(1.0)
        FireBtn.Joystick_Border:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end
end

function M.ButtonFireMove(Battle_Button_Phone, TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos)
    DebugPrint("ButtonFireMove")
    local FireBtn = Battle_Button_Phone.Btn_Shoot
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
    --if FireBtn.CurButtonState == "Forbidden" or FireBtn.CurButtonState == "Ban" or FireBtn.CurButtonState == "Empty" then
    --    return
    --end
    --if FireBtn.CurButtonState ~= "Forbidden" and FireBtn.LastButtonState == "Forbidden" then
    --    if (not EMUIAnimationSubsystem:EMAnimationIsPlaying(FireBtn, FireBtn.Press)) then
    --        EMUIAnimationSubsystem:EMPlayAnimation(FireBtn, FireBtn.Press)
    --        FireBtn.Joystick:SetRenderOpacity(1.0)
    --        FireBtn.Joystick_Border:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    --    end
    --end
    --if FireBtn.CurButtonState ~= "ChangeMagazine" and FireBtn.LastButtonState == "ChangeMagazine" then
    --    if (not EMUIAnimationSubsystem:EMAnimationIsPlaying(FireBtn, FireBtn.Press)) then
    --        EMUIAnimationSubsystem:EMPlayAnimation(FireBtn, FireBtn.Press)
    --        FireBtn.Joystick:SetRenderOpacity(1.0)
    --        FireBtn.Joystick_Border:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    --    end
    --end
    --FireBtn.LastButtonState = FireBtn.CurButtonState
    local FinalAngle = FireBtn:CalcFinalAngle(LastPos)
    FireBtn.Joystick_Border:SetRenderTransformAngle(FinalAngle)
end

function M.ButtonFireUp(Battle_Button_Phone, Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis)
    local FireBtn = Battle_Button_Phone.Btn_Shoot
    -- 逻辑层
    if FireBtn.LockShooting and FireBtn.OwnerPlayer:CharacterInTag("Shooting") then
        FireBtn.CurrentTime = UE4.UGameplayStatics.GetRealTimeSeconds(FireBtn)
        if FireBtn.CurrentTime - FireBtn.StartTime >  FireBtn.BtnHoldCD then
            FireBtn.IsLockingShoot = true
            return
        end
    end
    FireBtn.OwnerPanel:TryToStopTargetCommand("Fire", true)
    FireBtn.AutoYawRotate = false
    FireBtn.IsFireDown = false
    FireBtn.IsLockingShoot = false
    -- 表现层
    FireBtn.Joystick:SetRenderOpacity(0)
    FireBtn.Joystick_Border:SetVisibility(UIConst.VisibilityOp["Hidden"])
    EMUIAnimationSubsystem:EMPlayAnimation(FireBtn, FireBtn.Click)
    FireBtn:AddTimer(FireBtn.Click:GetEndTime(), function()
        EMUIAnimationSubsystem:EMPlayAnimation(FireBtn, FireBtn.Normal)
    end)
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

--function M:Destruct()
--end


return M

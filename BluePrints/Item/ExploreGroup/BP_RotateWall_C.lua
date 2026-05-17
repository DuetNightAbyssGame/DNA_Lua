--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_RotateWall_C
local M = Class("BluePrints/Item/BP_CombatItemBase_C")

function M:ReceiveBeginPlay()
    self.Super.ReceiveBeginPlay(self)
    self.InitRotate = self:K2_GetActorRotation()
    self.HasFireEvent1 = false
    self.HasFireEvent2 = false
end

function M:ReceiveTick(DeltaSeconds)
    self.Overridden.ReceiveTick(self, DeltaSeconds)

    local CurYaw = self.CurRotate.Yaw
    local TargetYaw = self.InitRotate.Yaw

    -- 使用 FixedTurn 实现就近旋转
    local NewYaw = UE4.UKismetMathLibrary.FixedTurn(CurYaw, TargetYaw, self.ReturnSpeed * DeltaSeconds)

    -- 更新当前旋转
    self.CurRotate.Yaw = NewYaw
    self:K2_SetActorRotation(self.CurRotate, false, nil, false)
end

function M:CheckAngle(RotateFactor)
    -- 判断旋转角度
    local CurYaw = self:K2_GetActorRotation().Yaw
    local InitYaw = self.InitRotate.Yaw
    -- 计算两个 yaw 之间的差异
    local YawDifference = InitYaw - CurYaw
    -- 归一化角度差异，确保差值位于 [-180, 180] 范围内
    YawDifference = (YawDifference + 180) % 360 - 180

    if not self.HasFireEvent1 and YawDifference <= -self.MaxAngle then
        self.HasFireEvent1 = true
        self:FireCustomEvent(self.EventName1)
    end
    if not self.HasFireEvent2 and YawDifference >= self.MaxAngle then
        self.HasFireEvent2 = true
        self:FireCustomEvent(self.EventName2)
    end
    -- 判断是否小于给定阈值
    if math.abs(YawDifference) <= self.MaxAngle or self.RotateFactor ~= RotateFactor then
        self.RotateFactor = RotateFactor
        return true
    end
    self.RotateFactor = RotateFactor
    return false
end

function M:AddRot(DeltaRot)
    -- self:K2_AddActorWorldRotation(DeltaRot, false, nil, false)

    local CurRot = self:K2_GetActorRotation()
    local FinalYaw = CurRot.Yaw + DeltaRot.Yaw
    if FinalYaw > self.MaxAngle then
        FinalYaw = self.MaxAngle - 0.001
        if not self.HasFireEvent1 then
            self.HasFireEvent1 = true
            self:FireCustomEvent(self.EventName1)
        end
    elseif FinalYaw < -self.MaxAngle then
        FinalYaw = -self.MaxAngle + 0.001
        if not self.HasFireEvent2 then
            self.HasFireEvent2 = true
            self:FireCustomEvent(self.EventName2)
        end
    end

    -- 构造最终Rotator（只限制Yaw）
    local FinalRot = UE.FRotator(
        CurRot.Pitch,
        FinalYaw,
        CurRot.Roll
    )

    self:K2_SetActorRotation(FinalRot, false, nil, false)
end

function M:ActiveCombat()
    self.Super.ActiveCombat(self)
    self:SetActorTickEnabled(false)
end

function M:DeActiveCombat()
    self.Super.DeActiveCombat(self)
    self.CurRotate = self:K2_GetActorRotation()
    self:SetActorTickEnabled(true)
end

function M:FireCustomEvent(EventName)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then
        return
    end
    DebugPrint("RotateWall FireCustomEvent", EventName)
    GameMode:PostCustomEvent(EventName)
end

return M

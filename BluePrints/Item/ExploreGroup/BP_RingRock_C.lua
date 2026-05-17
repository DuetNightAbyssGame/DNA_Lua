--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
---@type BP_RingRock_C
local M = Class({
    "BluePrints.Item.ExploreGroup.BP_DongGuoBreakableItem_C",
    "BluePrints.Common.TimerMgr"
})

function M:ReceiveBeginPlay()
    self.Super.ReceiveBeginPlay(self)
    self.InitLoc = self.Mesh:K2_GetComponentLocation()
    self.EndLoc = self.InitLoc + self.Arrow:GetForwardVector() * self.MaxDistance
    self.Finish = false
    self.AlreadyPull = false  -- 记录一下是否被拉动过
    self.IsInReset = false
    self.InitForward = self.Arrow:GetForwardVector()
end

function M:ReceiveTick(DeltaSeconds)
    self.Overridden.ReceiveTick(self, DeltaSeconds)
    local CurLocation = self.Rock:K2_GetComponentLocation()
    if not self.IsInReset then
        local AimLocation = CurLocation + self.Arrow:GetForwardVector() * self.PullSpeed * DeltaSeconds
        if UE4.UKismetMathLibrary.Vector_Distance(self.InitLoc, AimLocation) >= self.MaxDistance then
            self.Rock:K2_SetWorldLocation(self.EndLoc, false, nil, false)
            self.Finish = true
            self:SetActorTickEnabled(false)
            DebugPrint("zzz222 发出OnRingRockFinish", self.Eid)
            EventManager:FireEvent(EventID.OnRingRockFinish, self.IsRightOne, self.Eid)
        else
            self.Rock:K2_SetWorldLocation(AimLocation, false, nil, false)
        end
    else
        -- 归位中的tick
        local AimLocation = CurLocation - self.Arrow:GetForwardVector() * self.ResetSpeed * DeltaSeconds
        if UE4.UKismetMathLibrary.Vector_Distance(self.InitLoc, AimLocation) <= self.MinDistance then
            self.Rock:K2_SetWorldLocation(self.InitLoc, false, nil, false)
            self.IsInReset = false
            self:SetActorTickEnabled(false)
        else
            self.Rock:K2_SetWorldLocation(AimLocation, false, nil, false)
        end
    end
end

function M:CheckPlayerFaceToAim(SourceId)
    -- 检验角色是否在石块前方且未处于归为状态
    if self.IsInReset then
        return false
    end
    local Player = Battle(self):GetEntity(SourceId)
    if Player and Player.IsPlayer and Player:IsPlayer() and not Player:IsDead() then
        local ForwardVector = self.Arrow:GetForwardVector()
        local DirectionVector = Player:K2_GetActorLocation() - self.Rock:K2_GetComponentLocation()
        DirectionVector:Normalize()
        local Dot = UE4.UKismetMathLibrary.Dot_VectorVector(ForwardVector, DirectionVector)
        local InitDot = UE4.UKismetMathLibrary.Dot_VectorVector(self.InitForward, DirectionVector)
        if Dot > 0 and InitDot > 0 then
            return true
        end
    end
    return false
end

function M:OnValidHit()
    -- 被东国枪击中，添加定时器，一段时间后没被击就让能量归0
    local function ResetState()
        self.Energy = 0
    end
    if self.Energy < self.MaxEnergy then
        self:AddTimer(self.WaitTime, ResetState, false, 0, "ResetState")
    end
end

function M:OnMaxEnergyHit()
    -- 能量满后被击，每次被击移动一段距离
    self:RemoveTimer("ResetState")
    if self.Finish then return end
    if self.IsInReset then return end
    self:SetActorTickEnabled(true)
    self.AlreadyPull = true
    local function DisableTick()
        if self.IsInReset then return end
        self:SetActorTickEnabled(false)
    end
    self:AddTimer(self.SpecialWaitTime, DisableTick, false, 0, "DisableTick")
end

function M:StartReset()
    -- local CurLoc = self.Rock:K2_GetComponentLocation()
    -- local Distance = UE4.UKismetMathLibrary.Vector_Distance(self.InitLoc, CurLoc)
    -- if Distance <= self.MinDistance then
    --     self.Rock:K2_SetWorldLocation(self.InitLoc, false, nil, false)
    --     return
    -- end
    -- local Times = self.ResetTime / 0.02
    -- local PerDistance = Distance / Times
    -- local function Reset()
    --     self.Rock:K2_AddWorldOffset(-self.Arrow:GetForwardVector() * PerDistance)
    --     Times = Times - 1
    --     if Times <= 0 then
    --         self.Rock:K2_SetWorldLocation(self.InitLoc, false, nil, false)
    --         self:RemoveTimer("Reset")
    --     end
    -- end
    -- self:AddTimer(0.02, Reset, true, 0, "Reset")

    -- 开始归位
    self:SetActorTickEnabled(true)
end

return M

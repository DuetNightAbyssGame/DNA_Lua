--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
---@type BP_RotateFan_C
local M = Class({
    "BluePrints.Item.ExploreGroup.BP_DongGuoBreakableItem_C",
    "BluePrints.Common.TimerMgr"
})

function M:ReceiveBeginPlay()
    self.Super.ReceiveBeginPlay(self)
    self.PlayerInRight = true
    if self.RotateDirection then
        self.RotateSpeed = -self.RotateSpeed
        self.RelativeActorRot = UE4.FRotator(0, self.RelativeActorSpeed, 0)
    else
        self.RelativeActorRot = UE4.FRotator(0, -self.RelativeActorSpeed, 0)
    end
    self.RotateFactor = -1
    self.Reverse = false
    self.IsChangeDir = false
    self.ActorReverse = 1
    if self.RelativeActorReverse then
        self.ActorReverse = -1
    end
    self.InitRotate = self.Fan:K2_GetComponentRotation():ToQuat()
end

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    self.SequenceId = self.UnitParams["SequenceId"] or 1
    self.RotateCreatorId = self.UnitParams["RotateCreatorId"] or -1
end

function M:ReceiveTick(DeltaSeconds)
    self.Overridden.ReceiveTick(self, DeltaSeconds)

    if self.IsInReturn then
        -- -- 正在回归初始点
        -- local CurPitch = self.CurRotate.Pitch
        -- local TargetPitch = self.InitRotate.Pitch
    
        -- -- 使用 FixedTurn 实现就近旋转
        -- local NewPitch = UE4.UKismetMathLibrary.FixedTurn(CurPitch, TargetPitch, self.ReturnSpeed * DeltaSeconds)
    
        -- -- 更新当前旋转
        -- self.CurRotate.Pitch = NewPitch
        -- self.Fan:K2_SetRelativeRotation(self.CurRotate, false, nil, false)

        self:RotateComponent(DeltaSeconds, self.ReturnSpeed, self.InitRotate, self.Fan)
        return
    end

    local CurrentLocation = self.Fan:K2_GetComponentLocation()
    local CurrentRotation = self.Fan:K2_GetComponentRotation():ToQuat()
    local RightVector = self.Fan:GetRightVector()
    local AngleRad = math.rad(-self.RotateSpeed * DeltaSeconds * self.RotateFactor)
    local DeltaQuat = self:GetQuat_Lua(RightVector, AngleRad)
    local NewQuat = DeltaQuat * CurrentRotation
    local NewTransform = FTransform()
    NewTransform.Translation = CurrentLocation
    NewTransform.Rotation = NewQuat
    self.Fan:K2_SetWorldTransform(NewTransform, false, nil, false)

    self:TryGetRelativeActor()
    if self.RelativeActor ~= nil and self.RelativeActor.IsActive and self.RelativeActor.AddRot then
        self.RelativeActor:AddRot(self.RelativeActorRot * self.ActorReverse * DeltaSeconds * self.RotateFactor)
    end
end

function M:OnHit(SourceId)
    -- 判断受击方向
    local Player = Battle(self):GetEntity(SourceId)
    if Player and Player.IsPlayer and Player:IsPlayer() and not Player:IsDead() then
        local RightVector = -self:GetActorForwardVector()  -- 新模型摆放更改，取Actor的Forward向量
        local DirectionVector = Player:K2_GetActorLocation() - self.Fan:K2_GetComponentLocation()
        DirectionVector:Normalize()
        local Dot = UE4.UKismetMathLibrary.Dot_VectorVector(RightVector, DirectionVector)
        -- DebugPrint("zwkkk 风扇 OnHit", Dot, RightVector, DirectionVector)
        if Dot > 0 then
            -- if not self.IsChangeDir then
            --     self.IsChangeDir = false
            if self.RotateFactor == -1 then
                self.IsChangeDir = true
            else
                self.IsChangeDir = false
            end
            self.RotateFactor = 1
            self.Reverse = false
        else
            -- if not self.IsChangeDir then
            --     self.IsChangeDir = false
            if self.RotateFactor == 1 then
                self.IsChangeDir = true
            else
                self.IsChangeDir = false
            end
            self.RotateFactor = -1
            self.Reverse = true
        end


        self:TryGetRelativeActor()
        if self.RelativeActor ~= nil and self.RelativeActor.CheckAngle and self.RelativeActor:CheckAngle(self.RotateFactor) then
            -- 关联Actor旋转
            self:SetActorTickEnabled(true)
            local function DisableTick()
                if not self.IsInReturn then
                    self:SetActorTickEnabled(false)
                end
            end
            self:AddTimer(self.WaitToPauseTime, DisableTick, false, 0, "DisableTick")
        else
            -- Sequence旋转
            if not self.GameMode then
                self.GameMode = UE4.UGameplayStatics.GetGameMode(self)
            end
            if self.GameMode then
                local Avatar = GWorld:GetAvatar()
                if not Avatar or not self.GameMode:IsInRegion() then
                    return
                end

                if not self.SubRegionId then
                    self.SubRegionId = Avatar:GetSubRegionId2RegionId(Avatar.CurrentRegionId)
                end

                if not self.StateRecorder then
                    self.StateRecorder = self.GameMode:LevelSequenceState_GetStateRecorder(self.SubRegionId)
                end
                if not self.StateRecorder then return end

                DebugPrint("zwkkk 111 ", self.StateRecorder:GetSequenceState(self.SequenceId, 1), self.IsChangeDir, self.Reverse)
                if self.StateRecorder:GetSequenceState(self.SequenceId, 1) == ELevelSequenceRuntimeState.EComplete and not self.IsChangeDir then
                    return
                end

                if self.StateRecorder:GetSequenceState(self.SequenceId, 1) == ELevelSequenceRuntimeState.EDefault and self.Reverse then
                    return
                end

                self:PlaySequence()

                self:SetActorTickEnabled(true)
                local function DisableTick()
                    self:PauseSequence()
                    self:SetActorTickEnabled(false)
                end
                self:AddTimer(self.WaitToPauseTime, DisableTick, false, 0, "DisableTick")
            end
        end


    end
end

function M:PlaySequence()
    if self.StateRecorder and self.GameMode then
        self.GameMode:LevelSequenceState_PlaySequence(self.SubRegionId, self.SequenceId, 1, self.Reverse)
    end
end

function M:PauseSequence()
    if self.StateRecorder and self.GameMode then
        self.GameMode:LevelSequenceState_PauseSequence(self.SubRegionId, self.SequenceId, 1)
    end
end

function M:TryGetRelativeActor()
    if self.RelativeActor ~= nil or self.RotateCreatorId <= 0 then
        return
    end
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local StaticCreator = GameState:GetStaticCreatorInfo(self.RotateCreatorId)
    if IsValid(StaticCreator) and StaticCreator.ChildEids:Length() > 0 then
        local StaticItem = Battle(self):GetEntity(StaticCreator.ChildEids:GetRef(1))
        if IsValid(StaticItem) then
            self.RelativeActor = StaticItem
        end
    end
end

function M:ActiveCombat()
    self.Super.ActiveCombat(self)
    self.IsInReturn = false
end

function M:OnEnterState(NowStateId)
    self.Overridden.OnEnterState(self, NowStateId)

    if NowStateId == self.InReturnStateId then
        self.IsInReturn = true
        self.CurRotate = self.Fan:K2_GetComponentRotation()
        self:SetActorTickEnabled(true)
    elseif NowStateId == self.NormalStateId then
        self.IsInReturn = false
        self:SetActorTickEnabled(false)
    else
        self:SetActorTickEnabled(false)
        self.IsInReturn = false
    end
end

return M

require "UnLua"
local MiscUtils = require "Utils.MiscUtils"
local GameFlowUtils = require "Utils.GameFlowUtils"

---@class BP_SkillFeatureLevelSequenceActor_C : BP_SkillFeatureLevelSequenceActorBase_C
local M = Class("BluePrints.Combat.BP_SkillFeatureLevelSequenceActorBase_C")

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
--     if self.FeatureSequence == nil then
--         return
--     end

--     self.Super.ReceiveBeginPlay(self)

--     -- self:SetSequence(self.FeatureSequence)
--     -- self:SetInstanceData()
--     -- self:TryAttachToPlayer()
--     -- self:SetCineCameraActor()
--     -- self:ResetPlayerSpeed()
-- end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

---@return bool
function M:IsCanPlay()
    if not self.bIsSkill then
        return true
    end

    if not self.Super.IsCanPlay(self) then
        return false
    end

    -- assert(self.TraceDensity > 0)

    local FrameLength = self.SequencePlayer:GetFrameDuration()
    -- local FrameInterval = FrameLength / self.TraceDensity

    local IgnoreActors = TArray(AActor)
    IgnoreActors:Add(self.OwnerCharacter)

    local TraceDebugType = EDrawDebugTrace.None
    if _G.DrawDebugTest then
        TraceDebugType = EDrawDebugTrace.Persistent
    end

    local StartLocation = self.CineCameraActor:K2_GetActorLocation()
    local EndLocation = self.OwnerCharacter.CurrentLocation

    local CapsuleStartLocation = StartLocation + FVector(0, 0, self.OwnerCharacter.CapsuleComponent:GetUnscaledCapsuleHalfHeight())
    local CapsuleEndLocation = CapsuleStartLocation + FVector(0, 0, 1) * self.CapsuleTraceDis

    if self.CapsuleTraceDis > 0 then
        local _, bHit = UKismetSystemLibrary.SphereTraceSingle(self, CapsuleStartLocation, CapsuleEndLocation, 
            25, ETraceTypeQuery.Camera, false, IgnoreActors, TraceDebugType, nil, true)
        if bHit then
            return false
        end
    end

    local CurrentFrame = 0
    -- while FrameLength > CurrentFrame do
    --     local PlaybackParams = FMovieSceneSequencePlaybackParams()
    --     PlaybackParams.Frame.FrameNumber.Value = MiscUtils.Int(CurrentFrame)
    --     self.SequencePlayer:SetPlaybackPosition(PlaybackParams)
    --     StartLocation = self.CineCameraActor:K2_GetActorLocation()
    --     for i = 1, self.TraceOffsets:Length() do
    --         -- local _, bIsHit = UKismetSystemLibrary.LineTraceSingle(self, StartLocation, EndLocation + self.TraceOffsets:Get(i),
    --         --     ETraceTypeQuery.Camera, false, IgnoreActors, TraceDebugType, nil, true)
    --         local _, bIsHit = UKismetSystemLibrary.SphereTraceSingle(self, StartLocation, EndLocation + self.TraceOffsets:Get(i),
    --             self.TraceRadius, ETraceTypeQuery.Camera, false, IgnoreActors, TraceDebugType, nil, true)
    --         -- local _, bIsHit = UKismetSystemLibrary.SphereTraceSingleByProfile(self, StartLocation,
    --         --     EndLocation + self.TraceOffsets:Get(i), self.TraceRadius, self.TraceProfileName, false, IgnoreActors,
    --         --     TraceDebugType, nil, true)
    --         if bIsHit then
    --             return false
    --         end
    --     end
    --     CurrentFrame = CurrentFrame + FrameInterval
    -- end
    while FrameLength > CurrentFrame do
        local PlaybackParams = FMovieSceneSequencePlaybackParams()
        PlaybackParams.Frame.FrameNumber.Value = MiscUtils.Int(CurrentFrame)
        self.SequencePlayer:SetPlaybackPosition(PlaybackParams)
        StartLocation = self.CineCameraActor:K2_GetActorLocation()
       -- local _, bIsHit = UKismetSystemLibrary.LineTraceSingle(self, StartLocation, EndLocation + self.TraceOffsets:Get(i),
            --     ETraceTypeQuery.Camera, false, IgnoreActors, TraceDebugType, nil, true)
            local _, bIsHit = UKismetSystemLibrary.SphereTraceSingle(self, EndLocation, StartLocation,
                self.TraceRadius, ETraceTypeQuery.Camera, false, IgnoreActors, TraceDebugType, nil, true)
            -- local _, bIsHit = UKismetSystemLibrary.SphereTraceSingleByProfile(self, StartLocation,
            --     EndLocation + self.TraceOffsets:Get(i), self.TraceRadius, self.TraceProfileName, false, IgnoreActors,
            --     TraceDebugType, nil, true)
            if bIsHit then
                return false
            end
        CurrentFrame = CurrentFrame + 1
        -- local PlaybackParams = FMovieSceneSequencePlaybackParams()
        -- PlaybackParams.Frame.FrameNumber.Value = MiscUtils.Int(CurrentFrame)
        -- self.SequencePlayer:SetPlaybackPosition(PlaybackParams)
    end
    if not self.bUseNewSkillFeature and self.EndBlendTime > 0 then
        local PlaybackParams = FMovieSceneSequencePlaybackParams()
        PlaybackParams.Frame.FrameNumber.Value = FrameLength
        self.SequencePlayer:SetPlaybackPosition(PlaybackParams)
        self.EndBlendCamera = self:DuplicateCameraActorOnEnd()
    end
    self.SequencePlayer:SetPlaybackPosition(FMovieSceneSequencePlaybackParams())
    return true
end

function M:HidePlayerBattlePet(IsHide)
    local BattlePet = self.OwnerCharacter:GetBattlePet()
    if BattlePet then
        BattlePet:HideBattlePet("Skill", IsHide)
    end
end

function M:StartSkillFeature()
    self.Flow = GameFlowUtils:AddFlow("SkillFeature", {
        self, function()
            -- self.OwnerCharacter:ForbidHitStop_Lua(true)
            local PlayerCameraManager = UGameplayStatics.GetPlayerCameraManager(self, 0)
            PlayerCameraManager:StopAllCameraShakes(true)
            self:RecordPlayerCamera()
            self.CacheControlRotation = self.OwnerCharacter:GetControlRotation()

            self:StartSkillFeatureCD()

            M.Super.StartSkillFeature(self)

            self:SetSkillFeatureTimeDilation()

            -- if self.EndBlendTime > 0 then
            --     self.OwnerCharacter:AddForbidTag("Battle")
            -- end
            if self.OwnerCharacter.Controller.AddDisableRotationInputTag then
                self.OwnerCharacter.Controller:AddDisableRotationInputTag("SkillFeature")
            end

            if self.bIsSkill then
                self:HidePlayerBattlePet(true)
            end
        end
    })
end

function M:EndSkillFeature()
    if self.Flow then 
		GameFlowUtils:RemoveFlow(self.Flow)
		self.Flow = nil
    end
    self.OwnerCharacter.SkillFeature = false
    if self.OwnerCharacter.RemoveTimer then
        self.OwnerCharacter:RemoveTimer("SkillFeature")
    end

    if self.OwnerCharacter.Controller and self.OwnerCharacter.Controller.RemoveDisableRotationInputTag then
        self.OwnerCharacter.Controller:RemoveDisableRotationInputTag("SkillFeature")
    end

    if IsValid(self.NewCamera) then
        self.NewCamera:K2_DestroyActor()
    end

    if IsValid(self.CameraActor) then
        self.CameraActor:K2_DestroyActor()
    end

    self:ResetCamera()

    if self.OwnerCharacter.bSkillFeatureSuccess and self.EndBlendTime > 0 then
        -- self.OwnerCharacter.ForbidInput = true
        self.OwnerCharacter.Controller:AddDisableRotationInputTag("EndSkillFeatureCamera")
        ---@type ACineCameraActor
        self.EndBlendCamera = self:DuplicateCameraActorOnEnd()
        self.EndBlendCamera:GetCineCameraComponent().FocusSettings.ManualFocusDistance = 100000
        ---@type ASinglePlayerController
        local PlayerController = self.OwnerCharacter:GetController()
        if PlayerController then
            PlayerController:ClientSetViewTarget(self.EndBlendCamera, nil)
            -- PlayerController:SetViewTargetWithBlend(self.EndBlendCamera, 0, EViewTargetBlendFunction.VTBlend_Cubic)
        end
        local OwnerCharacter = self.OwnerCharacter
        self.OwnerCharacter:AddTimer(self.EndBlendTime + 0.1, function()
            if IsValid(self.EndBlendCamera) then
                self.EndBlendCamera:K2_DestroyActor()
            end
            OwnerCharacter.Controller:RemoveDisableRotationInputTag("EndSkillFeatureCamera")
            -- OwnerCharacter:MinusForbidTag("Battle")
        end, false, 0, "EndSkillFeatureCamera")
    end
    self:HidePlayerBattlePet(false)
    
    M.Super.EndSkillFeature(self)

    self.OwnerCharacter:ForbidHitStop(false)
end

function M:DuplicateCameraActorOnEnd()
    if IsValid(self.EndBlendCamera) then
        return self.EndBlendCamera
    end
    local NewCamera
    if IsValid(self.NewCamera) then
        NewCamera = URuntimeCommonFunctionLibrary.DuplicateActor(self.NewCamera)
    else
        NewCamera = URuntimeCommonFunctionLibrary.DuplicateActor(self.CineCameraActor)
    end
    return NewCamera
end

-- function M:DoHideEffects(bHide)
--     if bHide then
--         self.HiddenEffects = TArray(UNiagaraComponent)
--         self.HiddenEffectActors = TArray(AActor)
--         local EffectsOnPlayer = TArray(UNiagaraComponent)
--         self.OwnerCharacter:K2_GetComponentsByClass(UNiagaraComponent)
--         ---@type AWorldSettings
--         local WorldSettings = URuntimeCommonFunctionLibrary.GetWorldSettsings(self)
--         if IsValid(WorldSettings) then
--             local AllEffects = TArray(UNiagaraComponent)
--             WorldSettings:K2_GetComponentsByClass(UNiagaraComponent, AllEffects)
--             for i = 1, AllEffects:Num() do
--                 ---@type UNiagaraComponent
--                 local Effect = AllEffects:Get(i)
--                 if not EffectsOnPlayer:Contains(Effect) then
--                     self.HiddenEffects:Add(Effect)
--                     Effect:SetHiddenInGame(true)
--                 end
--             end
--         end
--         UGameplayStatics.GetAllActorsOfClass(self, ANiagaraActor, self.HiddenEffectActors)
--         for i = 1, self.HiddenEffectActors:Num() do
--             self.HiddenEffectActors:GetRef(i):SetActorHiddenInGame(true)
--         end
--     elseif self.HiddenEffects then
--         for i = 1, self.HiddenEffects:Num() do
--             ---@type UNiagaraComponent
--             local Effect = self.HiddenEffects:Get(i)
--             if IsValid(Effect) then
--                 Effect:SetHiddenInGame(false)
--             end
--         end
--         for i = 1, self.HiddenEffectActors:Num() do
--             local Actor = self.HiddenEffectActors:GetRef(i)
--             if IsValid(Actor) then
--                 Actor:SetActorHiddenInGame(false)
--             end
--         end
--     end

-- end

return M

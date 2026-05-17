local M = Class( {
    "BluePrints.Common.TimerMgr",
    "BluePrints.Common.DelayFrameComponent"
})
function M:InitializeLua(TalkTask)
    self.TalkTask = TalkTask
    -- self.DialogueRecordComponent = TalkTask.DialogueRecordComponent
    -- self.DialogueFlowGraphComponent = TalkTask.DialogueFlowGraphComponent
    self.SaveTickOptimizations = nil
    self.RecoverTimer = nil
    self.OnFinish:Add(self, self.OnFinishEvent)
    self.CachedNpcTransforms = {}
end

function M:IsFinish()
    return self:IsActive()
end

function M:GetTalkActorData()
    if self.CreatTalkActors then
        return self.CreatTalkActors
    end
    local TalkActors = {}
    local RawTalkActors = self.TalkActors:ToTable()
    for _, RawTalkActor in pairs(RawTalkActors) do
        if RawTalkActor.Type == ETalkActorType.Player then
            table.insert(TalkActors, {
                TalkActorType = "Player",
				TalkActorId = 0,
				TalkActorVisible = RawTalkActor.Visibility,
                Source = "FlowAsset"
            })
        else
            table.insert(TalkActors, {
                TalkActorType = "Npc",
				TalkActorId = RawTalkActor.UnitId,
				TalkActorVisible = RawTalkActor.Visibility,
                Source = "FlowAsset"
            })
        end
    end
    self.CreatTalkActors = TalkActors
    return TalkActors
end
-- 回退标记
function M:SetRestartDialogueId(DialogueId)
    self.RestartDialogueId = DialogueId
end

function M:SetSkipInRestartTag(bTag)
    self.bIsInRestartDialogueSkip = bTag
end

function M:OnSequenceCameraChanged(CameraComponent)
    if not IsValid(CameraComponent) then
        return
    end

    self:CloseTalkActorsOptimization()
end

function M:CloseTalkActorsOptimization()

    if not self.TalkTask then
        return
    end
    local TalkTask = self.TalkTask
    local TalkContext = TalkTask.TalkContext

    if not TalkContext then
        return
    end

    if self.RecoverTimer then
        self:RemoveTimer(self.RecoverTimer)
        self.RecoverTimer = nil
    end

    self.RecoverTimer = self:AddTimer(0.1, function()
        self:RecoverTalkActorsOptimization()
    end)

    if self.SaveTickOptimizations then
        return
    end
    
    local SaveTickOptimizations = {}
    self.SaveTickOptimizations = SaveTickOptimizations
    for _, NpcData in pairs(TalkTask.TalkTaskData.TalkActors) do
        local UnitId = NpcData.TalkActorId
        local TalkActorData = TalkContext:GetTalkActorData(TalkTask, UnitId)
        local TalkActor = TalkActorData and TalkActorData.TalkActor
        if IsValid(TalkActor) and IsValid(TalkActor.Mesh) then
			SaveTickOptimizations[TalkActor] = TalkActor.Mesh.VisibilityBasedAnimTickOption
            TalkActor.Mesh.VisibilityBasedAnimTickOption = UE4.EVisibilityBasedAnimTickOption.AlwaysTickPoseAndRefreshBones
            if TalkActor.ForceResetDynamics and not TalkActor.Mesh:WasRecentlyRendered(0.05) then
                TalkActor:ForceResetDynamics()
                USequenceMontageLibrary.ForceRefreshAnimation(TalkActor)
            end
        end
    end
end

function M:OnFinishEvent()
    self:RecoverTalkActorsOptimization()
    self:ResetNpcTransform()
end

function M:RecoverTalkActorsOptimization()
    if self.RecoverTimer then
        self:RemoveTimer(self.RecoverTimer)
        self.RecoverTimer = nil
    end

    if not self.SaveTickOptimizations then
        return
    end

    local SaveTickOptimizations = self.SaveTickOptimizations
    self.SaveTickOptimizations = nil

    for TalkActor, TickOption in pairs(SaveTickOptimizations) do
        if IsValid(TalkActor) and IsValid(TalkActor.Mesh) then
            TalkActor.Mesh.VisibilityBasedAnimTickOption = TickOption
        end
    end
end

function M:TryCacheNpcTransform(Npc)
    if not Npc or not IsValid(Npc) then
        return
    end
    if self.CachedNpcTransforms[Npc] then
        return
    end
    self.CachedNpcTransforms[Npc] = Npc:GetTransform()
end

function M:TryRecoverNpcTransform(Npc)
    if not Npc or not IsValid(Npc) then
        return
    end
    if not self.CachedNpcTransforms[Npc] then
        return
    end
    Npc:K2_SetActorTransform(self.CachedNpcTransforms[Npc], false, nil, true)
    self.CachedNpcTransforms[Npc] = nil
end

function M:ResetNpcTransform()
    for Npc, _ in pairs(self.CachedNpcTransforms) do
        self:TryRecoverNpcTransform(Npc)
    end
end

return M
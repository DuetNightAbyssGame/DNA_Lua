local BP_TalkObject = Class()


function BP_TalkObject:InitNew(Context)
    self.UnitInfo = Context
    local Unit = DataMgr.NPC[Context.UnitId]
    self.UnitId = Context.UnitId
    self.NpcId = Context.UnitId
    self.UnitType = Context.UnitType
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState then
        GameState.TalkObjectMap:Add(Context.UnitId, self)
    end
    self.Eid = Context.IntParams:Find("Eid") or GameMode:GetBattleEid()
    Battle(self):AddEntity(self.Eid, self)
    if IsValid(Context.Creator) then
        Context.Creator:SetCreatorInfo(self)
    end
    if IsValid(self.TalkObjectInteractiveComponent) then      
        local TalkInfo = {}
        TalkInfo.InteractiveId = Unit.UnitName
        TalkInfo.InteractiveDistance = self.InteractiveDistance
        self.TalkObjectInteractiveComponent:SetInteractiveInfo(TalkInfo)
    end
    self:ResetLocation()
    if Context.OnUnitInitCreateReadyDynamic and Context.OnUnitInitCreateReadyDynamic:IsBound() then
        Context.OnUnitInitCreateReadyDynamic:Broadcast(self)
    end
end

function BP_TalkObject:Init(Info)
    self.UnitInfo = Info
    local Unit = DataMgr.NPC[Info.UnitId]
    self.UnitId = Info.UnitId
    self.NpcId = Info.UnitId
    self.UnitType = Info.UnitType
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState then
        GameState.TalkObjectMap:Add(Info.UnitId, self)
    end
    self.Eid = Info.Eid or GameMode:GetBattleEid()
    Battle(self):AddEntity(self.Eid, self)
    if IsValid(Info.Creator) then
        Info.Creator:SetCreatorInfo(self)
    end
    if IsValid(self.TalkObjectInteractiveComponent) then      
        local TalkInfo = {}
        TalkInfo.InteractiveId = Unit.UnitName
        TalkInfo.InteractiveDistance = self.InteractiveDistance
        self.TalkObjectInteractiveComponent:SetInteractiveInfo(TalkInfo)
    end
    self:ResetLocation()
    if Info.LoadFinishCallback then
    	Info.LoadFinishCallback(self)
    end
end

function BP_TalkObject:EMActorDestroy(DestroyReason)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    self.UnitInfo.Creator:RemoveActorToChildEids(self.Eid)
    GameState.TalkObjectMap:Remove(self.UnitId)
    self.UnitInfo = nil
    self:K2_DestroyActor()
end

function BP_TalkObject:GetTalkInteractiveComponent()
    return self.TalkObjectInteractiveComponent
end

function BP_TalkObject:PreExitStory()
end

function BP_TalkObject:ResetLocation()
	local SpawnPos = self:K2_GetActorLocation()
	local HalfHeight = self.CapsuleComponent:GetScaledCapsuleHalfHeight()
	-- local MeshOffsetZ = -self.Mesh.RelativeLocation.Z
    -- if MeshOffsetZ > HalfHeight and MeshOffsetZ < HalfHeight + 5 then
    --     HalfHeight = MeshOffsetZ
    -- end
	local Start = SpawnPos+ FVector(0,0,HalfHeight)
	local End = SpawnPos + FVector(0,0,-HalfHeight * 2)
	local HitResult = FHitResult()
	local Ret = UE4.UKismetSystemLibrary.LineTraceSingle(self, Start, End, ETraceTypeQuery.TraceScene, true, nil, 0, HitResult, true)
	if(Ret) then
		DebugPrint("BP_TalkObject半高:",HalfHeight,"打中位置：",HitResult.ImpactPoint,"打中目标：",HitResult.Actor:GetName(),"Pawn名字：",self:GetName(),"============sssss================")
		local SurfacePos = FVector(HitResult.ImpactPoint.X,HitResult.ImpactPoint.Y,HitResult.ImpactPoint.Z + HalfHeight)
		self:K2_SetActorLocation(SurfacePos, false, nil, false)
	end
end

return BP_TalkObject
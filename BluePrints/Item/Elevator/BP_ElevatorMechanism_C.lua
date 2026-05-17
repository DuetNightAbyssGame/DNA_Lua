require "UnLua"
local MiscUtils = require "Utils.MiscUtils"

local BP_ElevatorMechanism_C = Class({
    "BluePrints.Item.BP_CombatItemBase_C",
    "BluePrints.Common.TimerMgr"
})

function BP_ElevatorMechanism_C:ReceiveBeginPlay()
    self.Overridden.ReceiveBeginPlay(self)
    self.Super.ReceiveBeginPlay(self)
end

function BP_ElevatorMechanism_C:Init()
end

function BP_ElevatorMechanism_C:AuthorityInitInfo(Info)
    BP_ElevatorMechanism_C.Super.AuthorityInitInfo(self,Info)
    if Info.State then
        self.CurrentElevatorState = self.StateId--区域数据恢复
    end
    local LocalTransform
    if self.CurrentElevatorState == UE4.ElevatorMechanismState.ElevatorTop then
        LocalTransform = UE4.UKismetMathLibrary.MakeTransform(MiscUtils.GetObjectLocation(self.ElevatorInSign) + FVector(0, 0, self.MoveHeight), self:K2_GetActorRotation(), UE4.FVector(1,1,1))
    else
        self.CurrentElevatorState = UE4.ElevatorMechanismState.ElevatorBottom
        LocalTransform = UE4.UKismetMathLibrary.MakeTransform(MiscUtils.GetObjectLocation(self.ElevatorInSign) , self:K2_GetActorRotation(), UE4.FVector(1,1,1))
    end
    local ElevatorInCharacter = self:GetWorld():SpawnActor(self.ElevatorInCharacterClass, LocalTransform)
    -- local ElevatorBottomChildActor = self:GetWorld():SpawnActor(self.ElevatorBottomChildClass)
    -- local ElevatorTopChildActor = self:GetWorld():SpawnActor(self.ElevatorTopChildClass)
    self.ElevatorInCharacter = ElevatorInCharacter
    self.ElevatorInCharacter.StartLocation = MiscUtils.GetObjectLocation(self.ElevatorInSign)
    self.ElevatorInCharacter.TargetLocation = self.ElevatorInCharacter.StartLocation + FVector(0, 0, self.MoveHeight)
    -- ElevatorBottomChildActor:K2_SetActorLocation(self.ElevatorBottomSign.RelativeLocation, false, nil, true)
    -- ElevatorTopChildActor:K2_SetActorLocation(self.ElevatorTopSign.RelativeLocation, false, nil, true)
    -- ElevatorBottomChildActor:K2_AttachToActor(self)
    -- ElevatorTopChildActor:K2_AttachToActor(self)
    -- ElevatorInCharacter.ElevatorInteractiveComponent.DisplayInteractiveName = "Test"--GText(ElevatorBottomChildActor.ElevatorInteractiveComponent.InteractiveName)
    -- ElevatorBottomChildActor.ElevatorInteractiveComponent.DisplayInteractiveName = GText(ElevatorBottomChildActor.ElevatorInteractiveComponent.InteractiveName)
    -- ElevatorTopChildActor.ElevatorInteractiveComponent.DisplayInteractiveName = GText(ElevatorTopChildActor.ElevatorInteractiveComponent.InteractiveName)
    -- self.ElevatorBottomChildActor = ElevatorBottomChildActor
    -- self.ElevatorTopChildActor = ElevatorTopChildActor
    self.ElevatorInCharacter.Eid = self.Eid
    -- self.ElevatorTopChildActor.Eid = self.Eid
    -- self.ElevatorBottomChildActor.Eid = self.Eid
    self.ElevatorInCharacter:SetCharacterFlySpeed(self.Speed)
    -- if self.CurrentElevatorState == UE4.ElevatorMechanismState.ElevatorTop then
    --     self:OpenTopDoor(self.ElevatorTopChildActor)
    -- else
    --     self:OpenBottomDoor(self.ElevatorBottomChildActor)
    -- end

    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local MiniGameList = TArray(0)
    if self.ElevatorTopCreatorId ~= 0 then
        GameState.StaticCreatorMap:Find(self.ElevatorTopCreatorId).SourceEid = self.Eid
        MiniGameList:Add(self.ElevatorTopCreatorId)
    end
    if self.ElevatorBottomCreatorId ~= 0 then
        GameState.StaticCreatorMap:Find(self.ElevatorBottomCreatorId).SourceEid = self.Eid
        MiniGameList:Add(self.ElevatorBottomCreatorId)
    end
    -- if self.ElevatorInCreatorId ~= 0 then
    --     GameState.StaticCreatorMap:Find(self.ElevatorInCreatorId).SourceEid = self.Eid
    --     MiniGameList:Add(self.ElevatorInCreatorId)
    -- end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode:TriggerActiveStaticCreator(MiniGameList)
    EventManager:AddEvent(EventID.OnMiniGameCreated,self,self.OnMiniGameCreated)
end

function BP_ElevatorMechanism_C:ReceiveEndPlay(reason)
    BP_ElevatorMechanism_C.Super.ReceiveEndPlay(self,reason)
    EventManager:RemoveEvent(EventID.OnMiniGameCreated,self)
end

function BP_ElevatorMechanism_C:OnMiniGameCreated(MiniGameActor)
    if not self.ChildrenState then
        self.ChildrenState = {}
    end
    self.ChildrenState[MiniGameActor] = {IsRun = false, IsOpenDoor = false}
    if MiniGameActor.CreatorId == self.ElevatorTopCreatorId then
        self.ElevatorTopChildActor = MiniGameActor
        if self.CurrentElevatorState == UE4.ElevatorMechanismState.ElevatorTop then
            self:OpenTopDoor(self.ElevatorTopChildActor)
        end
    elseif MiniGameActor.CreatorId == self.ElevatorBottomCreatorId then
        self.ElevatorBottomChildActor = MiniGameActor
    -- elseif MiniGameActor.CreatorId == self.ElevatorInCreatorId then
    --     self.ElevatorInChildActor = MiniGameActor
    --     MiniGameActor:K2_AttachToActor(self.ElevatorInCharacter,"",1)
        if self.CurrentElevatorState == ElevatorMechanismState.ElevatorBottom then
            self:OpenBottomDoor(self.ElevatorBottomChildActor)
        end
    end
    -- self:UpdateMiniGameState()
end


function BP_ElevatorMechanism_C:OpenTopDoor(ElevatorTopChildActor)
    self.Overridden.OpenTopDoor(self, ElevatorTopChildActor)
    self.ElevatorInCharacter:OpenDoor(ElevatorTopChildActor)
    self:UpdateRegionData('StateId',self.CurrentElevatorState)
end

function BP_ElevatorMechanism_C:OpenBottomDoor(ElevatorBottomChildActor)
    self.Overridden.OpenBottomDoor(self, ElevatorBottomChildActor)
    self.ElevatorInCharacter:OpenDoor(ElevatorBottomChildActor)
    self:UpdateRegionData('StateId',self.CurrentElevatorState)
end

function BP_ElevatorMechanism_C:OpenMoveSetting(TargetActor)
    if IsValid(TargetActor) then
        if self.ChildrenState[TargetActor].IsRun or self.ChildrenState[TargetActor].IsOpenDoor then
            return false
        end
        self.ChildrenState[TargetActor].IsRun = true
        return true
    end
    return false
end

function BP_ElevatorMechanism_C:CloseMoveSetting(TargetActor)
    if IsValid(TargetActor) then 
        if not self.ChildrenState[TargetActor].IsOpenDoor or self.ChildrenState[TargetActor].IsRun then 
            return false
        end
        self.ChildrenState[TargetActor].IsRun = true
        return true
    end
    return  false
end

function BP_ElevatorMechanism_C:CompleteNotify(TargetActor)
    if (IsValid(TargetActor)) then 
        DebugPrint('CompleteNotify',TargetActor == self.ElevatorBottomChildActor,self.ChildrenState[TargetActor].IsOpenDoor)
        self.ChildrenState[TargetActor].IsOpenDoor = not self.ChildrenState[TargetActor].IsOpenDoor
        self.ChildrenState[TargetActor].IsRun = false
        EventManager:FireEvent(EventID.ElevatorMechanismCompleteNotify,self)
    end
    self:UpdateMiniGameState()
end

function BP_ElevatorMechanism_C:CloseAllDoor()
    if not self.ElevatorBottomChildActor or self.ChildrenState[self.ElevatorBottomChildActor].IsOpenDoor then
        self:CloseBottomDoor(self.ElevatorBottomChildActor)
    end
    if not self.ElevatorTopChildActor or self.ChildrenState[self.ElevatorTopChildActor].IsOpenDoor then
        self:CloseTopDoor(self.ElevatorTopChildActor)
    end
    self.ElevatorInCharacter:CloseDoor(self.ElevatorBottomChildActor)
    self.ElevatorInCharacter:CloseDoor(self.ElevatorTopChildActor)
end

function BP_ElevatorMechanism_C:PlayOpenDoorSound(Component)
    AudioManager(self):PlayFMODSound(Component, nil, "event:/sfx/common/scene/lift_fast_door_open") 
end

function BP_ElevatorMechanism_C:PlayCloseDoorSound(Component)
    AudioManager(self):PlayFMODSound(Component, nil, "event:/sfx/common/scene/lift_fast_door_close") 
end

function BP_ElevatorMechanism_C:RealMoveLua(ElevatorId, SourceEid)
    if IsAuthority(self) then 
        local SelfChildActor = self:GetSelfChildActor(SourceEid)
        local RequiredState = self:GetSelfChildActorState(SourceEid)
        -- if self.IsCircle then--TODO:循环电梯
        --     self:PlayMiddle()
        --     return
        -- end
        if(RequiredState == 1 and  self.CurrentElevatorState ~= 1) then
            self:ElevatorMove(RequiredState)
        else
            if RequiredState == self.CurrentElevatorState and self.CurrentElevatorState ~= 1 then
                if not self.ChildrenState[SelfChildActor].IsOpenDoor then
                    if RequiredState == 0 then
                        self:OpenTopDoor(SelfChildActor)
                    elseif RequiredState == 2 then
                        self:OpenBottomDoor(SelfChildActor)
                    end
                end
            else
                self:ElevatorMove(RequiredState)
            end
        end
    end
end

function BP_ElevatorMechanism_C:GetSelfChildActor(SourceEid)
    if SourceEid == self.ElevatorTopChildActor.Eid then
        return self.ElevatorTopChildActor
    elseif SourceEid == self.ElevatorBottomChildActor.Eid then
        return self.ElevatorBottomChildActor
    elseif SourceEid == self.ElevatorInCharacter.Eid then
        return self.ElevatorInCharacter
    end
    return nil
end

function BP_ElevatorMechanism_C:GetSelfChildActorState(SourceEid)
    if SourceEid == self.ElevatorTopChildActor.Eid then
        return ElevatorMechanismState.ElevatorTop
    elseif SourceEid == self.ElevatorBottomChildActor.Eid then
        return ElevatorMechanismState.ElevatorBottom
    -- elseif SourceEid == self.ElevatorInChildActor.Eid then
    --     return ElevatorMechanismState.ElevatorIn
    end
    return ElevatorMechanismState.ElevatorIn
end

function BP_ElevatorMechanism_C:SetChildActorRunningEffect()--改小游戏机关以后大概要用小游戏机关状态做
    -- if IsValid(self.ElevatorTopChildActor) then
    --     if self.ElevatorTopChildActor.FXLock:IsActive() then
    --         self.ElevatorTopChildActor.FXLock:Deactivate()
    --     end
    --     if not self.ElevatorTopChildActor.FXRunning:IsActive() then
    --         self.ElevatorTopChildActor.FXRunning:Activate(true)
    --     end
    -- end
    -- if IsValid(self.ElevatorBottomChildActor) then
    --     if self.ElevatorBottomChildActor.FXLock:IsActive() then
    --         self.ElevatorBottomChildActor.FXLock:Deactivate()
    --     end
    --     if not self.ElevatorBottomChildActor.FXRunning:IsActive() then
    --         self.ElevatorBottomChildActor.FXRunning:Activate(true)
    --     end
    -- end
    -- if IsValid(self.ElevatorInCharacter) then
    --     if self.ElevatorInCharacter.FXLock:IsActive() then
    --         self.ElevatorInCharacter.FXLock:Deactivate()
    --     end
    --     if not self.ElevatorInCharacter.FXRunning:IsActive() then
    --         self.ElevatorInCharacter.FXRunning:Activate(true)
    --     end
    -- end
end

function BP_ElevatorMechanism_C:SetChildActorLockEffect()
    -- if IsValid(self.ElevatorTopChildActor) then
    --     if self.ElevatorTopChildActor.FXRunning:IsActive() then
    --         self.ElevatorTopChildActor.FXRunning:Deactivate()
    --     end
    --     self.ElevatorTopChildActor.FXLock:Activate(true)
    -- end
    -- if IsValid(self.ElevatorBottomChildActor) then
    --     if self.ElevatorBottomChildActor.FXRunning:IsActive() then
    --         self.ElevatorBottomChildActor.FXRunning:Deactivate()
    --     end
    --     self.ElevatorBottomChildActor.FXLock:Activate(true)
    -- end
    -- if IsValid(self.ElevatorInCharacter) then
    --     if self.ElevatorInCharacter.FXRunning:IsActive() then
    --         self.ElevatorInCharacter.FXRunning:Deactivate()
    --     end
    --     self.ElevatorInCharacter.FXLock:Activate(true)
    -- end
end

function BP_ElevatorMechanism_C:ClientInitInfo(Info)
    if IsStandAlone(self) or IsClient(self) then
        -- self.ElevatorTopChildActor.ElevatorInteractiveComponent.DisplayInteractiveName = GText(self.ElevatorTopChildActor.ElevatorInteractiveComponent.InteractiveName)
        -- self.ElevatorBottomChildActor.ElevatorInteractiveComponent.DisplayInteractiveName = GText( self.ElevatorBottomChildActor.ElevatorInteractiveComponent.InteractiveName)
        -- self.ElevatorInCharacter.ElevatorInteractiveComponent.DisplayInteractiveName = GText(self.ElevatorInCharacter.ElevatorInteractiveComponent.InteractiveName)
    end
end

function BP_ElevatorMechanism_C:OnRep_ElevatorBottomChildActor()
    DebugPrint('crack,....OnRep_ElevatorBottomChildActor')
    if not self.ChildrenState then
        self.ChildrenState = {}
    end
    self.ChildrenState[self.ElevatorBottomChildActor] = {IsRun = false, IsOpenDoor = false}
end

function BP_ElevatorMechanism_C:OnRep_ElevatorTopChildActor()
    DebugPrint('crack,....OnRep_ElevatorTopChildActor')
    if not self.ChildrenState then
        self.ChildrenState = {}
    end
    self.ChildrenState[self.ElevatorTopChildActor] = {IsRun = false, IsOpenDoor = false}
end

-- function BP_ElevatorMechanism_C:OnRep_ElevatorTopChildActor()
--     self.ElevatorTopChildActor.ElevatorInteractiveComponent.DisplayInteractiveName = GText(self.ElevatorTopChildActor.ElevatorInteractiveComponent.InteractiveName)
-- end
-- function BP_ElevatorMechanism_C:OnRep_ElevatorBottomChildActor()
--     self.ElevatorBottomChildActor.ElevatorInteractiveComponent.DisplayInteractiveName = GText( self.ElevatorBottomChildActor.ElevatorInteractiveComponent.InteractiveName)
-- end
function BP_ElevatorMechanism_C:OnRep_ElevatorInCharacter()
    self.ElevatorInCharacter.ElevatorInteractiveComponent.DisplayInteractiveName = GText(self.ElevatorInCharacter.ElevatorInteractiveComponent.InteractiveName)
end

function BP_ElevatorMechanism_C:AddStoryNodeCallback(StateName, Callback)
    if not self.StoryNodeCallback then
        self.StoryNodeCallback = {}
    end

    self.StoryNodeCallback[StateName] = Callback
end

function BP_ElevatorMechanism_C:RemoveStoryNodeCallback(StateName)
    self.StoryNodeCallback[StateName] = nil
end

function BP_ElevatorMechanism_C:GetGuideLocation(IsTargetTop, Target)
    if IsTargetTop then
        if self.CurrentElevatorState == ElevatorMechanismState.ElevatorBottom and not self.ElevatorInCharacter.IsMoveStart then
            if self.ChildrenState[self.ElevatorBottomChildActor].IsOpenDoor then
                return self.ElevatorInCharacter,true
            else
                return self.ElevatorBottomChildActor,true
            end
        end
        return nil,false
    else
        if self.CurrentElevatorState == ElevatorMechanismState.ElevatorTop and not self.ElevatorInCharacter.IsMoveStart then
            if self.ChildrenState[self.ElevatorTopChildActor].IsOpenDoor then
                return self.ElevatorInCharacter,true
            else
                return self.ElevatorTopChildActor,true
            end
        end
        return nil,false
    end
end

function BP_ElevatorMechanism_C:SetLifeTime(LifeTime, Reason)
  
end

function BP_ElevatorMechanism_C:TriggerByChild(SourceEid)
    self:RealMove(self.Eid, SourceEid)
end

function BP_ElevatorMechanism_C:ElevatorMove(ChildState)
    if ChildState == 0 then
        if(self.CurrentElevatorState == 2) then
            self.ElevatorInCharacter:MoveStart()
        end
    elseif ChildState == 1 then
        if(self.CurrentElevatorState == 0) then
            self.ElevatorInCharacter:MoveEnd()
        elseif self.CurrentElevatorState == 2 then
            self.ElevatorInCharacter:MoveStart()
        end
    else
        if(self.CurrentElevatorState == 0) then
            self.ElevatorInCharacter:MoveEnd()
        end
    end
end

function BP_ElevatorMechanism_C:UpdateMiniGameState()
    DebugPrint('crack','UpdateMiniGameState',self.ChildrenState[self.ElevatorTopChildActor],self.ChildrenState[self.ElevatorBottomChildActor])
    if self.ChildrenState[self.ElevatorTopChildActor] then
        DebugPrint('crack','ElevatorTopChildActor,IsOpenDoor',self.ChildrenState[self.ElevatorTopChildActor].IsOpenDoor)
    end
    if self.ChildrenState[self.ElevatorBottomChildActor] then
        DebugPrint('crack','ElevatorBottomChildActor,IsOpenDoor',self.ChildrenState[self.ElevatorBottomChildActor].IsOpenDoor)
    end
    if IsValid(self.ElevatorTopChildActor) and not self.ChildrenState[self.ElevatorTopChildActor].IsOpenDoor
    and IsValid(self.ElevatorBottomChildActor) and not self.ChildrenState[self.ElevatorBottomChildActor].IsOpenDoor then
        return
    end
    local topStateId = self.StateUninteractiveId
    local bottomStateId = self.StateUninteractiveId
    if self.CurrentElevatorState == 0 then
        topStateId = self.StateUninteractiveId
        bottomStateId = self.StateInteractiveId
    elseif self.CurrentElevatorState == 2 then
        bottomStateId = self.StateUninteractiveId
        topStateId = self.StateInteractiveId
    end

    if IsValid(self.ElevatorTopChildActor) and self.ElevatorTopChildActor.StateId ~= topStateId then
        DebugPrint('crack','ChangeState Top',topStateId)
        self.ElevatorTopChildActor:ChangeState("Manual", 0, topStateId)
    end
    if IsValid(self.ElevatorBottomChildActor) and self.ElevatorBottomChildActor.StateId ~= bottomStateId then
        DebugPrint('crack','ChangeState Bottom',bottomStateId)
        self.ElevatorBottomChildActor:ChangeState("Manual", 0, bottomStateId)
    end
    -- if IsValid(self.ElevatorInChildActor) and self.ElevatorInChildActor.StateId ~= self.InStateInteractiveId then
    --     self.ElevatorInChildActor:ChangeState("Manual", 0, self.InStateInteractiveId)
    -- end
end

function BP_ElevatorMechanism_C:CheckChildrenStateOpen()
    if not self.ElevatorTopChildActor and not self.ElevatorBottomChildActor then
        return true
    end
    if self.ElevatorTopChildActor and self.CurrentElevatorState == 2 then
        return self.ElevatorTopChildActor.StateId == self.StateInteractiveId
    end
    if self.ElevatorBottomChildActor and self.CurrentElevatorState == 0 then
        return self.ElevatorBottomChildActor.StateId == self.StateInteractiveId
    end
    return false
end

function BP_ElevatorMechanism_C:CreateRegionData()--电梯没接机关状态，借用下StateId
    self.RegionData = {
        StateId = self.CurrentElevatorState
    }
end

function BP_ElevatorMechanism_C:OnRep_StateId()--区域里借用StateId存数据，联机不需要同步
end

return BP_ElevatorMechanism_C

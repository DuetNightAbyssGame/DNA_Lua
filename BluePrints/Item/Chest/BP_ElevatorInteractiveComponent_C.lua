--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local LuaConst = require("EMLuaConst")
local BP_ElevatorInteractiveComponent_C = Class("BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C")

function BP_ElevatorInteractiveComponent_C:IsCanInteractive(PlayerActor)
    local Owner = self:GetOwner()
    if not Owner then
        return false
    end
    local Eid = -1
    local EMGameState = UE4.UGameplayStatics.GetGameState(self)
    if not EMGameState then
        return false
    end
    local ElevatorMechanismBody = Owner:Cast(UE4.AElevatorMechanismBody)
    if ElevatorMechanismBody then
        Eid = ElevatorMechanismBody.Eid
    end

    local ElevatorInCharacter = Owner:Cast(UE4.AElevatorCharacter)
    if ElevatorInCharacter then
        Eid = ElevatorInCharacter.Eid
        local ElevatorMechanism = Battle(self):GetEntity(Owner.Eid):Cast(UE4.AElevatorMechanism)
        if ElevatorMechanism.CurrentElevatorState == ElevatorMechanismState.ElevatorIn then
            return false
        else
            if not ElevatorMechanism:CheckChildrenStateOpen() then
                return false
            end
        end
    end
    local Elevator = Owner:GetAttachParentActor()
    local OpenState = false
    if Elevator then
        OpenState = Elevator.OpenState
    end
    if Eid == -1 then
        return false
    end
    if LuaConst.OpenComputeInteractive then
        return self:GetDistanceCheckResult() and
        self.CFaceToACheckComponent(self, PlayerActor, self.InteractiveFaceAngle) and
        self.AFaceToCCheckComponent(PlayerActor, self, self.InteractiveAngle) and
        not OpenState and not self:InteractiveStateCheck()
    else
        return self.DistanceCheckComponent(self, PlayerActor, self.InteractiveDistance) and
        self.CFaceToACheckComponent(self, PlayerActor, self.InteractiveFaceAngle) and
        self.AFaceToCCheckComponent(PlayerActor, self, self.InteractiveAngle) and
        not OpenState and not self:InteractiveStateCheck()
    end
end

function BP_ElevatorInteractiveComponent_C:StartInteractive(PlayerActor)
    if self:IsCanInteractive(PlayerActor) then
        self:InteractiveImplement(PlayerActor.Eid)
    end
end

function BP_ElevatorInteractiveComponent_C:EndInteractive(PlayerActor)
end

function BP_ElevatorInteractiveComponent_C:InteractiveStateCheck()
    local Owner = self:GetOwner()
    local ElevatorMechanism = Battle(Owner):GetEntity(Owner.Eid) --:Cast(UE4.AElevatorMechanism)
    if ElevatorMechanism == nil then
        return false
    end
    if ElevatorMechanism.IsCircle then
        return false
    end
    local TypeCheck = true
    if Owner.SelfElevatorState ~= ElevatorMechanismState.ElevatorIn then
        if not Owner.IsRun and not Owner.IsOpenDoor then
            TypeCheck = false
        end
    else
        if not Owner.IsMoveEnd and not Owner.IsMoveStart and 
        (not ElevatorMechanism.ElevatorBottomChildActor or not ElevatorMechanism.ElevatorBottomChildActor.IsRun) 
        and (not ElevatorMechanism.ElevatorTopChildActor or not ElevatorMechanism.ElevatorTopChildActor.IsRun) then
            TypeCheck = false
        end
    end
    return ElevatorMechanism.CurrentElevatorState == ElevatorMechanismState.ElevatorIn or TypeCheck
end

function BP_ElevatorInteractiveComponent_C:GetElevatorInnerState()
    local SelfActor = self:GetOwner()
    local SelfParentActor = Battle(self):GetEntity(SelfActor.Eid)
    local InnerElevator = SelfParentActor.ElevatorInCharacter
    if IsValid(InnerElevator) then
        return InnerElevator.ChildActor.SelfElevatorState
    end
    return nil
end

function BP_ElevatorInteractiveComponent_C:OpenDoor()
    local SelfActor = self:GetOwner()
    local SelfParentActor = Battle(self):GetEntity(SelfActor.Eid)
    if SelfActor.SelfElevatorState == 0 then 
        SelfParentActor:OpenTopDoor()
    elseif SelfActor.SelfElevatorState == 2 then 
        SelfParentActor:OpenBottomDoor()
    end
end

--该PlayStartFromEnd, PlayEndFromStart OpenTopDoor OpenBottomDoor 在蓝图实现
function BP_ElevatorInteractiveComponent_C:ElevatorMove()
    local SelfActor = self:GetOwner()
    local SelfParentActor = Battle(self):GetEntity(SelfActor.Eid)
    if SelfActor.SelfElevatorState == 0 then
        if(SelfParentActor.CurrentElevatorState == 2) then
            SelfParentActor.ElevatorInCharacter:MoveStart()
        end
    elseif SelfActor.SelfElevatorState == 1 then
        if(SelfParentActor.CurrentElevatorState == 0) then
            SelfActor:MoveEnd()
        elseif SelfParentActor.CurrentElevatorState == 2 then
            SelfActor:MoveStart()
        end
    else
        if(SelfParentActor.CurrentElevatorState == 0) then
            SelfParentActor.ElevatorInCharacter:MoveEnd()
        end
    end
end

function BP_ElevatorInteractiveComponent_C:InteractiveImplement(PlayerId)
    local SelfActor = self:GetOwner()
    local SelfParentActor = Battle(self):GetEntity(SelfActor.Eid)
    SelfActor.OpenState = true
    self:PlayInteractiveEffects() ---------- 交互特效只在客户端播放
    SelfParentActor:MoveElevator(PlayerId, SelfParentActor.Eid, SelfActor.SelfElevatorState)
end

function BP_ElevatorInteractiveComponent_C:InteractiveSuccess()
    local SelfActor = self:GetOwner()
    local SelfParentActor = Battle(self):GetEntity(SelfActor.Eid)
    if SelfParentActor.IsCircle then
        SelfParentActor:PlayMiddle()
        return
    end
    if(SelfActor.SelfElevatorState == 1 and  SelfParentActor.CurrentElevatorState ~= 1) then
        self:ElevatorMove()
    else
        if SelfActor.SelfElevatorState == SelfParentActor.CurrentElevatorState and SelfParentActor.CurrentElevatorState ~= 1 then
            if not SelfActor.IsOpenDoor then
                if SelfActor.SelfElevatorState == 0 then
                    SelfParentActor:OpenTopDoor(SelfActor)
                elseif SelfActor.SelfElevatorState == 2 then
                    SelfParentActor:OpenBottomDoor(SelfActor)
                end
            end
        else
            self:ElevatorMove()
        end
    end
end

function BP_ElevatorInteractiveComponent_C:PlayInteractiveEffects()
    local SelfActor = self:GetOwner()
    local SelfParentActor = Battle(self):GetEntity(SelfActor.Eid)
    if SelfParentActor.IsCircle then
        SelfParentActor:PlayInteractiveEffects()
        return
    end
    -- if SelfActor.SelfElevatorState == ElevatorMechanismState.ElevatorIn then
    --     if SelfActor.PlayEffect then
    --         SelfActor:PlayEffect()
    --     end
    -- else
    --     SelfActor.FXStartInteractive:Activate(true)
    -- end
end


function BP_ElevatorInteractiveComponent_C:BtnClicked(PlayerActor,InPressTimeSeconds)
    self:StartInteractive(PlayerActor)
end
function BP_ElevatorInteractiveComponent_C:BtnPressed(PlayerActor)

end
function BP_ElevatorInteractiveComponent_C:BtnReleased(PlayerActor,InPressTimeSeconds)

end
return BP_ElevatorInteractiveComponent_C

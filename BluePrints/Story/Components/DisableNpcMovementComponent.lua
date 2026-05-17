---@class FDisableNpcMovementComponent
local FDisableNpcMovementComponent = {}

---@return FDisableNpcMovementComponent
function FDisableNpcMovementComponent:New(TalkTask, TalkContext)
	local DisableCharacterDitherComponent = setmetatable({}, {
		__index = FDisableNpcMovementComponent
	})
	DisableCharacterDitherComponent.TalkTask = TalkTask
    DisableCharacterDitherComponent.TalkContext = TalkContext
	return DisableCharacterDitherComponent 
end

function FDisableNpcMovementComponent:Execute()
	DebugPrint("FDisableNpcMovementComponent:Execute")
	self.ResumeNpcMovement = {}
    local TalkTask = self.TalkTask
    local TalkContext = self.TalkContext
    for _, NpcData in pairs(TalkTask.TalkTaskData.TalkActors) do
        local UnitId = NpcData.TalkActorId
        local TalkActorData = TalkContext:GetTalkActorData(TalkTask, UnitId)
        local TalkActor = TalkActorData and TalkActorData.TalkActor
        if TalkActor and TalkActor.SetNpcMovementTickEnable then
            self.ResumeNpcMovement[TalkActor] = TalkActor.bNpcMovementTickEnable
            TalkActor:SetNpcMovementTickEnable(false)
            if TalkActor:GetMovementComponent() then
               TalkActor:GetMovementComponent().Velocity = FVector(0, 0, 0)
            end
            
        end
    end
end

function FDisableNpcMovementComponent:Resume()
	DebugPrint("FDisableNpcMovementComponent:Resume")
    for NpcActor, bEnable in pairs(self.ResumeNpcMovement) do
        if IsValid(NpcActor) then
            NpcActor:SetNpcMovementTickEnable(bEnable)
        end
    end
end

return FDisableNpcMovementComponent
